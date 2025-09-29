#version 330
precision highp float;

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec2 aTexCoord;
layout (location = 2) in vec2 aLmpCoord;

out vec2 	fTexCoord;
out vec2 	fLmpCoord;

uniform mat4 cameramat; 	
uniform vec3 entOrigin;
uniform vec3 entAngles; // XYZ = Pitch Yaw Roll

void main()
{
  fTexCoord = aTexCoord;
	fLmpCoord = aLmpCoord;
	
  gl_Position = cameramat * vec4(aPos.xyz + entOrigin.xyz, 1.0);
	//gl_Position = vec4(aPos, 1.0);
}