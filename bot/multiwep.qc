//MultiWeapon copyright 1997 Wes Morrison
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



// MultiWep.QC, requires MultiWep.QH

// called by worldspawn
void() MultiWeapon_PreCache =
{
	
//	precache_model ("progs/player.mdl");
	precache_model ("progs/pl_shot1.mdl");
	precache_model ("progs/pl_shot2.mdl");
	precache_model ("progs/pl_nail1.mdl");
	precache_model ("progs/pl_nail2.mdl");
	precache_model ("progs/pl_rock1.mdl");
	precache_model ("progs/pl_rock2.mdl");
	precache_model ("progs/pl_light.mdl");

	// If new player weapon models are created, precache them here

	if (cvar("temp1") & TEMP1_SUPPORT_PLAYER2)
	{
		precache_model ("progs/pl2shot1.mdl");
		precache_model ("progs/pl2shot2.mdl");
		precache_model ("progs/pl2nail1.mdl");
		precache_model ("progs/pl2nail2.mdl");
		precache_model ("progs/pl2rock1.mdl");
		precache_model ("progs/pl2rock2.mdl");
		precache_model ("progs/pl2light.mdl");
	}
	if (cvar("temp1") & TEMP1_SUPPORT_PLAYER3)
	{
		precache_model ("progs/pl3shot1.mdl");
		precache_model ("progs/pl3shot2.mdl");
		precache_model ("progs/pl3nail1.mdl");
		precache_model ("progs/pl3nail2.mdl");
		precache_model ("progs/pl3rock1.mdl");
		precache_model ("progs/pl3rock2.mdl");
		precache_model ("progs/pl3light.mdl");
	}
	if (cvar("temp1") & TEMP1_SUPPORT_PLAYER4)
	{
		precache_model ("progs/pl4shot1.mdl");
		precache_model ("progs/pl4shot2.mdl");
		precache_model ("progs/pl4nail1.mdl");
		precache_model ("progs/pl4nail2.mdl");
		precache_model ("progs/pl4rock1.mdl");
		precache_model ("progs/pl4rock2.mdl");
		precache_model ("progs/pl4light.mdl");
	}
};

// called in PutClientInServer
void() set_player_modelindexes =
{
	setmodel (self, "progs/pl_shot1.mdl");
	modelindex_pl_shot1 = self.modelindex;
	setmodel (self, "progs/pl_shot2.mdl");
	modelindex_pl_shot2 = self.modelindex;
	setmodel (self, "progs/pl_nail1.mdl");
	modelindex_pl_nail1 = self.modelindex;
	setmodel (self, "progs/pl_nail2.mdl");
	modelindex_pl_nail2 = self.modelindex;
	setmodel (self, "progs/pl_rock1.mdl");
	modelindex_pl_rock1 = self.modelindex;
	setmodel (self, "progs/pl_rock2.mdl");
	modelindex_pl_rock2 = self.modelindex;
	setmodel (self, "progs/pl_light.mdl");
	modelindex_pl_light = self.modelindex;

	if (temp1 & TEMP1_SUPPORT_PLAYER2)
	{
		setmodel (self, "progs/pl2shot1.mdl");
		modelindex_pl2shot1 = self.modelindex;
		setmodel (self, "progs/pl2shot2.mdl");
		modelindex_pl2shot2 = self.modelindex;
		setmodel (self, "progs/pl2nail1.mdl");
		modelindex_pl2nail1 = self.modelindex;
		setmodel (self, "progs/pl2nail2.mdl");
		modelindex_pl2nail2 = self.modelindex;
		setmodel (self, "progs/pl2rock1.mdl");
		modelindex_pl2rock1 = self.modelindex;
		setmodel (self, "progs/pl2rock2.mdl");
		modelindex_pl2rock2 = self.modelindex;
		setmodel (self, "progs/pl2light.mdl");
		modelindex_pl2light = self.modelindex;
	}

	if (temp1 & TEMP1_SUPPORT_PLAYER3)
	{
		setmodel (self, "progs/pl3shot1.mdl");
		modelindex_pl3shot1 = self.modelindex;
		setmodel (self, "progs/pl3shot2.mdl");
		modelindex_pl3shot2 = self.modelindex;
		setmodel (self, "progs/pl3nail1.mdl");
		modelindex_pl3nail1 = self.modelindex;
		setmodel (self, "progs/pl3nail2.mdl");
		modelindex_pl3nail2 = self.modelindex;
		setmodel (self, "progs/pl3rock1.mdl");
		modelindex_pl3rock1 = self.modelindex;
		setmodel (self, "progs/pl3rock2.mdl");
		modelindex_pl3rock2 = self.modelindex;
		setmodel (self, "progs/pl3light.mdl");
		modelindex_pl3light = self.modelindex;
	}

	if (temp1 & TEMP1_SUPPORT_PLAYER4)
	{
		setmodel (self, "progs/pl4shot1.mdl");
		modelindex_pl4shot1 = self.modelindex;
		setmodel (self, "progs/pl4shot2.mdl");
		modelindex_pl4shot2 = self.modelindex;
		setmodel (self, "progs/pl4nail1.mdl");
		modelindex_pl4nail1 = self.modelindex;
		setmodel (self, "progs/pl4nail2.mdl");
		modelindex_pl4nail2 = self.modelindex;
		setmodel (self, "progs/pl4rock1.mdl");
		modelindex_pl4rock1 = self.modelindex;
		setmodel (self, "progs/pl4rock2.mdl");
		modelindex_pl4rock2 = self.modelindex;
		setmodel (self, "progs/pl4light.mdl");
		modelindex_pl4light = self.modelindex;
	}

	// Make sure this routine is called after modelindex_player has been set.
	self.modelindex = modelindex_player;

	// Call this once from here to set initial value of .modelindex_thisplayer,
	// called thereafter in W_SetCurrentAmmo, which is called whenever weapon changes
	// Note: any patches that alter the way weapons are selected (so they don't all
	// eventually end up in W_SetCurrentAmmo) may need to call this routine in other spots
	set_player_weapon ();
};

// Called whenever the weapon is changed
void() set_player_weapon =
{
	if (self.sex == 2)
	{
		if (self.weapon == IT_SHOTGUN)
			self.modelindex_thisplayer = modelindex_pl2shot1;
		else if (self.weapon == IT_SUPER_SHOTGUN)
			self.modelindex_thisplayer = modelindex_pl2shot2;
		else if (self.weapon == IT_NAILGUN)
			self.modelindex_thisplayer = modelindex_pl2nail1;
		else if (self.weapon == IT_SUPER_NAILGUN)
			self.modelindex_thisplayer = modelindex_pl2nail2;
		else if (self.weapon == IT_GRENADE_LAUNCHER)
			self.modelindex_thisplayer = modelindex_pl2rock1;
		else if (self.weapon == IT_ROCKET_LAUNCHER)
			self.modelindex_thisplayer = modelindex_pl2rock2;
		else if (self.weapon == IT_LIGHTNING)
			self.modelindex_thisplayer = modelindex_pl2light;
		else
			self.modelindex_thisplayer = modelindex_player2;
	}
	else if (self.sex == 3)
	{
		if (self.weapon == IT_SHOTGUN)
			self.modelindex_thisplayer = modelindex_pl3shot1;
		else if (self.weapon == IT_SUPER_SHOTGUN)
			self.modelindex_thisplayer = modelindex_pl3shot2;
		else if (self.weapon == IT_NAILGUN)
			self.modelindex_thisplayer = modelindex_pl3nail1;
		else if (self.weapon == IT_SUPER_NAILGUN)
			self.modelindex_thisplayer = modelindex_pl3nail2;
		else if (self.weapon == IT_GRENADE_LAUNCHER)
			self.modelindex_thisplayer = modelindex_pl3rock1;
		else if (self.weapon == IT_ROCKET_LAUNCHER)
			self.modelindex_thisplayer = modelindex_pl3rock2;
		else if (self.weapon == IT_LIGHTNING)
			self.modelindex_thisplayer = modelindex_pl3light;
		else
			self.modelindex_thisplayer = modelindex_player3;
	}
	else if (self.sex == 4)
	{
		if (self.weapon == IT_SHOTGUN)
			self.modelindex_thisplayer = modelindex_pl4shot1;
		else if (self.weapon == IT_SUPER_SHOTGUN)
			self.modelindex_thisplayer = modelindex_pl4shot2;
		else if (self.weapon == IT_NAILGUN)
			self.modelindex_thisplayer = modelindex_pl4nail1;
		else if (self.weapon == IT_SUPER_NAILGUN)
			self.modelindex_thisplayer = modelindex_pl4nail2;
		else if (self.weapon == IT_GRENADE_LAUNCHER)
			self.modelindex_thisplayer = modelindex_pl4rock1;
		else if (self.weapon == IT_ROCKET_LAUNCHER)
			self.modelindex_thisplayer = modelindex_pl4rock2;
		else if (self.weapon == IT_LIGHTNING)
			self.modelindex_thisplayer = modelindex_pl4light;
		else
			self.modelindex_thisplayer = modelindex_player4;
	}
	else
	{
		if (self.weapon == IT_SHOTGUN)
			self.modelindex_thisplayer = modelindex_pl_shot1;
		else if (self.weapon == IT_SUPER_SHOTGUN)
			self.modelindex_thisplayer = modelindex_pl_shot2;
		else if (self.weapon == IT_NAILGUN)
			self.modelindex_thisplayer = modelindex_pl_nail1;
		else if (self.weapon == IT_SUPER_NAILGUN)
			self.modelindex_thisplayer = modelindex_pl_nail2;
		else if (self.weapon == IT_GRENADE_LAUNCHER)
			self.modelindex_thisplayer = modelindex_pl_rock1;
		else if (self.weapon == IT_ROCKET_LAUNCHER)
			self.modelindex_thisplayer = modelindex_pl_rock2;
		else if (self.weapon == IT_LIGHTNING)
			self.modelindex_thisplayer = modelindex_pl_light;
		else
			self.modelindex_thisplayer = modelindex_player;
	}

	// If the player is not invisible, assign the new model now.
	if (self.invisible_finished < time )
	{
		self.modelindex = self.modelindex_thisplayer;
	}
};
