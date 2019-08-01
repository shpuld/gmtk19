!!ver 100 150
!!permu TESS
!!permu DELUXE
!!permu FULLBRIGHT
!!permu FOG
!!permu LIGHTSTYLED
!!permu BUMP
!!permu SPECULAR
!!permu REFLECTCUBEMASK
!!cvarf r_glsl_offsetmapping_scale
!!cvardf r_tessellation_level=5
!!samps diffuse lightmap specular normalmap fullbright reflectmask reflectcube paletted lightmap1 lightmap2 lightmap3 deluxemap deluxemap1 deluxemap2 deluxemap3

#include "sys/defs.h"

//this is what normally draws all of your walls, even with rtlights disabled
//note that the '286' preset uses drawflat_walls instead.

#include "sys/fog.h"

#if !defined(TESS_CONTROL_SHADER)
	#if defined(OFFSETMAPPING) || defined(SPECULAR) || defined(REFLECTCUBEMASK)
		varying vec3 eyevector;
	#endif

	#if defined(REFLECTCUBEMASK) || defined(BUMPMODELSPACE)
		varying mat3 invsurface;
	#endif

	varying vec2 tc;
	#ifdef VERTEXLIT
		varying vec4 vc;
	#else
		#ifdef LIGHTSTYLED
			//we could use an offset, but that would still need to be per-surface which would break batches
			//fixme: merge attributes?
			varying vec2 lm0, lm1, lm2, lm3;
		#else
			varying vec2 lm0;
		#endif
	#endif
#endif

#ifdef VERTEX_SHADER
#ifdef TESS
varying vec3 vertex, normal;
#endif
void main ()
{
#if defined(OFFSETMAPPING) || defined(SPECULAR) || defined(REFLECTCUBEMASK)
	vec3 eyeminusvertex = e_eyepos - v_position.xyz;
	eyevector.x = dot(eyeminusvertex, v_svector.xyz);
	eyevector.y = dot(eyeminusvertex, v_tvector.xyz);
	eyevector.z = dot(eyeminusvertex, v_normal.xyz);
#endif
#if defined(REFLECTCUBEMASK) || defined(BUMPMODELSPACE)
	invsurface[0] = v_svector;
	invsurface[1] = v_tvector;
	invsurface[2] = v_normal;
#endif
	tc = v_texcoord;
#ifdef FLOW
	tc.s += e_time * -0.5;
#endif
#ifdef VERTEXLIT
	#ifdef LIGHTSTYLED
	//FIXME, only one colour.
	vc = v_colour * e_lmscale[0];
	#else
	vc = v_colour * e_lmscale;
	#endif
#else
	lm0 = v_lmcoord;
#ifdef LIGHTSTYLED
	lm1 = v_lmcoord2;
	lm2 = v_lmcoord3;
	lm3 = v_lmcoord4;
#endif
#endif
	gl_Position = ftetransform();

#ifdef TESS
	vertex = v_position;
	normal = v_normal;
#endif
}
#endif


#if defined(TESS_CONTROL_SHADER)
layout(vertices = 3) out;

in vec3 vertex[];
out vec3 t_vertex[];
in vec3 normal[];
out vec3 t_normal[];
#if defined(OFFSETMAPPING) || defined(SPECULAR) || defined(REFLECTCUBEMASK)
	in vec3 eyevector[];
	out vec3 t_eyevector[];
#endif
#ifdef REFLECTCUBEMASK
	in mat3 invsurface[];
	out mat3 t_invsurface[];
#endif
in vec2 tc[];
out vec2 t_tc[];
#ifdef VERTEXLIT
	in vec4 vc[];
	out vec4 t_vc[];
#else
	in vec2 lm0[];
	out vec2 t_lm0[];
	#ifdef LIGHTSTYLED
		in vec2 lm1[], lm2[], lm3[];
		out vec2 t_lm1[], t_lm2[], t_lm3[];
	#endif
#endif
void main()
{
	//the control shader needs to pass stuff through
#define id gl_InvocationID
	t_vertex[id] = vertex[id];
	t_normal[id] = normal[id];
	#ifdef REFLECTCUBEMASK
		t_invsurface[id] = invsurface[id];
	#endif
	t_tc[id] = tc[id];
	#ifdef VERTEXLIT
		t_vc[id] = vc[id];
	#else
		t_lm0[id] = lm0[id];
		#ifdef LIGHTSTYLED
			t_lm1[id] = lm1[id];
			t_lm2[id] = lm2[id];
			t_lm3[id] = lm3[id];
		#endif
	#endif

	#if defined(SPECULAR) || defined(OFFSETMAPPING) || defined(REFLECTCUBEMASK)
		t_eyevector[id] = eyevector[id];
	#endif

	gl_TessLevelOuter[0] = float(r_tessellation_level);
	gl_TessLevelOuter[1] = float(r_tessellation_level);
	gl_TessLevelOuter[2] = float(r_tessellation_level);
	gl_TessLevelInner[0] = float(r_tessellation_level);
}
#endif









#if defined(TESS_EVALUATION_SHADER)
layout(triangles) in;

in vec3 t_vertex[];
in vec3 t_normal[];
#if defined(OFFSETMAPPING) || defined(SPECULAR) || defined(REFLECTCUBEMASK)
	in vec3 t_eyevector[];
#endif
#ifdef REFLECTCUBEMASK
	in mat3 t_invsurface[];
#endif
in vec2 t_tc[];
#ifdef VERTEXLIT
	in vec4 t_vc[];
#else
	#ifdef LIGHTSTYLED
		//we could use an offset, but that would still need to be per-surface which would break batches
		//fixme: merge attributes?
		in vec2 t_lm0[], t_lm1[], t_lm2[], t_lm3[];
	#else
		in vec2 t_lm0[];
	#endif
#endif

#define LERP(a) (gl_TessCoord.x*a[0] + gl_TessCoord.y*a[1] + gl_TessCoord.z*a[2])
void main()
{
#define factor 1.0
	tc = LERP(t_tc);
	#ifdef VERTEXLIT
		vc = LERP(t_vc);
	#else
		lm0 = LERP(t_lm0);
		#ifdef LIGHTSTYLED
			lm1 = LERP(t_lm1);
			lm2 = LERP(t_lm2);
			lm3 = LERP(t_lm3);
		#endif
	#endif
	vec3 w = LERP(t_vertex);

	vec3 t0 = w - dot(w-t_vertex[0],t_normal[0])*t_normal[0];
	vec3 t1 = w - dot(w-t_vertex[1],t_normal[1])*t_normal[1];
	vec3 t2 = w - dot(w-t_vertex[2],t_normal[2])*t_normal[2];
	w = w*(1.0-factor) + factor*(gl_TessCoord.x*t0+gl_TessCoord.y*t1+gl_TessCoord.z*t2);

#if defined(PCF) || defined(SPOT) || defined(CUBE)
	//for texture projections/shadowmapping on dlights
	vtexprojcoord = (l_cubematrix*vec4(w.xyz, 1.0));
#endif

	//FIXME: we should be recalcing these here, instead of just lerping them
#ifdef REFLECTCUBEMASK
	invsurface = LERP(t_invsurface);
#endif
#if defined(SPECULAR) || defined(OFFSETMAPPING) || defined(REFLECTCUBEMASK)
	eyevector = LERP(t_eyevector);
#endif

	gl_Position = m_modelviewprojection * vec4(w,1.0);
}
#endif






#ifdef FRAGMENT_SHADER

//samplers
#define s_colourmap	s_t0
uniform sampler2D	s_colourmap;

#ifdef OFFSETMAPPING
#include "sys/offsetmapping.h"
#endif
void main ()
{
//adjust texture coords for offsetmapping
#ifdef OFFSETMAPPING
	vec2 tcoffsetmap = offsetmap(s_normalmap, tc, eyevector);
#define tc tcoffsetmap
#endif

#if defined(EIGHTBIT) && !defined(LIGHTSTYLED)
	//optional: round the lightmap coords to ensure all pixels within a texel have different lighting values either. it just looks wrong otherwise.
	//don't bother if its lightstyled, such cases will have unpredictable correlations anyway.
	//FIXME: this rounding is likely not correct with respect to software rendering. oh well.
#if __VERSION__ >= 130
	vec2 lmsize = vec2(textureSize(s_lightmap0, 0));
#else
	#define lmsize vec2(128.0,2048.0)
#endif
#define texelstolightmap (16.0)
	vec2 lmcoord0 = floor(lm0 * lmsize*texelstolightmap)/(lmsize*texelstolightmap);
#define lm0 lmcoord0
#endif


//yay, regular texture!
	gl_FragColor = texture2D(s_diffuse, 0.75*tc + vec2(-e_time * 0.012, e_time * 0.008)) * 0.5;
	vec2 tcscroll = tc * 0.3;
	tcscroll.x += e_time * 0.015;
	tcscroll.y += e_time * 0.025;
	gl_FragColor += texture2D(s_diffuse, tcscroll) * 0.5;

#if defined(BUMP) && (defined(DELUXE) || defined(SPECULAR) || defined(REFLECTCUBEMASK))
	vec3 norm = normalize(texture2D(s_normalmap, tc).rgb - 0.5);
#elif defined(SPECULAR) || defined(DELUXE) || defined(REFLECTCUBEMASK)
	vec3 norm = vec3(0, 0, 1);	//specular lighting expects this to exist.
#endif

//modulate that by the lightmap(s) including deluxemap(s)
#ifdef VERTEXLIT
	#ifdef LIGHTSTYLED
	vec3 lightmaps = vc.rgb;
	#else
	vec3 lightmaps = vc.rgb;
	#endif
	#define deluxe vec3(0.0,0.0,1.0)
#else
	#ifdef LIGHTSTYLED
		#define deluxe vec3(0.0,0.0,1.0)
		vec3 lightmaps;
		#ifdef DELUXE
			lightmaps  = texture2D(s_lightmap0, lm0).rgb * e_lmscale[0].rgb * dot(norm, 2.0*texture2D(s_deluxemap0, lm0).rgb-0.5);
			lightmaps += texture2D(s_lightmap1, lm1).rgb * e_lmscale[1].rgb * dot(norm, 2.0*texture2D(s_deluxemap1, lm1).rgb-0.5);
			lightmaps += texture2D(s_lightmap2, lm2).rgb * e_lmscale[2].rgb * dot(norm, 2.0*texture2D(s_deluxemap2, lm2).rgb-0.5);
			lightmaps += texture2D(s_lightmap3, lm3).rgb * e_lmscale[3].rgb * dot(norm, 2.0*texture2D(s_deluxemap3, lm3).rgb-0.5);
		#else
			lightmaps  = texture2D(s_lightmap0, lm0).rgb * e_lmscale[0].rgb;
			lightmaps += texture2D(s_lightmap1, lm1).rgb * e_lmscale[1].rgb;
			lightmaps += texture2D(s_lightmap2, lm2).rgb * e_lmscale[2].rgb;
			lightmaps += texture2D(s_lightmap3, lm3).rgb * e_lmscale[3].rgb;
		#endif
	#else
		vec3 lightmaps = (texture2D(s_lightmap, lm0) * e_lmscale).rgb;
		//modulate by the  bumpmap dot light
		#ifdef DELUXE
			vec3 deluxe = (texture2D(s_deluxemap, lm0).rgb-0.5);
			#ifdef BUMPMODELSPACE
				deluxe = normalize(deluxe*invsurface);
#else
				lightmaps *= 2.0 / max(0.25, deluxe.z);	//counter the darkening from deluxemaps
			#endif
			lightmaps *= dot(norm, deluxe);
		#else
			#define deluxe vec3(0.0,0.0,1.0)
		#endif
	#endif
#endif

//add in specular, if applicable.
#ifdef SPECULAR
	vec4 specs = texture2D(s_specular, tc);
	vec3 halfdir = normalize(normalize(eyevector) + deluxe);	//this norm should be the deluxemap info instead
	float spec = pow(max(dot(halfdir, norm), 0.0), FTE_SPECULAR_EXPONENT * specs.a);
	spec *= FTE_SPECULAR_MULTIPLIER;
//NOTE: rtlights tend to have a *4 scaler here to over-emphasise the effect because it looks cool.
//As not all maps will have deluxemapping, and the double-cos from the light util makes everything far too dark anyway,
//we default to something that is not garish when the light value is directly infront of every single pixel.
//we can justify this difference due to the rtlight editor etc showing the *4.
	gl_FragColor.rgb += spec * specs.rgb;
#endif

#ifdef REFLECTCUBEMASK
	vec3 rtc = reflect(normalize(-eyevector), norm);
	rtc = rtc.x*invsurface[0] + rtc.y*invsurface[1] + rtc.z*invsurface[2];
	rtc = (m_model * vec4(rtc.xyz,0.0)).xyz;
	gl_FragColor.rgb += texture2D(s_reflectmask, tc).rgb * textureCube(s_reflectcube, rtc).rgb;
#endif

#ifdef EIGHTBIT //FIXME: with this extra flag, half the permutations are redundant.
	lightmaps *= 0.5;	//counter the fact that the colourmap contains overbright values and logically ranges from 0 to 2 intead of to 1.
	float pal = texture2D(s_paletted, tc).r;	//the palette index. hopefully not interpolated.
	lightmaps -= 1.0 / 128.0;	//software rendering appears to round down, so make sure we favour the lower values instead of rounding to the nearest
	gl_FragColor.r = texture2D(s_colourmap, vec2(pal, 1.0-lightmaps.r)).r;	//do 3 lookups. this is to cope with lit files, would be a waste to not support those.
	gl_FragColor.g = texture2D(s_colourmap, vec2(pal, 1.0-lightmaps.g)).g;	//its not very softwarey, but re-palettizing is ugly.
	gl_FragColor.b = texture2D(s_colourmap, vec2(pal, 1.0-lightmaps.b)).b;	//without lits, it should be identical.
#else
	//now we have our diffuse+specular terms, modulate by lightmap values.
	gl_FragColor.rgb *= lightmaps.rgb; // lets do this later

//add on the fullbright
#ifdef FULLBRIGHT
	gl_FragColor.rgb += texture2D(s_fullbright, tc).rgb;
#endif
#endif

//entity modifiers
	gl_FragColor = gl_FragColor * e_colourident;

#if defined(MASK)
#if defined(MASKLT)
	if (gl_FragColor.a < MASK)
		discard;
#else
	if (gl_FragColor.a >= MASK)
		discard;
#endif
	gl_FragColor.a = 1.0;	//alpha blending AND alpha testing usually looks stupid, plus it screws up our fog.
#endif

//and finally hide it all if we're fogged.
#ifdef FOG
	gl_FragColor.rgba = fog4(gl_FragColor);
#endif
}
#endif

