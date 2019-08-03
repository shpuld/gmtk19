textures/dev/goal
{

	q3map_surfacelight 80
	surfaceparm nolightmap
	{
		map $nearest:textures/dev/goal.tga
		rgbGen identity
	}
}

textures/dev/white
{
	{
		map $nearest:textures/dev/white.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/gray
{
	{
		map $nearest:textures/dev/gray.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/graydark
{
	{
		map $nearest:textures/dev/graydark.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/black
{
	{
		map $nearest:textures/dev/black.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/green
{
	{
		map $nearest:textures/dev/green.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/blue
{
	{
		map $nearest:textures/dev/blue.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/brown
{
	{
		map $nearest:textures/dev/brown.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}
textures/dev/beige
{
	{
		map $nearest:textures/dev/beige.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/orange
{
	{
		map $nearest:textures/dev/orange.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/red
{
	{
		map $nearest:textures/dev/red.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/purple
{
	{
		map $nearest:textures/dev/purple.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/yellow
{
	{
		map $nearest:textures/dev/yellow.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

09_64
{
	{
		reflectcube textures/test3
	}
	{
		map textures/ld/metal2
		blendFunc GL_DST_COLOR GL_ZERO
	}
}

textures/dev/cliff
{
	{
		map textures/dev/cliff
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/base_floor/diamond2c
{
/*
	{
		cubemap textures/test3
		tcgen lightmap
	}
	{
		map textures/ld/reflect
		blendFunc GL_DST_COLOR GL_ZERO
	}
	{
		map textures/ld/metal2
		blendfunc add
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
	}
*/
	program defaultwall
	diffusemap textures/ld/metal2
	reflectcube textures/test3
	reflectmask textures/ld/reflect
}

models/grass
{
	trans
	{
		map models/grass
		alphaFunc GE128
		rgbGen lightingDiffuse
	}
}

textures/dev/portal
{
	portal
	{
		alphaGen portal 100
	}
}

textures/dev/ground
{
	{
		map textures/dev/ground
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

models/rocks
{
	qer_editorimage textures/dev/rockwll
	{
		map models/rocks
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/clipmodel
{
	q3map_clipmodel
	qer_trans 0.1
	surfaceparm nodraw
	surfaceparm nolightmap
	surfaceparm nomarks
}

models/stone_
{
	q3map_shadeAngle 50
	qer_editorimage textures/dev/gray
	{
		map models/stone_
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/test_sky
{
	qer_editorimage textures/dev/edsky.tga

	q3map_globaltexture
	q3map_skylight 150 3
	q3map_sun 0.9 0.8 0.7 50 60 45

	surfaceparm sky
	surfaceparm noimpact
	surfaceparm nolightmap
	surfaceparm nomarks
	nodraw
	skyparms textures/dev/sky - -
}
