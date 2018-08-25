//botai3.qc
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



//TONY
//some stuff to get the bots to act a little more random.
//
//the eAutoBot entity will have the bots attack as a "group"
//every now and then

entity eAutoBot;
float fAutoBotNextThink = 15;
float fAutoBotRand = 0.5;

void () BotAutoThink =
{
	eAutoBot.nextthink = time + fAutoBotNextThink + 10*random();
	if (random() < fAutoBotRand)
	{
		local float fBHasHuman, fRHasHuman;
		local float fBFlagHome, fRFlagHome;
		local entity ePlayer,eFlag,p;

		ePlayer = find(world,classname,"player");
		while(ePlayer)
		{
			if (ePlayer.team == TEAM_COLOR1)
				fRHasHuman = 1;
			if (ePlayer.team == TEAM_COLOR2)
				fBHasHuman = 1;
			ePlayer = find(ePlayer,classname,"player");
		}
		if((!fRHasHuman) && (random() < 0.5))
		{
			eFlag = find(world,classname,"item_flag_team1");
			if(eFlag != world)
			if(eFlag.cnt != FLAG_AT_BASE)
				return;
			p = find(world, classname, "bot");
			while (p != world)
			{
				if ((p.team == TEAM_COLOR1) && (!(p.player_flag & ITEM_ENEMY_FLAG)))
				{
					p.bot_plan = BOT_ATTACK;
				}
				p = find(p, classname, "bot");
			}
//removeme
//bprint("Red Team decides to attack\n");
		}

		if((!fBHasHuman) && (random() < 0.5))
		{
			eFlag = find(world,classname,"item_flag_team2");
			if(eFlag != world)
			if(eFlag.cnt != FLAG_AT_BASE)
				return;
			p = find(world, classname, "bot");
			while (p != world)
			{
				if ((p.team == TEAM_COLOR2) && (!(p.player_flag & ITEM_ENEMY_FLAG)))
				{
					p.bot_plan = BOT_ATTACK;
				}
				p = find(p, classname, "bot");
			}
//removeme
//bprint("Blue Team decides to attack\n");
		}
	}
};

void () BotAutoThinkPrepare =
{
	eAutoBot = spawn();
	eAutoBot.think = BotAutoThink;
	eAutoBot.nextthink = time + fAutoBotNextThink;
};