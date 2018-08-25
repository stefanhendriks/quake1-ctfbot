//tony.qc
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

.float best_wep;
.float ITbest_wep;
float TEAM_NORSE_MOVEMENT = 32768;
float TEAM_NOSELFHURT = 4096;
.string talkname; //when a bot talks


//moved this from client.qc
string nextmap;

//sex
//0 ??
//1 male
//2 female/player2.mdl
//3 player3.mdl
//4 player4.mdl

.float sex; 

void () RemoveAllBots;
void (vector org, float fteam) SpawnDefensiveWaypoint;
.float use_defensive_way;

float MAX_BOTS_TO_PRINT = 20;

float TEAM_PRINT_DELAY = 45;
float teamScorePrintTime;

float timer_flag;

float TEMP1_MULTI = 1;
float TEMP1_YCAM = 2;
float TEMP1_FRAGASCAPTURE = 4;
//tony
//took this out
//12-22-98
//float TEMP1_USEGLBOTMODEL = 8;
float TEMP1_USEDEFWAYS = 16;
float TEMP1_AUTOLEVEL = 32;
float TEMP1_LOADMOD = 64;
float TEMP1_BOTAUTOPLAN = 128;

float TEMP1_SUPPORT_PLAYER2 = 256;
float TEMP1_SUPPORT_PLAYER3 = 512;
float TEMP1_SUPPORT_PLAYER4 = 1024;

float TEMP1_AUTO_EVEN_TEAMS = 2048;		// CTFBOT always keep teams even
float TEMP1_PLAYER2SOUNDS = 4096;
float TEMP1_PLAYER3SOUNDS = 8192;
float TEMP1_PLAYER4SOUNDS = 16384;
float TEMP1_HALFLIGHT = 32768;
float TEMP1_NOMESS = 65536;

float captures_blue;
float captures_red;

//from client.qc
float	modelindex_eyes, modelindex_player;

float modelindex_player2;
float modelindex_player3;
float modelindex_player4;

float DM_REGULAR = 1;//x
float DM_WEAPONS_STAY = 2;//x
float DM_NO_HEALTH = 4;//x
float DM_NO_ARMOR = 8;//x
float DM_NO_ITEMS = 16;//x
float DM_DROP_QUAD = 32;//x ? set botwantsitem
float DM_DROP_RING = 64;//x ? set botwantsitem
float DM_NO_FALLING = 128;//x
float DM_INFINITE_AMMO = 256;//x
float DM_FIXED_FOV = 512;//x
float DM_SPAWN_RANDOM = 1024;//x
float DM_START_SMALL = 2048;//x
float DM_START_BIG = 4096;//x
float DM_SECRET_DOOR = 8192;//x
float DM_NORUNES = 16384;//x
float DM_FASTPLATS = 32768;//x
float DM_NO_POWERUPS = 65536;//x

//TONY
//multi player model support



void () set_player_main_index =
{
	if ((self.sex == 2) && (temp1 & TEMP1_SUPPORT_PLAYER2))
		self.modelindex = modelindex_player2;
	else if ((self.sex == 3) && (temp1 & TEMP1_SUPPORT_PLAYER3))
		self.modelindex = modelindex_player3;
	else if ((self.sex == 4) && (temp1 & TEMP1_SUPPORT_PLAYER4))
		self.modelindex = modelindex_player4;
	else
		self.modelindex = modelindex_player;

};


//void (entity e, float chan, string sSound, float attn, float number) PlayerSound =
//{
//	if (e.sex == 2)
//		sound (e, chan, 
//
//};


