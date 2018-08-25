//botname.qc
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
float (string st) BotNameInUse =
{
local entity bot;

//TONY
//if it's "Player", just let it go
	if (st == "Player")
		return FALSE;

	bot = find(world, classname, "bot");
	while (bot != world) 
	{
		if (bot.altname == st)
			return TRUE;
		bot = find(bot, classname, "bot");
	}
	return FALSE;
};

//=============================================================
//=============================================================
void (entity bot) RandomNormalName =
{
	local float r;
	local float counter;
	local string st;
	local string talkst;
	local float botsex;
	
	bot.altname = "Player";
	bot.talkname = "–Ï·yÂr";
	bot.sex = 1;
	
	do
	{
		counter = counter + 1;
		r = random();

		if (r < 0.01) {st = "Holesinswiss"; talkst = "»ÔÏÂÛÈÓÛ˜ÈÛÛ"; botsex = 1;}
		else if (r < 0.02) {st = "Spectre"; talkst = "”Â„ÙÚÂ"; botsex = 1;}
		else if (r < 0.03) {st = "Slider"; talkst = "”ÏÈ‰ÂÚ"; botsex = 1;}
		else if (r < 0.04) {st = "Mainframe"; talkst = "Õ·ÈÓÊÚ·ÌÂ"; botsex = 1;}
		else if (r < 0.05) {st = "Dark Queen"; talkst = "ƒ·ÚÎ†—ıÂÂÓ"; botsex = 2;}
		else if (r < 0.06) {st = "MarshalN"; talkst = "Õ·ÚÛË·ÏŒ"; botsex = 2;}
		else if (r < 0.07) {st = "Slasher"; talkst = "”Ï·ÛËÂÚ"; botsex = 1;}
		else if (r < 0.08) {st = "CORRISION"; talkst = "√œ““…”…œŒ"; botsex = 1;}
		else if (r < 0.09) {st = "Wench"; talkst = "◊ÂÓ„Ë"; botsex = 2;}
		else if (r < 0.10) {st = "[+[P.A.I.N]+]"; talkst = "€´€–Æ¡Æ…ÆŒ›´›"; botsex = 2;}
		else if (r < 0.11) {st = "SCraGG"; talkst = "”√Ú·««"; botsex = 1;}
		else if (r < 0.12) {st = "NiOXiN"; talkst = "ŒÈœÿÈŒ"; botsex = 1;}
		else if (r < 0.13) {st = "JokeR"; talkst = " ÔÎÂ“"; botsex = 1;}
		else if (r < 0.14) {st = "Critter"; talkst = "√ÚÈÙÙÂÚ"; botsex = 1;}
		else if (r < 0.15) {st = "Boccoccio"; talkst = "¬Ô„„Ô„„ÈÔ"; botsex = 2;}
		else if (r < 0.16) {st = "Xero.G"; talkst = "ÿÂÚÔÆ«"; botsex = 1;}
		else if (r < 0.17) {st = "Tyra"; talkst = "‘˘Ú·"; botsex = 2;}
		else if (r < 0.18) {st = "-mE*LoC0!-"; talkst = "≠Ì≈™ÃÔ√∞°≠"; botsex = 1;}
		else if (r < 0.19) {st = "-=*GorchFawr*=-"; talkst = "≠Ω™«ÔÚ„Ë∆·˜Ú™Ω≠"; botsex = 1;}
		else if (r < 0.20) {st = "ChiLLie"; talkst = "√ËÈÃÃÈÂ"; botsex = 2;}
		else if (r < 0.21) {st = "Moebius"; talkst = "ÕÔÂ‚ÈıÛ"; botsex = 1;}
		else if (r < 0.22) {st = "Andrea"; talkst = "¡Ó‰ÚÂ·"; botsex = 2;}
		else if (r < 0.23) {st = "Liquid!!!"; talkst = "ÃÈÒıÈ‰°°°"; botsex = 2;}
		else if (r < 0.24) {st = "Kendra"; talkst = "ÀÂÓ‰Ú·"; botsex = 2;}
		else if (r < 0.25) {st = "KillCreek"; talkst = "ÀÈÏÏ√ÚÂÂÎ"; botsex = 2;}
		else if (r < 0.26) {st = "Guns"; talkst = "«ıÓÛ"; botsex = 1;}
		else if (r < 0.27) {st = "CleptoTronic"; talkst = "√ÏÂÙÔ‘ÚÔÓÈ„"; botsex = 1;}
		else if (r < 0.28) {st = "Takhisis"; talkst = "‘·ÎËÈÛÈÛ"; botsex = 2;}
		else if (r < 0.29) {st = "Mob"; talkst = "ÕÔ‚"; botsex = 1;}
		else if (r < 0.30) {st = "Yogi_Bear"; talkst = "ŸÔÁÈﬂ¬Â·Ú"; botsex = 1;}
		else if (r < 0.31) {st = "JEzTER"; talkst = " ≈˙‘≈“"; botsex = 1;}
		else if (r < 0.32) {st = "Krylon"; talkst = "ÀÚ˘ÏÔÓ"; botsex = 2;}
		else if (r < 0.33) {st = "unnamed"; talkst = "ıÓÓ·ÌÂ‰"; botsex = 1;}
		else if (r < 0.34) {st = "Lythium Lad"; talkst = "Ã˘ÙËÈıÌ†Ã·‰"; botsex = 1;}
		else if (r < 0.35) {st = "alf"; talkst = "·ÏÊ"; botsex = 1;}
		else if (r < 0.36) {st = "Wino"; talkst = "◊ÈÓÔ"; botsex = 1;}
		else if (r < 0.37) {st = "Zed"; talkst = "⁄Â‰"; botsex = 1;}
		else if (r < 0.38) {st = "Prick"; talkst = "–ÚÈ„Î"; botsex = 1;}
		else if (r < 0.39) {st = "KEZ"; talkst = "À≈⁄"; botsex = 1;}
		else if (r < 0.40) {st = "Panther"; talkst = "–·ÓÙËÂÚ"; botsex = 1;}
		else if (r < 0.41) {st = "TUFF GUY"; talkst = "‘’∆∆†«’Ÿ"; botsex = 1;}
		else if (r < 0.42) {st = "Birdman"; talkst = "¬ÈÚ‰Ì·Ó"; botsex = 1;}
		else if (r < 0.43) {st = "WarDog"; talkst = "◊·ÚƒÔÁ"; botsex = 1;}
		else if (r < 0.44) {st = "Typhoon"; talkst = "‘˘ËÔÔÓ"; botsex = 2;}
		else if (r < 0.45) {st = "Ariakas"; talkst = "¡ÚÈ·Î·Û"; botsex = 1;}
		else if (r < 0.46) {st = "P0intdexter"; talkst = "–∞ÈÓÙ‰Â¯ÙÂÚ"; botsex = 1;}
		else if (r < 0.47) {st = "The Bitch"; talkst = "‘ËÂ ¬ÈÙ„Ë"; botsex = 2;}
		else if (r < 0.48) {st = "Andr0g3N"; talkst = "¡Ó‰Ú∞Á≥Œ"; botsex = 1;}
		else if (r < 0.49) {st = "-=*FRAGmE*=-"; talkst = "≠Ω™∆“¡«Ì≈™Ω≠"; botsex = 1;}
		else if (r < 0.50) {st = "DirK DiggleR"; talkst = "ƒÈÚÀ†ƒÈÁÁÏÂ“"; botsex = 1;}
		else if (r < 0.51) {st = "gobills"; talkst = "ÁÔ‚ÈÏÏÛ"; botsex = 1;}
		else if (r < 0.52) {st = "narcogen"; talkst = "Ó·Ú„ÔÁÂÓ"; botsex = 1;}
		else if (r < 0.53) {st = "RUDE Dog"; talkst = "“’ƒ≈†ƒÔÁ"; botsex = 1;}
		else if (r < 0.54) {st = "G==A==W===D"; talkst = "«ΩΩ¡ΩΩ◊ΩΩΩƒ"; botsex = 2;}
		else if (r < 0.55) {st = "corpse grinder"; talkst = "„ÔÚÛÂ†ÁÚÈÓ‰ÂÚ"; botsex = 1;}
		else if (r < 0.56) {st = "Meat Head"; talkst = "ÕÂ·Ù†»Â·‰"; botsex = 1;}
		else if (r < 0.57) {st = "sodomizer"; talkst = "ÛÔ‰ÔÌÈ˙ÂÚ"; botsex = 1;}
		else if (r < 0.58) {st = "illegal alien"; talkst = "ÈÏÏÂÁ·Ï†·ÏÈÂÓ"; botsex = 1;}
		else if (r < 0.59) {st = "Alpha Jizz Monkey"; talkst = "¡ÏË·† È˙˙†ÕÔÓÎÂ˘"; botsex = 1;}
		else if (r < 0.60) {st = "GiGetto"; talkst = "«È«ÂÙÙÔ"; botsex = 2;}
		else if (r < 0.61) {st = "bacchus"; talkst = "‚·„„ËıÛ"; botsex = 1;}
		else if (r < 0.62) {st = "Mother's Finest"; talkst = "ÕÔÙËÂÚßÛ†∆ÈÓÂÛÙ"; botsex = 1;}
		else if (r < 0.63) {st = "RU486"; talkst = "“’¥∏∂"; botsex = 2;}
		else if (r < 0.64) {st = "Mixie"; talkst = "®≈Æ√œÃ…©"; botsex = 2;}
		else if (r < 0.65) {st = "D00mweav3r"; talkst = "ƒ∞∞Ì˜Â·ˆ≥Ú"; botsex = 2;}
		else if (r < 0.66) {st = "Chunga"; talkst = "√ËıÓÁ·"; botsex = 1;}
		else if (r < 0.67) {st = "Mtn-Dew"; talkst = "ÕÙÓ≠ƒÂ˜"; botsex = 1;}
		else if (r < 0.68) {st = "p1mp"; talkst = "±Ì"; botsex = 1;}
		else if (r < 0.69) {st = "Damage"; talkst = "ƒ·Ì·ÁÂ"; botsex = 1;}
		else if (r < 0.70) {st = "Gwen"; talkst = "«˜ÂÓ"; botsex = 2;}
		else if (r < 0.71) {st = "Slippery People"; talkst = "”ÏÈÂÚ˘†–ÂÔÏÂ"; botsex = 1;}
		else if (r < 0.72) {st = "Reverend ZOOT"; talkst = "“ÂˆÂÚÂÓ‰†⁄œœ‘"; botsex = 1;}
		else if (r < 0.73) {st = "bErZeRk"; talkst = "‚≈Ú⁄Â“Î"; botsex = 1;}
		else if (r < 0.74) {st = "Ultimate Ken"; talkst = "’ÏÙÈÌ·ÙÂ†ÀÂÓ"; botsex = 1;}
		else if (r < 0.75) {st = "Snortwad"; talkst = "”ÓÔÚÙ˜·‰"; botsex = 1;}
		else if (r < 0.76) {st = "Troy McClure"; talkst = "‘ÚÔ˘ﬂÕ„√ÏıÚÂ"; botsex = 1;}
		else if (r < 0.77) {st = "Jimmy the Geek"; talkst = " ÈÌÌ˘†ÙËÂ†«ÂÂÎ"; botsex = 1;}
		else if (r < 0.78) {st = "Boobsie"; talkst = "¬ÔÔ‚ÛÈÂ"; botsex = 2;}
		else if (r < 0.79) {st = "Solotribe"; talkst = "”ÔÏÔÙÚÈ‚Â"; botsex = 1;}
		else if (r < 0.80) {st = "A Quake Nazi"; talkst = "¡†—ı·ÎÂ†Œ·˙È"; botsex = 1;}
		else if (r < 0.81) {st = "fragbait"; talkst = "ÊÚ·Á‚·ÈÙ"; botsex = 1;}
		else if (r < 0.82) {st = "BARNEY"; talkst = "¬¡“Œ≈Ÿ"; botsex = 1;}
		else if (r < 0.83) {st = "Hydr0"; talkst = "»˘‰Ú∞"; botsex = 1;}
		else if (r < 0.84) {st = "Hippie"; talkst = "»ÈÈÂ"; botsex = 1;}
		else if (r < 0.85) {st = "Beowulf"; talkst = "¬ÂÔ˜ıÏÊ"; botsex = 1;}
		else if (r < 0.86) {st = "Dark Wind"; talkst = "ƒ·ÚÎ†◊ÈÓ‰"; botsex = 2;}
		else if (r < 0.87) {st = "Garjen"; talkst = "«·ÚÍÂÓ"; botsex = 2;}
		else if (r < 0.88) {st = "BEEFCAKE!!!"; talkst = "¬≈≈∆√¡À≈°°°"; botsex = 1;}
		else if (r < 0.89) {st = "-That Bastard-"; talkst = "≠‘Ë·Ù†¬·ÛÙ·Ú‰≠"; botsex = 1;}
		else if (r < 0.90) {st = "HIGHLANDER"; talkst = "»…«»Ã¡Œƒ≈“"; botsex = 1;}
		else if (r < 0.91) {st = "FlasH"; talkst = "∆Ï·Û»"; botsex = 1;}
		else if (r < 0.92) {st = "tsunami"; talkst = "ÙÛıÓ·ÌÈ"; botsex = 1;}
		else if (r < 0.93) {st = "SHaD0W"; talkst = "”»·ƒ∞◊"; botsex = 1;}
		else if (r < 0.94) {st = "Cheese"; talkst = "√ËÂÂÛÂ"; botsex = 1;}
		else if (r < 0.95) {st = "Colonel Commode"; talkst = "√ÔÏÔÓÂÏ†√ÔÌÌÔ‰Â"; botsex = 1;}
		else if (r < 0.96) {st = "Santa Claws"; talkst = "”·ÓÙ·†√Ï·˜Û"; botsex = 1;}
		else if (r < 0.97) {st = "Obyte"; talkst = "œ‚˘ÙÂ"; botsex = 1;}
		else if (r < 0.98) {st = "<.RUGER.>"; talkst = "ºÆ“’«≈“Ææ"; botsex = 1;}
		else if (r < 0.99) {st = "CamperHunter"; talkst = "√·ÌÂÚ»ıÓÙÂÚ"; botsex = 1;}

		else {st = "Player"; talkst = "–Ï·yÂr"; botsex = 1;}
	}
	while (BotNameInUse(st) && (counter < 150));
	
	bot.altname = st;
	bot.talkname = talkst;
	bot.sex = botsex;
};


