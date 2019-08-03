// Empty

float not_enough_diamonds_time;

void() draw_hud =
{
	// crosshair
	vector ch_size = [16, 16];
	drawpic([g_width/2 - ch_size_x/2, g_height/2 - ch_size_y/2], "textures/crosshair", ch_size, '1 1 1', 0.5);
	
	// diamonds
	float num_diamonds = getstatf(STAT_DIAMONDS_TOTAL);
	float pickedup_diamonds = getstatf(STAT_DIAMONDS);
	vector dm_size = [64, 64];
	vector dm_text_size = [48, 48];
	if (num_diamonds)
	{
		string diamonds_str = sprintf("%.0f/%.0f", pickedup_diamonds, num_diamonds);
		drawpic([-512 + strlen(diamonds_str)*dm_text_size_x + dm_size_x + 16, 0], "textures/diamonds_bg", [512, 64], '1 1 1', 0.7, 0);
		drawpic([0, 0], "textures/diamond_icon", dm_size, '1 1 1', 0.9);
		drawstring([dm_size_x, (dm_size_y - dm_text_size_y) / 2], diamonds_str, dm_text_size, '1 1 1', 0.7, 0);
	}
	
	if (not_enough_diamonds_time)
	{
		
	}
};