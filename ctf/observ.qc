float () PrintImpulseNotAllowed;
void() respawn;
entity() SelectSpawnPoint;
//TONY
//REMOVED ADMIN.QC
void() CheckAdminCmd;


void(entity player,entity tele) ObserverTeleporter =
{
  local entity targ;
  local vector v1,v2;
  
  v1 = ((tele.absmax + tele.absmin) * 0.5) - player.origin; normalize(v1);
  v2 = player.velocity; normalize(v2);
  if (v1 * v2 <= 0.1) return;
  
  targ = find (world, targetname, tele.target);
  if (!targ) {
    dprint("ObserverTeleportThroughTeleporter: couldn't find teleporter target\n");
    return;
  }
  makevectors (targ.mangle);
  setorigin (player, targ.origin);
  player.angles = targ.mangle;
  player.fixangle = TRUE; // turn this way immediately
  player.teleport_time = time + 0.7;
  player.velocity = v_forward * 300;
  // player.flags = player.flags - player.flags & FL_ONGROUND;
};

.entity eChaser;
.float fChasing;


float() DoObserverImpulse =
{
	local float bskill;

	if (self.impulse == 1 || self.impulse == 2 || self.button2)
	{

		self.observer = 0;
//TONY
//REMOVED CAM
//		self.CamState = CAM_NOT;
		SetChangeParms ();
		self.killed = 0;

		if (self.impulse == 1)
			self.team = self.lastteam = TEAM_COLOR1;
		else if (self.impulse == 2)
			self.team = self.lastteam = TEAM_COLOR2;
		else {
			self.lastteam = -50;
			TeamCheckTeam();
		}

		bprint(self.netname);	
		bprint(" joined ");					
		local string st;
		if (self.lastteam == TEAM_COLOR1)
			st = "RED";
		else if (self.lastteam == TEAM_COLOR2)
			st = "BLUE";
		bprint(st);
		bprint(" team!\n"); 				

		self.impulse = 0;

		self.player_flag = self.player_flag | TEAM_STUFF_COLOR;
		if (teamplay & TEAM_CAPTURE_CUSTOM) {
			if (self.lastteam == TEAM_COLOR1)
				self.skin = 1;
			else
				self.skin = 3;
			if (random() < 0.5)
				self.skin = self.skin + 1; // visor dude
			self.player_flag = self.player_flag - (self.player_flag & 65280);
			self.player_flag = self.player_flag | (self.skin * 256);  
		}

		self.weapon = W_BestWeapon();
		respawn();
		W_SetCurrentAmmo();
		return TRUE;
	}

//tony
//chaser
	if (self.impulse == 3)
	{
		if (self.fChasing == 0)
		{
			local entity p;
			local float done;
			p = find(world, classname, "player");
			while(p != world && !done)
			{
				p = find(p, classname, "player");
				if (p != self)
					done = 1;
			}

			if (p)
				self.eChaser = p;

			sprint(self, "Chasing ");
			sprint(self, self.eChaser.netname);
			sprint(self, "\n");
			self.fChasing = 1;
		}
		else
		{
			self.fChasing = 0;
		}
		self.impulse = 0;
		return;
	}

	CheckBotImpulseCommands();

	return FALSE;
};

void () ObserverThink =
{
    local entity e;
    local float cont;

	self.weaponmodel = "";
	self.weaponframe = 0;
	self.flags = self.flags | FL_ONGROUND;

//TONY
//chaser
//HUGE HUGE HACK!!
	if (self.fChasing)
	{
		self.angles = self.eChaser.angles;
		self.angles_x = 0 - (self.angles_x);
		self.fixangle = TRUE;
		setorigin(self, self.eChaser.origin + '0 0 30');

		TeamPlayerUpdate2(self, "Tracking : ", self.eChaser.netname);
		self.health = self.eChaser.health;
		self.armorvalue = self.eChaser.armorvalue;
		self.ammo_shells = self.eChaser.ammo_shells;
		self.ammo_nails = self.eChaser.ammo_nails;
		self.ammo_rockets = self.eChaser.ammo_rockets;
		self.ammo_cells = self.eChaser.ammo_cells;
		self.items = self.eChaser.items;
	}
	else
  { 
    local float invcos,nv,nvp,nvpmax,nvs,nsp,sp,svz;
    local vector f,vp,vs;
    
    svz = self.velocity_z * 0.75;
    self.velocity_z = 0;
    
    // v_forward is already normalized
    f_x = v_forward_x; 
    f_y = v_forward_y; 
    f_z = 0;
    invcos = vlen(f); if (invcos) invcos= 1/invcos; else invcos=0;
    f = f*invcos; // normalize f
    
    sp = f * self.velocity;
    vp = sp*f;
    nvp = vlen(vp); if (sp<0) nvp = nvp*(-1);
    vs = self.velocity - vp;
    
    vp = v_forward * (nvp * invcos);
    vp_z = vp_z + svz;
    nvp = vlen(vp);
    nvpmax = (320 - 100*(v_forward * '0 0 1'));
    if (nvp > nvpmax) { vp = vp * (nvpmax/nvp); }
    
    self.velocity = vp + vs;
 
  
//TONY
//who cares about doors, etc. we're NOCLIP now
	// look for doors, etc.
    e = findradius(self.origin,75);
    while (e != world) {
//		if (e.classname == "door") {
//			ObserverDoor(self, e);
//			e = world;
//		}
    	if (e.classname == "trigger_teleport") {
			ObserverTeleporter(self,e);
			e = world;
        }
        e = e.chain;
		if (!e) e = world;
    }

 }

//TONY
//REMOVED ADMIN.QC
//	if (self.impulse && self.accessparm) // admin functions
//	{
//		CheckAdminCmd();
//		self.impulse = 0;
//	}
//	else
	if (DoObserverImpulse())
	{
		return;
	}
//TONY
//REMOVED ADMIN.QC
	else if (self.impulse)
	{
		CheckAdminCmd();
		self.impulse = 0;
	}
};

void(entity player) BecomeObserver =
{
	player.takedamage       = DAMAGE_NO;
	player.solid            = SOLID_NOT;
//TONY
	player.movetype         = /*MOVETYPE_FLY*/MOVETYPE_NOCLIP;
	player.deadflag         = DEAD_NO;

	setmodel (player, string_null);

	player.weaponmodel      = "";
	player.weaponframe      = 0;
	player.weapon           = 0;

	setsize(player, '-12 -12 -12', '12 12 12');
	player.view_ofs = '0 0 10';

	player.observer = 1;
	player.do_observer = 0;

//TONY
//DROP FLAG and RUNE
//set some other stuff
	DropRune();
	TeamCaptureDropFlagOfPlayer(self);

	player.health = 666;

	player.ammo_shells = 69;
	player.ammo_nails = 69;
	player.ammo_rockets = 69;
	player.ammo_cells = 69;
	player.armorvalue = 69;
	player.currentammo = 69;

	player.items = 0;
	player.team = 0;
	player.lastteam = 0;
};

