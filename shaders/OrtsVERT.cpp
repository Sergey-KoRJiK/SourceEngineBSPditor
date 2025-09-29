#version 330

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aLineColor;

out vec3 fLineColor;

uniform mat4 cameramat; // camera matrix
uniform float ortscale;

void main()
{
  fLineColor = aLineColor;
  gl_Position = cameramat * vec4(aPos.xyz*ortscale, 1.0);
}