#version 330
precision highp float;

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec2 aTexCoord;
layout (location = 2) in vec2 aLmpCoord;

uniform mat4 cameramat; 

uniform vec3 fOffset; // "Face plane normal"*1.0 + "BModel origin"

void main()
{
  gl_Position = cameramat * vec4(aPos.xyz + fOffset.xyz, 1.0);
	//gl_Position = vec4(aPos, 1.0);
}