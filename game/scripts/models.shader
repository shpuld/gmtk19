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

testblob
{
	{
		map models/testblob
		alphaGen entity
	}
}

testblob_alpha
{
	{
		map models/testblob
		blendFunc blend
		alphaGen entity
	}
}


blobshadow
{
	polygonOffset 1
	discrete
	sort unlitdecal
	noShadows
	{
		map textures/blobshadow
		blendFunc blend
		alphaGen vertex	
	}
}

trajectorydot
{
	sort nearest
	{
		map $whiteimage
		blendFunc GL_SRC_ALPHA GL_ONE
		rgbGen entity
		alphaGen entity
	}
}

brickpart
{
	{
		map particles/brick
		alphaFunc GE128
		rgbGen vertex
		alphaGen vertex
	}
}

diamond
{
	{
		map models/diamond
		rgbGen lightingDiffuse
	}
	{
		map models/diamond
		blendFunc add
		rgbGen wave sin 0.5 0.2 1 0.2
	}
}

diamondoutline
{
	{
		map models/diamond
		blendFunc add
		rgbGen const 0.5 0.5 0.5
	}
}