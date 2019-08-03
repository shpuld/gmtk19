additive
{
	cull disable
	{
		map $diffuse
		blendFunc GL_SRC_ALPHA GL_ONE
		rgbGen identity
		alphaGen entity
	}
}

arrow_fill2
{
	cull disable
	{
		map models/arrow_fill
		blendFunc blend
		rgbGen vertex
		alphaGen vertex
		nodepthtest
	}
}

arrow_outline
{
	cull disable
	{
		map models/arrow_outline
		blendFunc blend
		rgbGen vertex
		alphaGen vertex
		nodepthtest
	}
}