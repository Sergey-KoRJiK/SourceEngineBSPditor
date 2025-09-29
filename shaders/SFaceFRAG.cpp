#version 330
precision highp float;

out vec4 outColor;

uniform vec4 fSelColor; 

// face select 
void main()
{   
  outColor = vec4(fSelColor);
}