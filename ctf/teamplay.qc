/****************************************************************************
 * ThreeWave Capture The Flag
 ****************************************************************************
 * Based on John Spikles Complete Enhanced Teamplay
 ****************************************************************************
 * Version 4.0 rewrite Mar 21, 1997
 ****************************************************************************/

/** Defs **/

/** MODIFIABLE CONSTANTS **/

float TEAM_DEFAULT_PENALTY =    1;      // Default frag penalty
float TEAM_STRICT_COOP =	0;	// Strict Coop

// Allowed team colors
// -1 indicates no color

float TEAM_COLOR1       =       5;			// RED
float TEAM_COLOR2       =       14;			// BLUE

float team1shirt;
float team2shirt;

/** End of MODIFIABLE CONSTANTS **/

// Globals

entity team1_lastspawn;
entity team2_lastspawn;
float	nextteamupdtime;	// time until next team update
  
// Teamplay bitfield entries

float TEAM_HEALTH_PROTECT =     1;      // No health damage from friendly fire
float TEAM_ARMOR_PROTECT =      2;      // No armor damage from friendly fire
float TEAM_ATTACKER_DAMAGE =    4;      // Attacker takes damage from hitting teammates
float TEAM_FRAG_PENALTY =       8;      // One frag penalty for killing teammate
float TEAM_DEATH_PENALTY =      16;     // Die when you kill a teammate.
float TEAM_STATIC_TEAMS =       64;     // Don't allow players to switch teams
float TEAM_DROP_ITEMS = 		128;	// Allow players to drop packs and 
float TEAM_CAPTURE_CUSTOM = 	512;	// custom models
float TEAM_CAPTURE_SELECT_TEAM = 1024; // team selection

// CTFBOT [[[
float TEAM_CAPTURE_CTFBOT_ADMIN = 2048;			// CTFBOT enable ctf bot admin functions
//float TEAM_CAPTURE_AUTO_EVEN_TEAMS = 4096;		// CTFBOT always keep teams even
float TEAM_NO_RUNE_DROP = 8192;					// CTFBOT disable rune dropping
float TEAM_CAPTURE_NO_BOT_FLAG_PICKUP = 16384;	// CTFBOT disable bot flag pickups


//TONY
//I DONT THINK THIS THING EVEN WORKS AND I NEED ANOTHER FLAG
//float TEAM_FIX_BOT_COLORS = 32768;				// CTFBOT 

//MAYBE
//float TEAM_DISABLE_HOOK = ;


float TEAM_NO_FLAG_TOSS = 65536;
//oat TEAM_DAMAGE_THE_FLAG = 131072;			// CTFBOT DTF
// CTFBOT ]]]

float TEAM_CAPTURE_CAPTURE_BONUS = 15; // what you get for capture
float TEAM_CAPTURE_TEAM_BONUS = 10; // what your team gets for capture
float TEAM_CAPTURE_RECOVERY_BONUS = 1; // what you get for recovery
float TEAM_CAPTURE_FLAG_BONUS = 0; // what you get for picking up enemy flag
float TEAM_CAPTURE_FRAG_CARRIER_BONUS = 2; // what you get for fragging
	//enemy flag carrier
float TEAM_CAPTURE_FLAG_RETURN_TIME = 40; // seconds until auto return

// XXX EXPERT CTF Additional scoring system

// bonuses

float TEAM_CAPTURE_CARRIER_DANGER_PROTECT_BONUS = 2; // bonus for fraggin someone
// who has recently hurt your flag carrier
float TEAM_CAPTURE_CARRIER_PROTECT_BONUS = 1; // bonus for fraggin someone while
// either you or your target are near your flag carrier
float TEAM_CAPTURE_FLAG_DEFENSE_BONUS = 1; // bonus for fraggin someone while
// either you or your target are near your flag
float TEAM_CAPTURE_RETURN_FLAG_ASSIST_BONUS = 1; // awarded for returning a flag that causes a
// capture to happen almost immediately
float TEAM_CAPTURE_FRAG_CARRIER_ASSIST_BONUS = 2; // award for fragging a flag carrier if a
// capture happens almost immediately

// radii

float TEAM_CAPTURE_TARGET_PROTECT_RADIUS = 550; // the radius around an object being
// defended where a target will be worth extra frags
float TEAM_CAPTURE_ATTACKER_PROTECT_RADIUS = 550; // the radius around an object being
// defended where an attacker will get extra frags when making kills

// timeouts

float TEAM_CAPTURE_CARRIER_DANGER_PROTECT_TIMEOUT = 4;
float TEAM_CAPTURE_CARRIER_FLAG_SINCE_TIMEOUT = 2;
float TEAM_CAPTURE_FRAG_CARRIER_ASSIST_TIMEOUT = 6;
float TEAM_CAPTURE_RETURN_FLAG_ASSIST_TIMEOUT = 4;

float TEAM_CAPTURE_UPDATE_TIME = 120;

// END EXPERT CTF

// flag status used in cnt field of flag
float FLAG_AT_BASE = 0;
float FLAG_CARRIED = 1;
float FLAG_DROPPED = 2;


// Prototypes
float() W_BestWeapon;
void() W_SetCurrentAmmo;
void() bound_other_ammo;
void(float o, float n) Deathmatch_Weapon;
void() BackpackTouch;
void(entity who, string s) TeamPlayerUpdate;
void() TeamCaptureResetUpdate;

// Return a name for the color of a team
string(float Team) GetTeamColor =
{
	if(Team == 0) return("Blue");
	else if(Team == 1) return("Steel blue");
	else if(Team == 2) return("Brown");
	else if(Team == 3) return("Baby blue");
	else if(Team == 4) return("Green");
	else if(Team == 5) return("Red");
	else if(Team == 6) return("Olive");
	else if(Team == 7) return("Orange");
	else if(Team == 8) return("Peech");
	else if(Team == 9) return("Purple");
	else if(Team == 10) return("Majenta");
	else if(Team == 11) return("Grey");
	else if(Team == 12) return("Aqua");
	else if(Team == 13) return("Yellow");
	else if(Team == 14) return("Blue");
	return "Unknown";
};

// *XXX* EXPERT CTF
// Just a quickie to return the ASCII-ized team names for CTF
string(float Team) GetCTFTeam =
{
	if (Team == TEAM_COLOR1) return "“≈ƒ";
	if (Team == TEAM_COLOR2) return "¬Ã’≈";
	return "";
};

/*
================
TeamArmorDam

Return TRUE if the target's armor can take damage from this attacker.
================
*/

float(entity targ, entity inflictor, entity attacker, float damage) TeamArmorDam =
{
        if ((teamplay < 0) || gamestart)
                return TRUE;

        if( (teamplay & TEAM_ARMOR_PROTECT) && 
			(attacker.lastteam == targ.lastteam) && 
			(attacker != targ) && (targ.lastteam > 0) )
        {
                // Armor is protected
                return FALSE;
        }
        return TRUE;
};

/*
================
TeamHealthDam

Return TRUE if the target can take health damage from this attacker.
================
*/

float(entity targ, entity inflictor, entity attacker, float damage) TeamHealthDam =
{
        if ((teamplay < 0) || gamestart)
                return TRUE;

		// CTFBOT DTF [[[
		// flag damage always taken, regardless of teamplay settings
		if ((attacker.classname == "item_flag_team1") 
			|| (attacker.classname == "item_flag_team2"))
			return TRUE;
		// CTFBOT DTF ]]]

        if( (attacker.lastteam == targ.lastteam) && 
			(attacker != targ) && (targ.lastteam > 0) ) {
                // Attacker and target are on the same team.
                if( teamplay & TEAM_ATTACKER_DAMAGE )
                {
                        // Damage applied to teammate.
                        T_Damage(attacker, inflictor, attacker, damage);
                }
                if( teamplay & TEAM_HEALTH_PROTECT )
                {
                        // Health is protected
                        return FALSE;
                }
        }
        return TRUE;
};

/*
================
TeamPFrags

Return the number of frags we should penalize attacker for killing targ.
================
*/

float(entity targ, entity attacker) TeamPFrags =
{
        if( teamplay < 0 )
                return (-1 * teamplay);
        if( (targ.lastteam > 0) && (targ != attacker) && (targ.lastteam ==
			attacker.lastteam) )
        {
                // targ and attacker are on the same team
                if( teamplay < 0 )
                {
                        // teamplay indicates frag penalty
                        return ( -1 * teamplay );
                }
                if( teamplay & TEAM_FRAG_PENALTY )
                {
                        // default penalty
                        return TEAM_DEFAULT_PENALTY;
                }
        }
        // No frag penalty
        return 0;
};

/*
================
TeamFragPenalty

If attacker should be penalized for killing targ, penalize attacker
and return TRUE.
================
*/

float(entity targ, entity attacker) TeamFragPenalty =
{
        local float f;

        f = TeamPFrags(targ, attacker);

        if( f )
        {
                // We should penalize some frags.
				UpdateClientFrags(attacker, 0 - f);	// CTFBOT 

                return TRUE;
        }
        // No penalty
        return FALSE;
};

/*
=================
TeamDeathPenalty

If attacker should be killed for killing targ, kill attacker and
add a frag to offset the one attacker will lose for killing himself.
*/

void(entity targ, entity attacker) TeamDeathPenalty =
{
        //Don't kill anyone if teamplay is negative.
        if ( teamplay < 0 )
                return;

        if ( (teamplay & TEAM_DEATH_PENALTY) && (targ.lastteam > 0) &&
			(attacker != targ) && (attacker.lastteam == targ.lastteam) )
        {
                //We should kill the attacker.
                T_Damage(attacker,attacker,attacker,50000);	// CTFBOT EXTRAS increased
                //Add a frag to offset the self-kill penalty.
				UpdateClientFrags(attacker, 1);	// CTFBOT 
        }
};

/*
==================
TeamColorIsLegal

Return TRUE if the indicated color is legal
==================
*/
float(float color) TeamColorIsLegal =
{
        // All colors are legal if teamplay is negative.
        if( teamplay < 0 )
                return TRUE;
        if( (color == TEAM_COLOR1) && (TEAM_COLOR1 >= 0) )
                return TRUE;
        if( (color == TEAM_COLOR2) && (TEAM_COLOR2 >= 0) )
                return TRUE;
};

// CTFBOT bug fix, no crossdressers, not even "semi-crossdressers" [[[

//TONY
//added ent to see if bot or not

float(float t,entity ent) TeamGetShirt =
{
	if (t == TEAM_COLOR1) {
//TONY
//GL BOTS
//We don't want any shirt color 
//tony
//took this out
//12-22-98
//		if((temp1 & TEMP1_USEGLBOTMODEL) && (ent.classname == "bot"))
//			return 4;

		team1shirt = team1shirt + 1;
		if (team1shirt == (TEAM_COLOR2 - 1))	// crossdresser
			team1shirt = team1shirt + 1;
		if (team1shirt == 2)					// sky blue
			team1shirt = team1shirt + 1;
		if (team1shirt > 14)
			team1shirt = 0;
		return team1shirt;
	} else { // color2
//TONY
//GL BOTS
//We don't want any shirt color 
//tony
//took this out
//12-22-98
//		if((temp1 & TEMP1_USEGLBOTMODEL) && (ent.classname == "bot"))
//			return 13;


		team2shirt = team2shirt + 1;
		if (team2shirt == (TEAM_COLOR1 - 1))	// crossdresser
			team2shirt = team2shirt + 1;		
		if (team2shirt == 6)					// light salmon
			team2shirt = team2shirt + 1;		
		if (team2shirt > 14)
			team2shirt = 0;
		return team2shirt;
	}
	return t - 1;
};
// CTFBOT ]]]

/*
==================
TeamCheckTeam

Check if the team self is on is legal, and put self in a legal team if not.
==================
*/
void() TeamCheckTeam =
{
	local float TEAM1;
	local float TEAM2;
	
	if (self.classname != "player")		// CTFBOT
		return;							// CTFBOT

	local float newcolor;
	local float t;

	local entity p;

	local string n; 

	if( self.lastteam >= 0 )
	{
		if(TeamColorIsLegal(self.team))
		{
			self.lastteam = self.team;
			return;
		}
	}

	// Assign the player to a team.

	// Sum the players on all the teams.

	TEAM1 = 0;
	TEAM2 = 0;

	p = find (world, classname, "player");

	while(p)
	{
		if (p != self) {
			if (p.team == TEAM_COLOR1)
				TEAM1 = TEAM1 + 1;
			else if (p.team == TEAM_COLOR2)
				TEAM2 = TEAM2 + 1;
		}
		p = find(p, classname, "player");
	}

	// Find the team with the least players.
	newcolor = TEAM_COLOR1;
	if (((TEAM2 < TEAM1) || (TEAM2 == TEAM1 && random() < 0.5)))
		newcolor = TEAM_COLOR2;

	// Put the player on a the new team.

	stuffcmd(self, "color ");
	t = TeamGetShirt(newcolor,self);
	n = ftos(t);
	stuffcmd(self, n);
	stuffcmd(self, " ");
	n = ftos(newcolor - 1);
	stuffcmd(self, n);
	stuffcmd(self, "\n");

	self.lastteam = newcolor;      // Remember what team we're on
	self.team = newcolor;

//TONY
//assign the proper skin
//message the player of the team change
//frags to 0
	if (self.lastteam == TEAM_COLOR1)
	{
		bprint(self.netname);
		bprint(" has joined the Red team\n");
		self.skin = 1;
		self.frags = 0;
	}
	else
	{
		bprint(self.netname);
		bprint(" has joined the Blue team\n");
		self.skin = 3;
		self.frags = 0;
	}
};

/*
===============
TeamCheckLock

Check for team changing and perform whatever actions are neccessary.
===============
*/
void() TeamCheckLock =
{
	local   float   n;
	local   string  s;
	
	if (self.classname != "player")		// CTFBOT
		return;							// CTFBOT

	// Don't do anything if teamplay is negative
	if ( teamplay < 0 )
			return;
	
	if (self.observer || self.do_observer || gamestart)
	{
		if (self.team != 1)
			stuffcmd(self, "color 0\n");
		self.lastteam = 1;
		return;
	}

	if (self.player_flag & TEAM_STUFF_COLOR)
	{
		self.player_flag = self.player_flag - TEAM_STUFF_COLOR;
		stuffcmd(self, "color ");
		n = TeamGetShirt(self.lastteam,self);
		s = ftos(n);
		stuffcmd(self, s);
		stuffcmd(self, " ");
		n = self.lastteam - 1;
		s = ftos(n);
		stuffcmd(self, s);
		stuffcmd(self, "\n");
		return;
	}

	if ( !TeamColorIsLegal(self.team) && (self.team == self.lastteam))
	{
		self.lastteam = -1;
	}

	// Check to see if the player has changed colors
	if (self.team != self.lastteam)
	{
		// Player has changed colors

		// If teams are static and we've been on some team already,
		// put us back on the team we were on.

		if ( (teamplay & TEAM_STATIC_TEAMS) && (self.lastteam >= 0) )
		{
			if ( TeamColorIsLegal(self.lastteam) )
			{
				// changing teams sucks, kill him

				// if he has tried to change teams several
				// times, kick him off the server.
				if (self.suicide_count > 3) {
					sprint(self, "You were told you can't change teams.\nGo play color games somewhere else.\n");
					stuffcmd(self, "disconnect\n");
					bprint(self.netname);
					bprint(" has bad color sense\n");
				}
				// case base respawn
				if (self.killed != 1)
					self.killed = 2;
				self.invincible_finished = 0;
				T_Damage(self,self,self,50000);  // Kill the player CTFBOT EXTRAS increased
				// trying to change teams counts as a suicide
				self.suicide_count = self.suicide_count + 1;

				sprint(self, "You cannot change teams.\n");
				stuffcmd(self, "color ");
				n = TeamGetShirt(self.lastteam,self);
				s = ftos(n);
				stuffcmd(self, s);
				stuffcmd(self, " ");
				n = self.lastteam - 1;
				s = ftos(n);
				stuffcmd(self, s);
				stuffcmd(self, "\n");
				self.team = self.lastteam;
				return;
			}
			else
			{
				// If we're on an illegal team, force a change.
				self.lastteam = -50;
			}
		}

		if(self.lastteam > 0)
		{
			// case base respawn
			if (self.killed != 1)
				self.killed = 2;
			if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))		// CTFBOT don't kill if admin
				T_Damage(self,self,self,50000);  // CTFBOT EXTRAS Kill the player
		}
		self.frags = 0;                 // Zero out frags
		TeamCheckTeam();
	}
};

/*
=======================
TossBackPack

Original idea by Vhold
Rewritten by John Spickes

Toss out a backpack containing some ammo from your current weapon,
and any weapons you don't have.
=======================
*/
void() TossBackpack =
{
	local entity 	item;

	// If we don't have any ammo, return
	if(self.currentammo <= 0)
		return;

	item = spawn();

	// See if you have the Shotgun or Super Shotgun on
        if ( (self.weapon == IT_SHOTGUN) || (self.weapon == IT_SUPER_SHOTGUN)) {
		if( self.ammo_shells >= 20 ) {
			item.ammo_shells = 20;
			self.ammo_shells = self.ammo_shells - 20;
		}
		else
		{
			item.ammo_shells = self.ammo_shells;
			self.ammo_shells = 0;
		}
	}		
	
	// See if you have neither the Shotgun or Super Shotgun
        if ( !(self.items & IT_SHOTGUN) && !(self.items & IT_SUPER_SHOTGUN)) {
		if( self.ammo_shells >= 20 ) {
			item.ammo_shells = 20;
			self.ammo_shells = self.ammo_shells - 20;
		}
		else
		{
			item.ammo_shells = self.ammo_shells;
			self.ammo_shells = 0;
		}
	}		
	
	// See if we are using a nailgun
        if ( (self.weapon == IT_NAILGUN) || (self.weapon == IT_SUPER_NAILGUN) )
	{
		if( self.ammo_nails >= 20 )
		{
			item.ammo_nails = 20;
			self.ammo_nails = self.ammo_nails - 20;
		}
		else
		{
			item.ammo_nails = self.ammo_nails;
			self.ammo_nails = 0;
		}
	}	
	// Check to see if we have neither nailgun
        if ( !(self.items & IT_NAILGUN) && !(self.items & IT_SUPER_NAILGUN) )
	{
		if( self.ammo_nails >= 20 )
		{
			item.ammo_nails = 20;
			self.ammo_nails = self.ammo_nails - 20;
		}
		else
		{
			item.ammo_nails = self.ammo_nails;
			self.ammo_nails = 0;
		}
	}	
	
	// See if we are using a grenade or rocket launcher
        if ( (self.weapon == IT_GRENADE_LAUNCHER) || (self.weapon == IT_ROCKET_LAUNCHER) )
	{
		if( self.ammo_rockets >= 10 )
		{
			item.ammo_rockets = 10;
			self.ammo_rockets = self.ammo_rockets - 10;
		}
		else
		{
			item.ammo_rockets = self.ammo_rockets;
			self.ammo_rockets = 0;
		}
	}
	// See if we have neither the Grenade or rocket launcher
        if ( !(self.items & IT_GRENADE_LAUNCHER) && !(self.items & IT_ROCKET_LAUNCHER) )
	{
		if( self.ammo_rockets >= 10 )
		{
			item.ammo_rockets = 10;
			self.ammo_rockets = self.ammo_rockets - 10;
		}
		else
		{
			item.ammo_rockets = self.ammo_rockets;
			self.ammo_rockets = 0;
		}
	}

	// See if we're using the lightning gun
	if ( self.weapon == IT_LIGHTNING )
	{	
		if( self.ammo_cells >= 20 )
		{
			item.ammo_cells = 20;
			self.ammo_cells = self.ammo_cells - 20;
		}
		else
		{
			item.ammo_cells = self.ammo_cells;
			self.ammo_cells = 0;
		}
	}
	// see if we don't have the lightning gun
        if ( !(self.items & IT_LIGHTNING) )
	{	
		if( self.ammo_cells >= 20 )
		{
			item.ammo_cells = 20;
			self.ammo_cells = self.ammo_cells - 20;
		}
		else
		{
			item.ammo_cells = self.ammo_cells;
			self.ammo_cells = 0;
		}
	}
	 
	item.owner = self;
	makevectors(self.v_angle);

	setorigin(item, self.origin + '0 0 16');
	item.velocity = aim(self, 1000);
	item.velocity = item.velocity * 500;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_BOUNCE;

	setmodel (item, "progs/backpack.mdl");
	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	item.nextthink = time + 120;	// remove after 2 minutes
	item.think = SUB_Remove;

	W_SetCurrentAmmo();

	item.bot_wants_item = TRUE;		// CTFBOT optimization

	item.classname = "backpack";	// CTFBOT give backpacks a class name
									// CTFBOT so bots can see them
	item.netname = "backpack";		// CTFBOT give backpacks a net name
									// CTFBOT for better debug messages
};

void() Team_weapon_touch =
{
	local	float	hadammo, best, new, old;
	local entity stemp;

	if (!(other.flags & FL_CLIENT))
		return;
	// Don't let the owner pick up his own weapon for a second.
	if ( (other == self.owner) && ( (self.nextthink - time) > 119 ) )
		return;

// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

	if (self.classname == "weapon_nailgun")
	{
		hadammo = other.ammo_nails;			
		new = IT_NAILGUN;
	}
	else if (self.classname == "weapon_supernailgun")
	{
		hadammo = other.ammo_rockets;			
		new = IT_SUPER_NAILGUN;
	}
	else if (self.classname == "weapon_supershotgun")
	{
		hadammo = other.ammo_rockets;			
		new = IT_SUPER_SHOTGUN;
	}
	else if (self.classname == "weapon_rocketlauncher")
	{
		hadammo = other.ammo_rockets;			
		new = IT_ROCKET_LAUNCHER;
	}
	else if (self.classname == "weapon_grenadelauncher")
	{
		hadammo = other.ammo_rockets;			
		new = IT_GRENADE_LAUNCHER;
	}
	else if (self.classname == "weapon_lightning")
	{
		hadammo = other.ammo_rockets;			
		new = IT_LIGHTNING;
	}
	else
		objerror ("Team_weapon_touch: unknown classname");

	if (other.classname == "player")	// CTFBOT
	{
	if(!(temp1 & TEMP1_NOMESS))
	{
		sprint (other, "You got the ");
		sprint (other, self.netname);
		sprint (other, "\n");
		stuffcmd (other, "bf\n");
	}
	}// CTFBOT
	
// weapon touch sound
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);// CTFBOT

	bound_other_ammo ();

// change to the weapon
	old = other.items;
	other.items = other.items | new;
	
	remove(self);
	self = other;

	if (!deathmatch)
		self.weapon = new;
	else
		Deathmatch_Weapon (old, new);

	W_SetCurrentAmmo();

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


//flags == we're tossing
//else, were dying and tossing
void() TossWeapon =
{
	local entity item;

	if (!(deathmatch  & DM_WEAPONS_STAY))
		return;  // only in deathmatch 1

	if((self.weapon == IT_AXE) || (self.weapon == IT_SHOTGUN) ||
		(self.weapon == IT_HOOK))
		return;
		
	item = spawn();
	item.owner = self;
	makevectors(self.v_angle);

	setorigin(item, self.origin + '0 0 16');
	item.velocity = aim(self, 1000);
	item.velocity = item.velocity * 500;

	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_BOUNCE;

	item.bot_wants_item = TRUE;		// CTFBOT optimization
	
	if(self.weapon == IT_SUPER_SHOTGUN)
	{
		setmodel (item, "progs/g_shot.mdl");
		item.weapon = IT_SUPER_SHOTGUN;
		item.netname = "Double-barrelled Shotgun";
		item.classname = "weapon_supershotgun";
	}

	if( self.weapon == IT_NAILGUN )
	{
		setmodel (item, "progs/g_nail.mdl");
		item.weapon = IT_NAILGUN;
		item.netname = "Nailgun";
		item.classname = "weapon_nailgun";
	}
		
	if( self.weapon == IT_SUPER_NAILGUN)
	{
		setmodel (item, "progs/g_nail2.mdl");
		item.weapon = IT_SUPER_NAILGUN;
		item.netname = "Super Nailgun";
		item.classname = "weapon_supernailgun";
	}
	
	if( self.weapon == IT_GRENADE_LAUNCHER)
	{
		setmodel (item, "progs/g_rock.mdl");
		item.weapon = 3;
		item.netname = "Grenade Launcher";
		item.classname = "weapon_grenadelauncher";
	}
	
	if( self.weapon == IT_ROCKET_LAUNCHER )
	{
		setmodel (item, "progs/g_rock2.mdl");
		item.weapon = 3;
		item.netname = "Rocket Launcher";
		item.classname = "weapon_rocketlauncher";
	}
	
	if( self.weapon == IT_LIGHTNING )
	{
		setmodel (item, "progs/g_light.mdl");
		item.weapon = 3;
		item.netname = "Thunderbolt";
		item.classname = "weapon_lightning";
	}
	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = Team_weapon_touch;
	item.think = SUB_Remove;
	item.nextthink = time + 120;
	
	self.weapon = W_BestWeapon();
	W_SetCurrentAmmo();
};

void(entity flg) RegenFlag =
{
	flg.movetype = MOVETYPE_TOSS;
	flg.solid = SOLID_TRIGGER;
	sound (flg, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	// play respawn sound
	setorigin(flg, flg.oldorigin);
	flg.angles = flg.mangle;
	flg.cnt = FLAG_AT_BASE; // it's at home base
	flg.owner = world;
};

void(entity flg) TeamCaptureReturnFlag =
{
	local entity p;

	RegenFlag(flg);

	p = find(world, classname, "player");
	while (p != world) {
		if (p.team != flg.team)
			TeamPlayerUpdate(p, "Enemy flag has been returned to base!");
		else if (p.team == flg.team)
			TeamPlayerUpdate(p, "Your flag has been returned to base!");
		p = find(p, classname, "player");
	}
};

void () TeamCaptureRegenFlags =
{
	local entity f;

	f = find(world, classname, "item_flag_team1");
	if (f != world)
		RegenFlag(f);
	f = find(world, classname, "item_flag_team2");
	if (f != world)
		RegenFlag(f);
};

void(entity flg) TeamDropFlag =
{
	local entity item, f, oself;
	local entity p;

	p = flg.owner;


	bprint(p.netname);

	local float enteam;					// CTFBOT EXTRAS TEAMNAME
	if (p.lastteam == TEAM_COLOR1)		// CTFBOT EXTRAS TEAMNAME
		enteam = TEAM_COLOR2;			// CTFBOT EXTRAS TEAMNAME
	else if (p.lastteam == TEAM_COLOR2)	// CTFBOT EXTRAS TEAMNAME
		enteam = TEAM_COLOR1;			// CTFBOT EXTRAS TEAMNAME

	// lost
	bprint(" ÏÔÛÙ the ");				// CTFBOT EXTRAS TEAMNAME
	PrintTeamName(world, enteam);		// CTFBOT EXTRAS TEAMNAME
	bprint(" flag!\n");					// CTFBOT EXTRAS TEAMNAME
	
	LogMsg(p, "FLAG-DROP");

	flg.origin = p.origin - '0 0 24';
	flg.cnt = FLAG_DROPPED;
	//NOTE! We check lastteam here instead of team--this is because
	//in the mode where we change colors, we get killed
	flg.velocity_z = 300;
	flg.velocity_x = 0;
	flg.velocity_y = 0;
	flg.flags = FL_ITEM;
	flg.solid = SOLID_TRIGGER;
	flg.movetype = MOVETYPE_TOSS;
	if (teamplay & TEAM_CAPTURE_CUSTOM)
		setsize(flg, '-16 -16 0', '16 16 74');
	else
		setsize(flg, '-16 -16 -24', '16 16 32');
	// return it after so long
	flg.super_time = time + TEAM_CAPTURE_FLAG_RETURN_TIME;
};

void(entity player) TeamCaptureDropFlagOfPlayer =
{
	local string kn;
	local entity e;

	if (!(player.player_flag & ITEM_ENEMY_FLAG))
		return;
	if (player.lastteam == TEAM_COLOR1) 
		kn = "item_flag_team2";
	else
		kn = "item_flag_team1";
	player.player_flag = player.player_flag - ITEM_ENEMY_FLAG;
	e = find(world, classname, kn);
	if (e != world)
		TeamDropFlag(e);
};


void() TeamCaptureFlagTouch =
{
	local entity p, oself;

	if (other.classname != "player" && other.classname != "bot")	// CTFBOT
		return;
	if (other.health <= 0)
		return;

	if (other.team != other.lastteam)
		return; // something is fishy, somebody is playing with colors

	// CTFBOT EXTRAS [[[
	if ((time < (self.flag_toss_time + 3)) && (other == self.last_carrier))
		return;
	// CTFBOT EXTRAS ]]]

	if (self.lastteam == other.lastteam) {
		// same team, if the flag is *not* at the base, return
		// it to base.  we overload the 'cnt' field for this
		if (self.cnt == FLAG_AT_BASE) {
			// the flag is at home base.  if the player has the enemy
			// flag, he's just won!

			if (other.player_flag & ITEM_ENEMY_FLAG) {
				bprint(other.netname);
				
				// CTFBOT EXTRAS TEAMNAME [[[
				local float enteam;					// CTFBOT EXTRAS TEAMNAME
				if (other.team == TEAM_COLOR1)		// CTFBOT EXTRAS TEAMNAME
					enteam = TEAM_COLOR2;			// CTFBOT EXTRAS TEAMNAME
				else if (other.team == TEAM_COLOR2)	// CTFBOT EXTRAS TEAMNAME
					enteam = TEAM_COLOR1;			// CTFBOT EXTRAS TEAMNAME
				
				// captured
				bprint(" „·ÙıÚÂ‰ the ");			// CTFBOT EXTRAS TEAMNAME
				PrintTeamName(world, enteam);		// CTFBOT EXTRAS TEAMNAME
				bprint(" flag!\n");					// CTFBOT EXTRAS TEAMNAME
				// CTFBOT EXTRAS TEAMNAME ]]]

				LogMsg(other, "FLAG-CAPTURE");

				last_flag_capture = time;	// CTFBOT
				last_capture_team = other.team;// CTFBOT

				other.items = other.items - (other.items & (IT_KEY1 | IT_KEY2));

				if (cvar("teamplay") & TEAM_CAPTURE_CUSTOM)
					PlayFlagCaptureSound(other.team);		// CTFBOT EXTRAS CUSTOMSOUNDS
				else
					sound (other, CHAN_VOICE, "doors/meduse.wav", 1, ATTN_NONE);

				// other gets another 10 frag bonus
				UpdateClientFrags(other, TEAM_CAPTURE_CAPTURE_BONUS);	// CTFBOT 

				other.num_captures = other.num_captures + 1;		// CTFBOT EXTRAS
//TONY
//TEMP1 frags as captures
				if (other.team == TEAM_COLOR1)
					captures_red = captures_red + 1;
				if (other.team == TEAM_COLOR2)
					captures_blue = captures_blue + 1;

				// Ok, let's do the player loop, hand out the bonuses
				p = find(world, classname, "player");
				while (p != world) {
					self = p;
					self.killed = 0;
					if (self.lastteam == other.lastteam && self != other)
						UpdateClientFrags(self, TEAM_CAPTURE_TEAM_BONUS);	// CTFBOT 
					if (self.lastteam != other.lastteam) {
							TeamPlayerUpdate(self, "Your flag was captured!");
						// *XXX* EXPERT CTF
						// reset the last_hurt_carrier variable in all enemy players, so that you don't get
						// bonuses for defending the flag carrier if the flag carrier has already
						// completed a capture
						self.last_hurt_carrier = -5;
					} else if (self.lastteam == other.lastteam) {
						// done to all players on the capturing team

						// *XXX* EXPERT CTF
	
						// award extra points for capture assists
						if (self.last_returned_flag + TEAM_CAPTURE_RETURN_FLAG_ASSIST_TIMEOUT > time) {
							bprint(self.netname);
							bprint(" gets an assist for returning his flag!\n");
							UpdateClientFrags(self, TEAM_CAPTURE_RETURN_FLAG_ASSIST_BONUS);	// CTFBOT 

							self.num_assists = self.num_assists + 1;	// CTFBOT EXTRAS
						}
						if (self.last_fragged_carrier + TEAM_CAPTURE_FRAG_CARRIER_ASSIST_TIMEOUT > time) {
							bprint(self.netname);
							bprint(" gets an assist for fragging the flag carrier!\n");
							UpdateClientFrags(self, TEAM_CAPTURE_FRAG_CARRIER_ASSIST_BONUS);	// CTFBOT 

							self.num_assists = self.num_assists + 1;	// CTFBOT EXTRAS
						}
					}
					self.player_flag = self.player_flag - (self.player_flag & ITEM_ENEMY_FLAG);
					
					p = FindNextPlayerOrBot(p); // CTFBOT replaced find, so we find bots also
				}

				TeamCaptureResetUpdate();
				
				p = find(world, classname, "player");
				while (p != world) {
					if ((p.lastteam == TEAM_COLOR1 && other.lastteam == TEAM_COLOR2) ||
						(p.lastteam == TEAM_COLOR2 && other.lastteam == TEAM_COLOR1))
						TeamPlayerUpdate(p, "Your flag was captured!");
					else if (p.lastteam == other.lastteam)
						TeamPlayerUpdate(p, "Your team captured the flag!");
					p = find(p, classname, "player");
				}
				// respawn flags
				TeamCaptureRegenFlags();
				return;
			}
			return; // its at home base already
		}	
		// hey, its not home.  return it by teleporting it back
		bprint(other.netname);

		// returned
		bprint(" ÚÂÙıÚÓÂ‰ the ");			// CTFBOT EXTRAS TEAMNAME
		PrintTeamName(world, other.team);	// CTFBOT EXTRAS TEAMNAME
		bprint(" flag!\n");					// CTFBOT EXTRAS TEAMNAME

		LogMsg(other, "FLAG-RECOVERY");
		UpdateClientFrags(other, TEAM_CAPTURE_RECOVERY_BONUS);	// CTFBOT 

		other.num_recovery = other.num_recovery + 1;		// CTFBOT EXTRAS

		// *XXX* EXPERT CTF set time when player last returned his flag
		other.last_returned_flag = time;
		sound (other, CHAN_ITEM, self.noise1, 1, ATTN_NONE);	// CTFBOT EXTRAS changed to ATTN_NONE
		TeamCaptureReturnFlag(self);
		return;
	}

	// CTFBOT [[[
	// if we get here, the flag is the enemy flag
	if ((teamplay & TEAM_CAPTURE_NO_BOT_FLAG_PICKUP) && (other.classname == "bot"))
		return;		// if no bot pickup, bots can't get enemy flag
	// CTFBOT ]]]

	// hey, its not our flag, pick it up
	bprint(other.netname);
	
	// got
	bprint(" ÁÔÙ the ");					// CTFBOT EXTRAS TEAMNAME
	PrintTeamName(world, self.lastteam);	// CTFBOT EXTRAS TEAMNAME
	bprint(" flag!\n");						// CTFBOT EXTRAS TEAMNAME
	
	LogMsg(other, "FLAG-PICKUP");
	if (TEAM_CAPTURE_FLAG_BONUS)
		UpdateClientFrags(other, TEAM_CAPTURE_FLAG_BONUS);	// CTFBOT 
//TONY
//only score a pickup if the flag is at enemy base
	if (self.cnt == FLAG_AT_BASE)
	{
//		sprint(other,"pickup\n");
		other.num_pickups = other.num_pickups + 1;		// CTFBOT EXTRAS
	}

//	TeamPlayerUpdate(other, "YOU GOT THE ENEMY FLAG!  RETURN TO BASE!");
	TeamPlayerUpdate(other, "Ÿœ’ «œ‘ ‘»≈ ≈Œ≈ÕŸ ∆Ã¡«  “≈‘’“Œ ‘œ ¬¡”≈");

	PlayFlagTakenSound(other.team);		// CTFBOT EXTRAS CUSTOMSOUNDS 

	other.player_flag = other.player_flag + ITEM_ENEMY_FLAG;
	other.items = other.items | self.items;

	// *XXX* EXPERT CTF set the time at which the carrier picked up the flag
	other.flag_since = time;

	// pick up the flag
	self.cnt = FLAG_CARRIED;
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.owner = other;

	last_flag_pickup = time;	// CTFBOT
	last_pickup_team = other.team;// CTFBOT

	p = find(world, classname, "player");
	while (p != world) {
		if (p != other) {
			if ((p.team == TEAM_COLOR1 && other.team == TEAM_COLOR2) ||
				(p.team == TEAM_COLOR2 && other.team == TEAM_COLOR1))
				TeamPlayerUpdate(p, "ŸÔıÚ ÊÏ·Á Ë·Û ‚ÂÂÓ Ù·ÎÂÓ!");
//				TeamPlayerUpdate(p, "Your flag has been taken!");
			else if (p.team == other.team)
				TeamPlayerUpdate(p, "Your team has the enemy flag!");
		}
		p = find(p, classname, "player");
	}
};

void() TeamCaptureFlagThink =
{
	local entity e;
	local vector v;
	local float f;
	local string s;

	self.nextthink = time + 0.1;

	if (self.cnt == FLAG_AT_BASE)
		return; // just sitting around waiting to be picked up

	if (self.cnt == FLAG_DROPPED) {
		if (time - self.super_time > TEAM_CAPTURE_FLAG_RETURN_TIME)
			TeamCaptureReturnFlag(self);
		return;
	}

	if (self.cnt != FLAG_CARRIED)
		objerror("Flag in invalid state\n");

	e = self.owner;
	if ((e.classname != "player" && e.classname != "bot" && e.classname != "hologram") || (e.deadflag) ||   // CTFBOT
		(!(e.player_flag & ITEM_ENEMY_FLAG))) {
		TeamDropFlag(self);
		return;
	}
	makevectors (e.angles);
	v = v_forward;
//dprint("fwd: ");
//s = vtos(v);
//dprint(s);
//dprint("\n");
//	if (v_z < 0) { 
//		v_z = (-1)*v_z; 
//		v = v + v * 1.2 * v_z; 
//	}
//dprint("adj: ");
//s = vtos(v);
//dprint(s);
//dprint("\n");
	v_z = (-1) * v_z; // reverse z component

	f = 14;
	if (self.owner.frame >= 29 && self.owner.frame <= 40) {
		if (self.owner.frame >= 29 && self.owner.frame <= 34) { //axpain
			if      (self.owner.frame == 29) f = f + 2; 
			else if (self.owner.frame == 30) f = f + 8;
			else if (self.owner.frame == 31) f = f + 12;
			else if (self.owner.frame == 32) f = f + 11;
			else if (self.owner.frame == 33) f = f + 10;
			else if (self.owner.frame == 34) f = f + 4;
		} else if (self.owner.frame >= 35 && self.owner.frame <= 40) { // pain
			if      (self.owner.frame == 35) f = f + 2; 
			else if (self.owner.frame == 36) f = f + 10;
			else if (self.owner.frame == 37) f = f + 10;
			else if (self.owner.frame == 38) f = f + 8;
			else if (self.owner.frame == 39) f = f + 4;
			else if (self.owner.frame == 40) f = f + 2;
		}
	} else if (self.owner.frame >= 103 && self.owner.frame <= 118) {
		if      (self.owner.frame >= 103 && self.owner.frame <= 104) f = f + 6;  //nailattack
		else if (self.owner.frame >= 105 && self.owner.frame <= 106) f = f + 6;  //light 
		else if (self.owner.frame >= 107 && self.owner.frame <= 112) f = f + 7;  //rocketattack
		else if (self.owner.frame >= 112 && self.owner.frame <= 118) f = f + 7;  //shotattack
	}
	self.origin = e.origin + '0 0 -16' - f*v + v_right * 22;
	self.angles = e.angles + '0 0 -45';
	setorigin (self, self.origin);
	self.nextthink = time + 0.01;
};

// self is player
entity() TeamCaptureSpawn =
{
	if (self.team == TEAM_COLOR1) {
		team1_lastspawn = find(team1_lastspawn, classname, "info_player_team1");
		if (team1_lastspawn == world)
			team1_lastspawn = find(team1_lastspawn, classname, "info_player_team1");
		return team1_lastspawn;
	} else if (self.team == TEAM_COLOR2) {
		team2_lastspawn = find(team2_lastspawn, classname, "info_player_team2");
		if (team2_lastspawn == world)
			team2_lastspawn = find(team2_lastspawn, classname, "info_player_team2");
		return team2_lastspawn;
	}
	return world;
};


/*
	From byron@caseware.com Wed Oct 16 18:57:44 1996
	Date: Wed, 16 Oct 1996 21:22:37 -0400
	From: Byron Long <byron@caseware.com>
	To: zoid@mindlink.net
	Subject: Team Status Command (source code included) :-)

	A co-worker of mine wondered if it was possible to add a function to
	your capture the flag code that would give a status report on an
	impulse. I think he may have mailed you, but I wrote a quick version
	myself, which your welcome to use if you like the feature (it offsets
	some of the problems with the chat capabilities in Quake so it seems
	like a worthwhile feature). Feel free to change it
	as necessary.
*/

// *Capture The Flag - Status report by Wonko
void() TeamFlagStatusReport =
{
	local entity flag1, flag2, p;

	// CTFBOT [[[
	// no status for anything but players
	if (self.classname != "player")
		return;	
//TONY
//REMOVED DTF
		
	// CTFBOT ]]]
	
	// more status for CTF 4.0 by Drew 'BZ' Davidson [[[
	local float num_red, num_blue, score_red, score_blue;
	local string st;

		num_red = 0;
		num_blue = 0;
		score_red = 0;
		score_blue = 0;
		p = find(world, classname, "player");
		while (p != world)
		{
			if (p.team == TEAM_COLOR1)
			{
				num_red = num_red + 1;
				score_red = score_red + p.frags;
			}
			else if (p.team == TEAM_COLOR2)
			{
				num_blue = num_blue + 1;
				score_blue = score_blue + p.frags;
			}
			p = FindNextPlayerOrBot(p);		// find(p, classname, "player");
		}

		sprint(self, "You are ");
		PrintTeamName(self, self.team);		// CTFBOT EXTRAS TEAMNAME
		sprint(self, " with ");
		sprintfloat(self, self.frags);
		sprint(self, " frags\n");

		PrintTeamName(self, TEAM_COLOR1);	// CTFBOT EXTRAS TEAMNAME
		sprint(self, " ");
		
		st = ftos(score_red);
		sprint(self, st);
		sprint(self, " (");
		st = ftos(num_red);
		sprint(self, st);
		sprint(self, ")");
		
		sprint(self, " Ö ");
		PrintTeamName(self, TEAM_COLOR2);	// CTFBOT EXTRAS TEAMNAME
		sprint(self, " ");
		
		st = ftos(score_blue);
		sprint(self, st);
		sprint(self, " (");
		st = ftos(num_blue);
		sprint(self, st);
		sprint(self, ")\n");
	// more status for CTF 4.0 by Drew 'BZ' Davidson ]]]
	
	// Find the flags at home base
	flag1 = find (world,classname, "item_flag_team1");
	flag2 = find (world,classname, "item_flag_team2");

	// If on team 2 switch meanings of flags
	if (self.team != TEAM_COLOR1) {
		p = flag1;
		flag1 = flag2;
		flag2 = p;
	}

	if (flag1 != world && flag1.cnt == FLAG_CARRIED) {
		sprint(self, flag1.owner.netname);
		sprint(self, " has your flag. ");
	} else {
		sprint(self, "Your flag is ");
		if (flag1 == world)
			sprint(self, "missing!\n");			// CTFBOT EXTRAS added '\n' for better readability
		else if (flag1.cnt == FLAG_AT_BASE)		// CTFBOT EXTRAS added else
			sprint(self, "in your base.\n");	// CTFBOT EXTRAS added '\n' for better readability
		else if (flag1.cnt == FLAG_DROPPED)
			sprint(self, "lying about.\n");		// CTFBOT EXTRAS added '\n' for better readability
		else
			sprint(self, " corrupt.\n");		// CTFBOT EXTRAS added '\n' for better readability
	}

	if (flag2 != world && flag2.cnt == FLAG_CARRIED) {
		if (self == flag2.owner) 
			sprint(self, "You have the enemy flag.\n");
		else {
			sprint(self, flag2.owner.netname);
			sprint(self, " has the enemy flag.\n");
		}
	} else {
		sprint(self, "The enemy flag is ");
		if (flag2 == world)
			sprint(self, "missing!\n");
		else if (flag2.cnt == FLAG_AT_BASE)		// CTFBOT EXTRAS added else
			sprint(self, "in their base.\n");
		else if (flag2.cnt == FLAG_DROPPED)
			sprint(self, "lying about.\n");
		else
			sprint(self, " corrupt.\n");
	}
};

/////////////////////////////////////////////////////////////////////////

$cd id1/models/flag
$base base
$skin skin

void() place_flag = {
	// CTFBOT DTF [[[
	self.mdl = self.model;		// so it can be restored on respawn
	self.flags = FL_ITEM;		// make extra wide

	self.movetype = MOVETYPE_TOSS;	
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;

//TONY
//REMOVED DTF.QC
//	if (teamplay & TEAM_DAMAGE_THE_FLAG)
//	{
//		self.takedamage = DAMAGE_AIM;
//		self.solid = SOLID_SLIDEBOX;
//		self.deadflag = DEAD_NO;
//		self.health = FLAG_INITIAL_HEALTH;
//		self.max_health = FLAG_MAX_HEALTH;
//
//		self.touch = DTFFlagTouch;
//		self.th_pain = DTFFlagPain;
//		self.th_die = DTFFlagDie;
//
//		self.lastteam = self.team;
//	}
//	else
//	{
		self.solid = SOLID_TRIGGER;
		self.think = TeamCaptureFlagThink;
		self.touch = TeamCaptureFlagTouch;
		self.nextthink = time + 0.1;
//	}

	self.bot_wants_item = TRUE;		// CTFBOT optimization

//	// CTFBOT DTF ]]]
	
	self.flag_toss_time = time - 999;		// CTFBOT
	self.last_carrier = world;				// CTFBOT

	self.cnt = FLAG_AT_BASE;
	self.mangle = self.angles;
	self.effects = self.effects | EF_DIMLIGHT;
	if (!droptofloor()) {
		dprint ("Flag fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\nflag removed\n");	// CTFBOT EXTRAS
		remove(self);
		return;
	}
	self.oldorigin = self.origin; // save for flag return
};

// ZOID Capture the flag
void() item_flag_team1 =
{
	self.team = TEAM_COLOR1;
	self.lastteam = TEAM_COLOR1;
	self.enemy_team = TEAM_COLOR2;		// CTFBOT DTF
	self.items = IT_KEY2;
	if (cvar("teamplay") & TEAM_CAPTURE_CUSTOM) {
		precache_model ("progs/flag.mdl");
		setmodel (self, "progs/flag.mdl");
		self.skin = 0;
		precache_sound ("misc/flagtk.wav");			// flag taken
		precache_sound ("misc/flagcap.wav");			// flag capture
		precache_sound ("doors/runetry.wav");
		self.noise = "misc/flagtk.wav";
		self.noise1 = "doors/runetry.wav";
		setsize(self, '-16 -16 0', '16 16 74');
	} else {
		precache_model ("progs/w_g_key.mdl");
		setmodel (self, "progs/w_g_key.mdl");
		precache_sound ("misc/medkey.wav");
		precache_sound ("doors/meduse.wav");
		precache_sound ("doors/runetry.wav");
		self.noise = "misc/medkey.wav";
		self.noise1 = "doors/runetry.wav";
		self.origin_z = self.origin_z + 24;
		setsize(self, '-16 -16 -24', '16 16 32');
	}
	self.nextthink = time + 0.2;	// items start after other solids
	self.think = place_flag;
};

void() item_flag_team2 =
{
	self.team = TEAM_COLOR2;
	self.lastteam = TEAM_COLOR2;
	self.enemy_team = TEAM_COLOR1;		// CTFBOT DTF
	self.items = IT_KEY1;
	if (cvar("teamplay") & TEAM_CAPTURE_CUSTOM) {
		precache_model ("progs/flag.mdl");
		setmodel (self, "progs/flag.mdl");
		self.skin = 1;
		precache_sound ("misc/flagtk.wav");			// flag taken
		precache_sound ("misc/flagcap.wav");			// flag capture
		precache_sound ("doors/runetry.wav");
		self.noise = "misc/flagtk.wav";
		self.noise1 = "doors/runetry.wav";
		setsize(self, '-16 -16 0', '16 16 74');
	} else {
		precache_model ("progs/w_s_key.mdl");
		setmodel (self, "progs/w_s_key.mdl");
		precache_sound ("misc/medkey.wav");
		precache_sound ("doors/meduse.wav");
		precache_sound ("doors/runetry.wav");
		self.noise = "misc/medkey.wav";
		self.noise1 = "doors/runetry.wav";
		self.origin_z = self.origin_z + 24;
		setsize(self, '-16 -16 -24', '16 16 32');
	}
	// make it glow
	self.nextthink = time + 0.2;	// items start after other solids
	self.think = place_flag;
};


/*QUAKED func_ctf_wall (0 .5 .8) ?
This is just a solid wall if not inhibitted
Only appears in CTF teamplay
*/
void() func_ctf_wall =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	setmodel (self, self.model);
};

