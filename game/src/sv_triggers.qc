
/*
void() trigger_example =
{
	setmodel(self, self.model);
	self.modelindex = 0;
	self.solid = SOLID_TRIGGER;
	self.touch = something;
};
*/

void() info_null =
{
};

void() func_illusionary =
{
	setmodel(self, self.model);
	self.solid = SOLID_NOT;
};

void() death_touch =
{
	printf("someone %s died\n", etos(other));
};

void() trigger_death =
{
	setmodel(self, self.model);
	self.modelindex = 0;
	self.solid = SOLID_TRIGGER;
	self.touch = death_touch;
};

void() goal_touch =
{
	printf("someone %s reached goal\n", etos(other));
};

void() trigger_goal =
{
	setmodel(self, self.model);
	self.modelindex = 0;
	self.solid = SOLID_TRIGGER;
	self.touch = goal_touch;
};