
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

void(entity bricks) undo_bricks =
{
	bricks.modelindex = bricks.real_modelindex;
	bricks.solid = SOLID_BSP;
};

void() bricks_break =
{
	self.modelindex = 0;
	self.solid = SOLID_NOT;
};

void() bricks_touch =
{
	if (other.classname != "player") return;
	if (vlen(other.velocity) > 700)
	{
		pointparticles(particleeffectnum("weapons.bricks"), (self.absmin + self.absmax)/2, '0 0 1', 1);
		self.think = bricks_break;
		self.nextthink = time;
		self.active_jump = other.active_jump;
	}
};

void() func_bricks =
{
	setmodel(self, self.model);
	self.solid = SOLID_BSP;
	self.touch = bricks_touch;
	self.real_modelindex = self.modelindex;
	printf("self.modelindex %f\n", self.modelindex);
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

void(entity diamond) undo_diamond =
{
	diamond.modelindex = diamond.real_modelindex;
	diamond.active_jump = 0;
	diamonds -= 1;
};

void() diamond_touch =
{
	if (other.classname != "player" || self.modelindex == 0) return;
	
	self.active_jump = other.active_jump;
	pointparticles(particleeffectnum("weapons.diamond_pickup"), self.origin, '0 0 1', 1);
	self.modelindex = 0;
	diamonds += 1;
	printf("killed %f\n", diamonds);
};

void() item_health =
{
	setmodel(self, "models/diamond.iqm");
	self.real_modelindex = self.modelindex;
	self.modelflags |= MF_ROTATE;
	setsize(self, '-24 -24 -24', '24 24 24');
	self.solid = SOLID_TRIGGER;
	self.flags |= FL_FINDABLE_NONSOLID;
	self.touch = diamond_touch;
	diamonds_total += 1;
};