void() W_SetCurrentAmmo;
/* ALL LIGHTS SHOULD BE 0 1 0 IN COLOR ALL OTHER ITEMS SHOULD
BE .8 .3 .4 IN COLOR */


void() SUB_regen =
{
	self.model = self.mdl;          // restore original model
	self.solid = SOLID_TRIGGER;     // allow it to be touched again
	sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);    // play respawn sound
	setorigin (self, self.origin);
};



/*QUAKED noclass (0 0 0) (-8 -8 -8) (8 8 8)
prints a warning message when spawned
*/
void() noclass =
{
	dprint ("noclass spawned at");
	dprint (vtos(self.origin));
	dprint ("\n");
	remove (self);
};

//QW DROP RING AND QUAD

void() q_touch;

void() q_touch =
{
local entity    stemp;
local float     best;
local string    s;

	if (other.classname != "player" && other.classname != "bot")    // CTFBOT
		return;
	if (other.health <= 0)
		return;

	self.mdl = self.model;

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	self.solid = SOLID_NOT;
	other.items = other.items | IT_QUAD;
	self.model = string_null;
		if (deathmatch == 4)
		{
			other.armortype = 0;
			other.armorvalue = 0 * 0.01;
			other.ammo_cells = 0;
		}

// do the apropriate action
	other.super_time = 1;
	other.super_damage_finished = self.cnt;

	s=ftos(rint(other.super_damage_finished - time));

//TONY
//TEMP1_NOMESS
	if(!(temp1 & TEMP1_NOMESS))
	{
		bprint (other.netname);
		bprint (" recovered a Quad with ");
		bprint (s);
		bprint (" seconds remaining!\n");
	}

	activator = other;
	SUB_UseTargets();                               // fire all targets / killtargets
};


void(float timeleft) DropQuad =
{
	local entity    item;

	item = spawn();
	item.origin = self.origin;
	
	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	item.noise = "items/damage.wav";
	setmodel (item, "progs/quaddama.mdl");
	setsize (item, '-16 -16 -24', '16 16 32');
	item.cnt = time + timeleft;
	item.touch = q_touch;
	item.nextthink = time + timeleft;    // remove it with the time left on it
	item.think = SUB_Remove;
};


void() r_touch;

void() r_touch =
{
local entity    stemp;
local float     best;
local string    s;

	if (other.classname != "player" && other.classname != "bot")    // CTFBOT
		return;
	if (other.health <= 0)
		return;

	self.mdl = self.model;

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	self.solid = SOLID_NOT;
	other.items = other.items | IT_INVISIBILITY;
	self.model = string_null;

// do the apropriate action
	other.invisible_time = 1;
	other.invisible_finished = self.cnt;
	s=ftos(rint(other.invisible_finished - time));

//TONY
//TEMP1_NOMESS
	if(!(temp1 & TEMP1_NOMESS))
	{
		bprint (other.netname);
		bprint (" recovered a Ring with ");
		bprint (s);
		bprint (" seconds remaining!\n");
	}      

	activator = other;
	SUB_UseTargets();                               // fire all targets / killtargets
};


void(float timeleft) DropRing =
{
	local entity    item;

	item = spawn();
	item.origin = self.origin;
	
	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	item.noise = "items/inv1.wav";
	setmodel (item, "progs/invisibl.mdl");
	setsize (item, '-16 -16 -24', '16 16 32');
	item.cnt = time + timeleft;
	item.touch = r_touch;
	item.nextthink = time + timeleft;    // remove after 30 seconds
	item.think = SUB_Remove;
};

//QW DROP RING AND QUAD

/*
============
PlaceItem

plants the object on the floor
============
*/
void() PlaceItem =
{
	local float     oldz;

	self.mdl = self.model;          // so it can be restored on respawn
	self.flags = FL_ITEM;           // make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;  
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	oldz = self.origin_z;
	if (!droptofloor())
	{

//TONY
//This is lame, but I'm not sure how else to "fix" it.
//sometimes items produced in loadmod fall out,
//since we're not usually in a dedicated server, this can get
//rather annoying
		if (!(temp1 & TEMP1_LOADMOD))
		{
			dprint ("Bonus item fell out of level at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
		remove(self);
		return;
	}
	
	self.bot_wants_item = TRUE;             // CTFBOT bot optimization
};

/*
============
StartItem

Sets the clipping size and plants the object on the floor
============
*/
void() StartItem =
{
	self.nextthink = time + 0.2;    // items start after other solids
	self.think = PlaceItem;
};

/*
=========================================================================

HEALTH BOX

=========================================================================
*/
//
// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//
float (entity e, float healamount, float ignore) T_Heal =
{
	if (e.health <= 0)
		return 0;
	if ((!ignore) && (e.health >= other.max_health))
		return 0;
	healamount = ceil(healamount);

	e.health = e.health + healamount;
	if ((!ignore) && (e.health >= other.max_health))
		e.health = other.max_health;
		
	if (e.health > 250)
		e.health = 250;
	return 1;
};

/*QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
Health box. Normally gives 25 points.
Rotten box heals 5-10 points,
megahealth will add 100 health, then 
rot you down to your maximum health limit, 
one point per second.
*/

float   H_ROTTEN = 1;
float   H_MEGA = 2;
.float  healamount, healtype;
void() health_touch;
void() item_megahealth_rot;

void() item_health =
{       
//TONY
//DEATHMATCH
	if((deathmatch & DM_NO_HEALTH) || (deathmatch & DM_NO_ITEMS))
	{
		remove(self);
		return;
	}

	self.touch = health_touch;

	if (self.spawnflags & H_ROTTEN)
	{
//TONY
//LOADMOD
//		precache_model("maps/b_bh10.bsp");
//		precache_sound("items/r_item1.wav");
		setmodel(self, "maps/b_bh10.bsp");
		self.noise = "items/r_item1.wav";
		self.healamount = 15;
		self.healtype = 0;
	}
	else
	if (self.spawnflags & H_MEGA)
	{
//TONY
//LOADMOD
//		precache_model("maps/b_bh100.bsp");
//		precache_sound("items/r_item2.wav");
		setmodel(self, "maps/b_bh100.bsp");
		self.noise = "items/r_item2.wav";
		self.healamount = 100;
		self.healtype = 2;
	}
	else
	{
//TONY
//LOADMOD
//		precache_model("maps/b_bh25.bsp");
//		precache_sound("items/health1.wav");
		setmodel(self, "maps/b_bh25.bsp");
		self.noise = "items/health1.wav";
		self.healamount = 25;
		self.healtype = 1;
	}
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


void() health_touch =
{
	local   float amount;
	local   string  s;
	
	if (other.classname != "player" && other.classname != "bot")    // CTFBOT
		return;
	
	if (self.healtype == 2) // Megahealth?  Ignore max_health...
	{
		if (other.health >= 250)
			return;
		if (!T_Heal(other, self.healamount, 1))
			return;
	}
	else
	{
		if (!T_Heal(other, self.healamount, 0))
			return;
	}
	
	if (other.classname == "player")        // CTFBOT
	{                                               // CTFBOT

//TONY
//TEMP1_NOMESS
	if(!(temp1 & TEMP1_NOMESS))
	{
		stuffcmd (other, "bf\n");               // CTFBOT moved from below

	}       // CTFBOT
	}
// health touch sound
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	
	self.model = string_null;
	self.solid = SOLID_NOT;

	// Megahealth = rot down the player's super health
	if (self.healtype == 2)
	{
		other.items = other.items | IT_SUPERHEALTH;
		self.nextthink = time + 5;
		self.think = item_megahealth_rot;
		self.owner = other;
	}
	else
	{
//TONY
//code removed  
		self.nextthink = time + 20;

		self.think = SUB_regen;
	}
	
	activator = other;
	SUB_UseTargets();                               // fire all targets / killtargets
};      

void() item_megahealth_rot =
{
	other = self.owner;
	
//ZOID: player doesn't rot if they have Elder Magic rune
	if (other.health > other.max_health && 
		!(other.player_flag & ITEM_RUNE4_FLAG)) {
		other.health = other.health - 1;
		self.nextthink = time + 1;
		return;
	}

// it is possible for a player to die and respawn between rots, so don't
// just blindly subtract the flag off
	other.items = other.items - (other.items & IT_SUPERHEALTH);

	self.nextthink = time + 20;
	self.think = SUB_regen;
};

/*
===============================================================================

ARMOR

===============================================================================
*/

void() armor_touch;

void() armor_touch =
{
	local   float   type, value, bit;
	
	if (other.health <= 0)
		return;
	if (other.classname != "player" && other.classname != "bot")    // CTFBOT
		return;

	if (self.classname == "item_armor1")
	{
		type = 0.3;
		value = 100;
		bit = IT_ARMOR1;
	}
	if (self.classname == "item_armor2")
	{
		type = 0.6;
		value = 150;
		bit = IT_ARMOR2;
	}
	if (self.classname == "item_armorInv")
	{
		type = 0.8;
		value = 200;
		bit = IT_ARMOR3;
	}

	if (other.armortype*other.armorvalue >= type*value)
		return;
		
	other.armortype = type;
	other.armorvalue = value;
	other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;

	self.solid = SOLID_NOT;
	self.model = string_null;
//TONY
//code removed  
	self.nextthink = time + 20;

	self.think = SUB_regen;

	// armor touch sound                                                    // CTFBOT moved
	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);      // CTFBOT moved

	if (other.classname == "player")        // CTFBOT
	{                                               // CTFBOT
//TONY
//TEMP1_NOMESS
	if(!(temp1 & TEMP1_NOMESS))
	{
		stuffcmd (other, "bf\n");

	} // CTFBOT
	}	
	activator = other;
	SUB_UseTargets();                               // fire all targets / killtargets
};


/*QUAKED item_armor1 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armor1 =
{
//TONY
//DEATHMATCH
	if((deathmatch & DM_NO_ARMOR) || (deathmatch & DM_NO_ITEMS))
	{
		remove(self);
		return;
	}

	self.touch = armor_touch;
//TONY
//LOADMOD
//	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED item_armor2 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armor2 =
{
//TONY
//DEATHMATCH
	if((deathmatch & DM_NO_ARMOR) || (deathmatch & DM_NO_ITEMS))
	{
		remove(self);
		return;
	}

	self.touch = armor_touch;
//TONY
//LOADMOD
//	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 1;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED item_armorInv (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armorInv =
{
//TONY
//DEATHMATCH
	if((deathmatch & DM_NO_ARMOR) || (deathmatch & DM_NO_ITEMS))
	{
		remove(self);
		return;
	}

	self.touch = armor_touch;
//TONY
//LOADMOD
//	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 2;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*
===============================================================================

WEAPONS

===============================================================================
*/

void() bound_other_ammo =
{
//TONY
//DEATHMATCH
	if(deathmatch & DM_INFINITE_AMMO)
	{
		other.ammo_shells = 69;
		other.ammo_nails = 69;
		other.ammo_rockets = 69;               
		other.ammo_cells = 69;
		return;        
	}

	if (other.ammo_shells > 100)
		other.ammo_shells = 100;
	if (other.ammo_nails > 200)
		other.ammo_nails = 200;
	if (other.ammo_rockets > 100)
		other.ammo_rockets = 100;               
	if (other.ammo_cells > 100)
		other.ammo_cells = 100;         
};


float(float w) RankForWeapon =
{
	if (w == IT_LIGHTNING)
		return 1;
	if (w == IT_ROCKET_LAUNCHER)
		return 2;
   if (w == IT_SUPER_NAILGUN)
      return 4;
   if (w == IT_GRENADE_LAUNCHER)
      return 6;
   if (w == IT_SUPER_SHOTGUN)
      return 7;
	if (w == IT_NAILGUN)
      return 8;
	  
	return 10;
};

/*
=============
Deathmatch_Weapon

Deathmatch weapon change rules for picking up a weapon

.float          ammo_shells, ammo_nails, ammo_rockets, ammo_cells;
=============
*/
void(float old, float new) Deathmatch_Weapon =
{
	local float or, nr;

// change self.weapon if desired
	if (self.weapon == IT_HOOK && self.button0)
		return; // never change if we pulled ourselves to it.
	or = RankForWeapon (self.weapon);
	nr = RankForWeapon (new);
	if ( nr < or )
		self.weapon = new;
};

//TONY
//ripped from QW
float (float w) WeaponCode =
{
	if (w == IT_SUPER_SHOTGUN)
		return 3;
	if (w == IT_NAILGUN)
		return 4;
	if (w == IT_SUPER_NAILGUN)
		return 5;
	if (w == IT_GRENADE_LAUNCHER)
		return 6;
	if (w == IT_ROCKET_LAUNCHER)
		return 7;
	if (w == IT_LIGHTNING)
		return 8;
	return 1;
};

/*
=============
weapon_touch
=============
*/
float() W_BestWeapon;

void() weapon_touch =
{
	local   float   hadammo, best, new, old;
	local float bbest;      // CTFBOT
	local   entity  stemp;
	local   float   leave;
//McBain: added prevweapon local variable
	local   float   prevweapon;

	if ((!(other.flags & FL_CLIENT)) && other.classname != "bot")   // CTFBOT
		return;

// if the player was using his best weapon, change up to the new one if better          
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;
//TONY
//DEATHMATCH  
	if (deathmatch & DM_WEAPONS_STAY)  // deathmatch 2 is silly old rules
		leave = 1;
	else
		leave = 0;
	
	if (self.classname == "weapon_nailgun")
	{
		if (leave && (other.items & IT_NAILGUN) )
			return;
		hadammo = other.ammo_nails;                     
		new = IT_NAILGUN;
// *TEAMPLAY*
		if ( !( coop && (teamplay & TEAM_DROP_ITEMS) ) )
			other.ammo_nails = other.ammo_nails + 30;
	}
	else if (self.classname == "weapon_supernailgun")
	{
		if (leave && (other.items & IT_SUPER_NAILGUN) )
			return;
		hadammo = other.ammo_rockets;                   
		new = IT_SUPER_NAILGUN;
// *TEAMPLAY*
		if ( !( coop && (teamplay & TEAM_DROP_ITEMS) ) ) {
			other.ammo_nails = other.ammo_nails + 30;
		}
	}
	else if (self.classname == "weapon_supershotgun")
	{
		if (leave && (other.items & IT_SUPER_SHOTGUN) )
			return;
		hadammo = other.ammo_rockets;                   
		new = IT_SUPER_SHOTGUN;
// *TEAMPLAY*
		if ( !( coop && (teamplay & TEAM_DROP_ITEMS) ) )
			other.ammo_shells = other.ammo_shells + 5;
	}
	else if (self.classname == "weapon_rocketlauncher")
	{
		if (leave && (other.items & IT_ROCKET_LAUNCHER) )
			return;
		hadammo = other.ammo_rockets;                   
		new = IT_ROCKET_LAUNCHER;
// *TEAMPLAY*
		if ( !( coop && (teamplay & TEAM_DROP_ITEMS) ) )
			other.ammo_rockets = other.ammo_rockets + 5;
	}
	else if (self.classname == "weapon_grenadelauncher")
	{
		if (leave && (other.items & IT_GRENADE_LAUNCHER) )
			return;
		hadammo = other.ammo_rockets;                   
		new = IT_GRENADE_LAUNCHER;
// *TEAMPLAY*
		if ( !( coop && (teamplay & TEAM_DROP_ITEMS) ) )
			other.ammo_rockets = other.ammo_rockets + 5;
	}
	else if (self.classname == "weapon_lightning")
	{
		if (leave && (other.items & IT_LIGHTNING) )
			return;
		hadammo = other.ammo_rockets;                   
		new = IT_LIGHTNING;
// *TEAMPLAY*
		if ( !( coop && (teamplay & TEAM_DROP_ITEMS) ) )
			other.ammo_cells = other.ammo_cells + 15;
	}

	else
		objerror ("weapon_touch: unknown classname");

	if (other.classname == "player")        // CTFBOT
	{                                               // CTFBOT
//TONY
//TEMP1_NOMESS
		if(!(temp1 & TEMP1_NOMESS))
		{
			stuffcmd (other, "bf\n");       // CTFBOT moved from below
		
		}       // CTFBOT
	}

// weapon touch sound
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);

	bound_other_ammo ();

// change to the weapon
	old = other.items;
	other.items = other.items | new;
	
	stemp = self;
	self = other;

//McBain: temp store old weapon
	prevweapon = self.weapon; 


//TONY
//best wep
//ripped from QW

	if ( other.classname == "player")
	{
		if (( WeaponCode(new) <= other.best_wep ) || (self.best_wep == 0))
		{
			if (self.flags & FL_INWATER)
			{
				if (new != IT_LIGHTNING)
				{
					Deathmatch_Weapon (old, new);
				}
			}
			else
			{                
				Deathmatch_Weapon (old, new);
			}
		}
	}
	else
		Deathmatch_Weapon (old, new);

//McBain: save previous weapon if different
	if (self.weapon != prevweapon)
		self.previous_weapon = prevweapon;

	W_SetCurrentAmmo();

	self = stemp;

	if (leave)
		return;

// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
//TONY
//code removed
//and
//30 ticks is just too damn long
//	self.nextthink = time + 30;
	self.nextthink = time + 20;

	self.think = SUB_regen;
	
	activator = other;
	SUB_UseTargets();                               // fire all targets / killtargets
};


/*QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_supershotgun =
{
//TONY
//DEATHMATCH
	if ((deathmatch & DM_START_SMALL) || (deathmatch & DM_START_BIG) || (deathmatch & DM_NO_ITEMS))
	{
		remove(self);
		return;
	}
	precache_model ("progs/g_shot.mdl");
	setmodel (self, "progs/g_shot.mdl");
	self.weapon = IT_SUPER_SHOTGUN;
	self.netname = "Double-barrelled Shotgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_nailgun =
{
//TONY
//DEATHMATCH
	if ((deathmatch & DM_START_SMALL) || (deathmatch & DM_START_BIG) || (deathmatch & DM_NO_ITEMS))
	{
		remove(self);
		return;
	}
	precache_model ("progs/g_nail.mdl");
	setmodel (self, "progs/g_nail.mdl");
	self.weapon = IT_NAILGUN;
	self.netname = "nailgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_supernailgun =
{
//TONY
//DEATHMATCH
	if ((deathmatch & DM_START_BIG) || (deathmatch & DM_NO_ITEMS))
	{
		remove(self);
		return;
	}
	precache_model ("progs/g_nail2.mdl");
	setmodel (self, "progs/g_nail2.mdl");
	self.weapon = IT_SUPER_NAILGUN;
	self.netname = "Super Nailgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_grenadelauncher =
{
//TONY
//DEATHMATCH
	if (deathmatch & DM_NO_ITEMS)
	{
		remove(self);
		return;
	}
	precache_model ("progs/g_rock.mdl");
	setmodel (self, "progs/g_rock.mdl");
	self.weapon = 3;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_rocketlauncher =
{
//TONY
//DEATHMATCH
	if ((deathmatch & DM_START_BIG) || (deathmatch & DM_NO_ITEMS))
	{
		remove(self);
		return;
	}
	precache_model ("progs/g_rock2.mdl");
	setmodel (self, "progs/g_rock2.mdl");
	self.weapon = 3;
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_lightning =
{
//TONY
//DEATHMATCH
	if (deathmatch & DM_NO_ITEMS)
	{
		remove(self);
		return;
	}
	precache_model ("progs/g_light.mdl");
	setmodel (self, "progs/g_light.mdl");
	self.weapon = 3;
	self.netname = "Thunderbolt";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


/*
===============================================================================

AMMO

===============================================================================
*/

void() ammo_touch =
{
local entity    stemp;
local float             best;

	if (other.classname != "player" && other.classname != "bot")    // CTFBOT
		return;
	if (other.health <= 0)
		return;

// if the player was using his best weapon, change up to the new one if better          
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;


// shotgun
	if (self.weapon == 1)
	{
		if (other.ammo_shells >= 100)
			return;
		other.ammo_shells = other.ammo_shells + self.aflag;
	}

// spikes
	if (self.weapon == 2)
	{
		if (other.ammo_nails >= 200)
			return;
		other.ammo_nails = other.ammo_nails + self.aflag;
	}

//      rockets
	if (self.weapon == 3)
	{
		if (other.ammo_rockets >= 100)
			return;
		other.ammo_rockets = other.ammo_rockets + self.aflag;
	}

//      cells
	if (self.weapon == 4)
	{
		if (other.ammo_cells >= 100)
			return;
		other.ammo_cells = other.ammo_cells + self.aflag;
	}

	bound_other_ammo ();
	
	// ammo touch sound CTFBOT moved from below
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);

	if (other.classname == "player")                // CTFBOT
	{                                                       // CTFBOT
//TONY
//TEMP1_NOMESS
		if(!(temp1 & TEMP1_NOMESS))
		{
			stuffcmd (other, "bf\n");
		}
	}               // CTFBOT

// change to a better weapon if appropriate

	if ( other.weapon == best )
	{
		stemp = self;
		self = other;
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo ();
		self = stemp;
	}

// if changed current ammo, update it
	stemp = self;
	self = other;
	W_SetCurrentAmmo();
	self = stemp;

// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
//TONY
//DEATHMATCH
	if ((deathmatch & DM_START_SMALL) || (deathmatch & DM_START_BIG))
		self.nextthink = time + 15;
	else
		self.nextthink = time + 20;

	self.think = SUB_regen;

	activator = other;
	SUB_UseTargets();                               // fire all targets / killtargets
};




float WEAPON_BIG2 = 1;

/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_shells =
{
//TONY
//DEATHMATCH
	if ((deathmatch & DM_START_SMALL) || (deathmatch & DM_START_BIG) || (deathmatch & DM_NO_ITEMS) || (deathmatch & DM_INFINITE_AMMO))
	{
		remove(self);
		return;
	}
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_shell1.bsp");
		setmodel (self, "maps/b_shell1.bsp");
		self.aflag = 40;
	}
	else
	{
		precache_model ("maps/b_shell0.bsp");
		setmodel (self, "maps/b_shell0.bsp");
		self.aflag = 20;
	}
	self.weapon = 1;
	self.netname = "shells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_spikes =
{
//TONY
//DEATHMATCH
	if((deathmatch & DM_NO_ITEMS) || (deathmatch & DM_INFINITE_AMMO))
	{
		remove(self);
		return;
	}
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_nail1.bsp");
		setmodel (self, "maps/b_nail1.bsp");
		self.aflag = 50;
	}
	else
	{
		precache_model ("maps/b_nail0.bsp");
		setmodel (self, "maps/b_nail0.bsp");
		self.aflag = 25;
	}
	self.weapon = 2;
	self.netname = "nails";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_rockets =
{
//TONY
//DEATHMATCH
	if((deathmatch & DM_NO_ITEMS) || (deathmatch & DM_INFINITE_AMMO))
	{
		remove(self);
		return;
	}
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_rock1.bsp");
		setmodel (self, "maps/b_rock1.bsp");
		self.aflag = 10;
	}
	else
	{
		precache_model ("maps/b_rock0.bsp");
		setmodel (self, "maps/b_rock0.bsp");
		self.aflag = 5;
	}
	self.weapon = 3;
	self.netname = "rockets";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_cells =
{
//TONY
//DEATHMATCH
	if ((deathmatch & DM_NO_ITEMS) || (deathmatch & DM_INFINITE_AMMO))
	{
		remove(self);
		return;
	}
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_batt1.bsp");
		setmodel (self, "maps/b_batt1.bsp");
		self.aflag = 12;
	}
	else
	{
		precache_model ("maps/b_batt0.bsp");
		setmodel (self, "maps/b_batt0.bsp");
		self.aflag = 6;
	}
	self.weapon = 4;
	self.netname = "cells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
DO NOT USE THIS!!!! IT WILL BE REMOVED!
*/

float WEAPON_SHOTGUN = 1;
float WEAPON_ROCKET = 2;
float WEAPON_SPIKES = 4;
float WEAPON_BIG = 8;
void() item_weapon =
{
//TONY
//DEATHMATCH
	if((deathmatch & DM_NO_ITEMS) || (deathmatch & DM_INFINITE_AMMO))
	{
		remove(self);
		return;
	}

	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_SHOTGUN)
	{
//TONY
//DEATHMATCH 5
	if ((deathmatch & DM_START_SMALL) || (deathmatch & DM_START_BIG))
	{
		remove(self);
		return;
	}
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_shell1.bsp");
			setmodel (self, "maps/b_shell1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model ("maps/b_shell0.bsp");
			setmodel (self, "maps/b_shell0.bsp");
			self.aflag = 20;
		}
		self.weapon = 1;
		self.netname = "shells";
	}

	if (self.spawnflags & WEAPON_SPIKES)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_nail1.bsp");
			setmodel (self, "maps/b_nail1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model ("maps/b_nail0.bsp");
			setmodel (self, "maps/b_nail0.bsp");
			self.aflag = 20;
		}
		self.weapon = 2;
		self.netname = "spikes";
	}

	if (self.spawnflags & WEAPON_ROCKET)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_rock1.bsp");
			setmodel (self, "maps/b_rock1.bsp");
			self.aflag = 10;
		}
		else
		{
			precache_model ("maps/b_rock0.bsp");
			setmodel (self, "maps/b_rock0.bsp");
			self.aflag = 5;
		}
		self.weapon = 3;
		self.netname = "rockets";
	}
	
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


void() item_key1 =
{remove(self);};
void() item_key2 =
{remove(self);};
void() item_sigil =
{remove(self);};

/*
===============================================================================

POWERUPS

===============================================================================
*/

void() powerup_touch;


void() powerup_touch =
{
local entity    stemp;
local float             best;

	if (other.classname != "player" && other.classname != "bot")            // CTFBOT
		return;
	if (other.health <= 0)
		return;

	if (other.classname == "player")        // CTFBOT
	{
//TONY
//TEMP1_NOMESS
		if(!(temp1 & TEMP1_NOMESS))
		{
			sprint (other, "You got the ");
			sprint (other, self.netname);
			sprint (other,"\n");
			stuffcmd (other, "bf\n");               // CTFBOT moved from below
		}
	}

	self.mdl = self.model;
	
	if ((self.classname == "item_artifact_invulnerability") ||
		(self.classname == "item_artifact_invisibility"))
		self.nextthink = time + 60*5;
	else
		self.nextthink = time + 60;
	
	self.think = SUB_regen;

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;

// do the apropriate action
	if (self.classname == "item_artifact_envirosuit")
	{
		other.rad_time = 1;
		other.radsuit_finished = time + 30;
	}
	
	if (self.classname == "item_artifact_invulnerability")
	{
		other.invincible_time = 1;
		other.invincible_finished = time + 30;
	}
	
	if (self.classname == "item_artifact_invisibility")
	{
		other.invisible_time = 1;
		other.invisible_finished = time + 30;
	}

	if (self.classname == "item_artifact_super_damage")
	{
		other.super_time = 1;
		other.super_damage_finished = time + 30;
	}
	
	activator = other;
	SUB_UseTargets();                               // fire all targets / killtargets
};



/*QUAKED item_artifact_invulnerability (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invulnerable for 30 seconds
*/
void() item_artifact_invulnerability =
{
//TONY
//DEATHMATCH
	if ((deathmatch & DM_NO_POWERUPS) || (deathmatch & DM_NO_ITEMS))
	{
		if((deathmatch & DM_NO_ARMOR) || (deathmatch & DM_NO_ITEMS))
		{
			remove(self);
			return;
		}
		self.classname = "item_armorInv";
		self.touch = armor_touch;
		precache_model ("progs/armor.mdl");
		setmodel (self, "progs/armor.mdl");
		self.skin = 2;
		setsize (self, '-16 -16 0', '16 16 56');
		StartItem ();
		return;
	}

//TONY
//DEATHMATCH

	self.touch = powerup_touch;

	precache_model ("progs/invulner.mdl");
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	self.noise = "items/protect.wav";
	setmodel (self, "progs/invulner.mdl");
	self.netname = "Pentagram of Protection";
	self.items = IT_INVULNERABILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_artifact_envirosuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from water or slime for 30 seconds
*/
void() item_artifact_envirosuit =
{
	self.touch = powerup_touch;

	precache_model ("progs/suit.mdl");
	precache_sound ("items/suit.wav");
	precache_sound ("items/suit2.wav");
	self.noise = "items/suit.wav";
	setmodel (self, "progs/suit.mdl");
	self.netname = "Biosuit";
	self.items = IT_SUIT;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};


/*QUAKED item_artifact_invisibility (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invisible for 30 seconds
*/
void() item_artifact_invisibility =
{
//TONY
//DEATHMATCH
	if ((deathmatch & DM_NO_POWERUPS) || (deathmatch & DM_NO_ITEMS))
	{
		if((deathmatch & DM_NO_ARMOR) || (deathmatch & DM_NO_ITEMS))
		{
			remove(self);
			return;
		}
		self.classname = "item_armor1";
		self.touch = armor_touch;
		precache_model ("progs/armor.mdl");
		setmodel (self, "progs/armor.mdl");
		self.skin = 0;
		setsize (self, '-16 -16 0', '16 16 56');
		StartItem ();
		return;
	}

//TONY
//DEATHMATCH

	self.touch = powerup_touch;

	precache_model ("progs/invisibl.mdl");
	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/inv3.wav");
	self.noise = "items/inv1.wav";
	setmodel (self, "progs/invisibl.mdl");
	self.netname = "Ring of Shadows";
	self.items = IT_INVISIBILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};


/*QUAKED item_artifact_super_damage (0 .5 .8) (-16 -16 -24) (16 16 32)
The next attack from the player will do 4x damage
*/
void() item_artifact_super_damage =
{
//TONY
//DEATHMATCH
	if ((deathmatch & DM_NO_POWERUPS) || (deathmatch & DM_NO_ITEMS))
	{
		if((deathmatch & DM_NO_ARMOR) || (deathmatch & DM_NO_ITEMS))
		{
			remove(self);
			return;
		}
		self.classname = "item_armor2";
		self.touch = armor_touch;
		precache_model ("progs/armor.mdl");
		setmodel (self, "progs/armor.mdl");
		self.skin = 1;
		setsize (self, '-16 -16 0', '16 16 56');
		StartItem ();
		return;
	}

//TONY
//DEATHMATCH


	self.touch = powerup_touch;

	precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	self.noise = "items/damage.wav";
	setmodel (self, "progs/quaddama.mdl");
	self.netname = "Quad Damage";
	self.items = IT_QUAD;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};



/*
===============================================================================

PLAYER BACKPACKS

===============================================================================
*/

void() BackpackTouch =
{
	local string    s;
	local   float   best, old, new;
	local float bbest;              // CTFBOT
	local           entity  stemp;
	local   float   acount;

	if (other.classname != "player" && other.classname != "bot")    // CTFBOT
		return;
	if (other.health <= 0)
		return;
	//don't let self pick it up for a sec
	if ((other == self.owner) && ( (self.nextthink - time) > 118 ) )
		return;


	acount = 0;

//TONY
//TEMP1_NOMESS
	if(!(temp1 & TEMP1_NOMESS))
	{
		if (other.classname == "player")                // CTFBOT
			sprint (other, "You get ");
	}
	

// if the player was using his best weapon, change up to the new one if better          
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

// change weapons
	other.ammo_shells = other.ammo_shells + self.ammo_shells;
	other.ammo_nails = other.ammo_nails + self.ammo_nails;
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
	other.ammo_cells = other.ammo_cells + self.ammo_cells;

	new = self.items;
	if (!new)
		new = other.weapon;
	old = other.items;
	other.items = other.items | new;
	
	bound_other_ammo ();

	if (other.classname == "player")        // CTFBOT
	{
						// CTFBOT
//TONY
//TEMP1_NOMESS
	if(!(temp1 & TEMP1_NOMESS))
	{
		if (self.ammo_shells)
		{
			if (acount)
				sprint(other, ", ");
			acount = 1;
			s = ftos(self.ammo_shells);
			sprint (other, s);
			sprint (other, " shells");
		}
		if (self.ammo_nails)
		{
			if (acount)
				sprint(other, ", ");
			acount = 1;
			s = ftos(self.ammo_nails);
			sprint (other, s);
			sprint (other, " nails");
		}
		if (self.ammo_rockets)
		{
			if (acount)
				sprint(other, ", ");
			acount = 1;
			s = ftos(self.ammo_rockets);
			sprint (other, s);
			sprint (other, " rockets");
		}
		if (self.ammo_cells)
		{
			if (acount)
				sprint(other, ", ");
			acount = 1;
			s = ftos(self.ammo_cells);
			sprint (other, s);
			sprint (other, " cells");
		}
		sprint (other, "\n");
		stuffcmd (other, "bf\n");
	}//!NO_MESS
	}//player

	if ((deathmatch & DM_START_SMALL) || (deathmatch & DM_START_BIG))
	{
		other.health = other.health + 5;
	}

	// backpack touch sound CTFBOT moved
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);

// remove the backpack, change self to the player
	remove(self);
	self = other;

// change to the weapon

//TONY
//best wep
//ripped from QW

	if ( other.classname == "player")
	{
		if ( WeaponCode(new) <= other.best_wep )
		{
			if (self.flags & FL_INWATER)
			{
				if (new != IT_LIGHTNING)
				{
					Deathmatch_Weapon (old, new);
				}
			}
			else
			{                
				Deathmatch_Weapon (old, new);
			}
		}
	}
	else
		Deathmatch_Weapon (old, new);

	W_SetCurrentAmmo ();
};

/*
===============
DropBackpack
===============
*/
void() DropBackpack =
{
	local entity    item;


	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells))
		return; // nothing in it

	item = spawn();
	item.origin = self.origin - '0 0 24';

	item.items = 0; // none by default
	

//ZOID--axe and hook don't go into backpack
	if (self.weapon != IT_HOOK || self.weapon != IT_AXE)
		item.items = self.weapon;

	
	if (self.classname == "bot")
		item.items = self.lastweapon_shot;

	if (item.items == IT_SHOTGUN)
		item.netname = "Shotgun";
	else if (item.items == IT_SUPER_SHOTGUN)
		item.netname = "Double-barrelled Shotgun";
	else if (item.items == IT_NAILGUN)
		item.netname = "Nailgun";
	else if (item.items == IT_SUPER_NAILGUN)
		item.netname = "Super Nailgun";
	else if (item.items == IT_GRENADE_LAUNCHER)
		item.netname = "Grenade Launcher";
	else if (item.items == IT_ROCKET_LAUNCHER)
		item.netname = "Rocket Launcher";
	else if (item.items == IT_LIGHTNING)
		item.netname = "Thunderbolt";
	else
		item.netname = "";

	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;

//TONY
//DEATHMATCH 5
	if ((deathmatch & DM_START_SMALL) || (deathmatch & DM_START_BIG))
	{
		item.ammo_shells = 0;
		item.ammo_nails = 40;
		item.ammo_rockets = 5;
		item.ammo_cells = 0;
		item.items = 0;
	}



	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	
	item.nextthink = time + 120;    // remove after 2 minutes
	item.think = SUB_Remove;
	
	item.bot_wants_item = TRUE;             // CTFBOT optimization

	item.classname = "backpack";    // CTFBOT give backpacks a class name
									// CTFBOT so bots can see them

	item.netname = "backpack";      // CTFBOT give backpacks a net name
								// CTFBOT for better debug messages
};

/*----------------------------------------------------------------------
  The Rune Game modes

  Rune 1 - Earth Magic
	  resistance
  Rune 2 - Black Magic
	  strength
  Rune 3 - Hell Magic
	  haste
  Rune 4 - Elder Magic
	  regeneration

 ----------------------------------------------------------------------*/

entity() SelectRuneSpawnPoint =
{
	runespawn = find(runespawn, classname, "info_player_deathmatch");
	if (runespawn == world)
		runespawn = find (runespawn, classname, "info_player_deathmatch");
	if (runespawn == world)
		error("no info_player_deathmatch to spawn rune");
	return runespawn;
};

void() RuneTouch =
{
	local string    s;
	local   float   best;
	local           entity  stemp;
	
	if (other.classname != "player" && other.classname != "bot")   // CTFBOT
		return;
	if (other.health <= 0)
		return;
		
	// CTFBOT EXTRAS [[[
	if ((time < (other.rune_drop_time + 2)) && (other.last_rune == self.player_flag))
		return;
	// CTFBOT EXTRAS ]]]
		
	if (other.player_flag & ITEM_RUNE_MASK) {
		if (other.classname == "player")        // CTFBOT
		{
			if (other.rune_notice_time < time) 
			{
//TONY
//TEMP1_NOMESS
	if(!(temp1 & TEMP1_NOMESS))
	{
				// CTFBOT EXTRAS [[[
				if (other.player_flag & ITEM_RUNE1_FLAG) {
					sprint(other, "You already have Åבעפט Íבחיד!\n");
				}
				else if (other.player_flag & ITEM_RUNE2_FLAG) {
					sprint(other, "You already have Âלבדכ Íבחיד!\n");
				}
				else if (other.player_flag & ITEM_RUNE3_FLAG) {
					sprint(other, "You already have Èולל Íבחיד!\n");
				}
				else if (other.player_flag & ITEM_RUNE4_FLAG) {
					sprint(other, "You already have Åלהוע Íבחיד!\n");
				}
//TONY
//THIS IS VERY ANNOYING
//ITS ALSO WELL DOCUMENTED
//				sprint(other, "Use impulse 40 to drop your rune\n");

				// CTFBOT EXTRAS ]]]

				TeamPlayerUpdate(other, "You already have a rune.\n");
				other.rune_notice_time = time + 5;
	}//NO_MESS
			}
		}
		return; // one per customer
	}
		
	other.player_flag = other.player_flag | self.player_flag;

	// backpack touch sound CTFBOT moved from below
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);

	

	// CTFBOT [[[
	if (other.classname == "bot")
	{
		if (bot_debug >= 1)
		{
			dprint(other.netname);
			dprint(" got ");
			dprint(self.netname);
			dprint("\n");
		}
		remove(self);
		return;
	}       
	// CTFBOT ]]]


//TONY
//TEMP1_NOMESS
	if(!(temp1 & TEMP1_NOMESS))
	{

	// notification of rune, no nofity in team mode
	if (self.player_flag & ITEM_RUNE1_FLAG) {
		self.items = self.items | IT_SIGIL1;
		if (teamplay == 0) {
			bprint(other.netname);
			bprint(" got the rune of Åבעפט Íבחיד!\n");
		}
		// CTFBOT EXTRAS [[[
		else {
			sprint(other, "You got the rune of Åבעפט Íבחיד!\n");//, Òוףיףפבמדו!\n");
		}
		// CTFBOT EXTRAS ]]]
//TONY
//Not sure whats going on, changing this though
//		TeamPlayerUpdate(other, "Åבעפט Íבחיד!\n\nÒוףיףפבמדו");
		TeamPlayerUpdate(other, "Åבעפט Íבחיד!  Òוףיףפבמדו");
	}
	if (self.player_flag & ITEM_RUNE2_FLAG) {
		self.items = self.items | IT_SIGIL2;
		if (teamplay == 0) {
			bprint(other.netname);
			bprint(" got the rune of Âלבדכ Íבחיד!\n");
		}
		// CTFBOT EXTRAS [[[
		else {
			sprint(other, "You got the rune of Âלבדכ Íבחיד!\n");//, Óפעומחפט!\n");
		}
		// CTFBOT EXTRAS ]]]
//TONY
//Not sure whats going on, changing this though
//		TeamPlayerUpdate(other, "Âלבדכ Íבחיד!\n\nÓפעומחפט");
		TeamPlayerUpdate(other, "Âלבדכ Íבחיד!  Óפעומחפט");
	}
	if (self.player_flag & ITEM_RUNE3_FLAG) {
		self.items = self.items | IT_SIGIL3;
		if (teamplay == 0) {
			bprint(other.netname);
			bprint(" got the rune of Èולל Íבחיד!\n");
		}
		// CTFBOT EXTRAS [[[
		else {
			sprint(other, "You got the rune of Èולל Íבחיד!\n");//, Èבףפו!\n");
		}
		// CTFBOT EXTRAS ]]]
//TONY
//Not sure whats going on, changing this though
//		TeamPlayerUpdate(other, "Èולל Íבחיד!\n\nÈבףפו");
		TeamPlayerUpdate(other, "Èולל Íבחיד!  Èבףפו");
	}
	if (self.player_flag & ITEM_RUNE4_FLAG) {
		self.items = self.items | IT_SIGIL4;
		if (teamplay == 0) {
			bprint(other.netname);
			bprint(" got the rune of Åלהוע Íבחיד!\n");
		}
		// CTFBOT EXTRAS [[[
		else {
			sprint(other, "You got the rune of Åלהוע Íבחיד!\n");//, Òוחומועבפיןמ!\n");
		}
		// CTFBOT EXTRAS ]]]
//TONY
//Not sure whats going on, changing this though
//		TeamPlayerUpdate(other, "Åלהוע Íבחיד!\n\nÒוחומועבפיןמ");
		TeamPlayerUpdate(other, "Åלהוע Íבחיד!  Òוחומועבפיןמ");
	}
	
	stuffcmd (other, "bf\n");

	}//NO_MESS

	remove(self);
};

entity (float flag) Do_DropRune;                // CTFBOT

void() RuneRespawn =
{
	local entity oself;

	oself = self;

	// choose random starting points
	self = SelectRuneSpawnPoint();
	Do_DropRune(oself.player_flag);

	remove(oself);
};

entity (float flag) Do_DropRune =       // CTFBOT
{
	local entity    item;

	item = spawn();
	item.origin = self.origin - '0 0 24';
	
	item.player_flag = flag;

	item.velocity_z = 400;
	item.velocity_x = -500 + (random() * 1000);
	item.velocity_y = -500 + (random() * 1000);
	
	item.bot_wants_item = TRUE;             // CTFBOT optimization
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	if (flag & ITEM_RUNE1_FLAG)
		setmodel (item, "progs/end1.mdl");
	else if (flag & ITEM_RUNE2_FLAG)
		setmodel (item, "progs/end2.mdl");
	else if (flag & ITEM_RUNE3_FLAG)
		setmodel (item, "progs/end3.mdl");
	else if (flag & ITEM_RUNE4_FLAG)
		setmodel (item, "progs/end4.mdl");
	setsize (item, '-16 -16 0', '16 16 56');

	item.touch = RuneTouch;

	item.nextthink = time + 120; /* if no one touches it in two minutes,
		respawn it somewhere else, so inaccessible ones will come 'back' */
	item.think = RuneRespawn;
	
	
	// CTFBOT [[[   // let bots know what runes are
	if (flag & ITEM_RUNE1_FLAG)
	{
		item.classname = "item_rune1";
		item.netname = "Resistance";
	}
	else if (flag & ITEM_RUNE2_FLAG)
	{
		item.classname = "item_rune2";
		item.netname = "Strength";
	}
	else if (flag & ITEM_RUNE3_FLAG)
	{
		item.classname = "item_rune3";
		item.netname = "Haste";
	}
	else if (flag & ITEM_RUNE4_FLAG)
	{
		item.classname = "item_rune4";
		item.netname = "Regeneration";
	}
	
	return item;
	// CTFBOT ]]]
};

/*
===============
Droprune
self is player
===============
*/
void() DropRune =
{
	if (self.player_flag & ITEM_RUNE1_FLAG)
		Do_DropRune(ITEM_RUNE1_FLAG);
	if (self.player_flag & ITEM_RUNE2_FLAG)
		Do_DropRune(ITEM_RUNE2_FLAG);
	if (self.player_flag & ITEM_RUNE3_FLAG)
		Do_DropRune(ITEM_RUNE3_FLAG);
	if (self.player_flag & ITEM_RUNE4_FLAG)
		Do_DropRune(ITEM_RUNE4_FLAG);
	self.player_flag = self.player_flag - (self.player_flag & ITEM_RUNE_MASK);
};

/*
================
SpawnRunes
spawn all the runes
self is the entity that was created for us, we remove it
================
*/
void() SpawnRunes =
{
	local entity oself;
	local float i;

	oself = self;

	// choose random starting points
	i = random() * 10;
	while (i > 0) {
		self = SelectRuneSpawnPoint();
		i = i - 1;
	}

	self = SelectRuneSpawnPoint();
	Do_DropRune(ITEM_RUNE1_FLAG);
	self = SelectRuneSpawnPoint();
	Do_DropRune(ITEM_RUNE2_FLAG);
	self = SelectRuneSpawnPoint();
	Do_DropRune(ITEM_RUNE3_FLAG);
	self = SelectRuneSpawnPoint();
	Do_DropRune(ITEM_RUNE4_FLAG);

	remove(oself);          // temp entity that was created to spawn the runes
};



void() StartRuneSpawn =
{
	local entity rspawn;

	if (runespawned || gamestart)
		return;
		
	runespawned = 1;

	precache_model ("progs/end1.mdl");
	precache_model ("progs/end2.mdl");
	precache_model ("progs/end3.mdl");
	precache_model ("progs/end4.mdl");

	// CTFBOT [[[
	if (cvar("teamplay") & TEAM_CAPTURE_CUSTOM)
	{
	// CTFBOT ]]]

		precache_sound("rune/rune1.wav");
		precache_sound("rune/rune2.wav");
		precache_sound("rune/rune22.wav"); // special rune and quad combo
		precache_sound("rune/rune3.wav");
		precache_sound("rune/rune4.wav");

	// CTFBOT [[[
	}
	else
	{
		precache_sound ("items/protect3.wav");
		precache_sound ("items/r_item1.wav");
		precache_sound ("boss1/sight1.wav");
		precache_sound ("items/damage3.wav");
		
	}
	// CTFBOT ]]]

	// spawn the runes
	rspawn = spawn();
	rspawn.nextthink = time + 0.1;
	rspawn.think = SpawnRunes;
};
