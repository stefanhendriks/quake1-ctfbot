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
	bot.talkname = "���y�r";
	bot.sex = 1;
	
	do
	{
		counter = counter + 1;
		r = random();

		if (r < 0.01) {st = "Holesinswiss"; talkst = "������������"; botsex = 1;}
		else if (r < 0.02) {st = "Spectre"; talkst = "�������"; botsex = 1;}
		else if (r < 0.03) {st = "Slider"; talkst = "������"; botsex = 1;}
		else if (r < 0.04) {st = "Mainframe"; talkst = "���������"; botsex = 1;}
		else if (r < 0.05) {st = "Dark Queen"; talkst = "���������"; botsex = 2;}
		else if (r < 0.06) {st = "MarshalN"; talkst = "��������"; botsex = 2;}
		else if (r < 0.07) {st = "Slasher"; talkst = "�������"; botsex = 1;}
		else if (r < 0.08) {st = "CORRISION"; talkst = "���������"; botsex = 1;}
		else if (r < 0.09) {st = "Wench"; talkst = "�����"; botsex = 2;}
		else if (r < 0.10) {st = "[+[P.A.I.N]+]"; talkst = "۫�Ю��ɮ�ݫ�"; botsex = 2;}
		else if (r < 0.11) {st = "SCraGG"; talkst = "������"; botsex = 1;}
		else if (r < 0.12) {st = "NiOXiN"; talkst = "������"; botsex = 1;}
		else if (r < 0.13) {st = "JokeR"; talkst = "�����"; botsex = 1;}
		else if (r < 0.14) {st = "Critter"; talkst = "�������"; botsex = 1;}
		else if (r < 0.15) {st = "Boccoccio"; talkst = "���������"; botsex = 2;}
		else if (r < 0.16) {st = "Xero.G"; talkst = "�����"; botsex = 1;}
		else if (r < 0.17) {st = "Tyra"; talkst = "����"; botsex = 2;}
		else if (r < 0.18) {st = "-mE*LoC0!-"; talkst = "��Ū��ð��"; botsex = 1;}
		else if (r < 0.19) {st = "-=*GorchFawr*=-"; talkst = "�����������򪽭"; botsex = 1;}
		else if (r < 0.20) {st = "ChiLLie"; talkst = "�������"; botsex = 2;}
		else if (r < 0.21) {st = "Moebius"; talkst = "�������"; botsex = 1;}
		else if (r < 0.22) {st = "Andrea"; talkst = "������"; botsex = 2;}
		else if (r < 0.23) {st = "Liquid!!!"; talkst = "�����䡡�"; botsex = 2;}
		else if (r < 0.24) {st = "Kendra"; talkst = "������"; botsex = 2;}
		else if (r < 0.25) {st = "KillCreek"; talkst = "���������"; botsex = 2;}
		else if (r < 0.26) {st = "Guns"; talkst = "����"; botsex = 1;}
		else if (r < 0.27) {st = "CleptoTronic"; talkst = "������������"; botsex = 1;}
		else if (r < 0.28) {st = "Takhisis"; talkst = "��������"; botsex = 2;}
		else if (r < 0.29) {st = "Mob"; talkst = "���"; botsex = 1;}
		else if (r < 0.30) {st = "Yogi_Bear"; talkst = "���������"; botsex = 1;}
		else if (r < 0.31) {st = "JEzTER"; talkst = "������"; botsex = 1;}
		else if (r < 0.32) {st = "Krylon"; talkst = "������"; botsex = 2;}
		else if (r < 0.33) {st = "unnamed"; talkst = "�������"; botsex = 1;}
		else if (r < 0.34) {st = "Lythium Lad"; talkst = "�����������"; botsex = 1;}
		else if (r < 0.35) {st = "alf"; talkst = "���"; botsex = 1;}
		else if (r < 0.36) {st = "Wino"; talkst = "����"; botsex = 1;}
		else if (r < 0.37) {st = "Zed"; talkst = "���"; botsex = 1;}
		else if (r < 0.38) {st = "Prick"; talkst = "�����"; botsex = 1;}
		else if (r < 0.39) {st = "KEZ"; talkst = "���"; botsex = 1;}
		else if (r < 0.40) {st = "Panther"; talkst = "�������"; botsex = 1;}
		else if (r < 0.41) {st = "TUFF GUY"; talkst = "���Ơ���"; botsex = 1;}
		else if (r < 0.42) {st = "Birdman"; talkst = "�������"; botsex = 1;}
		else if (r < 0.43) {st = "WarDog"; talkst = "������"; botsex = 1;}
		else if (r < 0.44) {st = "Typhoon"; talkst = "�������"; botsex = 2;}
		else if (r < 0.45) {st = "Ariakas"; talkst = "�������"; botsex = 1;}
		else if (r < 0.46) {st = "P0intdexter"; talkst = "а���������"; botsex = 1;}
		else if (r < 0.47) {st = "The Bitch"; talkst = "��� �����"; botsex = 2;}
		else if (r < 0.48) {st = "Andr0g3N"; talkst = "������"; botsex = 1;}
		else if (r < 0.49) {st = "-=*FRAGmE*=-"; talkst = "��������Ū��"; botsex = 1;}
		else if (r < 0.50) {st = "DirK DiggleR"; talkst = "���ˠ�������"; botsex = 1;}
		else if (r < 0.51) {st = "gobills"; talkst = "�������"; botsex = 1;}
		else if (r < 0.52) {st = "narcogen"; talkst = "��������"; botsex = 1;}
		else if (r < 0.53) {st = "RUDE Dog"; talkst = "���Š���"; botsex = 1;}
		else if (r < 0.54) {st = "G==A==W===D"; talkst = "ǽ����׽���"; botsex = 2;}
		else if (r < 0.55) {st = "corpse grinder"; talkst = "�������������"; botsex = 1;}
		else if (r < 0.56) {st = "Meat Head"; talkst = "���������"; botsex = 1;}
		else if (r < 0.57) {st = "sodomizer"; talkst = "���������"; botsex = 1;}
		else if (r < 0.58) {st = "illegal alien"; talkst = "������������"; botsex = 1;}
		else if (r < 0.59) {st = "Alpha Jizz Monkey"; talkst = "����������������"; botsex = 1;}
		else if (r < 0.60) {st = "GiGetto"; talkst = "�������"; botsex = 2;}
		else if (r < 0.61) {st = "bacchus"; talkst = "�������"; botsex = 1;}
		else if (r < 0.62) {st = "Mother's Finest"; talkst = "�������������"; botsex = 1;}
		else if (r < 0.63) {st = "RU486"; talkst = "�մ��"; botsex = 2;}
		else if (r < 0.64) {st = "Mixie"; talkst = "�Ů���ɩ"; botsex = 2;}
		else if (r < 0.65) {st = "D00mweav3r"; talkst = "İ��������"; botsex = 2;}
		else if (r < 0.66) {st = "Chunga"; talkst = "������"; botsex = 1;}
		else if (r < 0.67) {st = "Mtn-Dew"; talkst = "������"; botsex = 1;}
		else if (r < 0.68) {st = "p1mp"; talkst = "���"; botsex = 1;}
		else if (r < 0.69) {st = "Damage"; talkst = "������"; botsex = 1;}
		else if (r < 0.70) {st = "Gwen"; talkst = "����"; botsex = 2;}
		else if (r < 0.71) {st = "Slippery People"; talkst = "���������������"; botsex = 1;}
		else if (r < 0.72) {st = "Reverend ZOOT"; talkst = "������������"; botsex = 1;}
		else if (r < 0.73) {st = "bErZeRk"; talkst = "�������"; botsex = 1;}
		else if (r < 0.74) {st = "Ultimate Ken"; talkst = "�����������"; botsex = 1;}
		else if (r < 0.75) {st = "Snortwad"; talkst = "��������"; botsex = 1;}
		else if (r < 0.76) {st = "Troy McClure"; talkst = "������������"; botsex = 1;}
		else if (r < 0.77) {st = "Jimmy the Geek"; talkst = "�������������"; botsex = 1;}
		else if (r < 0.78) {st = "Boobsie"; talkst = "�������"; botsex = 2;}
		else if (r < 0.79) {st = "Solotribe"; talkst = "���������"; botsex = 1;}
		else if (r < 0.80) {st = "A Quake Nazi"; talkst = "�����������"; botsex = 1;}
		else if (r < 0.81) {st = "fragbait"; talkst = "��������"; botsex = 1;}
		else if (r < 0.82) {st = "BARNEY"; talkst = "������"; botsex = 1;}
		else if (r < 0.83) {st = "Hydr0"; talkst = "����"; botsex = 1;}
		else if (r < 0.84) {st = "Hippie"; talkst = "������"; botsex = 1;}
		else if (r < 0.85) {st = "Beowulf"; talkst = "�������"; botsex = 1;}
		else if (r < 0.86) {st = "Dark Wind"; talkst = "��������"; botsex = 2;}
		else if (r < 0.87) {st = "Garjen"; talkst = "������"; botsex = 2;}
		else if (r < 0.88) {st = "BEEFCAKE!!!"; talkst = "�������š��"; botsex = 1;}
		else if (r < 0.89) {st = "-That Bastard-"; talkst = "�������������"; botsex = 1;}
		else if (r < 0.90) {st = "HIGHLANDER"; talkst = "����������"; botsex = 1;}
		else if (r < 0.91) {st = "FlasH"; talkst = "�����"; botsex = 1;}
		else if (r < 0.92) {st = "tsunami"; talkst = "�������"; botsex = 1;}
		else if (r < 0.93) {st = "SHaD0W"; talkst = "���İ�"; botsex = 1;}
		else if (r < 0.94) {st = "Cheese"; talkst = "������"; botsex = 1;}
		else if (r < 0.95) {st = "Colonel Commode"; talkst = "��������������"; botsex = 1;}
		else if (r < 0.96) {st = "Santa Claws"; talkst = "����������"; botsex = 1;}
		else if (r < 0.97) {st = "Obyte"; talkst = "�����"; botsex = 1;}
		else if (r < 0.98) {st = "<.RUGER.>"; talkst = "������Ү�"; botsex = 1;}
		else if (r < 0.99) {st = "CamperHunter"; talkst = "������������"; botsex = 1;}

		else {st = "Player"; talkst = "���y�r"; botsex = 1;}
	}
	while (BotNameInUse(st) && (counter < 150));
	
	bot.altname = st;
	bot.talkname = talkst;
	bot.sex = botsex;
};


