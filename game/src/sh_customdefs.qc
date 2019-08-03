//shared definitions

#define printf(x, ...) print(sprintf(x, __VA_ARGS__))

const float STAT_POWER = 51;
const float STAT_CANJUMP = 52;
const float STAT_DIAMONDS_TOTAL = 53;
const float STAT_DIAMONDS = 54;

const float EV_DIE = 10;
const float EV_REVIVE = 11;
const float EV_GOAL = 12;

void() precache_everything =
{
	precache_sound("demon/dland2.wav");
	precache_model("models/testblob.iqm");
	precache_model("models/arrow_fill.iqm");
	precache_model("models/trajectory_dot.iqm");
	precache_model("models/diamond.iqm");
	particleeffectnum("weapons.blob_die");
	particleeffectnum("weapons.bricks");
	particleeffectnum("weapons.diamond_pickup");
	
	precache_sound("sounds/splatbig1.wav");
	precache_sound("sounds/splatbig2.wav");
	precache_sound("sounds/blobjump.wav");
};


vector(vector to, vector vec) vector_project =
{
	float to_len = vlen(to);
	return ((to * vec)/(to_len * to_len)) * to;
};

vector(vector v, vector n) vector_bounce =
{
	// n = normalize(n);
	return v - (v * n) * n * 1.5;
};

void(float speed) handlebounce;
void(entity pl, float length) custom_physics = 
{
	vector start = pl.origin;
	vector end = pl.origin + pl.velocity * length;
	tracebox(start, pl.mins, pl.maxs, end, MOVE_TRIGGERS, pl);
	if (trace_ent && trace_ent.touch)
	{
		entity oself;
		oself = self;
		self = trace_ent;
		other = pl;
		self.touch();
		self = oself;
	}
	tracebox(start, pl.mins, pl.maxs, end, 0, pl);
	if (trace_fraction == 1)
		pl.velocity -= '0 0 1' * cvar("sv_gravity") * length;
	// tracebox(start, pl.mins, pl.maxs, end, 0, pl);
	setorigin(pl, trace_endpos);
	if (trace_fraction < 1)
	{
		if (vlen(pl.velocity) > 300)
		{
			handlebounce(vlen(pl.velocity));
		}
		pl.velocity = vector_bounce(pl.velocity, trace_plane_normal);
		pl.velocity *= 0.8;
		if (trace_plane_normal_z > 0.6 && vlen(pl.velocity) < 30*60*length)
		{
			pl.velocity = '0 0 0';
		}
	}
};
