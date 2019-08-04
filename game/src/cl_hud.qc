// Empty

float not_enough_diamonds_time;
float win_time;

void() draw_hud =
{
	// crosshair
	vector ch_size = [16, 16];
	drawpic([g_width/2 - ch_size_x/2, g_height/2 - ch_size_y/2], "textures/crosshair", ch_size, '1 1 1', 0.5);
	
	// sbar bg
	drawpic([0, 0], "textures/sbar", [g_width, 48], '1 1 1', 0.5, 0);
	
	// diamonds
	float num_diamonds = getstatf(STAT_DIAMONDS_TOTAL);
	float pickedup_diamonds = getstatf(STAT_DIAMONDS);
	vector dm_size = [48, 48];
	vector dm_text_size = [24, 24];
	if (num_diamonds)
	{
		string diamonds_str = sprintf("%.0f/%.0f", pickedup_diamonds, num_diamonds);
		// drawpic([-512 + strlen(diamonds_str)*dm_text_size_x + dm_size_x + 16, 0], "textures/diamonds_bg", [512, 64], '1 1 1', 0.7, 0);
		drawpic([0, -4], "textures/diamond_icon", dm_size, '1 1 1', 0.9);
		drawstring([dm_size_x, (dm_size_y - dm_text_size_y) / 2 - 4], diamonds_str, dm_text_size, '1 1 1', 0.8, 0);
	}
	
	float rocket_jumps = getstatf(STAT_ROCKET_JUMPS);
	float sticky_jumps = getstatf(STAT_STICKY_JUMPS);
	float two_pus = FALSE;
	if (rocket_jumps > 0 && sticky_jumps > 0) two_pus = TRUE;
	
	if (rocket_jumps)
		drawpic([g_width/2 - (two_pus ? dm_size_x : dm_size_x*0.5), -4], "textures/rocket_icon", dm_size, '1 1 1', 0.9);
	if (sticky_jumps)
		drawpic([g_width/2 - (two_pus ? 0 : dm_size_x*0.5), -4], "textures/glue_icon", dm_size, '1 1 1', 0.9);
	
	// strokes
	vector small_text_size = [12, 12];
	string num_strokes = sprintf("%.0f", getstatf(STAT_STROKES));
	string strokes_text = "Strokes";
	drawstring([g_width - strlen(strokes_text)*small_text_size_x, 0], strokes_text, small_text_size, '1 1 1', 0.8, 0);
	drawstring([g_width - strlen(num_strokes)*dm_text_size_x, small_text_size_y], num_strokes, dm_text_size, '1 1 1', 0.8, 0);
	
	string par = sprintf("%.0f", getstatf(STAT_PAR));
	string par_text = "Par";
	drawstring([g_width - (strlen(strokes_text) + strlen(par_text) + 2)*small_text_size_x, 0], par_text, small_text_size, '1 1 1', 0.8, 0);
	drawstring([g_width - (strlen(strokes_text) + 2)*small_text_size_x - strlen(par)*dm_text_size_x, small_text_size_y], par, dm_text_size, '1 1 1', 0.8, 0);
	
	vector msg_bg_size = [256, 32];
	
	float power = getstatf(STAT_POWER);
	if (power > 0)
	{
		float powerfrac = power/0.8;
		string powerstr = sprintf("%.0f%%", powerfrac*100);
		drawpic([g_width/2 - msg_bg_size_x/2, g_height - 72], "textures/message_bg", msg_bg_size, '1 1 1', 0.7);
		float h = max(1.0, powerfrac)*(msg_bg_size_y - 24);
		drawfill([g_width/2 - msg_bg_size_x/2, g_height - 72 - h*0.5 + (msg_bg_size_y - 24)*0.5] + [12, 12], [min(1.0, powerfrac)*(msg_bg_size_x - 24), h], color_for_power(power), 1, 1);
	}
	
	msg_bg_size = [360, 42];
	float txtsize = 16;
	if (not_enough_diamonds_time)
	{
		string prompt1 = "Not enough diamonds!";
		string prompt2 = "Find the missing ones!";
		drawpic([g_width/2 - msg_bg_size_x/2, 72], "textures/message_bg", msg_bg_size, '1 1 1', 0.5*not_enough_diamonds_time);
		drawstring([g_width/2 - strlen(prompt1)*txtsize*0.5, 72 + 4], prompt1, [txtsize, txtsize], '1 1 1', not_enough_diamonds_time, 0);
		drawstring([g_width/2 - strlen(prompt2)*txtsize*0.5, 72 + 4 + txtsize], prompt2, [txtsize, txtsize], '1 1 1', not_enough_diamonds_time, 0);
		not_enough_diamonds_time -= frametime;
		not_enough_diamonds_time = max(0, not_enough_diamonds_time);
	}
	
	if (win_time)
	{
		string prompt = "Stage Clear!";
		txtsize = 24;
		float a = min(0.5, 0.5*win_time);
		drawpic([g_width/2 - msg_bg_size_x/2, 72], "textures/message_bg", msg_bg_size, '1 1 1', a);
		drawstring([g_width/2 - strlen(prompt)*txtsize*0.5, 72 + 8], prompt, [txtsize, txtsize], '1 1 1', a*2, 0);
		win_time -= frametime;
		win_time = max(0, win_time);
		
		if (win_time < 1 && win_time > 0)
		{
			win_time = -1;
			localcmd(sprintf("nextlevel %.0f %.0f\n", getstatf(STAT_STROKES), getstatf(STAT_PAR)));
		}
	}
};