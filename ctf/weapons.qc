/*
*/
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float rad, entity ignore) T_RadiusDamage;
void(vector org, vector vel, float damage) SpawnBlood;
void() SuperDamageSound;
void() HasteSound;

// called by worldspawn
void() W_Precache =
{
	precache_sound ("hknight/hit.wav");  // flamethrower

	precache_sound ("weapons/r_exp3.wav");  // new rocket explosion
	precache_sound ("weapons/rocket1i.wav");        // spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav"); // player shotgun
	precache_sound ("weapons/ric1.wav");    // ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");    // ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");    // ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");  // super spikes
	precache_sound ("weapons/tink1.wav");   // spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav"); // grenade launcher
	precache_sound ("weapons/bounce.wav");          // grenade bounce
	precache_sound ("weapons/shotgn2.wav"); // super shotgun        
	
	precache_sound2 ("blob/land1.wav");     // chain go splorch!
	if (cvar("teamplay") & TEAM_CAPTURE_CUSTOM) {
		precache_sound ("weapons/chain1.wav");
		precache_sound ("weapons/chain2.wav");
		precache_sound ("weapons/chain3.wav");
		precache_sound ("weapons/bounce2.wav");
	}

	// ZOID:
	// normally the weapon models are precached in the individual item
	// creation routines.  But since we've added impulse 21 we can drop
	// weapons at any time.  Must precache all weapon models.
	precache_model ("progs/g_shot.mdl");
	precache_model ("progs/g_nail.mdl");
	precache_model ("progs/g_nail2.mdl");
	precache_model ("progs/g_rock.mdl");
	precache_model ("progs/g_rock2.mdl");
	precache_model ("progs/g_light.mdl");
};

float() crandom =
{
	return 2*(random() - 0.5);
};

/*
================
W_FireAxe
================
*/
void() W_FireAxe =
{
	local   vector  source;
	local   vector  org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood (org, '0 0 0', 20);
		T_Damage (trace_ent, self, self, 20);
	}
	else
	{       // hit wall
// tony
// sex sounds
		if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
			sound (self, CHAN_WEAPON, "player2/axhit2.wav", 1, ATTN_NORM);
		else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
			sound (self, CHAN_WEAPON, "player3/axhit2.wav", 1, ATTN_NORM);
		else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
			sound (self, CHAN_WEAPON, "player4/axhit2.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);

		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};


//============================================================================


vector() wall_velocity =
{
	local vector    vel;
	
	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	
	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
	local   entity missile, mpuff;
	local   vector  org;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';
	
// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');            
	setorigin (missile, org);
};

/*
================
SpawnBlood
================
*/
void(vector org, vector vel, float damage) SpawnBlood =
{
	particle (org, vel*0.1, 73, damage*2);
};

/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
	local vector    vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (self.origin + vel*0.01, vel, damage);
};


/*
================
SpawnChunk
================
*/
void(vector org, vector vel) SpawnChunk =
{
	particle (org, vel*0.02, 0, 10);
};

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity  multi_ent;
float   multi_damage;

//TONY
//COMPRESS
//QWSG
vector  puff_org;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};

void() ApplyMultiDamage =
{
	if (!multi_ent)
		return;
	T_Damage (multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage =
{
	if (!hit)
		return;
	
	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};


/*
==============================================================================

BULLETS

==============================================================================
*/

/*
================
TraceAttack
================
*/
void(float damage, vector dir) TraceAttack =
{
	local   vector  vel, org;
	
	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		SpawnBlood (org, vel*0.2, damage);
		AddMultiDamage (trace_ent, damage);
	}
	else
	{

//TONY
//COMPRESS
//QWSG
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/

void(float shotcount, vector dir, vector spread) FireBullets =
{
	local   vector direction;
	local   vector  src;
	
	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

//TONY
//	THIS IS NEVER USED
//	local float num_from_shot;      // CTFBOT EXTRAS BULLETHOLES
//	num_from_shot = 0;                      // CTFBOT EXTRAS BULLETHOLES

	ClearMultiDamage ();

	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;
		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (4, direction);

		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
};

/*
================
W_FireShotgun
================
*/
void() W_FireShotgun =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM); 

	self.punchangle_x = -2;
//TONY
//DEATHMATCH 5
	if (!((deathmatch & DM_START_SMALL) || (deathmatch & DM_START_BIG)))
	{
		if(!(deathmatch & DM_INFINITE_AMMO))
			self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	}
	
	if (self.classname == "player")         // CTFBOT
		dir = aim (self, 100000);
	else if (self.classname == "bot")       // CTFBOT
		dir = self.bot_aim;     // CTFBOT

//TONY
//LESS SPREAD
//	FireBullets (6, dir, '0.04 0.04 0');
	FireBullets (6, dir, '0.01 0.01 0');
};


/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
	local vector dir;

	if (self.currentammo == 1)
	{
		W_FireShotgun ();
		return;
	}
		
	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM); 

	self.punchangle_x = -4;

//TONY
//DEATHMATCH 5
	if (!((deathmatch & DM_START_SMALL) || (deathmatch & DM_START_BIG)))
	{
		if(!(deathmatch & DM_INFINITE_AMMO))
			self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	}

	if (self.classname == "player")         // CTFBOT
		dir = aim (self, 100000);
	else if (self.classname == "bot")       // CTFBOT
		dir = self.bot_aim;             // CTFBOT

//TONY
//LESS SPREAD
//	FireBullets (14, dir, '0.14 0.08 0');
	FireBullets (14, dir, '0.06 0.03 0');
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

void()  s_explode1      =       [0,             s_explode2] {};
void()  s_explode2      =       [1,             s_explode3] {};
void()  s_explode3      =       [2,             s_explode4] {};
void()  s_explode4      =       [3,             s_explode5] {};
void()  s_explode5      =       [4,             s_explode6] {};
void()  s_explode6      =       [5,             SUB_Remove] {};

void() BecomeExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() T_MissileTouch =
{
	local float     damg;

	if (other == self.owner)
		return;         // don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	if (other.classname == "player" || other.classname == "bot")
		other.gib_velocity = self.velocity;             // CTFBOT EXTRAS

	damg = 100 + random()*20;
	
	if (other.health)
	{
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 120, other);
	
	
//      sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	
	BecomeExplosion ();
};



/*
================
W_FireRocket
================
*/
void() W_FireRocket =
{
	local   entity missile, mpuff;

	if(!(deathmatch & DM_INFINITE_AMMO))
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
		
// set missile speed    

	makevectors (self.v_angle);

	if (self.classname == "player")         // CTFBOT
		missile.velocity = aim (self, 1000);
	else if (self.classname == "bot")       // CTFBOT
		missile.velocity = self.bot_aim;                // CTFBOT

	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = T_MissileTouch;
	
// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');            
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');
};

/*
===============================================================================

LIGHTNING

===============================================================================
*/

/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) LightningDamage =
{
	local entity            e1, e2;
	local vector            f;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
};

void() SetBotWaterLevel;
void() W_FireLightning =
{
	local   vector          org;
	local   float           cells;

	if (self.ammo_cells < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water

//TONY
//THIS SUCKS COCK, BUT THERE'S NOTHING ELSE TO DO.
//IT APPEARS THAT .waterlevel IS BEING SET TO -1 SOMEPLACE,
//I CAN'T FIND IT.
	if(self.classname == "bot")
	{
		SetBotWaterLevel();
	}

	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo ();
		T_RadiusDamage (self, self, 35*cells, world);
		return;
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;

	if(!(deathmatch & DM_INFINITE_AMMO))
		self.currentammo = self.ammo_cells = self.ammo_cells - 1;

	org = self.origin + '0 0 16';

	if (self.classname == "player")

		traceline (org, org + v_forward*600, TRUE, self);

	// CTFBOT [[[

	else if (self.classname == "bot")

	{

		if (bot_debug >= 3)

		{

			dprint(self.netname);

			dprint(" FireLightning\n");

		}

		local vector ba2;

		ba2 = self.bot_aim;

		ba2 = normalize(ba2);

		traceline (org, org + ba2*600, TRUE, self);

	}

	// CTFBOT ]]]

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

//TONY
//LIGHTNING HALF DAMAGE
	if(temp1 & TEMP1_HALFLIGHT)
		LightningDamage (self.origin, trace_endpos + v_forward*4, self, 15);
	else
		LightningDamage (self.origin, trace_endpos + v_forward*4, self, 30);
};


//=============================================================================


void() GrenadeExplode =
{
	T_RadiusDamage (self, self.owner, 120, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	
	BecomeExplosion ();
};

void() GrenadeTouch =
{
	if (other == self.owner)
		return;         // don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);  // bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

/*
================
W_FireGrenade
================
*/
void() W_FireGrenade =
{
	local   entity missile, mpuff;

	if(!(deathmatch & DM_INFINITE_AMMO))
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
		
// set missile speed    



	// CTFBOT [[[
	if (self.classname == "bot")
	{
		self.angles = vectoangles(self.bot_aim);
		makevectors(self.angles);
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	}
	else
	{
	// CTFBOT ]]]

		makevectors (self.v_angle);
		if (self.v_angle_x)
			missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
		else
		{
			missile.velocity = aim (self, 10000);

			missile.velocity = missile.velocity * 600;
			missile.velocity_z = 200;
		}
	}       // CTFBOT

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = GrenadeTouch;
	
// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = GrenadeExplode;

//TONY
//RED/BLUE grenades
	if (self.team==TEAM_COLOR2)
		missile.skin = 1;
	else
		missile.skin = 0;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');            
	setorigin (missile, self.origin);
};


//=============================================================================

void() spike_touch;
void() superspike_touch;


/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir, float spd) launch_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);               
	setorigin (newmis, org);

	newmis.velocity = dir * spd;
};

void() W_FireSuperSpikes =
{
	local vector    dir;
	local entity    old;
	
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	if(!(deathmatch & DM_INFINITE_AMMO))
		self.currentammo = self.ammo_nails = self.ammo_nails - 2;

	if (self.classname == "player")         // CTFBOT
		dir = aim (self, 1000);
	else if (self.classname == "bot")       // CTFBOT
		dir = self.bot_aim;             // CTFBOT

	if (self.player_flag & ITEM_RUNE3_FLAG) {
		HasteSound();
		launch_spike (self.origin + '0 0 16', dir, 2000);
	} 
	else    
		launch_spike (self.origin + '0 0 16', dir, 1000);
		
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);               
	self.punchangle_x = -2;
};

void(float ox) W_FireSpikes =
{
	local vector    dir;
	local entity    old;
	
	makevectors (self.v_angle);
	
	if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes ();
		return;
	}

	if (self.ammo_nails < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;

	if(!(deathmatch & DM_INFINITE_AMMO))
		self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	
	if (self.classname == "player")         // CTFBOT
		dir = aim (self, 1000);
	else if (self.classname == "bot")       // CTFBOT
		dir = self.bot_aim;             // CTFBOT
		
	if (self.player_flag & ITEM_RUNE3_FLAG) {
		HasteSound();
		launch_spike (self.origin + '0 0 16' + v_right*ox, dir, 2000);
	} 
	else    
		launch_spike (self.origin + '0 0 16' + v_right*ox, dir, 1000);

	self.punchangle_x = -2;
};



.float hit_z;
void() spike_touch =
{
local float rand;
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return; // trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);
		T_Damage (other, self, self.owner, 9);
	}
	else
	{       
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		
		/* CTFBOT monsters removed
		if (self.classname == "wizspike")
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
		else if (self.classname == "knightspike")
			WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		else
		*/
		
		WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};

void() superspike_touch =
{
local float rand;
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return; // trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (18);
		T_Damage (other, self, self.owner, 18);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

void() W_SetCurrentAmmo =
{

	if (self.classname == "player")         // CTFBOT
		player_run ();          // get out of any weapon firing states

	else if (self.classname == "bot")

		self.think = BotAnimationThink;


//	if ((bot_debug >= 2) && (self.classname == "bot"))
//	{
//		dprint(self.netname);
//		dprint(" ");
//		local string st;
//		st = ftos(self.weapon);
//		dprint(st);
//		dprint(" W_SetCurrentAmmo\n");
//	}

	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
	
	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == IT_HOOK)
	{
		self.currentammo = 0;
		if (teamplay & TEAM_CAPTURE_CUSTOM) 
			self.weaponmodel = "progs/v_star.mdl";
		else
			self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_light.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
	}
//TONY
//MULTIWEAPONS
	if(temp1 & TEMP1_MULTI)
	{
		set_player_weapon ();
	}
};

float() W_BestWeapon =
{
	local   float   it;

	if (self.classname == "bot")            // CTFBOT
	{
		local float bw;
		bw = Bot_BestWeapon();          // CTFBOT
		return bw;
	}

	else
	{
	it = self.items;

	if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & IT_LIGHTNING) )
		return IT_LIGHTNING;

	if(self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN) )
		return IT_SUPER_NAILGUN;
	if(self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN) )
		return IT_SUPER_SHOTGUN;
	if(self.ammo_nails >= 1 && (it & IT_NAILGUN) )
		return IT_NAILGUN;
	if(self.ammo_shells >= 1 && (it & IT_SHOTGUN) )
		return IT_SHOTGUN;

	return IT_AXE;

	}
};

float() W_CheckNoAmmo =
{
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == IT_AXE || self.weapon == IT_HOOK)
		return TRUE;
	
	self.weapon = W_BestWeapon ();

	if ((bot_debug >= 2) && (self.classname == "bot"))
	{
		dprint(self.netname);
		local string st;
		dprint(" BestWeapon ");
		st = ftos(self.weapon);
		dprint(st);
		dprint("\n");
	}

	W_SetCurrentAmmo ();
	
// drop the weapon down
	return FALSE;
};

/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void()  player_axe1;
void()  player_axeb1;
void()  player_axec1;
void()  player_axed1;
void()  player_shot1;
void()  player_nail1;
void()  player_light1;
void()  player_rocket1;
void()  player_chain1;
void()  player_chain3;

void() W_Attack =
{
	local   float   r;

	if (!W_CheckNoAmmo ())
		return;


//	if ((bot_debug >= 2) && (self.classname == "bot"))
//	{
//		dprint(self.netname);
//		dprint(" ");
//		local string st;
//		st = ftos(self.weapon);
//		dprint(st);
//		dprint(" W_Attack\n");
//	}


	makevectors     (self.v_angle);                 // calculate forward angle for velocity
	self.show_hostile = time + 1;   // wake monsters up

	if (self.weapon == IT_AXE)
	{
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		r = random();
		if (r < 0.25)
			player_axe1 ();
		else if (r<0.5)
			player_axeb1 ();
		else if (r<0.75)
			player_axec1 ();
		else
			player_axed1 ();
		// RUNE: rune of hell magic
		if (self.player_flag & ITEM_RUNE3_FLAG) {
			self.attack_finished = time + 0.3;
			HasteSound();
		} else
			self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		player_shot1 ();
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
		player_shot1 ();
		W_FireSuperShotgun ();
		// RUNE: rune of hell magic
//TONY
//DEATHMATCH
		if ((self.player_flag & ITEM_RUNE3_FLAG) && (deathmatch & DM_START_BIG))
		{
			self.attack_finished = time + 0.2;
			HasteSound();
		}
		
		else if (self.player_flag & ITEM_RUNE3_FLAG)
		{
			self.attack_finished = time + 0.4;
			HasteSound();
		}
		else if (deathmatch & DM_START_BIG)
		{
			self.attack_finished = time + 0.4;
			HasteSound();
		}
		else
			self.attack_finished = time + 0.7;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		player_rocket1();
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
		player_rocket1();
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
		player_light1();
		self.attack_finished = time + 0.1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	}
	else if (self.weapon == IT_HOOK)
	{
		if (!self.hook_out)
			player_chain1();
		else
			player_chain3();
		self.attack_finished = time + 0.1;
	}
};

void() NotifyWeapon =
{
	if (self.weapon == IT_AXE)
		sprint(self, "Axe selected.\n");
	else if (self.weapon == IT_HOOK)
		sprint(self, "Grappling hook selected.\n");
};

/*
============
W_ChangeWeapon

============
*/
void() W_ChangeWeapon =
{
	local   float   it, am, fl;
	
	it = self.items;
	am = 0;
	
	if (self.impulse == 1) {
		if (self.weapon == IT_AXE)
			fl = IT_HOOK;
		else
			fl = IT_AXE;
	} else if (self.impulse == 31) {
		fl = IT_AXE;
	} else if (self.impulse == 2 || self.impulse == 32) {
		fl = IT_SHOTGUN;
		if (self.ammo_shells < 1)
			am = 1;
	} else if (self.impulse == 3 || self.impulse == 33) {
		fl = IT_SUPER_SHOTGUN;
		if (self.ammo_shells < 2)
			am = 1;
	} else if (self.impulse == 4 || self.impulse == 34) {
		fl = IT_NAILGUN;
		if (self.ammo_nails < 1)
			am = 1;
	} else if (self.impulse == 5 || self.impulse == 35) {
		fl = IT_SUPER_NAILGUN;
		if (self.ammo_nails < 2)
			am = 1;
	} else if (self.impulse == 6 || self.impulse == 36) {
		fl = IT_GRENADE_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	} else if (self.impulse == 7 || self.impulse == 37) {
		fl = IT_ROCKET_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	} else if (self.impulse == 8 || self.impulse == 38) {
		fl = IT_LIGHTNING;
		if (self.ammo_cells < 1)
			am = 1;
	} else if (self.impulse == 22 || self.impulse == 39) {
		fl = IT_HOOK;
	} else if (self.impulse == 9)
		fl = self.ITbest_wep;

	self.impulse = 0;
	
	if (!(self.items & fl))
	{       // don't have the weapon or the ammo
		sprint (self, "no weapon.\n");
		return;
	}
	
	if (am)
	{       // don't have the ammo
		sprint (self, "not enough ammo.\n");
		return;
	}

//McBain: save current weapon
// For explicite weapon selection, allow previous weapon and new weapon to be
// same except for IT_HOOK.
	if (self.weapon != IT_HOOK || fl != IT_HOOK)
		self.previous_weapon = self.weapon;

//
// set weapon, set ammo
//
	self.weapon = fl;               
//TONY
//TEMP1_NOMESS
	if(!(temp1 & TEMP1_NOMESS))
	{
		NotifyWeapon();
	}
	W_SetCurrentAmmo ();
};

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void() CycleWeaponCommand =
{
	local   float   it, am;
	
	it = self.items;
	self.impulse = 0;
	
//McBain: save current weapon
	self.previous_weapon = self.weapon;

	while (1)
	{
		am = 0;
		
		if (self.weapon == IT_AXE) {
			self.weapon = IT_HOOK;
		} else if (self.weapon == IT_HOOK) {
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		} else if (self.weapon == IT_SHOTGUN) {
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		} else if (self.weapon == IT_SUPER_SHOTGUN) {
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		} else if (self.weapon == IT_NAILGUN) {
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		} else if (self.weapon == IT_SUPER_NAILGUN) {
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		} 

      else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
	 self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		
		
		else if (self.weapon == IT_ROCKET_LAUNCHER) {
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
      else if (self.weapon == IT_LIGHTNING)
		{
	 self.weapon = IT_AXE;
		}
		
		if ( (it & self.weapon) && am == 0)
		{
//TONY
//TEMP1_NOMESS
	if(!(temp1 & TEMP1_NOMESS))
	{
			NotifyWeapon();
	}
			W_SetCurrentAmmo ();
			return;
		}
	}

};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
	local   float   it, am;
	
	it = self.items;
	self.impulse = 0;

//McBain: save current weapon
	self.previous_weapon = self.weapon;

	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}               
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_HOOK;
		}
		else if (self.weapon == IT_HOOK)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (it & self.weapon) && am == 0)
		{
//TONY
//TEMP1_NOMESS
	if(!(temp1 & TEMP1_NOMESS))
	{
			NotifyWeapon();
	}
			W_SetCurrentAmmo ();
			return;
		}
	}

};

//McBain: Here's the beef...
/*
============
PreviousWeaponCommand
============
*/
void() PreviousWeaponCommand =
{
	local   float   fl, am;
	
	self.impulse = 0;
	am = 0;

//TONY
//4.20
	if (!(self.items & self.previous_weapon))
	{
		sprint(self, "no weapon\n");
		return;
	}

	fl = self.weapon;
	self.weapon = self.previous_weapon;
	self.previous_weapon = fl;

	// this might not be the best method, but I'll be able to play sooner
	if (self.weapon == IT_SHOTGUN || self.weapon == IT_SUPER_SHOTGUN) {
		if (self.ammo_shells < 1)
			am = 1;
	}
	else if (self.weapon == IT_NAILGUN || self.weapon == IT_SUPER_NAILGUN) {
		if (self.ammo_nails < 1)
			am = 1;
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER || self.weapon == IT_ROCKET_LAUNCHER) {
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.weapon == IT_LIGHTNING) {
		if (self.ammo_cells < 1)
			am = 1;
	}
	// ignore AXE & HOOK -- no ammo needed

	if (am)
		self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();
};

//ZOID:  Uhm, where am I?
void() PrintLocation =
{
	local string p;

	p = vtos(self.origin);

	sprint(self, "You are at ");
	sprint(self, p);
	sprint(self, "\n");
};




/////////////////////////
//TONY
//
//ACTION oriented impulses (change weapons, throw backpack)
//are handled here
//
//ALL non-action impulses (print stats, add bots, etc.)
//will be handled in botimpul.qc
//
/////////////////////////

/*
============
ImpulseCommands

============
*/
void() ImpulseCommands =
{
	// CTFBOT EXTRAS [[[
	if ((self.observer) && (self.classname == "player"))
	{
		sprint(self, "You are an observer\n");
		sprint(self, "You cannot execute impulses\n");
	}
	// CTFBOT EXTRAS ]]]

	if (self.classname != "player")
		return;

//TONY
//REMOVED ADMIN.QC
//      if (self.impulse != 0)
//      if (self.accessparm) // admin functions
//              CheckAdminCmd();

	if (self.impulse != 0)
	if (!CheckBotImpulseCommands()) // CTFBOT
	{                                               // CTFBOT

	if (!self.observer &&
//TONY
//BEST WEAPON
//		(self.impulse >= 1 && self.impulse <= 8) || 
		(self.impulse >= 1 && self.impulse <= 9) || 

		self.impulse == 22 ||
		(self.impulse >= 31 && self.impulse <= 40))
		W_ChangeWeapon ();

	else if (!self.observer && self.impulse == 10)
		CycleWeaponCommand ();

	else if (!self.observer && self.impulse == 12)
		CycleWeaponReverseCommand ();

//TONY
	else if (!self.observer && self.impulse == 14)
	{
		if (self.weapon == IT_HOOK)
			PreviousWeaponCommand ();
		else
		{
			self.previous_weapon = self.weapon;
			self.weapon = IT_HOOK;
			W_SetCurrentAmmo ();
		}
	}
//TONY
//YCAM
	else if (!self.observer &&((self.impulse == 15) && (temp1 & TEMP1_YCAM)))
		YCam();

	else if (!self.observer && self.impulse == 69)
		PreviousWeaponCommand ();

		
// *TEAMPLAY*
// If we're allowed to drop items, enable impulse 20 and 21
	else if (!self.observer && (teamplay & TEAM_DROP_ITEMS) && self.impulse == 20)
		TossBackpack ();

	else if (!self.observer && (teamplay & TEAM_DROP_ITEMS) && self.impulse == 21)
		TossWeapon ();

	else if (self.impulse == 141)
		identify_player();

      else
		CheckAdminCmd();
	
	}       // CTFBOT : end of !checkbotimpulse
	
	self.impulse = 0;
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_WeaponFrame =
{
	if (time < self.attack_finished)
		return;

//ZOID: Only call ImpulseCommands() if needed!  This saves a good chunk
//of cpu.  'profile' in console listed ImpulseCommands() as #1 user of
//cpu (instructions), adding this one line caused it to not even be in
//the top ten.
	if (self.impulse && (self.classname == "player"))               // CTFBOT
		ImpulseCommands ();
	
// check for attack
	if (self.button0)
	{
		SuperDamageSound ();
		W_Attack ();
	}
};

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound =
{
// RUNE play super damage sound if player has Black Magic, too
	if ((self.player_flag & ITEM_RUNE2_FLAG) && 
		(self.super_damage_finished > time)) {
		if (self.super_sound < time) {
			self.super_sound = time + 1;
			if (teamplay & TEAM_CAPTURE_CUSTOM)
				sound (self, CHAN_BODY, "rune/rune22.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}

	else if (self.super_damage_finished > time) {           // CTFBOT added else
		if (self.super_sound < time) {
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}

	else if (self.player_flag & ITEM_RUNE2_FLAG) {          // CTFBOT added else
		if (self.super_sound < time) {
			self.super_sound = time + 1;

			if (teamplay & TEAM_CAPTURE_CUSTOM)
				sound (self, CHAN_BODY, "rune/rune2.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}       
	}
	return;
};

/*
========
RegenerationSound

Plays sound if needed
========
*/
void() RegenerationSound =
{
// RUNE play healing sound if player has Elder Magic
	if (self.player_flag & ITEM_RUNE4_FLAG) {
		if (self.regeneration_sound < time) {
			self.regeneration_sound = time + 1;
			if (teamplay & TEAM_CAPTURE_CUSTOM)
				sound(self, CHAN_BODY, "rune/rune4.wav", 1, ATTN_NORM);
			else
				sound(self, CHAN_BODY, "items/r_item1.wav", 1, ATTN_NORM);
		}
	}
	return;
};

/*
========
HasteSound

Plays sound if needed
========
*/
void() HasteSound =
{
// RUNE play haste (Chthon's roar) sound if player has Hell Magic
	if (self.player_flag & ITEM_RUNE3_FLAG) {
		if (self.haste_sound < time) {
			self.haste_sound = time + 1;
			if (teamplay & TEAM_CAPTURE_CUSTOM)
				sound(self, CHAN_BODY, "rune/rune3.wav", 1, ATTN_NORM);
			else
				sound(self, CHAN_BODY, "boss1/sight1.wav", 1, ATTN_NORM);
		}
	}
	return;
};
