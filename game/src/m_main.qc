
float menu_active;

float splash_time;


entity great_thinker;

void() m_init =
{
	great_thinker = spawn();
	if (cvar_string("mapname") == "")
		localcmd("map menu\n");
	splash_time = time + 4.0;
	registercommand("togglemenu2");
	registercommand("nextlevel");
	registercommand("showtutorial");
	// drawfont = loadfont("", "Courier Prime Code", "12,16,24,32,48,64,72,128,256,512", -1, 0, 0);
	setcursormode(TRUE,"gfx/xhair", [16, 16], cvar("vid_conautoscale"));
	current_menu = MENU_MAIN;
};

vector() randomofs = { return [random() - 0.5, random() - 0.5] * 1.2; };

void(vector screensize) m_draw =
{
//	clearscene();

	
	vector realsize = getproperty(VF_SCREENPSIZE);
	float target_conauto = 2;
	if (realsize_y < 600) target_conauto = 1;
	else if (realsize_y < 1200) target_conauto = 2;
	else target_conauto = 4;
	
	if (target_conauto != cvar("vid_conautoscale")) localcmd(sprintf("vid_conautoscale %f\n", target_conauto));
	
	
	sui_begin(screensize_x, screensize_y);
	if (menu_active)
		root_menu(screensize);
		
		
	if (time < splash_time)
	{
		sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_CENTER]);
		float diff = splash_time - time;
		float a;
		if (diff > 2.5)
		{
			a = 1 - (diff - 2.5) * 2;
			float xstretch = (diff - 2.5) * 4;
			sui_fill([0, 0], screensize, '0 0 0', 1, 0);
			sui_pic(randomofs() * 1, [screensize_y * (0.7 + xstretch), screensize_y * 0.7], "gfx/splash.tga", '1 1 1', a * 0.75, 1);
			sui_pic(randomofs() * 1, [screensize_y * (0.7 + xstretch), screensize_y * 0.7], "gfx/splash.tga", '1 1 1', a * 0.75, 1);
		}
		else 
		{
			a = diff * 0.6;
			sui_fill([0, 0], screensize, '0 0 0', a * 2, 0);
			sui_pic(randomofs() * a, [screensize_y * 0.7, screensize_y * 0.7], "gfx/splash.tga", '1 1 1', a, 1);
			sui_pic(randomofs() * a, [screensize_y * (0.7 + random() * 0.05), screensize_y * 0.7], "gfx/splash.tga", '1 1 1', a * 0.5, 1);
		}
	}
	
	sui_end();
};

void() m_close =
{
	if (current_menu == MENU_NEXTLEVEL) return;
	if (current_menu == MENU_TUTORIAL) current_menu = MENU_MAIN;
	
	setkeydest(0);
	menu_active = FALSE;
};

void() m_open =
{
	setkeydest(2);
	menu_active = TRUE;
};

float(float evtype, float scanx, float chary, float devid) Menu_InputEvent =
{
	float used = sui_input_event(evtype, scanx, chary, devid);
	
	if (evtype == IE_KEYDOWN && !used)
	{
		string cmd = getkeybind(scanx);
		switch (cmd)
		{
		case "togglemenu":
			m_close();
			return TRUE;
			break;
		default: break;
		}
	}
	return FALSE;
};

void() great_think =
{
	current_menu = MENU_TUTORIAL;
	m_open();
};

void(float currentstrokes, float currentpar) prompt_next_level;
float(string cmd) m_consolecommand =
{
	tokenize(cmd);
	switch (argv(0))
	{
	case "nextlevel":
		prompt_next_level(stof(argv(1)), stof(argv(2)));
		m_open();
		return TRUE;
		break;
	case "showtutorial":
		if (current_tutorial == cvar_string("mapname")) return TRUE;
		current_menu = MENU_TUTORIAL;
		current_tutorial = cvar_string("mapname");
		m_open();
		return TRUE;
		break;
	default: break;
	}

	return FALSE;
};

void(float wantmode) m_toggle =
{
	if (menu_active) m_close();
	else m_open();
};

void() m_shutdown =
{
};