//TONY
//EVERYTHING IN HERE WAS IN DEFS.QC

// *TEAMPLAY*

.float          lastteam;       // The last team this player was a member of.

// *XXX* EXPERT CTF ALTERNATE SCORING

// time values

.float 		flag_since; 		// how long a player has had the flag
.float		last_returned_flag; 	// last time player returned his own flag
.float		last_fragged_carrier; 	// last time player fragged a flag carrier
.float		last_hurt_carrier; 	// last time player hurt the flag carrier

// *XXX* end 

// OBSERVER
.float observer;
.float do_observer;

//ADMIN
.float accesslvl; // current access level
//TONY
//REMOVED
//.float accessparm; // current access parm

// ZOID: Runes
float		ITEM_RUNE1_FLAG		= 1;
float		ITEM_RUNE2_FLAG		= 2;
float		ITEM_RUNE3_FLAG		= 4;
float		ITEM_RUNE4_FLAG		= 8;
float		ITEM_RUNE_MASK		= 15;

// ZOID: Capture the flag
float		ITEM_ENEMY_FLAG		= 16;
// TEAMPLAY
float		TEAM_STUFF_COLOR	= 32;

.float		motd_time;
.float		motd_count;

.float		suicide_count;
.float		killed;			// have we been killed yet

//McBain: PreviousWeaponCommand
.float		previous_weapon;	// one of the IT_SHOTGUN, etc flags


// CTF 4.0 [[[
float	capturespawned;
float	teamscored;		// non-zero if teams scored
float	gamestart;		// at start
.float		voted;			// non-zero if voted
//.float		motd_time;
//.float		motd_count;

