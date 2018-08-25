
/************\
* BreakChain *
\************/

void (entity Head) BreakChain =
{
        local entity link;

        link = Head.goalentity;
        while (link != world)
        {
                Head = link.goalentity;
                remove (link);
                link = Head;
        }
};

/*********\
* LinkPos *
\*********/

void () LinkPos =
{
        makevectors (self.enemy.angles);
        setorigin (self, self.owner.origin + ( ( ( self.enemy.origin + 
                (v_up * 16 * (!self.enemy.button2)) + (v_forward * 16) ) - self.owner.origin ) *
                ( self.weapon ) ) );
        self.nextthink = time + 0.1;
};

/***********\
* MakeChain *
\***********/

entity (entity head, entity tail, float num) MakeChain =
{
        local entity link, prevlink;
        local float linknum;

        linknum = num;
        num = num + 1;
        prevlink = world;
        while (linknum > 0)
        {
                link = spawn();
				
				link.classname = "link";		// CTFBOT EXTRAS HOLO

                link.goalentity = prevlink;
                prevlink = link;

                link.owner = head;
                link.enemy = tail;
                link.weapon = linknum / num;
                link.movetype = MOVETYPE_NOCLIP;
                link.solid = SOLID_NOT;
                link.angles_z = 51 * linknum;
                link.angles_y = 41 * linknum;
                link.angles_x = 31 * linknum;
                link.avelocity = '310 410 510';
				if (teamplay & TEAM_CAPTURE_CUSTOM)
					setmodel (link, "progs/bit.mdl");
				else
					setmodel (link, "progs/s_spike.mdl");
                setsize (link, '0 0 0', '0 0 0');
                makevectors (tail.angles);
                setorigin (link, head.origin + ( ( ( tail.origin 
                        + (v_up * 16 * (!tail.button2)) + ( v_forward * 16 ) ) - head.origin )
                        * ( link.weapon ) ) );
                link.nextthink = time + 0.1;
                link.think = LinkPos;
                linknum = linknum - 1;
        }
        return link;
};


/************\
* HookVanish *
\************/

void () HookVanish =
{
	// CTFBOT [[[
	if ((bot_debug >= 3) && (self.owner.classname == "bot"))
	{
		dprint(self.owner.netname);
		dprint(" HookVanish\n");
	}
	// CTFBOT ]]]

	self.owner.hook_out = FALSE;
	
	self.owner.stuck_count = 0;		// CTFBOT
	self.owner.hook_snag_time = time + 99999999;	// CTFBOT
	self.owner.hooked_on_someone = FALSE;		// CTFBOT

/*
        if (self.enemy.classname == "player")
                self.enemy.attack_finished = time + 0.1;
*/
		if (teamplay & TEAM_CAPTURE_CUSTOM)
			sound(self.owner, CHAN_WEAPON, "weapons/bounce2.wav", 1, ATTN_NORM);	// CTFBOT EXTRAS bug fix
        BreakChain (self);
        remove (self);
};

void() UnHookPlayer =
{
	local entity oself;

	if (self.hook_out) {
		oself = self;
		self = self.goalentity;
		HookVanish();
		self = oself;
	}
};

/**********\
* HookPull *
\**********/

void () HookPull =
{
        local vector vel, spray;
        local float v, dorg;

	// CTFBOT [[[
	// hack to make bots be pulled by hook properly
	if (self.owner.classname == "bot")
	{
		if (self.owner.flags & FL_ONGROUND)
			self.owner.flags = self.owner.flags - FL_ONGROUND;

		// hack to make bots not get stuck on ceiling
		if (!self.owner.button0)
		{
			// CTFBOT [[[
			if ((bot_debug >= 3) && (self.owner.classname == "bot"))
			{
				dprint(self.owner.netname);
				dprint(" HookVanish1\n");
			}
			// CTFBOT ]]]

			HookVanish();
			return;
		}
	}
	// CTFBOT ]]]

	if ((!self.owner.button0 && (self.owner.weapon == IT_HOOK)) ||
		(self.owner.teleport_time > time ) || self.owner.deadflag ) 
	{
		// CTFBOT [[[
		if ((bot_debug >= 3) && (self.owner.classname == "bot"))
		{
			dprint(self.owner.netname);
			dprint(" HookVanish2\n");
		}
		// CTFBOT ]]]

		HookVanish();
		return;
	} else {
		 if (self.enemy.takedamage) {
			// don't hurt teammates
			if (self.enemy.classname != "player" 
				|| self.enemy.classname != "bot"	// CTFBOT
				|| !teamplay ||
				self.enemy.lastteam != self.owner.lastteam) {
				
				
				// 4.1, if we can't see our enemy, unlock
				if (!CanDamage(self.enemy, self.owner)) {
					HookVanish();
					return;
				}
				
				
				sound (self, CHAN_WEAPON, "blob/land1.wav", 1, ATTN_NORM);
				T_Damage (self.enemy, self, self.owner, 1);
				makevectors (self.v_angle);
				spray_x = 100 * crandom();
				spray_y = 100 * crandom();
				spray_z = 100 * crandom() + 50;
				SpawnBlood (self.origin, spray, 20);
			}
			if (self.enemy.solid == SOLID_SLIDEBOX) {
					self.velocity = '0 0 0';
					setorigin (self, self.enemy.origin +
							self.enemy.mins +
							(self.enemy.size * 0.5));
			} else {
					self.velocity = self.enemy.velocity;
			}
		} else {
				self.velocity = self.enemy.velocity;
		}
		if (self.enemy.solid == SOLID_NOT) 
		{
			// CTFBOT [[[
			if ((bot_debug >= 3) && (self.owner.classname == "bot"))
			{
				dprint(self.owner.netname);
				dprint(" HookVanish3\n");
			}
			// CTFBOT ]]]

			HookVanish();
			return;
		}
		makevectors (self.owner.angles);
		vel = self.origin - ( self.owner.origin + (v_up * 16 *
				(!self.owner.button2)) + (v_forward * 16));
		v = vlen (vel);
		if (v <= 100)
				vel = normalize(vel) * v * 10;  
		if ( v > 100 )
				vel = normalize(vel) * 1000;  

		if (teamplay & TEAM_CAPTURE_CUSTOM) {
			dorg = vlen(self.owner.origin - self.dest);
			if (dorg > 10 && self.style == 3) {
				sound(self.owner, CHAN_WEAPON, "weapons/chain2.wav", 1, ATTN_NORM);
				self.style = 2;
			}
			if (dorg < 10 && self.style == 2) {
				sound(self.owner, CHAN_WEAPON, "weapons/chain3.wav", 1, ATTN_NORM);
				self.style = 3;
			}
		}

		self.owner.velocity = vel;
		self.dest = self.owner.origin;
		self.nextthink = time + 0.1;
		
		if (vlen(self.owner.origin - self.owner.oldorigin) < 10)
			self.owner.stuck_count = self.owner.stuck_count + 1;
		self.owner.oldorigin = self.owner.origin;
	}
};

/**************\
* T_ChainTouch *
\**************/

void() T_ChainTouch =
{
	if (other == self.owner)
			return;         // don't attach to owner
   			
	self.owner.hook_snag_time = time;

	if (pointcontents(self.origin) == CONTENT_SKY) 
	{

//TONY
//DONT VANISH on sky
//IT looks stupid, but the bots really need this

		// CTFBOT [[[
		if ((bot_debug >= 3) && (self.owner.classname == "bot"))
		{
			dprint(self.owner.netname);
			dprint(" HookVanish4\n");
		}
		// CTFBOT ]]]
		
//		HookVanish();
//		return;
	}

	if ((other.classname == "player" || other.classname == "bot")	// CTFBOT
		&& teamplay &&
		other.team == self.owner.lastteam)
		return; // just pass through teammates

	if (other.takedamage) {
		// don't damage teammates
		if (other.classname == "player" || other.classname == "bot")	// CTFBOT
			other.axhitme = 1; // make axe noise
		else
		{
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
		}
		T_Damage (other, self, self.owner, 10 );
		SpawnBlood (self.origin, self.velocity, 10);
		self.owner.hooked_on_someone = TRUE;		// CTFBOT
	}
	else
	{
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
		self.avelocity = '0 0 0';
	}
               
	if (!self.owner.button0) 
	{
		// CTFBOT [[[
		if ((bot_debug >= 3) && (self.owner.classname == "bot"))
		{
			dprint(self.owner.netname);
			dprint(" HookVanish5\n");
		}
		// CTFBOT ]]]
			
		HookVanish();
		return;
			
	} else {
			if (other.solid == SOLID_SLIDEBOX) {
					setorigin (self, other.origin + other.mins +
							(other.size * 0.5));
					self.velocity = '0 0 0';
			} else {
					self.velocity = other.velocity;
			}
			self.weapon = other.nextthink - time;
			if (teamplay & TEAM_CAPTURE_CUSTOM)
				sound (self.owner, CHAN_WEAPON, "weapons/chain2.wav", 1, ATTN_NORM);

			self.style = 2;
			self.enemy = other;
			self.nextthink = time + 0.1;
			self.think = HookPull;
			self.touch = SUB_Null;
			//self.solid = SOLID_NOT;		// CTFBOT EXTRAS 
	}
};

/*************\
* W_FireChain *
\*************/

void() W_FireChain =
{
        local entity hook;

        self.hook_out = TRUE;
        hook = spawn ();
		hook.classname = "hook";		// CTFBOT EXTRAS HOLO
        hook.owner = self;
        hook.movetype = MOVETYPE_FLY;
        hook.solid = SOLID_BBOX;
		
		// WHAT DOES THIS DO???? self.goalentity = hook;
		
// set hook speed 

        makevectors (self.v_angle);
 
		// CTFBOT [[[
		if (self.classname == "bot")
			hook.velocity = self.bot_aim;
		else
		// CTFBOT ]]]		
			hook.velocity = aim(self, 1000);
             
        hook.velocity = hook.velocity * 800;
        hook.angles = vectoangles(hook.velocity);
        hook.avelocity = '0 0 -500';
	
        hook.touch = T_ChainTouch;
	
// set hook sound
        hook.nextthink = time + 5;
        hook.think = HookVanish;

		if (teamplay & TEAM_CAPTURE_CUSTOM)
			setmodel (hook, "progs/star.mdl");
		else
			setmodel (hook, "progs/v_spike.mdl");
        setsize (hook, '0 0 0', '0 0 0');     
        setorigin (hook, self.origin + (v_forward*16) + '0 0 16' );

		if (teamplay & TEAM_CAPTURE_CUSTOM)
			sound (self, CHAN_WEAPON, "weapons/chain1.wav", 1, ATTN_NORM);	
		else
			sound (self, CHAN_WEAPON, "hknight/hit.wav", 1, ATTN_NORM);	

        hook.goalentity = MakeChain (hook, self, 3);
};

