
.float laststattime;		// time of last status update
.float motd_count;
//.float status_bar;		// status bar type CTFBOT
.float statstate;			// is the status bar on?

float teamscr1;			// team 1's teamscr score
float teamscr2;			// team 2's teamscr score
float lastteamscrtime;		// last time we calculated it

float TEAMSCRTIME = 1;
float PLAYERSTATTIME = 1.75;

//TONY
//SET UP STATUS BAR AND STUFFCMDS
void() preMOTD =
{
//TONY
//STUFFCMDS
	stuffcmd(self,"alias exit quit\n");
//LOAD PLAYER SETTINGS
//statbar
//bestwep
	stuffcmd(self,"exec player.cfg\n");
};

void() MOTD =
{
	if (self.classname != "player")
		return;

//TONY
	if(self.motd_count == 2)
	{
		preMOTD();
	}
//0123456789.
//Æ
//2.1
//Æ
//2.2 beta
//Æ beta
//3.0 beta 1
//Æ beta 
	if (self.motd_count < 4)
	{
		self.motd_count = self.motd_count + 1;
		if (gamestart)
		{
//VERSION
			centerprint(self, "√‘∆¬ÔÙ´ Æ beta \n\nBased on √‘∆ ¬ÔÙ ±Æ¥\n\n√¡–‘’“≈ ‘»≈ ∆Ã¡«!\n\nChoose an exit..."); //red
//                      centerprint(self, "Welcome!\nRunning ThreeWave CTF 4.21\n\n√¡–‘’“≈ ‘»≈ ∆Ã¡«!\n\nChoose an exit...\n"); //red
			return;
		}
		if (self.team == TEAM_COLOR1)
//VERSION
			centerprint(self, "√‘∆¬ÔÙ´ Æ beta \n\nBased on √‘∆ ¬ÔÙ ±Æ¥\n\n√¡–‘’“≈ ‘»≈ ∆Ã¡«!\n\nYou are “≈ƒ team\n"); //red
//                      centerprint(self, "Welcome!\nRunning ThreeWave CTF 4.21\n\n√¡–‘’“≈ ‘»≈ ∆Ã¡«!\n\nYou are “≈ƒ team\n"); //red
		else
//VERSION
			centerprint(self, "√‘∆¬ÔÙ´ Æ beta \n\nBased on √‘∆ ¬ÔÙ ±Æ¥\n\n√¡–‘’“≈ ‘»≈ ∆Ã¡«!\n\nYou are ¬Ã’≈ team\n"); //red
//                      centerprint(self, "Welcome!\nRunning Threewave CTF 4.21\n\n√¡–‘’“≈ ‘»≈ ∆Ã¡«!\n\nYou are ¬Ã’≈ team"); //blue
		return;
	}
//	sprint(self, "Impulse 70 to turn off status bar\n");
//	sprint(self, "Impulse 71 through 81 to set status bar resolution\n");
//	sprint(self, "71:200 72:240 73:300 74:350 75:384 76:400 77:480 78:600 79:768 81:1024\n");

//VERSION
	sprint(self, "\n              √‘∆¬ÔÙ´ Æ beta \n");
	sprint(self, "      http://captured.com/ctfbot/\n");
	sprint(self, "   CTF Bot 1.4 by Drew 'bz' Davidson\n");
	sprint(self, "  further enhanced by Stefan Hendriks\n");
	sprint(self, "  see \n");

	if (map_has_waypoints)
		sprint(self, "   LOADING waypoints for ");
	else
		sprint(self, "   NO waypoints for ");
	sprint(self, mapname);
	sprint(self, "\n");
	self.motd_count = -1;
};

void() MOTD_ChooseTeam =
{
	if (self.classname != "player")
		return;

//TONY
	if(self.motd_count == 2)
	{
		preMOTD();
	}

	if (self.motd_count < 6)
	{
		self.motd_count = self.motd_count + 1;
//VERSION
		centerprint(self, "√‘∆¬ÔÙ´ Æ beta \n\nBased on √‘∆ ¬ÔÙ ±Æ¥\n\n√¡–‘’“≈ ‘»≈ ∆Ã¡«!\n\nPress 1 for “≈ƒ team\nPress 2 for ¬Ã’≈ team\nOr Press Jump for automatic team\n");
		return;
	}
	self.motd_count = -1;
};


/*
==================================
PrintCTFScore

from EXPERT

Announce the CTF team score: the number of captures
each team has made.
==================================
*/
void() PrintCTFScore =
{
	local string s;

	bprint("Team Score: Red Team: ");
	s = ftos(teamscr1);
	bprint(s);
	bprint(" Blue Team: ");
	s = ftos(teamscr2);
	bprint(s);
	bprint("\n");
};

void(entity dude) PrintCTFScoreOne =
{
	local string s;

	sprint(dude, "Team Score: Red Team: ");
	s = ftos(teamscr1);
	sprint(dude, s);
	sprint(dude, " Blue Team: ");
	s = ftos(teamscr2);
	sprint(dude, s);
	sprint(dude, "\n");
};


void() TeamCaptureCheckUpdate =
{
	local entity p;

	if (gamestart)
		return; // handled by vote exit
	if (lastteamscrtime > time)
		return;

	lastteamscrtime = time + TEAMSCRTIME;

	// count up teamscr
	teamscr1 = teamscr2 = 0;
//TONY
//TEMP1
	if(temp1 & TEMP1_FRAGASCAPTURE)
	{
		teamscr1 = captures_red;
		teamscr2 = captures_blue;
	}
	else
	{
		p = find(world, classname, "player");
		while (p != world) {
			if (p.lastteam == TEAM_COLOR1)
				teamscr1 = teamscr1 + p.frags;
			else if (p.lastteam == TEAM_COLOR2)
				teamscr2 = teamscr2 + p.frags;
		//	p = find(p, classname, "player");
//TONY
//FIND BOTS TOO
			p = FindNextPlayerOrBot(p); 
		}
	}
};

void() TeamCaptureResetUpdate =
{
	lastteamscrtime = 0;
	TeamCaptureCheckUpdate();
};

void() TeamEndScore = 
{
	local string s;

	if (gamestart)
		return;
//TONY
	local string end;
	if(temp1 & TEMP1_FRAGASCAPTURE)
		end = " captures";
	else
		end = " points";

		
	// CTFBOT [[[
	level_over_time = time;

	// CTFBOT EXTRAS print detailed scores first, so the total appears as a summary 
	DetailedScoresBroadcast();		// CTFBOT EXTRAS  

	ToggleAllConsoles();		 // CTFBOT EXTRAS
	// CTFBOT ]]]

	lastteamscrtime = 0;
	TeamCaptureCheckUpdate();

	if (teamscr1 > teamscr2) {
		bprint("“≈ƒ team won with ");
		s = ftos(teamscr1);
		bprint(s);
		bprint(end);
		bprint("!\n");
		bprint("¬Ã’≈ team lost with ");
		s = ftos(teamscr2);
		bprint(s);
		bprint(end);
		bprint("!\n");
	} else if (teamscr1 < teamscr2) {
		bprint("¬Ã’≈ team won with ");
		s = ftos(teamscr2);
		bprint(s);
		bprint(end);
		bprint("!\n");
		bprint("“≈ƒ team lost with ");
		s = ftos(teamscr1);
		bprint(s);
		bprint(end);
		bprint("!\n");
	} else {
		bprint("¬Ã’≈ and “≈ƒ team tied\nwith ");
		s = ftos(teamscr1);
		bprint(s);
		bprint(end);
		bprint("!\n");
	}
};

string(entity who) RuneName =
{
	if (who.player_flag & ITEM_RUNE1_FLAG)
		return "\nEarth/Resistance   ";
	if (who.player_flag & ITEM_RUNE2_FLAG)
		return "\nBlack/Strength     ";
	if (who.player_flag & ITEM_RUNE3_FLAG)
		return "\nHell/Haste         ";
	if (who.player_flag & ITEM_RUNE4_FLAG)
		return "\nElder/Regeneration ";
	return     "\n                   ";
};


string(entity who) TeamSetStatRes =
{
	if (who.statstate > 7) // 768 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 7) // 600 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 6) // 480 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 5) // 400
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 4) // 384 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 3) // 350 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 2) // 300 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 1) // 240 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	// 200 
	return "\n\n\n\n\n\n\n\n\n\n\n\n";
};

string(entity who) TeamSetStatRes2 =
{
	if (who.statstate > 7) // 768 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 7) // 600 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 6) // 480 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 5) // 400
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 4) // 384 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 3) // 350 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 2) // 300 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 1) // 240 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	// 200 
	return "\n\n\n\n\n\n\n\n\n\n\n";
};

void() TeamCapturePlayerUpdate =
{
	local string n;
	local string t;
	local string res;

	if (self.classname != "player")		// CTFBOT
		return;							// CTFBOT

	if (self.laststattime > time)
		return;

	TeamCaptureCheckUpdate();

	self.laststattime = time + PLAYERSTATTIME;

//tony
//change to -1
	if (self.motd_count != -1) {
		if (self.observer)
			MOTD_ChooseTeam();
		else
			MOTD();
		return;
	}

	if (self.statstate < 0)
		return;

	res = TeamSetStatRes(self);

	if (gamestart) {
		if (vote_leader == world)
			centerprint2(self, res, "                    Choose an exit...");
		else {
			n = ftos(voteexit_time - time);
			centerprint5(self, res, vote_leader.message,
				" leads\n", n, " seconds until exit");
		}
		return;
	}

	// CTFBOT [[[
	//.1234567890123456789012345678901234567
	// Res.R.B.             Capture The Flag
	// Res.R.B.                     BLUE 999

	local entity e;
	local string s1, s2, s3;

		if (self.player_flag & ITEM_RUNE1_FLAG)
			s1 = "ResÖ";
		else if (self.player_flag & ITEM_RUNE2_FLAG)
			s1 = "StrÖ";
		else if (self.player_flag & ITEM_RUNE3_FLAG)
			s1 = "HstÖ";
		else if (self.player_flag & ITEM_RUNE4_FLAG)
			s1 = "RegÖ";
		else
			s1 = "   Ö";
		
		e = find(world, classname, "item_flag_team1");
		if (e.cnt == FLAG_AT_BASE)
			s2 = " Ö";
		else if (e.cnt == FLAG_CARRIED)
			s2 = "RÖ";
		else
			s2 = "“Ö";

		e = find(world, classname, "item_flag_team2");
		if (e.cnt == FLAG_AT_BASE)
			s3 = " Ö";
		else if (e.cnt == FLAG_CARRIED)
			s3 = "BÖ";
		else
			s3 = "¬Ö";
			
		if (teamscr1 == 0 && teamscr2 == 0) {
                        //centerprint5(self, "\n\n\n\n\n\n\n\n\n\n\n\n", s1, s2, s3, "                               ");          // CTFBOT
                        centerprint5(self, res, s1, s2, s3, "                               ");          // [RRM] CTFBOT
			return;
		}
		
		if ((time < (last_flag_capture + 6)) && (last_flag_capture != 0))
		{
			if (last_capture_team == self.team)
			{
				if (teamscr1 > teamscr2) {
					t = "We Captured!    RED ";
					n = ftos(teamscr1 - teamscr2);
				} else if (teamscr1 < teamscr2) {
					t = "We Captured!   BLUE ";
					n = ftos(teamscr2 - teamscr1);
				} else {
					t = "We Captured!   TIED ";
					n = "";
				}
			}
			else
			{
				if (teamscr1 > teamscr2) {
					t = "They Captured!  RED ";
					n = ftos(teamscr1 - teamscr2);
				} else if (teamscr1 < teamscr2) {
					t = "They Captured! BLUE ";
					n = ftos(teamscr2 - teamscr1);
				} else {
					t = "They Captured! TIED ";
					n = "";
				}
			}
		}
		else
		{
			if (teamscr1 > teamscr2) {
				t = "                RED ";
				n = ftos(teamscr1 - teamscr2);
			} else if (teamscr1 < teamscr2) {
				t = "               BLUE ";
				n = ftos(teamscr2 - teamscr1);
			} else {
				t = "               TIED ";
				n = "";
			}
		}
                //centerprint7(self, "\n\n\n\n\n\n\n\n\n\n\n\n", s1, s2, s3, "        ", t, n);           // CTFBOT
                centerprint7(self, res, s1, s2, s3, "        ", t, n);           //  [RRM] CTFBOT
};

void(entity who, string s) TeamPlayerUpdate =
{
	local string n;
	local string t;
	local string res;

	if (who.classname != "player")			// CTFBOT
		return;								// CTFBOT

	TeamCaptureCheckUpdate();
	who.laststattime = time + PLAYERSTATTIME;

//        res = TeamSetStatRes(self);  // [RRM]
//TONY
        res = TeamSetStatRes(who);  // [RRM]

	if (self.statstate < 0){
	            //centerprint2(who, "\n\n\n\n\n\n\n\n\n\n\n", s);
                centerprint2(who, res, s);  // [RRM]
		return;
	}

	res = TeamSetStatRes2(who);

	t = "\n                   ";
		
	if (teamscr1 == 0 && teamscr2 == 0) {
		centerprint4(who, res, s, t, "               ");		// CTFBOT removed
	} else if (teamscr1 > teamscr2) {
		n = ftos(teamscr1 - teamscr2);
		centerprint5(who, res, s, t, "           RED ", n);
	} else if (teamscr1 < teamscr2) {
		n = ftos(teamscr2 - teamscr1);
		centerprint5(who, res, s, t, "          BLUE ", n);
	} else
		centerprint4(who, res, s, t, "          TIED");
};

void(entity who, string s1, string s2) TeamPlayerUpdate2 =
{
	local string n;
	local string t;
	local string res;

	if (who.classname != "player")			// CTFBOT
		return;								// CTFBOT

	TeamCaptureCheckUpdate();
	who.laststattime = time + PLAYERSTATTIME;

        res = TeamSetStatRes(who);  // [RRM]

	if (self.statstate < 0){
                //centerprint3(who, "\n\n\n\n\n\n\n\n\n\n\n", s1, s2);
                centerprint3(who, res, s1, s2);  // [RRM]
		return;
	}

	res = TeamSetStatRes2(who);

	t = "\n                   ";
	
	if (teamscr1 == 0 && teamscr2 == 0) {
		centerprint5(who, res, s1, s2, t, "               ");	// CTFBOT removed
		return;
	} else if (teamscr1 > teamscr2) {
		n = ftos(teamscr1 - teamscr2);
		centerprint6(who, res, s1, s2, t, "          RED ", n);
	} else if (teamscr1 < teamscr2) {
		n = ftos(teamscr2 - teamscr1);
		centerprint6(who, res, s1, s2, t, "          BLUE ", n);
	} else {
		centerprint5(who, res, s1, s2, t, "          TIED");
		return;
	}
};
