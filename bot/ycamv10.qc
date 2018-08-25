//ycamv10c.qc
//Copyright (C) 1998  Harvey Lee
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


//YCam v1.0 Source Code
/*

This code is copyright by the author, Harvey Lee. You use this code 
freely provided that the author is given full credit for the work.

*/

// This file modified from version 1.0 by Wes Morrison

/*
Other Files you need to edit:

PROGS.SRC
items.qc
ycamv10.qc  <-- insert this line
weapons.qc

WEAPONS.QC
In the function ImpulseCommands:
if (self.impulse == 12)
	CycleWeaponReverseCommand();
if (self.impulse == 15)  <-- insert this line (15 may be changed to any
					       appropriate impulse)
	YCam();		 <-- insert this line
if (self.impulse == 255)

CLIENT.QC
In the function PutClientInServer:
W_SetCurrentAmmo ();

if (self.aflag)		  <--
      YCamChasePlayer();  <--

self.attack_finished = time;

In the function PlayerPreThink:
if (self.view_ofs == '0 0 0')
      return;		// intermission or finale
        
if (self.aflag)		  <--
      YCamChasePlayer();  <--              

makevectors (self.v_angle);

In the function PlayerPostThink:
if (self.deadflag)
	return;
if (self.aflag)		  <--
      YCamChasePlayer();  <--
*/

void () YCamChasePlayer;
void () YCam;

void () YCamChasePlayer =
{
	local vector camera_origin;

	makevectors (self.v_angle);

	// Wes Morrison - changed following three commented lines because the camera
	// has a view offset too. Setting it's origin inside the world could still
	// put the viewpoint outside it where you would see "gray" and other parts
	// of the map.

	// Don't do this
	//traceline (self.origin + self.view_ofs, self.origin + 
	//   self.view_ofs * + (v_forward * -32) + (v_up * -8), 
	//   FALSE, self);

	// Do this instead. Add view_ofs twice, we will subtract it from trace_endpos later
	traceline (self.origin + self.view_ofs, self.origin + 
	   (self.view_ofs * 2) + (v_forward * -32) + (v_up * -8),
	   FALSE, self);

	// Now adjust the point found by trace_endpos
	camera_origin_x = trace_endpos_x;
	camera_origin_y = trace_endpos_y;
	camera_origin_z = trace_endpos_z - self.view_ofs_z;
	camera_origin = camera_origin + trace_plane_normal; // Add this to make sure viewpoint stays inside world

	//setorigin (self.trigger_field, trace_endpos);
	setorigin (self.trigger_field, camera_origin);

	// Wes Morrison - why set viewpoint again?
	//WriteByte (MSG_ONE, 5);
	//WriteEntity (MSG_ONE, self.trigger_field);
	//self.weaponmodel = ""; // Wes Morrison - not necessary since we've turned off the viewmodel in YCam()
};

void () YCam =
{
        local entity camera;
        local entity spot;

		msg_entity = self; // Wes Morrison - moved line here from below because both cases use it
        
		if (!self.aflag)
        {
                self.aflag = TRUE;
                camera = spawn();
                spot = spawn();
                self.trigger_field = camera;
                camera.classname = "camera";
                //camera.movetype = MOVETYPE_FLY;
				camera.movetype = MOVETYPE_NONE; // Wes Morrison - we're moving it ourselves
                camera.solid = SOLID_NOT;

//TONY
//eyes are too big
		if(teamplay & TEAM_CAPTURE_CUSTOM )
                 setmodel (camera, "progs/bit.mdl");
		else
               setmodel (camera, "progs/eyes.mdl");

                setsize (camera, '0 0 0', '0 0 0');
                
				// Wes Morrison - commented redundant code
				//makevectors(self.v_angle);
                //traceline (self.origin + self.view_ofs, self.origin + 
			    //self.view_ofs + (v_forward * -32) + 
			    //(v_up * -8), FALSE, self);
                //setorigin (camera, trace_endpos); 
				//setorigin (camera, self.origin;
                //camera.angles = self.angles;
                //self.weaponmodel = "";
                				
				YCamChasePlayer(); // Wes Morrison - call once even though viewpoint not yet set, replaces block above

				// Wes Morrison
				// Misc. stuff to make it look "nice", i.e. turn off stuff that should only happen when looking
				// through the player's "eyes"
				stuffcmd (self, "r_drawviewmodel 0\n");//\ncl_bob 0\ncl_rollangle 0\nv_kickpitch 0\nv_kickroll 0\n");
								
                WriteByte (MSG_ONE, 5);
                WriteEntity (MSG_ONE, camera);
                //WriteByte (MSG_ONE, 10);
                //WriteAngle(MSG_ONE, camera.angles_x);
                //WriteAngle(MSG_ONE, camera.angles_y);
                //WriteAngle(MSG_ONE, camera.angles_z);
		if(!(temp1 & TEMP1_NOMESS))
                sprint (self, "YCam On\n");
        }
        else
        {
				// Wes Morrison
				// Misc. stuff to make it look "nice".
				stuffcmd (self, "r_drawviewmodel 1\n");//\ncl_bob 0.02\ncl_rollangle 2.0\nv_kickpitch 0.6\nv_kickroll 0.6\n");
        
		        self.aflag = FALSE;
                WriteByte (MSG_ONE, 5);
                WriteEntity (MSG_ONE, self);
                //WriteByte (MSG_ONE, 10);
                //WriteAngle(MSG_ONE, self.angles_x);
                //WriteAngle(MSG_ONE, self.angles_y);
                //WriteAngle(MSG_ONE, self.angles_z);
                remove (self.trigger_field);
		if(!(temp1 & TEMP1_NOMESS))
                sprint (self, "YCam Off\n");
                //W_SetCurrentAmmo();
        }
};

