
//
//	Player.qc - Various stuff done for the player, including per-frame functions like PlayerPreThink and PlayerPostThink, also client specific stuff like PutClientInServer etc.
//

void() PlayerJump =
{
	if (!(self.flags & FL_ONGROUND))
		return;

	if ( !(self.flags & FL_JUMPRELEASED) )
		return;
	
	self.weaponframe = 0;
	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
	self.button2 = 0;
};

void() CheckImpulses =
{
	switch (self.impulse)
	{
	default: break;
	}
	self.impulse = 0;
};

vector() get_spawn_point =
{
	entity spawnpoint = world;
	spawnpoint = find(spawnpoint, classname, "info_player_start");

	return spawnpoint.origin + '0 0 1';
};

.vector velocity_stuck_array[4];
.float velocity_stuck_index;
void() PlayerPreThink =
{	
	CheckImpulses();
	makevectors(self.v_angle);

	/*
	if (vlen(to_move_entity) > 0)
	{
		self.origin += to_move_entity * 0.04;
	}
	*/
	if(self.button0)
	{
		
	}
	if(self.button2)
	{
		PlayerJump();
	}
	else
	{
		self.flags = self.flags | FL_JUMPRELEASED;
	}
};

void() PlayerPostThink =
{
};

void() ClientKill =
{
};

//called when a client connects to the server
void() ClientConnect =
{
	// print("Client connect\n");
};

void() PlayerSpawn =
{
	self.classname = "player";
	self.solid = SOLID_NOT;
	setmodel(self, "models/testblob.iqm");
	self.movetype = MOVETYPE_FLY;
	self.health = 100;
	setorigin(self, get_spawn_point());
	self.fixangle = TRUE;
	setsize(self, [-16, -16, 0], [16, 16, 32]);
	self.view_ofs = [0, 0, 24];
};

void() PutClientInServer =
{
	player_chain_add(self);
	PlayerSpawn();
};

void() ClientDisconnect =
{
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " has left the game.\n");
};


void() SetNewParms =
{
};

void() SetChangeParms =
{
};

void() info_player_start =
{
};

void(float elapsedtime) SV_PausedTic =
{
	// if (elapsedtime > 2) setpause(0);
};

void(string command_string) SV_ParseClientCommand =
{
	tokenize(command_string);
	string cmd = argv(0);
	switch (cmd)
	{
	default: break;
	}
	clientcommand(self, command_string);
};

vector(vector to, vector vec) vector_project =
{
	float to_len = vlen(to);
	return ((to * vec)/(to_len * to_len)) * to;
};

vector(vector v, vector n) vector_reflect =
{
	// n = normalize(n);
	return -2 * (v * n) * n + v;
};

void() custom_physics = 
{
	vector start = self.origin;
	vector end = self.origin + self.velocity * input_timelength;
	tracebox(start, self.mins, self.maxs, end, 0, self);
	if (trace_fraction == 1)
		self.velocity -= '0 0 1' * cvar("sv_gravity") * input_timelength;
	tracebox(start, self.mins, self.maxs, end, 0, self);
	setorigin(self, trace_endpos);
	if (trace_fraction < 1)
	{
		self.velocity = vector_reflect(self.velocity, trace_plane_normal);
		self.velocity *= 0.5;
		//printf("trace plane normal: %v, self.velocity %v\n", trace_plane_normal, self.velocity);
		if (trace_plane_normal_z > 0.7 && vlen(self.velocity) < 15*60*input_timelength)
		{
			//print("reset velocity\n");
			self.velocity = '0 0 0';
		}
	}
};

.float jump_hold;
void() SV_RunClientCommand =
{
	input_movevalues = '0 0 0';
	input_buttons -= input_buttons & 2;
	float speed = vlen(self.velocity);
	//printf("speed %v\n", self.velocity);
	if (self.jump_hold)
	{
		printf("jump: %f %f\n", self.jump_hold, time);
		if (!input_buttons)
		{
			makevectors(input_angles + '-3 0 0');
			tracebox(self.origin, self.mins, self.maxs, self.origin + '0 0 8', 0, self);
			setorigin(self, trace_endpos);
			self.velocity += v_forward * (400 + self.jump_hold * 1700);
			self.jump_hold = 0;
		}
	}
	if (input_buttons && speed <= 5)
	{
		self.jump_hold += input_timelength;
		self.jump_hold = min(0.8, self.jump_hold);
		// 
	}
	custom_physics();
};


