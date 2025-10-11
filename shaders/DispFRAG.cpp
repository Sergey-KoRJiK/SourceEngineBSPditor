#version 330
precision highp float;

in vec2 	fTexCoord;
in vec2 	fLmpCoord;
in float	fDispAlpha;

out vec4 outColor;

uniform sampler2D sampler0; // lightmap 
uniform vec4 	fxColorAlpha;	// FX Engine
uniform float fStyle; 
uniform float fBump; 
uniform float fLightmapExpShift;
uniform vec4	fLmpCAPS; // xy = Lmp size in Atlas coord, z = max bumps, w = max styles

const float fLightmapExpBais = 128.0f / 255.0f; 
const vec3 fInvGamma = vec3(1.0f / 2.2f);
const vec4 FULLBRIGHT = vec4(0.0f, 0.0f, 0.0f, 1.0f);

vec3 UnpackLightmap(vec4 lmp) {
	// "Integer HDR"
	float preExp = (lmp.a - fLightmapExpBais + fLightmapExpShift)*255.0f; 
	return vec3( lmp.rgb * exp2(preExp) );	
}

// World and entity BModel Faces
void main()
{ 
	vec3 color_final;

	vec2 	fStyleBump = vec2(0.0f);
	if (fBump  < fLmpCAPS.z) {fStyleBump.x = fLmpCAPS.x*fBump;}
	if (fStyle < fLmpCAPS.w) {fStyleBump.y = fLmpCAPS.y*fStyle;}
	
	vec4 	lmp = texture(sampler0, fLmpCoord).rgba;
	if (FULLBRIGHT == lmp) {
		color_final = fxColorAlpha.rgb;
	} else {
		vec3 lmp_swtich = vec3(0.0f);
		if (fStyleBump.y > 0) lmp_swtich = UnpackLightmap(texture(sampler0, fLmpCoord + fStyleBump).rgba); 
		
		vec3 lmp_final = UnpackLightmap(lmp) + lmp_swtich;
		color_final = lmp_final * fxColorAlpha.rgb;	
		
		color_final = pow(color_final, fInvGamma);
		// color_final /= (color_final + vec3(1.0f)); // tonemap "x/(x+1)"
	}
	  
  outColor = vec4(color_final, fxColorAlpha.a);
}