//botai2.qc
//Copyright (C) 1998  Drew Davidson, Anthony J. Distler
//
//This program is free software; you can redistribute it and/or
//modify it under the terms of the GNU General Public License
//as published by the Free Software Foundation; either version 2
//of the License, or (at your option) any later version.
//
//This program is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with this program; if not, write to the Free Software
//Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

//====================================================
// self is the bot
// Returns TRUE if kicking ass (ie has enough ammo, and good weapons)
//====================================================
float () BotKicksAss =
{
	if ((self.items & IT_LIGHTNING) && (self.ammo_cells > 25))
		return TRUE;
	if ((self.items & IT_ROCKET_LAUNCHER) && (self.ammo_rockets > 25))
		return TRUE;
	if ((self.items & IT_GRENADE_LAUNCHER) && (self.ammo_rockets > 25))
		return TRUE;
	if ((self.items & IT_SUPER_NAILGUN) && (self.ammo_nails > 25))
		return TRUE;

	return FALSE;
}

//====================================================
// self is the bot
// Returns true if discharge/suicide is a good option
//====================================================
float () BotShouldDischarge =
{
local float num_we_will_fry;
local entity p;


	if (self.waterlevel != 3)
		return FALSE;
	if (!(self.items & IT_LIGHTNING))
		return FALSE;
	if (self.ammo_cells == 0)
		return FALSE;

	// don't discharge if we are kickin ass
	if (BotKicksAss() == TRUE)
		return FALSE;

	// count the amount of bodies we will potentially fry with discharge
	num_we_will_fry = 0;

	// search within radius (not guarenteed to be bots in same 'water pool', but it is
	// enough
	p = findradius(self.origin, 1000);
	while (p != world)
	{
		if (p.classname == "player" || p.classname == "bot")
		if (p.team != self.team)
		if (p.health > 0)
		if (!(p.observer_flags & PLAYER_NO_TARGET))
		if (!p.observer)
		if (pointcontents(p.origin) == CONTENT_WATER) // in water
		if (BotCanSeePlayer(p)) // can see it
		{
			num_we_will_fry = num_we_will_fry + 1;
		}
		p = p.chain;
	}
	
	if (num_we_will_fry > 1)
	{
		// at this point, we will probably kill 2 or more enemies
		// if we discharge

		// 10% chance we will discharge (not 2%, 10% is way more fun :) )
		if (random() < 0.10)
		{
			if (bot_debug >= 1)
			{
				dprint(self.netname);
				dprint(" decides to discharge\n");
			}
			
			return TRUE;
		}
	}

	return FALSE;
};

//====================================================
// self is the bot
//====================================================
float () Bot_BestWeapon =
{
local float	it;
local vector vrng;
local float rng, good_grenade_range, safe_dist, bestw, goodzrange;

	/*
	if (bot_debug >= 4)
	{
		dprint(self.netname);
		dprint(" ");
		dprint(self.classname);
		dprint(" BotBestWeapon\n");
	}
	*/

	it = self.items;
	safe_dist = -1;

	if (self.enemy != world)
	{
		rng = vlen(self.origin - self.enemy.origin);
		
		// misjudge actual range based on skill
		rng = rng + (((((random() * random()) * 2) - 1) * 50) * self.bot_skill_inverse);

		if ((it & IT_LIGHTNING) && (self.ammo_cells >= 1))
		{
			local float dis;
			// removed this, does it work? dis = BotShouldDischarge();
			dis = FALSE;

//TONY
//TESTING
			dis = BotShouldDischarge();
			if ((rng < 600) && ((self.waterlevel <= 1) || dis))
				return IT_LIGHTNING;
		}

		if ((it & IT_ROCKET_LAUNCHER) && (self.ammo_rockets >= 1))
		{
//TONY
//teamplay 1
//if it's on, always use RL
			if(teamplay & TEAM_NOSELFHURT)
				safe_dist = 0;
			else
			if (self.health < 50)
				safe_dist = 99999999;	// take no chances if health low
			else if ((self.armortype == 0.3) && (self.armorvalue > 75))
				safe_dist = 100;
			else if ((self.armortype == 0.6) && (self.armorvalue > 60))
				safe_dist = 80;
			else if ((self.armortype == 0.8) && (self.armorvalue > 50))
				safe_dist = 60;
			else
			{
				// general case
				safe_dist = 110;		
			}		

			// adjust for strength rune
			if (self.player_flag & ITEM_RUNE2_FLAG)
				safe_dist = safe_dist * 2;

			// adjust for quad
			if (self.super_damage_finished > time)
				safe_dist = safe_dist * 4;	
				
			if (rng > safe_dist)
				return IT_ROCKET_LAUNCHER;
		}
	
		if ((it & IT_GRENADE_LAUNCHER) && (self.ammo_rockets >= 1))
		{
			if (safe_dist == -1)	// haven't computed safe_dist yet
			{
				if (self.health < 50)
					safe_dist = 99999999;	// take no chances if health low
				else if ((self.armortype == 0.3) && (self.armorvalue > 75))
					safe_dist = 100;
				else if ((self.armortype == 0.6) && (self.armorvalue > 60))
					safe_dist = 80;
				else if ((self.armortype == 0.8) && (self.armorvalue > 50))
					safe_dist = 60;
				else
				{
					// general case
					safe_dist = 110;		
				}		

				// adjust for strength rune
				if (self.player_flag & ITEM_RUNE2_FLAG)
					safe_dist = safe_dist * 2;

				// adjust for quad
				if (self.super_damage_finished > time)
					safe_dist = safe_dist * 4;	
			}

			goodzrange = FALSE;
			if (self.origin_z > self.enemy.origin_z)
				goodzrange = TRUE;		// drop it on their heads
			else if ((self.enemy.origin_z - self.origin_z) < 250)		// need to fix this for low gravity
				goodzrange = TRUE;		// they are not too far above us

			if ((rng < 600) && (rng > safe_dist) && (goodzrange) )
				good_grenade_range = TRUE;
			else if ((rng < 1500) && (rng > (safe_dist * 0.6)) && (self.origin_z > (self.enemy.origin_z + 50)))
				good_grenade_range = TRUE;
			else
				good_grenade_range = FALSE;

			if (good_grenade_range)
				return IT_GRENADE_LAUNCHER;			
		}

		if ((self.ammo_nails >= 2) && (it & IT_SUPER_NAILGUN) )
		{
			/* disabled because only really effective if you cheat
			// special "last shot" double shotgun technique... when
			// bots are close
			// this is a skill based technique
			//if (random() < self.bsk_skill_lin3)
			if (TRUE)
			{
				if ((self.last_weapon_shot == IT_SUPER_NAILGUN)
					&& (rng < 100)
					&& (self.ammo_shells >= 2)
					&& (it & IT_SUPER_SHOTGUN)
					)
					{
					BotSayStart2();
					BotSayMiddle("BLAM!");
					BotSayEnd();
					return IT_SUPER_SHOTGUN;
					}
			}
			*/
			return IT_SUPER_NAILGUN;
		}
			
		if ((self.ammo_shells >= 2) && (it & IT_SUPER_SHOTGUN) )
			return IT_SUPER_SHOTGUN;
			
		if ((self.ammo_nails >= 1) && (it & IT_NAILGUN) )
		{
			// special case for haste -- give shotgun higher priority than nailgun
			if (self.player_flag & ITEM_RUNE3_FLAG)		// haste
			{
				// if we have haste, we are better off using the shotgun
				// because the nailgun firing rate is not doubled
				if ((self.ammo_shells >= 1) && (it & IT_SHOTGUN) )
					bestw = IT_SHOTGUN;
			}
			else
				return IT_NAILGUN;
		}
			
		if((self.ammo_shells >= 1) && (it & IT_SHOTGUN) )
			return IT_SHOTGUN;

		return IT_AXE;
	}
	else if((self.ammo_shells >= 1) && (it & IT_SHOTGUN) )
		return IT_SHOTGUN;
	else
		return IT_AXE;
};
//=============================================================
//=============================================================
float () IsExactlyOnePlayer =
{
local entity p;
local float nm;

	p = find(world, classname, "player");
	nm = 0;
	while (p != world)
	{
		nm = nm + 1;
		if (nm > 1)
			return FALSE;
		p = find(p, classname, "player");
	}

	return TRUE;
};

//=============================================================
// this routine could be changed, or another routine written, so
// that item priorities are different when we are in combat...
// e.g. health and armor should have much higher priorities than
// a box of shells, and we should also give priority to items that
// have not respawned yet, so if they respawn we will be standing
// right there
//=============================================================
float(entity bot, entity item) IsGoodItem =
{
local float val;
local entity p;

	if (!item.bot_wants_item)		// optimization
		return 0;

	if (item.classname == "item_health")
	{
		if (bot.health < 25)
			return 10000;	// almost dead, we really need health bad!
		else if (bot.health < 50)
			return 5000;
		else if (bot.health < 75)
			return 500;
		else if (bot.health < 100)
		{
			if (item.spawnflags & H_MEGA)
			{
				if (bot.player_flag & ITEM_RUNE4_FLAG)		// Regeneration
					return 1000;
				else
					return (250 - bot.health);
			}
			else if (item.spawnflags & H_ROTTEN)
				return (115 - bot.health);
			else 
				return (125 - bot.health);
		}
	}
	else if (item.classname == "item_shells") 
	{
		return (25 - bot.ammo_shells);		// don't be ammo hog
	}
	else if (item.classname == "item_nails") 
	{
		//if (!((bot.items & IT_NAILGUN) || (bot.items & IT_SUPER_NAILGUN)))
		//	return (100 - bot.ammo_nails);	// don't be ammo hog
		//else
			return (100 - bot.ammo_nails);	// don't be ammo hog
	}
	else if (item.classname == "item_rockets") 
	{
		//if (!((bot.items & IT_GRENADE_LAUNCHER) || (bot.items & IT_ROCKET_LAUNCHER)))
		//	return (50 - bot.ammo_rockets);		// don't be ammo hog
		//else
			return (50 - bot.ammo_rockets);		// don't be ammo hog
	}
	else if (item.classname == "item_cells") 
	{
		//if (!(bot.items & IT_LIGHTNING))
		//	return (50 - bot.ammo_cells);		// don't be ammo hog
		//else
			return (50 - bot.ammo_cells);		// don't be ammo hog
	}
	else if (item.classname == "backpack")
	{
      	return 150;
	}
	else if (item.classname == "weapon_supershotgun")
	{
		if (deathmatch & DM_WEAPONS_STAY)
		{
			if (!(bot.items & IT_SUPER_SHOTGUN))
				return 60;
		}
		else
		{
			if ((bot.items & IT_SUPER_NAILGUN) && (bot.ammo_nails >= 40))
				return 10;
			else if ((bot.items & IT_GRENADE_LAUNCHER) && (bot.ammo_rockets >= 5))
				return 10;
			else if ((bot.items & IT_ROCKET_LAUNCHER) && (bot.ammo_rockets >= 5))
				return 10;
			else if ((bot.items & IT_LIGHTNING) && (bot.ammo_cells >= 5))
				return 10;
			else if (!(bot.items & IT_SUPER_SHOTGUN))
				return 60;
			else if (!(deathmatch & DM_WEAPONS_STAY))			// no ammo in deathmatch 3
				return (60 - bot.ammo_shells);
		}
	}
	else if (item.classname == "weapon_nailgun")
	{
		if (deathmatch & DM_WEAPONS_STAY)
		{
			if (!(bot.items & IT_NAILGUN))
				return 40;
		}
		else
		{
			if ((bot.items & IT_SUPER_NAILGUN) && (bot.ammo_nails >= 40))
				return 10;
			else if ((bot.items & IT_GRENADE_LAUNCHER) && (bot.ammo_rockets >= 5))
				return 10;
			else if ((bot.items & IT_ROCKET_LAUNCHER) && (bot.ammo_rockets >= 5))
				return 10;
			else if ((bot.items & IT_LIGHTNING) && (bot.ammo_cells >= 5))
				return 10;
			else if (!(bot.items & IT_NAILGUN))
				return 40;
			else if (!(deathmatch & DM_WEAPONS_STAY))			// no ammo in deathmatch 3
				return (80 - bot.ammo_nails);
		}
	}
	else if (item.classname == "weapon_supernailgun")
	{
		if (deathmatch & DM_WEAPONS_STAY)
		{
			if (!(bot.items & IT_SUPER_NAILGUN))
				return 75;
		}
		else
		{
			if ((bot.items & IT_LIGHTNING) && (bot.ammo_cells >= 5))
				return (80 - bot.ammo_nails);
			else if (!(bot.items & IT_SUPER_NAILGUN))
				return 75;
			else if (!(deathmatch & DM_WEAPONS_STAY))			// no ammo in deathmatch 3
				return (80 - bot.ammo_nails);
		}
	}
	else if (item.classname == "weapon_grenadelauncher") 
	{
		if (deathmatch & DM_WEAPONS_STAY)
		{
			if (!(bot.items & IT_GRENADE_LAUNCHER))
				return 130;
		}
		else
		{
			if ((bot.items & IT_ROCKET_LAUNCHER) && (bot.ammo_rockets >= 5))
				return (50 - bot.ammo_rockets);
			else if ((bot.items & IT_LIGHTNING) && (bot.ammo_cells >= 5))
				return (50 - bot.ammo_rockets);
			else if (!(bot.items & IT_GRENADE_LAUNCHER))
				return 130;
			else if (!(deathmatch & DM_WEAPONS_STAY))			// no ammo in deathmatch 3
				return (50 - bot.ammo_rockets);
		}
	}
	else if (item.classname == "weapon_rocketlauncher")
	{
		if (!(bot.items & IT_ROCKET_LAUNCHER))
			return 140;
		else if (!(deathmatch & DM_WEAPONS_STAY))			// no ammo in deathmatch 3
			return (50 - bot.ammo_rockets);
	}
	else if (item.classname == "weapon_lightning") 
	{
		if (!(bot.items & IT_LIGHTNING))
			return 150;
		else if (!(deathmatch & DM_WEAPONS_STAY))			// no ammo in deathmatch 3
			return (50 - bot.ammo_cells);
	}
	else if (item.classname == "item_armor1")
	{
		// only care about it if we can actually pick it up
		if (bot.armortype*bot.armorvalue < 0.3*100)
			return 300;
	}
	else if (item.classname == "item_armor2")
	{
		// only care about it if we can actually pick it up
		if (bot.armortype*bot.armorvalue < 0.6*150)
			return 600;
	}
	else if (item.classname == "item_armorInv")
	{
		// only care about it if we can actually pick it up
		if (bot.armortype*bot.armorvalue < 0.8*200)
			return 800;
	}
	else if (item.classname == "item_flag_team1")	// red flag
	{
		if (bot.team == TEAM_COLOR2)
		{
			// we are blue
			// enemy flag!  
			return 20000;
		}
		else
		{
			// we are red
			// it's our flag.  if we are carrying the enemy flag, we
			// want to touch it to capture, otherwise if it's on the ground
			// we want to touch it and return it to base
			if (bot.player_flag & ITEM_ENEMY_FLAG)
				return 100000;
			else if (item.cnt == FLAG_DROPPED)
				return 50000;
		}
	}
	else if (item.classname == "item_flag_team2")	//  blue flag
	{
		if (bot.team == TEAM_COLOR1)
		{
			// we are red
			// enemy flag!
			return 20000;
		}
		else
		{
			// we are blue
			// it's our flag.  if we are carrying the enemy flag, we
			// want to touch it to capture, otherwise if it's on the ground
			// we want to touch it and return it to base
			if (bot.player_flag & ITEM_ENEMY_FLAG)
				return 100000;
			else if (item.cnt == FLAG_DROPPED)
				return 50000;
		}
	}
	else if ((item.classname == "item_rune1")
			|| (item.classname == "item_rune2")
			|| (item.classname == "item_rune3")
			|| (item.classname == "item_rune4"))
	{
		// ignore runes if we already have a rune
		if (!(bot.player_flag & ITEM_RUNE_MASK))
			return 1000;
	}
	else if (item.classname == "item_artifact_envirosuit")
	{
		// care more about envirosuits if we are under water
		if (self.waterlevel == 3)
			return 1000;
		else
			return 50;
	}
	else if (item.classname == "item_artifact_invulnerability")
	{
		return 1500;
	}
	else if (item.classname == "item_artifact_invisibility")
	{
		return 500;
	}
	else if (item.classname == "item_artifact_super_damage")
	{
		return 1500;
	}
		
	return 0;		// don't want it at all
};

//=============================================================
//=============================================================
float(entity item) IsImmovableGettableItem =
{
	if (item.classname == "item_flag_team1")
		return TRUE;
	else if (item.classname == "item_flag_team2")
		return TRUE;
	else if (item.classname == "item_artifact_envirosuit")
		return TRUE;
	else if (item.classname == "item_artifact_invulnerability")
		return TRUE;
	else if (item.classname == "item_artifact_invisibility")
		return TRUE;
	else if (item.classname == "item_artifact_super_damage")
		return TRUE;
	else if (item.classname == "weapon_supershotgun")
		return TRUE;
	else if (item.classname == "weapon_nailgun")
		return TRUE;
	else if (item.classname == "weapon_supernailgun")
		return TRUE;
	else if (item.classname == "weapon_grenadelauncher") 
		return TRUE;
	else if (item.classname == "weapon_rocketlauncher")
		return TRUE;
	else if (item.classname == "weapon_lightning") 
		return TRUE;
	else if (item.classname == "item_shells") 
		return TRUE;
	else if (item.classname == "item_nails") 
		return TRUE;
	else if (item.classname == "item_rockets") 
		return TRUE;
	else if (item.classname == "item_cells") 
		return TRUE;
	else if (item.classname == "item_armor1")
		return TRUE;
	else if (item.classname == "item_armor2")
		return TRUE;
	else if (item.classname == "item_armorInv")
		return TRUE;
	else if (item.classname == "item_health")
		return TRUE;
		
	return FALSE;
};

//==========================================================
float () BotSayStart =
{
	if (time < (self.last_say + 5))		// talk at most once every 5 seconds
		return FALSE;
	
	self.last_say = time;
	
	if (bots_have_normal_names)
	{
//TONY
//use talkname
//		bprint(self.netname);
		bprint(self.talkname);
		bprint("� ");
	}
	else
	{
		if (self.team  == TEAM_COLOR1)
			bprint("������� ");
		else if (self.team == TEAM_COLOR2)
			bprint("�������� ");
		else
			bprint("���� ");
	}

	return TRUE;
};
//==========================================================
float () BotSayTeamStart =
{
	if (time < (self.last_say + 5))		// talk at most once every 5 seconds
		return FALSE;
	
	self.last_say = time;
	
	if (bots_have_normal_names)
	{
//TONY
//use talkname
//		bprintteam(self.netname);
		bprintteam(self.talkname);
		bprintteam("� ");
	}
	else
	{
		if (self.team == TEAM_COLOR1)
			bprintteam("������� ");
		else if (self.team == TEAM_COLOR2)
			bprintteam("�������� ");
		else
			bprintteam("���� ");
	}

	return TRUE;
};
//==========================================================
void () BotSayStart2 =
{
	if (bots_have_normal_names)
	{
//TONY
//use talkname
//		bprint(self.netname);
		bprint(self.talkname);
		bprint("� ");
	}
	else
	{
		if (self.team == TEAM_COLOR1)
			bprint("������� ");
		else if (self.team == TEAM_COLOR2)
			bprint("�������� ");
		else
			bprint("���� ");
	}
};
//==========================================================
void () BotSayTeamStart2 =
{
	if (bots_have_normal_names)
	{
//TONY
//use talkname
//		bprintteam(self.netname);
		bprintteam(self.talkname);
		bprintteam("� ");
	}
	else
	{
		if (self.team == TEAM_COLOR1)
			bprintteam("������� ");
		else if (self.team == TEAM_COLOR2)
			bprintteam("�������� ");
		else
			bprintteam("���� ");
	}
};
//==========================================================
void (string st) BotSayMiddle =
{
	bprint(st);
};
//==========================================================
void (string st) BotSayTeamMiddle =
{
	bprintteam(st);
};
//==========================================================
void () BotSayEnd =
{
	bprint("\n");

	// note no attenuation, so that sound is played everywhere at max vol
	// to simulate the "talk beep"
	sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
};
//==========================================================
void () BotPlayTeamTalkBeep =
{
local entity p;
	
	// play sound on same team only... stuff cmd into console
	// so other players can't hear it
	p = find(world, classname, "player");
	while (p != world)
	{
		if (p.team == self.team)
			stuffcmd(p, "play misc/talk.wav\n");
		p = find(p, classname, "player");
	}
};
//==========================================================
void () BotSayTeamEnd =
{
	bprintteam("\n");
	
	BotPlayTeamTalkBeep();
};
//==========================================================
void (string st) BotSay =
{
	if (BotSayStart())
	{
		BotSayMiddle(st);
		BotSayEnd();
	}
};
//==========================================================
void (string st) BotSayTeam =
{
	if (BotSayTeamStart())
	{
		BotSayTeamMiddle(st);
		BotSayTeamEnd();
	}
};
/*
//==========================================================
void (string st) BotSayTeamPredefined =
{
local entity p;

	if (BotSayTeamStart())
	{
		p = find(world, classname, "player");
		while (p != world)
		{
			if (p.team == self.team)
				stuffcmd(p, st);
			p = find(p, classname, "player");
		}
		BotPlayTeamTalkBeep();
	}
};
*/
//==========================================================
void (entity player) BotSayEscort =
{
	if (bot_chatter_off)
		return;

	if (random() < 0.3)
	{
		local entity flag1, flag2, p;
		local float r;
		r = random();
		if (r < 0.125)
		{
			flag1 = find (world,classname, "item_flag_team1");
			flag2 = find (world,classname, "item_flag_team2");

			// If on team 2 switch meanings of flags
			if (self.team != TEAM_COLOR1) {
				p = flag1;
				flag1 = flag2;
				flag2 = p;
			}

			if (flag2.cnt == FLAG_AT_BASE)
			{
				if (BotSayTeamStart())
				{
					BotSayTeamMiddle("let's get their flag ");
					BotSayTeamMiddle(player.netname);
					BotSayTeamEnd();
				}
			}
		}
		else if (r < 0.25)
		{
			local entity p;
			p = find (world, classname, "item_artifact_invulnerability");
			if ((p != world) && (p.solid != SOLID_NOT))
			{
				if (BotSayTeamStart())
				{
					BotSayTeamMiddle("go get the pentagram ");
					BotSayTeamMiddle(player.netname);
					BotSayTeamEnd();
				}
			}
			else
			{
				p = find (world, classname, "item_artifact_super_damage");
				if ((p != world) && (p.solid != SOLID_NOT))
				{
					if (BotSayTeamStart())
					{
						BotSayTeamMiddle("go get the quad ");
						BotSayTeamMiddle(player.netname);
						BotSayTeamEnd();
					}
				}
				else if ((!bot_chatter_rated_g) && (BotSayStart()))
				{
					BotSayTeamMiddle("let's kill them ");
					BotSayTeamMiddle(player.netname);
					BotSayTeamEnd();
				}
			}
		}
		else if (r < 0.375)
			BotSayTeam("let's go get 'em");
		else if (r < 0.50)
			BotSayTeam("let's attack");
		else if ((!bot_chatter_rated_g) && (r < 0.75))
			BotSayTeam("let's kick some ass");
		else if (r < 0.995)
			BotSayTeam("go for it");
		else
		{
			if (BotSayTeamStart())
			{
				BotSayTeamMiddle("you're awesome ");
				BotSayTeamMiddle(player.netname);
				BotSayTeamEnd();
			}
		}
	}
};


//==========================================================
void () BotSayDefense =
{
	if (self.team != last_pickup_team)
	if (random() < 0.01)
	{
		local entity p;
		
		if (self.team == TEAM_COLOR1)
			p = find(world, classname, "item_flag_team1");
		else if (self.team == TEAM_COLOR2)
			p = find(world, classname, "item_flag_team2");
			
		if (p.cnt == FLAG_AT_BASE)
			return;		// already returned to base
	
		local float r;
		r = random();
		if (r < 0.1)
			BotSay("beefcake! BEEFCAKE!!!!");
		else if (r < 0.2)
			BotSay("Jerk Store!");
		else if (r < 0.3)
			BotSay("do we have any defenders?");
		else if ((!bot_chatter_rated_g) && (r < 0.4))
			BotSay("defense dammit");
		else if (r < 0.5)
			BotSay("defense?");
		else if ((!bot_chatter_rated_g) && (r < 0.6))
			BotSay("kill the carrier");
		else if (r < 0.7)
			BotSay("huh?");
		else if ((!bot_chatter_rated_g) && (r < 0.8))
			BotSay("what the hell?");
		else if (r < 0.9)
			BotSay("we need more defense");
		else if (r < 0.95)
			BotSay("get our flag back");
		else if (!bot_chatter_rated_g)
			BotSay("dammit");
	}
};

/*
//==========================================================
void () BotSayLetsGetEmPredefined =
{
	if (random() < 0.01)
	{
		local float r;
		r = random();
		if (r < 0.1)
			BotSayTeamPredefined("letsgo1\n");
		else if (r < 0.2)
			BotSayTeamPredefined("letsgo2\n");
		else if (r < 0.3)
			BotSayTeamPredefined("letsgo3\n");
		else if (r < 0.4)
			BotSayTeamPredefined("letsgo4\n");
		else if (r < 0.5)
			BotSayTeamPredefined("letsgo5\n");
		else if (r < 0.6)
			BotSayTeamPredefined("letsgo6\n");
		else if (r < 0.7)
			BotSayTeamPredefined("letsgo7\n");
		else if (r < 0.8)
			BotSayTeamPredefined("letsgo8\n");
		else if (r < 0.9)
			BotSayTeamPredefined("letsgo9\n");
		else
			BotSayTeamPredefined("letsgo10\n");
	}
};
*/

//==========================================================
void () BotSayLetsGetEm =
{
	if (random() < 0.01)
	{
		local float r;
		r = random();
		if (r < 0.1)
			BotSayTeam("lets get 'em");
		else if ((!bot_chatter_rated_g) && (r < 0.2))
			BotSayTeam("time for some serious killing");
		else if (r < 0.3)
			BotSayTeam("let's go!");
		else if ((!bot_chatter_rated_g) && (r < 0.4))
			BotSayTeam("let's kick some ass");
		else if ((!bot_chatter_rated_g) && (r < 0.5))
			BotSayTeam("it's ass-kickin' time");
		else if ((!bot_chatter_rated_g) && (r < 0.6))
			BotSayTeam("they're doomed");
		else if ((!bot_chatter_rated_g) && (r < 0.7))
			BotSayTeam("time to kill!");
		else if (r < 0.8)
			BotSayTeam("we gonna win");
		else if ((!bot_chatter_rated_g) && (r < 0.9))
			BotSayTeam("we're gonna kick some ass");
		else
			BotSayTeam("we're gonna rule this level");
	}
};
//==========================================================
void () BotSayDammit =
{
	if (self.team != last_capture_team)
	if (random() < 0.01)
	{
		local float r;
		r = random();
		if (r < 0.1)
			BotSay("no way");
		else if ((!bot_chatter_rated_g) && (r < 0.2))
			BotSay("crap");
		else if ((!bot_chatter_rated_g) && (r < 0.3))
			BotSay("wtf?");
		else if ((!bot_chatter_rated_g) && (r < 0.4))
			BotSay("no freakin way");
		else if ((!bot_chatter_rated_g) && (r < 0.5))
			BotSay("dammit!");
		else if (r < 0.6)
			BotSay("i can't believe it");
		else if (r < 0.7)
			BotSay("what happened?");
		else if ((!bot_chatter_rated_g) && (r < 0.8))
			BotSay("what the hell?");
		else if ((!bot_chatter_rated_g) && (r < 0.9))
			BotSay("huh?");
		else if (!bot_chatter_rated_g) 
			BotSay("total bs");
	}
};

/*
//==========================================================
void () BotSayGoodGame =
{
	if (random() < 0.01)
	{
		local float r;
		r = random();
		if (r < 0.1)
			BotSay("good game");
		else if (r < 0.2)
			BotSay("that was fun");
		else if (r < 0.3)
			BotSay("nice game");
		else if (r < 0.4)
			BotSay("fun");
		else if (r < 0.5)
			BotSay("great one");
		else if (r < 0.6)
			BotSay("nice one");
		else if (r < 0.7)
			BotSay("loved it");
		else if (r < 0.8)
			BotSay("that was fantastic");
		else if (r < 0.9)
			BotSay("good game everyone");
		else
			BotSay("fun!");
	}
};
*/

//==========================================================
void (entity p) BotSayTaunt =
{
	if (p == world)
		return;
	if (p.classname != "player")
		return;

	if (bot_chatter_rated_g)
		return;

	if (random() < 0.003)
	{
		if (BotSayStart())
		{
			local float r;
			r = random();
			if (r < 0.1)
				BotSayMiddle("how'd you like that one ");
			else if (r < 0.2)
				BotSayMiddle("nice try ");
			else if (r < 0.3)
				BotSayMiddle("try again ");
			else if (r < 0.4)
				BotSayMiddle("no soup for you ");
			else if (r < 0.5)
				BotSayMiddle("poor ");
			else if (r < 0.6)
				BotSayMiddle("i'm still here ");
			else if (r < 0.7)
				BotSayMiddle("no can do ");
			else if (r < 0.8)
				BotSayMiddle("got you ");
			else if (r < 0.9)
				BotSayMiddle("missed me ");
			else
				BotSayMiddle("sorry ");

			BotSayMiddle(p.netname);
			BotSayEnd();
		}
	}
};
//==========================================================
void (entity p) BotSayNiceOne1 =
{
local float r;

	r = random();
	if (r < 0.1)
		BotSayMiddle("nice one ");
	else if (r < 0.2)
		BotSayMiddle("great shot ");
	else if (r < 0.3)
		BotSayMiddle("awesome tactics ");
	else if (r < 0.4)
		BotSayMiddle("great combat ");
	else if ((!bot_chatter_rated_g) && (r < 0.5))
		BotSayMiddle("you're a psycho killer ");
	else if (r < 0.6)
		BotSayMiddle("you're a maniac ");
	else if (r < 0.7)
		BotSayMiddle("you're awesome ");
	else if (r < 0.8)
	{
		BotSayMiddle(p.netname);
		BotSayMiddle(" got me good");
		BotSayEnd();
		return;
	}
	else if (r < 0.9)
		BotSayMiddle("how'd you do that ");
	else
		BotSayMiddle("you're incredible ");

	BotSayMiddle(p.netname);
	BotSayEnd();
};
//==========================================================
void (entity p) BotSayNiceOne2 =
{
local float r;

	r = random();
	if (r < 0.1)
		BotSayMiddle("that was fantastic ");
	else if (r < 0.2)
		BotSayMiddle("you're good ");
	else if (r < 0.3)
		BotSayMiddle("very sneaky ");
	else if (r < 0.4)
		BotSayMiddle("great tactics ");
	else if (r < 0.5)
		BotSayMiddle("great reflexes ");
	else if (r < 0.6)
		BotSayMiddle("incredible aim ");
	else if (r < 0.7)
		BotSayMiddle("you're awesome ");
	else if (r < 0.8)
		BotSayMiddle("good one ");
	else if (r < 0.9)
		BotSayMiddle("that was a nice one ");
	else
		BotSayMiddle("wow ");

	BotSayMiddle(p.netname);
	BotSayEnd();
};
//==========================================================
void (entity p) BotSayNiceOne =
{
	if (p == world)
		return;
	if (p.classname != "player")
		return;

	if (random() < 0.003)
	{
		if (BotSayStart())
		{
			if (random() < 0.5)
				BotSayNiceOne1(p);
			else
				BotSayNiceOne2(p);
		}
	}
};

//==========================================================
void () BotSayExtras1 =
{
	if (bot_chatter_rated_g)
		return;
		
	if (random() < 0.3)
	{
		local float r;
		r = random();
		if (r < 0.05)
			BotSay("frag them all");
		else if (r < 0.10)
			BotSay("frag fest baby");
		else if (r < 0.15)
			BotSay("i want to kill");
		else if (r < 0.20)
			BotSay("i love ass-kicking");
		else if (r < 0.25)
			BotSay("i love a good frag fest");
		else if (r < 0.30)
			BotSay("it's gibbin' time");
		else if (r < 0.35)
			BotSay("kill kill kill");
		else if (r < 0.40)
			BotSay("i love killing");
		else if (r < 0.45)
			BotSay("i'm going to kill you all");
		else if (r < 0.50)
			BotSay("killing is my life");
		else if (r < 0.55)
			BotSay("frag frag frag");
		else if (r < 0.60)
			BotSay("kill 'em all");
		else if (r < 0.65)
			BotSay("i love this level");
		else if (r < 0.70)
			BotSay("me kill good");
		else if (r < 0.75)
			BotSay("this is my favorite map");
		else if (r < 0.80)
			BotSay("it's a frag-a-thon");
		else if (r < 0.85)
			BotSay("welcome to fragtown");
		else if (r < 0.90)
			BotSay("psycho killer time");
		else if (r < 0.95)
			BotSay("me want blood");
		else
			BotSay("shoot 'em if you got 'em");		// thanks Fletch
	}
};

//==========================================================
void () BotSayExtras2 =
{
	if (bot_chatter_rated_g)
		return;
		
	if (random() < 0.3)
	{
		local float r;
		r = random();
		if (r < 0.05)
			BotSay("you are all dead meat");
		else if (r < 0.10)
			BotSay("i love quad");
		else if (r < 0.15)
			BotSay("who else loves quad?");
		else if (r < 0.20)
			BotSay("me shoot you now");
		else if (r < 0.25)
			BotSay("this map kicks ass");
		else if (r < 0.30)
			BotSay("lets go team");
		else if (r < 0.35)
			BotSay("remember teamwork pays off");
		else if (r < 0.40)
			BotSay("watch your back");
		else if (r < 0.45)
			BotSay("help your teammates");
		else if (r < 0.50)
			BotSay("heads up everyone");
		else if (r < 0.55)
			BotSay("this kicks ass");
		else if (r < 0.60)
			BotSay("i love it");
		else if (r < 0.65)
			BotSay("gibs everywhere");
		else if (r < 0.70)
			BotSay("i will now kill");
		else if (r < 0.75)
			BotSay("kick butt");
		else if (r < 0.80)
			BotSay("i love watching gibs fly");
		else if (r < 0.85)
			BotSay("non-stop fragging");
		else if (r < 0.90)
			BotSay("bloody chunks");
		else if (r < 0.95)
			BotSay("blood! blood!");
		else
			BotSay("i love the rocket launcher");
	}
};
//==========================================================
void () BotSayExtras =
{
	if (bot_chatter_rated_g)
		return;
		
	if (random() < 0.3)
	{
		if (random() < 0.5)
			BotSayExtras1();
		else
			BotSayExtras2();
	}
};
//==========================================================
// self is the player
//==========================================================
float (float fteam) IsHumanOnTeam =
{
local entity p;

	p = find(world, classname, "player");
	while (p != world)
	{
		if (p.team == fteam)
			return TRUE;
		p = find(p, classname, "player");
	}
	
	return FALSE;
};
//==========================================================
//==========================================================
float (float fteam) GetNumTeamCaptures =
{
local entity p;
local float sum;

	p = find(world, classname, "bot");
	while (p != world)
	{
		if (p.team == fteam)
			sum = sum + p.num_captures;
		p = find(p, classname, "bot");
	}
	p = find(world, classname, "player");
	while (p != world)
	{
		if (p.team == fteam)
			sum = sum + p.num_captures;
		p = find(p, classname, "player");
	}
	return sum;
};
//==========================================================
//==========================================================
float (float fteam) GetNumTeamFrags =
{
local entity p;
local float sum;

	p = find(world, classname, "bot");
	while (p != world)
	{
		if (p.team == fteam)
			sum = sum + p.frags;
		p = find(p, classname, "bot");
	}
	p = find(world, classname, "player");
	while (p != world)
	{
		if (p.team == fteam)
			sum = sum + p.frags;
		p = find(p, classname, "player");
	}
	return sum;
};
//==========================================================
//==========================================================
float (float fteam) TeamHasFlag =
{
local entity p;

	if (fteam == TEAM_COLOR1)
		p = find(world, classname, "item_flag_team1");
	else if (fteam == TEAM_COLOR2)
		p = find(world, classname, "item_flag_team2");
	else
		error("Bogus Team\n");

	if (p.cnt == FLAG_CARRIED)
	if (p.owner.team == fteam)
		return TRUE;
		
	return FALSE;
};
//==========================================================
// self is the player
//==========================================================
void (float fteam) PrintTeamStatus =
{
local float f, fe, fenemyteam, n_flag, n_attack, n_defend; 
local float n_roam, n_camp, n_escort, n_bot, n_human;
local entity p;
local string st;
		
	if (self.classname != "player")
		return;
		
	n_flag = 0;
	n_attack = 0;
	n_defend = 0;
	n_roam = 0;
	n_camp = 0;
	n_escort = 0;
	p = find(world, classname, "bot");
	while (p != world)
	{
		if (p.team == self.team)
		{
			if (p.player_flag & ITEM_ENEMY_FLAG)
				n_flag = TRUE;
			else if (time < (p.camping_time + CAMPING_TIME))
				n_camp = n_camp + 1;
			else if (time < (p.escort_time + ESCORT_TIME))
				n_escort = n_escort + 1;
			else if (p.bot_plan == BOT_ATTACK)
				n_attack = n_attack + 1;
			else if (p.bot_plan == BOT_DEFEND)
				n_defend = n_defend + 1;
			else if (p.bot_plan == BOT_ROAM)
				n_roam = n_roam + 1;
				
			n_bot = n_bot + 1;
		}
		p = find(p, classname, "bot");
	}

	p = find(world, classname, "player");
	while (p != world)
	{
		if (p.team == self.team)
			n_human = n_human + 1;
		p = find(p, classname, "player");
	}

	sprint(self, "\n");
	
	if (self.team == TEAM_COLOR1)
	{
		sprint(self, "��� Team Status:\n");
		fenemyteam = TEAM_COLOR2;
	}
	else if (self.team == TEAM_COLOR2)
	{
		sprint(self, "���� Team Status:\n");
		fenemyteam = TEAM_COLOR1;
	}

	/*
	f = GetNumTeamFrags(fteam);
	fe = GetNumTeamFrags(fenemyteam);	
	st = ftos(f - fe);
	if ((f - fe) > 0)
		sprint(self, "+");
	sprint(self, st);
	sprint(self, " frags, ");
	
	f = GetNumTeamCaptures(fteam);
	fe = GetNumTeamCaptures(fenemyteam);
	st = ftos(f - fe);
	if ((f - fe) > 0)
		sprint(self, "+");
	sprint(self, st);
	sprint(self, " captures\n");
	*/
	
	if (map_has_waypoints)
	{
		st = ftos(n_attack);
		sprint(self, st);
		sprint(self, " attack, ");
		st = ftos(n_defend);
		sprint(self, st);
		sprint(self, " defend, ");
		st = ftos(n_roam);
		sprint(self, st);
		sprint(self, " roam\n");
	}
	st = ftos(n_escort);
	sprint(self, st);
	sprint(self, " escort, ");
	st = ftos(n_camp);
	sprint(self, st);
	sprint(self, " camp, ");
	
	if (n_flag)
		sprint(self, "1 flag carrier");

	sprint(self, "\n");

	/*
	st = ftos(n_bot);
	sprint(self, st);
	sprint(self, " bots, ");
	
	st = ftos(n_human);
	sprint(self, st);
	if (n_human == 1)
		sprint(self, " human\n");
	else
		sprint(self, " humans\n");
	*/
};
//==========================================================
// self is player
//==========================================================
void (float fteam) MoreBotsDefend =
{
local entity p;
local float found;

	if (!map_has_waypoints)
	{
		sprint(self, "map has no waypoints\n");
		sprint(self, "orders not possible\n");
		return;
	}
	
	found = FALSE;
	
	// take first out of roaming pool
	
	p = find(world, classname, "bot");
	while ((p != world) && (!found))
	{
		if (p.team == fteam)
		if (time >= (p.camping_time + CAMPING_TIME))
		if (time >= (p.escort_time + ESCORT_TIME))
		if (p.bot_plan == BOT_ROAM)
		if (!(p.player_flag & ITEM_ENEMY_FLAG))
		{
			p.bot_plan = BOT_DEFEND;
			found = TRUE;
		}

		p = find(p, classname, "bot");
	}
	
	// if no roamers, take out of attacker pool
	
	if (!found)
	{
		p = find(world, classname, "bot");
		while ((p != world) && (!found))
		{
			if (p.team == fteam)
			if (time >= (p.camping_time + CAMPING_TIME))
			if (time >= (p.escort_time + ESCORT_TIME))
			if (p.bot_plan == BOT_ATTACK)
			if (!(p.player_flag & ITEM_ENEMY_FLAG))
			{
				p.bot_plan = BOT_DEFEND;
				found = TRUE;
			}

			p = find(p, classname, "bot");
		}
	}
	
	// if no attackers, take out of camping pool

	if (!found)
	{
		p = find(world, classname, "bot");
		while ((p != world) && (!found))
		{
			if (p.team == fteam)
			if (time < (p.camping_time + CAMPING_TIME))
			if (time >= (p.escort_time + ESCORT_TIME))
			if (!(p.player_flag & ITEM_ENEMY_FLAG))
			if (p.bot_plan != BOT_DEFEND)
			{
				p.bot_plan = BOT_DEFEND;
				p.camping_time = time - 99;
				found = TRUE;
			}

			p = find(p, classname, "bot");
		}
	}

	
	// if no campers, take out of escort pool

	if (!found)
	{
		p = find(world, classname, "bot");
		while ((p != world) && (!found))
		{
			if (p.team == fteam)
			if (p.bot_plan != BOT_DEFEND)
			if (time >= (p.camping_time + CAMPING_TIME))
			if (time < (p.escort_time + ESCORT_TIME))
			if (!(p.player_flag & ITEM_ENEMY_FLAG))
			{
				p.bot_plan = BOT_DEFEND;
				p.camping_time = time - 99;
				found = TRUE;
			}

			p = find(p, classname, "bot");
		}
	}

//TONY
//DEATHMATCH 5
	if((!(temp1 & TEMP1_NOMESS)) && (found == TRUE))
	{
		stuffcmd(self,"play ctfbot/yessir\n");
	}
	
	
	sprint(self, self.netname);
	sprint(self, " orders ������đ ");		// DEFEND
	PrintTeamStatus();
};
//==========================================================
void (float fteam) MoreBotsAttack =
{
local entity p;
local float found;

	if (!map_has_waypoints)
	{
		sprint(self, "map has no waypoints\n");
		sprint(self, "orders not possible\n");
		return;
	}

	found = FALSE;

	// take first out of roaming pool
	
	p = find(world, classname, "bot");
	while ((p != world) && (!found))
	{
		if (p.team == fteam)
		if (p.bot_plan == BOT_ROAM)
		if (time >= (p.camping_time + CAMPING_TIME))
		if (time >= (p.escort_time + ESCORT_TIME))
		if (!(p.player_flag & ITEM_ENEMY_FLAG))
		{
			p.bot_plan = BOT_ATTACK;
			found = TRUE;
		}

		p = find(p, classname, "bot");
	}
	
	// if no roamers, take out of defender pool
	
	if (!found)
	{
		p = find(world, classname, "bot");
		while ((p != world) && (!found))
		{
			if (p.team == fteam)
			if (!(p.player_flag & ITEM_ENEMY_FLAG))
			if (time >= (p.camping_time + CAMPING_TIME))
			if (time >= (p.escort_time + ESCORT_TIME))
			if (p.bot_plan == BOT_DEFEND)
			{
				p.bot_plan = BOT_ATTACK;
				found = TRUE;
			}

			p = find(p, classname, "bot");
		}
	}
	
	// if no defenders, take out of camping pool

	if (!found)
	{
		p = find(world, classname, "bot");
		while ((p != world) && (!found))
		{
			if (p.team == fteam)
			if (!(p.player_flag & ITEM_ENEMY_FLAG))
			if (time >= (p.escort_time + ESCORT_TIME))
			if (p.bot_plan != BOT_ATTACK)
			{
				p.bot_plan = BOT_ATTACK;
				p.camping_time = time - 999;
				if (p.camping_entity != world)
				{	
					remove(p.camping_entity);
					p.camping_entity = world;
				}
				found = TRUE;
			}

			p = find(p, classname, "bot");
		}
	}

	// if no campers, take out of escort pool

	if (!found)
	{
		p = find(world, classname, "bot");
		while ((p != world) && (!found))
		{
			if (p.team == fteam)
			if (!(p.player_flag & ITEM_ENEMY_FLAG))
			if (time >= (p.camping_time + CAMPING_TIME))
			if (time < (p.escort_time + ESCORT_TIME))
			if (p.bot_plan != BOT_ATTACK)
			{
				p.bot_plan = BOT_ATTACK;
				p.escort_time = time - 999;
				found = TRUE;
			}

			p = find(p, classname, "bot");
		}
	}

//TONY
//no mess
	if((!(temp1 & TEMP1_NOMESS)) && (found == TRUE))
	{
		stuffcmd(self,"play ctfbot/yessir\n");
	}
	
	sprint(self, self.netname);
	sprint(self, " orders ������ˑ ");		// ATTACK
	PrintTeamStatus();
};
//==========================================================
void (float fteam) MoreBotsRoam =
{
local entity p;
local float found;

	if (!map_has_waypoints)
	{
		sprint(self, "map has no waypoints\n");
		sprint(self, "orders not possible\n");
		return;
	}

	found = FALSE;
	
	// take out of attacker pool

	p = find(world, classname, "bot");
	while ((p != world) && (!found))
	{
		if (p.team == fteam)
		if (!(p.player_flag & ITEM_ENEMY_FLAG))
		if (time >= (p.camping_time + CAMPING_TIME))
		if (time >= (p.escort_time + ESCORT_TIME))
		if (p.bot_plan == BOT_ATTACK)
		{
			p.bot_plan = BOT_ROAM;
			found = TRUE;
		}
		
		p = find(p, classname, "bot");
	}
	
	// if no attackers, take out of defender pool

	if (!found)
	{
		p = find(world, classname, "bot");
		while ((p != world) && (!found))
		{
			if (p.team == fteam)
			if (!(p.player_flag & ITEM_ENEMY_FLAG))
			if (time >= (p.camping_time + CAMPING_TIME))
			if (time >= (p.escort_time + ESCORT_TIME))
			if (p.bot_plan == BOT_DEFEND)
			{
				p.bot_plan = BOT_ROAM;
				found = TRUE;
			}

			p = find(p, classname, "bot");
		}
	}
	
	// if no defenders, take out of camping pool

	if (!found)
	{
		p = find(world, classname, "bot");
		while ((p != world) && (!found))
		{
			if (p.team == fteam)
			if (!(p.player_flag & ITEM_ENEMY_FLAG))
			if (time < (p.camping_time + CAMPING_TIME))
			if (time >= (p.escort_time + ESCORT_TIME))
			if (p.bot_plan != BOT_ROAM)
			{
				p.bot_plan = BOT_ROAM;
				p.camping_time = time - 999;
				if (p.camping_entity != world)
				{	
					remove(p.camping_entity);
					p.camping_entity = world;
				}
				found = TRUE;
			}

			p = find(p, classname, "bot");
		}
	}

	// if no campers, take out of escort pool

	if (!found)
	{
		p = find(world, classname, "bot");
		while ((p != world) && (!found))
		{
			if (p.team == fteam)
			if (!(p.player_flag & ITEM_ENEMY_FLAG))
			if (time >= (p.camping_time + CAMPING_TIME))
			if (time < (p.escort_time + ESCORT_TIME))
			if (p.bot_plan != BOT_ROAM)
			{
				p.bot_plan = BOT_ROAM;
				p.escort_time = time - 999;
				found = TRUE;
			}

			p = find(p, classname, "bot");
		}
	}

//TONY
//no mess
	if((!(temp1 & TEMP1_NOMESS)) && (found == TRUE))
	{
		stuffcmd(self,"play ctfbot/yessir\n");
	}

	sprint(self, self.netname);
	sprint(self, " orders ����͑ ");		// ROAM
	PrintTeamStatus();
};
//==========================================================
//==========================================================
void (float fteam) AllBotsDefend =
{
local entity p;

	if (!map_has_waypoints)
	{
		sprint(self, "map has no waypoints\n");
		sprint(self, "orders not possible\n");
		return;
	}

	sprint(self, self.netname);
	sprint(self, " orders ");

	if (self.team == TEAM_COLOR1)
	{
		sprint(self, "��� team to defend\n");
		last_order_time_team1 = time;
	}
	else if (self.team == TEAM_COLOR2)
	{
		sprint(self, "���� team to defend\n");
		last_order_time_team2 = time;
	}
	else
		return;


	p = find(world, classname, "bot");
	while (p != world)
	{
		if (p.team == fteam)
		{
			p.bot_plan = BOT_DEFEND;
		}
		
		p = find(p, classname, "bot");
	}
//TONY
//no mess
	if(!(temp1 & TEMP1_NOMESS))
	{
		stuffcmd(self,"play ctfbot/yessir\n");
	}

};
//==========================================================
void (float fteam) AllBotsAttack =
{
local entity p;

	if (!map_has_waypoints)
	{
		sprint(self, "map has no waypoints\n");
		sprint(self, "orders not possible\n");
		return;
	}

	sprint(self, self.netname);
	sprint(self, " orders ");
	
	if (self.team == TEAM_COLOR1)
	{
		sprint(self, "��� team to attack\n");
		last_order_time_team1 = time;
	}
	else if (self.team == TEAM_COLOR2)
	{
		sprint(self, "���� team to attack\n");
		last_order_time_team2 = time;
	}
	else
		return;

	p = find(world, classname, "bot");
	while (p != world)
	{
		if ((p.team == fteam) && (!(p.player_flag & ITEM_ENEMY_FLAG)))
		{
			p.bot_plan = BOT_ATTACK;
		}
		
		p = find(p, classname, "bot");
	}
//TONY
//no mess
	if(!(temp1 & TEMP1_NOMESS))
	{
		stuffcmd(self,"play ctfbot/yessir\n");
	}

};

//==========================================================
void () ToggleWaypoints =
{
	if (map_has_waypoints)
	{
		map_has_waypoints = FALSE;
		bprint("waypoints disabled for ");
	}
	else
	{
		local entity p;
		p = find(world, classname, "waypoint");
		if (p != world)
		{
			map_has_waypoints = TRUE;
			bprint("waypoints re-enabled for ");
		}
		else if (self.classname == "player")
		{
			bprint("no waypoints for ");
		}
	}

	bprint(mapname);
	bprint("\n");
};
//==========================================================
//==========================================================
entity (entity head) FindNextPlayerOrBot =
{
local entity h;

	h = head;
	
	if (h.classname == "bot")
		h = find(h, classname, "bot");
	else
	{ 
		h = find(h, classname, "player");
		
		// start finding bots
		if (h == world)
			h = find(world, classname, "bot");
	}
	
	return h;
};

//==========================================================
//==========================================================
void () RemoveAllBots =
{
local entity p;

	p = find(world, classname, "bot");
	if (p != world)
	{
		while (p != world)
		{
			local entity old_self;
			local entity removebot;

			old_self = self;
			self = p;
			ClientDisconnect();
			self = old_self;

			remove(p);
			p = find(world, classname, "bot");
		}

		next_bot_num = 0;
		next_bot_red = 0;
		next_bot_blue = 0;

		bprint("All bots have been removed\n");
	}
};

//
//TONY
// Change sv_aim to control red and blue teams seperately
//
//
//RED = teamsize/4(after skill and 64 bit sub)
//BLUE = teamsize/128(after skill and 64 bit sub)


//==========================================================
//==========================================================
void () BotKeepTeamsEven =
{
local entity p, oself;
local float n_red, n_blue;
local float /*teamsize, */i, svaim, tmp, added, bskill, bskill2, vary_skill;
local string st;

//TONY
local float teamsize_blue, teamsize_red;

//	if (!(teamplay & TEAM_CAPTURE_AUTO_EVEN_TEAMS))
	if (!(temp1 & TEMP1_AUTO_EVEN_TEAMS))
		return;

	n_red = 0;
	p = find(world, classname, "player");
	while (p != world)
	{
		if (p.team == TEAM_COLOR1)
			n_red = n_red + 1;
		p = FindNextPlayerOrBot(p);
	}
	
	n_blue = 0;
	p = find(world, classname, "player");
	while (p != world)
	{
		if (p.team == TEAM_COLOR2)
			n_blue = n_blue + 1;
		p = FindNextPlayerOrBot(p);
	}	
	
	// find a client
	p = find(world, classname, "player");
	if (p == world)
	{
		bprint("No human players\n");
		RemoveAllBots();
		return;
	}
	
	oself = self;
	self = p;
	
	added = FALSE;

	svaim = cvar("sv_aim");		// why doesn't cvar("maxplayers") work?
	if ((svaim >= 0) && (svaim <= 1))
		return;
		
	bskill = 0;
	if (svaim & 1)
	{
		svaim = svaim - 1;
		bskill = bskill + 1;
	}
	if (svaim & 2)
	{
		svaim = svaim - 2;
		bskill = bskill + 2;
	}
	if (svaim & 64)
	{
		svaim = svaim - 64;
		vary_skill = TRUE;
	}
	else
		vary_skill = FALSE;
	
	// get fractional skill part
	bskill = bskill + (svaim - floor(svaim));
	svaim = floor(svaim);

	teamsize_blue = svaim / 128;
	teamsize_blue = floor(teamsize_blue);

	svaim = svaim - (teamsize_blue * 128);
		
	teamsize_red = svaim / 4;
	teamsize_red = floor(teamsize_red);

	if (n_red < teamsize_red)
	{
		i = (teamsize_red - n_red);

		bprint("keeping teams even:\nAdding ");
		st = ftos(i);
		bprint(st);
		bprint(" ��� bots\n");
		
		added = TRUE;

		while (i > 0)
		{
			bskill2 = bskill;
			if (vary_skill)
				bskill2 = bskill2 + (random() - 0.5);
			if (bskill2 > 3) bskill2 = 3;
			if (bskill2 < 0) bskill2 = 0;
			CreateRedBot(bskill2);
			i = i - 1;
		}
	}
	else if (n_red > teamsize_red)
	{
		i = (n_red - teamsize_red);

		bprint("keeping teams even:\nRemoving ");
		st = ftos(i);
		bprint(st);
		bprint(" ��� bots\n");
		
		added = TRUE;

		while (i > 0)
		{
			RemoveBestBot(TEAM_COLOR1);
			i = i - 1;
		}
	}
	
	if (n_blue < teamsize_blue)
	{
		i = (teamsize_blue - n_blue);

		bprint("keeping teams even:\nAdding ");
		st = ftos(i);
		bprint(st);
		bprint(" ���� bots\n");
		
		added = TRUE;

		while (i > 0)
		{
			bskill2 = bskill;
			if (vary_skill)
				bskill2 = bskill2 + (random() - 0.5);
			if (bskill2 > 3) bskill2 = 3;
			if (bskill2 < 0) bskill2 = 0;
			CreateBlueBot(bskill2);
			i = i - 1;
		}
	}
	else if (n_blue > teamsize_blue)
	{
		i = (n_blue - teamsize_blue);

		bprint("keeping teams even:\nRemoving ");
		st = ftos(i);
		bprint(st);
		bprint(" ���� bots\n");
		
		added = TRUE;

		while (i > 0)
		{
			RemoveBestBot(TEAM_COLOR2);
			i = i - 1;
		}
	}
	
	self = oself;
};

//=============================================================
// massive hack routine to just make sure that bots always stay
// alive...  there may be a bug that makes bots "die" by them
// not getting their nextthink routine set properly, so this
// routine just makes sure their nextthink/think are valid.
// THIS IS A MASSIVE HACK.  IF I CAN FIND A REPRODUCIBLE CASE
// OF THE BOT STUCK thing then I will just fix that bug and
// remove this.  In fact the bug may already be fixed, who knows.
//=============================================================
void () BotSanityCheck =
{
local entity p;

	if (intermission_running)
		return;

	p = find(world, classname, "bot");
	while (p != world)
	{
		if (p.nextthink < (time - 5))		// somehow bot got screwed up?
		{
			p.think = BotAnimationThink;
			p.nextthink = time + 0.1;
			dprint(p.netname);
			dprint(" sanity check bug fix\n");
		}
		p = find(p, classname, "bot");
	}
};

//=============================================================
//=============================================================
void () EvenTeamsThink =
{
	if (intermission_running)
		return;

//	if (bot_debug >= 2)
//	{
//		dprint("EvenTeamsThink\n");
//	}
	
	self.nextthink = time + 30;

	BotKeepTeamsEven();
	
	BotSanityCheck();
};
/*
//=============================================================
//=============================================================
void (vector src, vector dst, entity bot) SpawnThinkHelper =
{
};
//=============================================================
//=============================================================
void () TempWaypointTouch =
{
	if (other == self.check_bot)
	{
//		if (bot_debug >= 1)
//		{
//			dprint(other.netname);
//			dprint(" reached goal successfully\n");
//		}
		
		SpawnThinkHelper(check_src, self.origin, )
	}
};
//=============================================================
//=============================================================
void (vector src, vector dst, entity bot) SpawnCheckSuccessEntity =
{
local entity p;

//	if (bot_debug >= 4)
//	{
//		dprint("SpawnTempWaypoint\n");
//	}
		
	p = spawn();
	p.classname = "think_helper_test";
	p.team = fteam;
	p.solid = SOLID_TRIGGER;
	p.movetype = MOVETYPE_NONE;
	p.origin = dst;
	setorigin(p, p.origin);
	setmodel(p, "progs/s_bubble.spr");
	p.touch = CheckSuccessTouch;
	p.think = SUB_Remove;
	p.nextthink = time + 5;
	
	p.check_bot = self;
	p.check_src =
};
*/
//=============================================================
//=============================================================
void () TempWaypointTouch =
{
	if (other.classname == "bot")
	{
//		if (bot_debug >= 1)
//		{
//			dprint(other.netname);
//			dprint(" reached temp waypoint\n");
//		}
		remove(self);
	}
};
//=============================================================
//=============================================================
void (vector org, float timeout, float fteam) SpawnTempWaypoint =
{
local entity p;

//	if (bot_debug >= 4)
//	{
//		dprint("SpawnTempWaypoint\n");
//	}
		
	p = spawn();
	p.classname = "waypoint_temp";
	p.team = fteam;
	p.solid = SOLID_TRIGGER;
	p.movetype = MOVETYPE_NONE;
	p.origin = org;
	setorigin(p, p.origin);
	//setmodel(p, "progs/s_bubble.spr");
	setmodel(p, string_null);
	p.touch = TempWaypointTouch;
	p.think = SUB_Remove;
	p.nextthink = time + timeout;
};
//=============================================================
//=============================================================
void () SpawnEvenTeamEntity =
{
local entity p;

//	if (bot_debug >= 4)
//	{
//		dprint("SpawnEvenTeamEntity\n");
//	}
	
	p = find(world, classname, "eventeams");
	if (p != world)
		return;
	
	p = spawn();
	p.solid = SOLID_NOT;
	p.movetype = MOVETYPE_NONE;
	p.classname = "eventeams";
	setmodel(p, string_null);
	p.think = EvenTeamsThink;
	p.nextthink = time + 30;
};
//==========================================================
//==========================================================
entity () SpawnFollow =
{
	local entity p;
	p = spawn();
	p.classname = "follow_ent";
	p.solid = SOLID_NOT;
	p.movetype = MOVETYPE_NONE;
	
	//setmodel(p, "progs/s_bubble.spr");
	setmodel(p, string_null);
		
	p.origin = self.origin + '0 0 16';
	setorigin(p, p.origin);
	p.owner = self;
	return p;
};
//==========================================================
//==========================================================
void () SpawnFollowEntity =
{
local entity e;

	if (time < (self.last_follow_spawn + 0.4))		// how often to spawn
		return;
		
	// remove oldest follow ent
	if (self.num_follows > 3)
	{
		if (self.follow_tail != world)
		{
			e = self.follow_tail.follow_prev;
			remove(self.follow_tail);
			self.follow_tail = e;
			
			self.num_follows = self.num_follows - 1;
		}
	}
	
	// add
	e = SpawnFollow();
	self.num_follows = self.num_follows + 1;
	if (self.follow_head == world)
	{
		// first one
		e.follow_next = world;
		e.follow_prev = world;
		self.follow_head = e;
		self.follow_tail = e;
	}
	else
	{
		e.follow_next = self.follow_head;
		e.follow_prev = world;
		self.follow_head.follow_prev = e;
		self.follow_head = e;
	}
	
	self.last_follow_spawn = time;
};
//==========================================================
//==========================================================
void () SwitchBotNames =
{
local entity p;

	bots_have_normal_names = !bots_have_normal_names;
	
	if (bots_have_normal_names)
		bprint("Bots now have normal names\n");
	else
		bprint("Bots now have bot names\n");

	p = find(world, classname, "bot");
	while (p != world)
	{
		if (bots_have_normal_names)
			p.netname = p.altname;
		else
			p.netname = p.botname;
		
		p = find(p, classname, "bot");
	}
};

//==========================================================
void (float fteam) ReportIn =
{
local entity p;
local entity oldself;

	p = find(world, classname, "bot");
	while (p != world)
	{
		if (p.team == fteam)
		{
			oldself = self;
			self = p;
			BotSayTeamStart2();
			if (p.player_flag & ITEM_ENEMY_FLAG)
				BotSayTeamMiddle("I have flag with ");
			else if (time < (p.camping_time + CAMPING_TIME))
				BotSayTeamMiddle("I camp with ");
			else if (time < (p.escort_time + ESCORT_TIME))
			{
				BotSayMiddle("I escort ");
				if (p.escort_entity == world)
					BotSayTeamMiddle("???");	// what happened?  bug somewhere!
				else
					BotSayTeamMiddle(p.escort_entity.netname);
				BotSayTeamMiddle(" with ");
			}
			else if (p.bot_plan == BOT_DEFEND)
				BotSayTeamMiddle("I defend with ");
			else if (p.bot_plan == BOT_ATTACK)
				BotSayTeamMiddle("I attack with ");
			else if (p.bot_plan == BOT_ROAM)
				BotSayTeamMiddle("I roam with ");
			else
				BotSayTeamMiddle("???? with ");
				
			if ((p.items & IT_LIGHTNING) && (p.ammo_cells > 0))
				BotSayTeamMiddle("lightning gun");
			else if ((p.items & IT_ROCKET_LAUNCHER) && (p.ammo_rockets > 0))
				BotSayTeamMiddle("rocket launcher");
			else if ((p.items & IT_GRENADE_LAUNCHER) && (p.ammo_rockets > 0))
				BotSayTeamMiddle("grenade launcher");
			else if ((p.items & IT_SUPER_NAILGUN) && (p.ammo_nails > 0))
				BotSayTeamMiddle("super nailgun");
			else if ((p.items & IT_NAILGUN) && (p.ammo_nails > 0))
				BotSayTeamMiddle("nailgun");
			else if ((p.items & IT_SUPER_SHOTGUN) && (p.ammo_shells > 0))
				BotSayTeamMiddle("double shotgun");
			else
				BotSayTeamMiddle("shotgun");
					
			BotSayTeamEnd();
			self = oldself;
		}
		
		p = find(p, classname, "bot");
	}
};

//==========================================================
void () BotSaySomething =
{
	if (bot_chatter_off)
		return;

	if (random() < 0.001)
	{
		BotSayExtras();
	}
	else if ((time > last_flag_capture + 3) && (time < last_flag_capture + 8))
	{
		BotSayDammit();
	}
	else if ((time > last_flag_pickup + 3) && (time < last_flag_pickup + 8))
	{
		BotSayDefense();
	}
	/*
	else if ((time > level_over_time + 3) && (time < level_over_time + 8))
	{
		BotSayGoodGame();
	}
	*/
	else if (time < (self.spawn_time + 5))
	{
		BotSayLetsGetEm();
	}
	else if ((time > self.last_kill_time + 3) && (time < self.last_kill_time + 8))
	{
		BotSayTaunt(self.last_kill_ent);
	}
	else if ((time > self.last_die_time + 3) && (time < self.last_die_time + 8))
	{
		BotSayNiceOne(self.last_die_ent);
	}
};

//==========================================================
void (entity p) BPrintFrags =
{
local string st;

	if (p.frags < 1000)
		bprint(" ");
	if (p.frags < 100)
		bprint(" ");
	if (p.frags < 10)
		bprint(" ");
	st = ftos(p.frags);
	bprint(st);
	bprint(" ");

	if (p.team == TEAM_COLOR1)
		bprint("���  ");
	else if (p.team == TEAM_COLOR2)
		bprint("���� ");

	bprint(p.netname);

	if (p.classname == "bot")
	{
		bprint(" [skill ");
		st = ftos(p.bot_skill);
		bprint(st);
		bprint("]");
	}

	bprint("\n");
};
//==========================================================
void (entity p) PrintFrags =
{
local string st;

	if (p.frags < 1000)
		sprint(self, " ");
	if (p.frags < 100)
		sprint(self, " ");
	if (p.frags < 10)
		sprint(self, " ");
	st = ftos(p.frags);
	sprint(self, st);
	sprint(self, " ");

	if (p.team == TEAM_COLOR1)
		sprint(self, "���  ");
	else if (p.team == TEAM_COLOR2)
		sprint(self, "���� ");

	sprint(self, p.netname);
	
	if (p.classname == "bot")
	{
		sprint(self, " [skill ");
		st = ftos(p.bot_skill);
		sprint(self, st);
		sprint(self, "]");
	}

	sprint(self, "\n");
};
//==========================================================
// self is player
//==========================================================
void (float broadcst) PrintFragList =
{
local entity p, best;
local float best_frags, done;

	if (self.classname != "player" && (!broadcst))
		return;

	p = find(world, classname, "player");
	while (p != world)
	{
		p.bsort = FALSE;	
		p = FindNextPlayerOrBot(p);
	}
	
	done = FALSE;
	
	if (broadcst)
	{
		bprint("\n������������������������������������\n");
		bprint("   ���������\n");			// [Rankings]
	}
	else
	{
		sprint(self, "\n������������������������������������\n");
		sprint(self, "   ���������\n");		// [Rankings]
	}

	while (!done)
	{
		best_frags = 0;
		best = world;
		
		p = find(world, classname, "player");
		while (p != world)
		{
			if (!p.bsort)
			if (p.frags >= best_frags)
			{
				best = p;
				best_frags = p.frags;
			}
			p = FindNextPlayerOrBot(p);
		}
		
		if (best == world)
			done = TRUE;
		else
		{		
			if (broadcst)
				BPrintFrags(best);
			else
				PrintFrags(best);

			best.bsort = TRUE;
		}
	}
};
//==========================================================
// self is player
//==========================================================
void (float broadcst) PrintFragList0 =
{
local entity p;
local float num_rbots, num_bbots, num_rhumans, num_bhumans;
local string st;

	if (self.classname != "player" && (!broadcst))
		return;

	p = find(world, classname, "player");
	while (p != world)
	{
		if (p.team == TEAM_COLOR1)
			num_rhumans = num_rhumans + 1;
		else if (p.team == TEAM_COLOR2)
			num_bhumans = num_bhumans + 1;
		if (broadcst)
			BPrintFrags(p);
		else
			PrintFrags(p);
		p = find(p, classname, "player");
	}
	p = find(world, classname, "bot");
	while (p != world)
	{
		if (p.team == TEAM_COLOR1)
			num_rbots = num_rbots + 1;
		else if (p.team == TEAM_COLOR2)
			num_bbots = num_bbots + 1;
		if (broadcst)
			BPrintFrags(p);
		else
			PrintFrags(p);
		p = find(p, classname, "bot");
	}
	/*
	if (broadcst)
	{
		bprint("[");
		st = ftos(num_rhumans);
		bprint(st);
		bprint(" red humans, ");
		st = ftos(num_rbots);
		bprint(st);
		bprint(" red bots]\n");
		bprint("[");
		st = ftos(num_bhumans);
		bprint(st);
		bprint(" blue humans, ");
		st = ftos(num_bbots);
		bprint(st);
		bprint(" blue bots]\n");
	}
	else
	{
		sprint(self, "[");
		st = ftos(num_rhumans);
		sprint(self, st);
		sprint(self, " red humans, ");
		st = ftos(num_rbots);
		sprint(self, st);
		sprint(self, " red bots]\n");
		sprint(self, "[");
		st = ftos(num_bhumans);
		sprint(self, st);
		sprint(self, " blue humans, ");
		st = ftos(num_bbots);
		sprint(self, st);
		sprint(self, " blue bots]\n");
	}
	*/
};

//=============================================================
//=============================================================
void (float fteam) RemoveBestBot =
{
local entity best_bot, bot;
local float best_num;
local string st;

	best_num = 99999999999;
	best_bot = world;
	bot = find(world, classname, "bot");
	while (bot != world)
	{
		if ((bot.frags < best_num) && (bot.team == fteam))
		{
			best_bot = bot;
			best_num = bot.frags;
		}
		
		bot = find(bot, classname, "bot");
	}
	
	if (best_bot != world)
	{
		bprint(best_bot.netname);
		bprint(" [skill ");
		st = ftos(best_bot.bot_skill);
		bprint(st);
		bprint("] has been removed\n");
		
		local entity old_self;
		old_self = self;
		self = best_bot;
		ClientDisconnect();
		self = old_self;
		remove(best_bot);
	}
};

//=============================================================
//=============================================================
void () InitCPU =
{
	local float cur_bot_cpu;
	cur_bot_cpu = 1.0;

	large_pulse_dist_base = 1000;
	awareness_dist_base = 300;
	item_large_pulse_dist_base = 400;
	item_awareness_dist_base = 300;
	large_pulse_dist = large_pulse_dist_base * cur_bot_cpu;
	awareness_dist = awareness_dist_base * cur_bot_cpu;
	item_large_pulse_dist = item_large_pulse_dist_base * cur_bot_cpu;
	item_awareness_dist = item_awareness_dist_base * cur_bot_cpu;
};
//=============================================================
//void () RecalcCPU =
//{
//	sprint(self, "Bot CPU usage set to ");
//	sprintfloat(self, cur_bot_cpu);
//	sprint(self, "\n");
//
//	large_pulse_dist = large_pulse_dist_base * cur_bot_cpu;
//	awareness_dist = awareness_dist_base * cur_bot_cpu;
//	item_large_pulse_dist = item_large_pulse_dist_base * cur_bot_cpu;
//	item_awareness_dist = item_awareness_dist_base * cur_bot_cpu;
//};
////=============================================================
//void () IncreaseCPU =
//{
//	cur_bot_cpu = cur_bot_cpu + 0.1;
//	RecalcCPU();
//};
////=============================================================
//void () DecreaseCPU =
//{
//	cur_bot_cpu = cur_bot_cpu - 0.1;
//	if (cur_bot_cpu < 0.1)
//		cur_bot_cpu = 0.1;	
//	RecalcCPU();
//};
////=============================================================
//void () IncreaseBotPing =
//{
//local string st;
//
//	if (self.classname != "player")
//		return;
//
//	bot_ping = bot_ping + 0.025;
//	sprint(self, "Bot ping set to ");
//	st = ftos(bot_ping * 1000);
//	sprint(self, st);
//	sprint(self, "\n");
//};
////=============================================================
//void () DecreaseBotPing =
//{
//local string st;
//
//	if (self.classname != "player")
//		return;
//		
//	bot_ping = bot_ping - 0.025;
//	if (bot_ping < 0)
//		bot_ping = 0;	
//	sprint(self, "Bot ping set to ");
//	st = ftos(bot_ping * 1000);
//	sprint(self, st);
//	sprint(self, "\n");
//};



//=============================================================
//=============================================================
void (float fteam) StartNewPath =
{
	if (fteam == TEAM_COLOR1)
	{
		dprint("Staring new ��� path\n");
		current_red_waypoint = 0;
	}
	else if (fteam == TEAM_COLOR2)
	{
		dprint("Staring new ���� path\n");
		current_blue_waypoint = 0;
	}
	else
		error("Bogus team\n");
	
	sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
	dprint("Remember to use -condebug option!\n");

	spawning_waypoints = TRUE;
	spawning_general_waypoints = FALSE;
};
//=============================================================
//=============================================================
void () StartNewGeneralPath =
{
	dprint("Staring new general path\n");
	current_waypoint = 0;
	
	sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
	dprint("Remember to use -condebug option!\n");

	spawning_waypoints = TRUE;
	spawning_general_waypoints = TRUE;
};
//=============================================================
//=============================================================
void (float make_visible) SetWaypointsVisible =
{
local entity e;

	e = find(world, classname, "waypoint");
	while (e != world)
	{
		if (make_visible)
			setmodel(e, "progs/s_bubble.spr");
		else
			setmodel(e, "");
		e = find(e, classname, "waypoint");
	}
};
//=============================================================
//=============================================================
void () PrintCloseWaypoint =
{
local entity e;

	/*
	e = find(world, noise2, "");
	while (e != world)
	{
		if (vlen(self.origin - e.origin) < 100)
		{
			if ((e.classname != "player") && (e.classname != ""))
			{
				dprint(e.classname);
				dprint("\n");
			}
		}
		e = find(e, noise2, "");
	}
	*/

	if ((spawning_waypoints) || (bot_debug))
	{
		e = find(world, classname, "waypoint");
		while (e != world)
		{
			if (vlen(self.origin - e.origin) < 30)
			{
				if (e.team == TEAM_COLOR1)
					dprint("���");
				else if (e.team == TEAM_COLOR2)
					dprint("����");
				else if (e.team == -1)
					dprint("general");
				else
					error("Bogus team\n");
				if(e.waypoint_num == -1)
				{
					dprint("Defensive waypoint\n");
				}
				else
				{
					dprint(" waypoint number ");
					dprintfloat(e.waypoint_num);
					dprint("\n");
				}
			}
			e = find(e, classname, "waypoint");
		}

		e = find(world, classname, "inaccessible_from_here");
		while (e != world)
		{
//			if (vlen(self.origin - e.origin) < 30)
//			{
//				dprint("inaccessible marker ");
//				PrintItemName(e.inaccessible_entity);
//				dprint("\n");
//			}
			e = find(e, classname, "inaccessible_from_here");
		}
	}
};

//=============================================================
// self is the player
//=============================================================
void () PrintWaypoints =
{
local entity e;

	dprint("============\n");
	dprint("============\n");
	dprint("waypoints for ");
	dprint(mapname);
	dprint("\n\n");
	dprint("============\n");
	dprint("============\n");

	dprint("	else if (mname == ");
	dprint("\"");
	dprint(mapname);
	dprint("\")\n	{\n		// CTF Bot 1.3 waypoints by ");
	dprint(self.netname);
	dprint("\n\n");
	e = find(world, classname, "waypoint");
	while (e != world)
	{
		dprint("		SpawnWaypointNum('");
		dprintfloat(e.origin_x);
		dprint(" ");
		dprintfloat(e.origin_y);
		dprint(" ");
		dprintfloat(e.origin_z);
		dprint("', ");
		dprintfloat(e.team);
		dprint(", ");
		dprintfloat(e.waypoint_num);
		dprint(", us);\n");
		e = find(e, classname, "waypoint");
	}
	dprint("		return TRUE;\n	}\n\n");
	dprint("============\n");
	dprint("============\n");
	
	sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
	dprint("no longer spawning waypoints\n");
	spawning_waypoints = FALSE;
};
//=============================================================
// self is player
//=============================================================
void () OrderCamping =
{
local entity head, selected, e, oldself;
local float dist;

	if (self.classname != "player")
		return;

	head = findradius(self.origin, 600);
	dist = 999999;
	while(head)
	{
		if (head.classname == "bot")
		if (head.team == self.team)
		if (BotCanSeeItem(head))
		if (vlen(head.origin - self.origin) < dist)
		{
			selected = head;
			dist = vlen(head.origin - self.origin);
		}
		head = head.chain;
	}
	
	if (selected != world)
	{
		if (selected.camping_entity)
		{
			remove(selected.camping_entity);
			selected.camping_entity = world;
		}
			
		e = spawn();
		e.classname = "waypoint";
		e.origin = self.origin + '0 0 16';
		setorigin(e, e.origin);
		e.solid = SOLID_NOT;
		e.movetype = MOVETYPE_NONE;
		setmodel(e, string_null);
		setsize (e, '0 0 0', '0 0 0');
		e.nextthink = time + CAMPING_TIME + 1;
		e.think = SUB_Remove; 
		
		selected.camping_entity = e;
		
		oldself = self;
		self = selected;
		BotSayTeamStart2();
		
		if (time < (self.escort_time + ESCORT_TIME))
		{
			BotSayTeamMiddle("I'll stop escorting ");
			if (self.escort_entity == oldself)
				BotSayTeamMiddle("you");
			else
				BotSayTeamMiddle(self.escort_entity.netname);
			BotSayTeamMiddle(" and camp here, ");
			
			self.escort_time = time - 999;
			self.escort_entity = world;
		}
		else
			BotSayTeamMiddle("I'll camp here, ");
			
		BotSayTeamMiddle(oldself.netname);
		BotSayTeamEnd();
		self = oldself;
		
		/*
		sprint(self, self.netname);
		sprint(self, " orders ");
		sprint(self, selected.netname);
		sprint(self, " to camp\n");
		*/
		
		selected.camping_spot = e.origin;
		selected.camping_time = time;
	}
	else
	{
		sprint(self, "No bot nearby\n");
	}
};
//=============================================================
// self is player
//=============================================================
void () OrderEscort =
{
local entity head, selected, e, oldself;
local float dist;

	if (self.classname != "player")
		return;

	head = findradius(self.origin, 600);
	dist = 999999;
	while(head)
	{
		if (head.classname == "bot")
		if (head.team == self.team)
		if (BotCanSeeItem(head))
		if (vlen(head.origin - self.origin) < dist)
		{
			selected = head;
			dist = vlen(head.origin - self.origin);
		}
		head = head.chain;
	}
	
	if (selected != world)
	{
		selected.escort_entity = self;
		selected.escort_time = time;
		
		oldself = self;
		self = selected;
		BotSayTeamStart2();

		if (time < (self.camping_time + CAMPING_TIME))
		{
			BotSayTeamMiddle("I'll stop camping and escort you, ");
			
			self.camping_time = time - 999;
			if (self.camping_entity != world)
			{	
				remove(self.camping_entity);
				self.camping_entity = world;
			}
		}
		else
			BotSayTeamMiddle("I'll escort you, ");
			
		BotSayTeamMiddle(oldself.netname);
		BotSayTeamEnd();
		self = oldself;
	}
	else
	{
		sprint(self, "No bot nearby\n");
	}
};
//=============================================================
// self is player
//=============================================================
void () OrderDropStuff =
{
local entity head, selected, e, oldself, item;
local float dist, oldweapon;

	if (self.classname != "player")
		return;

	head = findradius(self.origin, 600);
	dist = 999999;
	while(head)
	{
		if (head.classname == "bot")
		if (head.team == self.team)
		if (BotCanSeeItem(head))
		{
			if ((!(teamplay & TEAM_NO_RUNE_DROP)) 
			&& (head.player_flag & ITEM_RUNE_MASK) 
			&& (!(self.player_flag & ITEM_RUNE_MASK)))
			{
				oldself = self;
				self = head;
				BotSayTeamStart2();
				BotSayTeamMiddle("I dropped ");
				if (head.player_flag & ITEM_RUNE1_FLAG)
					BotSayTeamMiddle("Resistance");
				else if (head.player_flag & ITEM_RUNE2_FLAG)
					BotSayTeamMiddle("Strength");
				else if (head.player_flag & ITEM_RUNE3_FLAG)
					BotSayTeamMiddle("Haste");
				else if (head.player_flag & ITEM_RUNE4_FLAG)
					BotSayTeamMiddle("Regeneration");
				BotSayTeamEnd();
				item = PlayerDropRune();
				if (item != world)
				{
					item.bot_ignore_until_time = time + 10;
					item.bot_ignore_team = self.team;
				}
				self = oldself;
				return;
			}
		}
		head = head.chain;
	}
			
	head = findradius(self.origin, 600);
	dist = 999999;
	while(head)
	{
		if (head.classname == "bot")
		if (head.team == self.team)
		if (BotCanSeeItem(head))
		{
			if ((teamplay & TEAM_DROP_ITEMS)
				&& (head.items & IT_LIGHTNING)
				&& (head.ammo_cells > 0)
				&& (!(self.items & IT_LIGHTNING)))
			{
				oldself = self;
				self = head;
				
				BotSayTeamStart2();
				BotSayTeamMiddle("I dropped lightning gun");
				BotSayTeamEnd();
				
				oldweapon = self.weapon;
				self.weapon = IT_LIGHTNING;
//TONY
//MULTIWEAPON
	if(temp1 & TEMP1_MULTI)
		set_player_weapon ();

				item = TossWeaponBackpack(IT_LIGHTNING, oldself);
				if (item != world)
				{
					item.bot_ignore_until_time = time + 10;
					item.bot_ignore_team = self.team;
				}
				self.weapon = oldweapon;
//TONY
//MULTIWEAPON
	if(temp1 & TEMP1_MULTI)
		set_player_weapon ();

				
				self = oldself;
				
				return;
			}
		}
		head = head.chain;
	}
	head = findradius(self.origin, 600);
	dist = 999999;
	while(head)
	{
		if (head.classname == "bot")
		if (head.team == self.team)
		if (BotCanSeeItem(head))
		{
			if ((teamplay & TEAM_DROP_ITEMS)
				&& (head.items & IT_ROCKET_LAUNCHER)
				&& (head.ammo_rockets > 0)
				&& (!(self.items & IT_ROCKET_LAUNCHER)))
			{
				oldself = self;
				self = head;
				
				BotSayTeamStart2();
				BotSayTeamMiddle("I dropped rocket launcher");
				BotSayTeamEnd();
				
				oldweapon = self.weapon;
				self.weapon = IT_ROCKET_LAUNCHER;
//TONY
//MULTIWEAPON
	if(temp1 & TEMP1_MULTI)
		set_player_weapon ();

				item = TossWeaponBackpack(IT_ROCKET_LAUNCHER, oldself);
				if (item != world)
				{
					item.bot_ignore_until_time = time + 10;
					item.bot_ignore_team = self.team;
				}
				self.weapon = oldweapon;
//TONY
//MULTIWEAPON
	if(temp1 & TEMP1_MULTI)
		set_player_weapon ();

				
				self = oldself;
				
				return;
			}
		}
		head = head.chain;
	}
	head = findradius(self.origin, 600);
	dist = 999999;
	while(head)
	{
		if (head.classname == "bot")
		if (head.team == self.team)
		if (BotCanSeeItem(head))
		{
			if ((teamplay & TEAM_DROP_ITEMS)
				&& (head.items & IT_GRENADE_LAUNCHER)
				&& (head.ammo_rockets > 0)
				&& (!(self.items & IT_GRENADE_LAUNCHER)))
			{
				oldself = self;
				self = head;
				
				BotSayTeamStart2();
				BotSayTeamMiddle("I dropped grenade launcher");
				BotSayTeamEnd();
				
				oldweapon = self.weapon;
				self.weapon = IT_GRENADE_LAUNCHER;
//TONY
//MULTIWEAPON
	if(temp1 & TEMP1_MULTI)
		set_player_weapon ();

				item = TossWeaponBackpack(IT_GRENADE_LAUNCHER, oldself);
				if (item != world)
				{
					item.bot_ignore_until_time = time + 10;
					item.bot_ignore_team = self.team;
				}
				self.weapon = oldweapon;
//TONY
//MULTIWEAPON
	if(temp1 & TEMP1_MULTI)
		set_player_weapon ();

				
				self = oldself;
				
				return;
			}
		}
		head = head.chain;
	}
	head = findradius(self.origin, 600);
	dist = 999999;
	while(head)
	{
		if (head.classname == "bot")
		if (head.team == self.team)
		if (BotCanSeeItem(head))
		{
			if ((teamplay & TEAM_DROP_ITEMS)
				&& (head.items & IT_SUPER_NAILGUN)
				&& (head.ammo_nails > 0)
				&& (!(self.items & IT_SUPER_NAILGUN)))
			{
				oldself = self;
				self = head;
				
				BotSayTeamStart2();
				BotSayTeamMiddle("I dropped super nailgun");
				BotSayTeamEnd();
				
				oldweapon = self.weapon;
				self.weapon = IT_SUPER_NAILGUN;
//TONY
//MULTIWEAPON
	if(temp1 & TEMP1_MULTI)
		set_player_weapon ();

				item = TossWeaponBackpack(IT_SUPER_NAILGUN, oldself);
				if (item != world)
				{
					item.bot_ignore_until_time = time + 10;
					item.bot_ignore_team = self.team;
				}
				self.weapon = oldweapon;
//TONY
//MULTIWEAPON
	if(temp1 & TEMP1_MULTI)
		set_player_weapon ();

				
				self = oldself;
				
				return;
			}
		}
		head = head.chain;
	}
	
	sprint(self, "Nothing to drop\n");
};



//=============================================================
//=============================================================
void () PrintWaypointList =
{
local entity p;
local float nm, nm2;

	nm = 0;

	dprint("----\n");
	dprint("red\n");
	p = wp_first_red;
	while (p != world)
	{
		nm = nm + 1;
		dprint("waypoint ");
		dprintfloat(p.team);
		dprint(" ");
		dprintfloat(p.waypoint_num);
		dprint("\n");
		if (p.wp_chain == world)
		{
			if (p == wp_last_red)
				dprint("list terminated correctly\n");
			else
				dprint("list terminated INCORRECTLY\n");
		}
		p = p.wp_chain;
	}
	dprint("----\n");
	dprint("blue\n");
	p = wp_first_blue;
	while (p != world)
	{
		nm = nm + 1;
		dprint("waypoint ");
		dprintfloat(p.team);
		dprint(" ");
		dprintfloat(p.waypoint_num);
		dprint("\n");
		if (p.wp_chain == world)
		{
			if (p == wp_last_blue)
				dprint("list terminated correctly\n");
			else
				dprint("list terminated INCORRECTLY\n");
		}
		p = p.wp_chain;
	}
	dprint("----\n");
	dprint("general\n");
	p = wp_first_general;
	while (p != world)
	{
		nm = nm + 1;
		dprint("waypoint ");
		dprintfloat(p.team);
		dprint(" ");
		dprintfloat(p.waypoint_num);
		dprint("\n");
		if (p.wp_chain == world)
		{
			if (p == wp_last_general)
				dprint("list terminated correctly\n");
			else
				dprint("list terminated INCORRECTLY\n");
		}
		p = p.wp_chain;
	}
	dprint("----\n");
	dprintfloat(nm);
	dprint(" linked waypoints\n");
	
	nm2 = 0;
	p = find(world, classname, "waypoint");
	while (p != world)
	{	
		nm2 = nm2 + 1;
		p = find(p, classname, "waypoint");
	}
	dprintfloat(nm2);
	dprint(" waypoints\n");
	if (nm != nm2)
		dprint("ERROR\n");
};
//=============================================================
//=============================================================
void (entity wp) InsertWaypointLink =
{
	if (wp.team == TEAM_COLOR1)
	{
		if (wp_first_red == world)
		{
			wp_first_red = wp;
			wp_last_red = wp;
		}
		else
		{
			wp_last_red.wp_chain = wp;
			wp_last_red = wp;
			wp_last_red.wp_chain = world;
		}
	}
	else if (wp.team == TEAM_COLOR2)
	{
		if (wp_first_blue == world)
		{
			wp_first_blue = wp;
			wp_last_blue = wp;
		}
		else
		{
			wp_last_blue.wp_chain = wp;
			wp_last_blue = wp;
			wp_last_blue.wp_chain = world;
		}
	}
	else if (wp.team == -1)
	{
		if (wp_first_general == world)
		{
			wp_first_general = wp;
			wp_last_general = wp;
		}
		else
		{
			wp_last_general.wp_chain = wp;
			wp_last_general = wp;
			wp_last_general.wp_chain = world;
		}
	}
};


//=============================================================
// QUAKED
//=============================================================
void () waypoint =
{
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, string_null);
	map_has_waypoints = TRUE;
	InsertWaypointLink(self);
};
//=============================================================
//=============================================================
void (vector org) SpawnDeathmatchStart =
{
local entity e;

	e = spawn();
	e.classname = "info_player_deathmatch";
	e.origin = org;
	setorigin(e, org);
	e.solid = SOLID_NOT;
	e.movetype = MOVETYPE_NONE;
	setmodel(e, string_null);
};
//=============================================================
//=============================================================
entity (vector org, float fteam, float wpnum, float use_sprite) SpawnWaypointNum =
{
local entity e;

	map_has_waypoints = TRUE;

	e = spawn();
	e.classname = "waypoint";
	
	
	//e.dynamically_created = TRUE;	// so print bsp ents will print waypoints also

	if (spawning_waypoints)
	{	
		dprint("new ");

		if (fteam == TEAM_COLOR1)
			dprint("���");
		else if (fteam == TEAM_COLOR2)
			dprint("����");
		else if (fteam == -1)
			dprint("general");
		else
			error("Bogus team\n");

		dprint(" waypoint number ");
		dprintfloat(wpnum);
		dprint("\n");
	}

	e.waypoint_num = wpnum;
		
	e.origin = org;
	e.team = fteam;
	setorigin(e, org);
	//e.touch = SUB_Null;
	e.solid = SOLID_NOT;
	e.movetype = MOVETYPE_NONE;
	if (use_sprite)
		setmodel (e, "progs/s_bubble.spr");
	else
		setmodel(e, string_null);

	InsertWaypointLink(e);

	//setsize (e, '0 0 0', '0 0 0');
	//e.nextthink = time + 1;
	//e.think = SUB_Null; 
	
	return e;
};

//
//TONY
//FIXME
//shootable waypoints???
//1. do they work
//2. if so, do any maps currently have them in their waypoint
//	set
//

//=============================================================
//=============================================================
entity (vector org, float fteam, float wpnum, float use_sprite) SpawnWaypointNumShoot =
{
	local entity e;
	e = SpawnWaypointNum(org, fteam, wpnum, use_sprite);
	e.shoot_triggers = TRUE;
	return e;
};

//=============================================================
// self is player
//=============================================================
void () RemoveClosestWaypoint =
{
local entity head, selected, e, oldself;
local float dist;

	if (self.classname != "player")
		return;

	selected = world;
	head = find(world, classname, "waypoint");
	dist = 300;
	while(head != world)
	{
		if (vlen(head.origin - self.origin) < dist)
		{
			selected = head;
			dist = vlen(head.origin - self.origin);
		}
		head = find(head, classname, "waypoint");
	}
	
	if (selected != world)
	{
		dprint("Removed ");
		if (selected.team == TEAM_COLOR1)
			dprint("���");
		else if (selected.team == TEAM_COLOR2)
			dprint("����");
		else if (selected.team == -1)
			dprint("general");
		dprint(" waypoint number ");
		dprintfloat(selected.waypoint_num);
		dprint("\n");
		
		// fix up list here

		remove(selected);
	}
	else
	{
		dprint("No waypoint nearby\n");
	}
};

//TONY
//DEFENSIVE waypoints

void (vector org, float fteam) SpawnDefensiveWaypoint =
{
	sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
	
	if (fteam == TEAM_COLOR1)
	{
		SpawnWaypointNum(org + '0 0 16', fteam, -1, TRUE);
	}
	else if (fteam == TEAM_COLOR2)
	{
		SpawnWaypointNum(org + '0 0 16', fteam, -1, TRUE);
	}
	else
		error("Bogus team\n");
};


//=============================================================
//=============================================================
void (vector org, float fteam) SpawnNextWaypoint =
{
	if (!spawning_waypoints)
	{
		dprint("currently not spawning waypoints\n");
		dprint("use impulse 185 to start a new path\n");
		return;
	}

	sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
	
	if (fteam == TEAM_COLOR1)
	{
		SpawnWaypointNum(org + '0 0 16', fteam, current_red_waypoint, TRUE);
		current_red_waypoint = current_red_waypoint + 1;
	}
	else if (fteam == TEAM_COLOR2)
	{
		SpawnWaypointNum(org + '0 0 16', fteam, current_blue_waypoint, TRUE);
		current_blue_waypoint = current_blue_waypoint + 1;
	}
	else
		error("Bogus team\n");
};
//=============================================================
//=============================================================
void (vector org) SpawnNextGeneralWaypoint =
{
	if (!spawning_waypoints)
	{
		dprint("currently not spawning waypoints\n");
		dprint("use impulse 185 to start a new path\n");
		return;
	}
	
	sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
	
	SpawnWaypointNum(org + '0 0 16', -1, current_waypoint, TRUE);
	current_waypoint = current_waypoint + 1;
};

//////////////////
//moved to dynamic way/waypoint.qc
//actually in way/_tail.qc which is copied into way/waypoint.qc
//Tony
//
/////////////////


//=============================================================
//=============================================================
//void(string mname)SpawnWaypointsForMap = 
//{	
//local float found;
//
//	if (bot_debug >= 1)
//	{
//		dprint("Spawning waypoints for map ");
//		dprint(mname);
//		dprint("\n");
//	}
//	
//	// have to split into two routines, because one huge routine
//	// causes Quake to barf ("local stack overflow" error)
//	
//	found = SpawnWaypointsForMap1(mname);
//	if (!found)
//		found = SpawnWaypointsForMap2(mname);
//	if (!found)
//		found = SpawnWaypointsForMap3(mname);
//	if (!found)
//		found = SpawnWaypointsForMap4(mname);
//	if (!found)
//		found = SpawnWaypointsForMap5(mname);
//	if (!found)
//		found = SpawnWaypointsForMap6(mname);
//	if (!found)
//		found = SpawnWaypointsForMap7(mname);
//};
