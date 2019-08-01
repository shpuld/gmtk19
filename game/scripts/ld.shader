bullet
{
	cull disable
	{
		map models/bullet
		blendFunc add
	}
}

spawncircle
{
	cull disable
	{
		clampMap models/spawncircle2
		blendFunc filter
		tcMod rotate 10
	}
	{
		clampMap models/spawncircle
		blendFunc add
		tcMod rotate 35
	}
}

blood
{
	{
		map $linear:particles/blood
		alphaFunc GE128
		rgbGen vertex
		alphaGen vertex
	}
}

blood2
{
	{
		map $linear:particles/blood2
		alphaFunc GE128
		rgbGen vertex
		alphaGen vertex
	}
}

sub
{
	{
		map particles/weirdball
		blendFunc gl_dst_color gl_zero
		alphaFunc GE128
		rgbGen vertex
		alphaGen vertex
	}
}

gfx/hp_frame
{
	{
		map $nearest:gfx/hp_frame
		blendFunc blend
		alphaGen entity
	}
}


gfx/hp_fill
{
	{
		map $nearest:gfx/hp_fill
		tcMod scroll 0 0.1
	}
}

gfx/hp_top
{
	{
		map $nearest:gfx/hp_top
		tcMod scroll 0.2 0
	}
}

sky
{
	cull disable
	{
		map models/sky
	}
}

sun
{
	{
		clampMap models/sun
		blendFunc add
		tcMod rotate 10
		tcMod scale 1.1 1.1
	}
	{
		clampMap models/sun
		blendFunc add
		tcMod rotate 17
	}
}

clouds
{
	{
		map models/clouds
		blendFunc add
		tcMod scroll 0.05 0
	}	
	{
		map models/clouds
		blendFunc add
		tcMod scroll -0.025 0
		alphaGen const 0.5
	}
}

heart
{
	deformVertexes wave 1 sin 1 0.5 0 1
	{
		map models/heart
		rgbGen lightingDiffuse
	}
}

softpart
{
	program softpart
	{
		map $currentrender
	}
	{
		map $currentrender
	}
}

bloodsurface
{
	deformVertexes wave 1 sin 1 0.5 0 1
	{
		map models/bloodsurface
		blendFunc filter
		tcMod scroll -0.025 0.04
	}
}