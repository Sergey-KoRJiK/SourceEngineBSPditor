unit EXTOpengl32Glew32;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus
// 
// Additional Opengl functions

interface

uses SysUtils, Windows, OpenGL;

type PGLenum = ^GLenum;
type PPChar = ^PChar;

const
  GL_VERTEX_ARRAY = 32884;
  GL_NORMAL_ARRAY = 32885;
  GL_COLOR_ARRAY = 32886;
  GL_INDEX_ARRAY = 32887;
  GL_TEXTURE_COORD_ARRAY = 32888;

  GL_RGB4 = 32847;
  GL_RGB5 = 32848;
  GL_RGB8 = 32849;
  GL_RGB10 = 32850;
  GL_RGB12 = 32851;
  GL_RGB16 = 32852;
  GL_RGBA2 = 32853;
  GL_RGBA4 = 32854;
  GL_RGB5_A1 = 32855;
  GL_RGBA8 = 32856;
  GL_RGB10_A2 = 32857;
  GL_RGBA12 = 32858;
  GL_RGBA16 = 32859;
  GL_RGB565 = 36194;

  GL_SRGB = 35904;

  GL_DEPTH_COMPONENT16 = 33189;
  GL_DEPTH_COMPONENT24 = 33190;
  GL_DEPTH_COMPONENT32 = 33191;

  GL_VERTEX_SHADER = 35633;
  GL_FRAGMENT_SHADER = 35632;
  GL_TESS_EVALUATION_SHADER = 36487;
  GL_TESS_CONTROL_SHADER = 36488;
  GL_GEOMETRY_SHADER = 36313;
  GL_COMPILE_STATUS = 35713;
  GL_SHADER_TYPE = 35663;
  GL_DELETE_STATUS = 35712;
  GL_INFO_LOG_LENGTH = 35716;
  GL_SHADER_SOURCE_LENGTH = 35720;
  GL_LINK_STATUS = 35714;
  GL_VALIDATE_STATUS = 35715;
  GL_ATTACHED_SHADERS = 35717;
  GL_ACTIVE_ATTRIBUTES = 35721;
  GL_ACTIVE_ATTRIBUTE_MAX_LENGTH = 35722;
  GL_ACTIVE_UNIFORMS = 35718;
  GL_ACTIVE_UNIFORM_MAX_LENGTH = 35719;

  // Äëÿ glInterleavedArray
  GL_T2F_V3F = 10791;
  { type record
      TexCoord_0: array[0..1] of GLfloat;
      TexCoord_1: array[0..1] of GLfloat;
      Vertex_0: array[0..2] of GLfloat;
      Vertex_1: array[0..2] of GLfloat;
      Vertex_2: array[0..2] of GLfloat;
      // 52 bytes
    end;
  }

procedure glEnableClientState(cap: GLenum); stdcall;
procedure glDisableClientState(cap: GLenum); stdcall;

procedure glNormalPointer(typed: GLenum; stride: GLsizei; const p: Pointer); stdcall;
procedure glVertexPointer(size: GLint; typed: GLenum; stride: GLsizei; const p: Pointer); stdcall;
procedure glColorPointer(size: GLint; typed: GLenum; stride: GLsizei; const p: Pointer); stdcall;
procedure glTexCoordPointer(size: GLint; typed: GLenum; stride: GLsizei; const p: Pointer); stdcall;

procedure glDrawArrays(mode: GLenum; first: GLint; count: GLsizei); stdcall;
procedure glDrawElements(mode: GLenum; count: GLsizei; typed :GLenum; const indices: Pointer); stdcall;
procedure glInterleavedArrays(format: GLenum; stride: GLsizei; const p: Pointer); stdcall;

procedure glGenTextures(n: GLsizei; textures: PGLuint); stdcall;
procedure glDeleteTextures(n: GLsizei; textures: PGLuint); stdcall;
procedure glBindTexture(target:	GLenum; texture: GLuint); stdcall;

//procedure glutBitmapCharacter(BitmapFont: Pointer; character: Integer); stdcall;

implementation

const gl  = 'opengl32.dll';

procedure glEnableClientState(cap: GLenum); stdcall; external gl;
procedure glDisableClientState(cap: GLenum); stdcall; external gl;

procedure glNormalPointer(typed: GLenum; stride: GLsizei; const p: Pointer); stdcall; external gl;
procedure glVertexPointer(size: GLint; typed: GLenum; stride: GLsizei; const p: Pointer); stdcall; external gl;
procedure glColorPointer(size: GLint; typed: GLenum; stride: GLsizei; const p: Pointer); stdcall; external gl;
procedure glTexCoordPointer(size: GLint; typed: GLenum; stride: GLsizei; const p: Pointer); stdcall; external gl;
  
procedure glDrawArrays(mode: GLenum; first: GLint; count: GLsizei); stdcall; external gl;
procedure glDrawElements(mode: GLenum; count: GLsizei; typed :GLenum; const indices: Pointer); stdcall; external gl;
procedure glInterleavedArrays(format: GLenum; stride: GLsizei; const p: Pointer); stdcall; external gl;

procedure glGenTextures(n: GLsizei; textures: PGLuint); stdcall; external gl;
procedure glDeleteTextures(n: GLsizei; textures: PGLuint); stdcall; external gl;
procedure glBindTexture(target:	GLenum; texture: GLuint); stdcall; external gl;

//procedure glutBitmapCharacter(BitmapFont: Pointer; character: Integer); stdcall; external 'glut32.dll';

end.
