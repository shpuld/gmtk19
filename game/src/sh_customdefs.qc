//shared definitions

#define printf(x, ...) print(sprintf(x, __VA_ARGS__))

const float STAT_POWER = 51;
const float STAT_CANJUMP = 52;

void() precache_everything =
{
	precache_sound("demon/dland2.wav");
	precache_model("models/testblob.iqm");
	precache_model("models/arrow_fill.iqm");
};