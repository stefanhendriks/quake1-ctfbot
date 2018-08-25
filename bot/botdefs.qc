//botdefs.qc
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


//==============================================================================
// CONSTANTS		 
//==============================================================================

float FRIEND_BASE = 0;
float ENEMY_BASE = 1;

// bits for self.observer_flag
float PLAYER_NO_TARGET = 1;
float PLAYER_USING_CAMERA = 2;
float PLAYER_ALWAYS_ESCORT = 4;

//==============================================================================
//==============================================================================
// times
float CAMPING_TIME = 120;		// 2 minutes
float ESCORT_TIME = 120;		// 2 minutes
// not used float ATTACK_DEFEND_TIME = 60;

//==============================================================================
// values for bot_action field
//==============================================================================
float BOT_FIGHTING = 1;
float BOT_MOVING = 2;
float BOT_STANDING = 3;

//==============================================================================
// values for bot_plan field
//==============================================================================
float BOT_ATTACK = 1;
float BOT_DEFEND = 2;
float BOT_ROAM = 3;


//==============================================================================
// flags for registered cvar
//==============================================================================
//float BOT_CUSTOM_SOUNDS = 2;		// use different sounds for cap/take












//TONY
//EVERYTHING HERE WAS IN DEFS.QC

// CTFBOT [[[

//---------------------------------------------------
// flags only
float hook_use_enabled;
float bots_have_normal_names;
float smooth_move;
float map_has_waypoints;
float debug_markers_visible;
float bot_chatter_off;
float bot_chatter_rated_g;

//---------------------------------------------------
// candidates for deletion
float next_bot_num;

//---------------------------------------------------
// globals
float temp1;				// temp1 console variable
float bot_debug;
float next_bot_red;
float next_bot_blue;

float current_red_waypoint;
float current_blue_waypoint;
float current_waypoint;

float spawning_waypoints;
float spawning_general_waypoints;
//TONY REMOVED
//float cur_bot_cpu;

entity wp_first_red;
entity wp_last_red;
entity wp_first_blue;
entity wp_last_blue;
entity wp_first_general;
entity wp_last_general;
.entity wp_chain;

/*
entity wpheadred;			// doubly-linked list of red waypoints
entity wpheadblue;			// doubly-linked list of red waypoints
entity wpheadgeneral;		// doubly-linked list of red waypoints
entity wptailred;			// doubly-linked list of red waypoints
entity wptailblue;			// doubly-linked list of red waypoints
entity wptailgeneral;		// doubly-linked list of red waypoints
.entity wpprev;
.entity wpnext;
*/

.float last_status_bar_update;
//---------------------------------------------------
// global times
float last_flag_pickup;
float last_flag_capture;
float last_capture_team;
float last_pickup_team;
float last_order_time_team1;
float last_order_time_team2;

//TONY REMOVED
//float bot_ping;

float level_over_time;

.float shirt_color;
//---------------------------------------------------
// player flags
.float observer_flags;
.float disable_triggers;
.float toggle_ents_time;
//---------------------------------------------------
// item flags
.float bot_wants_item;		// optimization

//---------------------------------------------------
// bot flags

//---------------------------------------------------
// bot times
.float escort_time;
.float hook_snag_time;
.float last_say;
.float noticed_item_time;
.float next_waypoint_time;
.float trigger_search_time;
.float help_teammate_time;
.float getoutofwater_time;
.float find_enemy_time;
.float find_item_time;
.float watermove_time;

.float last_kill_time;
.entity last_kill_ent;
.float last_die_time;
.entity last_die_ent;

//---------------------------------------------------
// bot follow ent
.float last_follow_spawn;
.float num_follows;
.entity follow_head;
.entity follow_tail;
.entity follow_prev;
.entity follow_next;

//---------------------------------------------------
// bot fields
.vector current_velocity;
.float current_evade_yaw;
.vector camping_spot;
.float camping_time;
.float last_see_camp_ent;
.float bot_blocked;
.float bsort;

.float bot_ignore_until_time;
.float bot_ignore_team;
.float large_dist_pulse;
.float bogus_start;
.float dynamically_created;
.float spawn_time;
.vector oldorigin;
.float stuck_count;
.float enemy_team;
.float last_weapon_shot;
.float hooked_on_someone;
.entity bot_enemy;
.float bot_plan;

.entity debug_marker;
.entity camping_entity;
.entity escort_entity;

.string save_model;

.float enemy_notice_time;
.vector bot_aim;
.string altname;
.string botname;
.float rune_drop_time;
.float last_rune;
.float bot_action;	
.float old_waterlevel;
.float old_watertype;
.vector spawnorigin;
.float fire_hook_immediately;

.float simulated_client;
//---------------------------------------------------
// inaccessible item stuff
.entity inaccessible_entity;
.float get_item_stuck_count;
float num_inaccessible_entities;
.float inaccessible_count;

.float spawntime;
//---------------------------------------------------
// bot skill fields
.float bot_skill;
.float large_dist_pulse_items;

.float bsk_next_pulse_time;
.float bsk_next_pulse_time_items;
.float bsk_extra_large_pulse_dist;
.float bsk_extra_awareness_dist;
.float bsk_extra_jump_chance;
.float bsk_move_while_firing;
.float bot_skill_inverse;
.float bsk_evade_chance;
.float bsk_bot_fov;
.float bsk_reaction_time;

.float bsk_skill_lin1;
.float bsk_skill_lin2;
.float bsk_skill_lin3;

float large_pulse_dist_base;
float awareness_dist_base;
float item_large_pulse_dist_base;
float item_awareness_dist_base;

float large_pulse_dist;
float awareness_dist;
float item_large_pulse_dist;
float item_awareness_dist;

.vector gib_velocity;
.float lastweapon_shot;
.entity last_carrier;
.float flag_toss_time;
.float explore_item_num;
.string explore_item_name;
//---------------------------------------------------
// waypoint fields
.float waypoint_num;
.float shoot_triggers;
//---------------------------------------------------
// extra frame move
float use_extra_move_frame;
.void() extramove_oldthink;
.float extramove_yaw;
.float extramove_dist;
.float extramove_lastframewasextra;

float use_norse_movetogoal;

//---------------------------------------------------
// camera stuff
float last_camera_update;
float auto_camera_view;
float auto_fov_control;
entity cur_camera_watch_ent;
entity last_camera_ent;

float orig_flag1_health; // DTF
float orig_flag2_health; // DTF

entity goal_winner;		// INVASION

float registered;		// cvar

//---------------------------------------------------
// detailed scores
.float		num_kills;			// CTFBOT EXTRAS number of kills
.float		num_deaths;			// CTFBOT EXTRAS number of deaths
.float		num_suicides;		// CTFBOT EXTRAS number of suicides
.float		num_captures;		// CTFBOT EXTRAS number of personal flag captures 
.float 		num_pickups;		// CTFBOT EXTRAS number of personal enemy flag pickups
.float 		num_recovery;		// CTFBOT EXTRAS number of flag recoveries
.float 		num_assists;		// CTFBOT EXTRAS number of assists
.float 		num_bonus;			// CTFBOT EXTRAS number of general bonuses

//---------------------------------------------------
// unused
//.float suspicious_about_time;
//.vector suspicious_about;

// CTFBOT ]]]
