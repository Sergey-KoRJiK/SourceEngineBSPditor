#version 330
precision highp float;

layout (location = 0) in vec4 aPos;

out vec2 		fTexCoord;
out vec2 		fLmpCoord;
out float		fDispAlpha;

uniform mat4 cameramat; 	
uniform vec3 entOrigin;
uniform vec3 entAngles; // XYZ = Pitch Yaw Roll
uniform vec4 TexLmp0;
uniform vec4 TexLmp1;
uniform vec4 TexLmp2;
uniform vec4 TexLmp3;
uniform int  iDispSize;
uniform int  iDispBase;
uniform int  iBaseVertex;

vec2 TessellateFlatVec2(in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3, in vec2 f, in int iSwizzle) {
	vec2 res = v0;
	vec2 tmpA, tmpB;
	/*switch (iSwizzle % 4) {
		case 0:
			tmpA = (1 - f.x)*v3 + f.x*v0;
			tmpB = (1 - f.x)*v2 + f.x*v1;	
			res  = (1 - f.y)*tmpA + f.y*tmpB;
			break;
		case 1:
			tmpA = (1 - f.x)*v1 + f.x*v2;
			tmpB = (1 - f.x)*v0 + f.x*v3;	
			res  = (1 - f.y)*tmpB + f.y*tmpA;
			break;
		case 2:
			tmpA = (1 - f.x)*v2 + f.x*v3;
			tmpB = (1 - f.x)*v1 + f.x*v0;	
			res  = (1 - f.y)*tmpA + f.y*tmpB;
			break;
		case 3:
			tmpA = (1 - f.x)*v2 + f.x*v1;
			tmpB = (1 - f.x)*v3 + f.x*v0;	
			res  = (1 - f.y)*tmpA + f.y*tmpB;
			break;
	} //*/

	tmpA = (1 - f.x)*v0 + f.x*v3;
	tmpB = (1 - f.x)*v1 + f.x*v2;	
	res  = (1 - f.y)*tmpA + f.y*tmpB; //*/
			
	return res; 
}

void main()
{	
	vec2 fFrac	= vec2( int((gl_VertexID-iBaseVertex) / iDispSize), mod((gl_VertexID-iBaseVertex), iDispSize) ); 
	fFrac /= float(iDispSize-1);
  fTexCoord 	= TessellateFlatVec2(TexLmp0.xy, TexLmp1.xy, TexLmp2.xy, TexLmp3.xy, fFrac, iDispBase);
	fLmpCoord 	= TessellateFlatVec2(TexLmp0.zw, TexLmp1.zw, TexLmp2.zw, TexLmp3.zw, fFrac.yx, iDispBase);
	fDispAlpha	=	aPos.w;
	
  gl_Position = cameramat * vec4(aPos.xyz, 1.0);
	//gl_Position = vec4(aPos, 1.0);
}