/*
**
** _telefrg.qc (Telefrag Code, 1.1)
**
** Copyright (C) 1996 Johannes Plass
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
**
** Author:   Johannes Plass (plass@dipmza.physik.uni-mainz.de)
**
** --
** Sniped by Zoid for ThreeWave Mods, GPL respected
**
*/

entity() SelectSpawnPoint;

entity(entity spot) TelefragSelectSpawnPoint =
{
	local entity e, firstspot;
	local float search_spot;
	
	search_spot = 25;
	firstspot = spot;

	while (search_spot) {
		e = findradius(spot.origin, 50);
		if (!e)
			search_spot = 0;
		else {
			local float occupied;
			occupied = 0;
			while (!occupied && !(!e)) {
				if ((e.classname == "player"  	// CTFBOT
					|| e.classname == "bot") 	// CTFBOT
					 && e.deadflag == DEAD_NO)
						occupied = 1;
				else
					e = e.chain;
			}
			if (occupied) 
			{	
				spot = SelectSpawnPoint();
				search_spot = search_spot - 1;
				if (spot == firstspot)
						search_spot = 0;
			} else
				search_spot = 0;
		}
	}
	return (spot);
};
