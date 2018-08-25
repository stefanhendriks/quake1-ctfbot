
// prototypes
void () W_WeaponFrame;
void() W_SetCurrentAmmo;
void() player_pain;
void() player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;
void() UnHookPlayer;

//float	modelindex_eyes, modelindex_player;
float pregameover;

// ZOID: with several effects doing the dimlight thing, they just can't
// turn it off.  Do not set self.effects with EF_DIMLIGHT directly.  This
// will automatically do it when CheckPowerups is called
// EF_DIMLIGHT is used;
// 1. Invincible (Pentagram)
// 2. Super Damage (Quad Power)
// 3. Having Flag in Capture
// self is player
void () CheckDimLight = {
	local float flag;

	flag = 0;
	// invincable
	if (self.invincible_finished > time)
		flag = 1;
	// quad
	if (self.super_damage_finished > time)
		flag = 1;
	// flag
//	if (self.player_flag & ITEM_ENEMY_FLAG)
//		flag = 1;

	if (flag)
		self.effects = self.effects | EF_DIMLIGHT;
	else
		self.effects = self.effects - (self.effects & EF_DIMLIGHT);
};

/*
=============================================================================

				LEVEL CHANGING / INTERMISSION

=============================================================================
*/

float	intermission_running;
float	intermission_exittime;

/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/
void() info_intermission =
{
};

void() SetChangeParms =
{
	parm14 = self.statstate;
	parm13 = self.best_wep;
	if (self.health <= 0)
	{
		SetNewParms ();
// *TEAMPLAY*
		parm10 = self.lastteam;	// Save the current team of the player


//TONY
//REMOVED CAM
//		parm11 = self.CamState;

//TONY
//stop motd from popping up every level
		parm11 = self.motd_count;


//TONY
//4.20
		parm14 = self.statstate;
		parm13 = self.best_wep;
//sex
		parm12 = self.sex;




		parm15 = self.accesslvl; // remote admin state
		parm16 = self.player_flag;
		return;
	}

// remove items
	self.items = self.items - (self.items & 
	(IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD) );

// cap super health
	if (self.health > 100)
		self.health = 100;
	if (self.health < 50)
		self.health = 50;
	parm14 = self.statstate;
	parm11 = self.motd_count;
	parm12 = self.sex;
	parm13 = self.best_wep;

	SetNewParms();
// *TEAMPLAY*

//TONY
//DEATHMATCH START
	if ((deathmatch & DM_START_SMALL) || (deathmatch & DM_START_BIG))
		SetNewParms();
	if (gamestart || self.observer)
		parm10 = -1;
	else
		parm10 = self.lastteam;	// Save the current team of the player
//TONY
//REMOVED CAM
//	parm11 = self.CamState;

	parm15 = self.accesslvl; // remote admin state
	parm16 = self.player_flag;
};


void() SetNewParms =
{
	if (gamestart && !pregameover) {
		parm1 = IT_AXE;
		parm2 = 100;
		parm4 = 0;
		parm8 = IT_AXE;
		parm10 = 1;
	} else {
//TONY
//MAYBE
//		if(cvar("teamplay") & TEAM_DISABLE_HOOK)
//			parm1 = IT_SHOTGUN | IT_AXE;
//		else
			parm1 = IT_SHOTGUN | IT_AXE | IT_HOOK;
		parm2 = 100;
		parm3 = 50;
		parm9 = 30;
		parm1 = parm1 + IT_ARMOR1;
		parm4 = 40;
		parm8 = IT_SHOTGUN;
		parm10 = -1;	// Reset 
	}
	parm5 = 0;
	parm6 = 0;
	parm7 = 0;
// *TEAMPLAY*

//TONY
//DEATHMATCH START
	if(deathmatch & DM_START_SMALL)
	{
		parm1 = IT_HOOK | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_ARMOR1;
		parm2 = 100;
		parm3 = 100;
		parm4 = 69;
		parm5 = 40;
		parm6 = 0;
		parm7 = 0;
		parm8 = IT_NAILGUN;
		parm9 = 31;
	}
	if(deathmatch & DM_START_BIG)
	{
		parm1 = IT_HOOK | IT_SUPER_SHOTGUN | IT_SUPER_NAILGUN | IT_ROCKET_LAUNCHER | IT_ARMOR1;
		parm2 = 100;
		parm3 = 100;
		parm4 = 69;
		parm5 = 60;
		parm6 = 5;
		parm7 = 0;
		parm8 = IT_SUPER_NAILGUN;
		parm9 = 31;
	}
	if(deathmatch & DM_INFINITE_AMMO)
	{
		parm4 = 69;
		parm5 = 69;
		parm6 = 69;
		parm7 = 69;
	}

	parm14 = self.statstate;
//sex ycam
	parm13 = self.best_wep;
	parm12 = self.sex;
	parm11 = self.motd_count;
//TONY
//REMOVED CAM
//	parm11 = CAM_NOT;

	parm15 = 0; // remote admin
	parm16 = 0;
};

void() DecodeLevelParms =
{
	self.player_flag = self.player_flag | parm16;
	self.player_flag = self.player_flag - (self.player_flag & ITEM_RUNE_MASK);
	self.player_flag = self.player_flag - (self.player_flag & ITEM_ENEMY_FLAG);
	self.skin = (self.player_flag & 65280)/256;
	self.accesslvl = parm15;
	self.statstate = parm14;
//sex ycam
	if((parm12 > 0) && (parm12 < 5))
		self.sex = parm12;
	else
		self.sex = 1;

	if((parm13 > 0) && (parm13 < 8))
		self.best_wep = parm13;
	else
		self.best_wep = 1;

//tony
//keep motd from popping up every level
	if(parm11 != 0)
		self.motd_count = parm11;
	else
		self.motd_count = 1;




	if (gamestart)
		SetNewParms ();		// take away all stuff on starting new episode
	
	self.items = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = parm9 * 0.01;

	// *XXX* EXPERT CTF

	// Reset times for additional scoring system on level change and server join
	// dprint("decode level parms\n");
	self.last_returned_flag = -10;
	self.last_fragged_carrier = -10;
	self.flag_since = -10;
	self.last_hurt_carrier = -10;

//TONY
//REMOVED CAM
//	if (parm11 > CAM_NOT)
//		self.CamState = CAM_PREBECOME;

// *TEAMPLAY*
	if(TeamColorIsLegal(parm10))
		self.lastteam = parm10;


};

/*
============
FindIntermission

Returns the entity to view from
============
*/
entity() FindIntermission =
{
	local	entity spot;
	local	float cyc;

// look for info_intermission first
	spot = find (world, classname, "info_intermission");
	if (spot)
	{	// pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find (spot, classname, "info_intermission");
			if (!spot)
				spot = find (spot, classname, "info_intermission");
			cyc = cyc - 1;
		}
		return spot;
	}

// then look for the start position
	spot = find (world, classname, "info_player_start");
	if (spot)
		return spot;
	
// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
	
	objerror ("FindIntermission: no spot");
};


void() GotoNextMap =
{
	if (cvar("samelevel") & 1)	// if samelevel is set, stay on same level
		changelevel (mapname);
	else {
//tony
//new map list feature
		if (FindNextCTFBotMap())
			changelevel (nextmap);

		if (nextmap == "e1m7") // skip House of Chthon
			nextmap = "e1m8";
		else if (nextmap == "start" && (teamplay & TEAM_CAPTURE_CUSTOM))
			nextmap = "ctfstart";
		else if (nextmap == "ctf9")
			nextmap = "ctf2m1";
		else if (nextmap == "end")
			nextmap = "dm1";

		changelevel (nextmap);
	}
};


void() ExitIntermission =
{
// skip any text in deathmatch
	if (deathmatch)
	{

//TONY
//AUTO LEVEL CHANGING
//		if (temp1 & TEMP1_AUTOLEVEL)
//		{
//			localcmd("nextctfbotmap\n");
//			return;
//		}
		GotoNextMap ();
		return;
	}
	
	intermission_exittime = time + 1;
	intermission_running = intermission_running + 1;

//
// run some text if at the end of an episode
//
//TONY
//REMOVED CODE
	GotoNextMap();
};

/*
============
IntermissionThink

When the player presses attack or jump, change to the next level
============
*/
void() IntermissionThink =
{
	if (time < intermission_exittime)
		return;

	if (!self.button0 && !self.button1 && !self.button2)
		return;
	
	ExitIntermission ();
};

void() execute_changelevel =
{
	local entity	pos;

	intermission_running = 1;
	
	intermission_exittime = time + 8;

	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 3);
	WriteByte (MSG_ALL, 3);
	
	pos = FindIntermission ();

	other = find (world, classname, "player");
	while (other != world)
	{
		other.view_ofs = '0 0 0';
		other.angles = other.v_angle = pos.mangle;
		other.fixangle = TRUE;		// turn this way immediately
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		setorigin (other, pos.origin);
		other = find (other, classname, "player");
	}	

	WriteByte (MSG_ALL, SVC_INTERMISSION);
};


void() changelevel_touch =
{
	local entity	pos;
	local float noexit;

	if (other.classname != "player")
		return;

	noexit = cvar("noexit");

	if (noexit == 1 || (noexit == 2 && !gamestart))
		return; // do nothing

//TONY
//TEMP1_NOMESS
	if(!(temp1 & TEMP1_NOMESS))
	{
		bprint (other.netname);
		bprint (" exited the level\n");
	}
	
	nextmap = self.map;

	SUB_UseTargets ();

	if ( (self.spawnflags & 1) && (deathmatch == 0) )
	{	// NO_INTERMISSION
		GotoNextMap();
		return;
	}
	
	self.touch = SUB_Null;

// we can't move people right now, because touch functions are called
// in the middle of C movement code, so set a think time to do it
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
void() trigger_changelevel =
{
	// ZOID:  If we are in CTF on start map, but not custom, change these
	// info trigger vote exits
	if (gamestart && !(teamplay & TEAM_CAPTURE_CUSTOM)) {
	if (self.map == "e1m1")
		self.message = "E1 Dimension of the Doomed";
	else if (self.map == "e2m1")
		self.message = "E2 The Realm of Black Magic";
	else if (self.map == "e3m1")
		self.message = "E3 The Netherworld";
	else if (self.map == "e4m1")
		self.message = "E4 The Elder World";
	else if (self.map == "end")
		self.message = "The Deathmatch Arenas";
	else
		self.message = "Unknown";
	
		self.classname = "trigger_voteexit";
		trigger_voteexit();
		return;
	}

	if (!self.map)
		objerror ("chagnelevel trigger doesn't have map");
	
	InitTrigger ();
	self.touch = changelevel_touch;
};


/*
=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================
*/

void() set_suicide_frame;

// called by ClientKill and DeadThink
void() respawn =
{
	// make a copy of the dead body for appearances sake
	CopyToBodyQue (self);
	// set default spawn parms
	SetNewParms ();
	// respawn		
	PutClientInServer ();
};


/*
============
ClientKill

Player entered the suicide command
============
*/
void() ClientKill =
{
	if (self.observer)
		return; // can't suicide when observer

	if (gamestart) {
		sprint(self, "Life just started.\n");
		return;
	}

	if (self.suicide_count > 3) {
		sprint(self, "You have suicided too much already.\n");
		return;
	}
	bprint (self.netname);
	bprint (" suicides\n");
	DropRune();
    TeamCaptureDropFlagOfPlayer(self);
	UnHookPlayer();
	set_suicide_frame ();

//TONY
//multi player model support
	set_player_main_index();
	
	UpdateClientFrags(self, -2);	// extra penalty // CTFBOT 
	
	self.suicide_count = self.suicide_count + 1;
	self.num_suicides = self.num_suicides + 1;	// CTFBOT
	respawn ();
};

void() SilentKill =
{
	set_suicide_frame ();
//TONY
//multi player model support
	set_player_main_index();

	respawn ();
};


float(vector v) CheckSpawnPoint =
{
	return FALSE;
};
//TONY
//QW SELECT SPAWN POINT
/*
============
QWSelectSpawnPoint

Returns the entity to spawn at
============
*/
entity() QWSelectSpawnPoint =
{
	local   entity spot, newspot, thing;
	local   float   numspots, totalspots;
	local   float   rnum, pcount;
	local   float   rs;
	local entity spots;

	numspots = 0;
	totalspots = 0;

// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
		
// choose a info_player_deathmatch point

// ok, find all spots that don't have players nearby

	spots = world;
	spot = find (world, classname, "info_player_deathmatch");       
	while (spot)
	{
		totalspots = totalspots + 1;

		thing=findradius(spot.origin, 84);
		pcount=0;               
		while (thing)
		{
			if (thing.classname == "player")
				pcount=pcount + 1;                      
			thing=thing.chain;      
		}
		if (pcount == 0) {
			spot.goalentity = spots;
			spots = spot;
			numspots = numspots + 1;
		}

		// Get the next spot in the chain
		spot = find (spot, classname, "info_player_deathmatch");                
	}
	totalspots=totalspots - 1;
	if (!numspots) {
		// ack, they are all full, just pick one at random
//		bprint (PRINT_HIGH, "Ackk! All spots are full. Selecting random spawn spot\n");
		totalspots = rint((random() * totalspots));
		spot = find (world, classname, "info_player_deathmatch");       
		while (totalspots > 0) {
			totalspots = totalspots - 1;
			spot = find (spot, classname, "info_player_deathmatch");
		}
		return spot;
	}
		
// We now have the number of spots available on the map in numspots

	// Generate a random number between 1 and numspots

	numspots = numspots - 1;
	
	numspots = rint((random() * numspots ) );

	spot = spots;
	while (numspots > 0) {
		spot = spot.goalentity;
		numspots = numspots - 1;
	}
	return spot;

};

//QW SELECT SPAWN POINT

/*
============
SelectSpawnPoint

Returns the entity to spawn at
============
*/
entity() SelectSpawnPoint =
{
	local	entity spot;
	
// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
		
// choose a info_player_deathmatch point
	if (coop)
	{
		lastspawn = find(lastspawn, classname, "info_player_coop");
		if (lastspawn == world)
			lastspawn = find (lastspawn, classname, "info_player_start");
		if (lastspawn != world)
			return lastspawn;
	}
	else if (deathmatch)
	{
		if (!self.killed) {
			spot = TeamCaptureSpawn();
			if (spot != world) 
				return spot;
		} else if (gamestart && self.killed && (teamplay & TEAM_CAPTURE_CUSTOM)) {
			lastvotespawn = find(lastvotespawn, classname, "info_vote_destination");
			if (lastvotespawn == world)
				lastvotespawn = find(lastvotespawn, classname, "info_vote_destination");
			return lastvotespawn;
		}
	
		lastspawn = find(lastspawn, classname, "info_player_deathmatch");
		if (lastspawn == world)
			lastspawn = find (lastspawn, classname, "info_player_deathmatch");
		if (lastspawn != world)
			return lastspawn;
	}

	if (serverflags)
	{	// return with a rune to start
		spot = find (world, classname, "info_player_start2");
		if (spot)
			return spot;
	}
	
	spot = find (world, classname, "info_player_start");
	if (!spot)
		error ("PutClientInServer: no info_player_start on level");
	
	return spot;
};

/*
===========
PutClientInServer

called each time a player is spawned
============
*/
void() DecodeLevelParms;
void() PlayerDie;


void() PutClientInServer =
{
	local	entity spot;

//TONY
//4.20
	serverflags = 0;

	spot = SelectSpawnPoint ();
//ZOID: Minimize chance of telefragging someone, from Johannes Plass
//(plass@dipmza.physik.uni-mainz.de) ServerModules package
	spot = TelefragSelectSpawnPoint(spot);

	if(deathmatch & DM_SPAWN_RANDOM)
		spot = QWSelectSpawnPoint ();

	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;
	self.staydeadtime = 0;
	self.regen_time = 0;
	self.rune_notice_time = 0;

	self.observer_flags = 0;			// CTFBOT
	self.escort_time = time - 999;		// CTFBOT

	self.last_hurt_carrier = -10;

	DecodeLevelParms ();
	
	W_SetCurrentAmmo ();

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	
	self.deadflag = DEAD_NO;
// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
	
//	spot = SelectSpawnPoint ();

	self.fixangle = TRUE;		// turn this way immediately

   // CTFBOT Clear out velocity so you're not launched into the air
   // CTFBOT when you respawn.
   self.velocity = '0 0 0';		// CTFBOT EXTRAS BUGFIX

// oh, this is a hack!
	setmodel (self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;

//TONY
//multi player model support
	if(self.sex == 0)
		self.sex = 1;
	if(temp1 & TEMP1_SUPPORT_PLAYER2)
	{
		setmodel (self, "progs/player2.mdl");
		modelindex_player2 = self.modelindex;
	}
	if(temp1 & TEMP1_SUPPORT_PLAYER3)
	{
		setmodel (self, "progs/player3.mdl");
		modelindex_player3 = self.modelindex;
	}
	if(temp1 & TEMP1_SUPPORT_PLAYER4)
	{
		setmodel (self, "progs/player4.mdl");
		modelindex_player4 = self.modelindex;
	}
	setmodel (self, "progs/player.mdl");
	modelindex_player = self.modelindex;

//TONY
//MULTIWEAPONS
	if(temp1 & TEMP1_MULTI)
	{
		set_player_modelindexes ();
	}


	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.view_ofs = '0 0 22';

	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	player_stand1 ();

	if (self.do_observer) {
		BecomeObserver(self);
		return;
	}

	if (deathmatch || coop)
	{
		makevectors(self.angles);
		spawn_tfog (self.origin + v_forward*20);
	}

	spawn_tdeath (self.origin, self);
};


/*
=============================================================================

				QUAKED FUNCTIONS

=============================================================================
*/


/*QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24)
The normal starting point for a level.
*/
void() info_player_start =
{
};


/*QUAKED info_player_start2 (1 0 0) (-16 -16 -24) (16 16 24)
Only used on start map for the return point from an episode.
*/
void() info_player_start2 =
{
};


void() SpawnRunes;

/*
saved out by quaked in region mode
*/
void() testplayerstart =
{
};

/*QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for deathmatch games
*/
void() info_player_deathmatch =
{

//tony
//testing DM spawns
//precache_model ("progs/invulner.mdl");
//setmodel (self, "progs/invulner.mdl");


	if (deathmatch)
	{
		if (!(deathmatch & DM_NORUNES))
			StartRuneSpawn();
	}
};

void() info_player_team1 =
{

//tony
//testing DM spawns
//precache_model ("progs/quaddama.mdl");
//setmodel (self, "progs/quaddama.mdl");

};

void() info_player_team2 =
{

//tony
//testing DM spawns
//precache_model ("progs/quaddama.mdl");
//setmodel (self, "progs/quaddama.mdl");

};

/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for coop games
*/
void() info_player_coop =
{
};

/*
===============================================================================

RULES

===============================================================================
*/

/*
go to the next level for deathmatch
only called if a time or frag limit has expired
*/
void() NextLevel =
{
	local entity o;

	// episode one
	if (mapname == "e1m1") nextmap = "e1m2";
	else if (mapname == "e1m2") nextmap = "e1m3";
	else if (mapname == "e1m3") nextmap = "e1m4";
	else if (mapname == "e1m4") nextmap = "e1m5";
	else if (mapname == "e1m5") nextmap = "e1m6";
	else if (mapname == "e1m6") nextmap = "e1m8";
	// e1m7 skipped, lag city
	else if (mapname == "e1m8") nextmap = "ctfstart";

	// episode two
	else if (mapname == "e2m1") nextmap = "e2m2";
	else if (mapname == "e2m2") nextmap = "e2m3";
	else if (mapname == "e2m3") nextmap = "e2m4";
	else if (mapname == "e2m4") nextmap = "e2m5";
	else if (mapname == "e2m5") nextmap = "e2m6";
	else if (mapname == "e2m6") nextmap = "e2m7";
	else if (mapname == "e2m7") nextmap = "ctfstart";

	// episode three
	else if (mapname == "e3m1") nextmap = "e3m2";
	else if (mapname == "e3m2") nextmap = "e3m3";
	else if (mapname == "e3m3") nextmap = "e3m4";
	else if (mapname == "e3m4") nextmap = "e3m5";
	else if (mapname == "e3m5") nextmap = "e3m6";
	else if (mapname == "e3m6") nextmap = "e3m7";
	else if (mapname == "e3m7") nextmap = "ctfstart";

	// episode four
	else if (mapname == "e4m1") nextmap = "e4m2";
	else if (mapname == "e4m2") nextmap = "e4m3";
	else if (mapname == "e4m3") nextmap = "e4m4";
	else if (mapname == "e4m4") nextmap = "e4m5";
	else if (mapname == "e4m5") nextmap = "e4m6";
	else if (mapname == "e4m6") nextmap = "e4m7";
	else if (mapname == "e4m7") nextmap = "e4m8";
	else if (mapname == "e4m8") nextmap = "ctfstart";

	// the deathmatch arenas
	else if (mapname == "dm1") nextmap = "dm2";
	else if (mapname == "dm2") nextmap = "dm3";
	else if (mapname == "dm3") nextmap = "dm4";
	else if (mapname == "dm4") nextmap = "dm5";
	else if (mapname == "dm5") nextmap = "dm6";
	else if (mapname == "dm6") nextmap = "ctfstart";

	// ctf episode one
	else if (mapname == "ctf1") nextmap = "ctf2";
	else if (mapname == "ctf2") nextmap = "ctf3";
	else if (mapname == "ctf3") nextmap = "ctf4";
	else if (mapname == "ctf4") nextmap = "ctf5";
	else if (mapname == "ctf5") nextmap = "ctf6";
	else if (mapname == "ctf6") nextmap = "ctf7";
	else if (mapname == "ctf7") nextmap = "ctf8";
	else if (mapname == "ctf8") nextmap = "ctfstart";

	// ctf episode two
	else if (mapname == "ctf2m1") nextmap = "ctf2m2";
	else if (mapname == "ctf2m2") nextmap = "ctf2m3";
	else if (mapname == "ctf2m3") nextmap = "ctf2m4";
	else if (mapname == "ctf2m4") nextmap = "ctf2m5";
	else if (mapname == "ctf2m5") nextmap = "ctf2m6";
	else if (mapname == "ctf2m6") nextmap = "ctf2m7";
	else if (mapname == "ctf2m7") nextmap = "ctf2m8";
	else if (mapname == "ctf2m8") nextmap = "ctfstart";
//TONY
//LoC

	else if (mapname == "ctf3m1") nextmap = "ctf3m2";
	else if (mapname == "ctf3m2") nextmap = "ctf3m3";
	else if (mapname == "ctf3m3") nextmap = "ctf3m4";
	else if (mapname == "ctf3m4") nextmap = "ctf3m5";
	else if (mapname == "ctf3m5") nextmap = "ctf3m6";
	else if (mapname == "ctf3m6") nextmap = "ctf3m7";
	else if (mapname == "ctf3m7") nextmap = "ctf3m8";
	else if (mapname == "ctf3m8") nextmap = "ctf3m9";
	else if (mapname == "ctf3m9") nextmap = "ctf3m1";

//TONY
//XENO
	else if (mapname == "xeno1") nextmap = "xeno2";
	else if (mapname == "xeno2") nextmap = "xeno3";
	else if (mapname == "xeno3") nextmap = "xeno4";
	else if (mapname == "xeno4") nextmap = "xeno6";
	else if (mapname == "xeno6") nextmap = "xeno7";
	else if (mapname == "xeno7") nextmap = "xeno8";
	else if (mapname == "xeno8") nextmap = "expctf1";
	else if (mapname == "expctf1") nextmap = "expctf2";
	else if (mapname == "expctf2") nextmap = "xeno1";
//TONY
//CTFEP
	else if (mapname == "ctf1bsp0") nextmap = "ctf1bsp1";
	else if (mapname == "ctf1bsp1") nextmap = "ctf1bsp2";
	else if (mapname == "ctf1bsp2") nextmap = "ctf1bsp3";
	else if (mapname == "ctf1bsp3") nextmap = "ctf1bsp4";
	else if (mapname == "ctf1bsp4") nextmap = "ctf1bsp5";
	else if (mapname == "ctf1bsp5") nextmap = "ctf1bsp6";
	else if (mapname == "ctf1bsp6") nextmap = "ctf1bsp7";
	else if (mapname == "ctf1bsp7") nextmap = "ctf1bsp8";
	else if (mapname == "ctf1bsp8") nextmap = "ctf1bsp9";
	else if (mapname == "ctf1bsp9") nextmap = "ctf1bspx";
	else if (mapname == "ctf1bspx") nextmap = "ctf1bsp0";


	o = spawn();
	o.map = nextmap;
	o.think = execute_changelevel;
	o.nextthink = time + 0.1;
	return;

// DISABLED from here
//TONY
//REMOVED CODE
};

float pregameover;

//TONY
//COUNTDOWN
void (float timer_f) DoTimerMessage =
{
//ÍÉÎÕÔÅÓ òåíáéîéîç ÓÅÃÏÎÄÓ °±²³´µ¶·¸¹ òåä âìõå
//MINUTES remaining SECONDS 0123456789 red blue
	local entity p;
	local string st;

	p = find(world, classname, "player");
	while (p != world)
	{
		sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
		p = find(p, classname, "player");
	}
	
	if(timer_f == 1)
		bprint("\n\n\n         ² ÍÉÎÕÔÅÓ òåíáéîéîç\n");//2 minutes
	else if(timer_f == 2)
		bprint("\n\n\n         ± ÍÉÎÕÔÅ òåíáéîéîç\n");//1 minute
	else if(timer_f == 3)
		bprint("\n\n\n        ±° ÓÅÃÏÎÄÓ òåíáéîéîç\n");//10 seconds
	else
		return; //oops

	bprint("           òåä: ");
	st = ftos(teamscr1);
	bprint(st);
	bprint("  âìõå: ");
	st = ftos(teamscr2);
	bprint(st);
	bprint("\n");
};


/*
============
CheckRules

Exit deathmatch games upon conditions
============
*/
void() CheckRules =
{
	local	float		timelimit;
	local	float		fraglimit;
	local	entity		o;

	if (gameover || pregameover)	// someone else quit the game already
		return;

	if (gamestart) {
		if ((vote_leader != world) && voteexit_time && (time > voteexit_time)) {
			pregameover = 1;
			o = spawn();
			nextmap = vote_leader.map;
			o.map = nextmap;
			o.think = execute_changelevel;
			o.nextthink = time + 0.1;
			return;
		}
		return;
	}
	
//TONY
//REMOVED RADIO.QC
//	PrepareAttackAnnouncements(FALSE);		// CTFBOT

	timelimit = cvar("timelimit") * 60;
	fraglimit = cvar("fraglimit");		

//TONY
//COUNTDOWN
	if(timelimit > 120)
	{
		if((time >= (timelimit - 120)) && (timer_flag == 0))
		{
			timer_flag = 1;
			DoTimerMessage(timer_flag);
			return;
		}
		if((time >= (timelimit - 60)) && (timer_flag == 1))
		{
			timer_flag = 2;
			DoTimerMessage(timer_flag);
			return;
		}
		if((time >= (timelimit - 10)) && (timer_flag == 2))
		{
			timer_flag = 3;
			DoTimerMessage(timer_flag);
			return;
		}
	}

//TONY
//TEMP1
	if(temp1 & TEMP1_FRAGASCAPTURE)
	{
		if (fraglimit && ((captures_red >= fraglimit) || (captures_blue >= fraglimit)))
		{
			pregameover = 1;
			level_over_time = time;		// CTFBOT
			TeamEndScore();
			NextLevel ();
			return;
		}
		if(timelimit && time >= timelimit)
		{
			pregameover = 1;
			level_over_time = time;		// CTFBOT
			TeamEndScore();
			NextLevel ();
			return;
		}
	}
	else
	{
		if ((timelimit && time >= timelimit) ||
			(fraglimit && (self.frags >= fraglimit)))
		{
			pregameover = 1;
			level_over_time = time;		// CTFBOT
			TeamEndScore();
			NextLevel ();
			return;
		}
	}
};

//============================================================================

void() PlayerDeathThink =
{
	local entity	old_self;
	local float		forward;


	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen (self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else
			self.velocity = forward * normalize(self.velocity);
	}


// wait for all buttons released
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0)
			return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}
	
// wait for any button down
	if (!self.button2 && !self.button1 && !self.button0)
		return;

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	respawn();
};


void() PlayerJump =
{
	local vector start, end;
	
	if (self.flags & FL_WATERJUMP)
		return;

	if (self.waterlevel >= 2)
	{
		if (self.watertype == CONTENT_WATER)
			self.velocity_z = 100;
		else if (self.watertype == CONTENT_SLIME)
			self.velocity_z = 80;
		else
			self.velocity_z = 50;

// play swiming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
				sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}

		return;
	}

	if (!(self.flags & FL_ONGROUND))
		return;

	if ( !(self.flags & FL_JUMPRELEASED) )
		return;		// don't pogo stick

	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);

	self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
	
	self.button2 = 0;
// player jumping sound
// tony
// sex sounds
		if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
			sound (self, CHAN_BODY, "player2/plyrjmp8.wav", 1, ATTN_NORM);
		else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
			sound (self, CHAN_BODY, "player3/plyrjmp8.wav", 1, ATTN_NORM);
		else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
			sound (self, CHAN_BODY, "player4/plyrjmp8.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
	self.velocity_z = self.velocity_z + 270;
};


/*
===========
WaterMove

============
*/
.float	dmgtime;

void() WaterMove =
{
//dprint (ftos(self.waterlevel));
	if (self.movetype == MOVETYPE_NOCLIP)
		return;
	if (self.health < 0)
		return;
	
	// CTFBOT [[[
	// optimization: don't do this every frame
	if (time < self.watermove_time)
		return;
	self.watermove_time = time + 0.3;
	// CTFBOT ]]]

	if (self.waterlevel != 3)
	{
		if (self.air_finished < time)
		{
// tony
// sex sounds
		if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
			sound (self, CHAN_VOICE, "player2/gasp2.wav", 1, ATTN_NORM);
		else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
			sound (self, CHAN_VOICE, "player3/gasp2.wav", 1, ATTN_NORM);
		else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
			sound (self, CHAN_VOICE, "player4/gasp2.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
		}
		else if (self.air_finished < time + 9)
		{
// tony
// sex sounds
		if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
			sound (self, CHAN_VOICE, "player2/gasp1.wav", 1, ATTN_NORM);
		else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
			sound (self, CHAN_VOICE, "player3/gasp1.wav", 1, ATTN_NORM);
		else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
			sound (self, CHAN_VOICE, "player4/gasp1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
		}
		self.air_finished = time + 12;
		self.dmg = 2;
	}
	else if (self.air_finished < time)
	{	// drown!
		if (self.pain_finished < time)
		{
			self.dmg = self.dmg + 2;
			if (self.dmg > 15)
				self.dmg = 10;
			T_Damage (self, world, world, self.dmg);
			self.pain_finished = time + 1;
		}
	}

	if (!self.waterlevel)
	{
		if (self.flags & FL_INWATER)
		{	
			// play leave water sound
			sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
			self.flags = self.flags - FL_INWATER;
		}
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{	// do damage
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
				self.dmgtime = time + 1;
			else
				self.dmgtime = time + 0.2;

			T_Damage (self, world, world, 10*self.waterlevel);
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{	// do damage
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;
			T_Damage (self, world, world, 4*self.waterlevel);
		}
	}
	
	if ( !(self.flags & FL_INWATER) )
	{	

// player enter water sound

		if (self.watertype == CONTENT_LAVA)
		{
// tony
// sex sounds
		if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
			sound (self, CHAN_BODY, "player2/inlava.wav", 1, ATTN_NORM);
		else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
			sound (self, CHAN_BODY, "player3/inlava.wav", 1, ATTN_NORM);
		else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
			sound (self, CHAN_BODY, "player4/inlava.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
		}
		if (self.watertype == CONTENT_WATER)
		{
// tony
// sex sounds
		if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
			sound (self, CHAN_BODY, "player2/inh2o.wav", 1, ATTN_NORM);
		else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
			sound (self, CHAN_BODY, "player3/inh2o.wav", 1, ATTN_NORM);
		else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
			sound (self, CHAN_BODY, "player4/inh2o.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
		}
		if (self.watertype == CONTENT_SLIME)
		{
// tony
// sex sounds
		if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
			sound (self, CHAN_BODY, "player2/slimbrn2.wav", 1, ATTN_NORM);
		else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
			sound (self, CHAN_BODY, "player3/slimbrn2.wav", 1, ATTN_NORM);
		else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
			sound (self, CHAN_BODY, "player4/slimbrn2.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);
		}

		self.flags = self.flags + FL_INWATER;
		self.dmgtime = 0;
	}
	
	if (! (self.flags & FL_WATERJUMP) )
		self.velocity = self.velocity - 0.8*self.waterlevel*frametime*self.velocity;
};

void() CheckWaterJump =
{
	local vector start, end;

// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + 8; 
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);
	if (trace_fraction < 1)
	{	// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);
		if (trace_fraction == 1)
		{	// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// safety net
			return;
		}
	}

};


/*
================
PlayerPreThink

Called every frame before physics are run
================
*/
void() PlayerPreThink =
{
	local	float	mspeed, aspeed;
	local	float	r;
	local	string	s;

	if (intermission_running)
	{
		IntermissionThink ();	// otherwise a button could be missed between
		return;					// the think tics
	}
	if (self.staydeadtime && self.staydeadtime > time)
		return;// wait a bit before respawn

// *TEAMPLAY*
	if (coop && TEAM_STRICT_COOP)
		return;

	TeamCapturePlayerUpdate();

//TONY
//REMOVED CAM
//	if (self.CamState) {
//		if (self.CamState > CAM_BECOME)
//			CamPreThink();
//		return;
//	}

	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale

//TONY
//YCAM
	if ((self.aflag) && (temp1 & TEMP1_YCAM))
	      YCamChasePlayer();
//	else
//		stuffcmd(self, "r_drawviewmodel 1\n");

	makevectors (self.v_angle);		// is this still used

	CheckRules ();
	WaterMove ();

	// CTFBOT [[[
//TONY
//REMOVED BOTCAM.QC
//	if (self.observer_flags & PLAYER_USING_CAMERA)		// CTFBOT BOTCAM
//		SetPlayerViewPoint(FALSE);						// CTFBOT BOTCAM

	SpawnFollowEntity();

	PrintCloseWaypoint();	
	
	if ((self.toggle_ents_time != 0) && (time > self.toggle_ents_time))
		BlinkEnts();
	// CTFBOT ]]]

// *TEAMPLAY*
// TeamCheckLock performs all necessary teamlock checking, and performs all
// actions needed.
	TeamCheckLock();

	if (self.waterlevel == 2)
		CheckWaterJump ();

	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink ();
		return;
	}

	
//ZOID-Observer
	if (self.observer) {
//TONY
//REMOVED CAM
//		if (self.CamState <= CAM_BECOME)
			ObserverThink();
		return;
	}


	if (self.deadflag == DEAD_DYING)
		return;	// dying, so do nothing

	if (self.button2)
	{
		PlayerJump ();
	}
	else
		self.flags = self.flags | FL_JUMPRELEASED;

// teleporters can force a non-moving pause time	
	if (time < self.pausetime)
		self.velocity = '0 0 0';


// RUNE: If player has rune of elder magic (4), regeneration
	if (self.player_flag & ITEM_RUNE4_FLAG) {
		if (self.regen_time < time) {
			self.regen_time = time;
			if (self.health < 150) {
				self.health = self.health + 5;
				if (self.health > 150)
					self.health = 150;
				self.regen_time = self.regen_time + 0.5;
				RegenerationSound();
			}
			if (self.armorvalue < 150 && self.armortype) {
				self.armorvalue = self.armorvalue + 5;
				if (self.armorvalue > 150)
					self.armorvalue = 150;
				self.regen_time = self.regen_time + 0.5;
				RegenerationSound();
			}
		}
	}
// RUNE

	if(time > self.attack_finished && self.currentammo == 0 && 
		self.weapon != IT_AXE && self.weapon != IT_HOOK)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
	}
};
	
/*
================
CheckPowerups

Check for turning off powerups
================
*/
void() CheckPowerups =
{
	if (self.health <= 0)
		return;

// invisibility
	if (self.invisible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invisible_sound < time)
		{
			sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}


		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				if (self.classname == "player")		// CTFBOT
					sprint (self, "Ring of Shadows magic is fading\n");
				if (self.classname == "player")		// CTFBOT
					stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}
			
			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				if (self.classname == "player")		// CTFBOT
					stuffcmd (self, "bf\n");
			}
		}

		if (self.invisible_finished < time)
		{	// just stopped
			self.items = self.items - IT_INVISIBILITY;
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}
		
	// use the eyes
		self.frame = 0;
		self.modelindex = modelindex_eyes;
	}
	else
//TONY
//MULTIWEAPONS
	{
		if(temp1 & TEMP1_MULTI)
			self.modelindex = self.modelindex_thisplayer; // MultiWeapon patch; replaces above line
		else
//TONY
//multi player model support
			set_player_main_index();
	}




// invincibility
	if (self.invincible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				if (self.classname == "player")		// CTFBOT
					sprint (self, "Protection is almost burned out\n");
				if (self.classname == "player")		// CTFBOT
					stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}
			
			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				if (self.classname == "player")		// CTFBOT
					stuffcmd (self, "bf\n");
			}
		}
		
		if (self.invincible_finished < time)
		{	// just stopped
			self.items = self.items - IT_INVULNERABILITY;
			self.invincible_time = 0;
			self.invincible_finished = 0;
		}
// ZOID, next line isn't needed, EF_DIMLIGHT is handled by
// client.qc:CheckDimLight
//		if (self.invincible_finished > time)
//			self.effects = self.effects | EF_DIMLIGHT;
//		else
//			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	}

// super damage
	if (self.super_damage_finished)
	{

// sound and screen flash when items starts to run out

		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				if (self.classname == "player")		// CTFBOT
					sprint (self, "Quad Damage is wearing off\n");
				if (self.classname == "player")		// CTFBOT
					stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}	  
			
			if (self.super_time < time)
			{
				self.super_time = time + 1;
				if (self.classname == "player")		// CTFBOT
					stuffcmd (self, "bf\n");
			}
		}

		if (self.super_damage_finished < time)
		{	// just stopped
			self.items = self.items - IT_QUAD;
			self.super_damage_finished = 0;
			self.super_time = 0;
		}
// ZOID, next line isn't needed, EF_DIMLIGHT is handled by
// client.qc:CheckDimLight
//		if (self.super_damage_finished > time)
//			self.effects = self.effects | EF_DIMLIGHT;
//		else
//			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	}	

// suit	
	if (self.radsuit_finished)
	{
		self.air_finished = time + 12;		// don't drown

// sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				if (self.classname == "player")		// CTFBOT
					sprint (self, "Air supply in Biosuit expiring\n");
				if (self.classname == "player")		// CTFBOT
					stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}
			
			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				if (self.classname == "player")		// CTFBOT
					stuffcmd (self, "bf\n");
			}
		}

		if (self.radsuit_finished < time)
		{	// just stopped
			self.items = self.items - IT_SUIT;
			self.rad_time = 0;
			self.radsuit_finished = 0;
		}
	}	

	// Check to see about DIMLIGHT effects
	CheckDimLight();
};


/*
================
PlayerPostThink

Called every frame after physics are run
================
*/
void() PlayerPostThink =
{
	local	float	mspeed, aspeed;
	local	float	r;
    local   string  num;

//TONY
//REMOVED CAM
//	if (self.CamState > CAM_BECOME) {
//		CamThink();
//		return;
//	}
//	if (self.CamState == CAM_BECOME) {
//		InitCamClient();
//		return;
//	}

	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale

	if (self.deadflag)
	{
		return;
	}

//TONY
//YCAM
	if ((self.aflag) && (temp1 & TEMP1_YCAM))
	      YCamChasePlayer();
	else
		stuffcmd(self, "r_drawviewmodel 1\n");


// do weapon stuff

	W_WeaponFrame ();

// check to see if player landed and play landing sound	
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if (self.watertype == CONTENT_WATER)
		{
// tony
// sex sounds
		if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
			sound (self, CHAN_BODY, "player2/h2ojump.wav", 1, ATTN_NORM);
		else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
			sound (self, CHAN_BODY, "player3/h2ojump.wav", 1, ATTN_NORM);
		else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
			sound (self, CHAN_BODY, "player4/h2ojump.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		}
//TONY
//DEATHMATCH
		else if ((self.jump_flag < -650) && (!(deathmatch & DM_NO_FALLING)))
		{
			T_Damage (self, world, world, 5); 
// tony
// sex sounds
		if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
			sound (self, CHAN_VOICE, "player2/land2.wav", 1, ATTN_NORM);
		else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
			sound (self, CHAN_VOICE, "player3/land2.wav", 1, ATTN_NORM);
		else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
			sound (self, CHAN_VOICE, "player4/land2.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			self.deathtype = "falling";
		}
		else
		{
// tony
// sex sounds
		if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
			sound (self, CHAN_VOICE, "player2/land.wav", 1, ATTN_NORM);
		else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
			sound (self, CHAN_VOICE, "player3/land.wav", 1, ATTN_NORM);
		else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
			sound (self, CHAN_VOICE, "player4/land.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
		}

		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;

	if(deathmatch & DM_FIXED_FOV)
		stuffcmd(self,"fov 90\n");

	CheckPowerups ();

//tony
//from EXPERT
	if (time > teamScorePrintTime)
	{
		TeamCaptureCheckUpdate();
		PrintCTFScore();
		teamScorePrintTime = time + TEAM_PRINT_DELAY;
	}
};


/*
===========
ClientConnect

called when a player connects to a server
============
*/
void() ClientConnect =
{
	
	bprint (self.netname);
	bprint (" entered the game\n");
	
	LogMsg(self, "CONNECT");

	self.motd_count = 1;

	self.suicide_count = 0;
	self.killed = 0;
	self.frags = 0;

	self.statstate = 0;
	self.aflag = 0;

	// CTFBOT [[[	
	self.num_kills = 0;			// CTFBOT EXTRAS number of kills
	self.num_deaths = 0;		// CTFBOT EXTRAS number of deaths
	self.num_suicides = 0;		// CTFBOT EXTRAS number of suicides
	self.num_captures = 0;		// CTFBOT EXTRAS number of personal flag captures 
	self.num_pickups = 0;		// CTFBOT EXTRAS number of personal enemy flag pickups
	self.num_recovery = 0;		// CTFBOT EXTRAS number of flag recoveries
	self.num_assists = 0;		// CTFBOT EXTRAS number of assists
	self.num_bonus = 0;			// CTFBOT EXTRAS number of general bonuses

	// when a real player enters the game you must set its bitflag by calling:
//TONY
//	clientSetUsed( self.colormap - 1 );		 // in ClientConnect()
	// CTFBOT ]]]
   local entity bot;

   self.fClientNo = self.colormap - 1;

   if( clientIsActive( self.fClientNo ) )
      botInvalidClientNo( self.fClientNo );

   clientSetUsed( self.fClientNo );

   bot = find( world, classname, "bot" );

   while( bot )
   {
      msgUpdateNameToPlayer( self, bot.fClientNo, bot.netname );
      msgUpdateColorsToPlayer( self, bot.fClientNo, bot.fShirt, bot.fPants );
      msgUpdateFragsToPlayer( self, bot.fClientNo, bot.frags );

      bot = find( bot, classname, "bot" );
   }


	
// *TEAMPLAY*
 	// If this is our first connection, parm10 is < 0
 	// Set lastteam negative.
 	if(parm10 < 0 && teamplay > 0)
	{
 		self.lastteam = -50;
		self.team = -1;
		if (teamplay & TEAM_CAPTURE_SELECT_TEAM)
			self.do_observer = 1;
		else if (!self.do_observer)
		{
			TeamCheckLock();
			self.player_flag = self.player_flag | TEAM_STUFF_COLOR;
			if ((teamplay & TEAM_CAPTURE_CUSTOM))
			{
				if (self.lastteam == TEAM_COLOR1)
					self.skin = 1;
				else
					self.skin = 3;
				if (random() < 0.5)
					self.skin = self.skin + 1; // visor dude
				self.player_flag = self.player_flag - (self.player_flag & 65280);
				self.player_flag = self.player_flag | (self.skin * 256);  
			}
		}
	}


// a client connecting during an intermission can cause problems
	if (intermission_running)
		ExitIntermission ();
};


/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
void() ClientDisconnect =
{
	if (gameover)
		return;
	// if the level end trigger has been activated, just return
	// since they aren't *really* leaving

	// CTFBOT when a real player leaves the game you must set its bitflag by calling:

//TONY
//RANKINGS

//FIXME?  DID I SCREW THIS UP?

	if(self.simulated_client)
	{
		clientSetFree( self.fClientNo ); // CTFBOT in ClientDisconnect()
		if(self.classname == "bot")
		{
		      msgUpdateNameToAll( self.fClientNo, string_null );
		      msgUpdateColorsToAll( self.fClientNo, 0, 0 );
		      msgUpdateFragsToAll( self.fClientNo, 0 );
			self.fClientNo = -1;
		}
	}

//TONY
//YCAM
	if(self.aflag)
		YCam();

	// let everyone else know
	bprint (self.netname);
	bprint (" left the game with ");
	bprint (ftos(self.frags));
	bprint (" frags\n");
// tony
// sex sounds
	if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
		sound (self, CHAN_BODY, "player2/tornoff2.wav", 1, ATTN_NONE);
	else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
		sound (self, CHAN_BODY, "player3/tornoff2.wav", 1, ATTN_NONE);
	else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
		sound (self, CHAN_BODY, "player4/tornoff2.wav", 1, ATTN_NONE);
	else
		sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);

	DropRune();
	TeamCaptureDropFlagOfPlayer(self);
	set_suicide_frame ();

	self.lastteam = -50;
	self.team = -50;
	self.frags = 0;

	self.statstate = 0;

//TONY
//REMOVED CAM
//	CamPlayerDisconnect();

	LogMsg(self, "DISCONNECT");
};

// *TEAMPLAY*
// Prototypes

float(entity targ, entity attacker) TeamFragPenalty;
void(entity targ, entity attacker) TeamDeathPenalty;

/*
===========
ClientObituary

called when a player dies
============
*/
void(entity targ, entity attacker) ClientObituary =
{
//TONY
//STOP BOTS FROM KILLING EACH OTHER AT END
//AND SCREWING UP THE STATS DUMP.
	if(intermission_running)
		return;

	// *XXX* EXPERT CTF variable for 
	// flag/flag carrier defense bonus determination
	local	entity head;
	local float flag_radius;
	local float flag_carrier_radius;

	local string st;		// CTFBOT

	local	float rnum;
	local	string deathstring, deathstring2, what, s;
	rnum = random();

	if (targ.classname == "player" || targ.classname == "bot")	// CTFBOT
	{

		// *XXX* EXPERT CTF: 
		// When the flag carrier dies, reset the last_hurt_carrier field in
		// all players on the opposite team from the flag carrier.  The carrier
		// has been killed, so there is no longer a reason to award points for
		// killing off his assailants
		if (targ.player_flag & ITEM_ENEMY_FLAG) {

			head = find(world, classname, "player");

			while (head != world) {	
				if (head.team != targ.team) {
					head.last_hurt_carrier = -10;
				}
				head = FindNextPlayerOrBot(head);	// CTFBOT find bots also 
			}
		}
		// END EXPERT CTF

		if (attacker.classname == "teledeath")
		{
			bprint (targ.netname);
			bprint (" was telefragged by ");
			bprint (attacker.owner.netname);
			bprint ("\n");

//TONY
//TEAMMATES SHOULDN'T GET FRAGS HERE
			if(targ.team != attacker.owner.team)
			{
				UpdateClientFrags(attacker.owner, 1);	// CTFBOT 
			}

			LogPlayerDMDeath(targ, attacker.owner, "telefrag");

			targ.num_deaths = targ.num_deaths + 1; 		// CTFBOT EXTRAS
			attacker.owner.num_kills = attacker.owner.num_kills + 1; 	// CTFBOT EXTRAS

			return;
		}

		if (attacker.classname == "teledeath2")
		{
			bprint ("Satan's power deflects ");
			bprint (targ.netname);
			bprint ("'s telefrag\n");

			UpdateClientFrags(targ, -1);	// CTFBOT 

			LogPlayerDeath(targ, "telefrag");

			targ.num_deaths = targ.num_deaths + 1; 		// CTFBOT EXTRAS
			attacker.owner.num_kills = attacker.owner.num_kills + 1; 	// CTFBOT EXTRAS

			return;
		}

		if ((attacker.classname == "player") || (attacker.classname == "bot"))	// CTFBOT
		{
			if (targ == attacker)
			{
				// killed self
				UpdateClientFrags(attacker, -1);	// CTFBOT 

				bprint (targ.netname);
				
				if (targ.weapon == 64 && targ.waterlevel > 1)
				{
					bprint (" discharges into the water.\n");
					LogPlayerDeath(targ, "discharge");
					return;
				}
				if (targ.weapon == IT_GRENADE_LAUNCHER) {
					bprint (" tries to put the pin back in\n");
					LogPlayerDeath(targ, "grenade");
				} else if (targ.team != targ.lastteam) {
					//ZOID: try if player was gibbed for changing teams
					if (teamplay & TEAM_STATIC_TEAMS)
						bprint (" tried to change teams\n");
					else
						bprint (" changed teams\n");
					LogPlayerDeath(targ, "teamchange");
				} else {
					bprint (" becomes bored with life\n");
					LogPlayerDeath(targ, "rocket");
				}

				targ.num_deaths = targ.num_deaths + 1; 		// CTFBOT EXTRAS
				targ.num_suicides = targ.num_suicides + 1; 	// CTFBOT EXTRAS

				return;
			}
			else if ( (targ.team > 0)&&(targ.team == attacker.team) )
			{
				if (rnum < 0.25)
					deathstring = " mows down a teammate\n";
				else if (rnum < 0.50)
					deathstring = " checks his glasses\n";
				else if (rnum < 0.75)
					deathstring = " gets a frag for the other team\n";
				else
					deathstring = " loses another friend\n";
				bprint (attacker.netname);
				bprint (deathstring);
				UpdateClientFrags(attacker, -1);	// CTFBOT 

				targ.num_deaths = targ.num_deaths + 1; 			// CTFBOT EXTRAS

				return;
			}
			else
			{
 				// *TEAMPLAY*
 				// TeamFragPenalty returns true if the attacker gets a frag penalty for
 				// killing this target.  It also deducts frags as needed.
 				if (!TeamFragPenalty(targ, attacker)) {

 					// the attacker is award the normal one frag.. now we 
 					// determine if he gets any bonuses
					UpdateClientFrags(attacker, 1);	// CTFBOT 
 
 					if ((targ.player_flag & ITEM_ENEMY_FLAG) &&
 						(targ.team != attacker.team)) {
 						//ZOID: one team fragged the other team's flag carrier
 
 						// *XXX* EXPERT CTF
 						// Mark the attacker with the time at which he killed the flag
 						// carrier, for awarding assist points
 
 						attacker.last_fragged_carrier = time;
 
 						// *XXX* EXPERT CTF: give player only the normal amount of frags
 						// if the carrier has only had the flag for a few seconds, to
 						// prevent ppl intentionally allowing enemies to grab the flag,
 						// then immediately fragging them
 
 						if (TEAM_CAPTURE_FRAG_CARRIER_BONUS > 0)		// CTFBOT
						{
							if (targ.flag_since + TEAM_CAPTURE_CARRIER_FLAG_SINCE_TIMEOUT > time) {
								if (attacker.classname == "player")// CTFBOT
									sprint(attacker, "Flag carrier killed, no bonus\n");	
							} else {
								UpdateClientFrags(attacker, TEAM_CAPTURE_FRAG_CARRIER_BONUS);	// CTFBOT 

										// TeamScore (attacker, TEAM_CAPTURE_FRAG_CARRIER_BONUS);
								if (attacker.classname == "player")// CTFBOT
									sprint(attacker, "Flag carrier killed: ");	// CTFBOT
								s = ftos(TEAM_CAPTURE_FRAG_CARRIER_BONUS);
								if (attacker.classname == "player")// CTFBOT
									sprint(attacker, s);	// CTFBOT EXTRAS bug fix
								if (attacker.classname == "player")// CTFBOT
									sprint(attacker, " bonus frags\n");		// CTFBOT
	 							attacker.num_bonus = attacker.num_bonus + 1;	// CTFBOT EXTRAS
							}
						}		// CTFBOT
 						// END FLAG CARRIER FRAG CODE
 					}
 					
 					// *XXX* EXPERT CTF
 					// This code checks for all game-critical kills OTHER THAN fragging the enemy
 					// flag carrier, like killing players who are trying to kill your flag carrier
 					// or trying to grab your flag, and hands out bonus frags.
 
 					// The two variables below track whether special bonus frags have already
 					// been awarded for the attacker or target being near the flag or flag carrier.  
 
 					flag_radius = 0;
 					flag_carrier_radius = 0;
 
 					// get a string for the attacker's team now, for later announcements
 					//s = GetCTFTeam(attacker.team);
 
 					s = GetTeamName(attacker.team);
 
 					if ((targ.last_hurt_carrier + TEAM_CAPTURE_CARRIER_DANGER_PROTECT_TIMEOUT > time) &&
 					    !(attacker.player_flag & ITEM_ENEMY_FLAG) ) {
 						// a player on the same team as the flag carrier killed 
 						// someone who recently shot the flag carrier
						UpdateClientFrags(attacker, TEAM_CAPTURE_CARRIER_DANGER_PROTECT_BONUS);	// CTFBOT 

 						flag_carrier_radius = 1;
 						// NOTE: getting CARRIER_DANGER_PROTECT_BONUS precludes getting
 						// other kinds of bonuses for defending the flag carrier, since
 						// it's worth more points
 						bprint(attacker.netname);
 						bprint(" defends ");
 						bprint(s);
 						bprint("'s flag carrier against an agressive enemy\n");

 						attacker.num_bonus = attacker.num_bonus + 1;	// CTFBOT EXTRAS
 					}
 
 					// *XXX* EXPERT CTF
 					// Bonusus for defending the flag carrier or the flag itself.
 					// Extra frags are awarded if either the attacker or the target are
 					// 1. within 40 feet of a flag carrier on the same team as the attacker
 					// 2. within 40 feet of the attacker's flag
 					// These bonuses are cumulative with respect to defending both the
 					// flag and the flag carrier at the same time, but not cumulative with
 					// respect to both the target and attacker being near the object being defended
 
 					// find flags or flag carriers within a radius of the attacker
 					head = findradius(attacker.origin, TEAM_CAPTURE_ATTACKER_PROTECT_RADIUS);
 
 					while (head) {
 						if (head.classname == "player") {
 							if ( (head.team == attacker.team) &&
 							     (head.player_flag & ITEM_ENEMY_FLAG) &&
 							     (head != attacker) && // self defense
 							     (!flag_carrier_radius) ) { 
								// attacker was near his own flag carrier
								UpdateClientFrags(attacker, TEAM_CAPTURE_CARRIER_PROTECT_BONUS);	// CTFBOT 

 								flag_carrier_radius = 1;
 								bprint(attacker.netname);
 								bprint(" defends ");
 								bprint(s);
 								bprint("'s flag carrier\n");
								
  								attacker.num_bonus = attacker.num_bonus + 1;	// CTFBOT EXTRAS
 							}
 						}
 						if ( (head.classname == "item_flag_team1") ||
 						     (head.classname == "item_flag_team2")) {
 							if (((attacker.team == TEAM_COLOR1) &&
								(head.classname == "item_flag_team1")) ||
 								((attacker.team == TEAM_COLOR2) &&
 								(head.classname == "item_flag_team2"))) { 
								// attacker was near his own flag
								UpdateClientFrags(attacker, TEAM_CAPTURE_FLAG_DEFENSE_BONUS);	// CTFBOT 
 								flag_radius = 1; 
 								bprint(attacker.netname);
 								bprint(" defends the ");
 								bprint(s);
 								bprint(" flag\n");
								
  								attacker.num_bonus = attacker.num_bonus + 1;	// CTFBOT EXTRAS
 							}
 						}
 						head = head.chain;
 					}
 
 					// find flags or flag carriers within a radius from the target
 					head = findradius(targ.origin, TEAM_CAPTURE_TARGET_PROTECT_RADIUS);
 					while (head) {
 						if (head.classname == "player") {
 							if ( (head.team == attacker.team) &&
 							     (head.player_flag & ITEM_ENEMY_FLAG) &&
 							     (head != attacker) &&
 							     (!flag_carrier_radius)) { // prevents redundant points awarded
 								// target was near attacker's flag carrier
								UpdateClientFrags(attacker, TEAM_CAPTURE_CARRIER_PROTECT_BONUS);	// CTFBOT 
 								flag_carrier_radius = 1;
 								bprint(attacker.netname);
 								bprint(" defends ");
 								bprint(s);
 								bprint("'s flag carrier\n");
								
  								attacker.num_bonus = attacker.num_bonus + 1;	// CTFBOT EXTRAS
 							}
 						}
						if (((attacker.team == TEAM_COLOR1) &&
							(head.classname == "item_flag_team1")) ||
							((attacker.team == TEAM_COLOR2) &&
							(head.classname == "item_flag_team2"))
							&& (!flag_radius)) { // prevents redundant points awarded
							// target was near attacker's flag
							UpdateClientFrags(attacker, TEAM_CAPTURE_FLAG_DEFENSE_BONUS);	// CTFBOT 
							flag_radius = 1;
							bprint(attacker.netname);
							bprint(" defends the ");
							bprint(s);
							bprint(" flag\n");
							
  							attacker.num_bonus = attacker.num_bonus + 1;	// CTFBOT EXTRAS
						}
 						head = head.chain;
 					}
 				}	
 			 
 				// *XXX* EXPERT CTF 
 				// End frag determination code.  Now determine death text for
 				// a member of one team killing a member of the other
 
 				// *TEAMPLAY*
 				// TeamDeathPenalty kills the attacker if necessary and adjusts frags to
 				// offset the one frag penalty for dying.
				TeamDeathPenalty(targ, attacker);

				rnum = attacker.weapon;
				
				if (rnum == IT_AXE)
				{
					deathstring = " was ax-murdered by ";
					deathstring2 = "\n";
					what = "axe";
				}
				if (rnum == IT_HOOK) {
					if (random() < 0.5)
						deathstring = " was disembowled by ";
					else
						deathstring = " was hooked by ";
					deathstring2 = "\n";
					what = "hook";
				}
				if (rnum == IT_SHOTGUN)
				{
					deathstring = " chewed on ";
					deathstring2 = "'s boomstick\n";
					what = "shotgun";
				}
				if (rnum == IT_SUPER_SHOTGUN)
				{
					deathstring = " ate 2 loads of ";
					if (targ.health < -40)
						deathstring = " ate a box of ";
					deathstring2 = "'s buckshot\n";
					what = "supershotgun";
				}
				if (rnum == IT_NAILGUN)
				{
					deathstring = " was nailed by ";
					deathstring2 = "\n";
					what = "nailgun";
				}
				if (rnum == IT_SUPER_NAILGUN)
				{
					deathstring = " was punctured by ";
					deathstring2 = "\n";
					what = "supernailgun";
				}
				if (rnum == IT_GRENADE_LAUNCHER)
				{
					deathstring = " eats ";
					deathstring2 = "'s pineapple\n";
					if (targ.health < -40)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s grenade\n";
					}
					what = "grenade";
				}
				if (rnum == IT_ROCKET_LAUNCHER)
				{
					if (attacker.items & IT_QUAD) {
						deathstring = " was destroyed by ";
						deathstring2 = "'s Quad rocket\n";
					} else {
						deathstring = " rides ";
						deathstring2 = "'s rocket\n";
						if (targ.health < -40)
						{
							deathstring = " was gibbed by ";
							deathstring2 = "'s rocket\n" ;
						}
					}
					what = "rocket";
				}
				if (rnum == IT_LIGHTNING)
				{
					if (attacker.items & IT_QUAD) {
						deathstring = " was touched by ";
						deathstring2 = "'s Quad lightning\n";
					} else {
						deathstring = " accepts ";
						if (attacker.waterlevel > 1)
							deathstring2 = "'s discharge\n";
						else
							deathstring2 = "'s shaft\n";
					}
					what = "lightning";
				}
				bprint (targ.netname);
				
				// CTFBOT [[[
				if ((targ.classname == "bot") && (!bots_have_normal_names))
				{
					st = ftos(targ.bot_skill);
					bprint(" [skill ");
					bprint(st);
					bprint("]");
				}
				// CTFBOT ]]]


				bprint (deathstring);
				bprint (attacker.netname);

				// CTFBOT [[[
				if ((attacker.classname == "bot") && (!bots_have_normal_names))
				{
					st = ftos(attacker.bot_skill);
					bprint(" [skill ");
					bprint(st);
					bprint("]");
				}
				// CTFBOT ]]]

				bprint (deathstring2);
				LogPlayerDMDeath(targ, attacker, what);
				
				targ.num_deaths = targ.num_deaths + 1; 			// CTFBOT EXTRAS
				attacker.num_kills = attacker.num_kills + 1; 	// CTFBOT EXTRAS
			
				// CTFBOT [[[
				if ((targ.classname == "player") && (attacker.classname == "bot"))
				{
					attacker.last_kill_time = time;
					attacker.last_kill_ent = targ;
				}
				if ((targ.classname == "bot") && (attacker.classname == "player"))
				{
					targ.last_die_time = time;
					targ.last_die_ent = attacker;
				}
				// CTFBOT ]]]
			}
			return;
		}
		else
		{
			UpdateClientFrags(targ, -1);	// CTFBOT 

			targ.num_deaths = targ.num_deaths + 1; 		// CTFBOT EXTRAS

			bprint (targ.netname);

			// killed by a montser?
			/* CTFBOT remove this, no monsters
			if (attacker.flags & FL_MONSTER)
			{
				if (attacker.classname == "monster_army") {
					bprint (" was shot by a Grunt\n");
					LogPlayerDeath(targ, "grunt");
				} else if (attacker.classname == "monster_demon1") {
					bprint (" was eviscerated by a Fiend\n");
					LogPlayerDeath(targ, "fiend");
				} else if (attacker.classname == "monster_dog") {
					bprint (" was mauled by a Rottweiler\n");
					LogPlayerDeath(targ, "dog");
				} else if (attacker.classname == "monster_dragon") {
					bprint (" was fried by a Dragon\n");
					LogPlayerDeath(targ, "dragon");
				} else if (attacker.classname == "monster_enforcer") {
					bprint (" was blasted by an Enforcer\n");
					LogPlayerDeath(targ, "enforcer");
				} else if (attacker.classname == "monster_fish") {
					bprint (" was fed to the Rotfish\n");
					LogPlayerDeath(targ, "fish");
				} else if (attacker.classname == "monster_hell_knight") {
					bprint (" was slain by a Death Knight\n");
					LogPlayerDeath(targ, "deathknight");
				} else if (attacker.classname == "monster_knight") {
					bprint (" was slashed by a Knight\n");
					LogPlayerDeath(targ, "knight");
				} else if (attacker.classname == "monster_ogre") {
					bprint (" was destroyed by an Ogre\n");
					LogPlayerDeath(targ, "ogre");
				} else if (attacker.classname == "monster_oldone") {
					bprint (" became one with Shub-Niggurath\n");
					LogPlayerDeath(targ, "shub");
				} else if (attacker.classname == "monster_shalrath") {
					bprint (" was exploded by a Vore\n");
					LogPlayerDeath(targ, "vore");
				} else if (attacker.classname == "monster_shambler") {
					bprint (" was smashed by a Shambler\n");
					LogPlayerDeath(targ, "shambler");
				} else if (attacker.classname == "monster_tarbaby") {
					bprint (" was slimed by a Spawn\n");
					LogPlayerDeath(targ, "spawn");
				} else if (attacker.classname == "monster_vomit") {
					bprint (" was vomited on by a Vomitus\n");
					LogPlayerDeath(targ, "vomitus");
				} else if (attacker.classname == "monster_wizard") {
					bprint (" was scragged by a Scrag\n");
					LogPlayerDeath(targ, "scrag");
				} else if (attacker.classname == "monster_zombie") {
					bprint (" joins the Zombies\n");
					LogPlayerDeath(targ, "zombie");
				}

				return;
			}
			*/ // CTFBOT
			
			// tricks and traps
			if (attacker.classname == "explo_box")
			{
				bprint (" blew up\n");
				LogPlayerDeath(targ, "explosion");
				return;
			}
			if (attacker.solid == SOLID_BSP && attacker != world)
			{	
				bprint (" was squished\n");
				LogPlayerDeath(targ, "squished");
				return;
			}
			if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter")
			{
				bprint (" was spiked\n");
				LogPlayerDeath(targ, "spiked");
				return;
			}
			if (attacker.classname == "fireball")
			{
				bprint (" ate a lavaball\n");
				LogPlayerDeath(targ, "fireball");
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				bprint (" tried to leave\n");
				LogPlayerDeath(targ, "noexit");
				return;
			}

			// in-water deaths
			rnum = targ.watertype;
			if (rnum == -3)
			{
				if (random() < 0.5)
					bprint (" sleeps with the fishes\n");
				else
					bprint (" sucks it down\n");
				LogPlayerDeath(targ, "drowned");
				return;
			}
			else if (rnum == -4)
			{
				if (random() < 0.5)
					bprint (" gulped a load of slime\n");
				else
					bprint (" can't exist on slime alone\n");
				LogPlayerDeath(targ, "slimed");
				return;
			}
			else if (rnum == -5)
			{
				if (targ.health < -15)
				{
					bprint (" burst into flames\n");
					LogPlayerDeath(targ, "melted");
					return;
				}
				if (random() < 0.5)
					bprint (" turned into hot slag\n");
				else
					bprint (" visits the Volcano God\n");
				LogPlayerDeath(targ, "melted");
				return;
			}

			// fell to their death?
			if (targ.deathtype == "falling")
			{
				targ.deathtype = "";
				bprint (" fell to his death\n");
				LogPlayerDeath(targ, "falling");
				return;
			}

			// hell if I know; he's just dead!!!
			LogPlayerDeath(targ, "died");
			bprint (" died\n");
		}
	}
};
