#version 330

layout (location = 0) in vec4 aPos;

out vec4 fLineColor;

uniform mat4 cameramat; // camera matrix
uniform vec3 bbmin;
uniform vec3 bbmax;
uniform vec4 fcolor;

void main()
{
  fLineColor = fcolor;
	
	vec3 tmp = (bbmax - bbmin)*(aPos.xyz + vec3(1.0f))*0.5f + bbmin;
	
  gl_Position = cameramat * vec4(tmp, 1.0);
	//gl_Position = cameramat * vec4(aPos.xyz, 1.0);
}