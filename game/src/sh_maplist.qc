
struct map_list_item {
	string map;
	string name;
};

map_list_item map_list[] = 
{
	{ "start", "Introduction" },
	{ "goo02", "Pit" },
	{ "smap", "Snake" },
	{ "climb", "Mountain" },
	{ "sticky_tut", "Sticky" },
	{ "forest", "Forest" },
	{ "goo05", "Pentagoo" },
	{ "goo03", "Tower" },
	{ "goo01", "Isla Rock" },
	{ "rocket_tut", "Target Practice" },
	{ "dual_pu", "Duality of Goo" },
	{ "goo04", "Billboards" },
	{ "goo08", "Deconstruction" },
	{ "gentle_climb", "Gentle Climb" },
	{ "goo07", "Frown Canyon" },
	{ "goo06", "Smile Mountain" }
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
};

/*
struct map_score {
	string map;
	int score;
};

map_score map_scores[64];

void() init_scores =
{
	for (int i = 0; i < map_scores.length; i++)
	{
		map_scores[i].map = "";
		map_scores[i].score = 0;
	}
	for (int i = 0; i < map_list.length; i++)
	{
		map_scores[i].map = map_list[i].map;
		map_scores[i].score = 0;
	}
}

void() read_map_scores =
{
	init_scores();
	float file = fopen("scores", FILE_READ);
	string line = fgets(file);
	int i = 0;
	while (line)
	{
		tokenize(line);
		map_scores[i].map = argv(0);
		map_scores[i].score = stoi(argv(1));
		printf("line: %s %s\n", argv(0), argv(1));
	}
};
*/
