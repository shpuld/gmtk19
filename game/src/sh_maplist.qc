
struct map_list_item {
	string map;
	string name;
};

map_list_item map_list[] = 
{
	{ "start", "Introduction" },
	{ "goo02", "Pit" },
	{ "smap", "Snake" },
	{ "sticky_tut", "Sticky" },
	{ "forest", "Forest" },
	{ "goo05", "Pentagoo" },
	{ "rocket_tut", "Target Practice" },
	{ "goo01", "Isla Rock" },
	{ "goo03", "Tower" },
	{ "climb", "Climb" },
	{ "goo08", "Deconstruction" }
	{ "goo04", "Billboards" },
	{ "goo06", "Smile Mountain" },
	{ "goo07", "Frown Canyon" }
};

string(string mapfile) get_map_name =
{
	for (int i = 0; i < map_list.length; i++)
	{
		if (map_list[i].map == mapfile)
			return map_list[i].name;
	}
	return "Unknown";
};

string(string mapfile) get_next_map =
{
	for (int i = 0; i < map_list.length; i++)
	{
		if (map_list[i].map == mapfile)
			return i+1 == map_list.length ? map_list[0].map : map_list[i+1].map;
	}
	return map_list[0].map;
}