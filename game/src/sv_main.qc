//
//	Main.qc - mostly functions that will be called from the engine and are expected to exist
//

void() main =
{
};

//called for each frame that QC runs
void() StartFrame =
{
};

void() worldspawn =
{	
	precache_everything();
	
	par_g = world.par;
	
	clientstat(STAT_POWER, EV_FLOAT, jump_hold);
	clientstat(STAT_CANJUMP, EV_FLOAT, can_jump);
	clientstat(STAT_ROCKET_JUMPS, EV_FLOAT, rocket_jumps);
	clientstat(STAT_STICKY_JUMPS, EV_FLOAT, sticky_jumps);
	globalstat(STAT_DIAMONDS, EV_FLOAT, "diamonds");
	globalstat(STAT_DIAMONDS_TOTAL, EV_FLOAT, "diamonds_total");
	globalstat(STAT_STROKES, EV_FLOAT, "strokes");
	globalstat(STAT_PAR, EV_FLOAT, "par_g");
};

void() SpectatorConnect =
{	
};

