vector MENU_BG = '0.2 0.5 0.6';
vector MENU_BG_DARK = '0.1 0.25 0.3';
vector MENU_BORDER = '0.3 0.5 0.6';
vector MENU_BUTTON = '0.3 0.6 0.7';
vector MENU_BUTTON_BORDER = '0.35 0.55 0.65';
vector MENU_TEXT_1 = '1 1 1';
vector MENU_TEXT_2 = '0.7 0.75 0.75';
vector MENU_HIGHLIGHT = '1 1 1';
vector MENU_DARKEN = '1 1 1';

vector MENU_TEXT_SMALL = '8 8 0';
vector MENU_TEXT_MEDIUM = '16 16 0';
vector MENU_TEXT_LARGE = '24 24 0';

void() input_tester =
{
	float char = 0;
	float scan = 0;
	string printme = "";
	while (sui_get_input(char, scan))
	{
		printme = strcat(printme, chr2str(char));
	}
	if (printme != "") printf("INPUT: %s\n", printme); 
};

void(string id, vector pos, vector size, float maxlen, __inout string text, __inout float cursor) text_input_control =
{
	vector textsize = [size_y - 4, size_y - 4];
	sui_push_frame(pos, size);
	vector basecolor = sui_is_hovered(id) ? MENU_BG_DARK + MENU_HIGHLIGHT * 0.08 : MENU_BG_DARK; 
	sui_fill([0, 0], size, basecolor, 0.6, 0);
	
	sui_text_input(id, [0, 0], size, text, cursor);
	
	sui_set_align([SUI_ALIGN_START, SUI_ALIGN_CENTER]);
	float focused = sui_is_last_clicked(id);
	// Under focus
	focused ? sui_border_box([0, 0], size, 1, MENU_BORDER, 0.6, 0) : 0;	
	
	sui_push_frame([2, 0], [size_x - 4, size_y - 4]);
	
	float cursorx;
	if (stringwidth(text, 1, textsize) > size_x - 4)
	{
		sui_clip_to_frame();
		cursorx = 0;
		sui_set_align([SUI_ALIGN_END, SUI_ALIGN_CENTER]);
		sui_text([0, 0], textsize, text, MENU_TEXT_1, 1, 0);
	}
	else
	{
		cursorx = stringwidth(substring(text, 0, cursor), 1, textsize);
		sui_text([0, 0], textsize, text, MENU_TEXT_1, 1, 0);
	}
	if (focused) 
	{
		sui_fill([cursorx, 0], [2, textsize_y], MENU_TEXT_1, fabs(sin(time * 4)), 0);
	}
	sui_reset_clip();
	sui_pop_frame();
	
	sui_pop_frame();
};

float(string id, vector pos, vector size, string text) my_button =
{
	sui_push_frame(pos, size);
	vector basecolor = sui_is_hovered(id) ? MENU_BUTTON + MENU_HIGHLIGHT * 0.1 : MENU_BUTTON; 
	basecolor = sui_is_held(id) ? MENU_BUTTON - MENU_DARKEN * 0.1 : basecolor;
	sui_fill([0, 0], size, basecolor, 0.6, 0);
	sui_border_box([0, 0], size, 1, MENU_BUTTON_BORDER, 0.4, 0);
	
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_CENTER]);
	sui_text([0, 0], MENU_TEXT_SMALL, text, MENU_TEXT_1, 1, 0);	
	sui_action_element([0, 0], size, id, sui_noop);
	sui_pop_frame();
	
	return sui_is_clicked(id);
};


void(string id, vector pos, vector size, vector minmaxsteps, __inout float value) my_slider =
{
	sui_push_frame(pos, size);
	
	value = sui_slidercontrol(id, [0, 0], size, minmaxsteps, value, sui_slider_noop);
	float maxval = minmaxsteps[1];
	float sliderx = (value / maxval) * size_x;
	sui_fill([0, size_y * 0.25], [size_x, size_y * 0.5], MENU_BG_DARK, 1.0, 0);
	
	float is_active = sui_is_held(id) || (sui_is_hovered(id) && !sui_click_held());
	vector slider_ctrl_color = is_active ? MENU_BUTTON + MENU_HIGHLIGHT * 0.1 : MENU_BUTTON;
	sui_fill([sliderx - 2, 0], [4, size_y], slider_ctrl_color, 1.0, 0);
	
	sui_pop_frame();
};

void(vector pos, vector size, vector minmaxsteps, string cvar_s, string name, string format) cvar_slider =
{
	float current = cvar(cvar_s);
	float old = current;
	sui_push_frame(pos, [size_x, size_y * 0.5 - 4]);
	sui_text([0, 0], MENU_TEXT_SMALL, name, MENU_TEXT_1, 1, 0);
	sui_set_align([SUI_ALIGN_END, SUI_ALIGN_START]);
	sui_text([0, 0], MENU_TEXT_SMALL, sprintf(format, current), MENU_TEXT_1, 1, 0);
	sui_pop_frame();
	my_slider(strcat(cvar_s, "sldr"), [pos_x, pos_y + size_y * 0.5], [size_x, size_y * 0.5], minmaxsteps, current);
	if (current != old) cvar_set(cvar_s, ftos(current));
};

struct name_command {
	string name;
	string command;
};

name_command bindlist[] = 
{
	{ "Shoot", "+attack" },
	{ "Undo Stroke", "impulse 100" },
	{ "Restart", "restart" }
};

void(string id, vector pos, vector size, string name, string command) bind_button =
{
	sui_push_frame(pos, size);
	sui_set_align([SUI_ALIGN_START, SUI_ALIGN_CENTER]);
	string key = sui_binder(id, [0, 0], size, name, command);
	if (sui_is_hovered(id)) sui_fill([0, 0], size, MENU_HIGHLIGHT, 0.1, 0);
	sui_text([6, 0], MENU_TEXT_SMALL, name, MENU_TEXT_1, 1, 0);
	sui_set_align([SUI_ALIGN_END, SUI_ALIGN_CENTER]);
	sui_text([-6, 0], MENU_TEXT_SMALL, key, MENU_TEXT_1, 1, 0);
	
	sui_pop_frame();
};


void(string id, vector pos, vector size, __inout vector scrollofs) bind_list =
{
	sui_fill(pos, size, MENU_BG_DARK, 0.75, 0);
	sui_list_view_begin(strcat(id, "scrl"), pos, size, [size_x - 6, 24], bindlist.length, scrollofs, [0, 6]);
	vector listitem_pos = '0 0 0';
	for (float index = sui_list_item(listitem_pos); index > -1; index = sui_list_item(listitem_pos))
	{
		sui_push_frame(listitem_pos, [size_x - 6, 24]);
		bind_button(strcat(id, ftos(index)), [0, 0], [size_x - 6, 24], bindlist[index].name, bindlist[index].command);
		sui_pop_frame();
	}
	sui_list_view_end();	
};


float current_menu;
string current_tutorial;
const float MENU_MAIN = 1;
const float MENU_SETTINGS = 2;
const float MENU_HELP = 3;
const float MENU_NEWGAME = 4;
const float MENU_NEXTLEVEL = 5;
const float MENU_TUTORIAL = 6;


vector binds_scroll;
void() settings_menu =
{
	vector pos = [0, 0];
	vector size = [360, 280];
	
	sui_push_frame(pos, size);

	sui_fill([0, 0], size, MENU_BG, 0.75, 0);
	sui_border_box([0, 0], size, 2, MENU_BORDER, 0.3, 0);
	
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);
	sui_text([0, 4], MENU_TEXT_MEDIUM, "Settings", MENU_TEXT_1, 1, 0);

	
	sui_set_align([SUI_ALIGN_START, SUI_ALIGN_START]);
	
	float xpos = 8;
	float ypos = 32;
	float width = size_x * 0.5 - 8 * 2;
	sui_text([xpos, ypos], MENU_TEXT_SMALL, "Controls", MENU_TEXT_1, 1, 0);
	ypos += 16;
	bind_list("bindlist", [xpos, ypos], [width, 160], binds_scroll);
	ypos += 160 + 8;

	cvar_slider([xpos, ypos], [width, 32], [0.1, 10], "sensitivity", "Sensitivity", "%.2f");
	ypos += 32;

	ypos = 32;
	xpos = 8 + width + 8 + 8;
	
	cvar_slider([xpos, ypos], [width, 32], [0, 1], "volume", "Volume", "%.2f");
	ypos += 32 + 4;
	cvar_slider([xpos, ypos], [width, 32], [0, 1], "musicvolume", "Music Volume", "%.2f");
	ypos += 32 + 4 + 8;
	
	sui_text([xpos, ypos], MENU_TEXT_SMALL, "Video", MENU_TEXT_1, 1, 0);
	ypos += 16;
	my_button("fs_btn", [xpos, ypos], [width, 20], "Fullscreen") ? localcmd("vid_fullscreen 2; vid_restart\n") : 0;
	ypos += 24;
	my_button("wn_btn", [xpos, ypos], [width, 20], "Windowed") ? localcmd("vid_fullscreen 0; vid_width 1024; vid_height 768; vid_restart\n") : 0;
	ypos += 24;
	sui_text([xpos, ypos], MENU_TEXT_SMALL, "Window can be resized.", MENU_TEXT_1, 0.8, 0);
	ypos += 16;
	sui_set_align([SUI_ALIGN_END, SUI_ALIGN_END]);
	my_button("stg_back", [-8, -8], [80, 20], "Back") ? current_menu = MENU_MAIN : 0;
	
	sui_pop_frame();
};

void() help_menu =
{
	vector pos = [0, 0];
	vector size = [360, 280];
	
	sui_push_frame(pos, size);

	sui_fill([0, 0], size, MENU_BG, 0.75, 0);
	sui_border_box([0, 0], size, 2, MENU_BORDER, 0.3, 0);
	
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);
	sui_text([0, 4], MENU_TEXT_MEDIUM, "Help", MENU_TEXT_1, 1, 0);
	
	float xpos = 0;
	float ypos = 32;
	sui_text([xpos, ypos], MENU_TEXT_SMALL, "Bunch of Help and About", MENU_TEXT_1, 1, 0);
	
	sui_set_align([SUI_ALIGN_END, SUI_ALIGN_END]);
	my_button("hlp_back", [-8, -8], [80, 20], "Back") ? current_menu = MENU_MAIN : 0;

	sui_pop_frame();	
};

void(string map) start_stage =
{
	if (cvar_string("mapname") == "menu") localcmd("music 2\n");
	current_menu = MENU_MAIN;
	localcmd(sprintf("map %s\n", map));
};

void(string id, vector pos, vector size, string name, string map) select_map_button =
{
	sui_push_frame(pos, size);
	sui_set_align([SUI_ALIGN_START, SUI_ALIGN_CENTER]);
	sui_action_element(pos, size, id, sui_noop);
	if (sui_is_hovered(id)) sui_fill([0, 0], size, MENU_HIGHLIGHT, 0.1, 0);
	sui_text([6, 0], MENU_TEXT_SMALL, name, MENU_TEXT_1, 1, 0);
	sui_set_align([SUI_ALIGN_END, SUI_ALIGN_CENTER]);
	
	if (sui_is_clicked(id)) start_stage(map);
	
	sui_pop_frame();
};

vector maplist_scroll;
void() new_game_menu =
{
	vector pos = [0, 0];
	vector size = [216, 280];
	
	sui_push_frame(pos, size);
	
	sui_fill([0, 0], size, MENU_BG, 0.75, 0);
	sui_border_box([0, 0], size, 2, MENU_BORDER, 0.3, 0);
	
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);
	sui_text([0, 4], MENU_TEXT_MEDIUM, "New Game", MENU_TEXT_1, 1, 0);
	
	float xpos = 0;
	float ypos = 16;
	
	pos = [xpos, ypos];
	size = [200, 208];
	sui_push_frame(pos, size);
	
	sui_fill(pos, size, MENU_BG_DARK, 0.75, 0);
	sui_list_view_begin(strcat("mplst"), pos, size, [size_x - 6, 24], map_list.length, maplist_scroll, [0, 6]);
	vector listitem_pos = '0 0 0';
	for (float index = sui_list_item(listitem_pos); index > -1; index = sui_list_item(listitem_pos))
	{
		sui_push_frame(listitem_pos, [size_x - 6, 24]);
		select_map_button(strcat("mplst", ftos(index)), [0, 0], [size_x - 6, 24], map_list[index].name, map_list[index].map);
		sui_pop_frame();
	}
	sui_list_view_end();	
	
	sui_pop_frame();
	
	sui_set_align([SUI_ALIGN_END, SUI_ALIGN_END]);
	my_button("ng_back", [-8, -8], [80, 20], "Back") ? current_menu = MENU_MAIN : 0;
	
	sui_pop_frame();
};

float strokes;
float par;
void(float currentstrokes, float currentpar) prompt_next_level =
{
	current_menu = MENU_NEXTLEVEL;
	strokes = currentstrokes;
	par = currentpar;
};

struct tutorial {
	string map;
	string title;
	string line1;
	string line2;
	string line3;
	string line4;
	string line5;
	string line6;
};

tutorial tutorials[] = {
	{ "start", "Welcome!", "Use MOUSE1 to shoot the goo,", "hold it to shoot it further.", "Collect diamonds and avoid", "falling off the level.", "Get to the GOAL after", "collecting all of them." },
	{ "goo02", "Hotkeys", "You can use Z to undo your last", "move (strokes will still remain).", "You can use R to restart", "the stage and the strokes.", "You can reach better ranks", "with less strokes in total." },
	{ "sticky_tut", "Glue Powerup", "There's the Glue Powerup!", "", "With the Glue Powerup,", "you will stick to walls.", "Glue is useful for", "avoiding falling off." },
	{ "rocket_tut", "Rocket Powerup", "That's the Rocket Powerup!", "", "Rocket lets you charge much", "more than normally.", "With it, it's possible to", "reach far away places!" },
	{ "goo08", "Brick Walls", "You can ram into brick walls", "to break them!", "Remember that a reset will", "bring them back.", "You'll have to land safely", "to clear the wall." }
};

void() m_close;
void() tutorial_menu =
{
	string currentmap = current_tutorial;
	int i;
	for (i = 0; i < tutorials.length; i++)
	{
		if (tutorials[i].map == currentmap) break;
	}
	if (i >= tutorials.length)
	{
		current_menu = MENU_MAIN;
		m_close();
		return;
	}
	
	vector pos = [0, 0];
	vector size = [280, 160];
	
	sui_push_frame(pos, size);

	sui_fill([0, 0], size, MENU_BG, 0.75, 0);
	sui_border_box([0, 0], size, 2, MENU_BORDER, 0.3, 0);
	
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);
	sui_text([0, 4], MENU_TEXT_MEDIUM, tutorials[i].title, MENU_TEXT_1, 1, 0);
	
	float xpos = 0;
	float ypos = 32;
	sui_text([xpos, ypos], MENU_TEXT_SMALL, tutorials[i].line1, MENU_TEXT_1, 1, 0);
	ypos += 8;
	sui_text([xpos, ypos], MENU_TEXT_SMALL, tutorials[i].line2, MENU_TEXT_1, 1, 0);
	ypos += 16;
	sui_text([xpos, ypos], MENU_TEXT_SMALL, tutorials[i].line3, MENU_TEXT_1, 1, 0);
	ypos += 8;
	sui_text([xpos, ypos], MENU_TEXT_SMALL, tutorials[i].line4, MENU_TEXT_1, 1, 0);
	ypos += 16;
	sui_text([xpos, ypos], MENU_TEXT_SMALL, tutorials[i].line5, MENU_TEXT_1, 1, 0);
	ypos += 8;
	sui_text([xpos, ypos], MENU_TEXT_SMALL, tutorials[i].line6, MENU_TEXT_1, 1, 0);
	
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_END]);
	if (my_button("tut_close", [0, -8], [80, 20], "OK"))
	{
		current_menu = MENU_MAIN;
		m_close();
	}

	sui_pop_frame();	
};

void() next_level_menu =
{
	vector pos = [0, 0];
	vector size = [280, 180];
	
	sui_push_frame(pos, size);

	sui_fill([0, 0], size, MENU_BG, 0.75, 0);
	sui_border_box([0, 0], size, 2, MENU_BORDER, 0.3, 0);
	
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);
	sui_text([0, 4], MENU_TEXT_MEDIUM, "Well Done!", MENU_TEXT_1, 1, 0);
	
	float xpos = 0;
	float ypos = 32;
	string currentmap = cvar_string("mapname");
	sui_text([xpos, ypos], MENU_TEXT_SMALL, sprintf("You cleared '%s'!", get_map_name(currentmap)), MENU_TEXT_1, 1, 0);
	ypos += 32;
	sui_text([xpos, ypos], MENU_TEXT_SMALL, sprintf("Your strokes: %.0f, Par: %.0f", strokes, par), MENU_TEXT_1, 1, 0);
	ypos += 16;
	sui_text([xpos, ypos], MENU_TEXT_SMALL, "Your rank is:", MENU_TEXT_1, 1, 0);
	ypos += 16;
	if (strokes < par)
	{
		sui_text([xpos, ypos], MENU_TEXT_MEDIUM, "Diamond", '0.2 0.8 1', 1, 0);
	}
	else if (strokes == par)
	{
		sui_text([xpos, ypos], MENU_TEXT_MEDIUM, "Gold", '1 0.8 0.2', 1, 0);
	}
	else if (strokes <= par + 3)
	{
		sui_text([xpos, ypos], MENU_TEXT_MEDIUM, "Silver", '0.7 0.8 1', 1, 0);
	}
	else
	{
		sui_text([xpos, ypos], MENU_TEXT_MEDIUM, "Bronze", '0.7 0.4 0.1', 1, 0);
	}
	
	sui_set_align([SUI_ALIGN_START, SUI_ALIGN_END]);
	if (my_button("nl_reset", [8, -8], [80, 20], "Restart"))
	{
		current_menu = MENU_MAIN;
		localcmd("restart\n");
	}
	
	sui_set_align([SUI_ALIGN_END, SUI_ALIGN_END]);
	my_button("nl_next", [-8, -8], [80, 20], "Next") ? start_stage(get_next_map(currentmap)) : 0;

	sui_pop_frame();	
};

void() main_menu =
{
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);
	sui_text([0, 64], MENU_TEXT_LARGE, "Shoot Your Goo!", [1, 1, 1], 1, 0);
	sui_text([0, 64 + 48], MENU_TEXT_SMALL, "GMTK Game Jam 2019 Entry", [1, 1, 1], 1, 0);
	sui_text([0, 64 + 48 + 16], MENU_TEXT_SMALL, "by shp & Leonovsky75", [1, 1, 1], 1, 0);
	
	vector pos = [0, -24];
	vector size = [120, 140];
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_END]);
	sui_push_frame(pos, size);
	
	sui_fill([0, 0], size, MENU_BG, 0.3, 0);
	sui_border_box([0, 0], size, 2, MENU_BORDER, 0.2, 0);
	
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_START]);
	
	if (cvar_string("mapname") != "menu")
	{
		my_button("mm_restart", [0, 8], [size_x - 16, 20], "Restart") ? localcmd("restart\n") : 0;
		my_button("mm_start", [0, 8 + 24], [size_x - 16, 20], "New Game") ? current_menu = MENU_NEWGAME : 0;
		my_button("mm_settings", [0, 8 + 24 + 24], [size_x - 16, 20], "Settings") ? current_menu = MENU_SETTINGS : 0;
	}
	else
	{
		my_button("mm_start", [0, 8], [size_x - 16, 20], "New Game") ? current_menu = MENU_NEWGAME : 0;
		my_button("mm_settings", [0, 8 + 24], [size_x - 16, 20], "Settings") ? current_menu = MENU_SETTINGS : 0;
	}
	
	// my_button("mm_help", [0, 8 + 48 + 24], [size_x - 16, 20], "Help") ? current_menu = MENU_HELP : 0;
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_END]);
	my_button("mm_quit", [0, -8], [size_x - 16, 20], "Quit") ? localcmd("quit\n") : 0;
	sui_pop_frame();	
};

void(vector size) root_menu =
{
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_CENTER]);
	sui_fill([0, 0], size, '0 0 0', 0.5, 0);
	switch (current_menu)
	{
		case MENU_MAIN: main_menu(); break;
		case MENU_SETTINGS: settings_menu(); break;
		case MENU_HELP: help_menu(); break;
		case MENU_NEWGAME: new_game_menu(); break;
		case MENU_NEXTLEVEL: next_level_menu(); break;
		case MENU_TUTORIAL: tutorial_menu(); break;
		default: break;
	}
};