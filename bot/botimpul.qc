//botimpul.qc
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


//=============================================================
//=============================================================
float () PrintImpulseNotAllowed =
{
	sprint(self, "impulse ");
	sprintfloat(self, self.impulse);
	sprint(self, " is for sysop only\n");
	return FALSE;
};

//=============================================================
//=============================================================
float () CheckWaypointImpulseCommands =
{
	if ((self.impulse >= 1) && (self.impulse <= 20))
	{
		if (!spawning_waypoints)
			return FALSE;
			
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		stuffcmd (self, "bf\n");
			
		if (spawning_general_waypoints)
			SpawnWaypointNum(self.origin + '0 0 16', -1, self.impulse, TRUE);
		else
			SpawnWaypointNum(self.origin + '0 0 16', self.team, self.impulse, TRUE);

		if (spawning_general_waypoints)
			current_waypoint = self.impulse + 1;
		else if (self.team == TEAM_COLOR1)
			current_red_waypoint = self.impulse + 1;
		else if (self.team == TEAM_COLOR2)
			current_blue_waypoint = self.impulse + 1;

		return TRUE;
	}

	
	return FALSE;
};


//=============================================================
// CheckBotImpulseCommands - Called by weapons.qc before processing impulses
//=============================================================
float () CheckBotImpulseCommands =
{
	local float bskill;
		
	if (CheckWaypointImpulseCommands())
	{
		return TRUE;
	}

	if (self.impulse == 13)
	{
		self.sex = self.sex + 1;
		if (self.sex == 2)
		{
			if (!(temp1 & TEMP1_SUPPORT_PLAYER2))
				self.sex = 3;
			else
				sprint(self,"You are using the female model\n");
		}
		if (self.sex == 3)
		{
			if (!(temp1 & TEMP1_SUPPORT_PLAYER3))
				self.sex = 4;
			else
				sprint(self,"You are using the player3 model\n");
		}
		if (self.sex == 4)
		{
			if (!(temp1 & TEMP1_SUPPORT_PLAYER4))
				self.sex = 1;
			else
				sprint(self,"You are using the player4 model\n");
		}
		if ((self.sex < 2) || (self.sex > 4))
		{
			self.sex = 1;
			sprint(self,"You are using the regular(male) model\n");
		}
/*
local string shit;
shit = ftos(self.sex);
sprint(self, shit);
sprint(self,"\n");
*/

//TONY
//multi player model support
	if(temp1 & TEMP1_MULTI)
		set_player_weapon();
	else
		set_player_main_index();

	}

//TONY
//next level
	else if (self.impulse == 16)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
		pregameover = 1;
		level_over_time = time;		// CTFBOT
		TeamEndScore();
		NextLevel ();
		return TRUE;
	}

// *Capture The Flag - Status report by Wonko
// Impulse 23 prints the current status of your flag and the
// enemy flag (summarizes the endless messages)
	else if (self.impulse == 23)
		TeamFlagStatusReport();
//TONY
	else if (self.impulse == 24)
		SVAimPrintSettings();
// *TEAMPLAY*
// Impulse 25 prints info about the current teamplay settings.
	else if (self.impulse == 25)
		TeamPrintSettings ();
//TONY
	else if (self.impulse == 26)
		DeathPrintSettings ();
	else if (self.impulse == 27)
		Temp1PrintSettings ();
//TONY
	if (self.impulse == 40)
	{
		if (teamplay & TEAM_NO_RUNE_DROP)
		{
			sprint(self, "rune dropping not allowed\n");
			return TRUE;
		}

		PlayerDropRune();	
		return TRUE;
	}
	else if (self.impulse == 41)
	{
		RuneStatus();
		return TRUE;
	}
	else if (self.impulse == 70)
	{
		if (self.statstate < 0)
		{
			self.statstate = 0;
			sprint(self, "Status bar on (impulse 71 to 81 to set size)\n");
		}
		else
		{
			self.statstate = -1;
			sprint(self, "Status bar off.\n");
		}
	}
	else if (self.impulse >= 71 && self.impulse <= 79)
	{
		self.statstate = self.impulse - 71;
		sprint(self, "status bar size set to ");
		
		if (self.statstate > 7) // 768 
			sprint(self, "768\n");
		else if (self.statstate == 7) // 600 
			sprint(self, "600\n");
		else if (self.statstate == 6) // 480 
			sprint(self, "480\n");
		else if (self.statstate == 5) // 400
			sprint(self, "400\n");
		else if (self.statstate == 4) // 384 
			sprint(self, "384\n");
		else if (self.statstate == 3) // 350 
			sprint(self, "350\n");
		else if (self.statstate == 2) // 300 
			sprint(self, "300\n");
		else if (self.statstate == 1) // 240 
			sprint(self, "240\n");
		else
			sprint(self, "200\n");
	}
//TONY
//EASY (MAYBE TOO EASY;) WAYS TO INCREASE/DECREASE STATUS BAR
	else if ((self.impulse == 68) || (self.impulse == 67))
	{
		if((self.impulse == 68) && (self.statstate < 9))
			self.statstate = self.statstate + 1;
		if((self.impulse == 67) && (self.statstate > 0))
			self.statstate = self.statstate - 1;
		sprint(self, "status bar size set to ");
		
		if (self.statstate > 7) // 768 
			sprint(self, "768\n");
		else if (self.statstate == 7) // 600 
			sprint(self, "600\n");
		else if (self.statstate == 6) // 480 
			sprint(self, "480\n");
		else if (self.statstate == 5) // 400
			sprint(self, "400\n");
		else if (self.statstate == 4) // 384 
			sprint(self, "384\n");
		else if (self.statstate == 3) // 350 
			sprint(self, "350\n");
		else if (self.statstate == 2) // 300 
			sprint(self, "300\n");
		else if (self.statstate == 1) // 240 
			sprint(self, "240\n");
		else
			sprint(self, "200\n");
	}
	else if (self.impulse == 99)
		PrintLocation();
	else if (self.impulse == 80)
	{
		ReportIn(self.team);
		return TRUE;
	}
	else if (self.impulse == 81)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
		MoreBotsAttack(self.team);
		return TRUE;
	}
	else if (self.impulse == 82)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
		MoreBotsDefend(self.team);
		return TRUE;
	}
	else if (self.impulse == 83)
	{
		if (self.observer_flags & PLAYER_USING_CAMERA)
			return FALSE;

		OrderEscort();
		return TRUE;
	}
	else if (self.impulse == 84)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
		OrderCamping();
		return TRUE;
	}
	else if (self.impulse == 85)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
		if ((teamplay & TEAM_NO_RUNE_DROP) && (!(teamplay & TEAM_DROP_ITEMS)))
		{
			sprint(self, "item dropping not allowed\n");
			return FALSE;
		}

		OrderDropStuff();
		return TRUE;
	}
	else if (self.impulse == 86)
	{
		PrintTeamStatus();
		return TRUE;
	}
	else if (self.impulse == 87)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
		MoreBotsRoam(self.team);
		return TRUE;
	}
	else if (self.impulse == 88)
	{
		sprint(self, self.netname);
		sprint(self, " orders bots to come here\n");
		SpawnTempWaypoint(self.origin + '0 0 16', 20, self.team);
		return TRUE;
	}
	else if (self.impulse == 89)
	{
		if (teamplay & TEAM_NO_FLAG_TOSS)
		{
			sprint(self, "flag tossing not allowed\n");
			return;
		}

		if (self.player_flag & ITEM_ENEMY_FLAG)
		{
			TossFlag(self, world);
		}
		else
		{
			OrderTossFlag();
		}
		return TRUE;
	}
	else if (self.impulse == 90)
	{
		TossWeaponBackpack(self.weapon, world);		// target doesn't matter for players
		return TRUE;
	}
	else if (self.impulse == 94)
	{	
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		self.disable_triggers = !self.disable_triggers;

		if (self.disable_triggers)
			sprint2("triggers OFF\n");
		else
			sprint2("triggers ON\n");
		return TRUE;
	}
	else if (self.impulse == 95)
	{	
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();

		if (self.movetype == MOVETYPE_NOCLIP)
		{
			self.movetype = MOVETYPE_WALK;
			sprint2("noclip OFF\n");
		}
		else
		{
			self.movetype = MOVETYPE_NOCLIP;
			sprint2("noclip ON\n");
		}
		return TRUE;
	}
	else if (self.impulse == 96)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();

		if (self.flags & FL_GODMODE)
		{
			self.flags = self.flags - (self.flags & FL_GODMODE);
			dprint("god mode OFF\n");
		}
		else
		{
			self.flags = self.flags | FL_GODMODE;
			dprint("god mode ON\n");
		}
	}
	else if (self.impulse == 97)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		self.takedamage = !self.takedamage;
		if (self.takedamage)
			sprint(self, "no damage mode OFF\n");
		else
			sprint(self, "no damage mode ON\n");			
		
		return TRUE;
	}
	else if (self.impulse == 98)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
//TONY
//YCAM
		if((self.aflag) && (temp1 & TEMP1_YCAM))
			YCam();		 //turn off ycam before observer
		bprint(self.netname);
		bprint(" became an observer!\n");
		BecomeObserver(self);
		return TRUE;
	}
	else if (self.impulse == 100)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
//		if (teamplay & TEAM_CAPTURE_AUTO_EVEN_TEAMS)
		if (temp1 & TEMP1_AUTO_EVEN_TEAMS)
		{
			sprint2("can't add bots, auto-even-teams on\n");
			return TRUE;
		}
			
		bskill = cvar("skill");
			
		if (self.team == TEAM_COLOR1)
		{
			CreateRedBot(bskill);
			return TRUE;
		}
		else if (self.team == TEAM_COLOR2)
		{
			CreateBlueBot(bskill);
			return TRUE;
		}
		else
			return FALSE;
	}
	else if (self.impulse == 101)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();

//		if (teamplay & TEAM_CAPTURE_AUTO_EVEN_TEAMS)
		if (temp1 & TEMP1_AUTO_EVEN_TEAMS)
		{
			sprint2("can't add bots, auto-even-teams on\n");
			return TRUE;
		}

		bskill = cvar("skill");
			
		if (self.team == TEAM_COLOR2)
		{
			CreateRedBot(bskill);
			return TRUE;
		}
		else if (self.team == TEAM_COLOR1)
		{
			CreateBlueBot(bskill);
			return TRUE;
		}
		else
			return FALSE;
	}
	else if (self.impulse == 103)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		bot_debug = bot_debug + 1;
		if (bot_debug > 4)
			bot_debug = 0;
		if (bot_debug)
		{
			sprint(self, "bot debug on [");
			sprintfloat(self, bot_debug);
			sprint(self, "]\n");
			SetWaypointsVisible(TRUE);
			SetDebugMarkersVisible(TRUE);
		}
		else if (bot_debug == 0)
		{
			sprint(self, "bot debug off [0]\n");
			SetWaypointsVisible(FALSE);
			SetDebugMarkersVisible(FALSE);
		}
		return TRUE;
	}
	else if (self.impulse == 104)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		bot_debug = 0;
		sprint2("bot debug off [0]\n");
		SetWaypointsVisible(FALSE);
		SetDebugMarkersVisible(FALSE);
		return TRUE;
	}
	else if (self.impulse == 105)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();

//		if (teamplay & TEAM_CAPTURE_AUTO_EVEN_TEAMS)
		if (temp1 & TEMP1_AUTO_EVEN_TEAMS)
		{
			sprint2("can't add bots, auto-even-teams on\n");
			return TRUE;
		}
			
		bskill = cvar("skill");
			
		CreateRedBot(bskill);
		return TRUE;
	}
	else if (self.impulse == 106)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();

//		if (teamplay & TEAM_CAPTURE_AUTO_EVEN_TEAMS)
		if (temp1 & TEMP1_AUTO_EVEN_TEAMS)
		{
			sprint2("can't add bots, auto-even-teams on\n");
			return TRUE;
		}
			
		bskill = cvar("skill");
			
		CreateBlueBot(bskill);
		return TRUE;
	}
	else if (self.impulse == 107)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();

//		if (teamplay & TEAM_CAPTURE_AUTO_EVEN_TEAMS)
		if (temp1 & TEMP1_AUTO_EVEN_TEAMS)
		{
			sprint2("can't remove bots, auto-even-teams on\n");
			return TRUE;
		}
			
		RemoveBestBot(TEAM_COLOR1);
		return TRUE;
	}
	else if (self.impulse == 108)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();

//		if (teamplay & TEAM_CAPTURE_AUTO_EVEN_TEAMS)
		if (temp1 & TEMP1_AUTO_EVEN_TEAMS)
		{
			sprint2("can't remove bots, auto-even-teams on\n");
			return TRUE;
		}
			
		RemoveBestBot(TEAM_COLOR2);
		return TRUE;
	}
	else if(self.impulse == 110)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
		AllBotsAttack(self.team);
	}

	else if(self.impulse == 111)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
		AllBotsDefend(self.team);
	}
	else if(self.impulse == 112)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
		RemoveAllBots();
	}
	else if (self.impulse == 115)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return FALSE;
			
		SpawnFlag(TEAM_COLOR1);
		return TRUE;
	}
	else if (self.impulse == 116)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		SpawnFlag(TEAM_COLOR2);
		return TRUE;
	}
	else if (self.impulse == 117)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		SpawnBaseStockpile();
		return TRUE;
	}
	else if (self.impulse == 118)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		PrintEntityListBSP();
		return TRUE;
	}
	else if (self.impulse == 120)
	{
		DetailedPlayerScores(self, self);
		return TRUE;
	}
	else if (self.impulse == 121)
	{
		DetailedScores(self);
		return TRUE;
	}
	else if (self.impulse == 122)
	{
		PrintFragList(FALSE);
		return TRUE;
	}
	else if (self.impulse == 123)
	{	
		PrintCTFScoreOne(self);
	}
	else if (self.impulse == 130)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
		if (self.observer_flags & PLAYER_USING_CAMERA)
			return FALSE;
			
		if (self.observer_flags & PLAYER_NO_TARGET)
		{
			self.observer_flags = self.observer_flags - PLAYER_NO_TARGET;
			sprint(self, "no target mode OFF\n");
		}
		else
		{
			self.observer_flags = self.observer_flags | PLAYER_NO_TARGET;
			sprint(self, "no target mode ON\n");
		}
		return TRUE;
	}
	else if (self.impulse == 131)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
		if (self.observer_flags & PLAYER_USING_CAMERA)
			return FALSE;
			
		if (self.observer_flags & PLAYER_ALWAYS_ESCORT)
		{
			self.observer_flags = self.observer_flags - PLAYER_ALWAYS_ESCORT;
			sprint(self, "always escort mode OFF\n");
		}
		else
		{
			self.observer_flags = self.observer_flags | PLAYER_ALWAYS_ESCORT;
			sprint(self, "always escort mode ON\n");
		}
		return TRUE;
	}

//TONY
//BEST_WEP
	else if (self.impulse >=150 && self.impulse <= 159)
	{
		self.best_wep = self.impulse - 151; //-1 is off
		if (self.best_wep == -1)	//off
			{sprint(self,"Best Weapon is Off\n");self.ITbest_wep = 0;}
		else if(self.best_wep == 0)
			{sprint(self,"Best Weapon is Grappling Hook\n");self.ITbest_wep = IT_HOOK;}
		else if(self.best_wep == 1)
			{sprint(self,"Best Weapon is Axe\n");self.ITbest_wep = IT_AXE;}
		else if(self.best_wep == 2)
			{sprint(self,"Best Weapon is Shotgun\n");self.ITbest_wep = IT_SHOTGUN;}
		else if(self.best_wep == 3)
			{sprint(self,"Best Weapon is Super Shotgun\n");self.ITbest_wep = IT_SUPER_SHOTGUN;}
		else if(self.best_wep == 4)
			{sprint(self,"Best Weapon is Nailgun\n");self.ITbest_wep = IT_NAILGUN;}
		else if(self.best_wep == 5)
			{sprint(self,"Best Weapon is Super Nailgun\n");self.ITbest_wep = IT_SUPER_NAILGUN;}
		else if(self.best_wep == 6)
			{sprint(self,"Best Weapon is Grenade Launcher\n");self.ITbest_wep = IT_GRENADE_LAUNCHER;}
		else if(self.best_wep == 7)
			{sprint(self,"Best Weapon is Rocket Launcher\n");self.ITbest_wep = IT_ROCKET_LAUNCHER;}
		else if(self.best_wep == 8)
			{sprint(self,"Best Weapon is Lightning Gun\n");self.ITbest_wep = IT_LIGHTNING;}
		else
		{
			self.best_wep = 8;
			sprint(self,"Best Weapon is Lightning Gun\n");
			self.ITbest_wep = IT_LIGHTNING;
		}
	}
	else if (self.impulse == 166)
	{
		local string tp;
		local float ftp;
		ftp = cvar("teamplay");
		tp = ftos(ftp);
		bprint(tp);
		bprint("\n");
		if(ftp & TEAM_NORSE_MOVEMENT)
		{
			dprint("using old movetogoal\n");
			ftp = ftp - TEAM_NORSE_MOVEMENT;
		}
		else
		{
			dprint("using norse_movetogoal\n");
			ftp = ftp | TEAM_NORSE_MOVEMENT;
		}
		tp = ftos(ftp);
		cvar_set("teamplay",tp);
		ftp = cvar("teamplay");
		tp = ftos(ftp);
		bprint(tp);
		bprint("\n");
		return TRUE;
		
//		use_norse_movetogoal = !use_norse_movetogoal;
//		if (use_norse_movetogoal)
//		{
//			dprint("using norse movetogoal\n");
//			use_extra_move_frame = FALSE;
//		}
//		else
//		{
//			dprint("using old movetogoal\n");
//			use_extra_move_frame = TRUE;
//		}
//		return TRUE;
	}
	else if (self.impulse == 171)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		ToggleWaypoints();
		return TRUE;
	}
	else if (self.impulse == 172)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		bot_chatter_off = !bot_chatter_off;
		if (bot_chatter_off)
			sprint(self, "bot chatter OFF\n");
		else
			sprint(self, "bot chatter ON\n");
		return TRUE;
	}
	else if (self.impulse == 173)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		SwitchBotNames();
		return TRUE;
	}
	else if (self.impulse == 174)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		bot_chatter_rated_g = !bot_chatter_rated_g;
		if (bot_chatter_rated_g)
			sprint(self, "bot chatter rated G\n");
		else
			sprint(self, "bot chatter rated PG-13\n");
		return TRUE;
	}
//TONY
//NEW Impulse
	else if (self.impulse == 184)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		stuffcmd (self, "bf\n");

		SpawnDefensiveWaypoint(self.origin, self.team);

		return TRUE;
	}
	else if (self.impulse == 185)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		stuffcmd (self, "bf\n");

		if (spawning_general_waypoints)
			SpawnNextGeneralWaypoint(self.origin);
		else
			SpawnNextWaypoint(self.origin, self.team);
		return TRUE;
	}
	else if (self.impulse == 186)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		StartNewPath(self.team);
		return TRUE;
	}
	else if (self.impulse == 187)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return FALSE;
		PrintWaypoints();
		spawning_waypoints = FALSE;
		spawning_general_waypoints = FALSE;
		return TRUE;
	}
	else if (self.impulse == 188)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		StartNewGeneralPath();
		return TRUE;
	}
	else if (self.impulse == 189)
	{
		if ((!(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)) && (self.accesslvl < 3))
			return PrintImpulseNotAllowed();
			
		stuffcmd (self, "bf\n");

		RemoveClosestWaypoint();
		return TRUE;
	}
	
	return FALSE;
};
                              


//=============================================================
entity (float bskill) CreateRedBot =
{
local string name;
local entity bot;

	next_bot_num = next_bot_num + 1;
	next_bot_red = next_bot_red + 1;
	if (next_bot_red == 1)
     		name = "RedBot1";
	else if (next_bot_red == 2)
     		name = "RedBot2";
	else if (next_bot_red == 3)
     		name = "RedBot3";
	else if (next_bot_red == 4)
     		name = "RedBot4";
	else if (next_bot_red == 5)
     		name = "RedBot5";
	else if (next_bot_red == 6)
     		name = "RedBot6";
	else if (next_bot_red == 7)
     		name = "RedBot7";
	else if (next_bot_red == 8)
     		name = "RedBot8";
	else if (next_bot_red == 9)
     		name = "RedBot9";
	else if (next_bot_red == 10)
     		name = "RedBot10";
	else if (next_bot_red == 11)
     		name = "RedBot11";
	else if (next_bot_red == 12)
     		name = "RedBot12";
	else if (next_bot_red == 13)
     		name = "RedBot13";
	else if (next_bot_red == 14)
     		name = "RedBot14";
	else if (next_bot_red == 15)
     		name = "RedBot15";
	else if (next_bot_red == 16)
     		name = "RedBot16";
	else if (next_bot_red == 17)
     		name = "RedBot17";
	else if (next_bot_red == 18)
     		name = "RedBot18";
	else if (next_bot_red == 19)
     		name = "RedBot19";
	else
     		name = "RedBotUnnamed";
	bot = BotCreate(name, TEAM_COLOR1, bskill);
	return bot;
};

//=============================================================
entity (float bskill) CreateBlueBot =
{
local string name;
local entity bot;

	next_bot_num = next_bot_num + 1;
	next_bot_blue = next_bot_blue + 1;
	if (next_bot_blue == 1)
     		name = "BlueBot1";
	else if (next_bot_blue == 2)
     		name = "BlueBot2";
	else if (next_bot_blue == 3)
     		name = "BlueBot3";
	else if (next_bot_blue == 4)
     		name = "BlueBot4";
	else if (next_bot_blue == 5)
     		name = "BlueBot5";
	else if (next_bot_blue == 6)
     		name = "BlueBot6";
	else if (next_bot_blue == 7)
     		name = "BlueBot7";
	else if (next_bot_blue == 8)
     		name = "BlueBot8";
	else if (next_bot_blue == 9)
     		name = "BlueBot9";
	else if (next_bot_blue == 10)
     		name = "BlueBot10";
	else if (next_bot_blue == 11)
     		name = "BlueBot11";
	else if (next_bot_red == 12)
     		name = "BlueBot12";
	else if (next_bot_red == 13)
     		name = "BlueBot13";
	else if (next_bot_red == 14)
     		name = "BlueBot14";
	else if (next_bot_red == 15)
     		name = "BlueBot15";
	else if (next_bot_red == 16)
     		name = "BlueBot16";
	else if (next_bot_red == 17)
     		name = "BlueBot17";
	else if (next_bot_red == 18)
     		name = "BlueBot18";
	else if (next_bot_red == 19)
     		name = "BlueBot19";
	else
     		name = "BlueBotUnnamed";
	bot = BotCreate(name, TEAM_COLOR2, bskill);
	return bot;
};

