
void() CSQC_Ent_Remove =
{
	remove(self);
};

void() CSQC_Shutdown =
{
};

.float last_yaw;
float(float isnew) player_listen =
{
	if (self.entnum == player_localentnum) localplayer = self;
	float speed = vlen(self.velocity);
	self.frame1time = 0;
	self.angles_y = self.last_yaw;
	if (speed > 40)
	{
		vector velangles = vectoangles(self.velocity);
		if (velangles_x > 180) velangles_x -= 360;
		float pitch_factor = min(1, speed / 1600);
		printf("pitch fac %f, velpitch %f\n", pitch_factor, velangles_x);
		self.angles_x = velangles_x * pitch_factor;
		self.angles_y = velangles_y;
		self.last_yaw = self.angles_y;
		self.frame2 = 2;
		self.frame2time = min(frameduration(self.modelindex, 2), speed / 2000);
		self.lerpfrac = 1;
	}
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
		/*
		setorigin(arrow_fill, localplayer.origin);
		arrow_fill.angles = camang;
		arrow_fill.angles_x *= -1;
		arrow_fill.alpha = 0.01 + jump_power;
		addentity(arrow_fill);
		*/
		makevectors(camang);
		vector rgt = 16 * v_right;
		vector fwd = 128 * v_forward;
		vector org = localplayer.origin + '0 0 16';
		float frc = jump_power / 0.8;
		
		R_BeginPolygon("arrow_fill2", 0, 0);
		R_PolygonVertex(org - rgt, [0, 1], '1 1 1', frc);
		R_PolygonVertex(org - rgt + fwd * frc, [0, 1 - frc], '1 1 1', frc);
		R_PolygonVertex(org + rgt + fwd * frc, [1, 1 - frc], '1 1 1', frc);
		R_PolygonVertex(org + rgt, [1, 1], '1 1 1', frc);
		R_EndPolygon();
		
		
		R_BeginPolygon("arrow_outline", 0, 0);
		R_PolygonVertex(org - rgt, [0, 1], '1 1 1', 1);
		R_PolygonVertex(org - rgt + fwd, [0, 0], '1 1 1', 1);
		R_PolygonVertex(org + rgt + fwd, [1, 0], '1 1 1', 1);
		R_PolygonVertex(org + rgt, [1, 1], '1 1 1', 1);
		R_EndPolygon();
	}
	//does what you think it does
	renderscene();
	
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
