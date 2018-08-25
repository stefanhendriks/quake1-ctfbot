// Identify the player you are pointed towards
// By Suck (Nat Friedman)
// This code falls under the GNU public license, and cannot be 
// redistributed without my name attached.

// hacked by Zoid for CTF4

// This is called with the player who wants to know whose in front
// of him as "self."  I call it with an impulse in weapons.qc 
entity(float disp) identify_player =
{
	// e is a temp entity; guy is our current best guess
	// as to at whom the player is pointing
	local entity e, guy;

	// The best "closeness" heuristic so far.
	local float closeness = -1;

	// Temp vars.
	local vector diff, point;
	local float currclose;
	local string s1, s2, s3;

	// Walk the list of players...
	e=find(world, classname, "player");
	while (e!=world)
	{
		// Get a vector pointing from the viewer to the current
		// player under consideration
		diff=e.origin - self.origin;

		// Normalize it since we only care where he's pointing,
		// not how far away the guy is.
		diff=normalize(diff);

		// Normalize self.angles so we can do a length-independent
		// consideration
		point=normalize(self.angles);

		// Find the different between the current player's angle
		// and the viewer's vision angle
		diff=diff - point;

		// The length is going to be our definition of closeness
		currclose=vlen(diff);
		traceline(self.origin, e.origin, FALSE, self);
		if (trace_ent == e) {
			if (closeness == -1) {
				closeness = currclose;
				guy = e;
			} else if (currclose < closeness) {
				closeness = currclose;
				guy = e;
			}
		}
		e=FindNextPlayerOrBot(e);		// CTFBOT find bots also
	}

	// Now we display.
	if (disp==0)
		return guy;
	if (guy == world)
	{
		TeamPlayerUpdate(self, "You're not looking at anyone!");
		return world;
	}
//TONY
//	TeamPlayerUpdate2(self, "You are looking at ", guy.netname);
	TeamPlayerUpdate(self, guy.netname);
	return guy;
};	 

