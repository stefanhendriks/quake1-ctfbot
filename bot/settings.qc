/*
================
TeamPrintSettings

Print out current teamplay options
================
*/

void() TeamPrintSettings =
{
	sprint(self,"The following Teamplay options are set:\n");
	
	if(!teamplay) 
	{
		sprint(self, "None\n");
		return;
	}
	
	if(1 == teamplay)
	{
		sprint(self, "ID's original teamplay 1\n");
		return;
	}
	
	if(teamplay & TEAM_HEALTH_PROTECT)
		sprint(self, "Health-Protect, ");
	
	if(teamplay & TEAM_ARMOR_PROTECT)
		sprint(self, "Armor-Protect, ");
		
	if(teamplay & TEAM_ATTACKER_DAMAGE)
		sprint(self, "Mirror-Damage, ");
		
	if(teamplay & TEAM_FRAG_PENALTY)
		sprint(self, "Frag-Penalty, ");
		
	if(teamplay & TEAM_DEATH_PENALTY)
		sprint(self, "Death-Penalty, ");
				
	if(teamplay & TEAM_STATIC_TEAMS)
		sprint(self, "Static-Teams, ");
		
	if(teamplay & TEAM_DROP_ITEMS)
		sprint(self, "Drop-Items (Backpack Impulse 20, Weapon Impulse 21), ");
		
	if(teamplay & TEAM_CAPTURE_CUSTOM)				// CTFBOT EXTRAS
		sprint(self, "Custom-Capture, ");	// CTFBOT EXTRAS

	if(teamplay & TEAM_CAPTURE_SELECT_TEAM)			// CTFBOT EXTRAS
		sprint(self, "Select-Team, ");		// CTFBOT EXTRAS

	if(teamplay & TEAM_CAPTURE_CTFBOT_ADMIN)			// CTFBOT EXTRAS
		sprint(self, "Impulse-Freedom, ");		// CTFBOT EXTRAS

//	if(teamplay & TEAM_CAPTURE_AUTO_EVEN_TEAMS)			// CTFBOT EXTRAS
//		sprint(self, "Auto-Teams, ");		// CTFBOT EXTRAS
	if(teamplay & TEAM_NOSELFHURT)
		sprint(self, "No-Self-Hurt, ");

	if(teamplay & TEAM_NO_RUNE_DROP)			// CTFBOT EXTRAS
		sprint(self, "No-Rune-Dropping, ");		// CTFBOT EXTRAS

	if(teamplay & TEAM_NORSE_MOVEMENT)
		sprint(self, "Norse-Movement, ");
	sprint(self,"\n");
};

void() Temp1PrintSettings =
{
	sprint(self,"The following Temp1 options are set:\n");
	if(!cvar("temp1"))
	{
		sprint(self,"None\n");
		return;
	}
	if(cvar("temp1") & TEMP1_MULTI)
		sprint(self,"MultiWeapons, ");
	if(cvar("temp1") & TEMP1_YCAM)
		sprint(self,"YCam, ");
	if(cvar("temp1") & TEMP1_FRAGASCAPTURE)
		sprint(self,"Capture-Limit, ");
//tony
//took this out
//12-22-98
//	if(cvar("temp1") & TEMP1_USEGLBOTMODEL)
//		sprint(self,"GL-Skins, ");

	if(cvar("temp1") & TEMP1_USEDEFWAYS)
		sprint(self,"Defensive-Waypoints, ");
	if(cvar("temp1") & TEMP1_AUTOLEVEL)
		sprint(self,"Auto-Level, ");
	if(cvar("temp1") & TEMP1_BOTAUTOPLAN)
		sprint(self,"Auto-Plan, ");
	if(cvar("temp1") & TEMP1_HALFLIGHT)
		sprint(self,"Lightning-Gun-Half-Damage, ");
	if(cvar("temp1") & TEMP1_NOMESS)
		sprint(self,"No-Messages, ");
	if(cvar("temp1") & TEMP1_SUPPORT_PLAYER2)
		sprint(self,"Female/Player2-Model-Support, ");
	if(cvar("temp1") & TEMP1_SUPPORT_PLAYER3)
		sprint(self,"Player3-Model-Support, ");
	if(cvar("temp1") & TEMP1_SUPPORT_PLAYER4)
		sprint(self,"Player4-Model-Support, ");
	if(cvar("temp1") & TEMP1_AUTO_EVEN_TEAMS)
		sprint(self,"Auto-Even-Teams, ");
	sprint(self,"\n");
};

//==========================================================
//==========================================================
void() SVAimPrintSettings =
{
	local float svaim, bskill, Blueteamsize, Redteamsize,
		varied;

	sprint(self,"The following SV_Aim options are set:\n");

	if(temp1 & TEMP1_AUTO_EVEN_TEAMS)	
	{
		svaim = cvar("sv_aim");
		bskill = 0;

		if (svaim & 64)
		{
			svaim = svaim - 64;
			varied = 1;
		}

		Blueteamsize = svaim /128;
		Blueteamsize = floor(Blueteamsize);
		svaim = svaim - (Blueteamsize * 128);

		Redteamsize = svaim / 4;
		Redteamsize = floor(Redteamsize);
		svaim = svaim - (Redteamsize * 4);
		
		sprint(self, "    Red Team Size: ");
		sprintfloat(self, Redteamsize);
		sprint(self, "\n");
		sprint(self, "    Blue Team Size: ");
		sprintfloat(self, Blueteamsize);
		sprint(self, "\n");

		bskill = svaim;

		sprint(self, "    Bot Skill: ");
		sprintfloat(self, bskill);

		if(varied)
		{
			sprint(self, " (varied)");
		}
		sprint(self, "\n");

	}
	else
		sprint(self, "Auto even teams is off\n");
};

void() DeathPrintSettings =
{
	sprint(self,"The following Deathmatch options are set:\n");
	
	if(!deathmatch) 
	{
		sprint(self, "None\n");
		return;
	}
	
	if(DM_REGULAR == deathmatch)
	{
		sprint(self, "ID's original deathmatch 1\n");
		return;
	}
	if(deathmatch & DM_WEAPONS_STAY)
		sprint(self,"Weapons-Stay, ");
	if(deathmatch & DM_NO_HEALTH)
		sprint(self,"No-Health, ");
	if(deathmatch & DM_NO_ARMOR)
		sprint(self,"No-Armor, ");
	if(deathmatch & DM_NO_ITEMS)
		sprint(self,"No-Items, ");
	if(deathmatch & DM_DROP_QUAD)
		sprint(self,"Drop-Quad, ");
	if(deathmatch & DM_DROP_RING)
		sprint(self,"Drop-Ring, ");
	if(deathmatch & DM_NO_FALLING)
		sprint(self,"No-Fall-Damage, ");
	if(deathmatch & DM_INFINITE_AMMO)
		sprint(self,"Infinite-Ammo, ");
	if(deathmatch & DM_FIXED_FOV)
		sprint(self,"Fixed-FOV, ");
	if(deathmatch & DM_SPAWN_RANDOM)
		sprint(self,"QW's-Random-Spawn, ");
	if(deathmatch & DM_START_SMALL)
		sprint(self,"Start-Small, ");
	if(deathmatch & DM_START_BIG)
		sprint(self,"Start-Big, ");
	if(deathmatch & DM_SECRET_DOOR)
		sprint(self,"Secret-Door's-stay-open, ");
	if(deathmatch & DM_NORUNES)
		sprint(self,"No-Runes, ");
	if(deathmatch & DM_FASTPLATS)
		sprint(self,"Fast-Doors-and-Plats, ");
	if(deathmatch & DM_NO_POWERUPS)
		sprint(self,"No-PowerUps, ");
	sprint(self,"\n");
};
