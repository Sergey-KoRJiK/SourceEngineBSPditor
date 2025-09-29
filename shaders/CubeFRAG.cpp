#version 330

in vec4 fLineColor;
out vec4 outColor;

// bbox draw
void main()
{  
  outColor = vec4(fLineColor);
}