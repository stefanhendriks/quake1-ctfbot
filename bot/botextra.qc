//botextra.qc
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


//============================================================
void (entity flag_carrier, entity throwto) TossFlag =
{
local entity flg;
local entity oself;

	if (teamplay & TEAM_NO_FLAG_TOSS)
		return;
	if (!(flag_carrier.player_flag & ITEM_ENEMY_FLAG))
		return;

	if (flag_carrier.team == TEAM_COLOR1)
		flg = find(world, classname, "item_flag_team2");
	else if (flag_carrier.team == TEAM_COLOR2)
		flg = find(world, classname, "item_flag_team1");
	
	bprint(flag_carrier.netname);

	local float enteam;
	if (flag_carrier.team == TEAM_COLOR1)
		enteam = TEAM_COLOR2;
	else if (other.team == TEAM_COLOR2)
		enteam = TEAM_COLOR1;		

	// tossed
	bprint(" ÙÔÛÛÂ‰ the ");			// CTFBOT EXTRAS TEAMNAME
	PrintTeamName(world, enteam);	// CTFBOT EXTRAS TEAMNAME
	bprint(" flag!\n");				// CTFBOT EXTRAS TEAMNAME
		
	sound (flag_carrier, CHAN_VOICE, "shalrath/attack2.wav", 1, ATTN_NONE);
	
	LogMsg(flag_carrier, "FLAG-TOSS");

	flg.origin = flag_carrier.origin - '0 0 24';
	flg.cnt = FLAG_DROPPED;
	
	flag_carrier.player_flag = flag_carrier.player_flag - ITEM_ENEMY_FLAG;
//TONY
	flag_carrier.items = flag_carrier.items - (flag_carrier.items & (IT_KEY1 | IT_KEY2));

	
	if (flag_carrier.classname == "player")
	{
		makevectors(flag_carrier.v_angle);
		flg.velocity = aim(flag_carrier, 500);
		flg.velocity = normalize(flg.velocity);
		flg.velocity = flg.velocity * 500;
	}
	else if (flag_carrier.classname == "bot")
	{
		flg.velocity = normalize((throwto.origin + '0 0 300') - flag_carrier.origin);
		flg.velocity = flg.velocity * 500;

		// if bot is tossing flag, bots should ignore it for a few seconds
		// so a human can pick it up
		flg.bot_ignore_until_time = time + 10;
		flg.bot_ignore_team = flag_carrier.team;
	}

	flg.velocity_z = flg.velocity_z + 300;

	flg.flag_toss_time = time;
	flg.last_carrier = flag_carrier;
	
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

//=============================================================
// self is player
//=============================================================
void () OrderTossFlag =
{
local entity head, selected, e, oldself, item;
local float dist, oldweapon;

	if (teamplay & TEAM_NO_FLAG_TOSS)
		return;

	if (self.classname != "player")
		return;

	head = findradius(self.origin, 1000);
	dist = 999999;
	while(head)
	{
		if (head.classname == "bot")
		if (head.team == self.team)
		if (head.player_flag & ITEM_ENEMY_FLAG) 
		if (BotCanSeeItem(head))
		{
			TossFlag(head, self);
			return;
		}
		head = head.chain;
	}
	
	sprint(self, "Flag carrier not nearby\n");
};

//TONY
//REMOVED LIGHTS
//ITS REALLY COOL, BUT NOT VERY USEFUL WITH THE BOTS
//============================================================
//float lightamount;
//float NUM_LIGHT_STEPS = 12;
//float LIGHT_NORMAL = 6;
//============================================================
//void () SetLight =
//{
//	dprint("light = ");
//	dprintfloat(lightamount - LIGHT_NORMAL);
//	if (lightamount == LIGHT_NORMAL)
//		dprint(" [default]");
//	else if (lightamount == 0)
//		dprint(" [minimum]");
//	else if (lightamount == NUM_LIGHT_STEPS)
//		dprint(" [maximum]");
//	dprint("\n");
//
//	if (lightamount == 0)
//		lightstyle(0, "a");
//	else if (lightamount == 1)
//		lightstyle(0, "c");
//	else if (lightamount == 2)
//		lightstyle(0, "f");
//	else if (lightamount == 3)
//		lightstyle(0, "h");
//	else if (lightamount == 4)
//		lightstyle(0, "j");
//	else if (lightamount == 5)
//		lightstyle(0, "l");
//	else if (lightamount == 6)
//		lightstyle(0, "m");
//	else if (lightamount == 7)
//		lightstyle(0, "o");
//	else if (lightamount == 8)
//		lightstyle(0, "q");
//	else if (lightamount == 9)
//		lightstyle(0, "s");
//	else if (lightamount == 10)
//		lightstyle(0, "u");
//	else if (lightamount == 11)
//		lightstyle(0, "x");
//	else if (lightamount == 12)
//		lightstyle(0, "z");
//};
////============================================================
//void () DecreaseLight =
//{
//	lightamount = lightamount + 1;
//	if (lightamount > NUM_LIGHT_STEPS)
//		lightamount = NUM_LIGHT_STEPS;
//		
//	SetLight();
//};
////============================================================
//void () IncreaseLight =
//{
//	lightamount = lightamount - 1;
//	if (lightamount < 0)
//		lightamount = 0;
//
//	SetLight();
//};


//============================================================
// bz joined <X> E.g. red team
//============================================================
string (float fteam) GetTeamName =
{
local string st;

	if (fteam == TEAM_COLOR1)
		st = "RED";
	else if (fteam == TEAM_COLOR2)
		st = "BLUE";
		
	return st;
};
//============================================================
// bz joined <X> E.g. red team
//============================================================
void (entity p, float fteam) PrintTeamName =
{
local float teamname;
local string st;

/*
	if (fteam == TEAM_COLOR1)
		teamname = teamname1;
	else if (fteam == TEAM_COLOR2)
		teamname = teamname2;
	else
		bsprint(p, "unknown");
	st = GetTeamNameNum(teamname);
*/
	if (fteam == TEAM_COLOR1)
		st = "RED";
	else if (fteam == TEAM_COLOR2)
		st = "BLUE";
	bsprint(p, st);
};
//============================================================
// CTF EXTRAS TEAMNAMES ]]]


/*trigger_multiple
trigger_once
trigger_relay
trigger_secret
trigger_counter
trigger_teleport
trigger_setskill
trigger_skill_touch
trigger_hurt
trigger_push_touch
trigger_push 
*/
void () BlinkEnts =
{
	local float drawent;
	local string st;
	drawent = cvar("r_drawentities");
	stuffcmd(self, "r_drawentities ");
	st = ftos(1 - drawent);
	stuffcmd(self, st);
	stuffcmd(self, "\n");
	self.toggle_ents_time = time + 0.3;
	
	local entity e;
	local float thesolid;
	if (drawent)
		thesolid = SOLID_TRIGGER;
	else
		thesolid = SOLID_NOT;
	
	e = find(world, classname, "trigger_multiple");
	while (e != world)
	{
		if (drawent)
			setmodel(e, e.save_model);
		else
			setmodel(e, string_null);
		e = find(e, classname, "trigger_multiple");
		
	}
	e = find(world, classname, "trigger_teleport");
	while (e != world)
	{
		if (drawent)
			setmodel(e, e.save_model);
		else
			setmodel(e, string_null);
		e = find(e, classname, "trigger_teleport");
	}
};

//TONY
//THIS IS NEVER USED
//
// CTFBOT EXTRAS STATUSBAR [[[
//============================================================
//void (float on) ToggleFakeStatusBar =
//{
//	if (on)
//	{
//		stuffcmd(self, "viewsize 120\n");
//		self.last_status_bar_update = -99;
//	}
//	else
//	{
//		stuffcmd(self, "viewsize 100\n");
//		self.last_status_bar_update = 9999999999;
//		centerprint(self, "\n");
//	}
//};
//
// CTFBOT EXTRAS STATUSBAR [[[
//============================================================
//void () FakeStatusBar =
//{
//	if (time > (self.last_status_bar_update + 3))
//	if (self.classname == "player")
//	{
//		local string str1, str2, str3, str4, str5, str6, prefixstr;
//		
//		// 320x240bottom = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
//		prefixstr = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
//		
//		str1 = ftos(self.ammo_shells);
//		str2 = ftos(self.ammo_nails);
//		str3 = ftos(self.ammo_rockets);
//		str4 = ftos(self.ammo_cells);
//
//		str5 = ftos(self.armorvalue);
//
//		if (self.health > 0)
//			str6 = ftos(self.health);
//		else
//			str6 = "X";
//
//		centerprintcat(self, prefixstr, str2, "  ", str5, "  ", str1);
//
//		
//		self.last_status_bar_update = time;
//	}
//};
// CTFBOT EXTRAS STATUSBAR ]]]
/*============================================================*/
//TONY
//REMOVED RADIO.QC
//void (float force_update) DoAnnouncments =
//{
//	if ((nextcommentary > time) && (!force_update))
//		return;
//
//	nextcommentary = time + 30;
//	
//	local entity flag, eflag, p;
//
//	// no status for anything but players
//	if (self.classname != "player")
//		return;	
//
//	if (self.team == TEAM_COLOR1)
//	{
//		flag = find (world,classname, "item_flag_team1");
//		eflag = find (world,classname, "item_flag_team2");
//	}
//	else
//	{
//		flag = find (world,classname, "item_flag_team2");
//		eflag = find (world,classname, "item_flag_team1");
//	}
//	
//	if ((flag == world) || (eflag == world))
//		return;
//		
//	// status reports:
//	// you have enemy flag, your flag at base: you can capture
//	// your team have enemy flag, your flag at base: your team can capture
//	// enemy team have your flag, enemy flag at base: enemy team can capture
//	// both flags dropped
//	// enemy flag dropped
//	// your flag dropped
//	// both flags taken
//	// both flags at base (not reported)
//	
//	if ((eflag.cnt == FLAG_CARRIED)
//		&& (flag.cnt == FLAG_AT_BASE)
//		)
//	{
//		if (eflag.owner == self)
//			sprint(self, "You can capture!\n");
//		else
//			sprint(self, "Your team can capture!\n");
//	}
//	else if ((flag.cnt == FLAG_CARRIED)
//		&& (eflag.cnt == FLAG_AT_BASE)
//		)
//	{
//		sprint(self, "Enemy team can capture!\n");
//	}
//	else if ((flag.cnt == FLAG_DROPPED) || (eflag.cnt == FLAG_DROPPED))
//	{
//		if ((flag.cnt == FLAG_DROPPED) && (eflag.cnt == FLAG_DROPPED))
//		{
//			sprint(self, "Both flags have been dropped!\n");
//		}
//		else if (eflag.cnt == FLAG_DROPPED)
//		{
//			sprint(self, "Enemy flag has been dropped!\n");
//		}
//		else if (flag.cnt == FLAG_DROPPED)
//		{
//			sprint(self, "Your flag has been dropped!\n");
//		}
//	}
//	else if ((flag.cnt == FLAG_CARRIED)
//		&& (eflag.cnt == FLAG_CARRIED))
//	{
//		sprint(self, "Each team has the other flag!\n");
//	}
//};


//=============================================================
//=============================================================
entity (vector org) SpawnPermanentDebugBlob =
{
local entity e;

	precache_model("progs/s_light.spr");
	e = spawn();
	e.classname = "debug_blob";
	e.owner = self;
	e.origin = org;
	setorigin(e, org);
	e.touch = SUB_Null;
	e.solid = SOLID_NOT;
	e.movetype = MOVETYPE_NONE;
	setmodel(e, "progs/s_light.spr");
	setsize (e, '0 0 0', '0 0 0');
	return e;
};

/*============================================================*/
float (entity p) IsPlayerOrBot =
{
	return (p.classname == "player" || p.classname == "bot");
};

// CTFBOT EXTRAS CUSTOMSOUNDS [[[
/*============================================================*/
// fteam is team that took the flag
/*============================================================*/
void (float fteam) PlayFlagTakenSound =
{
local entity p;

	/* taken out because requires more client sounds, but this works
	if (registered & BOT_CUSTOM_SOUNDS)
	{
		p = find(world, classname, "player");
		while (p != world)
		{
			if (p.team == fteam)
				stuffcmd(p, "play misc/flagtk.wav\n");
			else
				stuffcmd(p, "play misc/flagtk2.wav\n");
			p = find(p, classname, "player");
		}
	}
	else
	*/
	
		sound (other, CHAN_AUTO, self.noise, 1, ATTN_NONE);		// CTFBOT EXTRAS changed to ATTN_NONE
};
/*============================================================*/
// fteam is team that captured the flag
/*============================================================*/
void (float fteam) PlayFlagCaptureSound =
{
local entity p;

	/* taken out because requires more client sounds, but this works
	if (registered & BOT_CUSTOM_SOUNDS)
	{
		p = find(world, classname, "player");
		while (p != world)
		{
			if (p.team == fteam)
				stuffcmd(p, "play misc/flagcap.wav\n");
			else
				stuffcmd(p, "play misc/flagcap2.wav\n");
			p = find(p, classname, "player");
		}
	}
	else
	*/
	
		sound (other, CHAN_AUTO, "misc/flagcap.wav", 1, ATTN_NONE);
};
// CTFBOT EXTRAS CUSTOMSOUNDS ]]]


//TONY
//calc player rank
float(entity player) CalcPlayerRank =
{
	local float ranc;
	ranc = player.num_kills - player.num_deaths - player.num_suicides + (player.num_captures * 10) + player.num_bonus;
	return ranc;
};


/*============================================================*/
// DetailedPlayerScores
/*============================================================*/
void(entity requester, entity player) DetailedPlayerScores =
{
	local string st;
	local float ranc;
	
	if (requester.classname != "player")
	{
		return;
	}
	if (player.classname != "player" && player.classname != "bot")
	{
		return;
	}
	
	sprint(requester, player.netname);
				
	if (player.classname == "bot")
	{
		st = ftos(player.bot_skill);
		sprint(requester, " [skill ");
		sprint(requester, st);
		sprint(requester, "] ");
	}

	sprint(requester, "\n");
	PrintTeamName(requester, player.team);
	sprint(requester, " ");
	
	sprint(requester, "rank ");
//tony
//new rankings
	ranc = CalcPlayerRank(player);
	sprintfloat(requester, ranc);
	sprint(requester, " old rank ");
	sprintfloat(requester, player.num_kills - player.num_deaths);

	sprint(requester, "\n");
	
	sprintfloat(requester, player.frags);
	sprint(requester, " frags, ");
	
	sprintfloat(requester, player.num_captures);
	sprint(requester, " captures, ");

	sprintfloat(requester, player.num_assists);
	sprint(requester, " assists\n");

	sprintfloat(requester, player.num_recovery);
	sprint(requester, " recover, ");

	sprintfloat(requester, player.num_bonus);
	sprint(requester, " bonus, ");

	sprintfloat(requester, player.num_pickups);
	sprint(requester, " pickups");	// note no \n here

	sprint(requester, "\n");
	
	sprintfloat(requester, player.num_kills);
	sprint(requester, " kills, ");
	
	sprintfloat(requester, player.num_deaths);
	sprint(requester, " deaths, ");
	
	sprintfloat(requester, player.num_suicides);
	sprint(requester, " suicides");

	sprint(requester, "\n");
	
};


/*============================================================*/

// DetailedPlayerScores

/*============================================================*/

void(entity player) DetailedPlayerScoresBroadcast =
{
	local string st;
	local float ranc;

	if (player.classname != "player" && player.classname != "bot")
	{
		return;
	}
	
	// format for detailed scores:
	// 1234567890123456789012345678901234567
	// Detailed Scores for e1m1:
	// Name [RED][rank 0]
	// 0 frags, 0 captures, 0 assists
	// 0 recover, 0 bonus, 0 pickups
	// 0 kills, 0 deaths, 0 suicides
	// NameNoCTF:
	// [0 frags] 
	// [0 kills][0 deaths][0 suicides]

	bprint(player.netname);
	// CTFBOT [[[
	if (player.classname == "bot")
	{
		st = ftos(player.bot_skill);
		bprint(" [skill ");
		bprint(st);
		bprint("] ");
	}
	// CTFBOT ]]]

	bprint("\n");
	PrintTeamName(world, player.team);
	bprint(" ");
	bprint("[rank ");
//tony
//new rankings
	ranc = CalcPlayerRank(player);
	st = ftos(ranc);
	bprint(st);

	bprint("] [old rank ");
	st = ftos(player.num_kills - player.num_deaths);
	bprint(st);
	bprint("]\n");


	st = ftos(player.frags);
	bprint(st);
	bprint(" frags, ");
	st = ftos(player.num_captures);
	bprint(st);
	bprint(" captures, ");
	st = ftos(player.num_assists);
	bprint(st);
	bprint(" assists, \n");
	st = ftos(player.num_recovery);
	bprint(st);
	bprint(" recover, ");
	st = ftos(player.num_bonus);
	bprint(st);
	bprint(" bonus, ");
	st = ftos(player.num_pickups);
	bprint(st);
	bprint(" pickups, ");	// note no \n here
	bprint("\n");
	st = ftos(player.num_kills);
	bprint(st);
	bprint(" kills, ");
	st = ftos(player.num_deaths);
	bprint(st);
	bprint(" deaths, ");
	st = ftos(player.num_suicides);
	bprint(st);
	bprint(" suicides\n");
	bprint("\n");
};

/*============================================================*/
/*============================================================*/
void (float flo, float ndig, float printfrac) PrintFloat =
{
local float f1, f2;
local string st;

	f1 = floor(flo);
	
	if ((f1 < 1000) && (ndig >= 4))
		bprint(" ");
	if ((f1 < 100) && (ndig >= 3))
		bprint(" ");
	if ((f1 < 10) && (ndig >= 2))
		bprint(" ");

	st = ftos(f1);
	bprint(st);
	if (printfrac)
	{
		f2 = flo - floor(flo);
		f2 = f2 * 10;
		f2 = floor(f2);

		bprint(".");
		st = ftos(f2);
		bprint(st);
	}
};
/*============================================================*/
/*============================================================*/
void (float n1, float n2, float np1, float np2) SPrintLine =
{
	SPrintFloatDigits(n1, 3, FALSE);
	sprint(self, " ");
	SPrintFloatDigits(n2, 3, FALSE);
	sprint(self, " ");
	if (np1 != 0)
		SPrintFloatDigits(n1 / np1, 4, FALSE);
	else
		bprint("     ");
	sprint(self, " ");
	if (np2 != 0)
		SPrintFloatDigits(n2 / np2, 4, FALSE);
	else
		sprint(self, "     ");
	sprint(self, " ");
	SPrintFloatDigits(n1 + n2, 3, FALSE);
	sprint(self, "\n");
};
/*============================================================*/
/*============================================================*/
void (float n1, float n2, float np1, float np2) PrintLine =
{
	PrintFloat(n1, 3, FALSE);
	bprint(" ");
	PrintFloat(n2, 3, FALSE);
	bprint(" ");
	if (np1 != 0)
		PrintFloat(n1 / np1, 4, FALSE);
	else
		bprint("     ");
	bprint(" ");
	if (np2 != 0)
		PrintFloat(n2 / np2, 4, FALSE);
	else
		bprint("     ");
	bprint(" ");
	PrintFloat(n1 + n2, 3, FALSE);
	bprint("\n");
};
//==========================================================
float (float fteam) GetNumHumansOnTeam =
{
local entity p;
local float num;
	
	num = 0;
	p = find(world, classname, "player");
	while (p != world)
	{
		if (p.team == fteam)
			num = num + 1;
		p = find(p, classname, "player");
	}
	
	return num;
};//==========================================================
float (float fteam) GetNumPlayersOnTeam =
{
local entity p;
local float num;
	
	num = 0;
	p = find(world, classname, "player");
	while (p != world)
	{
		if (p.team == fteam)
			num = num + 1;
		p = FindNextPlayerOrBot(p);
	}
	
	return num;
};
/*============================================================*/
// DetailedScores
/*============================================================*/
void(entity requester) DetailedScores =
{
local float nkills1, ndeaths1, nsuicides1, ncaptures1, nassists1, nbonus1;
local float npickups1, nrecovery1, nfrags1;
local float nkills2, ndeaths2, nsuicides2, ncaptures2, nassists2, nbonus2;
local float npickups2, nrecovery2, nfrags2;
local float nplayers1, nplayers2;

	nfrags1 = 0; nfrags2 = 0;
	nkills1 = 0; nkills2 = 0;
	ndeaths1 = 0; ndeaths2 = 0;
	nsuicides1 = 0; nsuicides2 = 0;
	ncaptures1 = 0; ncaptures2 = 0;
	nassists1 = 0; nassists2 = 0;
	nbonus1 = 0; nbonus2 = 0;
	npickups1 = 0; npickups2 = 0;
	nrecovery1 = 0; nrecovery2 = 0;

	sprint(requester, "Detailed Scores for Level [");
	sprint(requester, mapname);
	sprint(requester, "]:\n");
	local entity p;

//TONY
	local float capoff;
	capoff = 0;

	p = find(world, classname, "bot");
	while ((p != world) && (capoff < MAX_BOTS_TO_PRINT))
	{
		if (p.team == TEAM_COLOR1)
		{
			nfrags1 = nfrags1 + p.frags;
			nkills1 = nkills1 + p.num_kills;
			ndeaths1 = ndeaths1 + p.num_deaths;
			nsuicides1 = nsuicides1 + p.num_suicides;
			ncaptures1 = ncaptures1 + p.num_captures;
			nassists1 = nassists1 + p.num_assists;
			nbonus1 = nbonus1 + p.num_bonus;
			npickups1 = npickups1 + p.num_pickups;
			nrecovery1 = nrecovery1 + p.num_recovery;
		} 
		else if (p.team == TEAM_COLOR2)
		{
			nfrags2 = nfrags2 + p.frags;
			nkills2 = nkills2 + p.num_kills;
			ndeaths2 = ndeaths2 + p.num_deaths;
			nsuicides2 = nsuicides2 + p.num_suicides;
			ncaptures2 = ncaptures2 + p.num_captures;
			nassists2 = nassists2 + p.num_assists;
			nbonus2 = nbonus2 + p.num_bonus;
			npickups2 = npickups2 + p.num_pickups;
			nrecovery2 = nrecovery2 + p.num_recovery;
		}

		DetailedPlayerScores(requester, p);
		p = find(p, classname, "bot");
		capoff = capoff + 1;
	}

	bprint("ùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü\n");

	p = find(world, classname, "player");
	while (p != world)
	{
		if (p.team == TEAM_COLOR1)
		{
			nfrags1 = nfrags1 + p.frags;
			nkills1 = nkills1 + p.num_kills;
			ndeaths1 = ndeaths1 + p.num_deaths;
			nsuicides1 = nsuicides1 + p.num_suicides;
			ncaptures1 = ncaptures1 + p.num_captures;
			nassists1 = nassists1 + p.num_assists;
			nbonus1 = nbonus1 + p.num_bonus;
			npickups1 = npickups1 + p.num_pickups;
			nrecovery1 = nrecovery1 + p.num_recovery;
		} 
		else if (p.team == TEAM_COLOR2)
		{
			nfrags2 = nfrags2 + p.frags;
			nkills2 = nkills2 + p.num_kills;
			ndeaths2 = ndeaths2 + p.num_deaths;
			nsuicides2 = nsuicides2 + p.num_suicides;
			ncaptures2 = ncaptures2 + p.num_captures;
			nassists2 = nassists2 + p.num_assists;
			nbonus2 = nbonus2 + p.num_bonus;
			npickups2 = npickups2 + p.num_pickups;
			nrecovery2 = nrecovery2 + p.num_recovery;
		}

		DetailedPlayerScores(requester, p);
		p = find(p, classname, "player");
	}



	bprint("ùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü\n");

	PrintFragList(TRUE);

	bprint("ùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü\n");
		
	nplayers1 = GetNumPlayersOnTeam(TEAM_COLOR1);
	nplayers2 = GetNumPlayersOnTeam(TEAM_COLOR2);

	sprint(self, "         Red Blu RAvg BAvg Tot\n");
	sprint(self, "Frags    ");
	SPrintLine(nfrags1, nfrags2, nplayers1, nplayers2);
	sprint(self, "Captures ");
	SPrintLine(ncaptures1, ncaptures2, nplayers1, nplayers2);
	sprint(self, "Pickups  ");
	SPrintLine(npickups1, npickups2, nplayers1, nplayers2);
	sprint(self, "Assists  ");
	SPrintLine(nassists1, nassists2, nplayers1, nplayers2);
	sprint(self, "Bonuses  ");
	SPrintLine(nbonus1, nbonus2, nplayers1, nplayers2);
	sprint(self, "Recovery ");
	SPrintLine(nrecovery1, nrecovery2, nplayers1, nplayers2);
	sprint(self, "Kills    ");
	SPrintLine(nkills1, nkills2, nplayers1, nplayers2);
	sprint(self, "Deaths   ");
	SPrintLine(ndeaths1, ndeaths2, nplayers1, nplayers2);
	sprint(self, "Suicides ");
	SPrintLine(nsuicides1, nsuicides2, nplayers1, nplayers2);
};
/*                 Dr. Gibbenstein
1234567890123456789012345678901234567
         Red Blu RAvg BAvg Tot
Frags    999 999 99.9 99.9 999
Captures 999 999 99.9 99.9 999
Pickups  999 999 99.9 99.9 999
Assists  999 999 99.9 99.9 999
Bonuses  999 999 99.9 99.9 999
Recovery 999 999 99.9 99.9 999
Kills    999 999 99.9 99.9 999
Deaths   999 999 99.9 99.9 999
Suicides 999 999 99.9 99.9 999

Cap Pk As Bo Re Player
 99 99 99 99 99 aasdfasdfadf
 99 99 99 99 99 asdfasdfadf

Frg Kil Dth Sui Player
999 999 999 999 asdfasfd
*/
/*============================================================*/
// DetailedScoresBroadcast
/*============================================================*/
void() DetailedScoresBroadcast =
{
local float nkills1, ndeaths1, nsuicides1, ncaptures1, nassists1, nbonus1;
local float npickups1, nrecovery1, nfrags1;
local float nkills2, ndeaths2, nsuicides2, ncaptures2, nassists2, nbonus2;
local float npickups2, nrecovery2, nfrags2;
local float nplayers1, nplayers2;

	nfrags1 = 0; nfrags2 = 0;
	nkills1 = 0; nkills2 = 0;
	ndeaths1 = 0; ndeaths2 = 0;
	nsuicides1 = 0; nsuicides2 = 0;
	ncaptures1 = 0; ncaptures2 = 0;
	nassists1 = 0; nassists2 = 0;
	nbonus1 = 0; nbonus2 = 0;
	npickups1 = 0; npickups2 = 0;
	nrecovery1 = 0; nrecovery2 = 0;

	bprint("ùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü\n");
	bprint("Detailed Scores for Level ");
	bprint(mapname);
	bprint(":\n");
	local entity p;
//TONY
//CAP OFF PRINT
	local float capoff;
	capoff = 0;

	p = find(world, classname, "bot");
	while ((p != world) && (capoff < MAX_BOTS_TO_PRINT))
	{
		if (p.team == TEAM_COLOR1)
		{
			nfrags1 = nfrags1 + p.frags;
			nkills1 = nkills1 + p.num_kills;
			ndeaths1 = ndeaths1 + p.num_deaths;
			nsuicides1 = nsuicides1 + p.num_suicides;
			ncaptures1 = ncaptures1 + p.num_captures;
			nassists1 = nassists1 + p.num_assists;
			nbonus1 = nbonus1 + p.num_bonus;
			npickups1 = npickups1 + p.num_pickups;
			nrecovery1 = nrecovery1 + p.num_recovery;
		} 
		else if (p.team == TEAM_COLOR2)
		{
			nfrags2 = nfrags2 + p.frags;
			nkills2 = nkills2 + p.num_kills;
			ndeaths2 = ndeaths2 + p.num_deaths;
			nsuicides2 = nsuicides2 + p.num_suicides;
			ncaptures2 = ncaptures2 + p.num_captures;
			nassists2 = nassists2 + p.num_assists;
			nbonus2 = nbonus2 + p.num_bonus;
			npickups2 = npickups2 + p.num_pickups;
			nrecovery2 = nrecovery2 + p.num_recovery;
		}
		DetailedPlayerScoresBroadcast(p);
		p = find(p, classname, "bot");
		capoff = capoff + 1;
	}

	bprint("ùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü\n");

	p = find(world, classname, "player");
	while (p != world)
	{
		if (p.team == TEAM_COLOR1)
		{
			nfrags1 = nfrags1 + p.frags;
			nkills1 = nkills1 + p.num_kills;
			ndeaths1 = ndeaths1 + p.num_deaths;
			nsuicides1 = nsuicides1 + p.num_suicides;
			ncaptures1 = ncaptures1 + p.num_captures;
			nassists1 = nassists1 + p.num_assists;
			nbonus1 = nbonus1 + p.num_bonus;
			npickups1 = npickups1 + p.num_pickups;
			nrecovery1 = nrecovery1 + p.num_recovery;
		} 
		else if (p.team == TEAM_COLOR2)
		{
			nfrags2 = nfrags2 + p.frags;
			nkills2 = nkills2 + p.num_kills;
			ndeaths2 = ndeaths2 + p.num_deaths;
			nsuicides2 = nsuicides2 + p.num_suicides;
			ncaptures2 = ncaptures2 + p.num_captures;
			nassists2 = nassists2 + p.num_assists;
			nbonus2 = nbonus2 + p.num_bonus;
			npickups2 = npickups2 + p.num_pickups;
			nrecovery2 = nrecovery2 + p.num_recovery;
		}
		DetailedPlayerScoresBroadcast(p);
		p = find(p, classname, "player");
	}


	
	bprint("ùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü\n");

	PrintFragList(TRUE);
	
	bprint("ùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü\n");
	
	BroadcastMVP();		// CTFBOT EXTRAS
		
	nplayers1 = GetNumPlayersOnTeam(TEAM_COLOR1);
	nplayers2 = GetNumPlayersOnTeam(TEAM_COLOR2);

	bprint("         Red Blu RAvg BAvg Tot\n");
	bprint("Frags    ");
	PrintLine(nfrags1, nfrags2, nplayers1, nplayers2);
	bprint("Captures ");
	PrintLine(ncaptures1, ncaptures2, nplayers1, nplayers2);
	bprint("Pickups  ");
	PrintLine(npickups1, npickups2, nplayers1, nplayers2);
	bprint("Assists  ");
	PrintLine(nassists1, nassists2, nplayers1, nplayers2);
	bprint("Bonuses  ");
	PrintLine(nbonus1, nbonus2, nplayers1, nplayers2);
	bprint("Recovery ");
	PrintLine(nrecovery1, nrecovery2, nplayers1, nplayers2);
	bprint("Kills    ");
	PrintLine(nkills1, nkills2, nplayers1, nplayers2);
	bprint("Deaths   ");
	PrintLine(ndeaths1, ndeaths2, nplayers1, nplayers2);
	bprint("Suicides ");
	PrintLine(nsuicides1, nsuicides2, nplayers1, nplayers2);
};
//==========================================================
void () BroadcastMVP =
{
local entity p;
local entity best;
//local float best_frags;
local float best_rank;

	best = world;
	best_rank = 0;
//	best_frags = 0;

	p = find(world, classname, "player");
	while (p != world)
	{
		if (CalcPlayerRank(p) > best_rank)
		{
			best = p;
			best_rank = CalcPlayerRank(p);
		}
		p = FindNextPlayerOrBot(p);
	}
	
// Most Valuable Player
// ÕÔÛÙ ÷·Ïı·‚ÏÂ –Ï·˘ÂÚ

	if (best != world)
	{
		bprint("ÄÇ ÕÔÛÙ ÷·Ïı·‚ÏÂ –Ï·˘ÂÚ ê");
		bprint(mapname);
		bprint("ë ÄÇ\n");
		DetailedPlayerScoresBroadcast(best);
	}
};
//==========================================================
void () ToggleAllConsoles =
{
local entity p;

	p = find(world, classname, "player");
	while (p != world)
	{
		stuffcmd(p, "toggleconsole\n");
		p = find(p, classname, "player");
	}
};
//==========================================================
float () GetNumHumans =
{
local entity p;
local float num;
	
	num = 0;
	p = find(world, classname, "player");
	while (p != world)
	{
		num = num + 1;
		p = find(p, classname, "player");
	}
	
	return num;
};
//==========================================================
//==========================================================
entity(float dweapon, entity throwto) TossWeaponBackpack =
{
	local entity 	item;

	// If we don't have any ammo, return
	if(self.currentammo <= 0)
		return;

	item = spawn();

	// See if you have the Shotgun or Super Shotgun on
    if (self.weapon == IT_SUPER_SHOTGUN) {
		if( self.ammo_shells >= 20 ) {
			item.ammo_shells = 20;
			self.ammo_shells = self.ammo_shells - 20;
		}
		else
		{
			item.ammo_shells = self.ammo_shells;
			self.ammo_shells = 0;
		}
		self.items = self.items - IT_SUPER_SHOTGUN;
	}		
	
	// See if we are using a nailgun
    else if ( (self.weapon == IT_NAILGUN) || (self.weapon == IT_SUPER_NAILGUN) )
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
		if (self.weapon == IT_NAILGUN)
			self.items = self.items - IT_NAILGUN;
		else if (self.weapon == IT_SUPER_NAILGUN)
			self.items = self.items - IT_SUPER_NAILGUN;
	}	
	
	// See if we are using a grenade or rocket launcher
    else if ( (self.weapon == IT_GRENADE_LAUNCHER) || (self.weapon == IT_ROCKET_LAUNCHER) )
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
		if (self.weapon == IT_GRENADE_LAUNCHER)
			self.items = self.items - IT_GRENADE_LAUNCHER;
		else if (self.weapon == IT_ROCKET_LAUNCHER)
			self.items = self.items - IT_ROCKET_LAUNCHER;
	}

	// See if we're using the lightning gun
	else if ( self.weapon == IT_LIGHTNING )
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
		if (self.weapon == IT_LIGHTNING)
			self.items = self.items - IT_LIGHTNING;
	}

	if (dweapon != IT_HOOK || dweapon != IT_AXE)
		item.items = dweapon;

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
	 
	item.owner = self;
		
	setorigin(item, self.origin + '0 0 16');
	
	if (self.classname == "player")
	{
		makevectors(self.v_angle);
		item.velocity = aim(self, 1000);
		item.velocity = item.velocity * 750;
		self.weapon = W_BestWeapon();
	}
	else if (self.classname == "bot")
	{
		item.velocity = normalize(self.origin - throwto.origin);
		item.velocity = item.velocity * 750;
		self.weapon = Bot_BestWeapon();
	}
	
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
									
	return item;
};

/*============================================================*/
// self is player
/*============================================================*/
void() RuneStatus =
{
	// no status for anything but players
	if (self.classname != "player")
		return;
		
	if (self.player_flag & ITEM_RUNE1_FLAG) {
		sprint(self, "You have the Rune of ≈·ÚÙË Õ·ÁÈ„!\n");	//, “ÂÛÈÛÙ·Ó„Â!\n");
	}
	if (self.player_flag & ITEM_RUNE2_FLAG) {
		sprint(self, "You have the Rune of ¬Ï·„Î Õ·ÁÈ„!\n");	//, ”ÙÚÂÓÁÙË!\n");
	}
	if (self.player_flag & ITEM_RUNE3_FLAG) {
		sprint(self, "You have the Rune of »ÂÏÏ Õ·ÁÈ„!\n");	//, »·ÛÙÂ!\n");
	}
	if (self.player_flag & ITEM_RUNE4_FLAG) {
		sprint(self, "You have the Rune of ≈Ï‰ÂÚ Õ·ÁÈ„!\n");	//, “ÂÁÂÓÂÚ·ÙÈÔÓ!\n");
	}
};

/*============================================================*/
// PlayerDropRune
// self is player
/*============================================================*/
entity() PlayerDropRune =
{
local entity rune;

	if (teamplay & TEAM_NO_RUNE_DROP)
		return;
		
	rune = world;
		
	if (self.classname == "player")		// no sprints for non-players
	{
		if (self.player_flag & ITEM_RUNE1_FLAG) {
			sprint(self, "You dropped the Rune of ≈·ÚÙË Õ·ÁÈ„!\n");	//, “ÂÛÈÛÙ·Ó„Â!\n");
		}
		if (self.player_flag & ITEM_RUNE2_FLAG) {
			sprint(self, "You dropped the Rune of ¬Ï·„Î Õ·ÁÈ„!\n");	//, ”ÙÚÂÓÁÙË!\n");
		}
		if (self.player_flag & ITEM_RUNE3_FLAG) {
			sprint(self, "You dropped the Rune of »ÂÏÏ Õ·ÁÈ„!\n");	//, »·ÛÙÂ!\n");
		}
		if (self.player_flag & ITEM_RUNE4_FLAG) {
			sprint(self, "You dropped the Rune of ≈Ï‰ÂÚ Õ·ÁÈ„!\n");	//, “ÂÁÂÓÂÚ·ÙÈÔÓ!\n");
		}
	}
	
	self.rune_drop_time = time;
	
	if (self.player_flag & ITEM_RUNE1_FLAG)
	{
		self.last_rune = ITEM_RUNE1_FLAG;
		rune = Do_DropRune(ITEM_RUNE1_FLAG);
	}
	if (self.player_flag & ITEM_RUNE2_FLAG)
	{
		self.last_rune = ITEM_RUNE2_FLAG;
		rune = Do_DropRune(ITEM_RUNE2_FLAG);
	}
	if (self.player_flag & ITEM_RUNE3_FLAG)
	{
		self.last_rune = ITEM_RUNE3_FLAG;
		rune = Do_DropRune(ITEM_RUNE3_FLAG);
	}
	if (self.player_flag & ITEM_RUNE4_FLAG)
	{
		self.last_rune = ITEM_RUNE4_FLAG;
		rune = Do_DropRune(ITEM_RUNE4_FLAG);
	}
	self.player_flag = self.player_flag - (self.player_flag & ITEM_RUNE_MASK);
	
	return rune;
};

/*============================================================*/
// temp think routine for runes so they can't be picked up for 2 seconds
void () RuneThink = 
{
	self.nextthink = time + 118; /* if no one touches it in two minutes,
		respawn it somewhere else, so inaccessible ones will come 'back' */
	self.think = RuneRespawn;
	
	self.touch = RuneTouch;		// start to allow normal touches
};

/*============================================================*/
void (float fteam) RemoveTeamStarts = 

{
local entity p, nextp;




	if (fteam == TEAM_COLOR1)

		p = find(world, classname, "info_player_team1");

	else

		p = find(world, classname, "info_player_team2");



	while (p != world)

	{

		if (fteam == TEAM_COLOR1)

			nextp = find(p, classname, "info_player_team1");

		else

			nextp = find(p, classname, "info_player_team2");



		remove(p);



		p = nextp;

	}

};



/*============================================================*/

float (vector org) IsGoodSpawnPoint = 

{

	if (pointcontents(org + '0 0 0') != CONTENT_EMPTY)

		return FALSE;



	if (pointcontents(org + '16 16 -24') != CONTENT_EMPTY)

		return FALSE;

	if (pointcontents(org + '-16 -16 -24') != CONTENT_EMPTY)

		return FALSE;

	if (pointcontents(org + '16 -16 -24') != CONTENT_EMPTY)

		return FALSE;

	if (pointcontents(org + '-16 16 -24') != CONTENT_EMPTY)

		return FALSE;



	if (pointcontents(org + '16 16 32') != CONTENT_EMPTY)

		return FALSE;

	if (pointcontents(org + '-16 -16 32') != CONTENT_EMPTY)

		return FALSE;

	if (pointcontents(org + '-16 16 32') != CONTENT_EMPTY)

		return FALSE;

	if (pointcontents(org + '16 -16 32') != CONTENT_EMPTY)

		return FALSE;



	return TRUE;

};

/*============================================================*/

void (vector org, float fteam) spawn_team_start = 

{

local entity st;

	

	st = spawn();

	st.dynamically_created = TRUE;

	if (IsGoodSpawnPoint(org))

	{

		st.bogus_start = 1;

		st.origin = org;

		setorigin(st, org);
		st.solid = SOLID_NOT;
		st.movetype = MOVETYPE_NONE;
		setmodel(st, string_null);

		if (fteam == TEAM_COLOR1) 

			st.classname = "info_player_team1";

		else

			st.classname = "info_player_team2";

	}

	else

		remove(st);

};



/*============================================================*/

void (float fteam) SpawnFlag = 

{

local entity p, flag;


	if ((self.player_flag & ITEM_ENEMY_FLAG) && (self.team != fteam))

	{

		dprint("you have the enemy flag\n");

		dprint("enemy flag must be in its base before moving it\n");

		return;

	}



	if (fteam == TEAM_COLOR1)

	{

		p = find(world, classname, "item_flag_team1");

		if (p != world)

		{

			bprint("moving “≈ƒ flag and spawn points");

			remove(p);

		}

		else

			bprint("creating “≈ƒ flag and spawn points");

	}

	else if (fteam == TEAM_COLOR2)

	{

		p = find(world, classname, "item_flag_team2");

		if (p != world)

		{

			bprint("moving ¬Ã’≈ flag and spawn points");

			remove(p);

		}

		else

			bprint("creating ¬Ã’≈ flag and spawn points");

	}

	else

	{

		dprint("incorrect team = ");

		dprintfloat(fteam);

		dprint(" no flag spawned\n");

		return;

	}

	

	bprint("\n");



	sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);

	bprint("please step out of the way...\n");



	flag = spawn();

	flag.dynamically_created = TRUE;

	if (fteam == TEAM_COLOR1)

	{

		flag.classname = "item_flag_team1";

		flag.skin = 0;

	}

	else

	{

		flag.classname = "item_flag_team2";

		flag.skin = 1;

	}

	flag.origin = self.origin + '0 0 0';

	setorigin(flag, flag.origin);

	flag.team = fteam;
	flag.lastteam = fteam;

	if (fteam == TEAM_COLOR1)
		flag.items = IT_KEY2;
	else if (fteam == TEAM_COLOR2)
		flag.items = IT_KEY1;

	if (cvar("teamplay") & TEAM_CAPTURE_CUSTOM) {

		setmodel (flag, "progs/flag.mdl");

		flag.noise = "misc/flagtk.wav";

		flag.noise1 = "doors/runetry.wav";

		setsize(flag, '-16 -16 0', '16 16 74');

	} else {

		setmodel (flag, "progs/w_s_key.mdl");

		flag.noise = "misc/medkey.wav";

		flag.noise1 = "doors/runetry.wav";

		setsize(flag, '-16 -16 -24', '16 16 32');

	}



	flag.nextthink = time + 2;

	flag.think = place_flag;



	RemoveTeamStarts(fteam);

	spawn_team_start(self.origin + '60 -60 0', fteam);

	spawn_team_start(self.origin + '60 0 0', fteam);

	spawn_team_start(self.origin + '60 60 0', fteam);

	spawn_team_start(self.origin + '0 -60 0', fteam);

	spawn_team_start(self.origin + '0 0 0', fteam);

	spawn_team_start(self.origin + '0 60 0', fteam);

	spawn_team_start(self.origin + '-60 -60 0', fteam);

	spawn_team_start(self.origin + '-60 0 0', fteam);

	spawn_team_start(self.origin + '-60 60 0', fteam);

};





void(vector org) spawn_supershotgun =

{

local entity oldself;



	oldself = self;

	self = spawn();

	self.dynamically_created = TRUE;

	self.classname = "weapon_supershotgun";

	setorigin(self, org);

	setmodel (self, "progs/g_shot.mdl");

	self.weapon = IT_SUPER_SHOTGUN;

	self.netname = "Double-barrelled Shotgun";

	self.touch = weapon_touch;

	setsize (self, '-16 -16 0', '16 16 56');

	self.nextthink = time + 2;

	self.think = PlaceItem;

	self = oldself;

};



void(vector org) spawn_supernailgun =

{

local entity oldself;



	oldself = self;

	self = spawn();

	self.dynamically_created = TRUE;

	self.classname = "weapon_supernailgun";

	setorigin(self, org);

	setmodel (self, "progs/g_nail2.mdl");

	self.weapon = IT_SUPER_NAILGUN;

	self.netname = "Super Nailgun";

	self.touch = weapon_touch;

	setsize (self, '-16 -16 0', '16 16 56');

	self.nextthink = time + 2;

	self.think = PlaceItem;

	self = oldself;

};



void(vector org) spawn_25_health =

{	

local entity oldself;



	oldself = self;

	self = spawn();

	self.dynamically_created = TRUE;

	self.classname = "item_health";

	setorigin(self, org);

	self.touch = health_touch;

	setmodel(self, "maps/b_bh25.bsp");

	self.noise = "items/health1.wav";

	self.healamount = 25;


	self.healtype = 1;


	setsize (self, '0 0 0', '32 32 56');


	self.nextthink = time + 2;


	self.think = PlaceItem;


	self = oldself;


};


void(vector org) spawn_shells_large =


{


local entity oldself;





	oldself = self;


	self = spawn();


	self.dynamically_created = TRUE;


	self.classname = "item_shells";


	setorigin(self, org);


	self.touch = ammo_touch;


	self.spawnflags = self.spawnflags | WEAPON_BIG2;


	setmodel (self, "maps/b_shell1.bsp");


	self.aflag = 40;


	self.weapon = 1;


	self.netname = "shells";


	setsize (self, '0 0 0', '32 32 56');


	self.nextthink = time + 2;


	self.think = PlaceItem;


	self = oldself;


};





void(vector org) spawn_nails_large =


{


local entity oldself;





	oldself = self;


	self = spawn();


	self.dynamically_created = TRUE;


	self.classname = "item_spikes";


	setorigin(self, org);


	self.touch = ammo_touch;


	self.spawnflags = self.spawnflags | WEAPON_BIG2;


	setmodel (self, "maps/b_nail1.bsp");


	self.aflag = 50;


	self.weapon = 2;


	self.netname = "nails";


	setsize (self, '0 0 0', '32 32 56');


	self.nextthink = time + 2;


	self.think = PlaceItem;


	self = oldself;


};





void(vector org) spawn_yellow_armor =
{
local entity oldself;

	oldself = self;
	self = spawn();
	self.dynamically_created = TRUE;
	self.classname = "item_armor2";
	setorigin(self, org);
	self.touch = armor_touch;
	setmodel (self, "progs/armor.mdl");
	self.skin = 1;
	setsize (self, '-16 -16 0', '16 16 56');
	self.nextthink = time + 2;
	self.think = PlaceItem;
	self = oldself;
};

/*
//=============================================================
//=============================================================
void() set_generic_model =
{
	if (self.classname == "")
		return;
	else if (self.classname == "item_armorInv")
		self.touch = armor_touch;
	else if (self.classname == "item_armor2")
		self.touch = armor_touch;
	else if (self.classname == "item_armor1")
		self.touch = armor_touch;
};
//=============================================================
//=============================================================
void() set_generic_model =
{
	if (self.classname == "")
		return;
	else if (self.classname == "item_armorInv")
		setmodel (self, "progs/armor.mdl");	
	else if (self.classname == "item_armor2")
		setmodel (self, "progs/armor.mdl");	
	else if (self.classname == "item_armor1")
		setmodel (self, "progs/armor.mdl");	
};
//=============================================================
//=============================================================
void() set_generic_size =
{
	if (self.classname == "")
		return;
	else if (self.classname == "item_armorInv")
		setsize (self, '-16 -16 0', '16 16 56');
	else if (self.classname == "item_armor2")
		setsize (self, '-16 -16 0', '16 16 56');
	else if (self.classname == "item_armor1")
		setsize (self, '-16 -16 0', '16 16 56');
};
//=============================================================
//=============================================================
void() set_generic_skin =
{
	if (self.classname == "")
		return;
	else if (self.classname == "item_armorInv")
		self.skin = 0;
	else if (self.classname == "item_armor2")
		self.skin = 1;
	else if (self.classname == "item_armor1")
		self.skin = 2;
};
//=============================================================
//=============================================================
void(vector org, string classn) spawn_generic_item =
{
local entity oldself;

	oldself = self;
	
	self = spawn();
	self.dynamically_created = TRUE;
	self.classname = classn;
	
	local vector offs;
	setorigin(self, org);
	
	set_generic_touch();
	set_generic_model();
	set_generic_size();
	set_generic_skin();
	
	self.nextthink = time + 2;
	self.think = PlaceItem;
	
	self = oldself;
};
*/

//=============================================================
//=============================================================
void() SpawnBaseStockpile =
{
	bprint("creating base stockpile\n");
	bprint("please step out of the way...\n");

	spawn_25_health(self.origin + '0 -58 0');
	spawn_yellow_armor(self.origin + '0 0 0');
	spawn_25_health(self.origin + '0 58 0');
	spawn_nails_large(self.origin + '-58 -58 0');
	spawn_supershotgun(self.origin + '-58 0 0');
	spawn_nails_large(self.origin + '-58 58 0');
	spawn_shells_large(self.origin + '58 -58 0');
	spawn_supernailgun(self.origin + '58 0 0');
	spawn_shells_large(self.origin + '58 58 0');
};

//=============================================================
//=============================================================
void(entity p) PrintEntityForBSP =
{
local float val;

	if (p != world)
	{
		dprint("{\n");
		dprint("\"");
		dprint("classname");
		dprint("\"");
		dprint(" \"");
		dprint(p.classname);
		dprint("\"\n");
		dprint("\"");
		dprint("origin");
		dprint("\"");
		dprint(" \"");
		val = floor(p.origin_x);
		dprintfloat(val);
		dprint(" ");
		val = floor(p.origin_y);
		dprintfloat(val);
		dprint(" ");
		val = floor(p.origin_z);
		dprintfloat(val);
		dprint("\"\n");
		if (p.angles_y != 0)
		{
			dprint("\"");
			dprint("angle");
			dprint("\"");
			dprint(" \"");
			dprintfloat(p.angles_y);
			dprint("\"\n");
		}
		if (p.spawnflags != 0)
		{
			dprint("\"");
			dprint("spawnflags");
			dprint("\"");
			dprint(" \"");
			dprintfloat(p.spawnflags);
			dprint("\"\n");
		}
		if (p.classname == "waypoint")
		{
			dprint("\"");
			dprint("team");
			dprint("\"");
			dprint(" \"");
			dprintfloat(p.team);
			dprint("\"\n");
		}
		if (p.classname == "waypoint")
		{
			dprint("\"");
			dprint("waypoint_num");
			dprint("\"");
			dprint(" \"");
			dprintfloat(p.waypoint_num);
			dprint("\"\n");
		}
		dprint("}\n");
	}
};


//=============================================================
//=============================================================
void(entity p) PrintEntityForCode =
{
local float val;

	if (p != world)
	{
		dprint("{\n");
		dprint("\"");
		dprint("classname");
		dprint("\"");
		dprint(" \"");
		dprint(p.classname);
		dprint("\"\n");
		dprint("\"");
		dprint("origin");
		dprint("\"");
		dprint(" \"");
		val = floor(p.origin_x);
		dprintfloat(val);
		dprint(" ");
		val = floor(p.origin_y);
		dprintfloat(val);
		dprint(" ");
		val = floor(p.origin_z);
		dprintfloat(val);
		dprint("\"\n");
		if (p.angles_y != 0)
		{
			dprint("\"");
			dprint("angle");
			dprint("\"");
			dprint(" \"");
			dprintfloat(p.angles_y);
			dprint("\"\n");
		}
		if (p.spawnflags != 0)
		{
			dprint("\"");
			dprint("spawnflags");
			dprint("\"");
			dprint(" \"");
			dprintfloat(p.spawnflags);
			dprint("\"\n");
		}
		dprint("}\n");
	}
};

//=============================================================
//=============================================================
void() PrintEntityListBSP =
{	
local entity p;

	dprint("// ================================\n");


	dprint("// begin extra BSP entity list for ");
	dprint(mapname);
	dprint("\n");
	dprint("// ================================\n");

	p = findradius(self.origin, 99999999999);
	while (p != world)
	{
		if (p.dynamically_created)
			PrintEntityForBSP(p);
		p = p.chain;
	}
	p = find(world, classname, "info_player_team1");
	while (p != world)
	{
		if (p.dynamically_created)
			PrintEntityForBSP(p);
		p = find(p, classname, "info_player_team1");
	}
	p = find(world, classname, "info_player_team2");
	while (p != world)
	{
	if (p.dynamically_created)
			PrintEntityForBSP(p);

		p = find(p, classname, "info_player_team2");
	}

	dprint("// ================================\n");
	dprint("// end extra BSP entity list for ");
	dprint(mapname);
	dprint("\n");
	dprint("// ================================\n");
};


//=============================================================
//=============================================================
void() PrintEntityListCode =
{	
local entity p;

	dprint("// ================================\n");
	dprint("// begin code entity list for ");
	dprint(mapname);
	dprint("\n");
	dprint("// ================================\n");

	p = findradius(self.origin, 99999999999);
	while (p != world)
	{
		if (p.dynamically_created)
			PrintEntityForCode(p);
		p = p.chain;
	}
	p = find(world, classname, "info_player_team1");
	while (p != world)
	{
//		if (p.dynamically_created)
			PrintEntityForCode(p);
		p = find(p, classname, "info_player_team1");
	}
	p = find(world, classname, "info_player_team2");
	while (p != world)
	{
//	if (p.dynamically_created)
			PrintEntityForCode(p);

		p = find(p, classname, "info_player_team2");
	}

	dprint("// ================================\n");
	dprint("// end extra code entity list for ");
	dprint(mapname);
	dprint("\n");
	dprint("// ================================\n");
};
// CTFBOT EXTRAS ]]]

