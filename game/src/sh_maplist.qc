
struct map_list_item {
	string map;
	string name;
};

map_list_item map_list[] = 
{
	{ "start", "Introduction" },
	{ "goo02", "Goo 2" },
	{ "smap", "Snake" },
	{ "goo01", "Goo 1" },
	{ "goo03", "Goo 3" },
	{ "goo04", "Goo 4" },
	{ "goo05", "Goo 5" }
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