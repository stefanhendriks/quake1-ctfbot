/* loadmod.qc */

/**

LoadMod by Charles "Myrkul" Kendrick (myrkul@myrkul.org)

Some small modifications for ctfbot+ by *this(adistler@ace.cs.ohiou.edu)

LoadMod is a system for dynamically changing the entities in a level on the first few
game tics after level load.  It was primarily desgined for placing additional armor 
and health in levels in order to facilitate game balance, but the system is highly
flexible and extensible, and there are numerous other purposes that LoadMod can be
used for (and is used for).

If a level has too few armors, LoadMod can place a new set of armor in the level, on
top of the item that is furthest away from all the other armors on the level.  As an
example, if one armor is added to dm3, it will be placed in the SNG room on top of a
box of shells on the walkway.

For programmers:

LoadMod() is called on the first game tic from StartFrame() in world.qc.  The function
LoadMod() itself doesn't do everything, rather it sets up for it to be done over the
next few seconds.  This is necessary because LoadMod has to go through the entire 
entity list many times in order to get its work done, and if you try to do that in 
one tic, the Quake engine will spuriously detect a runaway loop because your function
takes too long to return.

To get around this problem, LoadMod spawns new entities whose only purpose is to sit
and call .think() functions, accomplishing a bit of the massive task of LoadMod every
game tic.  LoadMod usually completes in about 5 seconds.  If you are in the game after
a level change and are quick, you may be able to see an item dynamically added to the
level.

One nifty hack that I should probably explain separately: in order to get some
object-oriented functionality out of QuakeC, I assign functions to the .touch() field
of entities, and then pass those entities around essentially as "function pointers",
allowing a given routine to, for instance, call an arbitrary function on all entities
on the level, with no idea what that function will do.  The simplest example of this
is LMWalkAll() (below).

Passing function pointers around is one way in which LoadMod is very re-usable.  For
instance, it's very easy to swap in your own functions for optimal entity placement.

Some example uses of LoadMod:

1. Adding cells and the lightning gun to e1m* maps.
2. Placing a new type of weapon and its ammo evenly throughout a level that wouldn't
otherwise have it.
3. Placing any new game object evenly throughout a level, for instance, placing "flags"
for an alternate CTF mode in which flags are scattered around the map and each team must
gather as many flags as possible.
4. Adding camera entities above critical game items.
5. Removing DM spawn spots near CTF bases. [this one is actually implemented below]
6. Completely re-doing item placement for a level.

**/

/** Defs **/

// TEMP

.entity searchPos;
.float quotagap;
.float bestdistance;
.float status;
.entity spawnInfo;
.entity avoider;
.entity bestentity;

// whether an entity is essentially "gone" with respect to loadmod
.float voided;
// holds the result of a LoadMod touch function
.float funcResult;
.string stringResult;

// settings

// set "serverinfo loadmod" to a number which is the sum of the options you want to
// enable from the list below.  For example:
// serverinfo loadmod 9
// Would cause pentagrams to be removed from the level, and quotas for items to be
// fulfilled.


//TONY
//we'll be using just the health and armor adding routines
//
//float LM_QUOTA_ADD =			1;	// add health and armor where necessary to fulfill quotas
//float LM_QUOTA_REMOVE =			2;	// remove health and armor where necessary to trim to quotas [NOT IMPLEMENTED]
//float LM_REDO_ITEMS = 			4;	// redo the placement of all items on the level [NOT IMPLEMENTED]
//float LM_REMOVE_PENTAGRAM = 		8;	// remove all pentagrams of protection
//float LM_REMOVE_RING =			16;	// remove all rings of invisibility
//float LM_REMOVE_QUAD =			32;	// remove all quad damage powerups
//float LM_REMOVE_BASE_SPAWNS =		64;	// remove deathmatch spawns near CTF flags

// internal defs

float FIND_NEAREST =		1;
float FIND_FURTHEST =		2;

float DO_ADD =			4;
float DO_VOID =			8;

/** MODIFIABLE CONSTANTS **/

// LM Quota Constants
// Quotas for the amounts of various items in levels.  LoadMod
// will add or remove items from the level (according to what
// options are set) in order to make the actual items in the level
// match the quotas. These are per player constants, ie, 0.4 armor
// means 4 total armors in a 10 player game.

float LMQUOTA_ARMOR =		0.4;
float LMQUOTA_HEALTH =		40;

// [BELOW NOT IMPLEMENTED]
//TONY
//float LMQUOTA_SHELLS =		10;
//float LMQUOTA_SPIKES =		30;
//float LMQUOTA_ROCKETS =		3; 
//float LMQUOTA_CELLS =		20;
//float LMQUOTA_WEAPONS =		0.8;

/** Globals **/

//TONY
//This might work in QW, but not in Quake.
//float loadmodCalled = 0; // whether loadmod has been called yet
float loadmodCalled; // whether loadmod has been called yet

float numPlayers; 	// number of players in the game

float loadmod;		// bitvector for controlling behavior of loading modifications
				// set with serverinfo, see bits defined below.

float itemtype;		// the current itemtype that actions are being performed for
float action;		// the current action to perform: init, switching item types,
				// placing new items, cleanup.

//--------------------------//
// IDENTIFICATION FUNCTIONS //
//--------------------------//

/*
================
LMIsAmmoHealth

Reports true if an entity is an ammo or health box
================
*/
float(string className) LMIsAmmoHealth =
{

	if ((className == "item_shells") ||
		(className == "item_spikes") ||
		(className == "item_rockets") ||
		(className == "item_cells") ||
		(className == "item_health"))
		return 1;
	return 0;
};

/*
================
LMIsWeaponArmor

Reports true if an entity is a weapon or armor
================
*/
float(string className) LMIsWeaponArmor =
{

	if ((className == "weapon_supershotgun") ||
		(className == "weapon_nailgun") ||
		(className == "weapon_supernailgun") ||
		(className == "weapon_grenadelauncher") ||
		(className == "weapon_rocketlauncher") ||
		(className == "weapon_lightning") ||
		(className == "item_armor1") ||
		(className == "item_armor2") ||
		(className == "item_armorInv")) 
		return 1;
	return 0;
};

/*
================
LMIsItem

Reports true if an entity is an "item" entity as opposed
to some non-item entity, such as an ambient sound or missile.
================
*/
float(string className) LMIsItem =
{

	if ((className == "item_shells") ||
		(className == "item_spikes") ||
		(className == "item_rockets") ||
		(className == "item_cells") ||
		(className == "item_health") ||
		(className == "weapon_supershotgun") ||
		(className == "weapon_nailgun") ||
		(className == "weapon_supernailgun") ||
		(className == "weapon_grenadelauncher") ||
		(className == "weapon_rocketlauncher") ||
		(className == "weapon_lightning") ||
		(className == "item_armor1") ||
		(className == "item_armor2") ||
		(className == "item_armorInv")) 
		return 1;
	return 0;
};

/*
================
ItemOffset

Reports the offset required to place an item of "placingClass" on
exactly on top of an item of class "onClass".
================
*/
vector(string placingClass, string onClass) ItemOffset =
{
	local float spawningWeapon, spawningHealth, onWeapon, onHealth;

	spawningWeapon = LMIsWeaponArmor(placingClass);
	spawningHealth = LMIsAmmoHealth(placingClass);
	onWeapon = LMIsWeaponArmor(onClass);
	onHealth = LMIsAmmoHealth(onClass);

	if (spawningWeapon && onHealth) {
		// spawning a weapon or armor on top of ammo or health
		return '16 16 0';
	} else if (spawningHealth && onWeapon) {
		// spawning an ammo or health on top of a weapon or armor
		return '-16 -16 0';
	} else {
		return '0 0 0';
	}

};

//-------------------------//
// SPAWN CONTROL FUNCTIONS //
//-------------------------//

/*
================
LMWalkAll

LMWalkAll walks the list of all entities and calls the touch
function of the entity argument, with "self" set to the entity
holding the touch function and other set to the current entity
in the list.

Example usage: pass in an entity with a touch function that with
do a sum of all rocket ammo in the level, by storing the sum in
a field in the entity.
================
*/
void(entity funcHolder) LMWalkAll =
{
	local entity p;

	p = nextent(world);
	while (p != world) {
		self = funcHolder;
		other = p;
		funcHolder.touch();
		p = nextent(p);
	}
};

/*
================
LMWalkClass
 
LMWalkAll walks the list of all entities of the class "className"
and calls the touch function of the entity argument, with "self" set
to the entity holding the touch function and other set to the current
entity in the list.
================
*/
void(string className, entity funcHolder) LMWalkClass =
{
	local entity p;

	p = find(world, classname, className);
	while (p != world) {
		self = funcHolder;
		other = p;
		funcHolder.touch();
		p = find(p, classname, className);
	}
};

/*
================
LMSetVoided

LMSetVoided sets the "voided" field of all entities of the classes
given as arguments.  If className is to "null", all entities will
be set.  Entities marked as "voided" will be replaced or removed.
================
*/
void(float voidValue, string className, string className2,
			string className3) LMSetVoided =
{
	local entity p;

	p = nextent(world);
	while (p != world)
	{
		if ((className == "null") ||
			(p.classname == className) ||
			(p.classname == className2) ||
			(p.classname == className3))
		{
			p.voided = voidValue;
		}
		p = nextent(p);
	}
};

/*
================
LMReleaseVoided

LMReleaseVoided removes all voided entities from the entity list.
================
*/
void() LMReleaseVoided =
{
	local entity p;

	p = nextent(world);
	while (p != world) {
		if (p.voided) {
			remove(p);
		}
		p = nextent(p);
	}
};

//--------------------//
// SPAWNING FUNCTIONS //
//--------------------//

/*
================
LMDoSpawn

Call the correct spawn function for "spawnClass".  Basically a big switch
statement, that I wish id had written as part of the spawn() built-in
================
*/
void(entity spawnEnt, string spawnClass) LMDoSpawn =
{

	local entity holder;

	spawnEnt.classname = spawnClass;

	// store the value of "self" and set it for calling the spawn function
	holder = self;
	self = spawnEnt;

	if (spawnClass == "item_armor1") {
		item_armor1();
	} else if (spawnClass == "item_armor2") {
		item_armor2();
	} else if (spawnClass == "item_armorInv") {
//TONY
//no red armor
//		item_armorInv();
		item_armor1();
//		spawnClass = "item_armor1";
		spawnEnt.classname = "item_armor1";
	} else if (spawnClass == "item_health") {
		item_health();
	} else if (spawnClass == "weapon_supershotgun") {
		weapon_supershotgun();
	} else if (spawnClass == "weapon_nailgun") {
		weapon_nailgun();
	} else if (spawnClass == "weapon_supernailgun") {
		weapon_supernailgun();
	} else if (spawnClass == "weapon_grenadelauncher") {
		weapon_grenadelauncher();
	} else if (spawnClass == "weapon_rocketlauncher") {
		weapon_rocketlauncher();
	} else if (spawnClass == "weapon_lightning") {
		weapon_lightning();
	} else if (spawnClass == "item_shells") {
		item_shells();
	} else if (spawnClass == "item_spikes") {
		item_spikes();
	} else if (spawnClass == "item_rockets") {
		item_rockets();
	} else if (spawnClass == "item_cells") {
		item_cells();
	}

	// reset self
	self = holder;

};

// Spawn Cycling functions
// Set as touch functions for entities passed to item placement,
// routines these functions return in "stringResult" a classname
// to be spawned and in "funcResult" the amount that spawning an
// item of that class will reduce the quota.

/*
================
LMTArmorSpawn

Touch function passed in for cycling through armors for spawning.
================
*/
void() LMTArmorSpawn =
{
	if (self.status == 0) {
		self.stringResult = "item_armorInv";
		self.funcResult = 1;
		self.status = 1;
	} else if (self.status == 1) {
		self.stringResult = "item_armor2";
		self.funcResult = 1;
		self.status = 2;
	} else if (self.status == 2) {
		self.stringResult = "item_armor1";
		self.funcResult = 1;
		self.status = 0;
	}
};

/*
================
LMTHealthSpawn

Touch function passed in for cycling through healths for spawning.
================
*/
void() LMTHealthSpawn =
{
	self.stringResult = "item_health";
	self.funcResult = 25;
};

//--------------------//
// COUNTING FUNCTIONS //
//--------------------//

/*
================
LMClassCount

Return the number of entities in the game of a certain class,
eg, "item_armor1".
================
*/
float(string class) LMClassCount =
{
	local entity p;
	local float result;

	result = 0;

	if (class != "null") {
		p = find (world, classname, class);
		while(p != world)
		{
			if (!p.voided) {
				result = result + 1;
			}
			p = find(p, classname, class);
		}
	}
	return result;
};

/*
================
LMClassCountMulti

Return the number of entities in the game of class
"class", "class2" or "class3"
================
*/
float(string class, string class2, string class3) LMClassCountMulti =
{
	local float result;

	if (class != "null") {
		result = LMClassCount(class);
	}

	if (class2 != "null") {
		result = result + LMClassCount(class2);
	}

	if (class3 != "null") {
		result = result + LMClassCount(class3);
	}
	return result;
};

//--------------------//
// CRITERIA FUNCTIONS //
//--------------------//

/*
================
LMDistanceToNearestAvoid

Walks the entire entity list, finding the closest entity
to "position" that "avoidID.touch()" identifies as being important.

"avoidID" is an entity whose .touch() function will set 
self.funcResult to TRUE (1) if "self" is a entity that
should be considered an entity to avoid (and thus calculate
nearness to).
================
*/
float(vector position, entity avoidID) LMDistanceToNearestAvoid =
{
	local float entDistance, nearestDistance;
	local entity near, holder;

	nearestDistance = 60000;

	near = nextent(world);
	while(near != world)
	{
		holder = self;
		// HACK BLUDGEON MAIM
		// set "self" to the current entity in the list
		// walk, and call avoidID's touch function, 
		// effectively on "near"
		self = near;
		avoidID.touch();

		self = holder;

		// NOTE: avoidID's touch function actually set a
		// field in "near", since the global "self" was set
		// to "near" when avoidID.touch was called.
		if (near.funcResult) {
			entDistance = vlen(position - near.origin);
			if ((entDistance < nearestDistance) && !near.voided)
				nearestDistance = entDistance;
		}
		near = nextent(near);
	}

	return nearestDistance;

};

//----------------------------------//
// TOUCH FUNCTIONS FOR LIST WALKING //
//----------------------------------//

/*
================
LMTHealthAmount
================
*/
void() LMTHealthAmount =
{
	local string s;

	if (other.spawnflags & H_ROTTEN) {
		self.funcResult = self.funcResult + 15;
	} else if (other.spawnflags & H_MEGA) {
		// don't count mega healths as part of normal
		// restoration health.  It's considered a powerup.
		return;
	} else {
		self.funcResult = self.funcResult + 25;
	}
};

/*
================
LMTAmmoAmount
================
*/
void() LMTAmmoAmount =
{
	self.funcResult = self.funcResult + other.aflag;
};


/*
==================================
LMTRemoveSpawns

Remove all deathmatch spawn spots that are
within a certain radius of CTF flags
==================================
*/
void() LMTRemoveSpawns =
{
	local entity list, temp;

	list = findradius(other.origin, 400);
	while (list != world) {
		if ((list.classname == "item_flag_team1") ||
			(list.classname == "item_flag_team2")) {
			remove(other);
			return;
		} else {
			list = list.chain;
		}
	}

};

//-------------------------------------//
// THINK FUNCTIONS FOR PLACER ENTITIES //
//-------------------------------------//

/*
================
LMAny_Avoid

Items to avoid when placing any item - powerups and megahealths.
"self" must be set to the item to be checked.
================
*/
float() LMAny_Avoid =
{
	if (self.classname == "item_artifact_invulnerability" ||
		self.classname == "item_artifact_super_damage" ||
		self.classname == "item_artifact_invisibility" ||
		(self.classname == "item_health" && self.spawnflags & H_MEGA))
		return 1;
	return 0;
};

/*
================
LMTHealth_Avoid

Function that identifies items to be avoided when
placing health packs.
================
*/
void() LMTHealth_Avoid =
{
	if (self.classname == "item_health" ||
		LMAny_Avoid()) 
	{
		self.funcResult = 1;
		return;
	}
	self.funcResult = 0;
	return;
};

/*
================
LMTArmor_Avoid

Function that identifies items to be avoided when
placing armors.
================
*/
void() LMTArmor_Avoid =
{
	if (self.classname == "item_armor1" ||
		self.classname == "item_armor2" ||
		self.classname == "item_armorInv" ||
		LMAny_Avoid()) 
	{
		self.funcResult = 1;
		return;
	}
	self.funcResult = 0;
	return;
};

void() LMThink_Control;

/*
================
LMThink_Spawn
================
*/
void() LMThink_Spawn =
{
	local string spawnClass;	
	local entity holder, spawnEnt;
	local vector position;

	// determine the kind of item to spawn
	holder = self;
	self = self.spawnInfo;
	self.touch();
	self = holder;

	spawnClass = self.spawnInfo.stringResult;
	self.quotagap = self.quotagap - self.spawnInfo.funcResult;

	// origin adjustment to prevent items falling out of level.
	position = self.bestentity.origin + ItemOffset(spawnClass, self.bestentity.classname);

	if (self.bestentity.voided) {
		// overwrite (become) the entity with the best position
		spawnEnt = self.bestentity;
		spawnEnt.voided = 0;
		setorigin(spawnEnt, position);
	} else {
		// create a new entity directly on top of 
		// the entity with the best position
		spawnEnt = spawn();
		setorigin(spawnEnt, position);
	}

	LMDoSpawn(spawnEnt, spawnClass);

/*
	dprint("\nSpawning an item of class ");
	dprint(spawnClass);
	if (self.bestentity.voided) {
		dprint(" in place of an ");
	} else {
		dprint(" on top of an ");
	}
	dprint(self.bestentity.classname);
	dprint("\nLocation is ");
	s = vtos(self.bestentity.origin);
	dprint(s);
	dprint(", nearest similar entity is ");
	s = ftos(self.bestdistance);
	dprint(s);
	dprint(" away\n\n");
*/

	self.nextthink = time + 0.01;
	self.think = LMThink_Control;

};

/*
================
LMThink_Place
================
*/
void() LMThink_Place =
{
	local entity p, identifier;
	local string s;
	local float thisDistance;	

	self.searchPos = nextent(self.searchPos);
	p = self.searchPos;

	if (p != world) {

		// look at all entities of these types, in order to use
		// thier spawn positions for the item being spawned
		if (LMIsItem(p.classname))
		{
			thisDistance = LMDistanceToNearestAvoid(p.origin, self.avoider);

			// find the entity furthest from the nearclasses, but
			// prefer voided entities 100% over non-voided
			if ((thisDistance > self.bestdistance) &&
				!(self.bestentity.voided && !p.voided))
			{
				self.bestdistance = thisDistance;
				self.bestentity = p;
			}
		}	
	} else {
		self.think = LMThink_Spawn;
	}
	self.nextthink = time + 0.01;

};

/*
================
LMThink_Control
================
*/
void() LMThink_Control =
{
	if (self.quotagap > 0) {
		self.nextthink = time + 0.01;
		self.think = LMThink_Place;
		self.bestdistance = 0;
		self.searchPos = world;
	} else {
		remove(self.avoider);
		remove(self.spawnInfo);
		remove(self);
	}
};

/*
================
LMThink_Armor
================
*/
void() LMThink_Armor =
{
	local string s;
	local entity funcHolder, placer;

	// set up the spawning function for armors
	placer = spawn();
	placer.classname = "placer";

	// determine if quota for armors is met
	placer.quotagap = (LMQUOTA_ARMOR * numPlayers) -
			LMClassCountMulti("item_armor1", "item_armor2", "item_armorInv");
	placer.quotagap = rint(placer.quotagap);

	// identifier function entity - this is what causes this
	// placer to avoid other armors (and other items) when placing
	placer.avoider = spawn();
	placer.avoider.classname = "info_avoid_armor";
	placer.avoider.touch = LMTArmor_Avoid;

	// spawner function entity - this is what causes this
	// placer to place armors (in a cycle)
	placer.spawnInfo = spawn();
	placer.spawnInfo.classname = "info_spawn_armor";
	placer.spawnInfo.touch = LMTArmorSpawn;

	// start placing
	placer.think = LMThink_Control;
	placer.nextthink = time + 0.01;

	remove(self);

};

/*
================
LMThink_Health
================
*/
void() LMThink_Health =
{
	local string s;
	local entity funcHolder, placer;

	// determine if the quota for health is met
	// create an entity to hold the summing function
	funcHolder = spawn();
	funcHolder.touch = LMTHealthAmount;
	LMWalkClass("item_health", funcHolder);

	// set up the spawning function for health
	placer = spawn();
	placer.classname = "placer";
	placer.quotagap = (LMQUOTA_HEALTH * numPlayers) - funcHolder.funcResult;
	placer.quotagap = rint(placer.quotagap);
	remove(funcHolder);

	// identifier function entity - this is what causes this
	// placer to avoid other armors (and other items) when placing
	placer.avoider = spawn();
	placer.avoider.classname = "info_avoid_health";
	placer.avoider.touch = LMTHealth_Avoid;

	// spawner function entity - this is what causes this
	// placer to place armors (in a cycle)
	placer.spawnInfo = spawn();
	placer.spawnInfo.classname = "info_spawn_health";
	placer.spawnInfo.touch = LMTHealthSpawn;

	// start placing
	placer.think = LMThink_Control;
	placer.nextthink = time + 0.01;

	remove(self);
};

/*
================
LoadMod

An ambitious function :) Goes through the list of entities in the map and
modifies it to produce a more balanced game with less shortages.  There are
a set of quotas for each set of items of a kind, for instance armor.

When items need to be added according to quotas, the added items will be
added at the item-entity position furthest from all other items of the same 
type as the item being added.
================
*/
void() LoadMod =
{

//bprint("LoadMod\n");

	local string s;
	local entity funcHolder, placer;

	// flag to ensure a single call
	loadmodCalled = 1;

//TONY
//
//	// grab the bitvector for controlling loading modifications
//	s = infokey(world, "loadmod");
//	loadmod = stof(s);
//	if (loadmod > 0) {


//TONY
//
//		// determine number of clients
//		s = infokey(world, "maxclients");
//		numPlayers = stof(s);
//TONY
//USE fMaxClients from rankings.qc.
//Since more than 16 bots can be added, this isn't a really good way,
//but I'm much too lazy to do it otherwise
//
		numPlayers = fMaxClients;

		// if REDO_ITEMS is set, mark all items in the map as "voided",
		// so they will be replaced by items created to fulfill quotas
	//	if (loadmod & LM_REDO_ITEMS) {
	//		LMSetVoided(1, "null", "null", "null");
	//	} else {
	//		LMSetVoided(0, "null", "null", "null");
	//	}

		// set all entities as not voided
		LMSetVoided(0, "null", "null", "null");

//TONY
//
//		// remove powerups if option set
//		if (loadmod & LM_REMOVE_PENTAGRAM)
//			LMSetVoided(1, "item_artifact_invulnerability", "null", "null");
//		if (loadmod & LM_REMOVE_RING)
//			LMSetVoided(1, "item_artifact_invisibility", "null", "null");
//		if (loadmod & LM_REMOVE_QUAD)
//			LMSetVoided(1, "item_artifact_super_damage", "null", "null");


//TONY
//
//		// remove deathmatch spawns near CTF bases
//		if (loadmod & LM_REMOVE_BASE_SPAWNS) {
//			funcHolder = spawn();
//			funcHolder.touch = LMTRemoveSpawns;
//		
//			LMWalkClass("info_player_deathmatch", funcHolder);
//
//			remove(funcHolder);
//		}

		// release all entities that are voided
//		LMReleaseVoided();

//TONY
//
//		if (loadmod & LM_QUOTA_ADD) {

			// create entities to place additional items
			funcHolder = spawn();
			funcHolder.classname = "armorSpawner";
			funcHolder.think = LMThink_Armor;
			funcHolder.nextthink = time + 0.01;
	
			funcHolder = spawn();
			funcHolder.classname = "healthSpawner";
			funcHolder.think = LMThink_Health;
			funcHolder.nextthink = time + 0.01;
//		}
//	}

};