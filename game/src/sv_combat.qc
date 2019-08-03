
void(entity pl) player_die =
{
	if (pl.is_dead) return;
	
	pl.is_dead = TRUE;
	msg_entity = pl;
	BeginEvent(EV_DIE);
	multicast('0 0 0', MULTICAST_ONE_R);
	pointparticles(particleeffectnum("weapons.blob_die"), pl.origin, '0 0 1', 5);
	pl.dead_time = time;
	sound(pl, CHAN_AUTO, "sounds/splatbig2.wav", 1, 0, 100);
}