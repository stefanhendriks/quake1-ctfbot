//botmove.qc
//Copyright (C) 1998  Roscoe A. Sincero
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


/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*\
||          norse_movetogoal and related move functions          ||
||                   by Roscoe A. Sincero                        ||
||              e-mail: legion@keg.zymurgy.org                   ||
||                                                               ||
||                   Copyright(c) 1997                           ||
||                                                               ||
||                   Date: June 27, 1997 (v0.30)                 ||
||                   Date: July 03, 1997 (v0.31)                 ||
||                                                               ||
||                                                               ||
||     Permissions:  You are allowed to use these functions      ||
||                   provided that the original author,          ||
||                   Roscoe A. Sincero gets credit for coding    ||
||                   the functions and that your work is         ||
||                   is publically available to anyone and it    ||
||                   is *FREE*.                                  ||
\*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=*/

/*

   If you wish to add this code or portions of it in a commercial
   product, you will need to contact me _AND_ the individuals mentioned
   in my credits below.

   Norse_movetogoal package v0.31 by Roscoe A. Sincero

   Additional credits: Cameron Newham for Eliminatorbot v1.4.  If it wasn't
   for his bot, I would never had tried to create my own movetogoal
   function.  I had major problems in combining his bot with roambot
   and at the time I couldn't figure out why the bot would simply stop
   for no reason.  So I played around with the FL_ONGROUND flag.  From
   this, I formed the basis for the movetogoal function.  For the curious,
   it turns out that my problems were with those nested if-else block
   statements and had nothing to do with FL_ONGROUND.  The jumping code
   and swimming code used in the eliminatorbot formed the basis for the
   now complicated swim code and jump code.

   Jonathan E. Wright for Cujo v1.4.  I used the FINDLEDGE function and
   used ideas taken from various other functions related to finding gaps
   in the floor.


   NOTE: The swim code assumes that your bot executes a function very similar
         to WaterMove function found in client.qc.  To make your bot blow
         bubbles when it is feeling pain while under water, you must add
         the following line of code to the DeathBubblesSpawn function found
         in player.qc:

            self.owner.waterlevel = norse_waterlevel (self.owner);

         This line is placed *BEFORE* it checks for the owner's waterlevel.
         If the owner's waterlevel is not three, the function will return
         before it spawns any bubbles.

         It is assumed that the bot's initial think function is
         self.th_stand.  You may need to change this if you use a
         different think function.

   TO USE: To use the new movetogoal function simply replace all instances
           of ID's original movetogoal function with norse_movetogoal.
           You will also need to comment out or delete all lines associated
           with swimming and jumping over gaps.  If you want the bot to
           move at walking speed, replace movetogoal with
           norse_movetogoal (FALSE).  If you want the bot to move at
           running speed, use norse_movetogoal (TRUE).
         
           In addition, you also need to set self.speed = -1.  This is
           new for v0.31.  For example, if you want to use the default
           speeds for norse_movetogoal function, then you will need to
           replace all instances of movetogoal with the following:

               // remember to set self.speed to -1
               self.speed = -1;
               norse_movetogoal (TRUE);

           The above code instructs the bot to run.  If you wish to set
           the actual speed of the bot, then you do this:

               self.speed = 300;
               norse_movetogoal (TRUE);

           The above code instructs the bot to move at a speed you specified
           with self.speed.  As long as self.speed is greater than -1, you
           can specify the speed the bot can move to.

           self.speed only controls the speed the bot moves while ON LAND.
           It does not control its jumping nor its swimming abilities.

           Keep in mind this ratio when you are deciding what speed your
           bot should move with.  A bot speed of 448 is approximately equal
           to a player's speed of 320.

           Also new to v0.31 is the ability to specify a direction use
           self.movedir.  As long as self.goalentity does not equal world,
           you can specify a direction the bot can move to.  If self.movedir
           is equal to '0 0 0', then it will head towards self.goalentity.
           If self.movedir does not equal '0 0 0', then it will move towards
           the direction specified by self.movedir.

           Sample use of code:

           self.speed = 270;
           self.movedir = '0 100 0';
           norse_movetogoal (TRUE);
           self.movedir = '0 0 0';

           The last self.movedir resets the direction.  Otherwise, the next
           time norse_movetogoal is used, it will move in the direction
           specified by self.movedir.

           If you do not want to specify anything, do the following:
           self.speed = -1;
           self.movedir = '0 0 0';
           norse_movetogoal (TRUE);  *OR* norse_movetogoal (FALSE);

           
*/

// variables to be declared
.float   movetogoal_watchdog;
.vector  old_origin;
.entity   maker;



// function prototypes
void     ()             PlayerJump;
float    ()             norse_CheckWaterJump;
float    (entity me)    norse_checkgap;
void     ()             norse_blind_leap;
float    ()             norse_jump;
void     ()             norse_swim;
float    (entity me)    norse_jumpgoal;
void     ()             WaterMove;
float    (entity me)    norse_recognize_platform;
vector   (entity me)    real_origin;
float    (entity me)    norse_jump_barrier;
float    (entity targ)  visible;

float (entity me) norse_recognize_platform =
{

/*
   assumptions used for platform/door recognition
      a) platforms move up when activated
      b) doors move down when activated (eg. the platform-like entity
         on E1M1 near single-player start location that is activated by
         pressing button)

*/

   local vector   start, end;
   local float plat_speed;
   local vector   actual_origin;

   start = me.origin;
   end = start;
   end_z = end_z - 120;

   //bprint ("analyzing below feet\n");
   traceline (start, end, TRUE, self);
   plat_speed = vlen (trace_ent.velocity);

   if (trace_ent.classname == "plat")
   {
      if (plat_speed)
      {  
         actual_origin = real_origin (me.goalentity); 
         if (self.origin_z > (actual_origin_z + 64) )
         {
            // if bot's height is higher than goal, then bot is allowed
            // to move.
            return FALSE;
         }
         else
         {
            // goal is either not low enough or it is higher than bot,
            // so bot won't move while platform is moving upwards.
            return TRUE;
         }
      }
   }

   if (trace_ent.classname == "door")
   {
      if (plat_speed)
      {
         actual_origin = real_origin (me.goalentity);
         if (actual_origin_z > (self.origin_z + 64) )
         {
            // if goal's height is higher than bot, then bot is allowed
            // to move.
            return FALSE;
         }
         else
         {
            // bot is either not low enough or it is higher than goal,
            // so bot won't move while door is moving downwards.
            return TRUE;
         }
      }
   }

   return FALSE;
};

vector (entity me) real_origin =
{

   if ( (me.classname == "door") ||
        (me.classname == "plat") ||
        (me.classname == "func_button") ||
        (me.classname == "trigger_teleport") ||
        (me.classname == "trigger_multiple") ||
        (me.classname == "trigger_once") ||
        (me.classname == "func_wall") ||
        (me.classname == "trigger_secret"))
   {
      // the origins of these entities need to be calculated using
      // the vectors .absmin and .absmax

      return me.absmin + (me.absmax - me.absmin) * 0.5;
   }
   else
      return me.origin;


};

float (entity me) norse_waterlevel =
{

   local float pc;
//   local vector   ahead;
//   local vector start;
   if (me == world)
      return 0;

/*
   I originally took the waterlevel code from Jonathan E. Wright's
   CUJO_Waterlevel function of Cujo v1.4.  It has proven to be unreliable
   so I decided to use my own.
*/

//   local vector  dir, actual_origin, dir_angles;
//   actual_origin = real_origin(self.goalentity);
//   dir = (actual_origin - self.origin);
//   dir_angles = vectoangles (dir);
//   makevectors (dir_angles);

   //makevectors (me.angles);
//   ahead = v_forward;
//   ahead_z = 0;

   // check if water is at least eye/head level
//   pc = pointcontents (me.origin + ahead * 16 + v_up * 28);
   pc = pointcontents (me.origin + ' 0 0 28');

   if (pc == CONTENT_WATER || pc == CONTENT_SLIME || pc == CONTENT_LAVA)
   {
      me.watertype = pc;
      me.waterlevel = 3;
      return 3;   // liquid is at eye/head level, above mouth/nose
   }

   // check to see if water is below mouth
//   pc = pointcontents (me.origin + ahead * 16 + v_up * 4);
   pc = pointcontents (me.origin + '0 0 4');

   if (pc == CONTENT_WATER || pc == CONTENT_SLIME || pc == CONTENT_LAVA)
   {
      me.watertype = pc;
      me.waterlevel = 2;
      return 2;   // liquid is just above waist 
   }

   // check to see if water is feet level
//   pc = pointcontents (me.origin + ahead * 16 - v_up * 12);
   pc = pointcontents (me.origin - '0 0 12');

   if (pc == CONTENT_WATER || pc == CONTENT_SLIME || pc == CONTENT_LAVA)
   {
      me.watertype = pc;
      me.waterlevel = 1;
      return 1;   // liquid covers legs
   }

   // check to see if water is AT feet level
//   pc = pointcontents (me.origin + ahead * 16 - v_up * 22);
   pc = pointcontents (me.origin - '0 0 22');

   if (pc == CONTENT_WATER || pc == CONTENT_SLIME || pc == CONTENT_LAVA)
   {
      me.watertype = pc;
      me.waterlevel = 1;
      return 1;   // liquid covers legs
   }

//   start = me.origin;
//   start_z = start_z - 24;
   pc = pointcontents (me.origin - '0 0 24');
   if (pc == CONTENT_LAVA)
   {
      //bprint ("ouch! ouch! hot! hot!\n");
      me.watertype = pc;
      me.waterlevel = 1;
      return 1;
   }


   me.watertype = 0;
   me.waterlevel = 0;
   return 0;   // water, if any, is not significant


};


void(float run_type) norse_movetogoal =
{

   // norse_movetogoal was initially designed for chasing moving targets
   // and it was originally called bot_movetogoal in the doombot project.
   // However, modifications have been made so that, hopefully, it will
   // work great with non-moving targets as well.  Additional changes
   // were made to allow the bot to move in one direction but face another.

   // need to check if bot is on top of a moving entity
   if (norse_recognize_platform (self))
   {
      // bot is on a platform, so don't move
      self.velocity = '0 0 0';
      return;
   }

   // check to see if bot needs to swim.  It is assumed that the
   // WaterMove function is executed PRIOR to executing the movetogoal
   // function.
   if (norse_waterlevel(self) > 1)
   {
      norse_swim ();
      return;
   }

   // bot can not move if it is not on the ground.
   if (!(self.flags & FL_ONGROUND))
      return;

   local vector  dir, actual_origin;
   local vector   dir_angles;
   local float dist;

/* variable discriptions:

   dir:           this is the VECTOR direction that the bot is moving to
   dir_angles:    this vector contains the BEARING (angle of direction
                  in dir) and PITCH (up/down angle of dir).
   actual_origin: the actual origin of goal.  This is needed for entities
                  such as doors and teleporters.
   dist:          distance from goal
*/


   // it is usually a good idea to check to see if there is a gap in front
   // of the bot.  Bot will only check for gaps in the direction of its 
   // actual goal.  So, the owner of the bot can literally force the bot
   // to land in lava.  Enemies can not, however, since it will check for
   // gaps.
   local float gap;
   gap = norse_checkgap (self);

   local float jump_to_goal;
   jump_to_goal = norse_jumpgoal (self);

   if (gap)
   {
      if (norse_jump ())
      {
         //bprint ("norse jump\n");
         return;
      }
   }
   else if (norse_jump_barrier (self))
   {
      //bprint ("idiot jump\n");
      return;
   }
   else if (jump_to_goal)
   {
      //bprint ("Jumping to goal\n");
      norse_blind_leap ();
      return;
   }

//   bprint ("walking\n");
   if (self.movedir == '0 0 0')
   {
      actual_origin = real_origin(self.goalentity);
      dir = (actual_origin - self.origin);
      dist = vlen(dir);
   }
   else
   {
      actual_origin = real_origin(self.goalentity);
      dir = self.movedir;
      dist = vlen(dir);
   }


   if ((self.goalentity.classname == "player" ||
      self.goalentity.classname == "bot") && (self.goalentity != self.owner)
      && (self.goalentity != self.maker))
   {
      if (dist < 72 && self.movedir == '0 0 0')
      {
         // too close to live target already
         self.velocity_x = 0;
         self.velocity_y = 0;
         return;
      }
   }

   // bot is on the ground, so now take it off the ground to allow the bot
   // to move freely.
   if (self.flags & FL_ONGROUND)
      self.flags = self.flags - FL_ONGROUND;

   // initialize velocity of bot to 0,0,0
   self.velocity_x = self.velocity_y = self.velocity_z = 0;

   // based on the vector direction of bot, vectoangles function is
   // used to calculate dir_angles described above
   dir_angles = vectoangles (dir);

   // if bot is close enough to the target but it is at a very bad
   // pitch, bot will be stuck.  So to correct this problem, set
   // actual_origin_z to same height as bot and recalculate dir
   // and dir_angles.
   local vector   a, b;

   if ( (dist < (800)) && (dist > 32) && (dir_angles_x > 12) &&
      (self.movedir == '0 0 0'))
   {
      //actual_origin_z = self.origin_z;
      a = actual_origin; a_z = self.origin_z;
      dir = (a - self.origin);
      dir_angles = vectoangles (dir);
   }

   


   // if the enemy is the goal and the enemy is far above the bot,
   // then the bot will not chase the enemy.  It will stay at a
   // certain distance away.
   local float horiz_dist;
   a = actual_origin; a_z = 0;
   b = self.origin; b_z = 0;
   horiz_dist = fabs(vlen (a - b));
   local float r;
   r = random();
   r = r * 0.5;

   if (self.goalentity == self.enemy)
   {
      //bprint ("Checking \n");

      if ( (actual_origin_z - self.origin_z) > 160)
      {
         if (horiz_dist < 224 && self.movedir == '0 0 0')
         {
            // too close back away now
            //bprint ("backing awaying\n");
            dir = dir * (-1 - r);
            dir_angles = vectoangles (dir);
         }

      }

   }

   // calculate the velocity of the bot using dir as the basis where
   // dir is the VECTOR direction the bot is moving to.  If run_type
   // is true meaning bot is running, use running speed.  If run_type
   // is false, use walking speed. The variable .bot_skill is used
   // to store the skill level of the bot.  This has been commented
   // out and maximum skill of 3 is used instead.

   local float horizontal_speed;
   local float max_speed;

   if (run_type)
   {
      horizontal_speed = 336 + (32) * (3);//self.bot_skill);
   }      
   else
   {
      horizontal_speed = 240 + (32) * (3);//self.bot_skill);
   }

   // Need to cap speed of bot just in case, you decided to
   // use a skill level greater than 3.
   max_speed = 1.4 * (cvar("sv_maxspeed"));
   if (horizontal_speed > max_speed)
      horizontal_speed = max_speed;

   // if self.goalentity is self.owner or self.maker and
   // self.goalentity is too close to bot, bot will back up
   local float nohop;
   if (self.goalentity == self.owner ||
       self.goalentity == self.maker)
   {
      if (dist < 42)
      {
         //bprint ("backing away\n");
         dir = dir * -1;
         dir_angles = vectoangles (dir);
         horizontal_speed = 224;
         nohop = TRUE;
      }
      else if (dist < 72)
      {
         // close enough but not too close
         self.velocity_x = 0;
         self.velocity_y = 0;
         return;
      }

   }

   if (self.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (self.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }

   // v_forward, v_right, and v_up (forward direction, right, and up)
   // are calculated by using the makevectors function with dir_angles
   // as the basis for calculation.  Originally, self.angles, instead
   // of dir_angles, was used in the original bot_movetogoal function
   // where self.angles is the direction the bot is currently facing.
   // Since the purpose of this modified movetogoal function is to
   // allow the bot to move in one direction while facing another,
   // self.angles is no longer used.
   makevectors (dir_angles);









   // now need to check to see if there is a barrier at bot's orgin
   // in the way of bot.  if so, try to manuever around it.
   local vector left, right, left_end, right_end;
   local float left_block, right_block;
   local float block;
   block = dist * 2.5;  // this is equivalent to changing the direction by
                        // 68.2 degrees left or right depending on which
                        // way bot decides to go. remember, the length of
                        // dir is the distance between bot and goal so the
                        // amount you add to dir will have to take this into
                        // account.  Initially, I set the block factor to a
                        // value of 32.  If you don't take into account the
                        // distance, then if the bot is close to the goal, 
                        // the bot will make a very sharp change in 
                        // direction when avoiding obstacle.  That is, it
                        // will move 90 degrees.  If the goal is far away,
                        // bot will have a difficult time manuevering around
                        // obstacles.  By taking into account the distance,
                        // the bot's ability to move around obstacles will
                        // be the same no matter how far the goal is.

   left_block = right_block = FALSE;

   left = self.origin - v_right * 15;
   left_end = left + v_forward * 24;

   right = self.origin + v_right * 15;
   right_end = right + v_forward * 24;

   traceline (left, left_end, TRUE, self);
   if (trace_fraction != 1.0)
      left_block = TRUE;
   traceline (right, right_end, TRUE, self);
   if (trace_fraction != 1.0)
      right_block = TRUE;

   if (left_block && !right_block)
   {
      dir = dir + v_right * block;
      horizontal_speed = 160; // need to reduce speed 
   }
   else if (right_block && !left_block)
   {
      dir = dir + v_right * (0 - block);
      // QuakeC is pretty crappy.  It does not recognize "-block" so I use
      // (0 - block) which is the same thing.
      horizontal_speed = 160; // need to reduce speed 

      
   }
   else if (left_block && right_block)
   {
      left_block = right_block = FALSE;
      left = self.origin - v_right * 31;
      left_end = left + v_forward * 24;

      right = self.origin + v_right * 31;
      right_end = right + v_forward * 24;

      traceline (left, left_end, TRUE, self);
      if (trace_fraction != 1.0)
         left_block = TRUE;
      traceline (right, right_end, TRUE, self);
      if (trace_fraction != 1.0)
         right_block = TRUE;

      if (left_block && !right_block)
      {
         dir = dir + v_right * block;

      }
      else if (right_block && !left_block)
      {
         dir = dir + v_right * (0 - block);

      }
      else if (left_block && right_block)
      {

         left_block = right_block = FALSE;
         left = self.origin - v_right * 47;
         left_end = left + v_forward * 24;

         right = self.origin + v_right * 47;
         right_end = right + v_forward * 24;
   
         traceline (left, left_end, TRUE, self);
         if (trace_fraction != 1.0)
            left_block = TRUE;
         traceline (right, right_end, TRUE, self);
         if (trace_fraction != 1.0)
            right_block = TRUE;
   
         if (left_block && !right_block)
         {
            dir = dir + v_right * block;
   
         }
         else if (right_block && !left_block)
         {
            dir = dir + v_right * (0 - block);
   
         }
         else if (left_block && right_block)
         {
            left_block = right_block = FALSE;
            left = self.origin - v_right * 63;
            left_end = left + v_forward * 24;
   
            right = self.origin + v_right * 63;
            right_end = right + v_forward * 24;
      
            traceline (left, left_end, TRUE, self);
            if (trace_fraction != 1.0)
               left_block = TRUE;
            traceline (right, right_end, TRUE, self);
            if (trace_fraction != 1.0)
               right_block = TRUE;
      
            if (left_block && !right_block)
            {
               dir = dir + v_right * block;
      
            }
            else if (right_block && !left_block)
            {
               dir = dir + v_right * (0 - block);
      
            }
            else if (left_block && right_block)
            {
   
               dir = dir + v_forward * (0 - block);
            }
         }
      
      }

   }


   // now check to see if bot is not too close to the walls
   local vector start, end;
   start = self.origin;
   end = self.origin + v_right * 20;
   traceline (start, end, TRUE, self);
   if (trace_fraction != 1.0)
   {
      // wall too close on bot's right side so move a little to left
      dir = dir + v_right * (0 - block);
      horizontal_speed = 160;
   }

   start = self.origin;
   end = self.origin + v_right * (-20);
   traceline (start, end, TRUE, self);
   if (trace_fraction != 1.0)
   {
      // wall too close on bot's left side so move a little to right
      dir = dir + v_right * (block);
      horizontal_speed = 160;

   }


   // now check to see if it is heading towards a teleporter
   local entity   article;
   local entity   selected;
   article = world;
   article = findradius (self.origin, 128);

   while (article)
   {
      if (article.classname == "trigger_teleport")
      {
         selected = article;
      }         
      article = article.chain;
   }

   if (selected.classname == "trigger_teleport")
   {
      //bprint ("slowing down\n");
      // slow down to allow whoever is ahead of them to pass through
      horizontal_speed = 192;

   }


   // now normalize the vector direction.
   dir = normalize (dir);

   if (self.speed > -1)
      horizontal_speed = self.speed;

   self.velocity = horizontal_speed * dir;

   // Many times, the bot will get stuck.  The causes for this varies
   // greatly from goal is far below bot to a small object mearly two
   // or three units high blocking the foot of bot.

   local float hop_factor;
   local float checka1, checkb1;
   local float incline1;
   local float incline2;
   local float incline3;

   // hop factor is used if bot is on a map in which sv_gravity
   // has been altered.

   if (self.movetogoal_watchdog < time)
   {
      if (vlen(self.origin - self.old_origin) < 33)
      {
         if (self.goalentity.origin_z + 24 < self.origin_z)
         {
            // raise bot three units and reduce speed
            //bprint ("Raising bot by three\n");
            self.origin_z = self.origin_z + 3;
            self.velocity = self.velocity * 0.75;
         }
         else
         {
            // hop a little
            
//            bprint ("I'm hopping\n");
  //          bprint (ftos(self.waterlevel));
    //        bprint ("\n");
            
            if (self.waterlevel == 1)
            {
               local vector ahead;
               ahead = v_forward;
               ahead_z = 0;
               start = self.origin;
               start_z = start_z - 22;
               end = start;
               end = end + v_forward * 64;
               traceline (start, end, TRUE, self);

               if (trace_fraction < 1)
               {
                  //bprint ("barrier\n");
                  hop_factor = cvar ("sv_gravity");
                  hop_factor = hop_factor / 800;
                  self.origin_z = self.origin_z + 8;
                  self.velocity_z = 160 * hop_factor;


               }
               else
               {
                  
                  if (!nohop)
                  {
                     //bprint ("barrier 2\n");
                     hop_factor = cvar ("sv_gravity");
                     hop_factor = hop_factor / 800;
                     self.velocity_z = 56 * hop_factor;
                  }
               }


            }
            else
            {
               if (!nohop)
               {
                  hop_factor = cvar ("sv_gravity");
                  hop_factor = hop_factor / 800;

                  self.velocity_z = 160 * hop_factor;
               }
            }


         } 
      }

      self.movetogoal_watchdog = time + 0.27;
   }


   local vector   start, end, ahead;
   local vector projected_dest;
   local float LAVA_LEAP;

   // now need to determine if target is leading
   // bot into lava

   start = self.enemy.origin;
   end = start;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   end_z = end_z - 32;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;

   start = self.enemy.origin + normalize (self.enemy.velocity) * 12;
   end = start;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   end_z = end_z - 32;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   end_z = end_z - 56;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;

   start = self.enemy.origin + normalize (self.enemy.velocity) * 24;
   end = start;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   end_z = end_z - 32;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   end_z = end_z - 56;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;

   start = self.enemy.origin + normalize (self.enemy.velocity) * 36;
   end = start;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   end_z = end_z - 32;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   end_z = end_z - 56;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;

   projected_dest = self.enemy.origin + normalize (self.enemy.velocity) * 56;
   start = projected_dest;
   end = start;
   end_z = end_z - 32;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   traceline (start + v_right * 32, end + v_right * 32, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   traceline (start - v_right * 32, end - v_right * 32, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   if (LAVA_LEAP)
   {
      //bprint ("Player in lava\n");
      self.velocity_x = self.velocity_x * -0.1;
      self.velocity_y = self.velocity_y * -0.1;
      self.velocity_z = 0;
      self.goalentity = world;
      self.enemy = world;
      self.think = BotAnimationThink;	// self.th_stand;
      self.nextthink = time + 0.1;
   }
   

   // now need to check for steps and inclines
   local float trace1, trace2, trace3, trace4;
   local float z_factor;

   start = self.origin + v_forward * 16;
   end = start - '0 0 24';


   traceline (start, end, FALSE, self);
   trace1 = trace_fraction;
   traceline (start + v_right * 16, end + v_right * 16, FALSE, self);
   trace2 = trace_fraction;
   traceline (start - v_right * 16, end - v_right * 16, FALSE, self);
   trace3 = trace_fraction;
   
   if (trace1 < trace2)
      trace_fraction = trace1;
   else
      trace_fraction = trace2;

   if (trace3 < trace_fraction)
      trace_fraction = trace3;

   trace4 = trace_fraction;

   start = self.origin + v_forward * 32;
   end = start - '0 0 24';
   traceline (start + v_right * 16, end + v_right * 16, FALSE, self);
   trace1 = trace_fraction;
   traceline (start - v_right * 16, end - v_right * 16, FALSE, self);
   trace2 = trace_fraction;

   if (trace1 < trace2)
      trace_fraction = trace1;
   else
      trace_fraction = trace2;

   if (trace4 < trace_fraction)
      trace_fraction = trace4;


   if (self.waterlevel != 1.0)
   {
   if (trace_fraction < 0.9)
   {
      z_factor = floor (32 * (1 - trace_fraction));
      if (self.waterlevel == 1)
         bprint ("raising bot while in water bug\n");
      start = self.origin;
      //bprint ("z\n");
      start_z = start_z + z_factor;
      setorigin (self, start);
   }
   }
   self.old_origin = self.origin;

   self.nextthink = time + 0.08;
   
};

float (entity me) norse_jumpgoal =
{
   local vector  dir, actual_origin, dir_angles;
   local vector start, end;
   local float pc;
   local float dist;
   actual_origin = real_origin(me.goalentity);
   if (self.movedir == '0 0 0')
   {
      dir = (actual_origin - me.origin);
      dist = vlen (dir);
      dir_angles = vectoangles (dir);
   }
   else
   {
      dir = self.movedir;
      dist = vlen(dir);
      dir_angles = vectoangles (dir);
   }
      

   makevectors (dir_angles);

   if (self.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (self.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }

   // need to analyze environment to see if bot needs to jump
   // even if there is no gap to jump over

   if (dist < 64)
   {
      if (actual_origin_z > (me.origin_z + 16) )
      {
         // bot is close to target and origin of target is higher
         if ( (actual_origin_z - me.origin_z) < 80)
         {
            if (me.waterlevel < 2)
            {
               // below but close enough so jump and the bot is not
               // swimming
               return TRUE;
            }
         }
      }
   }

   if (norse_waterlevel (me) == 1)
   {
      if (me.watertype == CONTENT_LAVA)
      {

         //bprint ("ouch! ouch! hot! hot!\n");

         return TRUE;
      }
   }

   return FALSE;

};

float (entity me) norse_jump_barrier =
{

//   return FALSE;
   local vector  dir, actual_origin, dir_angles;
   local vector start, end;
   local float check1, check2, check3, check4, check5;
   local float pc;
   local float dist;
   actual_origin = real_origin(me.goalentity);
   if (self.movedir == '0 0 0')
   {
      dir = (actual_origin - me.origin);
      dist = vlen (dir);
      dir_angles = vectoangles (dir);
   }
   else
   {
      dir = self.movedir;
      dist = vlen (dir);
      dir_angles = vectoangles (dir);
   }

   makevectors (dir_angles);

   if (self.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (self.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }


   //if (dist < 96)
   //{
      // bot is pretty close to goal.  Now check to see if there is a
      // need to jump
      start = me.origin;
      start_z = start_z - 23;
      end = start + v_forward * (64);
      traceline (start, end, FALSE, self);
      check1 = trace_fraction;

      start = me.origin;
      start_z = start_z + 12;
      end = start + v_forward * (64);
      traceline (start, end, FALSE, self);
      check5 = trace_fraction;

      if (check5 == check1)
      {
         // there's a barrier above origin.  Probably a wall or player
         //bprint ("wall maybe?\n");
         return FALSE;
      }

      
      start = me.origin;
      start_z = start_z - 20;
      end = start + v_forward * (64);
      traceline (start, end, FALSE, self);
      check2 = trace_fraction;

      if (check2 != check1)
      {
         // not a barrier, probably steps or incline
         return FALSE;
      }
      
            
      start = me.origin;
      start_z = start_z - 15;
      end = start + v_forward * (64);
      traceline (start, end, FALSE, self);
      check3 = trace_fraction;
      if (check3 != check1)
      {
         // not a barrier, probably steps or incline
         return FALSE;
      }         
      

      
      start = me.origin;
      start_z = start_z - 8;
      end = start + v_forward * (64);
      traceline (start, end, FALSE, self);
      check4 = trace_fraction;

      
      if (check4 != check1)
      {
         // not a barrier, probably steps or incline
         return FALSE;
      }         

      

      if (trace_fraction < 1 && trace_fraction > 0.29)
      {
         // a solid barrier found, jump over it
         //bprint ("backing away from barrier\n");
         //bprint (ftos(trace_fraction));
         //bprint ("\n");

         if (trace_ent.classname != "player")
         {
            //bprint ("Jump up now\n");
            //norse_blind_leap ();
            self.flags = self.flags - (self.flags & FL_ONGROUND);

            self.velocity_x = v_forward_x * (64);
            self.velocity_y = v_forward_y * (64);
            self.velocity_z = 290;
// tony
// sex sounds
		if (self.sex == 2 && (temp1 & TEMP1_PLAYER2SOUNDS))
	            sound (self, CHAN_BODY, "player2/plyrjmp8.wav", 1, ATTN_NORM);
		else if (self.sex == 3 && (temp1 & TEMP1_PLAYER3SOUNDS))
	            sound (self, CHAN_BODY, "player3/plyrjmp8.wav", 1, ATTN_NORM);
		else if (self.sex == 4 && (temp1 & TEMP1_PLAYER4SOUNDS))
	            sound (self, CHAN_BODY, "player4/plyrjmp8.wav", 1, ATTN_NORM);
		else
	            sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);

            return TRUE;
         }
      }
      else if (trace_fraction <= 0.29)
      {
         // a solid barrier is found but bot is too close to jump over it
         //bprint ("backing away from barrier\n");
         //bprint (ftos(trace_fraction));
         //bprint ("\n");
         if (trace_ent.classname != "player")
         {
            self.flags = self.flags - (self.flags & FL_ONGROUND);

            self.velocity_x = v_forward_x * (-432);
            self.velocity_y = v_forward_y * (-432);

            return TRUE;
         }
      }

  // }

   return FALSE;
};


float (entity me) norse_checkgap =
{
   // checks if there is a gap.
   // returns TRUE if there is a non-walkable gap
   // returns FALSE is there is no gap or there is a
   // walkable gap

   local vector   start, end, ahead;
   local float dist;

   local float trace_dist, fwd_inc, out_dist;
   local float solid_count, i;

   local vector  dir, actual_origin, dir_angles;
   actual_origin = real_origin(self.goalentity);
   if (self.movedir == '0 0 0')
   {
      dir = (actual_origin - self.origin);
      dir_angles = vectoangles (dir);
   }
   else
   {
      dir = self.movedir;
      dir_angles = vectoangles (dir);
   }

   makevectors (dir_angles);

   if (self.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (self.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }


   ahead = v_forward;
   ahead_z = 0;

   if (vlen(me.velocity) > 0)
   {
      // check further ahead since bot is moving.
      // otherwise, bot won't have enough time to
      // jump and end up walking right off edges
      dist = 64;
      //bprint ("Speedy\n");
   }
   else
   {
      // if bot is not moving, then check one player
      // distance ahead.  bot "thickness" is 32 units
      //bprint ("slow poke\n");
      dist = 24;
   }

   // trace a line from bot origin to feet level dist units
   // away.  If a solid is found (ie. trace_fraction != 1)
   // then there is no gap

   start = me.origin;
   end = start - '0 0 25' + ahead * dist;
   traceline (start, end, TRUE, me);
   if (trace_fraction != 1.0)
   {
  //    bprint ("no gap1\n");
      return FALSE;
   }

   // bot did not find any solid directly in front at feet level
   // so a gap on the floor in front of bot has been found. however,
   // there maybe something in front of the bot that can prevent
   // the bot from jumping, thus, it is not actually a real gap.
   // so check for objects in front of bot both at origin height
   // and head level

   end = start + ahead * dist;
   traceline (start, end, TRUE, me);
   if (trace_fraction != 1.0)
   {
//      bprint ("no gap2\n");
      return FALSE;
   }

   end = start + ahead * dist + v_up * 33;
   traceline (start, end, TRUE, me);
   if (trace_fraction != 1.0)
   {
  //    bprint ("no gap3\n");
      return FALSE;
   }

   // a gap directly in front of bot has been found and no objects
   // in front of bot has been found to prevent jump.  now begin
   // analyzing gap to see if it is a gap worthy to jump over or
   // it is a small gap that bot can simply walk over (eg. rocket
   // launcher corridor on the START map)

   // code modified from Cujo v1.4

   trace_dist = 1000;
   fwd_inc = 8;
   start = me.origin + ahead * (dist - fwd_inc);
   end = start;
   end_z = end_z - trace_dist;
   solid_count = i = 0;

   while (i < 4)
   {

      start = start + ahead * fwd_inc;
      end = end + ahead * fwd_inc;

      // directly in front, 32 units below bot's feet (56 units
      // below bot's origin
      traceline (start, end, TRUE, me);
      if (trace_fraction * trace_dist < 56)
         solid_count = solid_count + 1;

      // at right of bot
      traceline (start + v_right * 15, end + v_right * 15, TRUE, me);
      if (trace_fraction * trace_dist < 56)
         solid_count = solid_count + 1;

      // at left of bot
      traceline (start - v_right * 15, end - v_right * 15, TRUE, me);
      if (trace_fraction * trace_dist < 56)
         solid_count = solid_count + 1;

      i = i + 1;

   }

   // if no solid is found from 64 (bot not moving) to 96 units (bot moving)
   // ahead of bot then there is a non-walkable gap.

   if (solid_count != 0)
   {
//      bprint ("no gap4\n");
      return FALSE;
   }

   // since the traceline function SUCKS bigtime, finding a
   // non-walkable gap does not mean that there is a non-walkable
   // gap.  So continue analyzing this ALLEDGED gap.  This is
   // performed by finding the ledge.  If no ledge is found, then
   // this gap is walkable.

   // code taken from Cujo v1.4

   local vector   above_start;
   local float highest;
   local float found_ledge;
   local float ledge_height;

   above_start = me.origin + v_up * 48;
   found_ledge = FALSE;

   ledge_height = 0.096;
   i = dist + 30;

   while ((i <= 320) && (!found_ledge))
   {
      start = above_start + (v_forward * (i + 30)) + (v_right * 15);
      end = start - (v_up * 1000);
      traceline (start, end, FALSE, me);
      highest = trace_fraction;

      if (trace_fraction <= ledge_height)
      {
         start = above_start + (v_forward * (i + 30)) - (v_right * 15);
         end = start - (v_up * 1000);
         traceline (start, end, FALSE, me);
         if (trace_fraction < highest)
            highest = trace_fraction;

         if (trace_fraction <= ledge_height)
         {
            start = above_start + (v_forward * i) + (v_right * 15);
            end = start - (v_up * 1000);
            traceline (start, end, FALSE, me);
            if (trace_fraction < highest)
               highest = trace_fraction;
            
            if (trace_fraction <= ledge_height)
            {
               start = above_start + (v_forward * i) - (v_right * 15);
               end = start - (v_up * 1000);
               traceline (start, end, FALSE, me);
               if (trace_fraction < highest)
                  highest = trace_fraction;

               if (trace_fraction <= ledge_height)
               {
                  start = above_start + (v_forward * (i + 15));
                  end = start - (v_up * 1000);
                  traceline (start, end, FALSE, me);
                  if (trace_fraction < highest)
                     highest = trace_fraction;
               
                  if (trace_fraction <= ledge_height)
                  {
                     start = above_start + (v_forward * (i + 7.5)) - (v_right * 7.5);
                     end = start - (v_up * 1000);
                     traceline (start, end, FALSE, me);
                     if (trace_fraction < highest)
                        highest = trace_fraction;
      
                     if (trace_fraction <= ledge_height)
                     {
                        start = above_start + (v_forward * (i + 7.5)) + (v_right * 7.5);
                        end = start - (v_up * 1000);
                        traceline (start, end, FALSE, me);
                        if (trace_fraction < highest)
                           highest = trace_fraction;

                        if (trace_fraction <= ledge_height)
                           found_ledge = TRUE;
                     }
                  }
               }
            }
         }
      }

      i = i + 30;
   }


   if (found_ledge)
   {
      //bprint ("jump\n");
      return TRUE;
   }
   else
   {
      //bprint ("don't jump");
      return FALSE;
   }

};

float () norse_jump =
{
   if (!(self.flags & FL_ONGROUND))
   {
      // bot is not on the ground, so can't jump
//      bprint ("can't jump, not on ground\n");
      return;
   }

   local float water_count;
   local float lava_count;
   local float trace_dist;
   local float fwd_inc;
   local float dist;
   local float i;
   local float pc;
   local float ht;
   local vector   start, end, ahead, left, right;
   local vector   left_end, right_end;

   local vector  dir, actual_origin, dir_angles;
   actual_origin = real_origin(self.goalentity);
   if (self.movedir == '0 0 0')
   {
      dir = (actual_origin - self.origin);
      dir_angles = vectoangles (dir);
   }
   else
   {
      dir = self.movedir;
      dir_angles = vectoangles (dir);
   }
      
   makevectors (dir_angles);

   if (self.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (self.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }


   if (vlen(self.velocity) > 0)
   {

      // check further ahead since bot is moving.
      // otherwise, bot won't have enough time to
      // jump and end up walking right off edges
      dist = 48;
   }
   else
   {
      // if bot is not moving, then check 1/2 player
      // distance ahead.  bot "thickness" is 32 units

      dist = 16;
   }

   trace_dist = 1000;
   fwd_inc = 2;

   start = self.origin + v_forward * dist;
   end = start;
   end_z = end_z - trace_dist;
   water_count = lava_count = 0;
   i = 0;

   while (i < 35 && !lava_count)
   {
      ahead = v_forward;
      ahead_z = 0;
      start = start + ahead * fwd_inc;
      end = end + ahead * fwd_inc;

      left = start - v_right * 16;
      left_end = end - v_right * 16;

      right = start + v_right * 16;
      right_end = end + v_right * 16;

      traceline (start, end, TRUE, self);
      if (trace_inwater)
      {
         pc = pointcontents (trace_endpos);
         if (pc == CONTENT_LAVA)
            lava_count = lava_count + 1;
         else
            water_count = water_count + 1;
      }

      traceline (left, left_end, TRUE, self);
      if (trace_inwater)
      {
         pc = pointcontents (trace_endpos);
         if (pc == CONTENT_LAVA)
            lava_count = lava_count + 1;
         else
            water_count = water_count + 1;
      }

      traceline (right, right_end, TRUE, self);
      if (trace_inwater)
      {
         pc = pointcontents (trace_endpos);
         if (pc == CONTENT_LAVA)
            lava_count = lava_count + 1;
         else
            water_count = water_count + 1;
      }


      i = i + 1;

   }

   local float goal_speed;
   local vector   projected_dest;
   local vector   norm_vel;
   local float projected_cont;
   local float projected_cont1;
   local float projected_cont2;
   local float projected_cont3;
   local float projected_cont4;
   local float projected_cont5;
   local float projected_cont6;
   local float projected_cont7;
   local float projected_cont8;
   local float projected_cont9;


   local float projected_dist;

   if (lava_count)
   {

      goal_speed = vlen (self.goalentity.velocity);

      if (!goal_speed && (self.goalentity != self.enemy))
      {
         // the gap is filled with lava
         // best to jump over it if the
         // goal is not moving
         // but don't jump if it is too far
         projected_dist = fabs(vlen (actual_origin - self.origin));

         if (projected_dist < 360)
         {
            //bprint ("Jumping over lava!\n");
            norse_blind_leap ();
            return TRUE;
         }
         else
         {
            // oops too far,...

            // changed June 7th, 1997
            // bot will jump it anyway
            norse_blind_leap ();
            return TRUE;

         }
      }
      else
      {
         // goal is moving, now need to determine
         // if goal is going to fall into lava
         start = actual_origin;
         end = start;
         traceline (start, end, TRUE, self.goalentity);
         projected_cont = pointcontents (trace_endpos);
         
         projected_dest = actual_origin + self.goalentity.velocity * 0.1;
         start = projected_dest;
         end = start;
         end_z = end_z - trace_dist;
         traceline (start, end, TRUE, self.goalentity);
         projected_cont1 = pointcontents (trace_endpos);
         projected_dest = actual_origin + self.goalentity.velocity * 0.2;
         start = projected_dest;
         end = start;
         end_z = end_z - trace_dist;
         traceline (start, end, TRUE, self.goalentity);
         projected_cont2 = pointcontents (trace_endpos);
         projected_dest = actual_origin + self.goalentity.velocity * 0.3;
         start = projected_dest;
         end = start;
         end_z = end_z - trace_dist;
         traceline (start, end, TRUE, self.goalentity);
         projected_cont3 = pointcontents (trace_endpos);
         projected_dest = actual_origin + self.goalentity.velocity * 0.05;
         start = projected_dest;
         end = start;
         end_z = end_z - trace_dist;
         traceline (start, end, TRUE, self.goalentity);
         projected_cont4 = pointcontents (trace_endpos);
         projected_dest = actual_origin + self.goalentity.velocity * 0.15;
         start = projected_dest;
         end = start;
         end_z = end_z - trace_dist;
         traceline (start, end, TRUE, self.goalentity);
         projected_cont5 = pointcontents (trace_endpos);
         projected_dest = actual_origin + self.goalentity.velocity * 0.25;
         start = projected_dest;
         end = start;
         end_z = end_z - trace_dist;
         traceline (start, end, TRUE, self.goalentity);
         projected_cont6 = pointcontents (trace_endpos);



         if (projected_cont == CONTENT_LAVA ||
            projected_cont1 == CONTENT_LAVA ||
            projected_cont2 == CONTENT_LAVA ||
            projected_cont3 == CONTENT_LAVA ||
            projected_cont4 == CONTENT_LAVA ||
            projected_cont5 == CONTENT_LAVA ||
            projected_cont6 == CONTENT_LAVA)
         {
            // bot has determined that moving goal is
            // going to land on lava, so don't jump
            // if the bot is wrong, then the bot will
            // appear to decide to stay in one place
            // while firing for a brief moment until
            // it realizes its error and continue the
            // chase.
            //bprint ("Not going to jump in lava\n");
            self.velocity_x = self.velocity_x * -0.2;
            self.velocity_y = self.velocity_y * -0.2;
            self.velocity_z = 0;
            self.goalentity = world;
            self.enemy = world;
            self.think = BotAnimationThink;	// self.th_stand;
            self.nextthink = time + 0.08;
            return TRUE;
         }
         else
         {
            // moving goal is not going to land in lava
            // so jump
            //bot_track_target ();
            norse_blind_leap ();
            return TRUE;
         }
      }

   }

   
   if (water_count)
   {
      // gap is filled with water or slime
      // now it is time to decide whether or not
      // to jump in
      
      goal_speed = vlen (self.goalentity.velocity);

      if (!goal_speed)
      {
         ht = self.goalentity.origin_z + 16 - self.origin_z;
         if (ht >= 0)
         {
            // non-moving goal is higher than bot so jump
            //bot_face ();
            norse_blind_leap ();
            return TRUE;
         }
         else
         {
            // non-moving goal is lower than bot, so don't jump
            return FALSE;
         }
      }
      else
      {
         // goal is moving
         projected_dest = actual_origin + self.goalentity.velocity * 0.2;
         ht = projected_dest_z + 16 - self.origin_z;

         if (ht >= 0)
         {
            // moving goal is higher than bot after 0.2 seconds
            // so jump
            //bot_track_target ();
            norse_blind_leap ();
            return TRUE;
         }
         else
         {
            // moving goal is not higher than bot after 0.2 seconds
            // so don't jump
            return FALSE;
         }
      }
   }         

   return FALSE;

};

void() norse_blind_leap =
{

   local float horizontal_speed;
   local float max_speed;

   local vector  dir, actual_origin, dir_angles;
   actual_origin = real_origin(self.goalentity);
   if (self.movedir == '0 0 0')
   {
      dir = (actual_origin - self.origin);
      dir_angles = vectoangles (dir);
   }
   else
   {
      dir = self.movedir;
      dir_angles = vectoangles (dir);
   }

   makevectors (dir_angles);

   if (self.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (self.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }


   horizontal_speed = 336 + (32) * (3);//self.bot_skill);

   // Need to cap speed of bot just in case, you decided to
   // use a skill level greater than 3.

   max_speed = 1.4 * (cvar("sv_maxspeed"));
   if (horizontal_speed > max_speed)
      horizontal_speed = max_speed;

   self.velocity_x = v_forward_x * horizontal_speed;
   self.velocity_y = v_forward_y * horizontal_speed;


	if ( !(self.flags & FL_JUMPRELEASED) )
      self.flags = self.flags + FL_JUMPRELEASED;

   PlayerJump ();

};

void() norse_swim =
{

   //bprint ("Swimming\n");
   local vector   norm_vel;
   local float pc, dist;

   local vector  dir, actual_origin, dir_angles;
   actual_origin = real_origin(self.goalentity);
   if (self.movedir == '0 0 0')
   {
      dir = (actual_origin - self.origin);
      dist = vlen(dir);
      dir_angles = vectoangles (dir);
   }
   else
   {
      dir = self.movedir;
      dist = vlen(dir);
      dir_angles = vectoangles (dir);
   }

   makevectors (dir_angles);

   if (self.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (self.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }


   self.waterlevel = norse_waterlevel (self);

   if (self.flags & FL_ONGROUND)
      self.flags = self.flags - FL_ONGROUND;

   if (self.goalentity == self.enemy)
      self.velocity_z = actual_origin_z + 16 - self.origin_z;
   else
      self.velocity_z = actual_origin_z + 56 - self.origin_z;
   
   local float test;
   local vector a;

   if (self.velocity_z > 0)
   {
      if (self.goalentity == self.enemy)
      {
         if (self.goalentity.waterlevel > 0)
            self.velocity_z = self.velocity_z * 4.0;
         else
         {
            if (self.waterlevel == 2)
            {
               if (norse_CheckWaterJump())
               {
                  test = TRUE;
                  return;
               }
               else
               {

                  a = self.origin;
                  a_z = a_z + 12;

                  test = pointcontents (a);
                  if (test == CONTENT_EMPTY)
                  {
                     //bprint ("out of water 1\n");
                     self.velocity_z = 0;
                  }
                  else
                  {
                     //bprint ("I'm swimming by myself 1\n");
                     self.velocity_z = 128;//self.velocity_z * 4.0;
                  }

               }
            }
            else
            {
               a = self.origin;
               a_z = a_z + 12;

               test = pointcontents (a);
               if (test == CONTENT_EMPTY)
               {
                  //bprint ("out of water 2\n");
                  self.velocity_z = 0;
               }
               else
               {
                  //bprint ("I'm swimming by myself 2\n");
                  self.velocity_z = 128;//self.velocity_z * 4.0;
               }

            }
         }

      }
      else
      {
         if (self.waterlevel == 2)
         {
                  a = self.origin;
                  a_z = a_z + 12;

                  test = pointcontents (a);
                  if (test == CONTENT_EMPTY)
                  {
                     //bprint ("out of water 1\n");
                     self.velocity_z = 0;
                  }
                  else
                  {
                    // bprint ("I'm swimming by myself 1\n");
                     self.velocity_z = 128;//self.velocity_z * 4.0;
                  }
         }
         else
         {
            //bprint ("Swimming towards goal\n");
            self.velocity_z = self.velocity_z * 2.0;
         }
      }
   }

   /*
   if (self.movetogoal_watchdog < time)
   {
      if (vlen(self.origin - self.old_origin) < 25)
      {
         bprint ("extra kick7\n");
         //if (self.velocity_z > 0)
         if (actual_origin_z > self.origin_z)
         {
            if (self.goalentity != self.enemy)
               self.velocity_z = self.velocity_z * 3.0;
         }
         else
            self.velocity_z = 0;


      }

      self.movetogoal_watchdog = time + 0.57;
   }
   */

//   self.air_finished = time + 20;

   self.waterlevel = norse_waterlevel (self);

   if (time > (self.air_finished - 2) && self.waterlevel > 2)
   {
      //bprint ("going up for air\n");
      // checks to see if bot needs to start going up for air
      traceline (self.origin, self.origin + '0 0 64', TRUE, self);
      if (trace_inopen)
      {
         // bot only goes up if nothing is blocking it from above
        self.velocity_z = 270 + random() * 40;
      }
      else
      {
         traceline (self.origin, self.origin + '0 0 128', TRUE, self);
         if (trace_inopen)
         {
            // bot only goes up if nothing is blocking it from above
            self.velocity_z = 270 + random() * 40;
         }
         else
         {
            traceline (self.origin, self.origin + '0 0 192', TRUE, self);
            if (trace_inopen)
            {
               // bot only goes up if nothing is blocking it from above
               self.velocity_z = 270 + random() * 40;
            }
            else
            {
               traceline (self.origin, self.origin + '0 0 256', TRUE, self);
               if (trace_inopen)
               {
                  // bot only goes up if nothing is blocking it from above
                  self.velocity_z = 270 + random() * 40;
               }
               else
               {
                  traceline (self.origin, self.origin + '0 0 320', TRUE, self);
                  if (trace_inopen)
                  {
                     // bot only goes up if nothing is blocking it from above
                     self.velocity_z = 270 + random() * 40;
                  }
                  else
                  {
                     traceline (self.origin, self.origin + '0 0 384', TRUE, self);
                     if (trace_inopen)
                     {
                        // bot only goes up if nothing is blocking it from above
                        self.velocity_z = 270 + random() * 40;
                     }
                     else
                     {
                        traceline (self.origin, self.origin + '0 0 448', TRUE, self);
                        if (trace_inopen)
                        {
                           // bot only goes up if nothing is blocking it from above
                           self.velocity_z = 270 + random() * 40;
                        }
                        else
                        {
                           traceline (self.origin, self.origin + '0 0 512', TRUE, self);
                           if (trace_inopen)
                           {
                              // bot only goes up if nothing is blocking it from above
                              self.velocity_z = 270 + random() * 40;
                           }
                           else
                           {
                              traceline (self.origin, self.origin + '0 0 576', TRUE, self);
                              if (trace_inopen)
                              {
                                 // bot only goes up if nothing is blocking it from above
                                 self.velocity_z = 270 + random() * 40;
                              }
                              else
                              {
                                 traceline (self.origin, self.origin + '0 0 640', TRUE, self);
                                 if (trace_inopen)
                                 {
                                    // bot only goes up if nothing is blocking it from above
                                    self.velocity_z = 270 + random() * 40;
                                 }
                                 else
                                 {
                                    traceline (self.origin, self.origin + '0 0 704', TRUE, self);
                                    if (trace_inopen)
                                    {
                                       // bot only goes up if nothing is blocking it from above
                                       self.velocity_z = 270 + random() * 40;
                                    }
                                    else
                                    {
                                       traceline (self.origin, self.origin + '0 0 768', TRUE, self);
                                       if (trace_inopen)
                                       {
                                          // bot only goes up if nothing is blocking it from above
                                          self.velocity_z = 270 + random() * 40;
                                       }
                                       else
                                       {
                                          traceline (self.origin, self.origin + '0 0 832', TRUE, self);
                                          if (trace_inopen)
                                          {
                                             // bot only goes up if nothing is blocking it from above
                                             self.velocity_z = 270 + random() * 40;
                                          }
                                          else
                                          {
                                             traceline (self.origin, self.origin + '0 0 896', TRUE, self);
                                             if (trace_inopen)
                                             {
                                                // bot only goes up if nothing is blocking it from above
                                                self.velocity_z = 270 + random() * 40;
                                             }
                                             else
                                             {
                                                traceline (self.origin, self.origin + '0 0 960', TRUE, self);
                                                if (trace_inopen)
                                                {
                                                   // bot only goes up if nothing is blocking it from above
                                                   self.velocity_z = 270 + random() * 40;
                                                }
                                                else
                                                {
                                                   traceline (self.origin, self.origin + '0 0 1024', TRUE, self);
                                                   if (trace_inopen)
                                                   {
                                                      // bot only goes up if nothing is blocking it from above
                                                      self.velocity_z = 270 + random() * 40;
                                                   }
                                                   else
                                                   {
                                                      traceline (self.origin, self.origin + '0 0 1152', TRUE, self);
                                                      if (trace_inopen)
                                                      {
                                                         // bot only goes up if nothing is blocking it from above
                                                         self.velocity_z = 270 + random() * 40;
                                                      }
                                                      else
                                                      {
                                                         traceline (self.origin, self.origin + '0 0 1280', TRUE, self);
                                                         if (trace_inopen)
                                                         {
                                                            // bot only goes up if nothing is blocking it from above
                                                            self.velocity_z = 270 + random() * 40;
                                                         }
                                                         else
                                                         {
                                                            traceline (self.origin, self.origin + '0 0 1408', TRUE, self);
                                                            if (trace_inopen)
                                                            {
                                                               // bot only goes up if nothing is blocking it from above
                                                               self.velocity_z = 270 + random() * 40;
                                                            }
                                                            else
                                                            {
                                                               traceline (self.origin, self.origin + '0 0 1536', TRUE, self);
                                                               if (trace_inopen)
                                                               {
                                                                  // bot only goes up if nothing is blocking it from above
                                                                  self.velocity_z = 270 + random() * 40;
                                                               }
                                                               else
                                                               {
                                                                  traceline (self.origin, self.origin + '0 0 1664', TRUE, self);
                                                                  if (trace_inopen)
                                                                  {
                                                                     // bot only goes up if nothing is blocking it from above
                                                                     // at this depth and with only 2 seconds, the
                                                                     // the bot should be suffering damage
                                                                     self.velocity_z = 270 + random() * 40;
                                                                  }
                                                                  else
                                                                  {
                                                                     traceline (self.origin, self.origin + '0 0 1792', TRUE, self);
                                                                     if (trace_inopen)
                                                                     {
                                                                        // bot only goes up if nothing is blocking it from above
                                                                        // at this depth and with only 2 seconds, the
                                                                        // the bot should be suffering damage
                                                                        self.velocity_z = 270 + random() * 40;
                                                                     }
                                                                     else
                                                                     {
                                                                        traceline (self.origin, self.origin + '0 0 1920', TRUE, self);
                                                                        if (trace_inopen)
                                                                        {
                                                                           // bot only goes up if nothing is blocking it from above
                                                                           // at this depth and with only 2 seconds, the
                                                                           // the bot should be suffering damage
                                                                           self.velocity_z = 270 + random() * 40;
                                                                        }
                                                                        else
                                                                        {
                                                                           traceline (self.origin, self.origin + '0 0 2048', TRUE, self);
                                                                           if (trace_inopen)
                                                                           {
                                                                              // bot only goes up if nothing is blocking it from above
                                                                              // at this depth and with only 2 seconds, the
                                                                              // the bot should be suffering damage
                                                                              self.velocity_z = 270 + random() * 40;
                                                                           }
                                                                           else
                                                                           {
                                                                              traceline (self.origin, self.origin + '0 0 2304', TRUE, self);
                                                                              if (trace_inopen)
                                                                              {
                                                                                 // bot only goes up if nothing is blocking it from above
                                                                                 // at this depth and with only 2 seconds, the
                                                                                 // the bot should be suffering damage

                                                                                 // need to check for these extreme depths to make sure
                                                                                 // bot does not give up so easily
                                                                                 self.velocity_z = 270 + random() * 40;
                                                                              }
                                                                              else
                                                                              {
                                                                                 traceline (self.origin, self.origin + '0 0 2560', TRUE, self);
                                                                                 if (trace_inopen)
                                                                                 {
                                                                                    // bot only goes up if nothing is blocking it from above
                                                                                    // at this depth and with only 2 seconds, the
                                                                                    // the bot should be suffering damage

                                                                                    // need to check for these extreme depths to make sure
                                                                                    // bot does not give up so easily
                                                                                    self.velocity_z = 270 + random() * 40;
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                    traceline (self.origin, self.origin + '0 0 2816', TRUE, self);
                                                                                    if (trace_inopen)
                                                                                    {
                                                                                       // bot only goes up if nothing is blocking it from above
                                                                                       // at this depth and with only 2 seconds, the
                                                                                       // the bot should be suffering damage

                                                                                       // need to check for these extreme depths to make sure
                                                                                       // bot does not give up so easily

                                                                                       // at this depth, bot may not make if it doesn't have
                                                                                       // enough health and armor.  But bot will try anyway.
                                                                                       self.velocity_z = 270 + random() * 40;
                                                                                    }

                                                                                 }

                                                                              }

                                                                           }

                                                                        }

                                                                     }

                                                                  }


                                                               }

                                                            }

                                                         }

                                                      }

                                                   }
                                                }
                                             }

                                          }

                                       }

                                    }
                                 }
                              }

                           }
                        }

                     }


                  }
               }


            }


         }


      }
   }

   // now need to check to see if there is a barrier at bot's orgin
   // in the way of bot.  if so, try to manuever around it.

   local vector left, right, left_end, right_end;
   local float left_block, right_block;

   left_block = right_block = FALSE;

   left = self.origin - v_right * 15;
   left_end = left + v_forward * 24;

   right = self.origin + v_right * 15;
   right_end = right + v_forward * 24;

   traceline (left, left_end, TRUE, self);
   if (trace_fraction != 1.0)
      left_block = TRUE;
   traceline (right, right_end, TRUE, self);
   if (trace_fraction != 1.0)
      right_block = TRUE;

   if (left_block && !right_block)
   {
      dir = dir + v_right * 32;
   }
   else if (right_block && !left_block)
   {
      dir = dir + v_right * (-32);
   }
   else if (left_block && right_block)
   {
      left_block = right_block = FALSE;
      left = self.origin - v_right * 31;
      left_end = left + v_forward * 24;

      right = self.origin + v_right * 31;
      right_end = right + v_forward * 24;

      traceline (left, left_end, TRUE, self);
      if (trace_fraction != 1.0)
         left_block = TRUE;
      traceline (right, right_end, TRUE, self);
      if (trace_fraction != 1.0)
         right_block = TRUE;

      if (left_block && !right_block)
      {
         dir = dir + v_right * 32;

      }
      else if (right_block && !left_block)
      {
         dir = dir + v_right * (-32);

      }
      else if (left_block && right_block)
      {

         left_block = right_block = FALSE;
         left = self.origin - v_right * 47;
         left_end = left + v_forward * 24;

         right = self.origin + v_right * 47;
         right_end = right + v_forward * 24;
   
         traceline (left, left_end, TRUE, self);
         if (trace_fraction != 1.0)
            left_block = TRUE;
         traceline (right, right_end, TRUE, self);
         if (trace_fraction != 1.0)
            right_block = TRUE;
   
         if (left_block && !right_block)
         {
            dir = dir + v_right * 32;
   
         }
         else if (right_block && !left_block)
         {
            dir = dir + v_right * (-32);
   
         }
         else if (left_block && right_block)
         {
            left_block = right_block = FALSE;
            left = self.origin - v_right * 63;
            left_end = left + v_forward * 24;
   
            right = self.origin + v_right * 63;
            right_end = right + v_forward * 24;
      
            traceline (left, left_end, TRUE, self);
            if (trace_fraction != 1.0)
               left_block = TRUE;
            traceline (right, right_end, TRUE, self);
            if (trace_fraction != 1.0)
               right_block = TRUE;
      
            if (left_block && !right_block)
            {
               dir = dir + v_right * 32;
      
            }
            else if (right_block && !left_block)
            {
               dir = dir + v_right * (-32);
      
            }
            else if (left_block && right_block)
            {
   
               dir = dir + v_forward * (-32);
            }
         }
      
      }

   }


   // now check to see if bot is not too close to the walls
   local vector start, end;
   start = self.origin;
   end = self.origin + v_right * 20;
   traceline (start, end, TRUE, self);
   if (trace_fraction != 1.0)
   {
      // wall too close on bot's right side so move a little to left
      dir = dir + v_right * (-32);
   }

   start = self.origin;
   end = self.origin + v_right * (-20);
   traceline (start, end, TRUE, self);
   if (trace_fraction != 1.0)
   {
      // wall too close on bot's left side so move a little to right
      dir = dir + v_right * (32);
   }


   self.velocity_x = dir_x;
   self.velocity_y = dir_y;

   local vector h1, h2;
   h1 = self.origin; h1_z = 0;
   h2 = actual_origin; h2_z = 0;

   if (self.goalentity == self.enemy && self.goalentity != self.owner &&
   self.goalentity != self.maker)
   if (fabs(vlen(h2 - h1)) < 64)
   {
      self.velocity_x = 0;
      self.velocity_y = 0;
   }

   // if self.goalentity is self.owner or self.maker and
   // self.goalentity is too close to bot, bot will back up
   if (self.goalentity == self.owner ||
       self.goalentity == self.maker)
   {
      if (dist < 42)
      {
         //bprint ("backing away while swimming\n");
         self.velocity_x = self.velocity_x * -1;
         self.velocity_y = self.velocity_y * -1;

      }
      else if (dist < 72)
      {
         // close enough but not too close
         //bprint ("close enough\n");
         self.velocity_x = 0;
         self.velocity_y = 0;
      }

   }

   // if the enemy is the goal and the enemy is far above the bot,
   // then the bot will not chase the enemy.  It will stay at a
   // certain distance away.
   local float horiz_dist;
   local vector b;
   a = actual_origin; a_z = 0;
   b = self.origin; b_z = 0;
   horiz_dist = fabs(vlen (a - b));

   if (self.goalentity == self.enemy)
   {
      //bprint ("Checking \n");

      if ( (actual_origin_z - self.origin_z) > 160)
      {
         if (horiz_dist < 224)
         {
            // too close back away now
            //bprint ("backing awaying\n");
            self.velocity_x = self.velocity_x * -1;
            self.velocity_y = self.velocity_y * -1;
            
         }

      }

   }

   norm_vel = normalize (self.velocity) * 72;
   norm_vel_z = 0;


   self.velocity = self.velocity + norm_vel;


   
};


float() norse_CheckWaterJump =
{

// This is a major hack to keep the bot from jumping out of water
// when a target is in sight BUT it is too far up to get to.

   if ( (self.enemy.origin_z > (self.origin_z + 96)) && self.enemy != world)
   {
      //bprint ("Target is too high up, don't bother\n");
      return FALSE;
   }

   if (self.enemy)
   {
      // an enemy has been selected
      if (!visible(self.enemy))
      {
         //bprint ("Enemy is not visible\n");
         return FALSE;
      }
   }


//   bprint ("Water jump\n");
	local vector start, end;
   local float waste;   
   local float dist;
   local float checka1, checka2, checka3;
   local float checkb1, checkb2, checkb3;
   local float incline1, incline2, incline3;

/*
   For the bot to jump out of water, it is required that the bot is
   given a reason to jump out of water.  Otherwise, it will stay in
   the water.  If the bot's goal, for instance, is out of the water
   and close the ledge, then the bot will jump out.  But if the bot's
   goal is out of the water, not close to the ledge (doesn't have to
   be far), and it is actually at the same height as the bot or even
   below the bot, then the bot does not have a reason to jump out.
   In this case, the coordinates of the goal tells the bot to swim
   forward and may be go down a little, not jump out.
*/

// check for a jump-out-of-water
// self.angles is used.  This means that bot can only jump out of water
// if it is facing the right direction.  Thus, it can't jump out of water
// backwards.
	makevectors (self.angles);
	v_forward_z = 0;
	normalize(v_forward);

   // incline check
   start = self.origin;
   start_z = start_z - 22;
	traceline (start, end, TRUE, self);
   checka1 = trace_fraction * 80;
   if (trace_fraction < 1)
   {
      waste = TRUE;
      start = self.origin;
      start_z = start_z - 19; 
      v_forward_z = 0;
      normalize(v_forward);
      end = start + v_forward*80;
      traceline (start, end, TRUE, self);
      checkb1 = trace_fraction * 80;
      if (checka1 < checkb1)
      {
         incline1 = TRUE;
         //bprint ("Incline check point 1\n");
      }

      //if (trace_fraction != check)
      //   bprint ("Possible incline\n");
   }

   start = self.origin;
   start_z = start_z - 17;
	traceline (start, end, TRUE, self);
   checka1 = trace_fraction * 80;
   if (trace_fraction < 1)
   {
      waste = TRUE;
      start = self.origin;
      start_z = start_z - 14; 
      v_forward_z = 0;
      normalize(v_forward);
      end = start + v_forward*80;
      traceline (start, end, TRUE, self);
      checkb1 = trace_fraction * 80;
      if (checka1 < checkb1)
      {
         incline2 = TRUE;
         //bprint ("Incline check point 2\n");
      }

      //if (trace_fraction != check)
      //   bprint ("Possible incline\n");
   }

   start = self.origin;
   start_z = start_z - 12;
	traceline (start, end, TRUE, self);
   checka1 = trace_fraction * 80;
   if (trace_fraction < 1)
   {
      waste = TRUE;
      start = self.origin;
      start_z = start_z - 7; 
      v_forward_z = 0;
      normalize(v_forward);
      end = start + v_forward*80;
      traceline (start, end, TRUE, self);
      checkb1 = trace_fraction * 80;
      if (checka1 < checkb1)
      {
         incline3 = TRUE;
         //bprint ("Incline check point 3\n");
      }

      //if (trace_fraction != check)
      //   bprint ("Possible incline\n");
   }

   if (incline1 && incline2 && incline3)
   {
      //bprint ("Incline detected\n");
      self.origin_z = self.origin_z + 8;

      self.velocity_x = v_forward_x * 72;
      self.velocity_y = v_forward_y * 72;
      //self.velocity_z = 240;

      self.velocity_z = 160;

      return TRUE;

   }





	start = self.origin;
	start_z = start_z + 8; 
   end = start + v_forward*80;
	traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
   {
      waste = TRUE;
   }




	start = self.origin;
   start_z = start_z + 4; 
   end = start + v_forward*80;
	traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
   {
      waste = TRUE;
   }

   start = self.origin;
   start_z = start_z + 12; 
   end = start + v_forward*80;
	traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
   {
      waste = TRUE;
   }


   start = self.origin;
   start_z = start_z + 16; 
   end = start + v_forward*80;
	traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
   {
      waste = TRUE;
      //bprint ("High block 1\n");
      //return FALSE;

   }

   start = self.origin;
   start_z = start_z + 20; 
   end = start + v_forward*80;
	traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
   {
      waste = TRUE;
      //bprint ("High block 2\n");
      //return FALSE;

   }


   start = self.origin;
   start_z = start_z - 4; 
   end = start + v_forward*80;
	traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
   {
      waste = TRUE;
   }

   start = self.origin;
   start_z = start_z - 8; 
   end = start + v_forward*80;
	traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
   {
      waste = TRUE;
   }

	start = self.origin;
   end = start + v_forward*80;
	traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
      waste = TRUE;

   if (waste)  // homonyms
	{	// solid at waist

		start_z = start_z + self.maxs_z - 8;
      end = start + v_forward*128;
      //self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);

/*
      if (trace_fraction != 1.0 &&
          trace_fraction > 0.6)
      {
         bprint ("Too far\n");

      }
*/
		if (trace_fraction == 1)
		{	// open at eye level

            start = self.origin;
            start_z = start_z + 8;
            end = start + v_forward * 80;
            traceline (start, end, TRUE, self);
            dist = trace_fraction;

            start = self.origin;
            start_z = start_z + 4; 
            end = start + v_forward*80;
            traceline (start, end, TRUE, self);
            if (trace_fraction < 1)
            if (trace_fraction < dist)
               dist = trace_fraction;

            start = self.origin;
            start_z = start_z + 12; 
            end = start + v_forward*80;
            traceline (start, end, TRUE, self);
            if (trace_fraction < 1)
            if (trace_fraction < dist)
               dist = trace_fraction;

            start = self.origin;
            start_z = start_z + 16; 
            end = start + v_forward*80;
            traceline (start, end, TRUE, self);
            if (trace_fraction < 1)
            if (trace_fraction < dist)
               dist = trace_fraction;

            start = self.origin;
            start_z = start_z + 20; 
            end = start + v_forward*80;
            traceline (start, end, TRUE, self);
            if (trace_fraction < 1)
            if (trace_fraction < dist)
               dist = trace_fraction;

            start = self.origin;
            start_z = start_z - 4; 
            end = start + v_forward*80;
            traceline (start, end, TRUE, self);
            if (trace_fraction < 1)
            if (trace_fraction < dist)
               dist = trace_fraction;

            start = self.origin;
            start_z = start_z - 8; 
            end = start + v_forward*80;
            traceline (start, end, TRUE, self);
            if (trace_fraction < 1)
            if (trace_fraction < dist)
               dist = trace_fraction;

            start = self.origin;
            end = start + v_forward*80;
            traceline (start, end, TRUE, self);
            if (trace_fraction < 1)
            if (trace_fraction < dist)
               dist = trace_fraction;

            if (dist <0.72)
            {
               //bprint ("Too close to jump\n");

               // bot is too close to ledge to jump out of water
               // so move backwards away from ledge.
               self.velocity_x = v_forward_x * -176;
               self.velocity_y = v_forward_y * -176;
               return TRUE;

            }
            //bprint ("Trying to get out of water\n");

            self.velocity_x = v_forward_x * 144;
            self.velocity_y = v_forward_y * 144;
            self.velocity_z = 336;
            return TRUE;

		}
	}
};


/*
   The following is unfinished code planned for v0.32 of norse_movetogoal.
   It is currently tested on REAL players by having these functions attached
   to impulse commands.  Thus, I know it works for real players.  It has
   not been implemented on bots, yet.  The question with bots concerns
   whether or not it has enough time to notice the traps and decide which
   direction to go before it is too late.  This is the *SAME* problem I
   had with checking for gaps.  That is why bots will sometimes walk right
   off the ledge and into lava.

   Yes, you read right.  It is code for avoiding TRAPS!

*/

void() trap_touch =
{
   
   // bprint ("Touched trap\n");

   // this function does nothing.  By the time the bot touches the
   // trap, it is too late.
   return;


};

void(vector set_trap, entity me) spawn_trap =
{

   local vector set_trap_now;
   set_trap_now = set_trap;
   //set_trap_now_z = me.origin_z;
   local entity   trap;
   local entity   article;
   local vector   trap_origin;
   local float dist, trap_dist;
   local vector quake_bug_workaround;

   article = findradius (me.origin, 128);
   trap_dist = 9999;

   //bprint ("looking for a trap\n");
   while (article)
   {
      //bprint (article.classname);
      //bprint ("\n");
      if (article.classname == "bubble_trap")
      {

         //bprint ("found a trap\n");
            trap_origin = real_origin (article);

            dist = vlen(trap_origin - me.origin);

            if (dist < trap_dist)
            {
               trap = article;
               trap_dist = dist;
               /*
            bprint (vtos(trap_origin));
            bprint (" ");
            bprint (vtos(set_trap));
            bprint ("\n");
                 */
            }
      }

      article = article.chain;

   }

   if (trap_origin == set_trap_now)
   {
      //bprint ("trap already set\n");
      return;
   }      

   local entity   bubble;
	bubble = spawn();
   bubble.classname = "bubble_trap";

   bubble.touch = trap_touch;
	setmodel (bubble, "progs/s_bubble.spr");
   setorigin (bubble, set_trap_now);
   //bubble.movetype = MOVETYPE_NOCLIP;
   bubble.movetype = MOVETYPE_NONE;

   //bubble.solid = SOLID_NOT;
   bubble.solid = SOLID_TRIGGER;

	setsize (bubble, '-8 -8 -8', '8 8 8');

};




void (entity me) find_trap =
{
   local entity   trap;
   local entity   article;
   local vector   trap_origin;
   local float dist, trap_dist;
   local vector quake_bug_workaround;

   trap_dist = 9999;
   article = findradius (me.origin, 128);

   while (article)
   {
      /*
      bprint (article.classname);
      bprint (" ");
      trap_origin = real_origin (article);
      bprint (vtos(trap_origin));
      bprint ("\n");
      bprint ("self = ");
      bprint (vtos(me.origin));
      bprint ("\n");
      */
      
      if (article.classname == "trap_spikeshooter" ||
         article.classname == "trap_shooter" ||
         article.classname == "func_wall" ||
         article.classname == "trigger_multiple")
      {

         //if (article.health)
         //{
            //quake_bug_workaround = real_origin - me.origin;
            //dist = vlen(quake_bug_workaround);
            trap_origin = real_origin (article);

            dist = vlen(trap_origin - me.origin);

            if (dist < trap_dist)
            {
               trap = article;
               trap_dist = dist;
            }
        // }
      }

      article = article.chain;

   }

   if (trap)
   {
   /*
      bprint (trap.classname);
      bprint (" at dist: ");
      bprint (ftos(trap_dist));
      bprint ("\n");
      bprint (trap.classname);
      bprint (" ");
      bprint (vtos(trap_origin));
      bprint ("\n");
      bprint ("self = ");
      bprint (vtos(me.origin));
      bprint ("\n");
    */
      spawn_trap (trap_origin, me);

   }
};

void (entity me) avoid_trap =
{

   bprint ("avoid trap\n");
   local entity   trap;
   local entity   article;
   local vector   trap_origin;
   local float dist, trap_dist;
   local vector quake_bug_workaround;


   // this uses a findradius function.  Traceline function will *NOT*
   // find any traps so findradius is the only thing you can do.
   // Unfortunately, it is only useful to finding traps that are within
   // a specified distance.  The bigger the distance, the more CPU
   // it will need.  An alternative is to execute a function ONCE that
   // will spawn all the necessary trap waypoints for the entire map.
   // You will notice that the bot will also use the findradius function
   // to look for trap waypoints.  In short, detecting traps eats up
   // CPU.  

   article = findradius (me.origin, 128);
   trap_dist = 9999;

   while (article)
   {
      if (article.classname == "bubble_trap")
      {

            trap_origin = real_origin (article);

            dist = vlen(trap_origin - me.origin);

            if (dist < trap_dist)
            {
               trap = article;
               trap_dist = dist;
            }
      }

      article = article.chain;

   }

   if (!trap)
   {
      bprint ("no trap found\n");
      return;
   }

   local vector a, b, dir;
   local float dist;
   local vector   dir_angles;
   a = trap_origin; 
   b = me.origin; b_z = a_z;
   

   dir = (a - b);    // from bot to bubble.  Recall final - initial dest
   dir_angles = vectoangles (dir);
   dist = vlen(dir);
   makevectors (dir_angles);
   v_forward_z = 0;
   local vector v1, v2;
   v1 = v_forward * 128;

   // am I heading toward the trap?
   makevectors (self.angles);
   v_forward_z = 0;
   v2 = v_forward * 128;

   local float dir_dist;
   dir_dist = vlen (v1 - v2);

   //        return;

/*
   v1 is the vector from bot to waypoint
   v2 is the vector the bot is facing (which is assumed to be the direction
      it is moving to).

   if these two vectors are very close together, then this means that the
   bot is heading towards that waypoint.  Meaning it is heading towards
   the trap.
*/

   if (dist > 96 || dir_dist > 40)
   {
      bprint ("Not going to hit trap\n"); // dir_dist > 40
      bprint (" or too far from trap\n"); // dist > 96, these are for
                                          // traps on ceilings (eg. E1M5)
      bprint (ftos(dist));
      bprint (ftos(dir_dist));
      bprint ("\n");
      return;
   }


   // deciding which direction to go
   // the fraction that is the greatest is the direction bot should go to

   local vector start, end;
   local float fraction;
   start = me.origin;
   end = start + v_forward * 128 - v_right * 80;
   traceline (start, end, TRUE, self);
   bprint ("left fraction = ");
   fraction = trace_fraction * 128;
   bprint (ftos (fraction));
   bprint ("\n");

   start = me.origin;
   end = start + v_forward * 128 + v_right * 80;
   traceline (start, end, TRUE, self);
   bprint ("right fraction = ");
   fraction = trace_fraction * 128;
   bprint (ftos (fraction));
   bprint ("\n");



   /*
   makevectors (me.angles);
   // v_forward_z = 0;
   local vector start, end;
   start = me.origin;
   end = start + v_forward * 128;

   traceline (start, end, TRUE, me);

   if (trace_ent.classname == "bubble_trap")
   {
      bprint ("Walking to trap 1\n");
   }

   makevectors (me.v_angle);
   // v_forward_z = 0;
   local vector start, end;
   start = me.origin;
   end = start + v_forward * 128;

   traceline (start, end, TRUE, me);

   if (trace_ent.classname == "bubble_trap")
   {
      bprint ("Walking to trap 2\n");
   }
   */

};
