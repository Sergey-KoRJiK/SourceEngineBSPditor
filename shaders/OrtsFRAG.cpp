#version 330

in vec3 fLineColor;
out vec4 outColor;

// orthonormal XYZ draw
void main()
{  
  outColor = vec4(fLineColor, 1.0f);
}