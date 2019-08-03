
/*
void() trigger_example =
{
	setmodel(self, self.model);
	self.modelindex = 0;
	self.solid = SOLID_TRIGGER;
	self.touch = something;
};
*/

void() trigger_base =
{
	setmodel(self, self.model);
	self.modelindex = 0;
	self.solid = SOLID_TRIGGER;
	self.flags |= FL_FINDABLE_NONSOLID;
};

void() info_null =
{
};

void() func_illusionary =
{
	setmodel(self, self.model);
	self.solid = SOLID_NOT;
};

void() bricks_touch =
{
	if (other.classname != "player") return;
	if (vlen(other.velocity) > 600)
	{
		self.think = sub_remove;
		self.nextthink = time;
	}
};

void() func_bricks =
{
	setmodel(self, self.model);
	self.solid = SOLID_BSP;
	self.touch = bricks_touch;
};

void() death_touch =
{
	if (other.is_dead) return;
	if (other.classname != "player") return;
	player_die(other);
};

void() trigger_death =
{
	print("trigger death in map\n");
	trigger_base();
	self.touch = death_touch;
};

void() goal_touch =
{
	printf("someone %s reached goal\n", etos(other));
};

void() trigger_goal =
{
	trigger_base();
	self.touch = goal_touch;
};