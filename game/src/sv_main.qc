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
	
	clientstat(STAT_POWER, EV_FLOAT, jump_hold);
	clientstat(STAT_CANJUMP, EV_FLOAT, can_jump);
};

void() SpectatorConnect =
{	
};

