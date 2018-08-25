//botanim.qc
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


$cd id1/models/player_4
$origin 0 -6 24
$base base		
$skin skin
 
//
// running
//
$frame axrun1 axrun2 axrun3 axrun4 axrun5 axrun6

$frame rockrun1 rockrun2 rockrun3 rockrun4 rockrun5 rockrun6

//
// standing
//
$frame stand1 stand2 stand3 stand4 stand5

$frame axstnd1 axstnd2 axstnd3 axstnd4 axstnd5 axstnd6
$frame axstnd7 axstnd8 axstnd9 axstnd10 axstnd11 axstnd12


//
// pain
//
$frame axpain1 axpain2 axpain3 axpain4 axpain5 axpain6

$frame pain1 pain2 pain3 pain4 pain5 pain6


//
// death
//

$frame axdeth1 axdeth2 axdeth3 axdeth4 axdeth5 axdeth6
$frame axdeth7 axdeth8 axdeth9

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8
$frame deatha9 deatha10 deatha11

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11 deathc12 deathc13 deathc14 deathc15

$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7
$frame deathd8 deathd9

$frame deathe1 deathe2 deathe3 deathe4 deathe5 deathe6 deathe7
$frame deathe8 deathe9

//
// attacks
//
$frame nailatt1 nailatt2

$frame light1 light2

$frame rockatt1 rockatt2 rockatt3 rockatt4 rockatt5 rockatt6

$frame shotatt1 shotatt2 shotatt3 shotatt4 shotatt5 shotatt6

$frame axatt1 axatt2 axatt3 axatt4 axatt5 axatt6

$frame axattb1 axattb2 axattb3 axattb4 axattb5 axattb6

$frame axattc1 axattc2 axattc3 axattc4 axattc5 axattc6

$frame axattd1 axattd2 axattd3 axattd4 axattd5 axattd6
/*
//==============================================================================
// this routine may not show the exact right animation
//==============================================================================
void () BotFirstAnimationFrame =
{
	if (self.weapon == IT_HOOK)
		self.frame = $axstnd1;
};
//==============================================================================
void () BotNextAnimationFrame =
{
	self.frame = self.frame + 1;
	
	if (self.frame > $axrun6)
		self.frame = $axrun1;
	else if (self.frame > $rockrun6)
		self.frame = $rockrun1;
	else if (self.frame > $stand5)
		self.frame = $stand1;
	else if (self.frame > $axstand12)
		self.frame = $axstand1;
	else if (self.frame > $axpain6)
		self.frame = $stand1;
	else if (self.frame > $pain6)
		self.frame = $stand1;
	else if (self.frame > $nailatt2)
		self.frame = $nailatt1;
	else if (self.frame > $light2)
		self.frame = $light1;
	else if (self.frame > $rockatt6)
		self.frame = $rockatt1;
	else if (self.frame > $shotatt6)
		self.frame = $shotatt1;
	else if ((self.frame > $axatt6) 
			|| (self.frame > $axattb6)
			|| (self.frame > $axattc6)
			|| (self.frame > $axattd6))
	{
		self.frame = $axatt1;
	}
};
*/
//==============================================================================
// this routine may not show the exact right animation
//==============================================================================
void () BotAnimationThink =
{
local float run;

	if (intermission_running)
	{
		BotSaySomething();
		return;
	}

//	if (bot_debug >= 4)
//	{
//		dprint(self.netname);
//		dprint(" BotAnimationThink\n");
//	}

	self.extramove_lastframewasextra = FALSE;

	if (smooth_move)
		run = (self.velocity_x || self.velocity_y || self.velocity_z);
	else
		run = (self.bot_action != BOT_STANDING);



	if (run)
	{
		// running animation
		if (self.weapon == IT_AXE || self.weapon == IT_HOOK)
		{
			if (self.walkframe >= 6)		// made >= CTFBOT bug fix for "sliding" with hook?
				self.walkframe = 0;
			self.frame = $axrun1 + self.walkframe;
		}
		else
		{
			if (self.walkframe >= 6)		// made >= CTFBOT EXTRAS bug fix for "sliding" with hook?
				self.walkframe = 0;
			self.frame = $rockrun1 + self.walkframe;	// made $rockrun1 CTFBOT EXTRAS bug fix for "sliding" with hook?
		}
	}
	else
	{
		// standing animation
		if (self.weapon == IT_AXE || self.weapon == IT_HOOK)
		{
			if (self.walkframe >= 12)
				self.walkframe = 0;
			self.frame = $axstnd1 + self.walkframe;
		}
		else
		{
			if (self.walkframe >= 5)
				self.walkframe = 0;
			self.frame = $stand1 + self.walkframe;
		}
	}
	
	// go to next animation frame
	self.walkframe = self.walkframe + 1;	

	// decide what to do... sets nextthink
	BotThink();	
};


//==============================================================================
// special case: check for attack finished so we can abort out of 
// animation... this handles the haste case and also helps us make
// sure bot is firing as fast as possible
//=============================================================================
void () CheckAttackFinished =
{
	// special case required for haste: break out of animation early
	// and go to main think routine where we can fire again.
	if ((time >= self.attack_finished) && (self.player_flag & ITEM_RUNE3_FLAG))
	{
		self.think = BotAnimationThink;
		self.extramove_oldthink = BotAnimationThink;
	}
	
	self.extramove_lastframewasextra = FALSE;
};

//==============================================================================
void()	bot_shot1 =	[$shotatt1, bot_shot2	] 
{self.effects = self.effects | EF_MUZZLEFLASH; MoveWhileFiring(); CheckAttackFinished(); };
void()	bot_shot2 =	[$shotatt2, bot_shot3	] {MoveWhileFiring(); CheckAttackFinished(); };
void()	bot_shot3 =	[$shotatt3, bot_shot4	] {MoveWhileFiring(); CheckAttackFinished(); };
void()	bot_shot4 =	[$shotatt4, bot_shot5	] {MoveWhileFiring(); CheckAttackFinished(); };
void()	bot_shot5 =	[$shotatt5, bot_shot6	] {MoveWhileFiring(); CheckAttackFinished(); };
void()	bot_shot6 =	[$shotatt6, BotAnimationThink	] {BotThink();};

void()	bot_axe1 =	[$axatt1, bot_axe2	] {MoveWhileFiring(); };
void()	bot_axe2 =	[$axatt2, bot_axe3	] {MoveWhileFiring(); };
void()	bot_axe3 =	[$axatt3, bot_axe4	] {W_FireAxe();CheckAttackFinished(); };
void()	bot_axe4 =	[$axatt4, BotAnimationThink	] {BotThink();};

void()	bot_axeb1 =	[$axattb1, bot_axeb2 ] {MoveWhileFiring(); };
void() bot_axeb2=[$axattb2, bot_axeb3] {MoveWhileFiring(); };
void()	bot_axeb3 =	[$axattb3, bot_axeb4 ] {W_FireAxe();CheckAttackFinished(); };
void()	bot_axeb4 =	[$axattb4, BotAnimationThink	] {BotThink();};

void()	bot_axec1 =	[$axattc1, bot_axec2	] {MoveWhileFiring(); };
void()	bot_axec2 =	[$axattc2, bot_axec3	] {MoveWhileFiring(); };
void()	bot_axec3 =	[$axattc3, bot_axec4	] {W_FireAxe();CheckAttackFinished(); };
void()	bot_axec4 =	[$axattc4, BotAnimationThink	] {BotThink();};

void()	bot_axed1 =	[$axattd1, bot_axed2	] {MoveWhileFiring(); };
void()	bot_axed2 =	[$axattd2, bot_axed3	] {MoveWhileFiring(); };
void()	bot_axed3 =	[$axattd3, bot_axed4	] {W_FireAxe();CheckAttackFinished(); };
void()	bot_axed4 =	[$axattd4, BotAnimationThink	] {BotThink();};

//==============================================================================
void()  bot_chain1=  [$axattd1, bot_chain2 ] {};
void()  bot_chain2=  [$axattd2, bot_chain3 ] {W_FireChain();};
void() bot_chain5;

void() bot_chain4;
void()  bot_chain3=  [$axattd3, bot_chain3 ]
{
//	if (bot_debug >= 2)
//	{
//		dprint(self.netname);
//		dprint(" bot_chain3\n");
//	}

	if (!self.hook_out)
	{
		bot_chain5();
		return;
	}
	if (vlen(self.velocity) >= 750)
	{
		bot_chain4();
		return;
	}

	if (ShouldReleaseHook())
		DropDown();
};

void() bot_chain4=  [$deathc4, bot_chain4 ]
{
//	if (bot_debug >= 2)
//	{
//		dprint(self.netname);
//		dprint(" bot_chain4\n");
//	}

        if (!self.hook_out)
        {
                bot_chain5();
                return;
        }
        if (vlen(self.velocity) < 750)
        {
                bot_chain3();
                return;
        }

	if (ShouldReleaseHook())
		DropDown();
};

void()  bot_chain5=  [$axattd4, BotAnimationThink    ] 
{
//	if (bot_debug >= 2)
//	{
//		dprint(self.netname);
//		dprint(" bot_chain5\n");
//	}

	BotThink();
};



//============================================================================
void() bot_nail1   =[$nailatt1, bot_nail2  ] 
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	SuperDamageSound();
	//MoveWhileFiring();

	W_FireSpikes (4);

	self.attack_finished = time + 0.1;
	BotThink();
};
void() bot_nail2   =[$nailatt2, bot_nail1  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	SuperDamageSound();

	//MoveWhileFiring();

	W_FireSpikes (-4);
	
	self.attack_finished = time + 0.1;
	BotThink();
};

//============================================================================
void() bot_light1   =[$light1, bot_light2  ] 
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	SuperDamageSound();
	//MoveWhileFiring();

	W_FireLightning();
	self.attack_finished = time + 0.2;
	BotThink();
};
void() bot_light2   =[$light2, bot_light1  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	SuperDamageSound();
	//MoveWhileFiring();

	W_FireLightning();
	self.attack_finished = time + 0.2;
	BotThink();
};

//============================================================================
void() bot_rocket1   =[$rockatt1, bot_rocket2  ] {
self.effects = self.effects | EF_MUZZLEFLASH;MoveWhileFiring(); CheckAttackFinished(); };
void() bot_rocket2   =[$rockatt2, bot_rocket3  ] {MoveWhileFiring(); CheckAttackFinished(); };
void() bot_rocket3   =[$rockatt3, bot_rocket4  ] {MoveWhileFiring(); CheckAttackFinished(); };
void() bot_rocket4   =[$rockatt4, bot_rocket5  ] {MoveWhileFiring(); CheckAttackFinished(); };
void() bot_rocket5   =[$rockatt5, bot_rocket6  ] {MoveWhileFiring(); CheckAttackFinished(); };
void() bot_rocket6   =[$rockatt6, BotAnimationThink  ] {BotThink();};


//==============================================================================
void()	bot_pain1 =	[	$pain1,	bot_pain2	] {PainSound();BotEvade(world);CheckAttackFinished(); };
void()	bot_pain2 =	[	$pain2,	bot_pain3	] {BotEvade(world);CheckAttackFinished(); };
void()	bot_pain3 =	[	$pain3,	bot_pain4	] {BotEvade(world);CheckAttackFinished(); };
void()	bot_pain4 =	[	$pain4,	bot_pain5	] {BotEvade(world);CheckAttackFinished(); };
void()	bot_pain5 =	[	$pain5,	bot_pain6	] {BotEvade(world);CheckAttackFinished(); };
void()	bot_pain6 =	[	$pain6,	BotAnimationThink	] {BotThink();};

void()	bot_axpain1 =	[	$axpain1,	bot_axpain2	] {PainSound();BotEvade(world);CheckAttackFinished(); };
void()	bot_axpain2 =	[	$axpain2,	bot_axpain3	] {BotEvade(world);CheckAttackFinished(); };
void()	bot_axpain3 =	[	$axpain3,	bot_axpain4	] {BotEvade(world);CheckAttackFinished(); };
void()	bot_axpain4 =	[	$axpain4,	bot_axpain5	] {BotEvade(world);CheckAttackFinished(); };
void()	bot_axpain5 =	[	$axpain5,	bot_axpain6	] {BotEvade(world);CheckAttackFinished(); };
void()	bot_axpain6 =	[	$axpain6,	BotAnimationThink	] {BotThink();};

//==============================================================================
void() bot_pain =
{
	if (self.weaponframe)
		return;

	if (self.invisible_finished > time)
		return;		// eyes don't have pain frames

	if (self.weapon == IT_AXE || self.weapon == IT_HOOK)
		bot_axpain1 ();
	else
		bot_pain1 ();
};



//==============================================================================
//==============================================================================
void() Bot_Attack =
{
	local	float	r;
	
//	if (bot_debug >= 2)
//	{
//		dprint(self.netname);
//		dprint(" Bot_Attack\n");
//	}

	if (!W_CheckNoAmmo ())
		return;

	makevectors	(self.v_angle);			// calculate forward angle for velocity

//	if (bot_debug >= 2)
//	{
//		dprint(self.netname);
//		dprint(" attack with ");
//		local string st;
//		st = ftos(self.weapon);
//		dprint(st);
//		dprint("\n");
//	}

	if (self.weapon == IT_AXE)
	{
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		r = random();
		if (r < 0.25)
			bot_axe1 ();
		else if (r<0.5)
			bot_axeb1 ();
		else if (r<0.75)
			bot_axec1 ();
		else
			bot_axed1 ();

		// RUNE: rune of hell magic
		if (self.player_flag & ITEM_RUNE3_FLAG) {
			self.attack_finished = time + 0.3;
			HasteSound();
		} else
			self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		bot_shot1 ();
		W_FireShotgun ();
		// RUNE: rune of hell magic
		if (self.player_flag & ITEM_RUNE3_FLAG) {
			self.attack_finished = time + 0.3;
			HasteSound();
		} else
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		bot_shot1 ();
		W_FireSuperShotgun ();
		// RUNE: rune of hell magic
		if (self.player_flag & ITEM_RUNE3_FLAG) {
			self.attack_finished = time + 0.4;
			HasteSound();
		} else
		self.attack_finished = time + 0.7;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		bot_nail1 ();
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		bot_nail1 ();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		bot_rocket1();
		W_FireGrenade();
		// RUNE: rune of hell magic
		if (self.player_flag & ITEM_RUNE3_FLAG) {
			self.attack_finished = time + 0.3;
			HasteSound();
		} else
			self.attack_finished = time + 0.6;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		bot_rocket1();
		W_FireRocket();
		// RUNE: rune of hell magic
		if (self.player_flag & ITEM_RUNE3_FLAG) {
			self.attack_finished = time + 0.4;
			HasteSound();
		} else
			self.attack_finished = time + 0.8;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		bot_light1();
		self.attack_finished = time + 0.1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	}
	else if (self.weapon == IT_HOOK)
	{
		if (!self.hook_out)
			bot_chain1();
		else
			bot_chain3();

		self.attack_finished = time + 0.1;
	}
};


//==============================================================================
//==============================================================================
void() Bot_WeaponFrame =
{
//	if (bot_debug >= 2)
//	{
//		dprint(self.netname);
//		dprint(" Bot_WeaponFrame\n");
//	}
	
	self.last_weapon_shot = self.weapon;

	if (time < self.attack_finished)
		return;
	
// check for attack
	if (self.button0)
	{
		SuperDamageSound ();
		Bot_Attack ();
	}

};