//botai.qc
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
// trace out a few lines and try to see the thing
//====================================================
vector () GetRandomVector =
{
local vector vec;
local float r;

	r = random();
	if (r < 0.5)
	{
		if (r < 0.25)
		{
			if (r < 0.05)
				vec = '0 0 0';
			else if (r < 0.1)
				vec = '0 0 12';
			else if (r < 0.15)
				vec = '0 12 0';
			else if (r < 0.2)
				vec = '12 0 0';
			else
				vec = '12 12 0';
		}
		else
		{
			if (r < 0.3)
				vec = '12 0 12';
			else if (r < 0.35)
				vec = '0 12 12';
			else if (r < 0.4)
				vec = '0 12 12';
			else if (r < 0.45)
				vec = '-12 12 0';
			else 
				vec = '-12 12 16';
		}
	}
	else
	{
		if (r < 0.75)
		{
			if (r < 0.55)
				vec = '0 0 16';
			else if (r < 0.6)
				vec = '12 12 -16';
			else if (r < 0.65)
				vec = '12 12 0';
			else if (r < 0.7)
				vec = '12 0 12';
			else 
				vec = '12 0 12';
		}
		else
		{
			if (r < 0.8)
				vec = '0 0 12';
			else if (r < 0.85)
				vec = '0 0 -12';
			else if (r < 0.9)
				vec ='0 -12 0';
			else if (r < 0.95)
				vec = '-12 0 0';
			else
				vec = '0 0 -16';
		}	
	}
};
//====================================================
// self is the bot
// trace out a few lines and try to see the thing
//====================================================
float (entity targ) BotCanSeeItemThroughWater =
{
	local vector	spot1, spot2, vec;
		
	spot1 = self.origin + self.view_ofs;
	vec = GetRandomVector();
	spot2 = targ.origin + vec;

	traceline (spot1, spot2, TRUE, self);	// see through other monsters

	if (trace_fraction == 1)
		return TRUE;
	
	return FALSE;
};
//====================================================
// self is the bot
// trace out a few lines and try to see the thing
//====================================================
float (vector pt) BotCanSeePoint =
{
	local vector	spot1;
		
	spot1 = self.origin + self.view_ofs;

	traceline (spot1, pt, TRUE, self);	// see through other monsters
	
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	
	return FALSE;
};
//====================================================
// self is the bot
// trace out a few lines and try to see the thing
//====================================================
float (vector pt) BotCanSeePointThroughWater =
{
	local vector	spot1;
		
	spot1 = self.origin + self.view_ofs;

	traceline (spot1, pt, TRUE, self);	// see through other monsters

	if (trace_fraction == 1)
		return TRUE;
	
	return FALSE;
};
//====================================================
// self is the bot
// trace out a few lines and try to see the thing
//====================================================
float (entity targ) BotCanSeeItem =
{
	local vector	spot1, spot2, vec;
		
	spot1 = self.origin + self.view_ofs;
	vec = GetRandomVector();
	spot2 = targ.origin + vec;

	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	
	return FALSE;
};
//====================================================
// self is the bot
// trace out a few lines and try to see the thing
//====================================================
float (entity targ) BotCanSeePlayer =
{
	local vector	spot1, spot2, vec;
	local float r;
	
	spot1 = self.origin + self.view_ofs;

	// don't get random vector if partially in water, because
	// this can cause bots to not notice players partially
	// in the water....
	// only use random vector when totally in or totally out
	// of water
	if ((targ.waterlevel == 0) || (targ.waterlevel == 3))
		vec = GetRandomVector();
	else
		vec = '0 0 16';
		
	spot2 = targ.origin + vec;

	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	
	return FALSE;
};
//=============================================================
// returns 1 if the entity is visible to self, even if not in front,
// this just checks for whether player is blocked by the world
//=============================================================
float (entity targ) BotCanSeePlayer0 =
{
	return BotCanSeeItem(targ);
};
//=============================================================
//=============================================================
entity (entity targ) BotCanSeePlayerFollow =
{
local float vis;
local entity e;
local float nm;

	if (targ != world)
	{
		nm = 0;
		e = targ.follow_head;
		while ((e != world) && (nm < 10))	// nm runaway loop protection
		{
			vis = BotCanSeeItem(e);
			if (vis) 
				return e;

			e = e.follow_next;
			nm = nm + 1;
		}
	}
	
	return world;
};
//=============================================================
//=============================================================

//TONY
//REMOVED
//void (entity it) PrintItemName = 
//{
//	if (it.classname == "item_health")
//	{
//		if (it.spawnflags & H_MEGA)
//			dprint("megahealth");
//		else if (it.spawnflags & H_ROTTEN)
//			dprint("15 health");
//		else
//			dprint("25 health");
//	}
//	else if (it.classname == "item_armor1")
//		dprint("green armor");
//	else if (it.classname == "item_armor2")
//		dprint("yellow armor");
//	else if (it.classname == "item_armorInv")
//		dprint("red armor");
//	else if (it.classname == "item_flag_team1")
//		dprint("red flag");
//	else if (it.classname == "item_flag_team2")
//		dprint("blue flag");
//	else if (it.netname == "")
//		dprint("something [?]");
//	else
//		dprint(it.netname);
//};

//=============================================================
// self is bot
//=============================================================
void() RemoveInaccessible =
{
	num_inaccessible_entities = num_inaccessible_entities - 1;
	if (self.inaccessible_entity != world)
	{
		if (self.inaccessible_entity.inaccessible_count > 0)
			self.inaccessible_entity.inaccessible_count = self.inaccessible_entity.inaccessible_count - 1;
	}
	remove(self);
};

//=============================================================
// self is bot
//=============================================================
float(entity e) ItemIsAccessible =
{
local entity p;

	if (e.inaccessible_count <= 0)
		return TRUE;

	p = find(world, classname, "inaccessible_from_here");
	while (p != world)
	{
		if (p.inaccessible_entity == e)
		{
			if (vlen(p.origin - self.origin) < 100)
			{
//				if (bot_debug >= 1)
//				{
//					dprint(self.netname);
//					dprint(" thinks ");
//					PrintItemName(e);
//					dprint(" is inaccessible\n");
//				}

				return FALSE;
			}
		}
		p = find(p, classname, "inaccessible_from_here");
	}
	
	return TRUE;
};

//=============================================================
// self is bot
//=============================================================
void (entity e) SpawnInaccessibleFromHere =
{
local entity p;

	if (ItemIsAccessible(e))	// don't spawn another if one already here
	{
		num_inaccessible_entities = num_inaccessible_entities + 1;

//		if (bot_debug >= 1)
//		{
//			dprint(self.netname);
//			dprint(" marks ");
//			PrintItemName(e);
//			dprint(" as inaccessible\n");
//		}
		
		p = spawn();
		p.classname = "inaccessible_from_here";
		p.inaccessible_entity = e;
		e.inaccessible_count = e.inaccessible_count + 1;
		p.origin = self.origin + '0 0 16';
		setorigin(p, p.origin);
		p.solid = SOLID_NOT;
		p.movetype = MOVETYPE_NONE;
		//setmodel(p, "progs/s_bubble.spr");
		setmodel(p, string_null);
		p.think = RemoveInaccessible;
		p.nextthink = time + 60;	// 1 minute
	}
};

//=============================================================
// check for items
// self is bot
//=============================================================
entity(float dist) FindNearbyItem =
{
local entity head, selected;
local float item_rating;
local float best_rating, found;

	// optimization: don't do this every frame, because it is slow
	if (time < self.find_item_time)
		return FALSE;	
	self.find_item_time = time + (self.bsk_reaction_time / 1.5);
	// end optimization

//	if (bot_debug >= 3)
//	{
//		dprint(self.netname);
//		dprint(" FindNearbyItem\n");
//	}
	
	selected = world;
	found = FALSE;
	
	// special case optimization: try to capture
	// look for our flag, we have enemy flag
	if (self.player_flag & ITEM_ENEMY_FLAG)
	{
		if (self.team == TEAM_COLOR1)
			head = find(world, classname, "item_flag_team1");
		else if (self.team == TEAM_COLOR2)
			head = find(world, classname, "item_flag_team2");

		if (head != world)
		if (head.solid != SOLID_NOT)		// ignore items until they respawn!
		if (BotCanSeeItem(head)) 
		{
			found = TRUE;
			selected = head;
		}
	}

	if (!found)
	{
		if (self.team == TEAM_COLOR1)
			head = find(world, classname, "item_flag_team2");
		else if (self.team == TEAM_COLOR2)
			head = find(world, classname, "item_flag_team1");

		if (head != world)
		if ((time >= head.bot_ignore_until_time) || (self.team != head.bot_ignore_team))
		if (head.solid != SOLID_NOT)		// ignore items until they respawn!
		if (vlen(head.origin - self.origin) < 700)
		if (BotCanSeeItem(head)) 
		{
			found = TRUE;
			selected = head;
		}
	}
	
	// look for other stuff
	if (!found)
	{
		head = findradius(self.origin, dist);
		while(head)
		{
			if (head.solid != SOLID_NOT)		// ignore items until they respawn!
			if (head.bot_wants_item)		// optimization
			if ((time >= head.bot_ignore_until_time) || (self.team != head.bot_ignore_team))
			if (BotCanSeeItem(head)) 
			if (ItemIsAccessible(head)) 
			{
				item_rating = IsGoodItem(self, head);

				if (item_rating > 0)
				{
					if ((trace_plane_dist - item_rating) < dist)
					{
						best_rating = item_rating;
						selected = head;
						dist = trace_plane_dist;
						found = TRUE;
					}
				}
			}
			head = head.chain;
		}
	}
	
	/*
	if (selected != world) 
	{
		if (selected != self.goalentity)
		{
			self.noticed_item_time = time;
//			if ((bot_debug >= 1) && (selected != world))
//			{
//				dprint(self.netname);
//				dprint(" noticed ");
//				PrintItemName(selected);
//				dprint(" at ");
//				dprintfloat(time);
//				dprint("\n");
//			}
		}
		else
		{
			// same item that we are already going for...
			// if it's more than 10 seconds we were going for the
			// item, give up on it
			if (time > (self.noticed_item_time + 10))
			{
//				if (bot_debug >= 1)
//				{
//					dprint(self.netname);
//					dprint(" giving up on ");
//					PrintItemName(self.goalentity);
//					dprint("\n");
//				}
			}
		}
	}
	*/
	
//	if ((bot_debug >= 1) && (selected != world))
//	{
//		dprint(self.netname);
//		dprint(" wants ");
//		PrintItemName(selected);
//		dprint(" [");
//		dprintfloat(best_rating);
//		dprint("]");
//		dprint("\n");
//	}
	
	return selected;
};

//=============================================================
// self is the bot
// returns the bot or player that we should move toward to help.
// candidates include:  
// 1) human player on our team
// 2) bot or human player carrying the flag
// 3) bot or human player with enemy != world
//=============================================================
entity (entity bot, float dist) HelpTeammate =
{
local entity head, selected1, selected2, selected3;
local float d, best_dist1, best_dist2, best_dist3, thisdist;

	// optimization:  if we already helping someone, keep helping
	
	if ((bot.goalentity.classname == "player"
		|| bot.goalentity.classname == "bot")
			&& (bot.goalentity != bot))
	{
		if (bot.goalentity.team == self.team)
		{
			// already helping someone, so just keep helping 
			// that player
			if (bot.goalentity.health > 0)
			{
				if (BotCanSeePlayer(bot.goalentity))
				{
//					if (bot_debug >= 1)
//					{
//						dprint(bot.netname);
//						dprint(" helping same ");
//						dprint(bot.goalentity.netname);
//						dprint("\n");
//					}

					return bot.goalentity;
				}
			
				if (bot.goalentity.classname == "player")
				{
					local entity follow_ent;
					follow_ent = BotCanSeePlayerFollow(bot.goalentity);
					if (follow_ent != world)
					{
//						if (bot_debug >= 1)
//						{
//							dprint(bot.netname);
//							dprint(" following ");
//							dprint(bot.goalentity.netname);
//							dprint("\n");
//						}	

						return follow_ent;
					}
				}
			}
		}
	}
	
	// if we get here, we are not already helping a player,
	// so we check for someone else to help... only do this
	// every few seconds, because it is slow
	
	// if already helping player or bot, don't check for player
	if (time < bot.help_teammate_time)
		return;

	bot.help_teammate_time = time + 5;

//	if (bot_debug >= 1)
//	{
//		dprint(bot.netname);
//		dprint(" check to help\n");
//	}
	
	selected1 = world;
	selected2 = world;
	selected3 = world;
	best_dist1 = 99999999;
	best_dist2 = 99999999;
	best_dist3 = 99999999;

	head = findradius(bot.origin, dist);		//find(world, classname, "player");
	while(head)
	{
		//thisdist = vlen(bot.origin - head.origin);
		//if (thisdist < dist)
		if (head.classname == "player" || head.classname == "bot")
		if (head.team == bot.team)
		if (head != bot)
		if (!(head.observer_flags & PLAYER_NO_TARGET))
		if (!head.observer)
		{
			d = vlen(head.origin - bot.origin);
			
			if (head.classname == "player")			
			if ((head.observer_flags & PLAYER_ALWAYS_ESCORT) 
				|| ((time < (self.escort_time + ESCORT_TIME)) 
				&& (self.escort_entity == head))
				
				)	// human must have requested escort
			{
				if (d < best_dist1)
				if (BotCanSeePlayer(head)) 
				{
					selected1 = head;
					best_dist1 = d;
				}
			}
			
			if (head.player_flag & ITEM_ENEMY_FLAG) 
			if (self != head.goalentity)		// ignore if he's following *us*
			{
				if (d < best_dist2)
				if (BotCanSeePlayer(head)) 
				{
					selected2 = head;
					best_dist2 = d;
				}
			}

			if (head.classname == "bot")	// only bots have enemies this way
			if (head.enemy != world) 
			if (head.enemy.classname == "player" || head.enemy.classname == "bot")
			{
				if (d < best_dist3)
				if (BotCanSeePlayer(head)) 
				{
					selected3 = head;
					best_dist3 = d;
				}
			}

		}
		
		head = head.chain;
	}
	
	// priorities: human player, bot with flag, bot with enemy
	
	if (selected1 != world)
	{
//		if (bot_debug >= 1)
//		{
//			dprint(self.netname);
//			dprint(" helping player ");
//			dprint(selected1.netname);
//			dprint("\n");
//		}

		return selected1;
	}
	else if (selected2 != world)
	{
//		if (bot_debug >= 1)
//		{
//			dprint(self.netname);
//			dprint(" helping flag carrier ");
//			dprint(selected2.netname);
//			dprint("\n");
//		}

		return selected2;
	}
	else if (selected3 != world)
	{
//		if (bot_debug >= 1)
//		{
//			dprint(self.netname);
//			dprint(" helping ");
//			dprint(selected3.netname);
//			
//			dprint(" fight ");
//			dprint(selected3.enemy.netname);
//				
//			dprint("\n");
//		}

		return selected3;
	}
	else 
		return world;
};

//=============================================================
//=============================================================
entity(float fteam)BotFindClosestTempWaypoint = 
{
local entity e, selected;
local float best_waypoint_dist;

	selected = world;
		
	best_waypoint_dist = 99999999999;
	e = find(world, classname, "waypoint_temp");
	while (e != world)
	{
		if (e.team == fteam)
		if (BotCanSeeItemThroughWater(e))
		{
			if (vlen(e.origin - self.origin) < best_waypoint_dist)
			{
					selected = e;
					best_waypoint_dist = vlen(e.origin - self.origin);
			}
		}

		e = find(e, classname, "waypoint_temp");
	}

	return selected;
};

//=============================================================
//=============================================================
entity(float fteam)BotFindLeastWaypoint = 
{
local entity e, selected;
local float best_waypoint_num, current_waypoint_num;

	/* this breaks for some reason
	if (self.goalentity.classname == "waypoint")
	{
		// if we are going toward a waypoint already, then have
		// a pretty good chance of not looking for another waypoint
		// until we actually get near the waypoint we are going
		// toward... not a 100% chance, because we want to be
		// able to take "shortcuts" sometimes, but this will make
		// this routine go much faster... there is no point in
		// looking at every waypoint in the world when we can
		// probably only see a few, and only care about one.
		
		if (!(self.player_flag & ITEM_ENEMY_FLAG))
		if (vlen(self.origin - self.goalentity.origin) > 100)
		{
			if (random() < 0.99)
				return;
		}
	
		if (self.goalentity.team == fteam)
			current_waypoint_num = self.goalentity.waypoint_num;
		else
			current_waypoint_num = 999999;
	}
	else
	*/
		current_waypoint_num = 999999;

	best_waypoint_num = 999999;
	selected = world;
	
	if (fteam == TEAM_COLOR1)
		e = wp_first_red;
	else if (fteam == TEAM_COLOR2)
		e = wp_first_blue;
	else if (fteam == -1)	
		e = wp_first_general;
	
	while (e != world)
	{
		//if (e.team == fteam)
		if (e.waypoint_num < current_waypoint_num)
		if (e.waypoint_num < best_waypoint_num)
		{

//OLD
//			if (BotCanSeeItemThroughWater(e))
//			{
//				selected = e;
//				best_waypoint_num = e.waypoint_num;
//			}
//tony
//def way
			if (e.waypoint_num != -1)
			{
				if (BotCanSeeItemThroughWater(e))
				{
					selected = e;
					best_waypoint_num = e.waypoint_num;
				}
			}
			else if ((e.waypoint_num == -1) && (self.use_defensive_way) &&
			(self.bot_plan == BOT_DEFEND) && (!(self.player_flag & ITEM_ENEMY_FLAG)))
			{
				if (BotCanSeeItemThroughWater(e))
				{
					selected = e;
					best_waypoint_num = e.waypoint_num;
				}
			}
			//else, just let it go
		}
		else if (e.waypoint_num == best_waypoint_num)
		{
		local float choose;
		
			if (BotCanSeeItemThroughWater(e))
			{
				// if our goalentity is a waypoint, then always
				// use that one, never switch to another that
				// has the same value.  This prevents the bot
				// for being very indecicive when he can see two
				// waypoints with the same value, but in opposite
				// directions.

				choose = TRUE;
				if (self.goalentity.classname == "waypoint")
					choose = FALSE;
				if (self.goalentity.waypoint_num > e.waypoint_num)
					choose = TRUE;

				if (choose)
				if (random() < 0.5)
				{
//					if (bot_debug >= 2)
//					{
//						dprint(self.netname);
//						dprint(" takes alternate path\n");
//					}

					selected = e;
					best_waypoint_num = e.waypoint_num;
				}
			}
		}

		e = e.wp_chain;
	}

	return selected;
};
//=============================================================
//=============================================================
entity(float fteam)BotFindGreatestWaypoint = 
{
local entity e, selected;
local float best_waypoint_num, current_waypoint_num;

	/* this breaks for some reason
	if (self.goalentity.classname == "waypoint")
	{		
		if (!(self.player_flag & ITEM_ENEMY_FLAG))
		if (vlen(self.origin - self.goalentity.origin) > 100)
		{
			if (random() < 0.99)
				return;
		}

		if (self.goalentity.team == fteam)
			current_waypoint_num = self.goalentity.waypoint_num;
		else
			current_waypoint_num = -1;
	}
	else
	*/
		current_waypoint_num = -1;

	best_waypoint_num = -1;
	selected = world;

	if (fteam == TEAM_COLOR1)
		e = wp_first_red;
	else if (fteam == TEAM_COLOR2)
		e = wp_first_blue;
	else if (fteam == -1)	
		e = wp_first_general;

	while (e != world)
	{
		//if (e.team == fteam)
		if (e.waypoint_num > current_waypoint_num)
		if (e.waypoint_num > best_waypoint_num)
		{
			if (BotCanSeeItemThroughWater(e))
			{
				selected = e;
				best_waypoint_num = e.waypoint_num;
			}
		}
		else if (e.waypoint_num == best_waypoint_num)
		{
		local float choose;
		
			if (BotCanSeeItemThroughWater(e))
			{
				// if our goalentity is a waypoint, then always
				// use that one, never switch to another that
				// has the same value.  This prevents the bot
				// for being very indecicive when he can see two
				// waypoints with the same value, but in opposite
				// directions.

				choose = TRUE;
				if (self.goalentity.classname == "waypoint")
					choose = FALSE;
				if (self.goalentity.waypoint_num > e.waypoint_num)
					choose = TRUE;

				if (choose)
				if (random() < 0.5)
				{
//					if (bot_debug >= 2)
//					{
//						dprint(self.netname);
//						dprint(" takes alternate path\n");
//					}

					selected = e;
					best_waypoint_num = e.waypoint_num;
				}
			}
		}
		
		e = e.wp_chain;
	}

	return selected;
};
//=============================================================
//=============================================================
void () BotFireHook =
{
	if (!hook_use_enabled)
		return;
//TONY
//MULTIWEAPON
	if(temp1 & TEMP1_MULTI)
	{

		self.lastweapon_shot = self.weapon;
		self.weapon = IT_HOOK;
		set_player_weapon ();
		self.button0 = TRUE;
		Bot_Attack();
		self.attack_finished = time + 0.1;
		self.weapon = self.lastweapon_shot;
//the following gives the bot a weapon sticking out of her head
//so . . . 
//		set_player_weapon ();

	}
	else
	{
		self.weapon = IT_HOOK;
		self.button0 = TRUE;
		Bot_Attack();
		self.attack_finished = time + 0.1;
	}
	
};
//=============================================================
//=============================================================
float(entity bot, entity en, float dist) CanSeeInvisibleEntity =
{
local float can_see_eyes, chance;

	can_see_eyes = TRUE;

	// special case check for eyes powerup
	if (en.invisible_finished > time)
	{
		if (dist < 80)
			chance = 15;
		else if (dist < 200)
			chance = 8;
		else
			chance = 1;
			
		if ((random() * 100) < (chance + (bot.bot_skill * (chance / 4))))
			can_see_eyes = TRUE;
		else
			can_see_eyes = FALSE;
	}
		
	return can_see_eyes;
};

//====================================================
// self is the bot
// should change this routine to select enemies based on priority...
// i.e. need to consider whether or not enemy has the flag here,
// and try to kill flag carrier with higher priority.  
//====================================================
entity () FindNearbyEnemy =
{
local entity head, selected;
local float dist, thisdist;

	// optimization: don't do this every frame, because it is slow
	if (time < self.find_enemy_time)
		return FALSE;	
	self.find_enemy_time = time + self.bsk_reaction_time;
	// end optimization
	
//	if (bot_debug >= 3)
//	{
//		dprint(self.netname);
//		dprint(" FindNearbyEnemy\n");
//	}

	if (time > self.large_dist_pulse)
	{
		self.large_dist_pulse = time + self.bsk_next_pulse_time;
		dist = large_pulse_dist;
		if (random() < 0.02)
			dist = dist + self.bsk_extra_large_pulse_dist;

//		if (bot_debug >= 2)
//		{
//			dprint(self.netname);
//			dprint(" large dist pulse\n");
//		}
	}
	else
	{
 	 	// awareness radius of bot... higher for higher skill levels
		dist = awareness_dist;
		if (random() < 0.008)
			dist = dist + self.bsk_extra_awareness_dist;
	}
	

	selected = world;

	head = findradius(self.origin, dist);
	while(head)
	{
		//thisdist = vlen(self.origin - head.origin);
		//if (thisdist < dist)
		if (head.classname == "player" || head.classname == "bot")
		if (head.team != self.team)		// || (head.invisible_finished > time))		// can't see what team if invisible
		if ((head.health > 0) && (head != self))
		if (EntityInFieldOfView(head))
		if (BotCanSeePlayer(head))
		if (trace_plane_dist < dist)
		if (CanSeeInvisibleEntity(self, head, trace_plane_dist))
		if (!(head.observer_flags & PLAYER_NO_TARGET))
		if (!head.observer)
		{
			selected = head;
			dist = trace_plane_dist;
		}

		head = head.chain;
		
		/*
		if (head.classname == "bot")
			head = find(head, classname, "bot");
		else
		{ 
			head = find(head, classname, "player");
			if (head == world)
				head = find(world, classname, "bot");
		}
		*/
	}

	if ((selected != world) && (bot_debug >= 3))
	{
		dprint(self.netname);
		dprint(" found ");
		dprint(selected.netname);
		dprint("\n");
	}
	return selected;
};
//=============================================================
//=============================================================
void() BotJump =
{
//	if (bot_debug >= 3)
//	{
//		dprint(self.netname);
//		dprint(" Jump\n");
//	}
	
	makevectors (self.angles);
	v_forward_z = 0;		// we need just x/y direction
	v_forward = normalize(v_forward);


	// this makes the bot jump forward instead of in place
	if (self.waterlevel >= 2)
	{
		if (self.watertype == CONTENT_WATER)
			self.velocity = '0 0 0' + (v_forward * 100);
		else if (self.watertype == CONTENT_SLIME)
			self.velocity = '0 0 0' + (v_forward * 80);
		else if (self.watertype == CONTENT_LAVA)
			self.velocity = '0 0 0' + (v_forward * 50);
	}
	else
		self.velocity = '0 0 0' + (v_forward * 320);		// sv_maxspeed
	
	self.flags = self.flags | FL_JUMPRELEASED;
	PlayerJump ();
	
	//if (self.velocity_z) 
	//	self.velocity = self.velocity + (v_forward * self.fwdspeed);
};
//=============================================================
// crude test to see if we are about to jump into lava or slime
//=============================================================
float()  IsJumpSafe =
{
local vector org, spot2; 

    makevectors(self.angles);
    
    org = self.origin + (v_forward * 100);
    spot2 = org;
    spot2_z = spot2_z - 500;

	// trace a line from 100 in front of us, straight down 500 units
	traceline (org, spot2, TRUE, self);
    if (pointcontents(trace_endpos) == CONTENT_LAVA)
        return FALSE;
    if (pointcontents(trace_endpos) == CONTENT_SLIME)
        return FALSE;

    org = self.origin + (v_forward * 200);
    spot2 = org;
    spot2_z = spot2_z - 500;

	// trace a line from 200 in front of us, straight down 500 units
	traceline (org, spot2, TRUE, self);
    if (pointcontents(trace_endpos) == CONTENT_LAVA)
        return FALSE;
    if (pointcontents(trace_endpos) == CONTENT_SLIME)
        return FALSE;
	
	return TRUE;		// looks pretty safe
};
//=============================================================
// remember, this routine is called often, so small chances become
// big chances quickly.  
//=============================================================
float() BotShouldJump =
{
local float chance, jump_to_goal;
local vector v;

	if (!IsJumpSafe())
	{
		if ((pointcontents(self.origin) != CONTENT_SLIME)
		&& (pointcontents(self.origin) != CONTENT_LAVA))		// not already in it
		{
//			if (bot_debug >= 1)
//			{
//				dprint(self.netname);
//				dprint(" jump is unsafe\n");
//			}
			return FALSE;
		}
	}

	// see if we need to jump to get an item that is above us
	jump_to_goal = FALSE;
	v = self.origin - self.goalentity.origin;
	if (vlen(v) < 50)
	{
		// item is close

		if (self.origin_z < self.goalentity.origin_z)	// we are below item
			if ((self.goalentity.origin_z - self.origin_z) < 100)		// below but close
				jump_to_goal = TRUE;
	}
	else if (vlen(v) > 60)
	{
		// item is far

		if (self.origin_z > self.goalentity.origin_z)	// we are above item
			if ((self.origin_z - self.goalentity.origin_z) > 100)		// far away
				jump_to_goal = TRUE;
	}

//	if ((bot_debug >= 2) && (jump_to_goal))
//	{
//		dprint(self.netname);
//		dprint(" jump to goal\n");
//	}

	if (jump_to_goal)
		chance = self.bsk_extra_jump_chance;
	else if (pointcontents(self.origin) == CONTENT_SLIME)
		chance = self.bsk_extra_jump_chance;
	else if (pointcontents(self.origin) == CONTENT_LAVA)
		chance = self.bsk_extra_jump_chance;
	else if (self.bot_blocked)
		chance = 0.1;
	else if (self.bot_action == BOT_FIGHTING)
		chance = 0.03;
	else
		chance = 0.002;

	if (random() < chance)
		return TRUE;
	else
		return FALSE;
};

/*============================================================*/
void (vector org) SpawnTempDebugMarker = 
{
local entity st;

	st = spawn();
	st.origin = org;
	setorigin(st, org);
	st.solid = SOLID_NOT;
	st.movetype = MOVETYPE_NONE;
	setmodel(st, "progs/s_bubble.spr");
	st.think = SUB_Remove;
	st.nextthink = time + 0.1;
};
//=============================================================
//=============================================================
float() StepUpZ =
{
	local vector spot1, spot2;
	local vector vf2, vr2, org;
	local float diff1, diff2, diff3, max;
		
	makevectors(self.angles);
	
	vf2 = v_forward;
	vf2_z = 0;
	vf2 = normalize(vf2);
	org = self.origin + (vf2 * 24);
	spot1 = org;
	spot2 = spot1 - '0 0 64';
	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	diff1 = trace_endpos_z - (self.origin_z - 24);
	// -------
	vr2 = v_right;
	vr2_z = 0;
	vr2 = normalize(vr2);
	org = self.origin + (vf2 * 24) + (vr2 * 16);
	spot1 = org;
	spot2 = spot1 - '0 0 64';
	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	diff2 = trace_endpos_z - (self.origin_z - 24);
	// -------
	org = self.origin + (vf2 * 24) + (vr2 * -16);
	spot1 = org;
	spot2 = spot1 - '0 0 64';
	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	diff3 = trace_endpos_z - (self.origin_z - 24);
	// -------
	
	max = diff1;
	if (diff2 > max)
		max = diff2;
	if (diff3 > max)
		max = diff3;
		
	if (max > 16)
		max = 16;
	
	if (max > 0)
		return max;
	else
		return 0;
};
//=============================================================
// self is the bot
//=============================================================
float() ShouldReleaseHook =
{
	if ((self.stuck_count > 2) && (!self.hooked_on_someone))
	{
//		if (bot_debug >= 2)
//		{
//			dprint(self.netname);
//			dprint(" stuck, drop down\n");
//		}
		
		return TRUE;		 // always release hook if stuck to wall
	}
	else if ((time > (self.hook_snag_time + 3)) && (!self.hooked_on_someone))
	{
//		if (bot_debug >= 2)
//		{
//			dprint(self.netname);
//			dprint(" time, drop down\n");
//		}
		return TRUE;		 // always release hook 3 second later
	}

	return FALSE;
};
//=============================================================
//=============================================================
float() MoveForwardSafe =
{
	local vector spot1, spot2;
	local vector vf2, org;
	local float diff;
		
	makevectors(self.angles);
	
	vf2 = v_forward;
	vf2_z = 0;
	vf2 = normalize(vf2);
	org = self.origin + (vf2 * 24);
	
	spot1 = org;
	spot2 = org - '0 0 2000';

	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	
	diff = trace_endpos_z - (self.origin_z - 24);

	if ((diff < 0) && (trace_inopen && trace_inwater))	// water/lava/slime
		return FALSE;
	else
		return TRUE;
};

//=============================================================
// this is an intermediate think routine used only to make the
// animation smoother.  It move the second half of the distance
// we originally wanted to move, and then sets think/nextthink
// and that is *IT*!  
//=============================================================
void() ExtraWalkMoveFrameThink =
{
//	if (bot_debug >= 2)
//	{
//		dprint(self.netname);
//		dprint(" ExtraWalkMoveFrameThink\n");
//	}

	//if (self.bot_action != BOT_STANDING)
		walkmove(self.extramove_yaw, self.extramove_dist);
	
	if (self.extramove_lastframewasextra)
	{
//TONY
//This happens everynow and then
//it's kind of annoying
//		dprint(self.netname);
//		dprint("'s brain was fixed\n");
		
		self.think = BotAnimationThink;
	}
	else
		self.think = self.extramove_oldthink;		// reset old think

	self.extramove_lastframewasextra = TRUE;

	self.nextthink = time + 0.05;
};
//=============================================================
// this is an intermediate think routine used only to make the
// animation smoother.  It move the second half of the distance
// we originally wanted to move, and then sets think/nextthink
// and that is *IT*!  
//=============================================================
void() ExtraMoveToGoalFrameThink =
{
//	if (bot_debug >= 2)
//	{
//		dprint(self.netname);
//		dprint(" ExtraMoveToGoalFrameThink\n");
//	}

	//if (self.bot_action != BOT_STANDING)
		movetogoal(self.extramove_dist);

	if (self.extramove_lastframewasextra)
	{
//TONY
//This happens everynow and then
//it's kind of annoying
//		dprint(self.netname);
//		dprint("'s brain was fixed\n");
		
		self.think = BotAnimationThink;
	}
	else
		self.think = self.extramove_oldthink;		// reset old think
	
	self.extramove_lastframewasextra = TRUE;

	self.nextthink = time + 0.05;
};
//=============================================================
// self is the bot
// returns FALSE if move blocked
//=============================================================
float(float yaw, float dist) BotWalkMove =
{
//TONY
//NORSE IS NOW PART OF TEAMPLAY CVAR
	//if (use_norse_movetogoal) 
	if (teamplay & TEAM_NORSE_MOVEMENT)
	{
		self.nextthink = time + 0.1;
		return walkmove(yaw, self.extramove_dist);

//TONY
//FIXME????
//WHY IS THIS COMMENTED OUT????		
	//   self.movedir = yawtovec(yaw);
	//	norse_movetogoal(TRUE);
	//   self.movedir = '0 0 0';
	}
	else// if (use_extra_move_frame)
	{
		self.extramove_yaw = yaw;
		self.extramove_dist = dist / 2;

		self.think = ExtraWalkMoveFrameThink;
		self.nextthink = time + 0.05;		// half of normal think

		return walkmove(yaw, self.extramove_dist);
	}
//	else
//	{
//		return walkmove(yaw, dist);
//	}
};
//=============================================================
//=============================================================
float(float dist) BotMoveToGoal =
{
//TONY
//NORSE IS NOW PART OF TEAMPLAY CVAR
//	if (use_norse_movetogoal)
	if (teamplay & TEAM_NORSE_MOVEMENT)
	{
		self.nextthink = time + 0.1;
             
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		ChangeYaw ();

		self.speed = -1;
		norse_movetogoal(TRUE);
	}
	else// if (use_extra_move_frame)
	{
		self.extramove_dist = dist / 2;

		self.think = ExtraMoveToGoalFrameThink;
		self.nextthink = time + 0.05;		// half of normal think

		movetogoal(self.extramove_dist);
	}
//	else
//	{
//		movetogoal(dist);
//	}
};

//=============================================================
// desired_velocity should be the vector we want to go
//=============================================================
float (vector desired_velocity) GetMoveDist =
{
local float dist, dp;
local vector des_vel;
	
	/*
	des_vel = normalize(desired_velocity) * 10;		// sv_acceleration (?)

	self.current_velocity = self.current_velocity + des_vel;
	dist = vlen(self.current_velocity);
	
	if (dist > 32)
	{
		dist = 32;
		self.current_velocity = normalize(self.current_velocity) * 32;
	}

	if (desired_velocity == '0 0 0')
	{
		makevectors(self.angles);
		des_vel = v_forward;
	}
	else
	*/
	
	if (desired_velocity == '0 0 0')
	{
		makevectors(self.angles);
		des_vel = normalize(v_forward);
	}
	else
	{
		des_vel = normalize(desired_velocity);
	}

	self.current_velocity = normalize(self.current_velocity);
	dp = (self.current_velocity * des_vel);
	self.current_velocity = des_vel;

	//dprintfloat(dp);
	//dprint("\n");
	
	if (dp < 0)
		dp = 0;

	dist = 32 * dp;

	
	// adjust movedist here based on waterlevel/watertype ???
	if (self.waterlevel == 3)
		dist = dist / 2;		// move slower in water
		
	/*
	local string st;
	st = ftos(dist);
	dprint(st);
	dprint("\n");
	*/

	return dist;
};

//=============================================================
// low-level move routine
// this routine does *NOT* change the yaw of the bot, it just moves
// blindly toward goalentity
//=============================================================
void() MoveBot =
{
local float dist;
local vector vec;

//	if (bot_debug >= 3)
//	{
//		dprint(self.netname);
//		dprint(" MoveBot\n");
//	}
	
	//self.bot_action = BOT_MOVING;

	if (!(self.flags & FL_ONGROUND))
		return;

	dist = GetMoveDist(self.goalentity.origin - self.origin);
	movedist = dist;		// must set this global to move?

//TONY
//TEST
		
	if (BotShouldJump() && !(teamplay & TEAM_NORSE_MOVEMENT))
		BotJump();
	else
	{
		if (!smooth_move)
		{
			local vector oldorg;
			
			/*
			// alternate movement code -- works kind of better?
			
			local float yw, bl, tries;
			
			
			yw = vectoyaw(self.goalentity.origin - self.origin);
			
			bl = !BotWalkMove(yw, dist);
									
			self.bot_blocked = FALSE;

			if (bl)
			{
				dprint(self.netname);
				dprint(" is blocked\n");
				
				// blocked (maybe stairs), so try moving to goal method
				
				oldorg = self.origin;
				BotMoveToGoal(dist);
				
				if (self.origin == oldorg)
				{
					dprint(self.netname);
					dprint(" is really blocked\n");
					self.bot_blocked = TRUE;
				}
			}
			*/
			
			oldorg = self.origin;
			
			BotMoveToGoal(dist);
			self.bot_blocked = FALSE;
			if ((self.origin == oldorg) && (dist != 0))
			{
//				if (bot_debug >= 1)
//				{
//					dprint(self.netname);
//					dprint(" is really blocked\n");
//				}
				
				self.bot_blocked = TRUE;
			}
		}
		else
		{
 			self.flags = self.flags | FL_JUMPRELEASED;

			self.flags = self.flags - (self.flags & FL_ONGROUND);
			
			if (MoveForwardSafe())
			{
				local vector vec2;
				local float stepup;
				vec2 = self.origin;
				stepup = StepUpZ();
				vec2_z = vec2_z + stepup;
				setorigin(self, vec2);

				//dprintfloat(vec_z);
				//dprint("\n");

				vec = self.goalentity.origin - self.origin;
				vec_z = stepup;
				vec = normalize(vec);
				if (self.goalentity != self)
					self.velocity = (vec * 640);
				else
				{
					makevectors(self.angles);
					self.velocity = normalize(v_forward) * 640;
				}
			}
		}
	}
};
//====================================================
// self is the bot
//====================================================
float() MaybeFightFlagCarrier =
{
local entity p;

	if (random() < self.bsk_skill_lin3)
	{
		if (self.team == TEAM_COLOR1)
			p = find(world, classname, "item_flag_team1");
		else if (self.team == TEAM_COLOR2)
			p = find(world, classname, "item_flag_team2");

		if (p.cnt == FLAG_CARRIED)
		if (p.owner != world)
		if (p.owner.classname == "player" || p.owner.classname == "bot")
		if (p.owner != self.enemy)		// only if not already fighting flag carrier
		if ((p.owner.health > 0) && (p.owner != self))
		if (EntityInFieldOfView(p.owner))
		if (BotCanSeePlayer(p.owner))
		if (CanSeeInvisibleEntity(self, p.owner, trace_plane_dist))
		if (!(p.owner.observer_flags & PLAYER_NO_TARGET))
		if (!p.owner.observer)
		if (trace_plane_dist < 1500) 
		{
//			if (bot_debug >= 1)
//			{
//				dprint(self.netname);
//				dprint(" wants to kill flag carrier ");
//				dprint(p.owner.netname);
//				dprint("\n");
//			}

			self.goalentity = p.owner;
			self.movetarget = p.owner;
			self.enemy = p.owner;

			/*
			self.suspicious_about = en.origin;
			self.suspicious_about_time = time;
			*/

			self.enemy_notice_time = time - 999;	// start now!

			self.bot_action = BOT_FIGHTING;

			return TRUE;
		}
	}
	
	return FALSE;
};
//====================================================
// self is the bot
//====================================================
float() MaybeFight =
{
local entity en;

	en = FindNearbyEnemy();
	if (en != world)
	{
//		if (bot_debug >= 1)
//		{
//			dprint(self.netname);
//			dprint(" wants to kill ");
//			dprint(en.netname);
//			dprint("\n");
//		}
		
		self.goalentity = en;
		self.movetarget = en;
		self.enemy = en;

		/*
		self.suspicious_about = en.origin;
		self.suspicious_about_time = time;
		*/
		self.enemy_notice_time = time;
		
		self.bot_action = BOT_FIGHTING;
	
		return TRUE;
	}
	/*
	else
	{
		if (FALSE)	// (time < (self.suspicious_about_time + 5))
		{
//			if (bot_debug >= 1)
//			{
//				dprint(self.netname);
//				dprint(" parting shots\n");
//			}

			local entity p;
			p = SpawnTempEntity(self.suspicious_about);
			p.health = 999;

			self.goalentity = p;
			self.movetarget = p;
			self.enemy = p;

			// don't set these ... self.suspicious_about = en.origin;
			// don't set these ... self.suspicious_about_time = time;
		
			self.enemy_notice_time = 0;	// immediately kill
		
			self.bot_action = BOT_FIGHTING;

			return TRUE;
		}
	}
	*/

	return FALSE;
};
//====================================================
void () StopFighting =
{
//	if (bot_debug >= 4)
//	{
//		dprint(self.netname);
//		dprint(" StopFighting\n");
//	}

	if (self.bot_action == BOT_FIGHTING)
		self.bot_action = BOT_MOVING;
	self.think = BotAnimationThink;		// go back to BotAnimationThink animation
	self.extramove_oldthink = BotAnimationThink;
	self.button0 = FALSE;
	self.button1 = FALSE;
	self.angles_x = 0;
	
	if (self.goalentity.classname == "player" || self.goalentity.classname == "bot")
	if (self.goalentity.team != self.team)
	{
		self.goalentity = self;
		self.movetarget = self;
	}

	self.enemy = world;
};
//====================================================
// self is the bot
//====================================================
void() ContinueFighting =
{
	/*
	if (bot_debug >= 2)
	{
		dprint(self.netname);
		dprint(" ContinueFighting\n");
	}
	*/
	
	// continue to be suspicious about enemy location
	/*
	self.suspicious_about = self.enemy.origin;
	self.suspicious_about_time = time;
	*/

	// lower skill less likely to move while firing
 	if (random() < self.bsk_move_while_firing)
	{
		// attack not finished yet, so move toward enemy and aim
		if (random() < 0.7)
			MoveWhileFiring();
		else
			BotEvade(world);
	}

	BotLeadTarget(FALSE);
	
	// special case: stop fighting invisible players if they
	// turn out to be on our team
	if ((self.enemy.team == self.team) && (time > self.enemy.invisible_finished))
	{
		StopFighting();
	}
	else if (time > self.attack_finished)
	{
		// attack finished, so fire weapon again
		self.weapon = Bot_BestWeapon();
//TONY
//MULTIWEAPON
		if(temp1 & TEMP1_MULTI)
			set_player_weapon ();

		self.lastweapon_shot = self.weapon;
//TONY
//FIXME
//umm . . . I think I fucked up here:

		BotFireWeapon(FALSE);		// branch away from BotAnimationFrame
	}
};
//====================================================
// self is the bot
// should remember what direction we were strafing,
// and have a change to change it, instead of resetting
// every frame
//====================================================
void () MoveWhileFiring =
{
local float dist;
local float r, rad, moved;
local entity item, e;

//	if (bot_debug >= 2)
//	{
//		dprint(self.netname);
//		dprint(" MoveWhileFiring\n");
//	}
	
	self.extramove_oldthink = self.think;
	self.extramove_lastframewasextra = FALSE;
	
	moved = FALSE;
	
	BotLeadTarget(FALSE);
	
	/* buggy
	// special move-while-firing case:  when we have the flag,
	// try to keep moving along the waypoints instead of
	// moving directly toward enemy!  This will not always
	// be possible, as some waypoints require us to use the 
	// hook, but it may help.
	if ((map_has_waypoints) && (self.player_flag & ITEM_ENEMY_FLAG))
	{	
		moved = MoveTowardBase(FRIEND_BASE, FALSE);
	}
	*/

	// don't move while firing for lower-skilled bots
	// if (!MaybeTryNotToDrown())
	if (!moved)
	{
		if (random() < self.bsk_move_while_firing)
		{
			rad = 250;
			if (random() < 0.01)
				rad = rad + 200;

			dist = rad;		// smaller than normal; bot is distracted by combat
			item = FindNearbyItem(dist);

			if (((item.origin_z - self.origin_z) > 30) 
				|| ((item.origin_z - self.origin_z) < -30) )
				item = world;

			if (random() < 0.02)
				item = world;

			if (item != world)
			{
				BotEvade(item);
			}
			else
			{
				self.goalentity = self.enemy;
				self.movetarget = self.enemy;

				local float chance, dist;

				dist = vlen(self.enemy.origin - self.origin);

				if (dist > 100)
				{
					// enemy far

					if (self.enemy.player_flag & ITEM_ENEMY_FLAG)
						chance = 0.95;
					else
						chance = 0.8;
				}
				else
				{
					// enemy close

					chance = 0.7;
				}
		
				if (random() < chance)
					BotMoveTowardTarget();
				else
					BotEvade(world);
			}
		}
	}
};
//====================================================
// self is the bot
//====================================================
void () MaybeChangeYaw =
{
local float r;

	r = random();

	makevectors(self.angles);
	traceline (self.origin + '0 0 22', self.origin + '0 0 22' + (v_forward*40), FALSE, self);
	if ((trace_fraction < 1.0) || (random() < 0.3))
	{
		if (r < 0.10)
		{
			self.ideal_yaw = self.ideal_yaw + 30 + (((random() * 2) - 1) * 50);
			if (self.ideal_yaw > 360)
				self.ideal_yaw = self.ideal_yaw - 360;
			if (self.ideal_yaw < 0)
				self.ideal_yaw = 360 + self.ideal_yaw;
			ChangeYaw ();
		}
		else if (r < 0.40)
		{
			self.ideal_yaw = self.ideal_yaw + (((random() * 2) - 1) * 10);
			if (self.ideal_yaw > 360)
				self.ideal_yaw = self.ideal_yaw - 360;
			if (self.ideal_yaw < 0)
				self.ideal_yaw = 360 + self.ideal_yaw;
			ChangeYaw ();
		}
	}
};

//=============================================================
//=============================================================
entity (vector org) SpawnTempDebugMarker2 =
{
local entity e;

	e = spawn();
	e.classname = "debug_marker";
	e.owner = self;
	e.origin = org;
	setorigin(e, org);
	e.solid = SOLID_NOT;
	e.movetype = MOVETYPE_NONE;
	setmodel(e, "progs/s_bubble.spr");
	setsize (e, '0 0 0', '0 0 0');
	e.nextthink = time + 0.3;
	e.think = SUB_Remove; 
	return e;
};

//====================================================
// self is the bot
//====================================================
void(float perfect_accuracy) BotLeadTarget =
{
local   vector  move, vlead, evec, d, org, eorg, err1, err2, face_vec, ang;
local	float	fly, rng, misjudge_position, onground;

//	if (bot_debug >= 4)
//	{
//		dprint(self.netname);
//		dprint(" LeadTarget\n");
//	}
	
	if (self.enemy.classname == "player" || self.enemy.classname == "bot")
	{
		eorg = self.enemy.origin + '0 0 16';
		evec = self.enemy.velocity;
		if (!(self.enemy.flags & FL_ONGROUND))
			onground = FALSE;
	}
	else
	{
		eorg = self.enemy.absmax + self.enemy.absmin;
		eorg_x = eorg_x / 2;
		eorg_y = eorg_y / 2;
		eorg_z = eorg_z / 2;
		evec = '0 0 0';
	}
	
	org = self.origin + '0 0 16';

	face_vec = normalize((eorg + '0 0 8') - org);
	
	rng = vlen(org - eorg);
	
	local float e, ez;
	if ((self.weapon == IT_SHOTGUN) || (self.weapon == IT_SUPER_SHOTGUN))
	{
		e = 20;
		if (onground)
			ez = 20;
		else
			ez = 50;
	}
	else
	{
		e = 15;
		if (onground)
			ez = 20;
		else
			ez = 50;
	}

	// misjudge position... skill 3 is perfect accuracy		
	if (!perfect_accuracy)
	{
		err1_x = self.bot_skill_inverse * (rng * 0.005) * (((random() * 2) - 1) * e);
		err1_y = self.bot_skill_inverse * (rng * 0.005) * (((random() * 2) - 1) * e);
		err1_z = self.bot_skill_inverse * (rng * 0.005) * (((random() * 2) - 1) * ez);
		
		eorg_x = eorg_x + err1_x;
		eorg_y = eorg_y + err1_y;
		eorg_z = eorg_z + err1_z;
	}

	// misjudge velocity... skill 3 is perfect accuracy
	if (!perfect_accuracy)
	{
		err2_x = self.bot_skill_inverse * (((random() * 2) - 1) * (evec_x * 1));
		err2_y = self.bot_skill_inverse * (((random() * 2) - 1) * (evec_y * 1));
		err2_z = self.bot_skill_inverse * (((random() * 2) - 1) * (evec_z * 2));
	
		evec_x = evec_x + err2_x;
		evec_y = evec_y + err2_y;
		evec_z = evec_z + err2_z;
	}

	if ((self.weapon == IT_NAILGUN) || (self.weapon == IT_SUPER_NAILGUN))
	{
		if (self.player_flag & ITEM_RUNE3_FLAG)
			fly = vlen(eorg - org) / 2000;
		else
			fly = vlen(eorg - org) / 1000;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
		fly = vlen(eorg - org) / 1000;
	else if (self.weapon == IT_GRENADE_LAUNCHER)
		fly = vlen(eorg - org) / 600;
	else
		fly = 0;		// instantaneous

	d = eorg + fly * evec;			

	if (bot_debug >= 1)
		SpawnTempDebugMarker2(d);

	vlead = normalize (d - org);

	self.bot_aim = vlead;

	ang = vectoangles(face_vec);

	ang_x = ang_x / 3;

	if (face_vec_z < 0)
		ang_x = ang_x * -1;
	
	// limit up/down angles
	if (ang_x < -26.2)
		ang_x = -26.2;
	if (ang_x > 23)
		ang_x = 23;
		
	self.angles = ang;

	//self.ideal_yaw = vectoyaw(vlead);
	//ChangeYaw ();
};
//====================================================
// self is the bot
//====================================================
void(float perfect_accuracy) BotFireWeapon =
{
//	if (bot_debug >= 2)
//	{
//		dprint(self.netname);
//		dprint(" FireWeapon\n");
//	}

	if (!W_CheckNoAmmo())
		return;

	BotLeadTarget(perfect_accuracy);

	self.v_angle = self.angles;

	self.button0 = TRUE;		// make Bot_WeaponFrame think we are holding down button
	Bot_WeaponFrame();
	self.button0 = FALSE;
};
//====================================================
// self is the bot
// this routine makes the bot face its target and move 
// toward it
//====================================================
void() BotMoveTowardTarget =
{
//	if (bot_debug >= 3)
//	{
//		dprint(self.netname);
//		dprint(" MoveTowardTarget\n");
//	}

	if (self.enemy == world)
		return;

	BotLeadTarget(FALSE);

	MoveBot();
	//TEST REMOVE THIS BotLeadTarget(FALSE);
};
//====================================================
// self is the bot
// main think routine for the bot... figure out what to do
//====================================================
void() DropDown =
{	
//	if (bot_debug >= 2)
//	{
//		dprint(self.netname);
//		dprint(" drops down\n");
//	}	
	
	traceline (self.origin, self.origin + '0 0 -1000', TRUE, self);	// see through other monsters
	
	// fire hook immediately after dropping down, if over lava or slime
	if (trace_inopen && trace_inwater)
		if ((pointcontents(trace_endpos) == CONTENT_LAVA)
			|| (pointcontents(trace_endpos) == CONTENT_SLIME))
		{
			self.fire_hook_immediately = TRUE;

//			if (bot_debug >= 1)
//			{
//				dprint(self.netname);
//				dprint(" fire hook quick\n");
//			}	
		}
	
	self.button0 = FALSE;	// drop down
};
//====================================================
// self is the bot
// this routine makes the bot face its goal and move 
// toward it
//====================================================
void(float change_yaw) BotMoveTowardGoal =
{
local float should_fire_hook;
local float chance;

//	if (bot_debug >= 2)
//	{
//		dprint(self.netname);
//		dprint(" MoveTowardGoal\n");
//	}
	
	should_fire_hook = FALSE;
	if ((self.goalentity != self) && (hook_use_enabled))
	{
		chance = 0;
		if ((self.goalentity.origin_z - self.origin_z) > 30)	// above us
			chance = 0.04;
		else if ((self.goalentity.origin_z - self.origin_z) < -30)	// below us
			chance = 0.04;
		else if (vlen(self.goalentity.origin - self.origin) > 700)	// far away
			chance = 0.04;
		else if (self.get_item_stuck_count > 3)	// stuck on something
			chance = 0.04;
		else
			chance = 0.008;
		
		if (self.goalentity.classname == "player")
			chance = 0.1;
		else if (vlen(self.goalentity.velocity) != 0)
			chance = 0.0001;
			
		// try not to fire the hook if we are fighting
		if (self.bot_action == BOT_FIGHTING)
			chance = 0.01;
			
		//if (self.hook_out)
		//	chance = 0;
		
		//if (!(self.flags & FL_ONGROUND))
		//	chance = 0;
	
		if (random() < chance)
			should_fire_hook = TRUE;
	}
		
	if (!should_fire_hook)
	{
		//DropDown();

		if (self.goalentity != self)
		{
			local vector vyaw;
			vyaw = self.goalentity.origin - self.origin;
			vyaw_z = 0;
			vyaw = normalize(vyaw);
			//self.ideal_yaw = vectoyaw(vyaw);
			//ChangeYaw();
		}

		MoveBot();
	}
	else
	{
		if (self.goalentity != self)
		{
			local vector vyaw;
			local vector goalorg;
			
			vyaw = self.goalentity.origin - self.origin;
			vyaw_z = 0;
			vyaw = normalize(vyaw);
			//self.ideal_yaw = vectoyaw(vyaw);
			//ChangeYaw();
			
			if (self.goalentity.classname == "player")
				chance = 0.9;
			if (self.goalentity.classname == "bot")
				chance = 0.3;
			else
				chance = 0.1;
				
			// if the ceiling above entity is the sky, then 
			// we always need to fire hook directly at the
			// entity instead of firing at ceiling, because
			// hook can't be used with sky
			
			traceline (self.goalentity.origin, 
				self.goalentity.origin + '0 0 50000', TRUE, self);
			if (pointcontents(trace_endpos) == CONTENT_SKY)
			{
//				if (bot_debug >= 1)
//				{
//					dprint(self.netname);
//					dprint(" don't fire at sky\n");
//				}
				chance = 1.0;
			}

			if (random() < chance) 
			{
//				if (bot_debug >= 2)
//				{
//					dprint(self.netname);
//					dprint(" firing hook above entity\n");
//				}

				goalorg = (self.goalentity.origin);// + '0 0 20');
				MoveDebugMarker(goalorg);
				self.bot_aim = goalorg - (self.origin + '0 0 16');
				self.bot_aim = normalize(self.bot_aim);
			}
			else
			{
				traceline (self.goalentity.origin, 
					self.goalentity.origin + '0 0 50000', TRUE, self);
	
				if (TRUE)
				{
					local vector pos;
					pos = trace_endpos;
					
					traceline (self.origin + '0 0 16', pos, TRUE, self);
				
					if (trace_fraction == 1.0)
					{
//						if (bot_debug >= 2)
//						{
//							dprint(self.netname);
//							dprint(" firing hook at ceiling\n");
//						}
						MoveDebugMarker(pos);
						self.bot_aim = pos - (self.origin + '0 0 16');
						self.bot_aim = normalize(self.bot_aim);
					}
					else if (random() < 0.7)
					{
//						if (bot_debug >= 2)
//						{
//							dprint(self.netname);
//							dprint(" firing hook above entity 2\n");
//						}
						// can't see the ceiling above item, try to
						// aim just above and hope we snag it
						goalorg = (self.goalentity.origin);// + '0 0 20');
						goalorg_x = goalorg_x + ((random() * 2) - 1) * 5;
						goalorg_y = goalorg_y + ((random() * 2) - 1) * 5;
						goalorg_z = goalorg_z + ((random() * 2) - 1) * 5;
						MoveDebugMarker(goalorg);
						self.bot_aim = goalorg - (self.origin + '0 0 16');
						self.bot_aim = normalize(self.bot_aim);
					}
				}
			}
			BotFireHook();
		}
	}
};
//=============================================================
// self is the bot
//=============================================================
void (entity combat_item) BotEvade =
{
local float dist;
local float r, evade_yaw;

//	if (bot_debug >= 2)
//	{
//		dprint(self.netname);
//		dprint(" BotEvade\n");
//	}
	
	r = random();
	// evade based on skill... skill 3 always evade
	if (TRUE)		// if (r < self.bsk_evade_chance)
	{
		if (!smooth_move)
		{
			local float move_blocked, dist;
			local vector targorigin;
			local float oldlefty;
			
			/*
			local entity item;

			dist = 750;
			if (random() < 0.02)
				dist = dist + 200;
				
			item = world;
			
			//if (random() < 0.5)
			{
				item = FindNearbyItem(dist);
				
				if (item != world)
				{
					dprint("z dist = ");
					dprintfloat(item.origin_z - self.origin_z);
					dprint("\n");
				}
				else
					dprint("no item found\n");
					
				// don't go for items to far up/down
				//if (((item.origin_z - self.origin_z) > 50) 
				//	|| ((item.origin_z - self.origin_z) < -50) )
				//	item = world;
			}
			*/
			
			if (combat_item != world)
			{
//				if (bot_debug >= 1)
//				{
//					dprint(self.netname);
//					dprint(" going for ");
//					PrintItemName(combat_item);
//					dprint(" in combat\n");
//				}

				self.current_evade_yaw = vectoyaw(combat_item.origin - self.origin);
				targorigin = combat_item.origin;
			}
			else
			{
				self.current_evade_yaw = vectoyaw(self.enemy.origin - self.origin);

				if (random() < 0.03)
				{
//					if (bot_debug >= 1)
//					{
//						dprint(self.netname);
//						dprint(" switch strafe\n");
//					}

					self.lefty = !self.lefty;
				}
				else if (random() < 0.01)
				{
//					if (bot_debug >= 1)
//					{
//						dprint(self.netname);
//						dprint(" strafe away\n");
//					}

					oldlefty = self.lefty;
					self.lefty = 3;		// hack
				}

				if (self.lefty == 3)
				{
					self.current_evade_yaw = self.current_evade_yaw + 180;
					self.lefty = oldlefty;
				}
				else if (self.lefty)
					self.current_evade_yaw = self.current_evade_yaw + 90;
				else
					self.current_evade_yaw = self.current_evade_yaw - 90;

				self.current_evade_yaw = self.current_evade_yaw + (((random() * 2) - 1) * 10);
			
				targorigin = self.goalentity.origin;
			}
			
			if (self.current_evade_yaw < 0)
				self.current_evade_yaw = self.current_evade_yaw + 360;
			if (self.current_evade_yaw >= 360)
				self.current_evade_yaw = self.current_evade_yaw - 360;
			
			dist = GetMoveDist(targorigin - self.origin);
			
			move_blocked = !BotWalkMove(self.current_evade_yaw, dist);
			
			if (move_blocked)
			{
//				if (bot_debug >= 1)
//				{
//					dprint(self.netname);
//					dprint(" blocked\n");
//				}
				
				self.lefty = !self.lefty;
			
				/*
				self.current_evade_yaw + 180 + (((random() * 2) - 1) * 15);
				if (self.current_evade_yaw < 0)
					self.current_evade_yaw = self.current_evade_yaw + 360;
				if (self.current_evade_yaw >= 360)
					self.current_evade_yaw = self.current_evade_yaw - 360;
				*/
			}
		}
		else
		{
			makevectors(self.angles);
			self.velocity = self.velocity + (normalize(v_right) * 640);
		}	
	}
};
//=============================================================
//waterlevel;		// 0 = not in, 1 = feet, 2 = wast, 3 = eyes
//=============================================================
void() SetBotWaterLevel =
{
local vector start, end;
local float wlevel, wtype, fc, wc, ec;

	wlevel = 0; 
	wtype = CONTENT_EMPTY;
	
	// these offset values are very close to being perfect,
	// determined via testing
	
	fc = pointcontents(self.origin + '0 0 -23');
	wc = pointcontents(self.origin + '0 0 4');
	ec = pointcontents(self.origin + '0 0 22');
	
	if ((fc != CONTENT_EMPTY) || (wc != CONTENT_EMPTY) || (ec != CONTENT_EMPTY))
	{	
		if ((fc == CONTENT_WATER) || (wc == CONTENT_WATER) || (ec == CONTENT_WATER))
		{
			wlevel = 1; 
			wtype = CONTENT_WATER;
			
			if (wc == CONTENT_WATER)
				wlevel = 2; 
			if (ec == CONTENT_WATER)
				wlevel = 3; 
		}
		else if ((fc == CONTENT_SLIME) || (wc == CONTENT_SLIME) || (ec == CONTENT_SLIME))
		{
			wlevel = 1; 
			wtype = CONTENT_SLIME;
			
			if (wc == CONTENT_SLIME)
				wlevel = 2; 
			if (ec == CONTENT_SLIME)
				wlevel = 3; 
		}
		else if ((fc == CONTENT_LAVA) || (wc == CONTENT_LAVA) || (ec == CONTENT_LAVA))
		{
			wlevel = 1; 
			wtype = CONTENT_LAVA;
			if (wc == CONTENT_LAVA)
				wlevel = 2; 
			if (ec == CONTENT_LAVA)
				wlevel = 3; 
		}	
	}

	self.waterlevel = wlevel; 
	self.watertype = wtype;

//	if ((bot_debug >= 1) && (wlevel != 0))
//	if (wlevel != 0)
//	{
//		dprint(self.netname);
//		dprint(" in ");
//		if (wtype == CONTENT_WATER)
//			dprint("water");
//		else if (wtype == CONTENT_SLIME)
//			dprint("slime");
//		else if (wtype == CONTENT_LAVA) 
//			dprint("lava");
//		dprint(" to ");
//		if (wlevel == 1)
//			dprint("feet [1]\n");
//		else if (wlevel == 2)
//			dprint("waist [2]\n");
//		else if (wlevel == 3)
//			dprint("eyes [3]\n");
//	}
};
//=============================================================
//=============================================================
void() BotPreThink =
{
//local float wlevel;
//local float wtype;

//	if (bot_debug >= 3)
//	{
//		dprint(self.netname);
//		dprint(" PreThink\n");
//	}


	CheckRules ();

//TONY
//UMMMM . . . duh
//SMALL COPY AND PASTE
//HUGE HUGE HUGE HUGE HUGE HUGE HUGE FIX
	// optimization: don't do this every frame, because it is slow

//TONY
//TEST
	if (!(teamplay & TEAM_NORSE_MOVEMENT))
	{

	if (time >= self.watermove_time)
	{
		SetBotWaterLevel();
	 	self.old_waterlevel = self.waterlevel; 
		self.old_watertype = self.watertype;

		WaterMove ();		// try to drown bot
		self.watermove_time = time + 0.3;
	}
	else
	{
	 	self.waterlevel = self.old_waterlevel; 
		self.watertype = self.old_watertype;
	}
	// end optimization

//TONY END
//TEST
	}
	

	// don't do this for bots, pretty much pointless
	// because bots never really try to escape and
	// this can cause no free edits with lots of bots
	// SpawnFollowEntity();

	if (self.health <= 0)
	{
		self.think = PlayerDie;	// special case required in case we drown?
	}
	else
	{
		if (self.waterlevel == 2)
			CheckWaterJump();
	}

};
//=============================================================
//=============================================================
void() BotPostThink =
{
//	if (bot_debug >= 3)
//	{
//		dprint(self.netname);
//		dprint(" PostThink\n");
//	}



	// if we are jumping from a height, play the appropriate sounds
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if ((self.watertype == CONTENT_WATER) && (self.waterlevel > 0))
		{
// tony
// sex sounds
		if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
			sound (self, CHAN_BODY, "player2/h2ojump.wav", 1, ATTN_NORM);
		else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
			sound (self, CHAN_BODY, "player3/h2ojump.wav", 1, ATTN_NORM);
		else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
			sound (self, CHAN_BODY, "player4/h2ojump.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		}
		else if (self.jump_flag < -650)	// very high
		{
//TONY
//NO FALL DAMAGE
			if(!(deathmatch & DM_NO_FALLING))
				T_Damage (self, world, world, 5);
 
// tony
// sex sounds
		if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
			sound (self, CHAN_VOICE, "player2/land2.wav", 1, ATTN_NORM);
		else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
			sound (self, CHAN_VOICE, "player3/land2.wav", 1, ATTN_NORM);
		else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
			sound (self, CHAN_VOICE, "player4/land2.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			self.deathtype = "falling";
		}
		else
		{
// tony
// sex sounds
		if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
			sound (self, CHAN_VOICE, "player2/land.wav", 1, ATTN_NORM);
		else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
			sound (self, CHAN_VOICE, "player3/land.wav", 1, ATTN_NORM);
		else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
			sound (self, CHAN_VOICE, "player4/land.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
		}

		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;

	CheckPowerups();
};
//====================================================
// self is the bot
//====================================================
float(entity targ) EntityInFieldOfView =
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	
	// skill 3 is total 360-degree awareness
	// skill 1 is like a monster... 0.3
	if (dot > self.bsk_bot_fov)
	{
		return TRUE;
	}
	return FALSE;
};

//====================================================
// return TRUE if we know what we are doing (i.e we moved
// toward a waypoint, we are defending.
// return FALSE if we are kinda lost
//====================================================
float (float enemy_base, float change_yaw) MoveTowardBase = 
{
local entity e;
local float team_lo, team_hi;

	// optimization: if we are standing looking at our own
	// flag, then just keep doing that 
	
	//if ((self.bot_plan == BOT_DEFEND) && (self.bot_action == BOT_STANDING))
	//	return FALSE;

	// optimization: don't look for waypoints every frame,
	// because it is slow
	
	if (time < self.next_waypoint_time)
		return FALSE;
		
	self.next_waypoint_time = time + 0.35;

	// end optimization

	if (enemy_base)
	{
		// go to enemy base
		team_lo = self.enemy_team;
		team_hi = self.team;
	}
	else
	{
		// go to friend base
		team_lo = self.team;
		team_hi = self.enemy_team;
	}

	// optimization -- if we are already there, don't keep searching
	if (self.goalentity.classname == "waypoint")
	{
//TONY
//This bot should use defensive points so
//skip the next part?
		if (!((self.use_defensive_way == 1) && (self.bot_plan == BOT_DEFEND) && (team_lo == self.team)))
		{
		if (self.goalentity.team == team_lo)
		if (self.goalentity.waypoint_num == 0)
		{

//			if (bot_debug >= 2)
//			{
//				dprint(self.netname);
//				dprint(" waypoint optimization\n");
//			}

			BotMoveTowardGoal(change_yaw);
			return TRUE;
		}
		}//bot is not defensize waypoint user

//keep bots on their chosen defensive spot
		if ((self.use_defensive_way == 1) && (self.bot_plan == BOT_DEFEND) && (team_lo == self.team))
		if (self.goalentity.waypoint_num == -1)
		{
			BotMoveTowardGoal(change_yaw);
			return TRUE;
		}
	}

	e = BotFindLeastWaypoint(team_lo);
	if (e != world)
	{			
//		if (bot_debug >= 2)
//		{
//			dprint(self.netname);
//			dprint(" ");
//			dprintfloat(self.team);
//			dprint(" ");
//			dprintfloat(self.enemy_team);
//			dprint(" found waypoint ");
//			dprintfloat(e.waypoint_num);
//			dprint(" ");
//			dprintfloat(e.team);
//			dprint(" def_Way: ");
//			dprintfloat(self.use_defensive_way);
//			dprint("\n");
//		}

		self.goalentity = e;
		self.movetarget = e;
		self.enemy = world;

		BotMoveTowardGoal(change_yaw);
		return TRUE;
	}
	else
	{
		local float fteam;

		e = BotFindGreatestWaypoint(team_hi);
		if (e != world)
		{			
//			if (bot_debug >= 2)
//			{
//				dprint(self.netname);
//				dprint(" ");
//				dprintfloat(self.team);
//				dprint(" ");
//				dprintfloat(self.enemy_team);
//				dprint(" found waypoint ");
//				dprintfloat(e.waypoint_num);
//				dprint(" ");
//				dprintfloat(e.team);
//				dprint("\n");
//			}

			self.goalentity = e;
			self.movetarget = e;
			self.enemy = world;

			BotMoveTowardGoal(change_yaw);
			return TRUE;
		}
		else
		{
			// can't find either red or blue path, so fall back to
			// general path, which should bring us to where the action is.
			// general paths start with zero in the central area, and
			// then go outward increasing from there.  They have a team
			// of -1.
			e = BotFindLeastWaypoint(-1);
			if (e != world)
			{			
//				if (bot_debug >= 2)
//				{
//					dprint(self.netname);
//					dprint(" ");
//					dprint(" found general waypoint ");
//					dprintfloat(e.waypoint_num);
//					dprint("\n");
//				}

				self.goalentity = e;
				self.movetarget = e;
				self.enemy = world;

				BotMoveTowardGoal(change_yaw);
				return TRUE;
			}
		}
	}
	
	return FALSE;
};
//====================================================
// self is the bot
//====================================================
float (float fteam) NumBotsDefending =
{
local entity p;
local float nm;
	
	nm = 0;
	p = find(world, classname, "bot");
	while (p != world)
	{
		if (p.team == fteam)
		if (p.bot_plan == BOT_DEFEND)
			nm = nm + 1;
		p = find(p, classname, "bot");
	}
	
	return nm;
};

//====================================================
// self is the bot
//====================================================
float() MaybeGoToTempWaypoint =
{
local entity e;

	// first look for temp waypoints
	e = BotFindClosestTempWaypoint(self.team);
	if (e != world)
	{
//		if (bot_debug >= 1)
//		{
//			dprint(self.netname);
//			dprint(" ");
//			dprint(" found temporary waypoint");
//			dprint("\n");
//		}

		self.goalentity = e;
		self.movetarget = e;
		self.enemy = world;

		BotMoveTowardGoal(TRUE);
		return TRUE;
	}
	return FALSE;
};
//====================================================
// self is the bot
// this routine isn't even called if the bot has the flag,
// in that case we always go toward our base.
//====================================================
void() SetBotPlan =
{
local entity flag, eflag;
local float nm;
local float r;
local float oldplan, numbots;

	oldplan = self.bot_plan;
	
	// already camping, don't attack/defend/roam
	if (time < (self.camping_time + CAMPING_TIME))
		return;
		
	// already escorting, don't attack/defend/roam
	if (time < (self.escort_time + ESCORT_TIME))
		return;

	if (IsHumanOnTeam(self.team))
	{
		// much less chance of randomly deciding what to do
		if (random() < 0.9)
			return;
	}

	if (self.team == TEAM_COLOR1)
	{
		flag = find(world, classname, "item_flag_team1");
		eflag = find(world, classname, "item_flag_team2");
		numbots = next_bot_red;
	}
	else if (self.team == TEAM_COLOR2)
	{
		flag = find(world, classname, "item_flag_team2");
		eflag = find(world, classname, "item_flag_team1");
		numbots = next_bot_blue;
	}
	
	if (self.bot_plan == BOT_ATTACK)
	{
		nm = NumBotsDefending(self.team);
		if ((nm < (numbots / 2)) && ((flag.cnt == FLAG_AT_BASE) || (eflag.cnt == FLAG_CARRIED) ))
		{
			if (random() < 0.02)			// no defenders, so very large chance
			{
				self.bot_plan = BOT_DEFEND;
			}
		}
		else if (self.player_flag & ITEM_RUNE3_FLAG)		// haste
		{
			if (random() < 0.01)
			{
				self.bot_plan = BOT_DEFEND;
			}
		}
		else if (self.player_flag & ITEM_RUNE4_FLAG)		// regeneration
		{
			if (random() < 0.01)
			{
				self.bot_plan = BOT_DEFEND;
			}
		}	
		else if (random() < 0.001)		// chance to start defending
		{
			self.bot_plan = BOT_DEFEND;
		}
		else if (random() < 0.001)		// chance to start roaming
		{
			self.bot_plan = BOT_ROAM;
		}
	}
	else if (self.bot_plan == BOT_DEFEND)
	{
		if ((time < self.super_damage_finished) 
			|| (time < self.invisible_finished)
			|| (time < self.invincible_finished))
		{
			self.bot_plan = BOT_ATTACK;
		}
		else if ((time < (last_flag_capture + 10)) 
			&& (self.team == last_capture_team))
		{
			// we just captured, so attack again immediatley!
			if (random() < 0.02)
			{
				self.bot_plan = BOT_ATTACK;
			}
		}
		else if ((flag.cnt == FLAG_CARRIED) && (eflag.cnt == FLAG_CARRIED))
		{
			if (!(self.player_flag & ITEM_ENEMY_FLAG))		// sanity check
			if (random() < 0.02)
			{
				self.bot_plan = BOT_ATTACK;

//				if (bot_debug >= 1)
//				{
//					dprint(self.netname);
//					dprint(" flush out flag carrier\n");
//				}			
			}
		}
		else if (self.player_flag & ITEM_RUNE1_FLAG)		// resistance
		{
			if (random() < 0.01)
			{
				self.bot_plan = BOT_ATTACK;
			}
		}
		else if (self.player_flag & ITEM_RUNE2_FLAG)		// strength
		{
			if (random() < 0.01)
			{
				self.bot_plan = BOT_ATTACK;
			}
		}
		else if (random() < 0.001)
		{
			self.bot_plan = BOT_ATTACK;
		}
		else if (random() < 0.001)
		{
			self.bot_plan = BOT_ROAM;
		}
	}
	else
	{
		nm = NumBotsDefending(self.team);	
		
		if ((time < self.super_damage_finished) 
			|| (time < self.invisible_finished)
			|| (time < self.invincible_finished))
		{
			self.bot_plan = BOT_ATTACK;
		}
		else if ((nm < (numbots / 2)) && ((flag.cnt == FLAG_AT_BASE) || (eflag.cnt == FLAG_CARRIED) ))
		{
			if (random() < 0.02)			// no defenders, so very large chance
			{
				self.bot_plan = BOT_DEFEND;
			}
		}
		else if ((flag.cnt == FLAG_CARRIED) && (eflag.cnt == FLAG_CARRIED))
		{
			if (!(self.player_flag & ITEM_ENEMY_FLAG))		// sanity check
			if (random() < 0.02)
			{
				self.bot_plan = BOT_ATTACK;

//				if (bot_debug >= 1)
//				{
//					dprint(self.netname);
//					dprint(" flush out flag carrier\n");
//				}			
			}
		}
		else if ((time < (last_flag_capture + 10)) 
			&& (self.team == last_capture_team))
		{
			// we just captured, so attack again immediatley!
			if (random() < 0.02)
			{
				self.bot_plan = BOT_ATTACK;
			}
		}
		else if (random() < 0.001)
		{
			self.bot_plan = BOT_DEFEND;
		}
		else if (random() < 0.001)
		{
			self.bot_plan = BOT_ATTACK;
		}
	}
			
//	if ((bot_debug >= 1) && (self.bot_plan != oldplan))
//	{
//		if (self.bot_plan == BOT_ATTACK)
//		{
//			dprint(self.netname);
//			dprint(" decides to attack\n");
//		}
//		else if (self.bot_plan == BOT_DEFEND)
//		{
//			dprint(self.netname);
//			dprint(" decides to defend\n");
//		}
//		else if (self.bot_plan == BOT_ROAM)
//		{
//			dprint(self.netname);
//			dprint(" decides to be a roaming killer\n");
//		}
//	}
};
//====================================================
// this routine sets goals for the bot based on what is going on 
// in the game.  E.g. if the bot has the flag, we try to escape
// to our base.  If the bot is near a player, follow him around.
// If the bot is a defender, then go back toward own flag.  these
// are goals that aren't fighting or getting stuff.  
//====================================================
float() SetSpecialGoals =
{
local entity p, e;
local float maxrad, moved;

	moved = FALSE;

	if ((map_has_waypoints) && (self.player_flag & ITEM_ENEMY_FLAG))
	{	
		moved = MoveTowardBase(FRIEND_BASE, TRUE);
	}
	
	if (!moved)
	{
		e = HelpTeammate(self, 600);
		if (e != world)
		{
			if (e.classname == "follow_ent")
			{
				// can't see enemy, but can see enemy follow entities, so
				// move toward those entities and hopefully keep fighting
				local entity old_goal;
				old_goal = self.goalentity;

				self.goalentity = e;
				self.movetarget = e;

				BotMoveTowardGoal(TRUE);

				self.goalentity = old_goal;
				self.movetarget = old_goal;
				return TRUE;
			}
			else if (vlen(e.origin - self.origin) > 150)	// not too close
			{
				self.goalentity = e;
				self.movetarget = e;
				self.enemy = world;
				
				if (e.classname == "player")	// must be escorting
				{
					//if (e.player_flag & ITEM_ENEMY_FLAG)
					//	BotSayEscortFlag(e);
					if ((self.escort_entity == e) || (e.observer_flags & PLAYER_ALWAYS_ESCORT))
						BotSayEscort(e);
				}
			
				BotMoveTowardGoal(TRUE);
				return TRUE;
			}
		}
		else if (time < (self.camping_time + CAMPING_TIME))
		{
//			if (bot_debug >= 1)
//			{
//				dprint(self.netname);
//				dprint(" camping\n");
//			}
			
			self.goalentity = self.camping_entity;
			self.movetarget = self.camping_entity;
			self.enemy = world;
			BotMoveTowardGoal(TRUE);
			return TRUE;		
		}
		else if (map_has_waypoints)
		{
			SetBotPlan();		// should we attack or defend?
			
			if (self.bot_plan == BOT_ATTACK)
			{
				moved = MoveTowardBase(ENEMY_BASE, TRUE);
//				if ((moved) && (bot_debug >= 1))
//				{
//					dprint(self.netname);
//					dprint(" go to enemy base\n");
//				}
			}
			
			if (!moved)
			if (self.bot_plan == BOT_DEFEND)
			{
				moved = MoveTowardBase(FRIEND_BASE, TRUE);
//				if ((moved) && (bot_debug >= 1))
//				{
//					dprint(self.netname);
//					dprint(" go to friend base\n");
//				}
			}
		}
	}
	
	return moved;
};

//====================================================
// self is the bot
//====================================================
void(float old_dist, entity goal_item) CheckStuck =
{
	if (goal_item != world)
	{
		if ((old_dist - vlen(self.origin - goal_item.origin)) < 5)
		{
			self.get_item_stuck_count = self.get_item_stuck_count + 1;

//			if (bot_debug >= 1)
//			{
//				dprint(self.netname);
//				dprint(" stuck ");
//				dprintfloat(self.get_item_stuck_count);
//				dprint("\n");
//			}

			if ((self.get_item_stuck_count > 10) && (num_inaccessible_entities < 15))
			{
				self.get_item_stuck_count = 0;
				SpawnInaccessibleFromHere(goal_item);
			}
		}
	}
};

//====================================================
// self is the bot
//====================================================
float() MaybeGetItems =
{
local entity item;
local float dist;
	
	if (time > self.large_dist_pulse_items)
	{
		self.large_dist_pulse_items = time + self.bsk_next_pulse_time_items;
		dist = item_large_pulse_dist;
		if (random() < 0.02)
			dist = dist + self.bsk_extra_large_pulse_dist;
	}
	else
	{
 	 	// awareness radius of bot... higher for higher skill levels
		dist = item_awareness_dist;
	}

	item = FindNearbyItem(dist);
	if (item != world)
	{
		if (item != self.goalentity)
			self.get_item_stuck_count = 0;
			
		self.goalentity = item;
		self.movetarget = item;
		self.enemy = world;
		
		local float old_dist;
		old_dist = vlen(self.origin - self.goalentity.origin); 	
		
		BotMoveTowardGoal(TRUE);	
		
		CheckStuck(old_dist, self.goalentity);
		
		return TRUE;	
	}

	return FALSE;
};
//====================================================
// self is the bot
//====================================================
float () BotCloseToShootWaypoint =
{
local float best_waypoint_num;
local entity selected, e;

	best_waypoint_num = 999999;
	selected = world;
	
	if (self.team == TEAM_COLOR1)
		e = wp_first_red;
	else if (self.team == TEAM_COLOR2)
		e = wp_first_blue;
	else if (self.team == -1)	
		e = wp_first_general;
	
	while (e != world)
	{


		e = e.wp_chain;
	}
};
//====================================================
// self is the bot
//====================================================
float (float force_search) MaybeShootTriggers =
{
local entity selected, e;
local float dist, best_dist;
local vector org, selected_org;

	if ((time < self.trigger_search_time) && (!force_search))
		return;
		
	self.trigger_search_time = time + 7 * (random() * 5);
		
	dist = 150;
	//if (random() < (0.001 + (self.bot_skill * 0.002)))
		dist = dist + 400;
		
	best_dist = 999999999;
	e = find(world, classname, "door");
	while(e)
	{
		org = e.absmin + e.absmax;
		org_x = org_x / 2;
		org_y = org_y / 2;
		org_z = org_z / 2;
	
		if (BotCanSeePoint(org)) 
		{
			if (vlen(self.origin - org) < best_dist)
			{
				if (e.health > 0)
				{
					selected = e;
					selected_org = org;
					best_dist = vlen(self.origin - org);
				}
			}
		}
		e = find(e, classname, "door");
	}
	if ((selected != world) && (random() < 0.8))
	{
		best_dist = 999999999;
		e = find(world, classname, "func_button");
		while(e)
		{
			org = e.absmin + e.absmax;
			org_x = org_x / 2;
			org_y = org_y / 2;
			org_z = org_z / 2;

			if (BotCanSeePoint(org))  
			{
				if (vlen(self.origin - org) < best_dist)
				{
					if (e.health > 0)
					{
						selected = e;
						selected_org = org;
						best_dist = vlen(self.origin - org);
					}
				}
			}
			e = find(e, classname, "func_button");
		}
	}
	
	if (selected != world) 
	{
		if (random() < 0.25)
		{
//			if (bot_debug >= 1)
//			{
//				dprint(self.netname);
//				dprint(" shoot trigger\n");
//			}

			local entity old_enemy;
			old_enemy = self.enemy;
			self.enemy = selected;
			if ((time > self.attack_finished) && (self.ammo_shells > 0))
			{
				//self.bot_action = BOT_MOVING;
				self.weapon = IT_SHOTGUN;
//TONY
//MULTIWEAPON
	if(temp1 & TEMP1_MULTI)
		set_player_weapon ();

				BotFireWeapon(TRUE);		// branch away from BotAnimationFrame
				if (selected.classname == "door")
					SpawnTempWaypoint(selected_org, 15, self.team);	// go toward door
			}
			self.enemy = old_enemy;

			return TRUE;	
		}
	}

	return FALSE;
};
//====================================================
// this routine used when firing hook to get out of water
// self is the bot
// return TRUE if new better than old
//====================================================
float (entity newwp, entity oldwp) WaypointBetter =
{	
	// any waypoint better than none
	if (oldwp == world)
		return TRUE;
		
	if (self.bot_plan == BOT_ATTACK)
	{
		// want to go toward higher-number waypoints of our team,
		// lower-number waypoint of enemy team
		if ((newwp.team == self.team) && (oldwp.team == self.team))
		{	
			// both new and old are our team, go toward highest num
			if (newwp.waypoint_num == oldwp.waypoint_num)
			{
				// both new and old are same num, go toward closest
				if (vlen(newwp.origin - self.origin) < vlen(oldwp.origin - self.origin))
					return TRUE;
			}
			else if (newwp.waypoint_num < oldwp.waypoint_num)
			{
				// we are attacking, so we want higher waypoints on our team
				return FALSE;
			}
			else if (newwp.waypoint_num > oldwp.waypoint_num)
			{
				// we are attacking, so we want higher waypoints on our team
				return TRUE;
			}			
		}
		else if ((newwp.team == self.team) && (oldwp.team != self.team))
		{
			// always go toward enemy team waypoint if attacking
			return FALSE;
		}
		else if ((newwp.team != self.team) && (oldwp.team == self.team))
		{
			// always go toward enemy team waypoint if attacking
			return TRUE;
		}
		else if ((newwp.team != self.team) && (oldwp.team != self.team))
		{
			// both waypoints are enemy team, go toward lowest num
			if (newwp.waypoint_num == oldwp.waypoint_num)
			{
				// both new and old are same num, go toward closest
				if (vlen(newwp.origin - self.origin) < vlen(oldwp.origin - self.origin))
					return TRUE;
			}
			else if (newwp.waypoint_num < oldwp.waypoint_num)
			{
				// we are attacking, so we want lower waypoints on enemy team
				return TRUE;
			}
			else if (newwp.waypoint_num > oldwp.waypoint_num)
			{
				// we are attacking, so we want lower waypoints on enemy team
				return FALSE;
			}			
		}
	}
	else if (self.bot_plan == BOT_DEFEND)
	{
		// want to go toward lower-number waypoints of our team,
		// higher-number waypoint of enemy team
		if ((newwp.team == self.team) && (oldwp.team == self.team))
		{	
			// both new and old are our team, go toward highest num
			if (newwp.waypoint_num == oldwp.waypoint_num)
			{
				// both new and old are same num, go toward closest
				if (vlen(newwp.origin - self.origin) < vlen(oldwp.origin - self.origin))
					return TRUE;
			}
			else if (newwp.waypoint_num < oldwp.waypoint_num)
			{
				// we are defending, so we want lower waypoints on our team
				return TRUE;
			}
			else if (newwp.waypoint_num > oldwp.waypoint_num)
			{
				// we are defending, so we want lower waypoints on our team
				return FALSE;
			}			
		}
		else if ((newwp.team == self.team) && (oldwp.team != self.team))
		{
			// always go toward friend team waypoint if defending
			return TRUE;
		}
		else if ((newwp.team != self.team) && (oldwp.team == self.team))
		{
			// always go toward friend team waypoint if defending
			return FALSE;
		}
		else if ((newwp.team != self.team) && (oldwp.team != self.team))
		{
			// both waypoints are enemy team, go toward highest num
			if (newwp.waypoint_num == oldwp.waypoint_num)
			{
				// both new and old are same num, go toward closest
				if (vlen(newwp.origin - self.origin) < vlen(oldwp.origin - self.origin))
					return TRUE;
			}
			else if (newwp.waypoint_num < oldwp.waypoint_num)
			{
				// we are defending, so we want higher waypoints on enemy team
				return FALSE;
			}
			else if (newwp.waypoint_num > oldwp.waypoint_num)
			{
				// we are defending, so we want higher waypoints on enemy team
				return TRUE;
			}			
		}
	}
	else
	{
		// bot is either roaming or camping or escorting, so
		// for now just randomize what we do
		if (random() < 0.3)
			return TRUE;
	}
	
	return FALSE;
};
//====================================================
//====================================================
float () FireHookAtBestOutOfWaterWaypoint =
{
local float best_dist;
local vector selected_pos;
local entity e, selected, selected_wp;
	
	selected_pos = '0 0 0';
	selected_wp = world;
	best_dist = 9999999999;
	e = find(world, classname, "waypoint");
	while(e != world)
	{
		if (pointcontents(e.origin) != CONTENT_WATER)
		if (pointcontents(e.origin) != CONTENT_SLIME)
		if (pointcontents(e.origin) != CONTENT_LAVA)
		{
			traceline (e.origin, e.origin + '0 0 50000', TRUE, self);

			local vector pos;
			pos = trace_endpos;
			
			if (BotCanSeePointThroughWater(pos))
			{
				local float wp_better;
				wp_better = WaypointBetter(e, selected_wp);
				if ((wp_better) || (selected_pos == '0 0 0'))
				{
					selected_pos = pos;
					selected_wp = e;
					best_dist = vlen(e.origin - self.origin);
				}
			}

		}
		e = find(e, classname, "waypoint");
	}

	if (selected_pos != '0 0 0')
	{
		MoveDebugMarker(selected_pos);
		self.bot_aim = selected_pos - (self.origin + '0 0 16');
		self.bot_aim = normalize(self.bot_aim);
		BotFireHook();

//		if (bot_debug >= 1)
//		{
//			dprint(self.netname);
//			dprint(" found out of water waypoint\n");
//		}
		
		return TRUE;
	}

	return FALSE;
};

//====================================================
//====================================================
void (entity ent) BotFireHookAtEntity =
{
local vector org;

	if (!hook_use_enabled)
		return;

	if (time > self.attack_finished)
	{
//		if (bot_debug >= 2)
//		{
//			dprint(self.netname);
//			dprint(" BotFireHookAtEntity\n");
//		}
		
		org = ent.origin;
		MoveDebugMarker(org);
		self.bot_aim = org - self.origin;
		self.bot_aim = normalize(self.bot_aim);

		BotFireHook();
	}
};
//====================================================
//====================================================
void (float zdist) BotFireHookUpRandomly =
{
local vector org;

	if (!hook_use_enabled)
		return;

	if (time > self.attack_finished)
	{
//		if (bot_debug >= 2)
//		{
//			dprint(self.netname);
//			dprint(" BotFireHookUpRandomly\n");
//		}
		
		org = self.origin;
		org_z = org_z + zdist;
		org_x = org_x + ((random() * 2) - 1) * 50;
		org_y = org_y + ((random() * 2) - 1) * 50;
		MoveDebugMarker(org);
		self.bot_aim = org - self.origin;
		self.bot_aim = normalize(self.bot_aim);

		//self.bot_action = BOT_MOVING;
		BotFireHook();
	}
};
//====================================================
// self is the bot
//====================================================
float () MaybeGetOutOfWater =
{
	if (self.hook_out)
		return;
		
	if (time < self.getoutofwater_time)
		return FALSE;
	
	self.getoutofwater_time = time + 1;

	if (self.watertype == CONTENT_WATER)
	{
		if (self.waterlevel == 3)
		{
//			if (bot_debug >= 1)
//			{
//				dprint(self.netname);
//				dprint(" wants out of water\n");
//			}
	
			if (FireHookAtBestOutOfWaterWaypoint())
				return TRUE;
		}
	}

	return FALSE;
};
//====================================================
// self is the bot
//====================================================
float () MaybeTryNotToDrown =
{
local entity e;

	if (self.watertype == CONTENT_WATER)
	{
		if ((self.waterlevel == 3) && ((self.air_finished - 4) < time))
		{
//			if (bot_debug >= 1)
//			{
//				dprint(self.netname);
//				dprint(" try not to drown\n");
//			}
	
			if (!FireHookAtBestOutOfWaterWaypoint())
				BotFireHookUpRandomly(1500);

			return TRUE;
		}
	}
	else if ((self.watertype == CONTENT_SLIME) || (self.watertype == CONTENT_LAVA))
	{
//		if (bot_debug >= 1)
//		{
//			dprint(self.netname);
//			dprint(" try to get out of slime\n");
//		}
		
		if (!FireHookAtBestOutOfWaterWaypoint())
			BotFireHookUpRandomly(1500);
	
		return TRUE;
	}

	return FALSE;
};
//====================================================
// self is the bot
//====================================================
float () MaybeFireHook =
{
	if (random() < 0.002)
	{
		if (time > self.attack_finished)
		{
//			if (bot_debug >= 2)
//			{
//				dprint(self.netname);
//				dprint(" decides to fire hook\n");
//			}
			
			//self.bot_action = BOT_MOVING;
			BotFireHookUpRandomly(100);

			return TRUE;
		}
	}

	return FALSE;
};
//====================================================
// self is the bot
//====================================================
float() PlayerIsClose =
{
local entity head;

	head = find(world, classname, "player");
	while(head)
	{
		if (vlen(self.origin - head.origin) < 40)
		if (head.team == self.team)
		if (!(head.observer_flags & PLAYER_NO_TARGET))
		if (!head.observer)
		{
			return TRUE;
		}
			
		head = find(head, classname, "player");
	}
	
	return FALSE;
};
//====================================================
// self is the bot
//====================================================
float() BotCanSeeHisFlagAtBase =
{
local entity flag;

	if (self.team = TEAM_COLOR1)
		flag = find(world, classname, "item_flag_team1");
	else if (self.team = TEAM_COLOR2)
		flag = find(world, classname, "item_flag_team2");
		
	if (self.bot_plan == BOT_DEFEND)
	if (flag.cnt == FLAG_AT_BASE)
	{
		if (BotCanSeeItem(flag)) 
		{
			return TRUE;
		}
	}
	
	return FALSE;
};
//====================================================
// self is the bot
//====================================================
float() BotShouldStand =
{		
	if (self.bot_plan == BOT_DEFEND)
	if (BotCanSeeHisFlagAtBase())
	{
		if (random() < 0.3)
		{
			dprint(self.netname);
			dprint(" decides to stand\n");
			return TRUE;
		}
	}
	
	if (random() < 0.003)
	{
		return TRUE;
	}
	
	return FALSE;
};
//====================================================
// self is the bot
//====================================================
void() NothingToDo =
{
//	if (bot_debug >= 1)
//	{
//		dprint(self.netname);
//		dprint(" has nothing to do\n");
//	}	

	// nothing else to do, so just explore randomly
	MaybeChangeYaw();

	MoveBot();

	/*
	if (self.bot_action == BOT_STANDING)
	{
		if (PlayerIsClose())
		{
//			if (bot_debug >= 1)
//			{
//				dprint(self.netname);
//				dprint(" getting out of the way\n");
//			}	

			self.bot_action = BOT_MOVING;			
		}
		else if (random() < 0.006)
		{
//			if (bot_debug >= 1)
//			{
//				dprint(self.netname);
//				dprint(" decides to stroll\n");
//			}	

			self.bot_action = BOT_MOVING;
		}
		else
		{
//			if (bot_debug >= 1)
//			{
//				dprint(self.netname);
//				dprint(" is standing\n");
//			}	

			MaybeChangeYaw();
		}
	}
	else
	{
		local float shouldstand;
		shouldstand = BotShouldStand();
		if (shouldstand)
		{
//			if (bot_debug >= 1)
//			{
//				dprint(self.netname);
//				dprint(" decides to stand\n");
//
//				self.bot_action = BOT_STANDING;
//			}	
//TONY
//THIS WAS IN THE IF BLOCK
//SHOULD IT BE HERE?
			self.bot_action = BOT_STANDING;
		}
		else
		{
			// nothing else to do, so just explore randomly
			MaybeChangeYaw();

			MoveBot();
		}
	}
	*/
};
//====================================================
// self is the bot
//====================================================
void() CheckGiveUpCamping =
{	
	if ((time < (self.camping_time + CAMPING_TIME)) && (self.camping_entity != world))
	{
		if (BotCanSeeItem(self.camping_entity))
		{
			self.last_see_camp_ent = time;
		}
		else
		{
			// haven't seen camping entity for 30 seconds...
			// we are probably lost, so give up
			
			if (time > (self.last_see_camp_ent + 30))
			{
				BotSayTeamStart2();
				BotSayTeamMiddle("I'm going to stop camping");
				BotSayTeamEnd();
				
				self.camping_time = time - 999;
				remove(self.camping_entity);
				self.camping_entity = world;
			}
		}
	}
};
//====================================================
// self is the bot
// main think routine for the bot... figure out what to do
//====================================================
void() BotThink =
{	
local float visi;
local entity follow_ent, old_goal;

	self.extramove_oldthink = self.think;
	
	self.nextthink = time + 0.1;

//	if (bot_debug >= 3)
//	{
//		dprint(self.netname);
//		dprint(" Think\n");
//	}

	self.extramove_lastframewasextra = FALSE;
	
	if (self.health <= 0) 
		return;

	BotPreThink();

	if (self.health <= 0) 	// BotPreThink may have killed bot by drowning
		return;

	// this is just to make the animation look nice, with the bot
	// running around with the gun instead of the axe... we will always
	// choose our best weapon right before attacking

//TONY
//MULTIWEAPON
//keep bot from using axe or lamo shotgun when running
	if(!(temp1 & TEMP1_MULTI))
	{
		if (time > self.attack_finished)
			if((self.ammo_shells >= 1) && (self.items & IT_SHOTGUN) )
				self.weapon = IT_SHOTGUN;
			else
				self.weapon = IT_AXE;
	}
//TONY
//MULTIWEAPON
	if(temp1 & TEMP1_MULTI)
		set_player_weapon ();
			
	MaybeFightFlagCarrier();
	
	if (self.enemy != world)
	{
		visi = BotCanSeePlayer(self.enemy);
		
		follow_ent = world;
		
		// don't try to follow if have the flag (what's the point?)
		if ((!visi) && (!(self.player_flag & ITEM_ENEMY_FLAG)))
			follow_ent = BotCanSeePlayerFollow(self.enemy);
	}
	else
		visi = FALSE;

		
	CheckGiveUpCamping();
		
	if (self.fire_hook_immediately)
	{
//		if (bot_debug >= 1)
//		{
//			dprint(self.netname);
//			dprint(" firing hook quick\n");
//		}	

		BotFireHookUpRandomly(30);
		self.fire_hook_immediately = FALSE;
	}
	else if ((self.enemy.health > 0) && (visi) && (self.bot_action == BOT_FIGHTING))
	{
//TONY REMOVED PING
//		if (time > (self.enemy_notice_time + (self.bsk_reaction_time / 2) + bot_ping))
		if (time > (self.enemy_notice_time + (self.bsk_reaction_time / 2) ))
			ContinueFighting();
	}
	else if ((self.enemy.health > 0) && (follow_ent != world) && (self.bot_action == BOT_FIGHTING))
	{
		// can't see enemy, but can see enemy follow entities, so
		// move toward those entities and hopefully keep fighting
		
		old_goal = self.goalentity;
		
		self.goalentity = follow_ent;
		self.movetarget = follow_ent;
		
		BotMoveTowardGoal(TRUE);

		self.goalentity = old_goal;
		self.movetarget = old_goal;

//		if (bot_debug >= 1)
//		{
//			dprint(self.netname);
//			dprint(" following ");
//			dprint(self.enemy.netname);
//			dprint("\n");
//		}	
	}
	else
	{
		// enemy is gone, so maybe find another
		if (!MaybeFight())
		{
			StopFighting();
			
			if (!MaybeGoToTempWaypoint())
			{
				if (!MaybeTryNotToDrown())
				{
					if (!MaybeGetItems())	
					{
						if (!SetSpecialGoals())
						{
							if (!MaybeGetOutOfWater())
							{
								if (!MaybeShootTriggers(FALSE))
								{
									if (!MaybeFireHook())
									{
										NothingToDo();
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
//	if (bot_debug >= 2)
//	{
//		dprint(self.netname);
//		dprint(" goal: ");
//		dprint(self.goalentity.classname);
//		dprint("\n");
//	}



	BotSaySomething();

	
	BotPostThink();


};


//=============================================================
// BotIsDead
//=============================================================
void() BotIsDead =
{
//	if (bot_debug >= 4)
//	{
//		dprint(self.netname);
//		dprint(" IsDead\n");
//	}
	
	self.think = BotRespawn;
	self.nextthink = time + 1 + (random()*5);
};

//=============================================================
// BotSelfDeActivate - Bot deactivates itself
//=============================================================
void () BotSelfDeActivate =
{
local float forward;

//	if (bot_debug >= 4)
//	{
//		dprint(self.netname);
//		dprint(" SelfDeactivate\n");
//	}
	
	self.solid = SOLID_NOT;
	self.deadflag = DEAD_DEAD;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen (self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else	
			self.velocity = forward * normalize(self.velocity);
	}

	// This creates a dead body
	if (deathmatch)
		CopyToBodyQue (self);
	
	BotIsDead();
};


//=============================================================
// Bot_Precache - called by Worldspawn
//=============================================================
void () Bot_Precache =
{
	//RadioPrecache();		// CTFBOT EXTRAS RADIO

	bot_debug = 0;
	
	next_bot_num = 0;
	next_bot_red = 0;
	next_bot_blue = 0;
	smooth_move = FALSE;
	use_extra_move_frame = TRUE;
	last_flag_capture = time - 999;
	last_flag_pickup = time - 999;
	
	last_order_time_team1 = time - 999;
	last_order_time_team2 = time - 999;
	
	level_over_time = time - 999;
	
	hook_use_enabled = TRUE;
	
//	bot_ping = 0;
	
	SpawnEvenTeamEntity();

//TONY
//IS THIS NEEDED?
//	SpawnBotColorMapEntity();
	
	//InitTeamNames();		// CTFBOT EXTRAS TEAMNAMES
//TONY
//REMOVED TO SAVE SPACE	
//	input_mode = 0;
	
	auto_camera_view = FALSE;
	auto_fov_control = FALSE;
	cur_camera_watch_ent = world;
	last_camera_ent = world;
	
	bots_have_normal_names = TRUE;
	
	SpawnWaypointsForMap(mapname);

//TONY
//THIS FUNCTION IS HORRIBLY NAMED
//THE BOTS AWARE DISTANCES ARE CALC'D HERE
	InitCPU();
	
	goal_winner = world;		// INVASION

	/*
	if (cvar("registered") & BOT_CUSTOM_SOUNDS)
	{
		precache_sound ("misc/flagtk2.wav");			// flag taken
		precache_sound ("misc/flagcap2.wav");			// flag capture
	}
	*/
	
	// CTFBOT EXTRAS [[[
	// for dynamic base stockpile creation... not all maps already
	// have super nailgun, double shotgun, large nails, large shells, etc.
	// this makes absolutely sure we have the stuff we could possibly
	// spawned already precached.
	precache_model ("maps/b_shell1.bsp");	// large shells
	precache_model ("maps/b_nail1.bsp");	// large nails
	precache_model ("progs/g_shot.mdl");	// double shotgun
	precache_model ("progs/g_nail2.mdl");	// super nailgun
	precache_model("maps/b_bh25.bsp");		// 25 health
	precache_sound("items/health1.wav");	// 25 health sound
	precache_model ("progs/armor.mdl");		// armor
	
	if (!(cvar("teamplay") & TEAM_NO_FLAG_TOSS))
	{
		precache_sound("shalrath/attack2.wav");	// flag toss sound
	}

//TONY
//temp1 no mess
	if (!(cvar("temp1") & TEMP1_NOMESS))
	{
		precache_sound("ctfbot/yessir.wav");
		bot_chatter_off = 0;
	}
	
	precache_model("progs/s_bubble.spr");	// for bot debugging
	precache_model("progs/s_light.spr");	// for bot debugging

	// flag stuff -- need to have this here so we can add flags to
	// maps without flags
	if (cvar("teamplay") & TEAM_CAPTURE_CUSTOM) {
		precache_model ("progs/flag.mdl");
		precache_sound ("misc/flagtk.wav");			// flag taken
		precache_sound ("misc/flagcap.wav");		// flag capture
		precache_sound ("doors/runetry.wav");
	} else {
		precache_model ("progs/w_g_key.mdl");
		precache_sound ("misc/medkey.wav");
		precache_sound ("doors/meduse.wav");
		precache_sound ("doors/runetry.wav");
	}
};

	
//=============================================================
//=============================================================
entity(entity bot) TeamCaptureSpawnBot =
{
	if (bot.team == TEAM_COLOR1) {
		team1_lastspawn = find(team1_lastspawn, classname, "info_player_team1");
		if (team1_lastspawn == world)
			team1_lastspawn = find(team1_lastspawn, classname, "info_player_team1");
		return team1_lastspawn;
	} else { // if (bot.team == TEAM_COLOR2)
 		team2_lastspawn = find(team2_lastspawn, classname, "info_player_team2");
		if (team2_lastspawn == world)
			team2_lastspawn = find(team2_lastspawn, classname, "info_player_team2");
		return team2_lastspawn;
	}
	return world;
};

//=============================================================
//=============================================================
entity (vector org) SpawnDebugMarker =
{
local entity e;

	e = spawn();
	e.classname = "debug_marker";
	e.owner = self;
	e.origin = org;
	setorigin(e, org);
	e.solid = SOLID_NOT;
	e.movetype = MOVETYPE_NONE;
	setmodel(e, string_null);
	setsize (e, '0 0 0', '0 0 0');
	return e;
};
//=============================================================
//=============================================================
void (float make_visible) SetDebugMarkersVisible =
{
local entity e;

	e = find(world, classname, "debug_marker");
	while (e != world)
	{
		if (make_visible)
		{
			debug_markers_visible = TRUE;
			setmodel(e, "progs/s_light.spr");
		}
		else
		{
			debug_markers_visible = TRUE;
			setmodel(e, "");
		}
		e = find(e, classname, "debug_marker");
	}
};
//=============================================================
//=============================================================
void (vector org) MoveDebugMarker =
{
	if (debug_markers_visible)
		setorigin(self.debug_marker, org);
};

//=============================================================


//TONY
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
//THIS IS THE _ONLY_ PLACE BOT SKIN IS SET//
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//


void (entity p) SetBotSkin = 
{

//TONY
//CHANGED THIS FUNCTION AROUND

//	if (p.team == TEAM_COLOR1)
//		p.skin = 1;
//	else if (p.team == TEAM_COLOR2)
//		p.skin = 3;

//GL BOTS
//||
//the bot is not a simulated client and does not have a colormap
//Set the skins to the full color
//tony
//took this out
//12-22-98
//	if((temp1 & TEMP1_USEGLBOTMODEL) || (p.simulated_client == FALSE))
//	{
//		p.skin = p.skin + 4;
//	}
	if (p.bot_skill >= 2)
		p.skin = p.skin + 1; // visor dude

//OLD
	// skin 0 = default
	// skins 1-4 = custom ctf: red, red visor, blue, blue visor
	// skins 5-6 = red, red visor
	// skins 7-8 = blue, blue visor

	if (p.team == TEAM_COLOR1)
		p.skin = 5;
	else if (p.team == TEAM_COLOR2)
		p.skin = 7;
	else
		p.skin = 0;

	if (p.bot_skill >= 2)
		p.skin = p.skin + 1; // visor dude
};
//=============================================================
//void () BotsUseSkins = 
//{
//local entity p;
//
//	p = find(world, classname, "bot");
//	while (p != world)
//	{
//		SetBotSkin(p);
//		p = find(p, classname, "bot");
//	}
//};
//=============================================================
//void () BotsUseClientColorMap = 
//{
//local entity p;
//local entity rh, bh;
//local float found;
//
//	// fall back on a random player just in case we can't
//	// find a good one
//	rh = find(world, classname, "player");
//	bh = find(world, classname, "player");
//
//	found = 0;
//	p = find(world, classname, "player");
//	while ((p != world) && (!found))
//	{
//		if (p.team == TEAM_COLOR1)
//		{
//			found = TRUE;
//			rh = p;
//		}
//		p = find(p, classname, "player");
//	}
//	
//	found = 0;
//	p = find(world, classname, "player");
//	while ((p != world) && (!found))
//	{
//		if (p.team == TEAM_COLOR2)
//		{
//			found = TRUE;
//			bh = p;
//		}
//		p = find(p, classname, "player");
//	}
//
//	p = find(world, classname, "bot");
//	while (p != world)
//	{
//		if (p.team == TEAM_COLOR1)
//		{
//			p.colormap = rh.colormap;
//			p.skin = 1;
//		}
//		else if (p.team == TEAM_COLOR2)
//		{
//			p.colormap = bh.colormap;
//			p.skin = 3;
//		}
//
//		if (p.bot_skill >= 2)
//			p.skin = p.skin + 1; // visor dude
//
//		/*
//		dprint("set bot colormap to ");
//		dprintfloat(p.colormap);
//		dprint("\n");
//		*/
//			
//		p = find(p, classname, "bot");
//	}
//};
//=============================================================
// self is the colormap entity
//=============================================================
//void () BotUpdateColorMaps = 
//{
//local float nr, nb;
//
//	// first get the number of humans.  
//	nr = GetNumHumansOnTeam(TEAM_COLOR1);
//	nb = GetNumHumansOnTeam(TEAM_COLOR2);
//
//	// If there are no humans on one of the teams,
//	// we need to use skins to differetiate bots	
//	if ((nr == 0) || (nb == 0))
//	{
//		BotsUseSkins();
//	}
//	else
//	{
//		// at leats one red human and one blue human
//		BotsUseClientColorMap();
//	}
//	
//	self.nextthink = time + 5;
//};
//=============================================================
//=============================================================
//void () SpawnBotColorMapEntity =
//{
//	if (bot_debug >= 4)
//	{
//		dprint("SpawnBotColorMapEntity\n");
//	}
//	
//	if (!(teamplay & TEAM_FIX_BOT_COLORS))
//		return;
//	
//	local entity p;
//	p = spawn();
//	p.solid = SOLID_NOT;
//	p.movetype = MOVETYPE_NONE;
//	setmodel(p, string_null);
//	p.think = BotUpdateColorMaps;
//	p.nextthink = time + 5;
//};

//=============================================================
// self is player
//=============================================================
entity (string name, float botteam, float bskill) BotCreate = 
{
local entity    newbot;
local entity    spot;
local float     mapper;
local float     counter;
local string st;

	if ((self.classname != "player") && (self.classname != "info_bot_start"))
		return;

	if (!deathmatch) 
	{
		sprint2("Deathmatch is not enabled.\n");
		sprint2("No bot created.\n");
		return;
	}
	
//	if (bot_debug >= 2)
//	{
//		dprint("BotCreate: ");
//		dprint(name);
//		dprint(", team ");
//		st = ftos(botteam);
//		dprint(st);
//		dprint("\n");
//	}
	
	newbot = spawn();
	newbot.solid = SOLID_SLIDEBOX;
	newbot.movetype = MOVETYPE_STEP;
	
	
	newbot.botname = name;
	
	RandomNormalName(newbot);

	if (bots_have_normal_names)
		newbot.netname = newbot.altname;
	else
		newbot.netname = newbot.botname;

	newbot.classname = "bot";

	/* old colormap code
	if (self.classname == "player")
		newbot.colormap = self.colormap;
	else
		newbot.colormap = 1;
	*/
	
	newbot.team = botteam;
	newbot.lastteam = botteam;
	
	// NEW COLORMAP CODE [[[
	local float lfClientNo;
	lfClientNo = clientNextAvailable();


//TONY
//THIS IS A MESS
//Check simulated_client in SetBotSkins and add 4 if FALSE
	if( lfClientNo == -1 )
	{
//
//		// no free client numbers available, so use another player/bots colormap
//		
//		local entity p;
//		local float found;
//		found = FALSE;
//		p = find(world, classname, "bot");
//		while ((p != world) && (!found))
//		{
//TONY
//MADE SOME CHANGES
//Instead of looking for player, look for a bot.  Players can change teams and stuff.
//			if (p.team == newbot.team)
//			{
//				newbot.colormap = p.colormap;
//				SetBotSkin(newbot);
//				found = TRUE;
//			}
//			p = find(p, classname, "bot");
//		}
		newbot.simulated_client = FALSE;
//
//
//		dprint(newbot.netname);
//		dprint(" doppleganger of ");
//		dprint(p.netname);
//		dprint("\n");
	}
	else
	{
		clientSetUsed( lfClientNo );
		
//		dprint(newbot.netname);
//		dprint(" simulated client ");
//		dprintfloat(lfClientNo);
//		dprint("\n");

		newbot.simulated_client = TRUE;
		newbot.colormap = lfClientNo + 1; // use the colormap for reference to the
		newbot.fClientNo = lfClientNo;	// bot's client number
	}
	// NEW COLORMAP CODE ]]]
		
	newbot.waterlevel = 0;
	newbot.health = 100;
	newbot.max_health = 100;
	newbot.frags = 0;
	newbot.flags = FL_CLIENT;
	newbot.takedamage = DAMAGE_AIM;
	newbot.goalentity = newbot;
	newbot.movetarget = newbot;
	newbot.enemy = world;
	newbot.pausetime = 0;
	newbot.deadflag = DEAD_NO;
	
	newbot.escort_time = time - 999;
	newbot.escort_entity = world;
	
	newbot.camping_time = time - 999;
	newbot.camping_entity = world;
	newbot.camping_spot = '0 0 0';
	
	newbot.last_kill_time = time - 999;
	newbot.last_kill_ent = world;

	/*
	newbot.suspicious_about = '0 0 0';
	newbot.suspicious_about_time = 0;
	*/
	
	// CTFBOT [[[
	newbot.num_kills = 0;			// CTFBOT EXTRAS number of kills
	newbot.num_deaths = 0;		// CTFBOT EXTRAS number of deaths
	newbot.num_suicides = 0;		// CTFBOT EXTRAS number of suicides
	newbot.num_captures = 0;		// CTFBOT EXTRAS number of personal flag captures 
	newbot.num_pickups = 0;		// CTFBOT EXTRAS number of personal enemy flag pickups
	newbot.num_recovery = 0;		// CTFBOT EXTRAS number of flag recoveries
	newbot.num_assists = 0;		// CTFBOT EXTRAS number of assists
	newbot.num_bonus = 0;			// CTFBOT EXTRAS number of general bonuses
	// CTFBOT ]]]

	newbot.player_flag = newbot.player_flag - (newbot.player_flag & ITEM_RUNE_MASK);
	newbot.player_flag = newbot.player_flag - (newbot.player_flag & ITEM_ENEMY_FLAG);
	
	newbot.spawn_time = time;

	newbot.yaw_speed = 80;  // could do cvar("cl_yawspeed");
	newbot.items = IT_SHOTGUN;
	newbot.show_hostile = 0;
	newbot.weapon = 1;
	newbot.effects = 0;
	newbot.ammo_shells = 25;
	newbot.ammo_nails = 0;
	newbot.ammo_rockets = 0;
	newbot.ammo_cells = 0;
	
	newbot.last_say = 0;

	newbot.armorvalue = 50;
	newbot.items = newbot.items | IT_ARMOR1;
	newbot.armortype = 0.3;

	newbot.view_ofs = '0 0 22';

	newbot.hook_out = FALSE;
	
	newbot.bot_plan = BOT_ATTACK;
	
	newbot.th_pain = bot_pain;
	newbot.th_die = PlayerDie;
		
	newbot.debug_marker = SpawnDebugMarker();
//TONY
//MULTIWEAPONS
//?????
	if(temp1 & TEMP1_MULTI)
	{
		local entity oself;

		oself = self;
		self = newbot;
		set_player_modelindexes ();
		self = oself;
		

//		set_player_modelindexes_newbot (newbot);
	}
	else
	{

//TONY
//BOT's SEX
//make male if support female off
		if(!(temp1 & TEMP1_SUPPORT_PLAYER2))
		{
			newbot.sex = 1;
		}

		if(newbot.sex == 2)
			setmodel( newbot, "progs/player2.mdl");
		else if (newbot.sex == 3)
			setmodel( newbot, "progs/player3.mdl");
		else if (newbot.sex == 4)
			setmodel( newbot, "progs/player4.mdl");
		else
			setmodel (newbot, "progs/player.mdl");
	}

	newbot.bot_skill = bskill;
	if (newbot.bot_skill < 0)
		newbot.bot_skill = 0;
	if (newbot.bot_skill > 3)
		newbot.bot_skill = 3;

	newbot.bot_skill_inverse = (3 - newbot.bot_skill);

	// various precalculations for bot skill... do these now as an
	// optimization because they never change

	newbot.bsk_skill_lin1 = 0.7 + (newbot.bot_skill * 0.1);
	newbot.bsk_skill_lin2 = 0.4 + (newbot.bot_skill * 0.2);
	newbot.bsk_skill_lin3 = 0.1 + (newbot.bot_skill * 0.3);
	
	newbot.bsk_next_pulse_time = 0.3 + (0.3 * newbot.bot_skill_inverse);
	newbot.bsk_next_pulse_time_items = 0.2 + (0.2 * newbot.bot_skill_inverse);
	newbot.bsk_extra_large_pulse_dist = (200 * newbot.bot_skill);
	newbot.bsk_extra_awareness_dist = (300 * newbot.bot_skill);
	newbot.bsk_extra_jump_chance = 0.05 + (0.05 * newbot.bot_skill);
	newbot.bsk_move_while_firing = (0.85 + (newbot.bot_skill * 0.05));
	newbot.bsk_evade_chance = 0.4 + (newbot.bot_skill * 0.2);
	newbot.bsk_bot_fov = newbot.bot_skill_inverse * 0.15;

	// skill 3 is instantaneous, skill 0 is 0.6 seconds
	newbot.bsk_reaction_time = 0.2 * newbot.bot_skill_inverse;
	
	newbot.shirt_color = TeamGetShirt(newbot.team,newbot);

	if (botteam == TEAM_COLOR1)
		newbot.enemy_team = TEAM_COLOR2;
	else if (botteam == TEAM_COLOR2)
		newbot.enemy_team = TEAM_COLOR1;

	SetBotSkin(newbot);

//	if (newbot.team == TEAM_COLOR1)
//		newbot.skin = 1;
//	else if (newbot.team == TEAM_COLOR2)
//		newbot.skin = 3;
//TONY
//GL BOTS
//Set the skins to the full color
//	if(temp1 & TEMP1_USEGLBOTMODEL)
//	{
//		if (newbot.team == TEAM_COLOR1)
//			newbot.skin = 5;
//		else if (newbot.team == TEAM_COLOR2)
//			newbot.skin = 7;
//	}

//TONY
//is this bot going to use the Defensive waypoints?
	if(random() > 0.75)
		newbot.use_defensive_way = 1;
	else
		newbot.use_defensive_way = 0;
	if(!(temp1 & TEMP1_USEDEFWAYS))
		newbot.use_defensive_way = 0;


//TONY
//Don't want to set this crap again!!!!!!!
//	if (newbot.bot_skill >= 2)
//		newbot.skin = newbot.skin + 1; // visor dude
//	SetBotSkin(newbot);		
	
	newbot.air_finished = time + 300;		// what the hell??
	newbot.dmg = 2;

	setsize (newbot, VEC_HULL_MIN, VEC_HULL_MAX);

	if (self.classname == "player")
		spot = TeamCaptureSpawnBot(newbot);
	else if (self.classname == "info_bot_start")
		spot = self;

	newbot.origin = spot.origin + '0 0 1';
	setorigin(newbot, newbot.origin );
	newbot.angles = spot.angles;
	newbot.angles_x = 0;	// center view
	newbot.ideal_yaw = newbot.angles * '0 1 0';
	newbot.v_angle = newbot.angles;

	makevectors(newbot.angles);
	spawn_tfog (newbot.origin + v_forward*20);

	newbot.bot_action = BOT_MOVING;
	newbot.think = BotAnimationThink;
	newbot.extramove_oldthink = BotAnimationThink;
	newbot.nextthink = time + 0.1 + (random() * 0.1);

	spawn_tdeath(newbot.origin, newbot);


	bprint("[");
	st = ftos(next_bot_num);
	bprint(st);
	bprint("]");
	if (newbot.team == TEAM_COLOR1)
	{
		bprint("[r");
		st = ftos(next_bot_red);
		bprint(st);
		bprint("] ");
	}
	else if (newbot.team == TEAM_COLOR2)
	{
		bprint("[b");
		st = ftos(next_bot_blue);
		bprint(st);
		bprint("] ");
	}
	bprint(newbot.netname);
	bprint(" [skill ");
	st = ftos(newbot.bot_skill);
	bprint(st);
	bprint("] entered the game\n");

	if (self.classname == "info_bot_start")
	{
		newbot.items = spot.items;
		newbot.ammo_shells = spot.ammo_shells;
		newbot.ammo_rockets = spot.ammo_shells;
		newbot.ammo_nails = spot.ammo_nails;
		newbot.ammo_cells = spot.ammo_cells;
		newbot.armortype = spot.armortype;
		newbot.armorvalue = spot.armorvalue;
	}
//TONY
//DEATHMATCH 5
	if(deathmatch & DM_START_SMALL)
	{
		newbot.items = IT_HOOK | IT_SUPER_SHOTGUN | IT_NAILGUN;
		newbot.ammo_shells = 69;
		newbot.ammo_rockets = 0;
		newbot.ammo_nails = 40;
		newbot.ammo_cells = 0;
		newbot.armortype = 0.31;
		newbot.armorvalue = 100;
		newbot.weapon = IT_NAILGUN;
	}

	if(deathmatch & DM_START_BIG)
	{
		newbot.items = IT_HOOK | IT_SUPER_SHOTGUN | IT_SUPER_NAILGUN | IT_ROCKET_LAUNCHER;
//TONY
//TESTING WATER
//		newbot.items = IT_HOOK | IT_LIGHTNING;
		newbot.ammo_shells = 69;
		newbot.ammo_rockets = 5;
		newbot.ammo_nails = 60;
//TESTING WATER
//		newbot.ammo_cells = 200;
		newbot.ammo_cells = 0;
		newbot.armortype = 0.31;
		newbot.armorvalue = 100;
		newbot.weapon = IT_ROCKET_LAUNCHER;

	}

//TONY
//MULTIWEAPON
	if(temp1 & TEMP1_MULTI)
		set_player_weapon ();

	
	if (newbot.simulated_client)
	{
		newbot.fShirt = newbot.shirt_color;
		newbot.fPants = newbot.team - 1;
		msgUpdateNameToAll( newbot.fClientNo, newbot.netname );
		msgUpdateColorsToAll( newbot.fClientNo, newbot.fShirt, newbot.fPants );
		msgUpdateFragsToAll( newbot.fClientNo, newbot.frags );


//		msgUpdateColorsToAll(newbot.colormap - 1, newbot.shirt_color, newbot.team - 1);
//		msgUpdateFragsToAll(newbot.colormap - 1, newbot.frags);
//		msgUpdateNameToAll(newbot.colormap - 1, newbot.netname);
	}

	return newbot;
};

void () CheckDimLight;

//==========================================================
//==========================================================
void () BotRespawn =
{
local entity spot;

//	if (bot_debug >= 2)
//	{
//		dprint("BotRespawn: ");
//		dprint(self.netname);
//		dprint("\n");
//	}
	
	if (!deathmatch) 
		return;

	self.flags = FL_CLIENT;			// ????
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.waterlevel = 0;
	self.air_finished = time + 300;
	self.dmg = 2;
	self.classname = "bot";
	self.health = 100;
	self.max_health = 100;
	self.takedamage = DAMAGE_AIM;
	self.deadflag = DEAD_NO;
	self.goalentity = self;
	self.movetarget = self;
	self.enemy = world;
	self.pausetime = 0;
	
	// all powerups & runes & flag disappear on respawn
	
	self.super_damage_finished = 0;
	self.invincible_finished = 0;
	self.invisible_finished = 0;
	self.radsuit_finished = 0;
		
	self.player_flag = self.player_flag - (self.player_flag & ITEM_RUNE_MASK);
	self.player_flag = self.player_flag - (self.player_flag & ITEM_ENEMY_FLAG);

	/*
	self.suspicious_about = '0 0 0';
	self.suspicious_about_time = 0;
	*/
	
	// don't set on respawn? self.spawn_time = time;

	self.yaw_speed = 80;	// could use cvar("cl_yawspeed");
	self.show_hostile = 0;
	self.effects = 0;
	self.view_ofs = '0 0 22';
	self.items = IT_SHOTGUN;
	self.weapon = IT_SHOTGUN;
	self.ammo_shells = 25;
	self.ammo_nails = 0;
	self.ammo_rockets = 0;
	self.ammo_cells = 0;

	self.escort_time = time - 999;
	self.escort_entity = world;

	self.camping_time = time - 999;
	if (self.camping_entity != world)
		remove(self.camping_entity);
	self.camping_entity = world;
	self.camping_spot = '0 0 0';

	self.hook_out = FALSE;

	self.th_pain = bot_pain;
	self.th_die = PlayerDie;
	
//TONY
//MULTIWEAPONS
//?????
//	if(temp1 & TEMP1_MULTI)
//	{
//		set_player_modelindexes ();
//	}
//	else
//	{

//	setmodel (self, "progs/player.mdl");
	if(self.sex == 2)
		setmodel( self, "progs/player2.mdl");
	else if(self.sex == 3)
		setmodel( self, "progs/player3.mdl");
	else if(self.sex == 4)
		setmodel( self, "progs/player4.mdl");
	else
		setmodel (self, "progs/player.mdl");

//	}

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);

	spot = SelectSpawnPoint ();
	spot = TelefragSelectSpawnPoint(spot);

//TONY
//RANDOM spawn
	if(deathmatch & DM_SPAWN_RANDOM)
		spot = QWSelectSpawnPoint ();


	self.origin = spot.origin + '0 0 1';
	setorigin(self, self.origin);
	
	self.angles = spot.angles;
	self.angles_x = 0;	// center view
	self.ideal_yaw = self.angles * '0 1 0';
	self.v_angle = self.angles;
	makevectors(self.angles);
	spawn_tfog (self.origin + v_forward*20);
	spawn_tdeath(self.origin, self);

	self.bot_action = BOT_MOVING;
	self.think = BotAnimationThink;
	self.extramove_oldthink = BotAnimationThink;
	self.nextthink = time + 0.1;

//TONY
//DEATHMATCH 5
	if(deathmatch & DM_START_SMALL)
	{
		self.items = IT_HOOK | IT_SUPER_SHOTGUN | IT_NAILGUN;
		self.ammo_shells = 69;
		self.ammo_rockets = 0;
		self.ammo_nails = 40;
		self.ammo_cells = 0;
		self.armortype = 0.31;
		self.armorvalue = 100;
		self.weapon = IT_NAILGUN;

	}
	if(deathmatch & DM_START_BIG)
	{
		self.items = IT_HOOK | IT_SUPER_SHOTGUN | IT_SUPER_NAILGUN | IT_ROCKET_LAUNCHER;
		self.ammo_shells = 69;
		self.ammo_rockets = 5;
		self.ammo_nails = 60;
		self.ammo_cells = 0;
		self.armortype = 0.31;
		self.armorvalue = 100;
		self.weapon = IT_ROCKET_LAUNCHER;

	}

//TONY
//MULTIWEAPON
	if(temp1 & TEMP1_MULTI)
		set_player_weapon ();

};


//==========================================================
// BotList - lists bots currently playing and how many frags.
//==========================================================
void (entity to) BotList =
{
local entity head;
local string frag;
local float best;
local string bestname;
local float num;

	if (to.classname != "player")
		return;

	bestname = "";
	best = 0;
	num = 0;

	sprint(to, "Bot frags:\n");
	head = find(world, classname, "bot");
	while(head)
	{
		num = num +1;
		frag = ftos (head.frags);
		sprint(to, head.netname);
		sprint(to, " = ");
		sprint(to, frag);
		if( best < head.frags )
		{
			best = head.frags;
			bestname = head.netname;
		}

		head = find(head, classname, "bot");
	}
};
