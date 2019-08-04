
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

void() respawn_to_last_safe =
{
	if (self.active_jump == 0) return;
	
	self.origin = self.last_safe;
	self.angles = self.last_safe_angles;
	self.v_angle = self.last_safe_angles;
	self.sticky_jumps = self.last_safe_sticky_jumps;
	self.rocket_jumps = self.last_safe_rocket_jumps;
	self.fixangle = TRUE;
	self.velocity = '0 0 0';
	self.sticking_to = self.last_safe_sticking_to;
	
	msg_entity = self;
	BeginEvent(EV_REVIVE);
	multicast('0 0 0', MULTICAST_ONE_R);
	self.is_dead = FALSE;
	
	entity undoent = findfloat(world, active_jump, self.active_jump);
	while (undoent)
	{
		switch (undoent.classname)
		{
			case "item_health":
				undo_diamond(undoent);
				break;
			case "func_bricks":
				undo_bricks(undoent);
				break;
			case "item_haste":
				undo_glue(undoent);
				break;
			case "item_flight":
				undo_glue(undoent); //rocket can reuse same code
				break;
			default: break;
		}
		undoent = findfloat(undoent, active_jump, self.active_jump);
	}
	
	self.active_jump -= 1;
};

void() CheckImpulses =
{
	switch (self.impulse)
	{
	case 100:
		respawn_to_last_safe();
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

	if (self.is_dead && time - self.dead_time > 1) respawn_to_last_safe();
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
void(optional float csqcactive) ClientConnect =
{
	// print("Client connect\n");
};

void() PlayerSpawn =
{
	self.classname = "player";
	self.solid = SOLID_SLIDEBOX;
	setmodel(self, "models/testblob.iqm");
	self.real_modelindex = self.modelindex;
	self.movetype = MOVETYPE_FLY;
	self.health = 100;
	setorigin(self, get_spawn_point() + '0 0 16');
	self.fixangle = TRUE;
	setsize(self, [-16, -16, -16], [16, 16, 16]);
	self.view_ofs = [0, 0, 24];
	strokes = 0;
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

void(float speed, entity blob) handlebounce =
{
	float vol = min(1, ((speed - 200) * 0.001));
	sound(world, CHAN_AUTO, "sounds/splatbig1.wav", vol, 0, 100);
	
	// printf("hit: %x, sky? %i\n", trace_surfaceflagsi, trace_surfaceflagsi & 4); //q3surf sky?
	if (trace_surfaceflagsi & Q3SURF_SKY) player_die(blob);
	
	if (speed > 350)
		pointparticles(particleeffectnum("weapons.blob_bounce"), blob.origin, '0 0 1', 1);
		
	if (self.sticky_jumps > 0 && self.jump_flags & JF_STICKY)
	{
		self.sticking_to = blob.origin;
		self.velocity = '0 0 0';
		self.sticky_jumps -= 1;
		self.jump_flags -= self.jump_flags & JF_STICKY;
	}	
	if (self.rocket_jumps > 0 && self.jump_flags & JF_ROCKET)
	{
		// massive dampening to make rocket jumps more controllable
		self.velocity *= 0.5;
		self.rocket_jumps -= 1;
		self.jump_flags -= self.jump_flags & JF_ROCKET;
	}
};

void() SV_RunClientCommand =
{
	input_movevalues = '0 0 0';
	input_buttons -= input_buttons & 2;
	if (world.model == "maps/menu.bsp")
	{
		input_angles = [sin(time * 0.3) * 10, anglemod(time*5 + 120), 0];
		self.angles = input_angles;
		self.v_angle = input_angles;
		self.fixangle = TRUE;
		input_buttons = 0;
	}
	float speed = vlen(self.velocity);
	//printf("speed %v\n", self.velocity);
	if (self.is_dead) return;
	if (self.jump_hold)
	{
		// printf("jump: %f %f\n", self.jump_hold, time);
		if (!input_buttons)
		{
			strokes++;
			self.active_jump += 1;
			self.last_safe = self.origin;
			self.last_safe_angles = input_angles;
			self.last_safe_sticky_jumps = self.sticky_jumps;
			self.last_safe_rocket_jumps = self.rocket_jumps;
			self.last_safe_sticking_to = self.sticking_to;
			
			self.sticking_to = '0 0 0'; // disconnect glue for jump
			
			input_angles_x = max(input_angles_x - 5, -90);
			makevectors(input_angles);
			// tracebox(self.origin, self.mins, self.maxs, self.origin + '0 0 8', 0, self);
			// setorigin(self, trace_endpos);	
			self.velocity = v_forward * (250 + self.jump_hold * 1800);
			sound(self, CHAN_AUTO, "sounds/blobjump.wav", 0.5 + (self.jump_hold * 0.5), 0, 110 - (self.jump_hold * 25));
			self.jump_hold = 0;
			
			self.jump_flags = 0;
			if (self.rocket_jumps > 0) self.jump_flags |= JF_ROCKET;
			if (self.sticky_jumps > 0) self.jump_flags |= JF_STICKY;
		}
	}
	if (input_buttons && self.can_jump)
	{
		self.jump_hold += input_timelength * 0.8;
		if (self.rocket_jumps > 0)
			self.jump_hold = min(2.0, self.jump_hold);
		else
			self.jump_hold = min(0.8, self.jump_hold);	
	}
	if (speed < 30*60*input_timelength)
	{
		
		self.can_jump_time += input_timelength;
		if (self.can_jump_time > 0.25)
		{
			self.can_jump = TRUE;
			
		}
	}
	else
	{
		self.can_jump_time = 0;
		self.can_jump = FALSE;
	}
	custom_physics(self, input_timelength);
};


