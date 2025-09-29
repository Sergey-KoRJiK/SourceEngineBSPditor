#version 330
precision highp float;

in vec2 	fTexCoord;
in vec2 	fLmpCoord;

out vec4 outColor;

uniform sampler2D sampler0; // lightmap 
uniform vec4 fxColorAlpha;	// FX Engine
uniform vec2 fStyleOfs; 
uniform float fLightmapExpShift;

const float fLightmapExpBais = 128.0f / 255.0f; 
const vec3 fInvGamma = vec3(1.0f / 2.2f);

// World and entity BModel Faces
void main()
{ 
	vec4 	lmp = texture(sampler0, fLmpCoord + fStyleOfs).rgba;

	// "Integer HDR"
	float preExp = (lmp.a - fLightmapExpBais + fLightmapExpShift)*255.0f; 
	lmp.rgb *= exp2(preExp)*fxColorAlpha.rgb;
	lmp.rgb = pow(lmp.rgb, vec3(fInvGamma)); // default gamma tonemap
	// lmp.rgb /= (lmp.rgb + vec3(1.0f)); // tonemap "x/(x+1)"
	  
  outColor = vec4(lmp.rgb, fxColorAlpha.a);
}