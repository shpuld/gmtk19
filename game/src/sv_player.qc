
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

void() PlayerPreThink =
{	
	CheckImpulses();
	makevectors(self.v_angle);
	vector to_move_entity = self.move_entity.origin - self.origin;
	if (vlen(to_move_entity) > 0)
	{
		self.origin += to_move_entity * 0.04;
	}
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
	setmodel(self, "models/testplayer.iqm");
	self.movetype = MOVETYPE_FLY;
	self.health = 100;
	setorigin(self, get_spawn_point());
	self.fixangle = TRUE;
	setsize(self, [-16, -16, 0], [16, 16, 32]);
	self.view_ofs = [0, 0, 24];
	
	self.move_entity = spawn();
	self.move_entity.solid = SOLID_SLIDEBOX;
	self.move_entity.movetype = MOVETYPE_BOUNCE;
	self.move_entity.origin = self.origin + '0 0 64';
	setmodel(self.move_entity, "models/testplayer.iqm");
	setsize(self.move_entity, self.mins, self.maxs);
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

.float jump_hold;
void() SV_RunClientCommand =
{
	input_movevalues = '0 0 0';
	input_buttons -= input_buttons & 2;
	float speed = vlen(self.move_entity.velocity);
	printf("speed %f\n", speed);
	if (self.jump_hold)
	{
		printf("jump: %f\n", self.jump_hold);
		if (!input_buttons)
		{
			makevectors(input_angles + '-5 0 0');
			self.move_entity.velocity += v_forward * (400 + self.jump_hold * 700);
			self.jump_hold = 0;
		}
	}
	if (input_buttons && speed <= 5)
	{
		self.jump_hold += input_timelength;
		// 
	}
	runstandardplayerphysics(self);
};


