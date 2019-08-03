// Empty

void() draw_hud =
{
	// crosshair
	vector ch_size = [16, 16];
	drawpic([g_width/2 - ch_size_x/2, g_height/2 - ch_size_y/2], "textures/crosshair", ch_size, '1 1 1', 0.5);
};