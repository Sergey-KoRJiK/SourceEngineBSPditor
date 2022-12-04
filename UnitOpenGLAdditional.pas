unit UnitOpenGLAdditional;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

interface

uses SysUtils, Windows, Classes, OpenGL, EXTOpengl32Glew32;

const
  glBufferClearBits = GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT;
  
  OrdW = Ord('W');
  OrdS = Ord('S');
  OrdA = Ord('A');
  OrdD = Ord('D');
  OrdF = Ord('F');
  OrdQ = Ord('Q');
  OrdE = Ord('E');
  OrdG = Ord('G');

type tColor4fv = array[0..3] of GLfloat;

procedure SetDCPixelFormat(const InHDC: HDC);

function GenListStartGrid(): GLuint; 
function GenListOrts(): GLuint; 
function GenListCubeWireframe(): GLuint; // Cube 2x2x2

procedure InitGL();
procedure InitLight0();


implementation


procedure SetDCPixelFormat(const InHDC: HDC);
var
  pfd: TPixelFormatDescriptor;
  nPixelFormat: Integer;
begin
  {$R-}
  FillChar(pfd, SizeOf(pfd), 0);
  pfd.dwFlags:=PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
  pfd.cDepthBits:=32;

  nPixelFormat:=ChoosePixelFOrmat(InHDC, @pfd); 
  SetPixelFormat(InHDC, nPixelFormat, @pfd); 
  {$R+}
end;

function GenListStartGrid(): GLuint;
const
  StartGridColor: array[0..2] of GLubyte = (76, 76, 127);
  Scale = 10.0;
  StartGridVertexies: array[0..71] of GLfloat = (
    -8*Scale,  8*Scale,   -6*Scale,  8*Scale,
    -4*Scale,  8*Scale,   -2*Scale,  8*Scale,
     0*Scale,  8*Scale,    2*Scale,  8*Scale,
     4*Scale,  8*Scale,    6*Scale,  8*Scale,
     8*Scale,  8*Scale,   -8*Scale, -8*Scale,
    -6*Scale, -8*Scale,   -4*Scale, -8*Scale,
    -2*Scale, -8*Scale,    0*Scale, -8*Scale,
     2*Scale, -8*Scale,    4*Scale, -8*Scale,
     6*Scale, -8*Scale,    8*Scale, -8*Scale,
     8*Scale, -8*Scale,    8*Scale, -6*Scale,
     8*Scale, -4*Scale,    8*Scale, -2*Scale,
     8*Scale,  0*Scale,    8*Scale,  2*Scale,
     8*Scale,  4*Scale,    8*Scale,  6*Scale,
     8*Scale,  8*Scale,   -8*Scale, -8*Scale,
    -8*Scale, -6*Scale,   -8*Scale, -4*Scale,
    -8*Scale, -2*Scale,   -8*Scale,  0*Scale,
    -8*Scale,  2*Scale,   -8*Scale,  4*Scale,
    -8*Scale,  6*Scale,   -8*Scale,  8*Scale
  );
  StartGridIndices: array[0..35] of GLubyte = (
      0,  9,    1, 10,    2, 11,    3, 12,
      4, 13,    5, 14,    6, 15,    7, 16,
      8, 17,   18, 27,   19, 28,   20, 29,
     21, 30,   22, 31,   23, 32,   24, 33,
     25, 34,   26, 35
  );
begin
  {$R-}
  Result:=glGenLists(1);
  if Result=0 then Exit; 

	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(2, GL_FLOAT, 0, @StartGridVertexies[0]);

  glNewList(Result, GL_COMPILE); 
  glLineWidth(1);
  glColor3ubv(@StartGridColor[0]);
  glDrawElements(GL_LINES, 36, GL_UNSIGNED_BYTE, @StartGridIndices);
	glEndList();	//=========================================================

	glDisableClientState(GL_VERTEX_ARRAY);	// disable vertex arrays
  {$R+}
end;

function GenListOrts(): GLuint;
const
  LineOrtsLength = 50;
  LineOrtsOffset = 0;
  LineOrstWidth: GLfloat = 1.5;
  OrtsColorSaturation = 0.6; // from 0 (b/w) to 1 (default)

  OrtsVertexies: array[0..17] of GLshort = (
    LineOrtsOffset, 0, 0,    LineOrtsLength + LineOrtsOffset, 0, 0,
    0, LineOrtsOffset, 0,    0, LineOrtsLength + LineOrtsOffset, 0,
    0, 0, LineOrtsOffset,    0, 0, LineOrtsLength + LineOrtsOffset
  );

  OrtMainColor = (1 + 2*OrtsColorSaturation)/3;
  OrtSecondColor = (1 - OrtsColorSaturation)/3;
  OrtsColors: array[0..17] of GLfloat = (
    OrtMainColor, OrtSecondColor, OrtSecondColor,
    OrtMainColor, OrtSecondColor, OrtSecondColor,
    OrtSecondColor, OrtSecondColor, OrtMainColor,
    OrtSecondColor, OrtSecondColor, OrtMainColor,
    OrtSecondColor, OrtMainColor, OrtSecondColor,
    OrtSecondColor, OrtMainColor, OrtSecondColor
  );
begin
  {$R-}
  Result:=glGenLists(1);
  if Result=0 then Exit;  

  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_COLOR_ARRAY);

  glVertexPointer(3, GL_SHORT, 0, @OrtsVertexies[0]);
  glColorPointer(3, GL_FLOAT, 0, @OrtsColors[0]);

  glNewList(Result, GL_COMPILE);
  glLineWidth(LineOrstWidth);
  glDrawArrays(GL_LINES, 0, 6);
	glEndList();	//=========================================================

  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_COLOR_ARRAY);
  {$R+}
end;

function GenListCubeWireframe(): GLuint;
const
  CubeQuadVertecies: array[0..23] of GLfloat = (
    0, 0, 0,    0, 0, 1,    0, 1, 1,    0, 1, 0,
    1, 0, 0,    1, 0, 1,    1, 1, 1,    1, 1, 0
  );
begin
  Result:=glGenLists(1);
  if (Result = 0) then Exit;

  glNewList(Result, GL_COMPILE);
  glLineWidth(2.0);

  glBegin(GL_LINE_STRIP);
    glVertex3fv(@CubeQuadVertecies[0]);
    glVertex3fv(@CubeQuadVertecies[3]);
    glVertex3fv(@CubeQuadVertecies[6]);
    glVertex3fv(@CubeQuadVertecies[9]);
    glVertex3fv(@CubeQuadVertecies[0]);
  glEnd();

  glBegin(GL_LINE_STRIP);
    glVertex3fv(@CubeQuadVertecies[12]);
    glVertex3fv(@CubeQuadVertecies[15]);
    glVertex3fv(@CubeQuadVertecies[18]);
    glVertex3fv(@CubeQuadVertecies[21]);
    glVertex3fv(@CubeQuadVertecies[12]);
  glEnd();

  glBegin(GL_LINE_STRIP);
    glVertex3fv(@CubeQuadVertecies[0]);
    glVertex3fv(@CubeQuadVertecies[15]);
    glVertex3fv(@CubeQuadVertecies[6]);
    glVertex3fv(@CubeQuadVertecies[21]);
    glVertex3fv(@CubeQuadVertecies[0]);
  glEnd();

  glBegin(GL_LINE_STRIP);
    glVertex3fv(@CubeQuadVertecies[3]);
    glVertex3fv(@CubeQuadVertecies[18]);
    glVertex3fv(@CubeQuadVertecies[9]);
    glVertex3fv(@CubeQuadVertecies[12]);
    glVertex3fv(@CubeQuadVertecies[3]);
  glEnd();

  glBegin(GL_LINE_STRIP);
    glVertex3fv(@CubeQuadVertecies[0]);
    glVertex3fv(@CubeQuadVertecies[6]);
    glVertex3fv(@CubeQuadVertecies[18]);
    glVertex3fv(@CubeQuadVertecies[12]);
    glVertex3fv(@CubeQuadVertecies[0]);
  glEnd();

  glBegin(GL_LINE_STRIP);
    glVertex3fv(@CubeQuadVertecies[3]);
    glVertex3fv(@CubeQuadVertecies[9]);
    glVertex3fv(@CubeQuadVertecies[21]);
    glVertex3fv(@CubeQuadVertecies[15]);
    glVertex3fv(@CubeQuadVertecies[3]);
  glEnd();

	glEndList();
end;

procedure InitGL();
begin
  {$R-}
  glEnable(GL_TEXTURE_2D); // Enable Textures
  glEnable(GL_DEPTH_TEST);  // Enable Depth Buffer
  glEnable(GL_CULL_FACE); // Enable Face Normal Test
  glCullFace(GL_FRONT); // which Face side render, Front or Back
  glPolygonMode(GL_BACK, GL_FILL); // GL_FILL, GL_LINE, GL_POINT
  
  glDepthMask ( GL_TRUE ); // Enable Depth Test
  glDepthFunc(GL_LEQUAL);  // type of Depth Test
  glEnable(GL_NORMALIZE); // automatic Normalize

  glColorMaterial(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE);
  glEnable(GL_COLOR_MATERIAL);

  glShadeModel(GL_POLYGON_SMOOTH); // Interpolation color type
  // GL_FLAT - Color dont interpolated, GL_SMOOTH - linear interpolate
  // GL_POLYGON_SMOOTH

  glAlphaFunc(GL_GEQUAL, 0.1);
  glEnable(GL_ALPHA_TEST);

  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glEnable(GL_BLEND);
  
  // point border smooth
  glEnable(GL_POINT_SMOOTH);
  glHint(GL_POINT_SMOOTH_HINT, GL_NICEST); //GL_FASTEST/GL_NICEST
  // line border smooth
  glEnable(GL_LINE_SMOOTH);
  glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
  // polygon border smooth
  glEnable(GL_POLYGON_SMOOTH);
  glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
  // 
  glHint(GL_Perspective_Correction_Hint, GL_NICEST); //}

  glClearStencil(0);
  glClearDepth(1);
  glPixelStorei(GL_UNPACK_ALIGNMENT, 4);
  {$R+}
end;

procedure InitLight0();
const
  Ambient: array[0..3] of GLfloat = (0.4, 0.4, 0.7, 1); // ambient light
  Diffuse: array[0..3] of GLfloat = (0.6, 0.6, 0.9, 1); // diffuse light
  Specular: array[0..3] of GLfloat = (1, 1, 1, 1);   // specular light
  Position: array[0..3] of GLfloat = (0, 0, 20, 1);    // positional light
begin
  {$R-}
  glLightfv(GL_LIGHT0, GL_AMBIENT, @Ambient[0]);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, @Diffuse[0]);
  glLightfv(GL_LIGHT0, GL_SPECULAR, @Specular[0]);

  // position the light
  glLightfv(GL_LIGHT0, GL_POSITION, @Position[0]);

  glEnable(GL_LIGHT0); // MUST enable each light source after configuration
  {$R+}
end;


end.

