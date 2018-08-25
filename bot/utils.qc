//utils.qc
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



// CTFBOT EXTRAS [[[
//============================================================
// <x> is leading by 1 points (e.g. red, the demons)
//============================================================
void (entity p, string st) bsprint =
{
	if (p == world)
		bprint(st);
	else
		sprint(p, st);
};
/*============================================================*/
// Replacement for dprint, which is not supported by some 
// versions of WinQuake and/or Quake 1.07... use sprint 
// instead of dprint if self is actually a player (which it 
// probably will be if in response to impulse commands), otherwise
// use bprint
/*============================================================*/
void (string st) dprint = 
{
	if (self.classname == "player")
		sprint(self, st);
	else
		bprint(st);
};
/*============================================================*/
/*============================================================*/
void (float f) dprintfloat = 
{
local string st;

	st = ftos(f);
	dprint(st);
};
/*============================================================*/
/*============================================================*/
void (vector v) dprintvector = 
{
local string st;

	st = vtos(v);
	dprint(st);
};
/*============================================================*/
/*============================================================*/
void (float f) bprintfloat = 
{
local string st;

	st = ftos(f);
	bprint(st);
};
/*============================================================*/
/*============================================================*/
void (entity req, float f) sprintfloat = 
{
local string st;

	st = ftos(f);
	sprint(req, st);
};
/*============================================================*/
/*============================================================*/
void (string st) sprint2 = 
{
	if (self.classname == "player")
	{
		sprint(self, st);
	}
};


// CTFBOT HIPNOTIC [[[ added these for hipnotic mods
/*==============================================================*/
void() monster_use =
{
};
/*==============================================================*/
// infront
// returns 1 if the entity is in front (in sight) of self
/*==============================================================*/
float(entity targ) infront =
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	
	if ( dot > 0.3)
	{
		return TRUE;
	}
	return FALSE;
};
/*==============================================================*/
// returns 1 if the entity is visible to self, even if not infront ()
/*==============================================================*/
float (entity targ) visible =
{
	local vector	spot1, spot2;
	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};
// CTFBOT HIPNOTIC ]]] added this for hipnotic mods

/*============================================================*/
/*============================================================*/
void (float flo, float ndig, float printfrac) SPrintFloatDigits =
{
local float f1, f2;
local string st;

	f1 = floor(flo);
	
	if ((f1 < 1000) && (ndig >= 4))
		sprint(self, " ");
	if ((f1 < 100) && (ndig >= 3))
		sprint(self, " ");
	if ((f1 < 10) && (ndig >= 2))
		sprint(self, " ");

	st = ftos(f1);
	sprint(self, st);
	if (printfrac)
	{
		f2 = flo - floor(flo);
		f2 = f2 * 10;
		f2 = floor(f2);

		sprint(self, ".");
		st = ftos(f2);
		sprint(self, st);
	}
};

//==========================================================
// like an bprints but only for players with same team as self.
//==========================================================
void (string st) bprintteam =
{
local entity p;

	p = find(world, classname, "player");
	while (p != world)
	{
		if (p.team == self.team)
			sprint(p, st);
		p = find(p, classname, "player");
	}

};
//==========================================================
// like an bprints but only for players with same team as self.
//==========================================================
void (string st, float fteam) bprintteam2 =
{
local entity p;

	p = find(world, classname, "player");
	while (p != world)
	{
		if (p.team == fteam)
			sprint(p, st);
		p = find(p, classname, "player");
	}

};
