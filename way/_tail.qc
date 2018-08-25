//////////////////////
//do not alter this file
//////////////////////



};

//=============================================================
//=============================================================
void(string mname)SpawnWaypointsForMap = 
{	
	local float found;
	found = SpawnWaypointsForMap1(mname);
	if (!found)
		found = SpawnWaypointsForMap2(mname);
};

