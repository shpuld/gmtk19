
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
};

void() death_touch =
{
	if (other.is_dead) return;
	if (other.classname != "player") return;
	player_die(other);
};

void() trigger_death =
{
	trigger_base();
	self.touch = death_touch;
};

void() goal_touch =
{
	if (other.classname != "player") return;
	msg_entity = other;
	BeginEvent(EV_GOAL);
	multicast('0 0 0', MULTICAST_ONE_R);
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
	sound(other, CHAN_ITEM, "sounds/diamondpickup2.wav", 0.5, 0, 100 + random() * 4);
	diamonds += 1;
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

void(entity glue) undo_glue =
{
	glue.modelindex = glue.real_modelindex;
};

void() glue_touch =
{
	if (other.classname != "player" || self.modelindex == 0) return;
	self.active_jump = other.active_jump;
	self.modelindex = 0;
	sound(other, CHAN_AUTO, "sounds/diamondpickup2.wav", 0.5, 0, 50);
	other.sticky_jumps = 5;
};

void() item_haste =
{
	// todo add particles
	setmodel(self, "models/glue.iqm");
	self.real_modelindex = self.modelindex;
	self.modelflags |= MF_ROTATE;
	setsize(self, '-24 -24 -24', '24 24 24');
	self.solid = SOLID_TRIGGER;
	self.flags |= FL_FINDABLE_NONSOLID;
	self.touch = glue_touch;
};