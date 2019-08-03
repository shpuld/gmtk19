
void() CSQC_Ent_Remove =
{
	remove(self);
};

void() CSQC_Shutdown =
{
};

.float last_yaw;
.float framelerp;
.vector aimdir;
.entity trajectorydot;

float is_dead;

void() draw_trajectory =
{
	float power = getstatf(STAT_POWER);
	if (!self.trajectorydot)
	{
		self.trajectorydot = spawn();
		setmodel(self.trajectorydot, "models/trajectory_dot.iqm");
		setsize(self.trajectorydot, '-16 -16 -16', '16 16 16');
		self.trajectorydot.solid = SOLID_NOT;
		self.trajectorydot.movetype = MOVETYPE_NONE;
	}
	//tracebox(self.origin, self.mins, self.maxs, self.origin + '0 0 8', 0, self);
	self.trajectorydot.origin = self.origin; // trace_endpos;
	self.trajectorydot.angles = camang;
	self.trajectorydot.angles_x = max(self.trajectorydot.angles_x - 5, -90);
	makevectors(self.trajectorydot.angles);
	self.trajectorydot.velocity = v_forward * (250 + power * 1800);
	vector oldorg;
	for (int i = 0; i < 40; i++)
	{
		custom_physics(self.trajectorydot, 0.0125);
		self.trajectorydot.angles = vectoangles(self.trajectorydot.velocity);
		self.trajectorydot.alpha = 1 - (i / 40);
		self.trajectorydot.colormod = '0 1 0' * (0.8-power) + '1.2 0.1 0' * power; 
		
		if ((float)i%3 == 0)
		{
			oldorg = self.trajectorydot.origin;
			self.trajectorydot.origin += self.trajectorydot.velocity * (time*0.03 % 0.0125*3);
			addentity(self.trajectorydot);
			self.trajectorydot.origin = oldorg;
		}
	}
};

float(float isnew) player_listen =
{
	if (is_dead) 
	{
		self.modelindex = 0;
		return 1;
	}
	
	if (self.entnum == player_localentnum) localplayer = self;
	float speed = vlen(self.velocity);
	self.frame = 0;
	self.frame1time = 0 + fabs(sin(time * 0.8) * 0.2);
	self.frame2 = 2;
	self.frame2time = min(frameduration(self.modelindex, 2), speed / 2000);
	self.angles_y = self.last_yaw;
	if (speed > 40)
	{
		vector velangles = vectoangles(self.velocity);
		if (velangles_x > 180) velangles_x -= 360;
		float pitch_factor = min(1, speed / 1700);
		// printf("pitch fac %f, velpitch %f\n", pitch_factor, velangles_x);
		self.angles_x = velangles_x * pitch_factor;
		self.angles_y = velangles_y;
		self.last_yaw = self.angles_y;
		self.framelerp += frametime * 10;
		self.framelerp = min(1, self.framelerp);
		self.lerpfrac = self.framelerp;
	}
	else
	{
		self.framelerp -= frametime * 10;
		self.framelerp = max(0, self.framelerp);
		self.lerpfrac = self.framelerp;
		
		float power = getstatf(STAT_POWER);
		if (power > 0.02)
		{
			self.frame1time = power;
			self.angles_y = camang_y;
			draw_trajectory();
			self.origin += [sin(time*40) + cos(time*100), sin(time*90) + cos(time*110), sin(time*105) + cos(time*90)] * max(0, power - 0.65);
		}
	}
	self.forceshader = shaderforname("testblob");
	if (vlen(self.origin - campos) < 80)
	{
		float dist = vlen(self.origin - campos);
		self.alpha = 1 * (dist/80);
		self.forceshader = shaderforname("testblob_alpha");
	}
	makevectors(self.angles);
	vector newdir = v_forward;
	makevectors(self.aimdir);
	vector olddir = self.aimdir;
	self.angles = vectoangles((olddir*7 + newdir) / 8);
	self.angles_x *= -1;
	makevectors(self.angles);
	self.aimdir = v_forward;
	
	traceline(self.origin, self.origin - '0 0 990000', MOVE_NOMONSTERS, self);
	float shadowdist = vlen(self.origin - trace_endpos);
	float shadowval = bound(0, (400 - shadowdist) * 0.001, 0.2);
	adddecal("blobshadow", trace_endpos, '0 0 2', '0.03 0 0', '1 1 1', shadowval);
	return 1;
};

entity arrow_fill;
noref void(float apiver, string enginename, float enginever) CSQC_Init =
{
	// drawfont = loadfont("", "Courier Prime Code", "12,16,24,32,64,72,128,256,512", -1, 0, 0);
	precache_everything();
	arrow_fill = spawn();
	setmodel(arrow_fill, "models/arrow_fill.iqm");
	arrow_fill.solid = SOLID_NOT;
	setsize(arrow_fill, '0 0 0', '0 0 0');
	deltalisten("models/testblob.iqm", player_listen, 0);
};

noref void() CSQC_WorldLoaded =
{
};

noref void(float isnew) CSQC_Ent_Update =
{
	// printf("csqc ent update %f\n", isnew);
};

// CALLED EVERY CLIENT RENDER FRAME
void(float width, float height, float menushown) CSQC_UpdateView =
{
	//clear and update our global screen resolution vars
	clearscene();
	g_width = width;
	g_height = height;
	

	//disable quake status bar and quake crosshair
	setproperty(VF_DRAWENGINESBAR, 0);	
	setproperty(VF_DRAWCROSSHAIR, 0);

	campos = getproperty(VF_ORIGIN);
	camang = getproperty(VF_ANGLES);

	//autoadd entities received from servers for drawing	
	addentities(MASK_ENGINE);
	
	float can_jump = getstatf(STAT_CANJUMP);
	float jump_power = getstatf(STAT_POWER);
	if (can_jump)
	{
		makevectors(camang);
		vector rgt = 16 * v_right;
		vector fwd = 128 * v_forward;
		vector org = localplayer.origin + '0 0 16';
		// float frc = jump_power / 0.8;
		/*
		R_BeginPolygon("arrow_fill2", 0, 0);
		R_PolygonVertex(org - rgt, [0, 1], '1 1 1', frc);
		R_PolygonVertex(org - rgt + fwd * frc, [0, 1 - frc], '1 1 1', frc);
		R_PolygonVertex(org + rgt + fwd * frc, [1, 1 - frc], '1 1 1', frc);
		R_PolygonVertex(org + rgt, [1, 1], '1 1 1', frc);
		R_EndPolygon();
		*/
		
		R_BeginPolygon("arrow_outline", 0, 0);
		R_PolygonVertex(org - rgt, [0, 1], '1 1 1', 1);
		R_PolygonVertex(org - rgt + fwd, [0, 0], '1 1 1', 1);
		R_PolygonVertex(org + rgt + fwd, [1, 0], '1 1 1', 1);
		R_PolygonVertex(org + rgt, [1, 1], '1 1 1', 1);
		R_EndPolygon();
	}
	//does what you think it does
	renderscene();
	
	draw_hud();
	
	/*sui_pre_draw(g_width, g_height);
	
	test_sui_system();
	
	sui_draw();*/
};

float(string cmd) CSQC_ConsoleCommand =
{
	tokenize(cmd);
	switch(argv(0))
	{
		default:
			return FALSE;
	}
	return TRUE;
};

float(float evtype, float scanx, float chary, float devid) CSQC_InputEvent =
{
	// sui_input_event(evtype, scanx, chary, devid);
	switch(evtype)
	{
	case IE_KEYDOWN:
		return FALSE;
	case IE_KEYUP:
		return FALSE;
	case IE_MOUSEDELTA:
		return FALSE;
	case IE_MOUSEABS:
		cursor_pos_x = scanx;
		cursor_pos_y = chary;
		return FALSE;
	}
	return FALSE;
};


void() CSQC_Parse_Event =
{
	float first = readbyte();
	switch(first) {
		case EV_DIE:
			is_dead = TRUE;
			break;
		case EV_REVIVE:
			is_dead = FALSE;
			break;
		case EV_GOAL:
			if (getstatf(STAT_DIAMONDS) < getstatf(STAT_DIAMONDS_TOTAL))
			{
				
			}
			break;
		default:
			printf("No action for byte %f\n", first);
			break;
	}
};


float(string key, string val) find_player_id =
{
	for (int currentindex = 0; currentindex < maxclients; currentindex++)
	{
		if (getplayerkeyvalue(currentindex, key) == val) return currentindex;
	}
	return -1;
}

void(string printmsg, float printlvl) CSQC_Parse_Print =
{
	print(printmsg);
};
