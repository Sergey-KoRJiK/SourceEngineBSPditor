unit UnitOpenGLext;

// This module ported by Sergey-KoRJiK, 2020

// Original file: glext.h, license from this file:
// ***********************************************************************************
// Copyright (c) 2013-2016 The Khronos Group Inc.

// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and/or associated documentation files (the "Materials"),
// to deal in the Materials without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Materials, and to permit persons to whom
// the Materials are furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Materials.
//
// THE MATERIALS ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE MATERIALS OR THE USE
// OR OTHER DEALINGS IN THE MATERIALS.
// ***********************************************************************************

// Based OpenGL in Delphi 7 is Version 1.0 (and GLU version 1.1).
// wglGetProcessAddress always return NULL for all function in 1.0 and 1.1
// OpenGL versions. So EXT from 1.1 will be defined as static imported functions
// OpenGL 1.2+ functions initialized to 942 global variables (32-bit pointer).
// Additional 6 String 32-bit Pointers and 5 32-bit Integer as global variables.
// Totaly, this requarement ~4 KBytes additional memory for global variables


interface

// check if this module used in not Delphi 7 IDE
{$IFNDEF VER150}
  {$MESSAGE FATAL '"OpenGL EXT&ARB" UNIT FILE ONLY FOR "Borland Delphi 7" (x86)!!!'}
{$ENDIF}

uses
  Windows,
  OpenGL;

{$DEFINE GL_VERSION_1_0}

// define help types for EXT and ARB
type GLhandle           = GLenum;
type PGLhandle          = ^GLhandle;
type GLchar             = Char;
type PGLchar            = ^GLchar;
type PPGLchar           = ^PGLchar;
type PGLenum            = ^GLenum;
type PGLbitfield        = ^GLbitfield;
type GLsizeiptr         = GLsizei;  // GLsizeiptr is sensetive to SizeOf(Pointer)
type GLintptr           = GLint;    // GLintptr is sensetive to SizeOf(Pointer)
type GLuintptr          = GLuint;   // GLuintptr is sensetive to SizeOf(Pointer)
type PGLsizeiptr        = ^GLsizeiptr;
type PGLintptr          = ^GLintptr;
type PGLuintptr         = ^GLuintptr;
type PGLvoid            = Pointer;
type PPGLvoid           = ^PGLvoid;
type GLhalf             = Word;
type PGLhalf            = ^GLhalf;
type GLint64            = Int64;
type GLuint64           = Int64;
type GLsync             = PGLvoid;
type PGLint64           = ^GLint64;
type PGLuint64          = ^GLuint64;
type PGLsync            = ^GLsync;

// define "dynamic arrays" types for each OpenGL type
type AGLhandle          = array of GLhandle;
type AGLchar            = array of GLchar;
type APGLchar           = array of PGLchar; // PPGLchar = APGLchar
type AGLenum            = array of GLenum;
type AGLuint            = array of GLuint;
type AGLint             = array of GLint;
type AGLubyte           = array of GLubyte;
type AGLbyte            = array of GLbyte;
type AGLfloat           = array of GLfloat;
type AGLdouble          = array of GLdouble;
type AGLshort           = array of GLshort;
type AGLushort          = array of GLushort;
type AGLboolean         = array of GLboolean;
type AGLbitfield        = array of GLbitfield;
type AGLsizeiptr        = array of GLsizeiptr;
type AGLintptr          = array of GLintptr;
type AGLuintptr         = array of GLuintptr;
type AGLsizei           = array of GLsizei;
type AGLhalf            = array of GLhalf;

type GLDrawArraysIndirectCommand = record
    count, primCount, first: GLuint;
    baseInstance: GLuint; // must be zero for OpenGL less then 4.2
  end;
type PGLDrawArraysIndirectCommand = ^GLDrawArraysIndirectCommand;
type AGLDrawArraysIndirectCommand = array of GLDrawArraysIndirectCommand;

type GLDrawElementsIndirectCommand = record
    count, primCount, firstIndex, baseVertex: GLuint;
    baseInstance: GLuint; // must be zero for OpenGL less then 4.2
  end;
type PGLDrawElementsIndirectCommand = ^GLDrawElementsIndirectCommand;
type AGLDrawElementsIndirectCommand = array of GLDrawElementsIndirectCommand;

type GLDEBUGPROC = procedure(source, debugType: GLenum; id: GLuint;
  severity: GLenum; length: GLsizei; const msg: PGLchar;
  const userParam: PGLvoid); stdcall;
type PGLDEBUGPROC = ^GLDEBUGPROC;


var
  // Help additional information
  OpenGLVersion: String = '1.0';
  OpenGLVersionShort: String = '1.0';
  OpenGLVendor: String = 'Unknown';
  OpenGLRenderer: String = 'Unknown';
  OpenGLExtArbList: String = '';
  OpenGLShaderVersion: String = '0.0.0';
  //
  OpenGLVersionValues: array [0..1] of Integer = (1, 0);
  OpenGLShaderVersionValues: array[0..2] of Integer = (0, 0, 0);


////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 1.1 Core Extensions    ////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_1_1}


// EXT Vertex array ************************************************************
{$DEFINE GL_EXT_vertex_array}
const
  GL_EXT_vertex_array_str = 'GL_EXT_vertex_array';
  //
  GL_VERTEX_ARRAY             = $8074;
  GL_NORMAL_ARRAY             = $8075;
  GL_COLOR_ARRAY              = $8076;
  GL_INDEX_ARRAY              = $8077;
  GL_TEXTURE_COORD_ARRAY      = $8078;
  GL_EDGE_FLAG_ARRAY          = $8079;
  GL_DOUBLE                   = $140A; // for GLdouble
  GL_VERTEX_ARRAY_SIZE  				  = $807A;
  GL_VERTEX_ARRAY_TYPE  				  = $807B;
  GL_VERTEX_ARRAY_STRIDE				  = $807C;
  GL_VERTEX_ARRAY_COUNT 				  = $807D;
  GL_NORMAL_ARRAY_TYPE  				  = $807E;
  GL_NORMAL_ARRAY_STRIDE				  = $807F;
  GL_NORMAL_ARRAY_COUNT 				  = $8080;
  GL_COLOR_ARRAY_SIZE   				  = $8081;
  GL_COLOR_ARRAY_TYPE   				  = $8082;
  GL_COLOR_ARRAY_STRIDE 				  = $8083;
  GL_COLOR_ARRAY_COUNT  				  = $8084;
  GL_INDEX_ARRAY_TYPE   				  = $8085;
  GL_INDEX_ARRAY_STRIDE 				  = $8086;
  GL_INDEX_ARRAY_COUNT  				  = $8087;
  GL_TEXTURE_COORD_ARRAY_SIZE    = $8088;
  GL_TEXTURE_COORD_ARRAY_TYPE    = $8089;
  GL_TEXTURE_COORD_ARRAY_STRIDE  = $808A;
  GL_TEXTURE_COORD_ARRAY_COUNT   = $808B;
  GL_EDGE_FLAG_ARRAY_STRIDE      = $808C;
  GL_EDGE_FLAG_ARRAY_COUNT       = $808D;
  GL_VERTEX_ARRAY_POINTER        = $808E;
  GL_NORMAL_ARRAY_POINTER        = $808F;
  GL_COLOR_ARRAY_POINTER         = $8090;
  GL_INDEX_ARRAY_POINTER         = $8091;
  GL_TEXTURE_COORD_ARRAY_POINTER = $8092;
  GL_EDGE_FLAG_ARRAY_POINTER     = $8093;

// PROC PROTOTYPES
procedure glArrayElement(index: GLint); stdcall;
procedure glDrawArrays(mode: GLenum; first: GLint; count: GLsizei); stdcall;
procedure glDrawElements(mode: GLenum; count: GLsizei; indexType: GLenum;
  const indices: PGLvoid); stdcall;
procedure glVertexPointer(size: GLint; dataType: GLenum; stride: GLsizei;
  const data: PGLvoid); stdcall;
procedure glNormalPointer(dataType: GLenum; stride: GLsizei;
  const data: PGLvoid); stdcall;
procedure glColorPointer(size: GLint; dataType: GLenum; stride: GLsizei;
  const data: PGLvoid); stdcall;
procedure glIndexPointer(dataType: GLenum; stride: GLsizei;
  const data: PGLvoid); stdcall;
procedure glTexCoordPointer(size: GLint; dataType: GLenum; stride: GLsizei;
  const data: PGLvoid); stdcall;
procedure glEdgeFlagPointer(stride: GLsizei; const data: PGLboolean); stdcall;
procedure glFogCoordPointer(dataType: GLenum; stride: GLsizei;
  const data: PGLvoid); stdcall;
procedure glGetPointerv(pname: GLenum; params: PPGLvoid); stdcall;
procedure glEnableClientState(cap: GLenum); stdcall;
procedure glDisableClientState(cap: GLenum); stdcall;
// End EXT Vertex Array ********************************************************


// EXT texture *****************************************************************
{$DEFINE GL_EXT_texture}
const
  GL_EXT_texture_str = 'GL_EXT_texture';
  //
  GL_ALPHA4                     = $803B;
  GL_ALPHA8                     = $803C;
  GL_ALPHA12                    = $803D;
  GL_ALPHA16                    = $803E;
  GL_LUMINANCE4                 = $803F;
  GL_LUMINANCE8                 = $8040;
  GL_LUMINANCE12                = $8041;
  GL_LUMINANCE16                = $8042;
  GL_LUMINANCE4_ALPHA4          = $8043;
  GL_LUMINANCE6_ALPHA2          = $8044;
  GL_LUMINANCE8_ALPHA8          = $8045;
  GL_LUMINANCE12_ALPHA4         = $8046;
  GL_LUMINANCE12_ALPHA12        = $8047;
  GL_LUMINANCE16_ALPHA16        = $8048;
  GL_INTENSITY                  = $8049;
  GL_INTENSITY4                 = $804A;
  GL_INTENSITY8                 = $804B;
  GL_INTENSITY12                = $804C;
  GL_INTENSITY16                = $804D;
  GL_RGB2                       = $804E;
  GL_RGB4                       = $804F;
  GL_RGB5                       = $8050;
  GL_RGB8                       = $8051;
  GL_RGB10                      = $8052;
  GL_RGB12                      = $8053;
  GL_RGB16                      = $8054;
  GL_RGBA2                      = $8055;
  GL_RGBA4                      = $8056;
  GL_RGB5_A1                    = $8057;
  GL_RGBA8                      = $8058;
  GL_RGB10_A2                   = $8059;
  GL_RGBA12                     = $805A;
  GL_RGBA16                     = $805B;
  GL_TEXTURE_RED_SIZE           = $805C;
  GL_TEXTURE_GREEN_SIZE         = $805D;
  GL_TEXTURE_BLUE_SIZE          = $805E;
  GL_TEXTURE_ALPHA_SIZE         = $805F;
  GL_TEXTURE_LUMINANCE_SIZE     = $8060;
  GL_TEXTURE_INTENSITY_SIZE     = $8061;
  GL_REPLACE                    = $8062;
  GL_PROXY_TEXTURE_1D           = $8063;
  GL_PROXY_TEXTURE_2D           = $8064;
  GL_TEXTURE_TOO_LARGE          = $8065;
// End EXT Texture *************************************************************


// EXT Texture object **********************************************************
{$DEFINE GL_EXT_texture_object}
const
  GL_EXT_texture_object_str = 'GL_EXT_texture_object';
  //
  GL_TEXTURE_PRIORITY       = $8066;
  GL_TEXTURE_RESIDENT       = $8067;
  GL_TEXTURE_1D_BINDING     = $8068;
  GL_TEXTURE_2D_BINDING     = $8069;
  GL_TEXTURE_3D_BINDING     = $806A;

// PROC PROTOTYPES
procedure glGenTextures(n: GLsizei; textures: PGLuint); stdcall;
procedure glDeleteTextures(n: GLsizei; const textures: PGLuint); stdcall;
procedure glBindTexture(target:	GLenum; texture: GLuint); stdcall;
procedure glPrioritizeTextures(n: GLsizei; const textures: PGLuint;
  const priorities: PGLclampf); stdcall;
function glAreTexturesResident(n: GLsizei; textures: PGLuint;
  const residences: PGLboolean): GLboolean; stdcall;
function glIsTexture(texture: GLuint): GLboolean; stdcall;
// End EXT Texture object ******************************************************


// CEXT opy texture ************************************************************
{$DEFINE GL_EXT_copy_texture}
const
  GL_EXT_copy_texture_str = 'GL_EXT_copy_texture';

// PROC PROTOTYPES
procedure glCopyTexImage1D(target: GLenum; level: GLint; internalFormat: GLenum;
  x, y: GLint; width: GLsizei; border: GLint); stdcall;
procedure glCopyTexImage2D(target: GLenum; level: GLint; internalFormat: GLenum;
  x, y: GLint; width, height: GLsizei; border: GLint); stdcall;
procedure glCopyTexSubImage1D(target: GLenum; level, xOffset, x, y: GLint;
  width: GLsizei); stdcall;
procedure glCopyTexSubImage2D(target: GLenum;
  level, xOffset, yOffset, x, y: GLint;
  width, height: GLsizei); stdcall;
// End EXT Copy texture ********************************************************


// EXT Subtexture **************************************************************
{$DEFINE GL_EXT_subtexture}
const
  GL_EXT_subtexture_str = 'GL_EXT_subtexture';

// PROC PROTOTYPES
procedure glTexSubImage1D(target: GLenum; level, xOffset: GLint; width: GLsizei;
  format, pixelType: GLenum; const pixels: PGLvoid); stdcall;
procedure glTexSubImage2D(target: GLenum; level, xOffset, yOffset: GLint;
  width, height: GLsizei; format, pixelType: GLenum; 
  const pixels: PGLvoid); stdcall;
// End EXT Subtexture **********************************************************


// EXT Polygon offset **********************************************************
{$DEFINE GL_EXT_polygon_offset}
const
  GL_EXT_polygon_offset_str = 'GL_EXT_polygon_offset';
  //
  GL_POLYGON_OFFSET         = $8037;
  GL_POLYGON_OFFSET_FACTOR  = $8038;
  GL_POLYGON_OFFSET_BIAS    = $8039;

// PROC PROTOTYPES
procedure glPolygonOffset(factor, bias: GLfloat); stdcall;
// End EXT Polygon offset ******************************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 1.2 Extensions    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_1_2}


// EXT Blend minmax ************************************************************
{$DEFINE GL_EXT_blend_minmax}
const
  GL_EXT_blend_minmax_str = 'GL_EXT_blend_minmax';
  //
  GL_FUNC_ADD         = $8006;
  GL_MIN              = $8007;
  GL_MAX              = $8008;
  GL_BLEND_EQUATION   = $8009;

// PROC PROTOTYPES
type PFNGLBLENDEQUATIONEXTPROC = procedure(mode: GLenum); stdcall;

// PROC VARIABLE POINTERS
var
  glBlendEquationEXT: PFNGLBLENDEQUATIONEXTPROC;
// End EXT Blend minmax ********************************************************


// EXT Blend substract *********************************************************
{$DEFINE GL_EXT_blend_subtract}
const
  GL_EXT_blend_subtract_str = 'GL_EXT_blend_subtract';
  //
  GL_FUNC_SUBTRACT          = $800A;
  GL_FUNC_REVERSE_SUBTRACT  = $800B;

// End EXT Blend substract *****************************************************


// EXT Blend color *************************************************************
{$DEFINE GL_EXT_blend_color}
const
  GL_EXT_blend_color_str = 'GL_EXT_blend_color';
  //
  GL_CONSTANT_COLOR             = $8001;
  GL_ONE_MINUS_CONSTANT_COLOR   = $8002;
  GL_CONSTANT_ALPHA             = $8003;
  GL_ONE_MINUS_CONSTANT_ALPHA   = $8004;
  GL_BLEND_COLOR                = $8005;

// PROC PROTOTYPES
type PFNGLBLENDCOLOREXTPROC = procedure(
  red, green, blue, alpha: GLclampf); stdcall;

// PROC VARIABLE POINTERS
var
  glBlendColorEXT:  PFNGLBLENDCOLOREXTPROC;
// End EXT Blend color *********************************************************


// EXT Histogram ***************************************************************
{$DEFINE GL_EXT_histogram}
const
  GL_EXT_histogram_str = 'GL_EXT_histogram';
  //
  GL_HISTOGRAM                  = $8024;
  GL_PROXY_HISTOGRAM            = $8025;
  GL_HISTOGRAM_WIDTH            = $8026;
  GL_HISTOGRAM_FORMAT           = $8027;
  GL_HISTOGRAM_RED_SIZE         = $8028;
  GL_HISTOGRAM_GREEN_SIZE       = $8029;
  GL_HISTOGRAM_BLUE_SIZE        = $802A;
  GL_HISTOGRAM_ALPHA_SIZE       = $802B;
  GL_HISTOGRAM_LUMINANCE_SIZE   = $802C;
  GL_HISTOGRAM_SINK             = $802D;
	GL_MINMAX                     = $802E;
	GL_MINMAX_FORMAT              = $802F;
	GL_MINMAX_SINK                = $8030;
	GL_TABLE_TOO_LARGE						= $8031;

// PROC PROTOTYPES
type PFNGLHISTOGRAMEXTPROC = procedure(target: GLenum; width: GLsizei;
  internalFmt: GLenum; sink: GLboolean); stdcall;
type PFNGLRESETHISTOGRAMEXTPROC = procedure(target: GLenum); stdcall;
type PFNGLGETHISTOGRAMEXTPROC = procedure(target: GLenum; reset: GLboolean;
  Fmt, dataType: GLenum; data: PGLvoid); stdcall;
type PFNGLGETHISTOGRAMPARAMETERIVEXTPROC = procedure(target, pname: GLenum;
  params: PGLint); stdcall;
type PFNGLGETHISTOGRAMPARAMETERIFEXTPROC = procedure(target, pname: GLenum; 
  params: PGLfloat); stdcall;
type PFNGLMINMAXEXTPROC = procedure(target, internalFmt: GLenum;
   sink: GLboolean); stdcall;
type PFNGLRESETMINMAXEXTPROC = procedure(target: GLenum); stdcall;
type PFNGLGETMINMAXEXTPROC = procedure(target: GLenum; reset: GLboolean;
  Fmt, dataType: GLenum; data: PGLvoid); stdcall;
type PFNGLGETMINMAXPARAMETERIVEXTPROC = procedure(target, pname: GLenum; 
  params: PGLint); stdcall;
type PFNGLGETMINMAXPARAMETERIFEXTPROC = procedure(target, pname: GLenum; 
  params: PGLfloat); stdcall;

// PROC VARIABLE POINTERS
var
  glHistogramEXT:               PFNGLHISTOGRAMEXTPROC;
  glResetHistogramEXT:          PFNGLRESETHISTOGRAMEXTPROC;
  glGetHistogramEXT:            PFNGLGETHISTOGRAMEXTPROC;
  glGetHistogramParameterivEXT: PFNGLGETHISTOGRAMPARAMETERIVEXTPROC;
  glGetHistogramParameterfvEXT: PFNGLGETHISTOGRAMPARAMETERIFEXTPROC;
  glMinmaxEXT:                  PFNGLMINMAXEXTPROC;
  glResetMinmaxEXT:             PFNGLRESETMINMAXEXTPROC;
  glGetMinmaxEXT:               PFNGLGETMINMAXEXTPROC;
  glGetMinmaxParameterivEXT:    PFNGLGETMINMAXPARAMETERIVEXTPROC;
  glGetMinmaxParameterfvEXT:    PFNGLGETMINMAXPARAMETERIFEXTPROC;
// End EXT Histogram ***********************************************************


// SGI Color matrix ************************************************************
{$DEFINE GL_SGI_color_matrix}
const
  GL_SGI_color_matrix_str = 'GL_SGI_color_matrix';
  //
  GL_COLOR_MATRIX		 	              = $80B1;
  GL_COLOR_MATRIX_STACK_DEPTH		    = $80B2;
  GL_MAX_COLOR_MATRIX_STACK_DEPTH	  = $80B3;
  GL_POST_COLOR_MATRIX_RED_SCALE	  = $80B4;
  GL_POST_COLOR_MATRIX_GREEN_SCALE  = $80B5;
  GL_POST_COLOR_MATRIX_BLUE_SCALE	  = $80B6;
  GL_POST_COLOR_MATRIX_ALPHA_SCALE  = $80B7;
  GL_POST_COLOR_MATRIX_RED_BIAS		  = $80B8;
  GL_POST_COLOR_MATRIX_GREEN_BIAS	  = $80B9;
  GL_POST_COLOR_MATRIX_BLUE_BIAS	  = $80BA;
  GL_POST_COLOR_MATRIX_ALPHA_BIAS	  = $80BB;

// End SGI Color matrix ********************************************************


// SGI Color table ****************************************************************
{$DEFINE GL_SGI_color_table}
const
  GL_SGI_color_table_str = 'GL_SGI_color_table';
  //
  GL_COLOR_TABLE					                = $80D0;
	GL_POST_CONVOLUTION_COLOR_TABLE		      = $80D1;
	GL_POST_COLOR_MATRIX_COLOR_TABLE		    = $80D2;
	GL_PROXY_COLOR_TABLE				            = $80D3;
	GL_PROXY_POST_CONVOLUTION_COLOR_TABLE	  = $80D4;
	GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE	= $80D5;
	GL_COLOR_TABLE_SCALE				            = $80D6;
	GL_COLOR_TABLE_BIAS				              = $80D7;
	GL_COLOR_TABLE_FORMAT				            = $80D8;
	GL_COLOR_TABLE_WIDTH				            = $80D9;
	GL_COLOR_TABLE_RED_SIZE			            = $80DA;
	GL_COLOR_TABLE_GREEN_SIZE			          = $80DB;
	GL_COLOR_TABLE_BLUE_SIZE			          = $80DC;
	GL_COLOR_TABLE_ALPHA_SIZE			          = $80DD;
	GL_COLOR_TABLE_LUMINANCE_SIZE			      = $80DE;
	GL_COLOR_TABLE_INTENSITY_SIZE			      = $80DF;

// PROC PROTOTYPES
type PFNGLCOLORTABLESGIPROC = procedure(target, internalFmt:
  GLenum; width: GLsizei; tblFmt, tblType: GLenum; const table: PGLvoid); stdcall;
type PFNGLCOPYCOLORTABLESGIPROC = procedure(target, internalFmt: GLenum;
  x, y: GLint; width: GLsizei); stdcall;
type PFNGLCOLORTABLEPARAMETERIVSGIPROC = procedure(target, pname: GLenum;
  const params: PGLint); stdcall;
type PFNGLCOLORTABLEPARAMETERIFSGIPROC = procedure(target, pname: GLenum;
  const params: PGLfloat); stdcall;
type PFNGLGETCOLORTABLESGIPROC = procedure(target, tblFmt, tblType: GLenum;
  table: PGLvoid); stdcall;
type PFNGLGETCOLORTABLEPARAMETERIVSGIPROC = procedure(target, pname: GLenum;
  params: PGLint); stdcall;
type PFNGLGETCOLORTABLEPARAMETERFVSGIPROC = procedure(target, pname: GLenum;
  params: PGLfloat); stdcall;

// PROC VARIABLE POINTERS
var                    
  glColorTableSGI:                PFNGLCOLORTABLESGIPROC;
  glCopyColorTableSGI:            PFNGLCOPYCOLORTABLESGIPROC;
  glColorTableParameterivSGI:     PFNGLCOLORTABLEPARAMETERIVSGIPROC;
  glColorTableParameterfvSGI:     PFNGLCOLORTABLEPARAMETERIFSGIPROC;
  glGetColorTableSGI:             PFNGLGETCOLORTABLESGIPROC;
  glGetColorTableParameterivSGI:  PFNGLGETCOLORTABLEPARAMETERIVSGIPROC;
  glGetColorTableParameterfvSGI:  PFNGLGETCOLORTABLEPARAMETERFVSGIPROC;
// End SGI Color table ************************************************************


// SGI Color subtable **********************************************************
{$DEFINE GL_EXT_color_subtable}
const
  GL_EXT_color_subtable_str = 'GL_EXT_color_subtable';

// PROC PROTOTYPES
type PFNGLCOLORSUBTABLEEXTPROC = procedure(target: GLenum; start, count: GLsizei;
  colorFmt, dataType: GLenum; const data: PGLvoid); stdcall;
type PFNGLCOPYCOLORSUBTABLEEXTPROC = procedure(target: GLenum; start: GLsizei;
  x, y: GLint; width: GLsizei); stdcall;

// PROC VARIABLE POINTERS
var
  glColorSubTableEXT:     PFNGLCOLORSUBTABLEEXTPROC;
  glCopyColorSubTableEXT: PFNGLCOPYCOLORSUBTABLEEXTPROC;
// End SGI Color subtable ******************************************************


// EXT Texture3D ****************************************************************
{$DEFINE GL_EXT_texture3D}
const
  GL_EXT_texture3D_str = 'GL_EXT_texture3D';
  //
  GL_PACK_SKIP_IMAGES             = $806B;
  GL_PACK_IMAGE_HEIGHT            = $806C;
  GL_UNPACK_SKIP_IMAGES           = $806D;
  GL_UNPACK_IMAGE_HEIGHT          = $806E;
  GL_TEXTURE_3D                   = $806F;
  GL_PROXY_TEXTURE_3D             = $8070;
  GL_TEXTURE_DEPTH                = $8071;
  GL_TEXTURE_WRAP_R               = $8072;
  GL_MAX_3D_TEXTURE_SIZE          = $8073;

// PROC PROTOTYPES
type PFNGLTEXIMAGE3DEXTPROC = procedure(target: GLenum; level: GLint;
  internalFmt: GLenum;
  width, height, depth: GLsizei; border: GLint; dataFmt, dataType: GLenum;
  const data: PGLvoid); stdcall;
type PFNGLTEXSUBIMAGE3DEXTPROC = procedure (target: GLenum;
  level, xOffset, yOffset, zOffset: GLint;
  width, height, depth: GLsizei; format, pixelType: GLenum;
  const pixels: PGLvoid); stdcall;
type PFNGLCOPYTEXSUBIMAGE3DEXTPROC = procedure (target: GLenum;
  level, xOffset, yOffset, zOffset, x, y: GLint;
  width, height: GLsizei); stdcall;

// PROC VARIABLE POINTERS
var
  glTexImage3DEXT:        PFNGLTEXIMAGE3DEXTPROC;
  glTexSubImage3DEXT:     PFNGLTEXSUBIMAGE3DEXTPROC;
  glCopyTexSubImage3DEXT: PFNGLCOPYTEXSUBIMAGE3DEXTPROC;

// End EXT Texture3D ***********************************************************


// EXT BGRA ********************************************************************
{$DEFINE GL_EXT_bgra}
const
  GL_EXT_bgra_str = 'GL_EXT_bgra';
  //
  GL_BGR    = $80E0;
  GL_BGRA   = $80E1;

// End EXT BGRA ****************************************************************


// EXT Packed pixels ***********************************************************
{$DEFINE GL_EXT_packed_pixels}
const
  GL_EXT_packed_pixels_str = 'GL_EXT_packed_pixels';
  //
  GL_UNSIGNED_BYTE_3_3_2      = $8032;
  GL_UNSIGNED_SHORT_4_4_4_4   = $8033;
  GL_UNSIGNED_SHORT_5_5_5_1   = $8034;
  GL_UNSIGNED_INT_8_8_8_8     = $8035;
  GL_UNSIGNED_INT_10_10_10_2  = $8036;

// End EXT Packed pixels *******************************************************


// EXT Rescale normal **********************************************************
{$DEFINE GL_EXT_rescale_normal}
const
  GL_EXT_rescale_normal_str = 'GL_EXT_rescale_normal';
  //
  GL_RESCALE_NORMAL   = $803A;

// End EXT Rescale normal ******************************************************


// EXT Separate specular color *************************************************
{$DEFINE GL_EXT_separate_specular_color}
const
  GL_EXT_separate_specular_color_str = 'GL_EXT_separate_specular_color';
  //
  GL_LIGHT_MODEL_COLOR_CONTROL  = $81F8;
  GL_SINGLE_COLOR               = $81F9;
  GL_SEPARATE_SPECULAR_COLOR    = $81FA;

// End EXT Separate specular color *********************************************


// EXT Clamp to edge **********************************************************
{$DEFINE GL_EXT_texture_edge_clamp_str}
const
  GL_EXT_texture_edge_clamp_str = 'GL_EXT_texture_edge_clamp';
  //
  GL_CLAMP_TO_EDGE  = $812F;

// End SGIS Clamp to edge ******************************************************


// SGIS Texture LOD ************************************************************
{$DEFINE GL_SGIS_texture_lod}
const
  GL_SGIS_texture_lod_str = 'GL_SGIS_texture_lod';
  //
  GL_TEXTURE_MIN_LOD          = $813A;
  GL_TEXTURE_MAX_LOD          = $813B;
  GL_TEXTURE_BASE_LEVEL_LOD   = $813C;
  GL_TEXTURE_MAX_LEVEL_LOD    = $813D;

// End SGIS Texture LOD ********************************************************


// EXT Draw range elements *****************************************************
{$DEFINE GL_EXT_draw_range_elements}
const
  GL_EXT_draw_range_elements_str = 'GL_EXT_draw_range_elements';
  //
  GL_MAX_ELEMENTS_VERTICES  = $80E8;
  GL_MAX_ELEMENTS_INDICES   = $80E9;

// PROC PROTOTYPES
type PFNGLDRAWRANGEELEMENTSEXTPROC = procedure(
    mode: GLenum;
    startIndex, endIndex: GLuint;
    count: GLsizei;
    indexType: GLenum;
    const indices: PGLvoid
  ); stdcall;

// PROC VARIABLE POINTERS
var
  glDrawRangeElementsEXT: PFNGLDRAWRANGEELEMENTSEXTPROC;
// End EXT Draw range elements *************************************************


// SUN Convolution border modes ************************************************
{$DEFINE GL_SUN_convolution_border_modes}
const
  GL_SUN_convolution_border_modes_str = 'GL_SUN_convolution_border_modes';
  //
  GL_WRAP_BORDER = $81D4;
  
// End SUN Convolution border modes ********************************************


// EXT Convolution *************************************************************
{$DEFINE GL_EXT_convolution}
const
  GL_EXT_convolution_str = 'GL_EXT_convolution';
  //
  GL_CONVOLUTION_1D               = $8010;
  GL_CONVOLUTION_2D               = $8011;
  GL_SEPARABLE_2D                 = $8012;
  GL_CONVOLUTION_BORDER_MODE      = $8013;
  GL_CONVOLUTION_FILTER_SCALE     = $8014;
  GL_CONVOLUTION_FILTER_BIAS      = $8015;
  GL_REDUCE                       = $8016;
  GL_CONVOLUTION_FORMAT           = $8017;
  GL_CONVOLUTION_WIDTH            = $8018;
  GL_CONVOLUTION_HEIGHT           = $8019;
  GL_MAX_CONVOLUTION_WIDTH        = $801A;
  GL_MAX_CONVOLUTION_HEIGHT       = $801B;
  GL_POST_CONVOLUTION_RED_SCALE   = $801C;
  GL_POST_CONVOLUTION_GREEN_SCALE = $801D;
  GL_POST_CONVOLUTION_BLUE_SCALE  = $801E;
  GL_POST_CONVOLUTION_ALPHA_SCALE = $801F;
  GL_POST_CONVOLUTION_RED_BIAS    = $8020;
  GL_POST_CONVOLUTION_GREEN_BIAS  = $8021;
  GL_POST_CONVOLUTION_BLUE_BIAS   = $8022;
  GL_POST_CONVOLUTION_ALPHA_BIAS  = $8023;
  
// PROC PROTOTYPES
type PFNGLCONVOLUTIONFILTER1DEXTPROC = procedure(target, internalFmt: GLenum;
  width: GLsizei; dataFmt, dataType: GLenum;
  const image: PGLvoid); stdcall;
type PFNGLCONVOLUTIONFILTER2DEXTPROC = procedure(target, internalFmt: GLenum;
  width, height: GLsizei; dataFmt, dataType: GLenum;
  const image: PGLvoid); stdcall;
type PFNGLCOPYCONVOLUTIONFILTER1DEXTPROC = procedure(target, internalFmt: GLenum;
  x, y: GLint; width: GLsizei); stdcall;
type PFNGLCOPYCONVOLUTIONFILTER2DEXTPROC = procedure(target, internalFmt: GLenum;
  x, y: GLint; width, height: GLsizei); stdcall;
type PFNGLGETCONVOLUTIONFILTEREXTPROC = procedure(target, dataFmt, dataType: GLenum;
  image: PGLvoid); stdcall;
type PFNGLSEPARABLEFILTER2DEXTPROC = procedure(target, internalFmt: GLenum;
  width, height: GLsizei; dataFmt, dataType: GLenum;
  const row, column: PGLvoid); stdcall;
type PFNGLGETSEPARABLEFILTEREXTPROC = procedure(target, dataFmt, dataType: GLenum;
  row, column, span: PGLvoid); stdcall;
type PFNGLCONVOLUTIONPARAMETERIEXTPROC = procedure(target, pname: GLenum;
  param: GLint); stdcall;
type PFNGLCONVOLUTIONPARAMETERIVEXTPROC = procedure(target, pname: GLenum;
const params: PGLint); stdcall;
type PFNGLCONVOLUTIONPARAMETERFEXTPROC = procedure(target, pname: GLenum;
  param: GLfloat); stdcall;
type PFNGLCONVOLUTIONPARAMETERFVEXTPROC = procedure(target, pname: GLenum;
  const params: PGLfloat); stdcall;
type PFNGLGETCONVOLUTIONPARAMETERIVEXTPROC = procedure(target, pname: GLenum;
  params: PGLint); stdcall;
type PFNGLGETCONVOLUTIONPARAMETERFVEXTPROC = procedure(target, pname: GLenum;
  params: PGLfloat); stdcall;

// PROC VARIABLE POINTERS
var
  glConvolutionFilter1DEXT:       PFNGLCONVOLUTIONFILTER1DEXTPROC;
  glConvolutionFilter2DEXT:       PFNGLCONVOLUTIONFILTER2DEXTPROC;
  glCopyConvolutionFilter1DEXT:   PFNGLCOPYCONVOLUTIONFILTER1DEXTPROC;
  glCopyConvolutionFilter2DEXT:   PFNGLCOPYCONVOLUTIONFILTER2DEXTPROC;
  glGetConvolutionFilterEXT:      PFNGLGETCONVOLUTIONFILTEREXTPROC;
  glSeparableFilter2DEXT:         PFNGLSEPARABLEFILTER2DEXTPROC;
  glGetSeparableFilterEXT:        PFNGLGETSEPARABLEFILTEREXTPROC;
  glConvolutionParameteriEXT:     PFNGLCONVOLUTIONPARAMETERIEXTPROC;
  glConvolutionParameterivEXT:    PFNGLCONVOLUTIONPARAMETERIVEXTPROC;
  glConvolutionParameterfEXT:     PFNGLCONVOLUTIONPARAMETERFEXTPROC;
  glConvolutionParameterfvEXT:    PFNGLCONVOLUTIONPARAMETERFVEXTPROC;
  glGetConvolutionParameterivEXT: PFNGLGETCONVOLUTIONPARAMETERIVEXTPROC;
  glGetConvolutionParameterfvEXT: PFNGLGETCONVOLUTIONPARAMETERFVEXTPROC;
// End EXT Convolution *********************************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 1.3 Extensions    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_1_3}


// ARB Texture Compression *****************************************************
{$DEFINE GL_ARB_texture_compression}
const
  GL_ARB_texture_compression_str = 'GL_ARB_texture_compression';
  //
  GL_COMPRESSED_ALPHA                 = $84E9;
	GL_COMPRESSED_LUMINANCE             = $84EA;
	GL_COMPRESSED_LUMINANCE_ALPHA       = $84EB;
	GL_COMPRESSED_INTENSITY             = $84EC;
	GL_COMPRESSED_RGB                   = $84ED;
	GL_COMPRESSED_RGBA                  = $84EE;
	GL_TEXTURE_COMPRESSION_HINT         = $84EF;
	GL_TEXTURE_COMPRESSED_IMAGE_SIZE    = $86A0;
	GL_TEXTURE_COMPRESSED               = $86A1;
	GL_NUM_COMPRESSED_TEXTURE_FORMATS   = $86A2;
	GL_COMPRESSED_TEXTURE_FORMATS       = $86A3;

// PROC PROTOTYPES
type PFNGLCOMPRESSEDTEXIMAGE3DARBPROC = procedure(target: GLenum; level: GLint;
  internalFmt: GLenum; width, height, depth: GLsizei; border: GLint;
  imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDTEXIMAGE2DARBPROC = procedure(target: GLenum; level: GLint;
  internalFmt: GLenum; width, height: GLsizei; border: GLint; imageSize: GLsizei;
  const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDTEXIMAGE1DARBPROC = procedure(target: GLenum; level: GLint;
  internalFmt: GLenum; width: GLsizei; border: GLint; imageSize: GLsizei;
  const data: PGLvoid); stdcall;

type PFNGLCOMPRESSEDTEXSUBIMAGE3DARBPROC = procedure(target: GLenum; level: GLint;
  xOffset, yOffset, zOffset: GLint; width, height, depth: GLsizei; Fmt: GLenum;
  imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDTEXSUBIMAGE2DARBPROC = procedure(target: GLenum; level: GLint;
  xOffset, yOffset: GLint; width, height: GLsizei; Fmt: GLenum; imageSize: GLsizei;
  const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDTEXSUBIMAGE1DARBPROC = procedure(target: GLenum; level: GLint;
  xOffset: GLint; width: GLsizei; Fmt: GLenum; imageSize: GLsizei;
    const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDTEXIMAGEARBPROC = procedure(target: GLenum; lod: GLint;
  img: PGLvoid); stdcall;

// PROC VARIABLE POINTERS
var
  glCompressedTexImage3DARB:    PFNGLCOMPRESSEDTEXIMAGE3DARBPROC;
  glCompressedTexImage2DARB:    PFNGLCOMPRESSEDTEXIMAGE2DARBPROC;
  glCompressedTexImage1DARB:    PFNGLCOMPRESSEDTEXIMAGE1DARBPROC;
  glCompressedTexSubImage3DARB: PFNGLCOMPRESSEDTEXSUBIMAGE3DARBPROC;
  glCompressedTexSubImage2DARB: PFNGLCOMPRESSEDTEXSUBIMAGE2DARBPROC;
  glCompressedTexSubImage1DARB: PFNGLCOMPRESSEDTEXSUBIMAGE1DARBPROC;
  glGetCompressedTexImageARB:   PFNGLCOMPRESSEDTEXIMAGEARBPROC;
// End ARB Texture Compression *************************************************


// ARB Texture Cubemap *********************************************************
{$DEFINE GL_ARB_texture_cube_map}
const
  GL_ARB_texture_cube_map_str = 'GL_ARB_texture_cube_map';
  //
  GL_NORMAL_MAP                      = $8511;
	GL_REFLECTION_MAP                  = $8512;
  GL_TEXTURE_CUBE_MAP                = $8513;
  GL_TEXTURE_BINDING_CUBE_MAP        = $8514;
  GL_TEXTURE_CUBE_MAP_POSITIVE_X     = $8515;
  GL_TEXTURE_CUBE_MAP_NEGATIVE_X     = $8516;
  GL_TEXTURE_CUBE_MAP_POSITIVE_Y     = $8517;
  GL_TEXTURE_CUBE_MAP_NEGATIVE_Y     = $8518;
  GL_TEXTURE_CUBE_MAP_POSITIVE_Z     = $8519;
  GL_TEXTURE_CUBE_MAP_NEGATIVE_Z     = $851A;
  GL_PROXY_TEXTURE_CUBE_MAP          = $851B;
  GL_MAX_CUBE_MAP_TEXTURE_SIZE       = $851C;

// End ARB Texture Cubemap *****************************************************


// ARB Clamp to Border *********************************************************
{$DEFINE GL_ARB_texture_border_clamp}
const
  GL_ARB_texture_border_clamp_str = 'GL_ARB_texture_border_clamp';
  //
  GL_CLAMP_TO_BORDER  = $812D;

// End ARB Clamp to Border *****************************************************


// ARB Texture env dot3 ********************************************************
{$DEFINE GL_ARB_texture_env_dot3}
const
  GL_ARB_texture_env_dot3_str = 'GL_ARB_texture_env_dot3';
  //
  GL_DOT3_RGB   = $86AE;
  GL_DOT3_RGBA  = $86AF;

// End ARB Texture env dot3 ****************************************************


// ARB Texture env add *********************************************************
{$DEFINE GL_ARB_texture_env_add}
const
  GL_ARB_texture_env_add_str = 'GL_ARB_texture_env_add';
  //
  GL_ADD  = $0104;

// End ARB Texture env add *****************************************************


// ARB Texture env combine *****************************************************
{$DEFINE GL_ARB_texture_env_combine}
const
  GL_ARB_texture_env_combine_str = 'GL_ARB_texture_env_combine';
  //
  GL_COMBINE                        = $8570;
  GL_COMBINE_RGB                    = $8571;
  GL_COMBINE_ALPHA                  = $8572;
  GL_SOURCE0_RGB                    = $8580;
  GL_SOURCE1_RGB                    = $8581;
  GL_SOURCE2_RGB                    = $8582;
  GL_SOURCE0_ALPHA                  = $8588;
  GL_SOURCE1_ALPHA                  = $8589;
  GL_SOURCE2_ALPHA                  = $858A;
  GL_OPERAND0_RGB                   = $8590;
  GL_OPERAND1_RGB                   = $8591;
  GL_OPERAND2_RGB                   = $8592;
  GL_OPERAND0_ALPHA                 = $8598;
  GL_OPERAND1_ALPHA                 = $8599;
  GL_OPERAND2_ALPHA                 = $859A;
  GL_RGB_SCALE                      = $8573;
  GL_ADD_SIGNED                     = $8574;
  GL_INTERPOLATE                    = $8575;
  GL_SUBTRACT                       = $84E7;
  GL_CONSTANT                       = $8576;
  GL_PRIMARY_COLOR                  = $8577;
  GL_PREVIOUS                       = $8578;

// End ARB Texture env combine *************************************************


// ARB Transpose matrix ********************************************************
{$DEFINE GL_ARB_transpose_matrix}
const
  GL_ARB_transpose_matrix_str = 'GL_ARB_transpose_matrix';
  //
  GL_TRANSPOSE_MODELVIEW_MATRIX   = $84E3;
  GL_TRANSPOSE_PROJECTION_MATRIX  = $84E4;
  GL_TRANSPOSE_TEXTURE_MATRIX     = $84E5;
  GL_TRANSPOSE_COLOR_MATRIX       = $84E6;

// PROC PROTOTYPES
type PFNGLLOADTRANSPOSEMATRIXFARBPROC = procedure(const mat4x4: PGLfloat); stdcall;
type PFNGLLOADTRANSPOSEMATRIXDARBPROC = procedure(const mat4x4: PGLdouble); stdcall;
type PFNGLMULTTRANSPOSEMATRIXFARBPROC = procedure(const mat4x4: PGLfloat); stdcall;
type PFNGLMULTTRANSPOSEMATRIXDARBPROC = procedure(const mat4x4: PGLdouble); stdcall;

// PROC VARIABLE POINTERS
var
  glLoadTransposeMatrixdARB:  PFNGLLOADTRANSPOSEMATRIXDARBPROC;
  glLoadTransposeMatrixfARB:  PFNGLLOADTRANSPOSEMATRIXFARBPROC;
  glMultTransposeMatrixdARB:  PFNGLMULTTRANSPOSEMATRIXDARBPROC;
  glMultTransposeMatrixfARB:  PFNGLMULTTRANSPOSEMATRIXFARBPROC;
// End ARB Transpose matrix ****************************************************


// ARB Multy textures **********************************************************
{$DEFINE GL_ARB_multitexture}
const
  GL_ARB_multitexture_str = 'GL_ARB_multitexture';
  //
  GL_TEXTURE0                       = $84C0;
  GL_TEXTURE1                       = $84C1;
  GL_TEXTURE2                       = $84C2;
  GL_TEXTURE3                       = $84C3;
  GL_TEXTURE4                       = $84C4;
  GL_TEXTURE5                       = $84C5;
  GL_TEXTURE6                       = $84C6;
  GL_TEXTURE7                       = $84C7;
  GL_TEXTURE8                       = $84C8;
  GL_TEXTURE9                       = $84C9;
  GL_TEXTURE10                      = $84CA;
  GL_TEXTURE11                      = $84CB;
  GL_TEXTURE12                      = $84CC;
  GL_TEXTURE13                      = $84CD;
  GL_TEXTURE14                      = $84CE;
  GL_TEXTURE15                      = $84CF;
  GL_TEXTURE16                      = $84D0;
  GL_TEXTURE17                      = $84D1;
  GL_TEXTURE18                      = $84D2;
  GL_TEXTURE19                      = $84D3;
  GL_TEXTURE20                      = $84D4;
  GL_TEXTURE21                      = $84D5;
  GL_TEXTURE22                      = $84D6;
  GL_TEXTURE23                      = $84D7;
  GL_TEXTURE24                      = $84D8;
  GL_TEXTURE25                      = $84D9;
  GL_TEXTURE26                      = $84DA;
  GL_TEXTURE27                      = $84DB;
  GL_TEXTURE28                      = $84DC;
  GL_TEXTURE29                      = $84DD;
  GL_TEXTURE30                      = $84DE;
  GL_TEXTURE31                      = $84DF;
  GL_ACTIVE_TEXTURE                 = $84E0;
  GL_CLIENT_ACTIVE_TEXTURE          = $84E1;
  GL_MAX_TEXTURE_UNITS              = $84E2;

// PROC PROTOTYPES
type PFNACTIVETEXTUREARBPROC = procedure(texture: GLenum); stdcall;
type PFNCLIENTACTIVETEXTUREARBPROC = procedure(texture: GLenum); stdcall;
type PFNMULTITEXCOORD1SARBPROC = procedure(target: GLenum; 
  s: GLshort); stdcall;
type PFNMULTITEXCOORD2SARBPROC = procedure(target: GLenum; 
  s, t: GLshort); stdcall;
type PFNMULTITEXCOORD3SARBPROC = procedure(target: GLenum; 
  s, t, r: GLshort); stdcall;
type PFNMULTITEXCOORD4SARBPROC = procedure(target: GLenum; 
  s, t, r, q: GLshort); stdcall;
type PFNMULTITEXCOORD1IARBPROC = procedure(target: GLenum; 
  s: GLint); stdcall;
type PFNMULTITEXCOORD2IARBPROC = procedure(target: GLenum; 
  s, t: GLint); stdcall;
type PFNMULTITEXCOORD3IARBPROC = procedure(target: GLenum; 
  s, t, r: GLint); stdcall;
type PFNMULTITEXCOORD4IARBPROC = procedure(target: GLenum; 
  s, t, r, q: GLint); stdcall;
type PFNMULTITEXCOORD1FARBPROC = procedure(target: GLenum; 
  s: GLfloat); stdcall;
type PFNMULTITEXCOORD2FARBPROC = procedure(target: GLenum; 
  s, t: GLfloat); stdcall;
type PFNMULTITEXCOORD3FARBPROC = procedure(target: GLenum; 
  s, t, r: GLfloat) stdcall;
type PFNMULTITEXCOORD4FARBPROC = procedure(target: GLenum; 
  s, t, r, q: GLfloat); stdcall;
type PFNMULTITEXCOORD1DARBPROC = procedure(target: GLenum; 
  s: GLdouble); stdcall;
type PFNMULTITEXCOORD2DARBPROC = procedure(target: GLenum; 
  s, t: GLdouble); stdcall;
type PFNMULTITEXCOORD3DARBPROC = procedure(target: GLenum; 
  s, t, r: GLdouble); stdcall;
type PFNMULTITEXCOORD4DARBPROC = procedure(target: GLenum; 
  s, t, r, q: GLdouble); stdcall;
type PFNMULTITEXCOORD1SVARBPROC = procedure(target: GLenum; 
  vs1: PGLshort); stdcall;
type PFNMULTITEXCOORD2SVARBPROC = procedure(target: GLenum; 
  vs2: PGLshort); stdcall;
type PFNMULTITEXCOORD3SVARBPROC = procedure(target: GLenum; 
  vs3: PGLshort); stdcall;
type PFNMULTITEXCOORD4SVARBPROC = procedure(target: GLenum; 
  vs4: PGLshort); stdcall;
type PFNMULTITEXCOORD1IVARBPROC = procedure(target: GLenum; 
  vi1: PGLint); stdcall;
type PFNMULTITEXCOORD2IVARBPROC = procedure(target: GLenum; 
  vi2: PGLint); stdcall;
type PFNMULTITEXCOORD3IVARBPROC = procedure(target: GLenum; 
  vi3: PGLint); stdcall;
type PFNMULTITEXCOORD4IVARBPROC = procedure(target: GLenum; 
  vi4: PGLint); stdcall;
type PFNMULTITEXCOORD1FVARBPROC = procedure(target: GLenum; 
  vf1: PGLfloat); stdcall;
type PFNMULTITEXCOORD2FVARBPROC = procedure(target: GLenum; 
  vf2: PGLfloat); stdcall;
type PFNMULTITEXCOORD3FVARBPROC = procedure(target: GLenum; 
  vf3: PGLfloat); stdcall;
type PFNMULTITEXCOORD4FVARBPROC = procedure(target: GLenum; 
  vf4: PGLfloat); stdcall;
type PFNMULTITEXCOORD1DVARBPROC = procedure(target: GLenum; 
  vd1: PGLdouble); stdcall;
type PFNMULTITEXCOORD2DVARBPROC = procedure(target: GLenum; 
  vd2: PGLdouble); stdcall;
type PFNMULTITEXCOORD3DVARBPROC = procedure(target: GLenum; 
  vd3: PGLdouble); stdcall;
type PFNMULTITEXCOORD4DVARBPROC = procedure(target: GLenum; 
  vd4: PGLdouble); stdcall;

// PROC VARIABLE POINTERS
var
  glActiveTextureARB:        PFNACTIVETEXTUREARBPROC;
  glClientActiveTextureARB:  PFNCLIENTACTIVETEXTUREARBPROC;
  glMultiTexCoord1sARB:      PFNMULTITEXCOORD1SARBPROC;
  glMultiTexCoord2sARB:      PFNMULTITEXCOORD2SARBPROC;
  glMultiTexCoord3sARB:      PFNMULTITEXCOORD3SARBPROC;
  glMultiTexCoord4sARB:      PFNMULTITEXCOORD4SARBPROC;
  glMultiTexCoord1iARB:      PFNMULTITEXCOORD1IARBPROC;
  glMultiTexCoord2iARB:      PFNMULTITEXCOORD2IARBPROC;
  glMultiTexCoord3iARB:      PFNMULTITEXCOORD3IARBPROC;
  glMultiTexCoord4iARB:      PFNMULTITEXCOORD4IARBPROC;
  glMultiTexCoord1fARB:      PFNMULTITEXCOORD1FARBPROC;
  glMultiTexCoord2fARB:      PFNMULTITEXCOORD2FARBPROC;
  glMultiTexCoord3fARB:      PFNMULTITEXCOORD3FARBPROC;
  glMultiTexCoord4fARB:      PFNMULTITEXCOORD4FARBPROC;
  glMultiTexCoord1dARB:      PFNMULTITEXCOORD1DARBPROC;
  glMultiTexCoord2dARB:      PFNMULTITEXCOORD2DARBPROC;
  glMultiTexCoord3dARB:      PFNMULTITEXCOORD3DARBPROC;
  glMultiTexCoord4dARB:      PFNMULTITEXCOORD4DARBPROC;
  glMultiTexCoord1svARB:     PFNMULTITEXCOORD1SVARBPROC;
  glMultiTexCoord2svARB:     PFNMULTITEXCOORD2SVARBPROC;
  glMultiTexCoord3svARB:     PFNMULTITEXCOORD3SVARBPROC;
  glMultiTexCoord4svARB:     PFNMULTITEXCOORD4SVARBPROC;
  glMultiTexCoord1ivARB:     PFNMULTITEXCOORD1IVARBPROC;
  glMultiTexCoord2ivARB:     PFNMULTITEXCOORD2IVARBPROC;
  glMultiTexCoord3ivARB:     PFNMULTITEXCOORD3IVARBPROC;
  glMultiTexCoord4ivARB:     PFNMULTITEXCOORD4IVARBPROC;
  glMultiTexCoord1fvARB:     PFNMULTITEXCOORD1FVARBPROC;
  glMultiTexCoord2fvARB:     PFNMULTITEXCOORD2FVARBPROC;
  glMultiTexCoord3fvARB:     PFNMULTITEXCOORD3FVARBPROC;
  glMultiTexCoord4fvARB:     PFNMULTITEXCOORD4FVARBPROC;
  glMultiTexCoord1dvARB:     PFNMULTITEXCOORD1DVARBPROC;
  glMultiTexCoord2dvARB:     PFNMULTITEXCOORD2DVARBPROC;
  glMultiTexCoord3dvARB:     PFNMULTITEXCOORD3DVARBPROC;
  glMultiTexCoord4dvARB:     PFNMULTITEXCOORD4DVARBPROC;
// End ARB Multy textures ******************************************************


// ARB Multysample *************************************************************
{$DEFINE GL_ARB_multisample}
{$DEFINE GLX_ARB_multisample}
{$DEFINE WGL_ARB_multisample}
const
  GL_ARB_multisample_str  = 'GL_ARB_multisample';
  GLX_ARB_multisample_str = 'GLX_ARB_multisample';
  WGL_ARB_multisample_str = 'WGL_ARB_multisample';
  //
	GL_MULTISAMPLE_ARB            = $809D;
  GL_SAMPLE_BUFFERS_ARB         = $80A8;
  GL_SAMPLES_ARB                = $80A9;
	GLX_SAMPLE_BUFFERS_ARB        = 100000;
  GLX_SAMPLES_ARB               = 100001;
	WGL_SAMPLE_BUFFERS_ARB        = $2041;
  WGL_SAMPLES_ARB               = $2042;
	MULTISAMPLE_ARB               = $809D;
  SAMPLE_ALPHA_TO_COVERAGE_ARB  = $809E;
  SAMPLE_ALPHA_TO_ONE_ARB       = $809F;
  SAMPLE_COVERAGE_ARB           = $80A0;
	MULTISAMPLE_BIT_ARB           = $20000000;
  SAMPLE_COVERAGE_VALUE_ARB     = $80AA;
  SAMPLE_COVERAGE_INVERT_ARB    = $80AB;

// PROC PROTOTYPES
type PFNGLSAMPLECOVERAGEARBPROC = procedure(value: GLclampf; 
  invert: GLboolean); stdcall;

// PROC VARIABLE POINTERS
var
  glSampleCoverageARB: PFNGLSAMPLECOVERAGEARBPROC;
// End ARB Multysample *********************************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 1.4 Extensions    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_1_4}


// ARB Texture mirrored repeat *************************************************
{$DEFINE GL_ARB_texture_mirrored_repeat}
const
  GL_ARB_texture_mirrored_repeat_str = 'GL_ARB_texture_mirrored_repeat';
  //
  GL_MIRRORED_REPEAT = $8370;

// End ARB Texture mirrored repeat *********************************************


// EXT Texture lod bais ********************************************************
{$DEFINE GL_EXT_texture_lod_bias}
const
  GL_EXT_texture_lod_bias_str = 'GL_EXT_texture_lod_bias';
  //
  GL_TEXTURE_FILTER_CONTROL   = $8500;
  GL_TEXTURE_LOD_BIAS         = $8501;
  GL_MAX_TEXTURE_LOD_BIAS     = $84FD;

// End EXT Texture lod bais ****************************************************


// ARB WindowPos ***************************************************************
{$DEFINE GL_ARB_window_pos}
const
  GL_ARB_window_pos_str = 'GL_ARB_window_pos';

// PROC PROTOTYPES
type PFNGLWINDOWPOS2SARBPROC  = procedure(x, y: GLshort); stdcall;
type PFNGLWINDOWPOS2IARBPROC  = procedure(x, y: GLshort); stdcall;
type PFNGLWINDOWPOS2FARBPROC  = procedure(x, y: GLshort); stdcall;
type PFNGLWINDOWPOS2DARBPROC  = procedure(x, y: GLshort); stdcall;
type PFNGLWINDOWPOS2SVARBPROC = procedure(const v: PGLshort); stdcall;
type PFNGLWINDOWPOS2IVARBPROC = procedure(const v: PGLint); stdcall;
type PFNGLWINDOWPOS2FVARBPROC = procedure(const v: PGLfloat); stdcall;
type PFNGLWINDOWPOS2DVARBPROC = procedure(const v: PGLdouble); stdcall;
type PFNGLWINDOWPOS3SARBPROC  = procedure(x, y, z: GLshort); stdcall;
type PFNGLWINDOWPOS3IARBPROC  = procedure(x, y, z: GLshort); stdcall;
type PFNGLWINDOWPOS3FARBPROC  = procedure(x, y, z: GLshort); stdcall;
type PFNGLWINDOWPOS3DARBPROC  = procedure(x, y, z: GLshort); stdcall;
type PFNGLWINDOWPOS3SVARBPROC = procedure(const v: PGLshort); stdcall;
type PFNGLWINDOWPOS3IVARBPROC = procedure(const v: PGLint); stdcall;
type PFNGLWINDOWPOS3FVARBPROC = procedure(const v: PGLfloat); stdcall;
type PFNGLWINDOWPOS3DVARBPROC = procedure(const v: PGLdouble); stdcall;

// PROC VARIABLE POINTERS
var
  glWindowPos2sARB:   PFNGLWINDOWPOS2SARBPROC;
  glWindowPos2iARB:   PFNGLWINDOWPOS2IARBPROC;
  glWindowPos2fARB:   PFNGLWINDOWPOS2FARBPROC;
  glWindowPos2dARB:   PFNGLWINDOWPOS2DARBPROC;
  glWindowPos2svARB:  PFNGLWINDOWPOS2SVARBPROC;
  glWindowPos2ivARB:  PFNGLWINDOWPOS2IVARBPROC;
  glWindowPos2fvARB:  PFNGLWINDOWPOS2FVARBPROC;
  glWindowPos2dvARB:  PFNGLWINDOWPOS2DVARBPROC;
  glWindowPos3sARB:   PFNGLWINDOWPOS3SARBPROC;
  glWindowPos3iARB:   PFNGLWINDOWPOS3IARBPROC;
  glWindowPos3fARB:   PFNGLWINDOWPOS3FARBPROC;
  glWindowPos3dARB:   PFNGLWINDOWPOS3DARBPROC;
  glWindowPos3svARB:  PFNGLWINDOWPOS3SVARBPROC;
  glWindowPos3ivARB:  PFNGLWINDOWPOS3IVARBPROC;
  glWindowPos3fvARB:  PFNGLWINDOWPOS3FVARBPROC;
  glWindowPos3dvARB:  PFNGLWINDOWPOS3DVARBPROC;
// End ARB WindowPos ***********************************************************


// EXT Stencil wrap ************************************************************
{$DEFINE GL_EXT_stencil_wrap}
const
  GL_EXT_stencil_wrap_str = 'GL_EXT_stencil_wrap';
  //
  GL_NCR_WRAP   = $8507;
  GL_DECR_WRAP  = $8508;

// End EXT Stencil wrap ********************************************************


// EXT Blend func separate *****************************************************
{$DEFINE GL_EXT_blend_func_separate}
const
  GL_EXT_blend_func_separate_str = 'GL_EXT_blend_func_separate';
  //
  GL_BLEND_DST_RGB    = $80C8;
  GL_BLEND_SRC_RGB    = $80C9;
  GL_BLEND_DST_ALPHA  = $80CA;
  GL_BLEND_SRC_ALPHA  = $80CB;

// PROC PROTOTYPES
type PFNGLBLENDFUNCSEPARATEEXTPROC = procedure(
  sfactorRGB, dfactorRGB, sfactorAlpha, dfactorestAlpha: GLenum); stdcall;

// PROC VARIABLE POINTERS
var
  glBlendFuncSeparateEXT: PFNGLBLENDFUNCSEPARATEEXTPROC;
// End EXT Blend func separate *************************************************


// ARB Generate mipmap *********************************************************
{$DEFINE GL_SGIS_generate_mipmap}
const
  GL_SGIS_generate_mipmap_str = 'GL_SGIS_generate_mipmap';
  //
  GENERATE_MIPMAP       = $8191;
  GENERATE_MIPMAP_HINT  = $8192;

// End ARB Generate mipmap *****************************************************


// EXT Multi draw arrays *******************************************************
{$DEFINE GL_EXT_multi_draw_arrays}
{$DEFINE GL_SUN_multi_draw_arrays}
const
  GL_EXT_multi_draw_arrays_str = 'GL_EXT_multi_draw_arrays';
  GL_SUN_multi_draw_arrays_str = 'GL_SUN_multi_draw_arrays';

// PROC PROTOTYPES
type PFNGLMULTYDRAWARRAYSEXTPROC = procedure(mode: GLenum; const vFirst: PGLint;
  const vCount: PGLsizei; primcount: GLsizei); stdcall;
type PFNGLMULTYDRAWELEMENTSEXTPROC = procedure(mode: GLenum; const vCount: PGLsizei;
  primType: GLenum; const vIndecies: PPGLvoid; primcount: GLsizei); stdcall;

// PROC VARIABLE POINTERS
var
  glMultiDrawArraysEXT:   PFNGLMULTYDRAWARRAYSEXTPROC;
  glMultiDrawElementsEXT: PFNGLMULTYDRAWELEMENTSEXTPROC;
// End EXT Multi draw arrays ***************************************************


// ARB Shadow ******************************************************************
{$DEFINE GL_ARB_shadow}
const
  GL_ARB_shadow_str = 'GL_ARB_shadow';
  //
  GL_TEXTURE_COMPARE_MODE = $884C;
  GL_TEXTURE_COMPARE_FUNC = $884D;
  GL_COMPARE_R_TO_TEXTURE = $884E;

// End ARB Shadow **************************************************************


// ARB Depth texture ***********************************************************
{$DEFINE GL_ARB_depth_texture}
const
  GL_ARB_depth_texture_str = 'GL_ARB_depth_texture';
  //
  GL_DEPTH_COMPONENT    = $1902;
  GL_DEPTH_COMPONENT16  = $81A5;
  GL_DEPTH_COMPONENT24  = $81A6;
  GL_DEPTH_COMPONENT32  = $81A7;
  GL_TEXTURE_DEPTH_SIZE = $884A;
  GL_DEPTH_TEXTURE_MODE = $884B;

// End ARB Depth texture *******************************************************


// ARB Point parameters ********************************************************
{$DEFINE GL_ARB_point_parameters}
const
  GL_ARB_point_parameters_str = 'GL_ARB_point_parameters';
  //
  GL_POINT_SIZE_MIN             = $8126;
  GL_POINT_SIZE_MAX             = $8127;
  GL_POINT_FADE_THRESHOLD_SIZE  = $8128;
  GL_POINT_DISTANCE_ATTENUATION = $8129;

// PROC PROTOTYPES
type PFNGLPOINTPARAMETERFARBPROC = procedure(pname: GLenum; 
  param: GLfloat); stdcall;
type PFNGLPOINTPARAMETERFVARBPROC = procedure(pname: GLenum; 
  const param: PGLfloat); stdcall;

// PROC VARIABLE POINTERS
var
  glPointParameterfARB:   PFNGLPOINTPARAMETERFARBPROC;
  glPointParameterfvARB:  PFNGLPOINTPARAMETERFVARBPROC;
// End ARB Point parameters ****************************************************


// EXT Fog coord ***************************************************************
{$DEFINE GL_EXT_fog_coord}
const
  GL_EXT_fog_coord_str = 'GL_EXT_fog_coord';
  //
  GL_FOG_COORDINATE_SOURCE   	    = $8450;
  GL_FOG_COORDINATE  					    = $8451;
  GL_FRAGMENT_DEPTH               = $8452;
  GL_CURRENT_FOG_COORDINATE       = $8453;
  GL_FOG_COORDINATE_ARRAY_TYPE    = $8454;
  GL_FOG_COORDINATE_ARRAY_STRIDE  = $8455;
  GL_FOG_COORDINATE_ARRAY_POINTER = $8456;
  GL_FOG_COORDINATE_ARRAY         = $8457;

// PROC PROTOTYPES
type PFNGLFOGCOORDFEXTPROC = procedure(coord: GLfloat); stdcall;
type PFNGLFOGCOORDDEXTPROC = procedure(coord: GLdouble); stdcall;
type PFNGLFOGCOORDFVEXTPROC = procedure(vCoord: PGLfloat); stdcall;
type PFNGLFOGCOORDDVEXTPROC = procedure(vCoord: PGLdouble); stdcall;
type PFNGLFOGCOORDPOINTEREXTPROC = procedure(); stdcall;

// PROC VARIABLE POINTERS
var
  glFogCoordfEXT:       PFNGLFOGCOORDFEXTPROC;
  glFogCoorddEXT:       PFNGLFOGCOORDDEXTPROC;
  glFogCoordfvEXT:      PFNGLFOGCOORDFVEXTPROC;
  glFogCoorddvEXT:      PFNGLFOGCOORDDVEXTPROC;
  glFogCoordPointerEXT: PFNGLFOGCOORDPOINTEREXTPROC;
// End EXT Fog coord ***********************************************************


// EXT Secondary color *********************************************************
{$DEFINE GL_EXT_secondary_color}
const
  GL_EXT_secondary_color_str = 'GL_EXT_secondary_color';
  //
  GL_COLOR_SUM	                    = $8458;
  GL_CURRENT_SECONDARY_COLOR        = $8459;
  GL_SECONDARY_COLOR_ARRAY_SIZE     = $845A;
  GL_SECONDARY_COLOR_ARRAY_TYPE     = $845B;
  GL_SECONDARY_COLOR_ARRAY_STRIDE   = $845C;
  GL_SECONDARY_COLOR_ARRAY_POINTER  = $845D;
  GL_SECONDARY_COLOR_ARRAY          = $845E;

// PROC PROTOTYPES
type PFNGLSECONDARYCOLOR3bEXTPROC = procedure(r, g, b: GLbyte); stdcall;
type PFNGLSECONDARYCOLOR3bvEXTPROC = procedure(const v: PGLbyte); stdcall;
type PFNGLSECONDARYCOLOR3sEXTPROC = procedure(r, g, b: GLshort); stdcall;
type PFNGLSECONDARYCOLOR3svEXTPROC = procedure(const v: PGLshort); stdcall;
type PFNGLSECONDARYCOLOR3iEXTPROC = procedure(r, g, b: GLint); stdcall;
type PFNGLSECONDARYCOLOR3ivEXTPROC = procedure(const v: PGLint); stdcall;
type PFNGLSECONDARYCOLOR3fEXTPROC = procedure(r, g, b: GLfloat); stdcall;
type PFNGLSECONDARYCOLOR3fvEXTPROC = procedure(const v: PGLfloat); stdcall;
type PFNGLSECONDARYCOLOR3dEXTPROC = procedure(r, g, b: GLdouble); stdcall;
type PFNGLSECONDARYCOLOR3dvEXTPROC = procedure(const v: PGLdouble); stdcall;
type PFNGLSECONDARYCOLOR3ubEXTPROC = procedure(r, g, b: GLubyte); stdcall;
type PFNGLSECONDARYCOLOR3ubvEXTPROC = procedure(const v: PGLubyte); stdcall;
type PFNGLSECONDARYCOLOR3usEXTPROC = procedure(r, g, b: GLushort); stdcall;
type PFNGLSECONDARYCOLOR3usvEXTPROC = procedure(const v: PGLushort); stdcall;
type PFNGLSECONDARYCOLOR3uiEXTPROC = procedure(r, g, b: GLuint); stdcall;
type PFNGLSECONDARYCOLOR3uivEXTPROC = procedure(const v: PGLuint); stdcall;
type PFNGLSECONDARYCOLORPOINTEREXTPROC = procedure(size: GLint; clrType: GLenum;
  stride: GLsizei; data: PGLvoid); stdcall;

// PROC VARIABLE POINTERS
var
  glSecondaryColor3bEXT:      PFNGLSECONDARYCOLOR3bEXTPROC;
  glSecondaryColor3bvEXT:     PFNGLSECONDARYCOLOR3bvEXTPROC;
  glSecondaryColor3sEXT:      PFNGLSECONDARYCOLOR3sEXTPROC;
  glSecondaryColor3svEXT:     PFNGLSECONDARYCOLOR3svEXTPROC;
  glSecondaryColor3iEXT:      PFNGLSECONDARYCOLOR3iEXTPROC;
  glSecondaryColor3ivEXT:     PFNGLSECONDARYCOLOR3ivEXTPROC;
  glSecondaryColor3fEXT:      PFNGLSECONDARYCOLOR3fEXTPROC;
  glSecondaryColor3fvEXT:     PFNGLSECONDARYCOLOR3fvEXTPROC;
  glSecondaryColor3dEXT:      PFNGLSECONDARYCOLOR3dEXTPROC;
  glSecondaryColor3dvEXT:     PFNGLSECONDARYCOLOR3dvEXTPROC;
  glSecondaryColor3ubEXT:     PFNGLSECONDARYCOLOR3ubEXTPROC;
  glSecondaryColor3ubvEXT:    PFNGLSECONDARYCOLOR3ubvEXTPROC;
  glSecondaryColor3usEXT:     PFNGLSECONDARYCOLOR3usEXTPROC;
  glSecondaryColor3usvEXT:    PFNGLSECONDARYCOLOR3usvEXTPROC;
  glSecondaryColor3uiEXT:     PFNGLSECONDARYCOLOR3uiEXTPROC;
  glSecondaryColor3uivEXT:    PFNGLSECONDARYCOLOR3uivEXTPROC;
  glSecondaryColorPointerEXT: PFNGLSECONDARYCOLORPOINTEREXTPROC;
// End EXT Secondary color *****************************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 1.5 Extensions    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_1_5}


// ARB Occclussion querry ******************************************************
{$DEFINE GL_ARB_occlusion_query}
const
  GL_ARB_occlusion_query_str = 'GL_ARB_occlusion_query';
  //
  GL_SAMPLES_PASSED         = $8914;
  GL_QUERY_COUNTER_BITS     = $8864;
  GL_CURRENT_QUERY          = $8865;
  GL_QUERY_RESULT           = $8866;
  GL_QUERY_RESULT_AVAILABLE = $8867;

// PROC PROTOTYPES
type PFNGLGENQUERIESARBPROC = procedure(n: GLsizei; 
  const ids: PGLuint); stdcall;
type PFNGLDELETEQUERIESARBPROC = procedure(n: GLsizei; 
  const ids: PGLuint); stdcall;
type PFNGLISQUERYARBPROC = function(id: GLuint): GLboolean; stdcall;
type PFNGLBEGINQUERYARBPROC = procedure(target: GLenum; id: GLuint); stdcall;
type PFNGLENDQUERYARBPROC = procedure(target: GLenum); stdcall;
type PFNGLGETQUERYIVARBPROC = procedure(target, pname: GLenum; 
  const params: PGLint); stdcall;
type PFNGLGETQUERYOBJECTIVARBPROC = procedure(id: GLuint; pname: GLenum;
  const params: PGLint); stdcall;
type PFNGLGETQUERYOBJECTUIVARBPROC = procedure(id: GLuint; pname: GLenum;
  const params: PGLuint); stdcall;

// PROC VARIABLE POINTERS
var
  glGenQueriesARB:        PFNGLGENQUERIESARBPROC;
  glDeleteQueriesARB:     PFNGLDELETEQUERIESARBPROC;
  glIsQueryARB:           PFNGLISQUERYARBPROC;
  glBeginQueryARB:        PFNGLBEGINQUERYARBPROC;
  glEndQueryARB:          PFNGLENDQUERYARBPROC;
  glGetQueryivARB:        PFNGLGETQUERYIVARBPROC;
  glGetQueryObjectivARB:  PFNGLGETQUERYOBJECTIVARBPROC;
  glGetQueryObjectuivARB: PFNGLGETQUERYOBJECTUIVARBPROC;
// End ARB Occclussion querry **************************************************


// ARB Vertex buffer object (VBO) **********************************************
{$DEFINE GL_ARB_vertex_buffer_object}
{$DEFINE GLX_ARB_vertex_buffer_object}
const
  GL_ARB_vertex_buffer_object_str = 'GL_ARB_vertex_buffer_object';
  GLX_ARB_vertex_buffer_object_str = 'GL_ARB_vertex_buffer_object';
  //
  GLX_CONTEXT_ALLOW_BUFFER_BYTE_ORDER_MISMATCH  = $2095;
  GL_ARRAY_BUFFER                               = $8892;
  GL_ELEMENT_ARRAY_BUFFER                       = $8893;
  GL_ARRAY_BUFFER_BINDING                       = $8894;
  GL_ELEMENT_ARRAY_BUFFER_BINDING               = $8895;
  GL_VERTEX_ARRAY_BUFFER_BINDING                = $8896;
  GL_NORMAL_ARRAY_BUFFER_BINDING                = $8897;
  GL_COLOR_ARRAY_BUFFER_BINDING                 = $8898;
  GL_INDEX_ARRAY_BUFFER_BINDING                 = $8899;
  GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING         = $889A;
  GL_EDGE_FLAG_ARRAY_BUFFER_BINDING             = $889B;
  GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING       = $889C;
  GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING        = $889D;
  GL_WEIGHT_ARRAY_BUFFER_BINDING                = $889E;
  GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING         = $889F;
  GL_STREAM_DRAW                                = $88E0;
  GL_STREAM_READ                                = $88E1;
  GL_STREAM_COPY                                = $88E2;
  GL_STATIC_DRAW                                = $88E4;
  GL_STATIC_READ                                = $88E5;
  GL_STATIC_COPY                                = $88E6;
  GL_DYNAMIC_DRAW                               = $88E8;
  GL_DYNAMIC_READ                               = $88E9;
  GL_DYNAMIC_COPY                               = $88EA;
  GL_READ_ONLY				                          = $88B8;
  GL_WRITE_ONLY                                 = $88B9;
  GL_READ_WRITE                                 = $88BA;
  GL_BUFFER_SIZE                                = $8764;
  GL_BUFFER_USAGE                               = $8765;
  GL_BUFFER_ACCESS                              = $88BB;
  GL_BUFFER_MAPPED                              = $88BC;
  GL_BUFFER_MAP_POINTER                         = $88BD;

// PROC PROTOTYPES
type PFNGLBINDBUFFERARBPROC = procedure(target: GLenum; buffer: GLuint); stdcall;
type PFNGLDELETEBUFFERSARBPROC = procedure(n: GLsizei; const 
  buffers: PGLuint); stdcall;
type PFNGLGENBUFFERSARBPROC = procedure(n: GLsizei; buffers: PGLuint); stdcall;
type PFNGLISBUFFERARBPROC = function(buffer: GLuint): GLboolean; stdcall;
type PFNGLBUFFERDATAARBPROC = procedure(target: GLenum; size: Glsizeiptr;
  const dataPtr: Pointer; usage: GLenum); stdcall;
type PFNGLBUFFERSUBDATAARBPROC = procedure(target: GLenum; offset: GLintptr;
  size: Glsizeiptr; const dataPtr: Pointer); stdcall;
type PFNGLGETBUFFERSUBDATAARBPROC = procedure(target: Glenum; offset: GLintptr;
  size: Glsizeiptr; const dataPtr: Pointer); stdcall;
type PFNGLMAPBUFFERARBPROC = function(target: GLenum; 
  access: GLenum): PGLvoid; stdcall;
type PFNGLUNMAOBUFFERARBPROC = function(target: GLenum): GLboolean; stdcall;
type PFNGLGETBUFFERPARAMETERIVARBPROC = procedure(target, pname: GLenum; 
  params: PGLint); stdcall;
type PFNGLGETBUFFERPOINTERVARBPROC = procedure(target, pname: GLenum; 
  params: PPGLvoid); stdcall;

// PROC VARIABLE POINTERS
var
  glBindBufferARB:            PFNGLBINDBUFFERARBPROC;
  glDeleteBuffersARB:         PFNGLDELETEBUFFERSARBPROC;
  glGenBuffersARB:            PFNGLGENBUFFERSARBPROC;
  glIsBufferARB:              PFNGLISBUFFERARBPROC;
  glBufferDataARB:            PFNGLBUFFERDATAARBPROC;
  glBufferSubDataARB:         PFNGLBUFFERSUBDATAARBPROC;
  glGetBufferSubDataARB:      PFNGLGETBUFFERSUBDATAARBPROC;
  glMapBufferARB:             PFNGLMAPBUFFERARBPROC;
  glUnmapBufferARB:           PFNGLUNMAOBUFFERARBPROC;
  glGetBufferParameterivARB:  PFNGLGETBUFFERPARAMETERIVARBPROC;
  glGetBufferPointervARB:     PFNGLGETBUFFERPOINTERVARBPROC;
// End ARB Vertex buffer object (VBO) ******************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 2.0 Extensions    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_2_0}


// ATI Separate stencil ********************************************************
{$DEFINE GL_ATI_separate_stencil}
const
  GL_ATI_separate_stencil_str = 'GL_ATI_separate_stencil';
  //
  GL_KEEP                         = $1E00;
  GL_ZERO                         = $0000;
  GL_INCR                         = $1E02;
  GL_DECR                         = $1E03;
  GL_INVERT                       = $150A;
  GL_NEVER                        = $0200;
  GL_LESS                         = $0201;
  GL_LEQUAL                       = $0203;
  GL_GREATER                      = $0204;
  GL_GEQUAL                       = $0206;
  GL_EQUAL                        = $0202;
  GL_NOTEQUAL                     = $0205;
  GL_ALWAYS                       = $0207;
  GL_FRONT                        = $0404;
  GL_BACK                         = $0405;
  GL_FRONT_AND_BACK               = $0408;
  GL_STENCIL_BACK_FUNC            = $8800;
  GL_STENCIL_BACK_FAIL            = $8801;
  GL_STENCIL_BACK_PASS_DEPTH_FAIL = $8802;
  GL_STENCIL_BACK_PASS_DEPTH_PASS = $8803;

// PROC PROTOTYPES
type PFNGLSTENCILOPSEPARATEATIPROC = procedure(
  face, sfail, dpfail, dppass: GLenum); stdcall;
type PFNGLSTENCILFUNCSEPARATEARBPROC = procedure(ftFunc, bkFunc: GLenum; 
  ref: GLint; mask: GLuint); stdcall;

// PROC VARIABLE POINTERS
var
  glStencilOpSeparateATI:   PFNGLSTENCILOPSEPARATEATIPROC;
  glStencilFuncSeparateATI: PFNGLSTENCILFUNCSEPARATEARBPROC;
// End ATI Separate stencil ****************************************************


// EXT Stencil two side ********************************************************
{$DEFINE GL_EXT_stencil_two_side}
const
  GL_EXT_stencil_two_side_str = 'GL_EXT_stencil_two_side';
  //
  GL_STENCIL_TEST_TWO_SIDE  = $8910;
  GL_ACTIVE_STENCIL_FACE    = $8911;

// PROC PROTOTYPES
type PFNGLACTIVESTENCILFACEEXTPROC = procedure(face: GLenum); stdcall;

// PROC VARIABLE POINTERS
var
  glActiveStencilFaceEXT: PFNGLACTIVESTENCILFACEEXTPROC;
// End EXT Stencil two side ****************************************************


// ARB Point sprite ************************************************************
{$DEFINE GL_ARB_point_sprite}
const
  GL_ARB_point_sprite_str = 'GL_ARB_point_sprite';
  //
  GL_POINT_SPRITE   = $8861;
  GL_COORD_REPLACE  = $8862;

// End ARB Point sprite ********************************************************


// ARB Draw buffers ************************************************************
{$DEFINE GL_ARB_draw_buffers}
const
  GL_ARB_draw_buffers_str = 'GL_ARB_draw_buffers';
  //
  GL_MAX_DRAW_BUFFERS = $8824;
  GL_DRAW_BUFFER0			= $8825;
  GL_DRAW_BUFFER1			= $8826;
  GL_DRAW_BUFFER2			= $8827;
  GL_DRAW_BUFFER3			= $8828;
  GL_DRAW_BUFFER4			= $8829;
  GL_DRAW_BUFFER5			= $882A;
  GL_DRAW_BUFFER6			= $882B;
  GL_DRAW_BUFFER7			= $882C;
  GL_DRAW_BUFFER8			= $882D;
  GL_DRAW_BUFFER9			= $882E;
  GL_DRAW_BUFFER10    = $882F;
  GL_DRAW_BUFFER11    = $8830;
  GL_DRAW_BUFFER12    = $8831;
  GL_DRAW_BUFFER13    = $8832;
  GL_DRAW_BUFFER14    = $8833;
  GL_DRAW_BUFFER15    = $8834;

// PROC PROTOTYPES
type PFNGLDRAWBUFFERSARBPROC = procedure(n: GLsizei; 
  const bufs: PGLenum); stdcall;

// PROC VARIABLE POINTERS
var
  glDrawBuffersARB: PFNGLDRAWBUFFERSARBPROC;
// End ARB Draw buffers ********************************************************


// ARB Shading language 100 ****************************************************
{$DEFINE GL_ARB_shading_language_100}
const
  GL_ARB_shading_language_100_str = 'GL_ARB_shading_language_100';
  //
  GL_SHADING_LANGUAGE_VERSION = $8B8C;

// End ARB Shading language 100 ************************************************


// ARB Fragment shader *********************************************************
{$DEFINE GL_ARB_fragment_shader}
const
  GL_ARB_fragment_shader_str = 'GL_ARB_fragment_shader';
  //
  GL_FRAGMENT_SHADER                  = $8B30;
  GL_MAX_FRAGMENT_UNIFORM_COMPONENTS  = $8B49;
  GL_MAX_TEXTURE_COORDS               = $8871;
  GL_MAX_TEXTURE_IMAGE_UNITS          = $8872;
  GL_FRAGMENT_SHADER_DERIVATIVE_HINT  = $8B8B;

// End ARB Fragment shader *****************************************************


// ARB Vertex shader ***********************************************************
{$DEFINE GL_ARB_vertex_shader}
const
  GL_ARB_vertex_shader_str = 'GL_ARB_vertex_shader';
  //
  GL_VERTEX_SHADER                      = $8B31;
  GL_MAX_VERTEX_UNIFORM_COMPONENTS      = $8B4A;
  GL_MAX_VARYING_FLOATS                 = $8B4B;
  GL_MAX_VERTEX_ATTRIBS                 = $8869;
  GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS     = $8B4C;
  GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS   = $8B4D;
  GL_VERTEX_PROGRAM_POINT_SIZE          = $8642;
  GL_VERTEX_PROGRAM_TWO_SIDE            = $8643;
  GL_OBJECT_ACTIVE_ATTRIBUTES           = $8B89;
  GL_OBJECT_ACTIVE_ATTRIBUTE_MAX_LENGTH = $8B8A;
  GL_VERTEX_ATTRIB_ARRAY_ENABLED        = $8622;
  GL_VERTEX_ATTRIB_ARRAY_SIZE           = $8623;
  GL_VERTEX_ATTRIB_ARRAY_STRIDE         = $8624;
  GL_VERTEX_ATTRIB_ARRAY_TYPE           = $8625;
  GL_VERTEX_ATTRIB_ARRAY_NORMALIZED     = $886A;
  GL_CURRENT_VERTEX_ATTRIB              = $8626;
  GL_VERTEX_ATTRIB_ARRAY_POINTER        = $8645;

// PROC PROTOTYPES
type PFNGLVERTEXATTRIB1FARBPROC = procedure(index: GLuint;
  v0: GLfloat); stdcall;
type PFNGLVERTEXATTRIB1SARBPROC = procedure(index: GLuint;
  v0: GLshort); stdcall;
type PFNGLVERTEXATTRIB1DARBPROC = procedure(index: GLuint;
  v0: GLdouble); stdcall;
type PFNGLVERTEXATTRIB2FARBPROC = procedure(index: GLuint;
  v0, v1: GLfloat); stdcall;
type PFNGLVERTEXATTRIB2SARBPROC = procedure(index: GLuint;
  v0, v1: GLshort); stdcall;
type PFNGLVERTEXATTRIB2DARBPROC = procedure(index: GLuint;
  v0, v1: GLdouble); stdcall;
type PFNGLVERTEXATTRIB3FARBPROC = procedure(index: GLuint;
  v0, v1, v2: GLfloat); stdcall;
type PFNGLVERTEXATTRIB3SARBPROC = procedure(index: GLuint;
  v0, v1, v2: GLshort); stdcall;
type PFNGLVERTEXATTRIB3DARBPROC = procedure(index: GLuint;
  v0, v1, v2: GLdouble); stdcall;
type PFNGLVERTEXATTRIB4FARBPROC = procedure(index: GLuint;
  v0, v1, v2, v3: GLfloat); stdcall;
type PFNGLVERTEXATTRIB4SARBPROC = procedure(index: GLuint;
  v0, v1, v2, v3: GLshort); stdcall;
type PFNGLVERTEXATTRIB4DARBPROC = procedure(index: GLuint;
  v0, v1, v2, v3: GLdouble); stdcall;
type PFNGLVERTEXATTRIB4NUBARBPROC = procedure(index: GLuint;
  x, y, z, w: GLubyte); stdcall;
type PFNGLVERTEXATTRIB1FVARBPROC = procedure(index: GLuint; 
  const v: PGLFloat); stdcall;
type PFNGLVERTEXATTRIB1SVARBPROC = procedure(index: GLuint; 
  const v: PGLshort); stdcall;
type PFNGLVERTEXATTRIB1DVARBPROC = procedure(index: GLuint; 
  const v: PGLdouble); stdcall;
type PFNGLVERTEXATTRIB2FVARBPROC = procedure(index: GLuint; 
  const v: PGLFloat); stdcall;
type PFNGLVERTEXATTRIB2SVARBPROC = procedure(index: GLuint; 
  const v: PGLshort); stdcall;
type PFNGLVERTEXATTRIB2DVARBPROC = procedure(index: GLuint; 
  const v: PGLdouble); stdcall;
type PFNGLVERTEXATTRIB3FVARBPROC = procedure(index: GLuint; 
  const v: PGLFloat); stdcall;
type PFNGLVERTEXATTRIB3SVARBPROC = procedure(index: GLuint; 
  const v: PGLshort); stdcall;
type PFNGLVERTEXATTRIB3DVARBPROC = procedure(index: GLuint; 
  const v: PGLdouble); stdcall;
type PFNGLVERTEXATTRIB4FVARBPROC = procedure(index: GLuint; 
  const v: PGLFloat); stdcall;
type PFNGLVERTEXATTRIB4SVARBPROC = procedure(index: GLuint; 
  const v: PGLshort); stdcall;
type PFNGLVERTEXATTRIB4DVARBPROC = procedure(index: GLuint; 
  const v: PGLdouble); stdcall;
type PFNGLVERTEXATTRIB4IVARBPROC = procedure(index: GLuint; 
  const v: PGLint); stdcall;
type PFNGLVERTEXATTRIB4BVARBPROC = procedure(index: GLuint; 
  const v: PGLubyte); stdcall;
type PFNGLVERTEXATTRIB4UBVARBPROC = procedure(index: GLuint; 
  const v: PGLubyte); stdcall;
type PFNGLVERTEXATTRIB4USVARBPROC = procedure(index: GLuint; 
  const v: PGLushort); stdcall;
type PFNGLVERTEXATTRIB4UIVARBPROC = procedure(index: GLuint; 
  const v: PGLuint); stdcall;
type PFNGLVERTEXATTRIB4NBVARBPROC = procedure(index: GLuint; 
  const v: PGLbyte); stdcall;
type PFNGLVERTEXATTRIB4NSVARBPROC = procedure(index: GLuint; 
  const v: PGLshort); stdcall;
type PFNGLVERTEXATTRIB4NIVARBPROC = procedure(index: GLuint; 
  const v: PGLint); stdcall;
type PFNGLVERTEXATTRIB4NUBVARBPROC = procedure(index: GLuint; 
  const v: PGLubyte); stdcall;
type PFNGLVERTEXATTRIB4NUSVARBPROC = procedure(index: GLuint; 
  const v: PGLushort); stdcall;
type PFNGLVERTEXATTRIB4NUIVARBPROC = procedure(index: GLuint; 
  const v: PGLuint); stdcall;
type PFNGLVERTEXATTRIBPOINTERARBPROC = procedure(index: GLuint; size: GLint;
  attribType: GLenum; normalized: GLboolean; stride: GLsizei;
    const data: PGLvoid); stdcall;
type PFNGLENABLEVERTEXATTRIBARRAYARBPROC = procedure(index: GLuint); stdcall;
type PFNGLDISABLEVERTEXATTRIBARRAYARBPROC = procedure(index: GLuint); stdcall;
type PFNGLBINDATTRIBLOCATIONARBPROC = procedure(programObj: GLhandle; index: GLuint;
  const name: PGLchar); stdcall;
type PFNGLGETACTIVEATTRIBARBPROC = procedure(programObj: GLhandle; index: GLuint;
  maxLen: GLsizei; length: PGLsizei; size: PGLint; attribType: PGLenum;
    name: PGLchar); stdcall;
type PFNGLGETATTRIBLOCATIONARBPROC = function(programObj: GLhandle;
  const name: PGLchar): GLint; stdcall;
type PFNGLGETVERTEXATTRIBDVARBPROC = procedure(index: GLuint; pname: GLenum;
  params: PGLdouble); stdcall;
type PFNGLGETVERTEXATTRIBFVARBPROC = procedure(index: GLuint; pname: GLenum;
  params: PGLfloat); stdcall;
type PFNGLGETVERTEXATTRIBIVARBPROC = procedure(index: GLuint; pname: GLenum;
  params: PGLint); stdcall;
type PFNGLGETVERTEXATTRIBPOINTERVARBPROC = procedure(index: GLuint; pname: GLenum;
  data: PPGLvoid); stdcall;


// PROC VARIABLE POINTERS
var
  glVertexAttrib1fARB:            PFNGLVERTEXATTRIB1FARBPROC;
  glVertexAttrib1sARB:            PFNGLVERTEXATTRIB1SARBPROC;
  glVertexAttrib1dARB:            PFNGLVERTEXATTRIB1DARBPROC;
  glVertexAttrib2fARB:            PFNGLVERTEXATTRIB2FARBPROC;
  glVertexAttrib2sARB:            PFNGLVERTEXATTRIB2SARBPROC;
  glVertexAttrib2dARB:            PFNGLVERTEXATTRIB2DARBPROC;
  glVertexAttrib3fARB:            PFNGLVERTEXATTRIB3FARBPROC;
  glVertexAttrib3sARB:            PFNGLVERTEXATTRIB3SARBPROC;
  glVertexAttrib3dARB:            PFNGLVERTEXATTRIB3DARBPROC;
  glVertexAttrib4fARB:            PFNGLVERTEXATTRIB4FARBPROC;
  glVertexAttrib4sARB:            PFNGLVERTEXATTRIB4SARBPROC;
  glVertexAttrib4dARB:            PFNGLVERTEXATTRIB4DARBPROC;
  glVertexAttrib4NubARB:          PFNGLVERTEXATTRIB4NUBARBPROC;
  glVertexAttrib1fvARB:           PFNGLVERTEXATTRIB1FVARBPROC;
  glVertexAttrib1svARB:           PFNGLVERTEXATTRIB1SVARBPROC;
  glVertexAttrib1dvARB:           PFNGLVERTEXATTRIB1DVARBPROC;
  glVertexAttrib2fvARB:           PFNGLVERTEXATTRIB2FVARBPROC;
  glVertexAttrib2svARB:           PFNGLVERTEXATTRIB2SVARBPROC;
  glVertexAttrib2dvARB:           PFNGLVERTEXATTRIB2DVARBPROC;
  glVertexAttrib3fvARB:           PFNGLVERTEXATTRIB3FVARBPROC;
  glVertexAttrib3svARB:           PFNGLVERTEXATTRIB3SVARBPROC;
  glVertexAttrib3dvARB:           PFNGLVERTEXATTRIB3DVARBPROC;
  glVertexAttrib4fvARB:           PFNGLVERTEXATTRIB4FVARBPROC;
  glVertexAttrib4svARB:           PFNGLVERTEXATTRIB4SVARBPROC;
  glVertexAttrib4dvARB:           PFNGLVERTEXATTRIB4DVARBPROC;
  glVertexAttrib4ivARB:           PFNGLVERTEXATTRIB4IVARBPROC;
  glVertexAttrib4bvARB:           PFNGLVERTEXATTRIB4BVARBPROC;
  glVertexAttrib4ubvARB:          PFNGLVERTEXATTRIB4UBVARBPROC;
  glVertexAttrib4usvARB:          PFNGLVERTEXATTRIB4USVARBPROC;
  glVertexAttrib4uivARB:          PFNGLVERTEXATTRIB4UIVARBPROC;
  glVertexAttrib4NbvARB:          PFNGLVERTEXATTRIB4NBVARBPROC;
  glVertexAttrib4NsvARB:          PFNGLVERTEXATTRIB4NSVARBPROC;
  glVertexAttrib4NivARB:          PFNGLVERTEXATTRIB4NIVARBPROC;
  glVertexAttrib4NubvARB:         PFNGLVERTEXATTRIB4NUBVARBPROC;
  glVertexAttrib4NusvARB:         PFNGLVERTEXATTRIB4NUSVARBPROC;
  glVertexAttrib4NuivARB:         PFNGLVERTEXATTRIB4NUIVARBPROC;
  glVertexAttribPointerARB:       PFNGLVERTEXATTRIBPOINTERARBPROC;
  glEnableVertexAttribArrayARB:   PFNGLENABLEVERTEXATTRIBARRAYARBPROC;
  glDisableVertexAttribArrayARB:  PFNGLDISABLEVERTEXATTRIBARRAYARBPROC;
  glBindAttribLocationARB:        PFNGLBINDATTRIBLOCATIONARBPROC;
  glGetActiveAttribARB:           PFNGLGETACTIVEATTRIBARBPROC;
  glGetAttribLocationARB:         PFNGLGETATTRIBLOCATIONARBPROC;
  glGetVertexAttribdvARB:         PFNGLGETVERTEXATTRIBDVARBPROC;
  glGetVertexAttribfvARB:         PFNGLGETVERTEXATTRIBFVARBPROC;
  glGetVertexAttribivARB:         PFNGLGETVERTEXATTRIBIVARBPROC;
  glGetVertexAttribPointervARB:   PFNGLGETVERTEXATTRIBPOINTERVARBPROC;
// End ARB Vertex shader *******************************************************


// ARB Shader object ***********************************************************
{$DEFINE GL_ARB_shader_objects}
const
  GL_ARB_shader_objects_str = 'GL_ARB_shader_objects';
  //
  GL_PROGRAM_OBJECT                   = $8B40;
  GL_OBJECT_TYPE                      = $8B4E;
  GL_OBJECT_SUBTYPE                   = $8B4F;
  GL_OBJECT_DELETE_STATUS             = $8B80;
  GL_OBJECT_COMPILE_STATUS            = $8B81;
  GL_OBJECT_LINK_STATUS               = $8B82;
  GL_OBJECT_VALIDATE_STATUS           = $8B83;
  GL_OBJECT_INFO_LOG_LENGTH           = $8B84;
  GL_OBJECT_ATTACHED_OBJECTS          = $8B85;
  GL_OBJECT_ACTIVE_UNIFORMS           = $8B86;
  GL_OBJECT_ACTIVE_UNIFORM_MAX_LENGTH = $8B87;
  GL_OBJECT_SHADER_SOURCE_LENGTH      = $8B88;
  GL_SHADER_OBJECT                    = $8B48;
  GL_FLOAT_VEC2                       = $8B50;
  GL_FLOAT_VEC3                       = $8B51;
  GL_FLOAT_VEC4                       = $8B52;
  GL_INT_VEC2                         = $8B53;
  GL_INT_VEC3                         = $8B54;
  GL_INT_VEC4                         = $8B55;
  GL_BOOL                             = $8B56;
  GL_BOOL_VEC2                        = $8B57;
  GL_BOOL_VEC3                        = $8B58;
  GL_BOOL_VEC4                        = $8B59;
  GL_FLOAT_MAT2                       = $8B5A;
  GL_FLOAT_MAT3                       = $8B5B;
  GL_FLOAT_MAT4                       = $8B5C;
  GL_SAMPLER_1D                       = $8B5D;
  GL_SAMPLER_2D                       = $8B5E;
  GL_SAMPLER_3D                       = $8B5F;
  GL_SAMPLER_CUBE                     = $8B60;
  GL_SAMPLER_1D_SHADOW                = $8B61;
  GL_SAMPLER_2D_SHADOW                = $8B62;
  GL_SAMPLER_2D_RECT                  = $8B63;
  GL_SAMPLER_2D_RECT_SHADOW           = $8B64;

// PROC PROTOTYPES
type PFNGLDELETEOBJECTARBPROC = procedure(obj: GLhandle); stdcall;
type PFNGLGETHANDLEARBPROC = function(pname: GLenum): GLhandle; stdcall;
type PFNGLDETACHOBJECTARBPROC = procedure(containerObj,
  attachedObj: GLhandle); stdcall;
type PFNGLCREATESHADEROBJECTARBPROC = function(
  shaderType: GLenum): GLhandle; stdcall;
type PFNGLSHADERSOURCEARBPROC = procedure(shaderObj: GLhandle; count: GLsizei;
  const dataSrc: PPGLchar; const length: PGLint); stdcall;
type PFNGLCOMPILESHADERARBPROC = procedure(shaderObj: GLhandle); stdcall;
type PFNGLCREATEPROGRAMOBJECTARBPROC = function(): GLhandle; stdcall;
type PFNGLATTACHOBJECTARBPROC = procedure(containerObj, obj: GLhandle); stdcall;
type PFNGLLINKPROGRAMARBPROC = procedure(programObj: GLhandle); stdcall;
type PFNGLUSEPROGRAMOBJECTARBPROC = procedure(programObj: GLhandle); stdcall;
type PFNGLVALIDATEPROGRAMARBPROC = procedure(programObj: GLhandle); stdcall;
type PFNGLGETOBJECTPARAMETERFVARBPROC = procedure(obj: GLhandle; pname: GLenum;
  params: PGLfloat); stdcall;
type PFNGLGETOBJECTPARAMETERIVARBPROC = procedure(obj: GLhandle; pname: GLenum;
  params: PGLint); stdcall;
type PFNGLGETINFOLOGARBPROC = procedure(obj: GLhandle; maxLength: GLsizei;
  length: PGLsizei; infoLog: PGLchar); stdcall;
type PFNGLGETATTACHEDOBJECTSARBPROC = procedure(containerObj: GLhandle;
  maxCount: GLsizei; count: PGLsizei; objs: PGLhandle); stdcall;
type PFNGLGETUNIFORMLOCATIONARBPROC = function(programObj: GLhandle;
  const name: PGLchar): GLint; stdcall;
type PFNGLGETACTIVEUNIFORMARBPROC = procedure(programObj: GLhandle; index: GLuint;
  maxLength: GLsizei; length: PGLsizei; size: PGLint; uniformType: PGLenum;
    name: PGLchar); stdcall;
type PFNGLGETUNIFORMFVARBPROC = procedure(programObj: GLhandle; location: GLint;
  params: PGLfloat); stdcall;
type PFNGLGETUNIFORMIVARBPROC = procedure(programObj: GLhandle; location: GLint;
  params: PGLint); stdcall;
type PFNGLGETSHADERSOURCEARBPROC = procedure(obj: GLhandle; maxCount: GLsizei;
  length: PGLsizei; source: PGLchar); stdcall;

type PFNGLUNIFORM1FARBPROC =    procedure(location: GLint;
  f0: GLfloat); stdcall;
type PFNGLUNIFORM2FARBPROC =    procedure(location: GLint;
  f0, f1: GLfloat); stdcall;
type PFNGLUNIFORM3FARBPROC =    procedure(location: GLint;
  f0, f1, f2: GLfloat); stdcall;
type PFNGLUNIFORM4FARBPROC =    procedure(location: GLint;
  f0, f1, f2, f3: GLfloat); stdcall;
type PFNGLUNIFORM1IARBPROC =    procedure(location: GLint;
  i0: GLint); stdcall;
type PFNGLUNIFORM2IARBPROC =    procedure(location: GLint;
  i0, i1: GLint); stdcall;
type PFNGLUNIFORM3IARBPROC =    procedure(location: GLint;
  i0, i1, i2: GLint); stdcall;
type PFNGLUNIFORM4IARBPROC =    procedure(location: GLint;
  i0, i1, i2, i3: GLint); stdcall;
type PFNGLUNIFORM1FVARBPROC =   procedure(location: GLint; count: GLsizei;
  const data: PGLfloat); stdcall;
type PFNGLUNIFORM2FVARBPROC =   procedure(location: GLint; count: GLsizei;
  const data: PGLfloat); stdcall;
type PFNGLUNIFORM3FVARBPROC =   procedure(location: GLint; count: GLsizei;
  const data: PGLfloat); stdcall;
type PFNGLUNIFORM4FVARBPROC =   procedure(location: GLint; count: GLsizei;
  const data: PGLfloat); stdcall;
type PFNGLUNIFORM1IVARBPROC =   procedure(location: GLint; count: GLsizei;
  const data: PGLint); stdcall;
type PFNGLUNIFORM2IVARBPROC =   procedure(location: GLint; count: GLsizei;
  const data: PGLint); stdcall;
type PFNGLUNIFORM3IVARBPROC =   procedure(location: GLint; count: GLsizei;
  const data: PGLint); stdcall;
type PFNGLUNIFORM4IVARBPROC =   procedure(location: GLint; count: GLsizei;
  const data: PGLint); stdcall;
type PFNGLUNIFORMMATRIX2FVARBPROC =   procedure(location: GLint; count: GLsizei;
  transpose: GLBoolean; const data: PGLfloat); stdcall;
type PFNGLUNIFORMMATRIX3FVARBPROC =   procedure(location: GLint; count: GLsizei;
  transpose: GLBoolean; const data: PGLfloat); stdcall;
type PFNGLUNIFORMMATRIX4FVARBPROC =   procedure(location: GLint; count: GLsizei;
  transpose: GLBoolean; const data: PGLfloat); stdcall;

// PROC VARIABLE POINTERS
var
  glDeleteObjectARB:         PFNGLDELETEOBJECTARBPROC;
  glGetHandleARB:            PFNGLGETHANDLEARBPROC;
  glDetachObjectARB:         PFNGLDETACHOBJECTARBPROC;
  glCreateShaderObjectARB:   PFNGLCREATESHADEROBJECTARBPROC;
  glShaderSourceARB:         PFNGLSHADERSOURCEARBPROC;
  glCompileShaderARB:        PFNGLCOMPILESHADERARBPROC;
  glCreateProgramObjectARB:  PFNGLCREATEPROGRAMOBJECTARBPROC;
  glAttachObjectARB:         PFNGLATTACHOBJECTARBPROC;
  glLinkProgramARB:          PFNGLLINKPROGRAMARBPROC;
  glUseProgramObjectARB:     PFNGLUSEPROGRAMOBJECTARBPROC;
  glValidateProgramARB:      PFNGLVALIDATEPROGRAMARBPROC;
  glGetObjectParameterfvARB: PFNGLGETOBJECTPARAMETERFVARBPROC;
  glGetObjectParameterivARB: PFNGLGETOBJECTPARAMETERIVARBPROC;
  glGetInfoLogARB:           PFNGLGETINFOLOGARBPROC;
  glGetAttachedObjectsARB:   PFNGLGETATTACHEDOBJECTSARBPROC;
  glGetUniformLocationARB:   PFNGLGETUNIFORMLOCATIONARBPROC;
  glGetActiveUniformARB:     PFNGLGETACTIVEUNIFORMARBPROC;
  glGetUniformfvARB:         PFNGLGETUNIFORMFVARBPROC;
  glGetUniformivARB:         PFNGLGETUNIFORMIVARBPROC;
  glGetShaderSourceARB:      PFNGLGETSHADERSOURCEARBPROC;
  glUniform1fARB:            PFNGLUNIFORM1FARBPROC;
  glUniform2fARB:            PFNGLUNIFORM2FARBPROC;
  glUniform3fARB:            PFNGLUNIFORM3FARBPROC;
  glUniform4fARB:            PFNGLUNIFORM4FARBPROC;
  glUniform1iARB:            PFNGLUNIFORM1IARBPROC;
  glUniform2iARB:            PFNGLUNIFORM2IARBPROC;
  glUniform3iARB:            PFNGLUNIFORM3IARBPROC;
  glUniform4iARB:            PFNGLUNIFORM4IARBPROC;
  glUniform1fvARB:           PFNGLUNIFORM1FVARBPROC;
  glUniform2fvARB:           PFNGLUNIFORM2FVARBPROC;
  glUniform3fvARB:           PFNGLUNIFORM3FVARBPROC;
  glUniform4fvARB:           PFNGLUNIFORM4FVARBPROC;
  glUniform1ivARB:           PFNGLUNIFORM1IVARBPROC;
  glUniform2ivARB:           PFNGLUNIFORM2IVARBPROC;
  glUniform3ivARB:           PFNGLUNIFORM3IVARBPROC;
  glUniform4ivARB:           PFNGLUNIFORM4IVARBPROC;
  glUniformMatrix2fvARB:     PFNGLUNIFORMMATRIX2FVARBPROC;
  glUniformMatrix3fvARB:     PFNGLUNIFORMMATRIX3FVARBPROC;
  glUniformMatrix4fvARB:     PFNGLUNIFORMMATRIX4FVARBPROC;
// End ARB Shader object *******************************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 2.1 Extensions    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_2_1}


// NV Non-squared GLSL Matrices ***********************************************
{$DEFINE GL_NV_non_square_matrices}
const
  GL_NV_NAME_str = 'GL_NV_non_square_matrices';
  //
  GL_FLOAT_MAT2x3 = $8B65;
  GL_FLOAT_MAT2x4 = $8B66;
  GL_FLOAT_MAT3x2 = $8B67;
  GL_FLOAT_MAT3x4 = $8B68;
  GL_FLOAT_MAT4x2 = $8B69;
  GL_FLOAT_MAT4x3 = $8B6A;

// PROC PROTOTYPES
type PFNGLUNIFORMATRIX2X3FVNVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const data: PGLfloat); stdcall;
type PFNGLUNIFORMATRIX2X4FVNVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const data: PGLfloat); stdcall;
type PFNGLUNIFORMATRIX3X2FVNVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const data: PGLfloat); stdcall;
type PFNGLUNIFORMATRIX3X4FVNVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const data: PGLfloat); stdcall;
type PFNGLUNIFORMATRIX4X2FVNVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const data: PGLfloat); stdcall;
type PFNGLUNIFORMATRIX4X3FVNVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const data: PGLfloat); stdcall;

// PROC VARIABLE POINTERS
var
  glUniformMatrix2x3fvNV: PFNGLUNIFORMATRIX2X3FVNVPROC;
  glUniformMatrix2x4fvNV: PFNGLUNIFORMATRIX2X4FVNVPROC;
  glUniformMatrix3x2fvNV: PFNGLUNIFORMATRIX3X2FVNVPROC;
  glUniformMatrix3x4fvNV: PFNGLUNIFORMATRIX3X4FVNVPROC;
  glUniformMatrix4x2fvNV: PFNGLUNIFORMATRIX4X2FVNVPROC;
  glUniformMatrix4x3fvNV: PFNGLUNIFORMATRIX4X3FVNVPROC;  
// End NV Non-squared GLSL Matrices *******************************************


// EXT Texture sRGB ************************************************************
{$DEFINE GL_EXT_texture_sRGB}
const
  GL_EXT_texture_sRGB_str = 'GL_EXT_texture_sRGB';
  //
  GL_SRGB                             = $8C40;
  GL_SRGB8                            = $8C41;
  GL_SRGB_ALPHA                       = $8C42;
  GL_SRGB8_ALPHA8                     = $8C43;
  GL_SLUMINANCE_ALPHA                 = $8C44;
  GL_SLUMINANCE8_ALPHA8               = $8C45;
  GL_SLUMINANCE                       = $8C46;
  GL_SLUMINANCE8                      = $8C47;
  GL_COMPRESSED_SRGB                  = $8C48;
  GL_COMPRESSED_SRGB_ALPHA            = $8C49;
  GL_COMPRESSED_SLUMINANCE            = $8C4A;
  GL_COMPRESSED_SLUMINANCE_ALPHA      = $8C4B;
  GL_COMPRESSED_SRGB_S3TC_DXT1        = $8C4C;
  GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT1  = $8C4D;
  GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT3  = $8C4E;
  GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT5  = $8C4F;

// End EXT Texture sRGB ********************************************************


// ARB Pixel buffer object (PBO) ***********************************************
{$DEFINE GL_ARB_pixel_buffer_object}
const
  GL_ARB_pixel_buffer_object_str = 'GL_ARB_pixel_buffer_object';
  //
  GL_PIXEL_PACK_BUFFER            = $88EB;
  GL_PIXEL_PUNACK_BUFFER          = $88EC;
  GL_PIXEL_PACK_BUFFER_BINDING    = $88ED;
  GL_PIXEL_PUNACK_BUFFER_BINDING  = $88EF;

// End ARB Pixel buffer object (PBO) *******************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 3.0 Extensions    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_3_0}


// NV Conditional render *******************************************************
{$DEFINE GL_NV_conditional_render}
const
  GL_NV_conditional_render_str = 'GL_ARBGL_NV_conditional_render_NAME';
  //
  GL_QUERY_WAIT_NV              = $8E13;
  GL_QUERY_NO_WAIT_NV           = $8E14;
  GL_QUERY_BY_REGION_WAIT_NV    = $8E15;
  GL_QUERY_BY_REGION_NO_WAIT_NV = $8E16;

// PROC PROTOTYPES
type PFNGLBEGINCONDITIONALRENDERNVPROC = procedure(id: GLuint;
  mode: GLenum); stdcall;
type PFNGLENDCONDITIONALRENDERNVPROC = procedure(); stdcall;

// PROC VARIABLE POINTERS
var
  glBeginConditionalRenderNV: PFNGLBEGINCONDITIONALRENDERNVPROC;
  glEndConditionalRenderNV:   PFNGLENDCONDITIONALRENDERNVPROC;
// End NV Conditional render ***************************************************


// ARB Color buffer float ******************************************************
{$DEFINE GL_ARB_color_buffer_float}
{$DEFINE WGL_ARB_color_buffer_float}
{$DEFINE GLX_ARB_color_buffer_float}
const
  GL_ARB_color_buffer_float_str = 'GL_ARB_color_buffer_float';
  WGL_ARB_color_buffer_float_str = 'WGL_ARB_color_buffer_float';
  GLX_ARB_color_buffer_float_str = 'GLX_ARB_color_buffer_float';
  //
  GL_RGBA_FLOAT_MODE      = $8820;
  GL_CLAMP_VERTEX_COLOR   = $891A;
  GL_CLAMP_FRAGMENT_COLOR = $891B;
  GL_CLAMP_READ_COLOR     = $891C;
  GL_FIXED_ONLY           = $891D;
  GL_WGL_TYPE_RGBA_FLOAT  = $21A0;
  GL_GLX_RGBA_FLOAT_TYPE  = $20B9;
  GL_GLX_RGBA_FLOAT_BIT   = $00000004;

// PROC PROTOTYPES
type PFNGLCLAMPCOLORARBPROC = procedure(target, clamp: GLenum); stdcall;

// PROC VARIABLE POINTERS
var
  glClampColorARB: PFNGLCLAMPCOLORARBPROC;
// End ARB Color buffer float **************************************************


// NV Depth buffer float *******************************************************
{$DEFINE GL_NV_depth_buffer_float}
const
  GL_NV_depth_buffer_float_str = 'GL_NV_depth_buffer_float';
  //
  GL_DEPTH_COMPONENT32F_NV              = $8DAB;
	GL_DEPTH32F_STENCIL8_NV               = $8DAC;
	GL_FLOAT_32_UNSIGNED_INT_24_8_REV_NV  = $8DAD;
	GL_DEPTH_BUFFER_FLOAT_MODE_NV         = $8DAF;

// PROC PROTOTYPES
type PFNGLDEPTHRANGEDNVPROC = procedure(n, f: GLdouble); stdcall;
type PFNGLCLEARDEPTHDNVPROC = procedure(d: GLdouble); stdcall;
type PFNGLDEPTHBOUNDSDNVPROC = procedure(zmin, zmax: GLdouble); stdcall;

// PROC VARIABLE POINTERS
var
  glDepthRangedNV:  PFNGLDEPTHRANGEDNVPROC;
  glClearDepthdNV:  PFNGLCLEARDEPTHDNVPROC;
  glDepthBoundsdNV: PFNGLDEPTHBOUNDSDNVPROC;
// End NV Depth buffer float ***************************************************


// ARB Texture float ***********************************************************
{$DEFINE GL_ARB_texture_float}
const
  GL_ARB_texture_float_str = 'GL_ARB_texture_float';
  //
  GL_TEXTURE_RED_TYPE       = $8C10;
  GL_TEXTURE_GREEN_TYPE     = $8C11;
  GL_TEXTURE_BLUE_TYPE      = $8C12;
  GL_TEXTURE_ALPHA_TYPE     = $8C13;
  GL_TEXTURE_LUMINANCE_TYPE = $8C14;
  GL_TEXTURE_INTENSITY_TYPE = $8C15;
  GL_TEXTURE_DEPTH_TYPE     = $8C16;
  GL_UNSIGNED_NORMALIZED    = $8C17;
  GL_RGBA32F                = $8814;
  GL_RGB32F                 = $8815;
  GL_ALPHA32F               = $8816;
  GL_INTENSITY32F           = $8817;
  GL_LUMINANCE32F           = $8818;
  GL_LUMINANCE_ALPHA32F     = $8819;
  GL_RGBA16F                = $881A;
  GL_RGB16F                 = $881B;
  GL_ALPHA16F               = $881C;
  GL_INTENSITY16F           = $881D;
  GL_LUMINANCE16F           = $881E;
  GL_LUMINANCE_ALPHA16F     = $881F;

// End ARB Texture float *******************************************************


// EXT Packed float ************************************************************
{$DEFINE GL_EXT_packed_float}
{$DEFINE WGL_EXT_packed_float}
{$DEFINE GLX_EXT_packed_float}
const
  GL_EXT_packed_float_str = 'GL_EXT_packed_float';
  WGL_EXT_packed_float_str = 'WGL_EXT_packed_float';
  GLX_EXT_packed_float_str = 'GLX_EXT_packed_float';
  //
  GL_R11F_G11F_B10F               = $8C3A;
  GL_UNSIGNED_INT_10F_11F_11F_REV = $8C3B;
  GL_RGBA_SIGNED_COMPONENTS       = $8C3C;
  WGL_TYPE_RGBA_UNSIGNED_FLOAT    = $20A8;
  GLX_RGBA_UNSIGNED_FLOAT_TYPE    = $20B1;
  GLX_RGBA_UNSIGNED_FLOAT_BIT     = $00000008;

// End EXT Packed float ********************************************************


// EXT Texture shader exponent *************************************************
{$DEFINE GL_EXT_texture_shared_exponent}
const
  GL_EXT_texture_shared_exponent_str = 'GL_EXT_texture_shared_exponent';
  //
  GL_RGB9_E5                  = $8C3D;
  GL_UNSIGNED_INT_5_9_9_9_REV = $8C3E;
  GL_TEXTURE_SHARED_SIZE      = $8C3F;

// End EXT Texture shader exponent *********************************************


// EXT Texture compression rgtc ************************************************
{$DEFINE GL_EXT_texture_compression_rgtc}
const
  GL_EXT_texture_compression_rgtc_str = 'GL_EXT_texture_compression_rgtc';
  //
  GL_COMPRESSED_RED_RGTC1               = $8DBB;
  GL_COMPRESSED_SIGNED_RED_RGTC1        = $8DBC;
  GL_COMPRESSED_RED_GREEN_RGTC2         = $8DBD;
  GL_COMPRESSED_SIGNED_RED_GREEN_RGTC2  = $8DBE;

// End EXT Texture compression rgtc ********************************************


// EXT Framebuffer sRGB ********************************************************
{$DEFINE GL_EXT_framebuffer_sRGB}
{$DEFINE GLX_EXT_framebuffer_sRGB}
{$DEFINE WGL_EXT_framebuffer_sRGB}
const
  GL_EXT_framebuffer_sRGB_str = 'GL_EXT_framebuffer_sRGB';
  GLX_EXT_framebuffer_sRGB_str = 'GLX_EXT_framebuffer_sRGB';
  WGL_EXT_framebuffer_sRGB_str = 'WGL_EXT_framebuffer_sRGB';
  //
  GLX_FRAMEBUFFER_SRGB_CAPABLE  = $20B2;
  WGL_FRAMEBUFFER_SRGB_CAPABLE  = $20A9;
  GL_FRAMEBUFFER_SRGB           = $8DB9;
  GL_FRAMEBUFFER_SRGB_CAPABLE   = $8DBA;

// End EXT Framebuffer sRGB ****************************************************


// EXT Draw buffers v2 *********************************************************
{$DEFINE GL_EXT_draw_buffers2}
const
  GL_EXT_draw_buffers2_str = 'GL_EXT_draw_buffers2';

// PROC PROTOTYPES
type PFNGLCOLORMASKINDEXEDEXTPROC = procedure(buf: GLuint;
  r, g, b, a: GLboolean); stdcall;

// PROC VARIABLE POINTERS
var
  glColorMaskIndexedEXT:    PFNGLCOLORMASKINDEXEDEXTPROC;
// End EXT Draw buffers v2 *****************************************************


// EXT Texture array ***********************************************************
{$DEFINE GL_EXT_texture_array}
const
  GL_EXT_texture_array_str = 'GL_EXT_texture_array';
  //
  GL_TEXTURE_1D_ARRAY                     = $8C18;
  GL_TEXTURE_2D_ARRAY                     = $8C1A;
  GL_PROXY_TEXTURE_2D_ARRAY               = $8C1B;
  GL_PROXY_TEXTURE_1D_ARRAY               = $8C19;
  GL_TEXTURE_BINDING_1D_ARRAY             = $8C1C;
  GL_TEXTURE_BINDING_2D_ARRAY             = $8C1D;
  GL_MAX_ARRAY_TEXTURE_LAYERS             = $88FF;
  GL_COMPARE_REF_DEPTH_TO_TEXTURE         = $884E;
  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = $8CD4;
  GL_SAMPLER_1D_ARRAY                     = $8DC0;
  GL_SAMPLER_2D_ARRAY                     = $8DC1;
  GL_SAMPLER_1D_ARRAY_SHADOW              = $8DC3;
  GL_SAMPLER_2D_ARRAY_SHADOW              = $8DC4;
  
// PROC PROTOTYPES
type PFNGLFRAMEBUFFERTEXTURELAYEREXTPROC = procedure(target, attachment: GLenum;
  texture: GLuint; level, layer: GLint); stdcall;

// PROC VARIABLE POINTERS
var
  glFramebufferTextureLayerEXT: PFNGLFRAMEBUFFERTEXTURELAYEREXTPROC;
// End EXT Texture array *******************************************************


// EXT Texture integer *********************************************************
{$DEFINE GL_EXT_texture_integer}
const
  GL_EXT_texture_integer_str = 'GL_EXT_texture_integer';
  //
  GL_RGBA_INTEGER_MODE        = $8D9E;
  GL_RGBA32UI                 = $8D70;
  GL_RGB32UI                  = $8D71;
  GL_ALPHA32UI                = $8D72;
  GL_INTENSITY32UI            = $8D73;
  GL_LUMINANCE32UI            = $8D74;
  GL_LUMINANCE_ALPHA32UI      = $8D75;
  GL_RGBA16UI                 = $8D76;
  GL_RGB16UI                  = $8D77;
  GL_ALPHA16UI                = $8D78;
  GL_INTENSITY16UI            = $8D79;
  GL_LUMINANCE16UI            = $8D7A;
  GL_LUMINANCE_ALPHA16UI      = $8D7B;
  GL_RGBA8UI                  = $8D7C;
  GL_RGB8UI                   = $8D7D;
  GL_ALPHA8UI                 = $8D7E;
  GL_INTENSITY8UI             = $8D7F;
  GL_LUMINANCE8UI             = $8D80;
  GL_LUMINANCE_ALPHA8UI       = $8D81;
  GL_RGBA32I                  = $8D82;
  GL_RGB32I                   = $8D83;
  GL_ALPHA32I                 = $8D84;
  GL_INTENSITY32I             = $8D85;
  GL_LUMINANCE32I             = $8D86;
  GL_LUMINANCE_ALPHA32I       = $8D87;
  GL_RGBA16I                  = $8D88;
  GL_RGB16I                   = $8D89;
  GL_ALPHA16I                 = $8D8A;
  GL_INTENSITY16I             = $8D8B;
  GL_LUMINANCE16I             = $8D8C;
  GL_LUMINANCE_ALPHA16I       = $8D8D;
  GL_RGBA8I                   = $8D8E;
  GL_RGB8I                    = $8D8F;
  GL_ALPHA8I                  = $8D90;
  GL_INTENSITY8I              = $8D91;
  GL_LUMINANCE8I              = $8D92;
  GL_LUMINANCE_ALPHA8I        = $8D93;
  GL_RED_INTEGER              = $8D94;
  GL_GREEN_INTEGER            = $8D95;
  GL_BLUE_INTEGER             = $8D96;
  GL_ALPHA_INTEGER            = $8D97;
  GL_RGB_INTEGER              = $8D98;
  GL_RGBA_INTEGER             = $8D99;
  GL_BGR_INTEGER              = $8D9A;
  GL_BGRA_INTEGER             = $8D9B;
  GL_LUMINANCE_INTEGER        = $8D9C;
  GL_LUMINANCE_ALPHA_INTEGER  = $8D9D;
  
// PROC PROTOTYPES
type PFNGLCLEARCOLORIIEXTPROC = procedure(r, g, b, a: GLint); stdcall;
type PFNGLCLEARCOLORIUIEXTPROC = procedure(r, g, b, a: GLuint); stdcall;
type PFNGLTEXPARAMETERIIVEXTPROC = procedure(target, pname: GLenum;
  params: PGLint); stdcall;
type PFNGLTEXPARAMETERIUIVEXTPROC = procedure(target, pname: GLenum;
  params: PGLuint); stdcall;
type PFNGLGETTEXPARAMETERIIVEXTPROC = procedure(target, pname: GLenum;
  params: PGLint); stdcall;
type PFNGLGETTEXPARAMETERIUIVEXTPROC = procedure(target, pname: GLenum;
  params: PGLuint); stdcall;

// PROC VARIABLE POINTERS
var
  glClearColorIiEXT:        PFNGLCLEARCOLORIIEXTPROC;
  glClearColorIuiEXT:       PFNGLCLEARCOLORIUIEXTPROC;
  glTexParameterIivEXT:     PFNGLTEXPARAMETERIIVEXTPROC;
  glTexParameterIuivEXT:    PFNGLTEXPARAMETERIUIVEXTPROC;
  glGetTexParameterIivEXT:  PFNGLGETTEXPARAMETERIIVEXTPROC;
  glGetTexParameterIuivEXT: PFNGLGETTEXPARAMETERIUIVEXTPROC;
// End EXT Texture integer *****************************************************


// NV Tranform feedback ********************************************************
{$DEFINE GL_NV_transform_feedback}
const
  GL_NV_transform_feedback_str = 'GL_NV_transform_feedback';
  //
  GL_TRANSFORM_FEEDBACK_BUFFER          		        = $8C8E;
  GL_TRANSFORM_FEEDBACK_BUFFER_START                = $8C84;
  GL_TRANSFORM_FEEDBACK_BUFFER_SIZE         				= $8C85;
  GL_TRANSFORM_FEEDBACK_RECORD          						= $8C86;
  GL_TRANSFORM_FEEDBACK_BUFFER_BINDING      				= $8C8F;
  GL_INTERLEAVED_ATTRIBS            								= $8C8C;
  GL_SEPARATE_ATTRIBS           										= $8C8D;
  GL_PRIMITIVES_GENERATED           								= $8C87;
  GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN					= $8C88;
  GL_RASTERIZER_DISCARD             								= $8C89;
  GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS	= $8C8A;
  GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS    		= $8C8B;
  GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS     = $8C80;
  GL_TRANSFORM_FEEDBACK_ATTRIBS         						= $8C7E;
  GL_ACTIVE_VARYINGS            										= $8C81;
  GL_ACTIVE_VARYING_MAX_LENGTH          						= $8C82;
  GL_TRANSFORM_FEEDBACK_VARYINGS        						= $8C83;
  GL_TRANSFORM_FEEDBACK_BUFFER_MODE        					= $8C7F;
  GL_BACK_PRIMARY_COLOR             								= $8C77;
  GL_BACK_SECONDARY_COLOR           								= $8C78;
  GL_TEXTURE_COORD              										= $8C79;
  GL_CLIP_DISTANCE              										= $8C7A;
  GL_VERTEX_ID              												= $8C7B;
  GL_PRIMITIVE_ID               										= $8C7C;
  GL_GENERIC_ATTRIB             										= $8C7D;
  GL_POINT_SIZE                											= $0B11;
  GL_SECONDARY_COLOR            										= $852D;
  GL_POSITION              													= $1203;
  GL_LAYER              														= $8DAA;
  
// PROC PROTOTYPES
type PFNGLBINDBUFFEROFFSETNVPROC = procedure(target: GLenum; index, buffer: GLuint;
  offset: GLintptr); stdcall;
type PFNGLTRANSFORMFEEDBACKATTRIBSNVPROC = procedure(count: GLsizei;
  const attribs: PGLint; bufferMode: GLenum); stdcall;
type PFNGLTRANSFORMFEEDBACKVARYINGSNVPROC = procedure(prog: GLuint; count: GLsizei;
  const locations: PGLint; bufferMode: GLenum); stdcall;
type PFNGLBEGINTRANSFORMFEEDBACKNVPROC = procedure(primitiveMode: GLenum); stdcall;
type PFNGLENDTRANSFORMFEEDBACKNVPROC = procedure(); stdcall;
type PFNGETVARYINGLOCATIONNVPROC = function(prog: GLuint;
  const name: PGLchar): GLint; stdcall;
type PFNGLGETACTIVEVARYINGNVPROC = procedure(prog: GLuint; index: GLuint;
  bufSize: GLsizei; length, size: PGLsizei; varType: PGLenum;
    name: PGLchar); stdcall;
type PFNGLACTIVEVARYINGNVPROC = procedure(prog: GLuint;
  const name: PGLchar); stdcall;
type PFNGLGETTRANSFORMFEEDBACKVARYINGNVPROC = procedure(prog: GLuint;
  index: GLuint; location: PGLint); stdcall;

// PROC VARIABLE POINTERS
var
  glBindBufferOffsetNV:             PFNGLBINDBUFFEROFFSETNVPROC;
  glTransformFeedbackAttribsNV:     PFNGLTRANSFORMFEEDBACKATTRIBSNVPROC;
  glTransformFeedbackVaryingsNV:    PFNGLTRANSFORMFEEDBACKVARYINGSNVPROC;
  glBeginTransformFeedbackNV:       PFNGLBEGINTRANSFORMFEEDBACKNVPROC;
  glEndTransformFeedbackNV:         PFNGLENDTRANSFORMFEEDBACKNVPROC;
  glGetVaryingLocationNV:           PFNGETVARYINGLOCATIONNVPROC;
  glGetActiveVaryingNV:             PFNGLGETACTIVEVARYINGNVPROC;
  glActiveVaryingNV:                PFNGLACTIVEVARYINGNVPROC;
  glGetTransformFeedbackVaryingNV:  PFNGLGETTRANSFORMFEEDBACKVARYINGNVPROC;
// End NV Tranform feedback ****************************************************


// Core ARB Vertex array object (VAO) ******************************************
{$DEFINE GL_ARB_vertex_array_object}
const
  GL_ARB_vertex_array_object_str = 'GL_ARB_vertex_array_object';
  //
  GL_VERTEX_ARRAY_BINDING = $85B5;
  
// PROC PROTOTYPES
type PFNGLBINDVERTEXARRAYPROC = procedure(obj: GLuint); stdcall;
type PFNGLDELETEVERTEXARRAYSPROC = procedure(n: GLsizei; const objs: PGLuint); stdcall;
type PFNGLGENVERTEXARRAYSPROC = procedure(n: GLsizei; const objs: PGLuint); stdcall;
type PFNGLISVERTEXARRAYPROC = function(obj: GLuint): GLboolean; stdcall;
type PFNGLVERTEXATTRIBIPOINTERPROC = procedure(index: GLuint; size: GLint;
  attribType: GLenum; stride: GLsizei; const data: PGLvoid); stdcall;

// PROC VARIABLE POINTERS
var
  glBindVertexArray:      PFNGLBINDVERTEXARRAYPROC;
  glDeleteVertexArrays:   PFNGLDELETEVERTEXARRAYSPROC;
  glGenVertexArrays:      PFNGLGENVERTEXARRAYSPROC;
  glIsVertexArray:        PFNGLISVERTEXARRAYPROC;
  glVertexAttribIPointer: PFNGLVERTEXATTRIBIPOINTERPROC;
// End Core ARB Vertex array object (VAO) **************************************


// Core ARB Framebuffer object (FBO) *******************************************
{$DEFINE GL_ARB_framebuffer_object}
const
  GL_ARB_framebuffer_object_str = 'GL_ARB_framebuffer_object';
  //
  GL_FRAMEBUFFER                                    = $8D40;
  GL_READ_FRAMEBUFFER                               = $8CA8;
  GL_DRAW_FRAMEBUFFER                               = $8CA9;
  GL_RENDERBUFFER                                   = $8D41;
  GL_STENCIL_INDEX1                                 = $8D46;
  GL_STENCIL_INDEX4                                 = $8D47;
  GL_STENCIL_INDEX8                                 = $8D48;
  GL_STENCIL_INDEX16                                = $8D49;
  GL_RENDERBUFFER_WIDTH                             = $8D42;
  GL_RENDERBUFFER_HEIGHT                            = $8D43;
  GL_RENDERBUFFER_INTERNAL_FORMAT                   = $8D44;
  GL_RENDERBUFFER_RED_SIZE                          = $8D50;
  GL_RENDERBUFFER_GREEN_SIZE                        = $8D51;
  GL_RENDERBUFFER_BLUE_SIZE                         = $8D52;
  GL_RENDERBUFFER_ALPHA_SIZE                        = $8D53;
  GL_RENDERBUFFER_DEPTH_SIZE                        = $8D54;
  GL_RENDERBUFFER_STENCIL_SIZE                      = $8D55;
  GL_RENDERBUFFER_SAMPLES                           = $8CAB;
  GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE             = $8CD0;
  GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME             = $8CD1;
  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL           = $8CD2;
  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE   = $8CD3;
  GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING          = $8210;
  GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE          = $8211;
  GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE                = $8212;
  GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE              = $8213;
  GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE               = $8214;
  GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE              = $8215;
  GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE              = $8216;
  GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE            = $8217;
  GL_FRAMEBUFFER_DEFAULT                            = $8218;
  GL_INDEX                                          = $8222;
  GL_COLOR_ATTACHMENT0                              = $8CE0;
  GL_COLOR_ATTACHMENT1                              = $8CE1;
  GL_COLOR_ATTACHMENT2                              = $8CE2;
  GL_COLOR_ATTACHMENT3                              = $8CE3;
  GL_COLOR_ATTACHMENT4                              = $8CE4;
  GL_COLOR_ATTACHMENT5                              = $8CE5;
  GL_COLOR_ATTACHMENT6                              = $8CE6;
  GL_COLOR_ATTACHMENT7                              = $8CE7;
  GL_COLOR_ATTACHMENT8                              = $8CE8;
  GL_COLOR_ATTACHMENT9                              = $8CE9;
  GL_COLOR_ATTACHMENT10                             = $8CEA;
  GL_COLOR_ATTACHMENT11                             = $8CEB;
  GL_COLOR_ATTACHMENT12                             = $8CEC;
  GL_COLOR_ATTACHMENT13                             = $8CED;
  GL_COLOR_ATTACHMENT14                             = $8CEE;
  GL_COLOR_ATTACHMENT15                             = $8CEF;
  GL_DEPTH_ATTACHMENT                               = $8D00;
  GL_STENCIL_ATTACHMENT                             = $8D20;
  GL_DEPTH_STENCIL_ATTACHMENT                       = $821A;
  GL_MAX_SAMPLES                                    = $8D57;
  GL_FRAMEBUFFER_BINDING                            = $8CA6;
  GL_DRAW_FRAMEBUFFER_BINDING                       = $8CA6;
  GL_READ_FRAMEBUFFER_BINDING                       = $8CAA;
  GL_RENDERBUFFER_BINDING                           = $8CA7;
  GL_MAX_COLOR_ATTACHMENTS                          = $8CDF;
  GL_MAX_RENDERBUFFER_SIZE                          = $84E8;
  GL_FRAMEBUFFER_COMPLETE                           = $8CD5;
  GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT              = $8CD6;
  GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT      = $8CD7;
  GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER             = $8CDB;
  GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER             = $8CDC;
  GL_FRAMEBUFFER_UNSUPPORTED                        = $8CDD;
  GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE             = $8D56;
  GL_FRAMEBUFFER_UNDEFINED                          = $8219;
  GL_INVALID_FRAMEBUFFER_OPERATION                  = $0506;
  GL_DEPTH_STENCIL                                  = $84F9;
  GL_UNSIGNED_INT_24_8                              = $84FA;
  GL_DEPTH24_STENCIL8                               = $88F0;
  GL_TEXTURE_STENCIL_SIZE                           = $88F1;
  
// PROC PROTOTYPES
type PFNGLBINDRENDERBUFFERPROC = procedure(target: GLenum;
  renderbuffer: GLuint); stdcall;
type PFNGLDELETERENDERBUFFERSPROC = procedure(n: GLsizei;
  const renderbuffers: PGLuint); stdcall;
type PFNGLGENRENDERBUFFERSPROC = procedure(n: GLsizei;
  renderbuffers: PGLuint); stdcall;
type PFNGLISRENDERBUFFERPROC = function(renderbuffer: GLuint): GLboolean; stdcall;
type PFNGLRENDERBUFFERSTORAGEPROC = procedure(target, internalFmt: GLenum;
  width, height: GLsizei); stdcall;
type PFNGLRENDERBUFFERSTORAGEMULTISAMPLEPROC = procedure(target: GLenum;
  samples: GLsizei; internalFmt: GLenum; width, height: GLsizei); stdcall;
type PFNGLGETRENDERBUFFERPARAMETERIVPROC = procedure(target, pname: GLenum;
  params: PGLint); stdcall;
type PFNGLBINDFRAMEBUFFERPROC = procedure(target: GLenum;
  framebuffer: GLuint); stdcall;
type PFNGLDELETEFRAMEBUFFERSPROC = procedure(n: GLsizei;
  const framebuffers: PGLuint); stdcall;
type PFNGLGENFRAMEBUFFERSPROC = procedure(n: GLsizei;
  framebuffers: PGLuint); stdcall;
type PFNGLISFRAMEBUFFERPROC = function(framebuffer: GLuint): GLboolean; stdcall;
type PFNGLFRAMEBUFFERTEXTURE1DPROC = procedure(target, attachment, textarget: GLenum;
  texture: GLuint; level: GLint); stdcall;
type PFNGLFRAMEBUFFERTEXTURE2DPROC = procedure(target, attachment, textarget: GLenum;
  texture: GLuint; level: GLint); stdcall;
type PFNGLFRAMEBUFFERTEXTURE3DPROC = procedure(target, attachment, textarget: GLenum;
  texture: GLuint; level, layer: GLint); stdcall;

type PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC = procedure(target: GLenum;
  attachment, pname: GLenum; params: PGLint); stdcall;
type PFNGLCHECKFRAMEBUFFERSTATUSPROC = function(target: GLenum): GLenum; stdcall;
type PFNGLBLITFRAMEBUFFERPROC = procedure(srcX0, srcY0, srcX1, srcY1, dstX0,
  dstY0, dstX1, dstY1: GLint; mask: GLbitfield; filter: GLenum); stdcall;

type PFNGLFRAMEBUFFERRENDERBUFFERPROC = procedure(target, attachment,
  renderbuffertarget: GLenum; renderbuffer: GLuint); stdcall;
type PFNGLGENERATEMIPMAPPROC = procedure(target: GLenum); stdcall;

// PROC VARIABLE POINTERS
var
  glBindRenderbuffer:                     PFNGLBINDRENDERBUFFERPROC;
  glDeleteRenderbuffers:                  PFNGLDELETERENDERBUFFERSPROC;
  glGenRenderbuffers:                     PFNGLGENRENDERBUFFERSPROC;
	glIsRenderbuffer:                       PFNGLISRENDERBUFFERPROC;
  glRenderbufferStorage:                  PFNGLRENDERBUFFERSTORAGEPROC;
  glRenderbufferStorageMultisample:       PFNGLRENDERBUFFERSTORAGEMULTISAMPLEPROC;
  glGetRenderbufferParameteriv:           PFNGLGETRENDERBUFFERPARAMETERIVPROC;
  glBindFramebuffer:                      PFNGLBINDFRAMEBUFFERPROC;
  glDeleteFramebuffers:                   PFNGLDELETEFRAMEBUFFERSPROC;
  glGenFramebuffers:                      PFNGLGENFRAMEBUFFERSPROC;
	glIsFramebuffer:                        PFNGLISFRAMEBUFFERPROC;
  glFramebufferTexture1D:                 PFNGLFRAMEBUFFERTEXTURE1DPROC;
  glFramebufferTexture2D:                 PFNGLFRAMEBUFFERTEXTURE2DPROC;
  glFramebufferTexture3D:                 PFNGLFRAMEBUFFERTEXTURE3DPROC;
  glGetFramebufferAttachmentParameteriv:  PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC;
	glCheckFramebufferStatus:               PFNGLCHECKFRAMEBUFFERSTATUSPROC;
  glBlitFramebuffer:                      PFNGLBLITFRAMEBUFFERPROC;
  glFramebufferRenderbuffer:              PFNGLFRAMEBUFFERRENDERBUFFERPROC;
  glGenerateMipmap:                       PFNGLGENERATEMIPMAPPROC;
// End Core ARB Framebuffer object (FBO) ***************************************


// NV Half float ***************************************************************
{$DEFINE GL_NV_half_float}
const
  GL_NV_half_float_str = 'GL_NV_half_float';
  //
  GL_HALF_FLOAT = $140B;

// End NV Half float ***********************************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 3.1 Extensions    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_3_1}


// ARB Texture rectangle *******************************************************
{$DEFINE GL_ARB_texture_rectangle}
const
  GGL_ARB_texture_rectangle_str = 'GL_ARB_texture_rectangle';
  //
  GL_TEXTURE_RECTANGLE            = $84F5;
  GL_TEXTURE_BINDING_RECTANGLE    = $84F6;
  GL_PROXY_TEXTURE_RECTANGLE      = $84F7;
  GL_MAX_RECTANGLE_TEXTURE_SIZE   = $84F8;

// End ARB Texture rectangle ***************************************************


// ARB Texture buffer object (TBO) *********************************************
{$DEFINE GL_ARB_texture_buffer_object}
const
  GL_ARB_texture_buffer_object_str = 'GL_ARB_texture_buffer_object';
  //
  GL_TEXTURE_BUFFER                     = $8C2A;
  GL_MAX_TEXTURE_BUFFER_SIZE            = $8C2B;
  GL_TEXTURE_BINDING_BUFFER             = $8C2C;
  GL_TEXTURE_BUFFER_DATA_STORE_BINDING  = $8C2D;
  GL_TEXTURE_BUFFER_FORMAT              = $8C2E;
  
// PROC PROTOTYPES
type PFNGLTEXBUFFERARBPROC = procedure(target, internalFmt: GLenum;
  buffer: GLuint); stdcall;

// PROC VARIABLE POINTERS
var
  glTexBufferARB: PFNGLTEXBUFFERARBPROC;  
// End ARB Texture buffer object (TBO) *****************************************


// NV Primitive restart ********************************************************
{$DEFINE GL_NV_primitive_restart}
const
  GL_NV_primitive_restart_str = 'GL_NV_primitive_restart';
  //
  GL_PRIMITIVE_RESTART        = $8558;
  GL_PRIMITIVE_RESTART_INDEX  = $8559;
  
// PROC PROTOTYPES
type PFNGLPRIMIVITERESTARTNVPROC = procedure(); stdcall;
type PFNGLPRIMIVITERESTARTINDEXNVPROC = procedure(index: GLuint); stdcall;

// PROC VARIABLE POINTERS
var
  glPrimitiveRestartNV:       PFNGLPRIMIVITERESTARTNVPROC;
  glPrimitiveRestartIndexNV:  PFNGLPRIMIVITERESTARTINDEXNVPROC;
// End NV Primitive restart ****************************************************


// ARB Draw instanced **********************************************************
{$DEFINE GL_ARB_draw_instanced}
const
  GL_ARB_draw_instanced_str = 'GL_ARB_draw_instanced';
  
// PROC PROTOTYPES
type PFNGLDRAWARRAYSINSTANCEDARBPROC = procedure(mode: GLenum; first: GLint;
  count, primcount: GLsizei); stdcall;
type PFNGLDRAWELEMENTSINSTANCEDARBPROC = procedure(mode: GLenum; count: GLsizei;
  indexType: GLenum; const indices: PGLvoid; primcount: GLsizei); stdcall;

// PROC VARIABLE POINTERS
var
  glDrawArraysInstancedARB:   PFNGLDRAWARRAYSINSTANCEDARBPROC;
  glDrawElementsInstancedARB: PFNGLDRAWELEMENTSINSTANCEDARBPROC;
// End ARB Draw instanced ******************************************************


// Core ARB Copy buffer ********************************************************
{$DEFINE GL_ARB_copy_buffer}
const
  GL_ARB_copy_buffer_str = 'GL_ARB_copy_buffer';
  //
  GL_COPY_READ_BUFFER   = $8F36;
  GL_COPY_WRITE_BUFFER  = $8F37;
  
// PROC PROTOTYPES
type PFNGLCOPYBUFFERSUBDATAARBPROC = procedure(src, dest: GLenum;
  srcOffset, destOffset: GLintptr; copySize: GLsizeiptr); stdcall;

// PROC VARIABLE POINTERS
var
  glCopyBufferSubData:  PFNGLCOPYBUFFERSUBDATAARBPROC;
// End Core ARB Copy buffer ****************************************************


// Core ARB Uniform buffer object (UBO) ****************************************
{$DEFINE GL_ARB_uniform_buffer_object}
const
  GL_ARB_uniform_buffer_object_str = 'GL_ARB_uniform_buffer_object';
  //
  GL_UNIFORM_BUFFER                               = $8A11;
  GL_UNIFORM_BUFFER_BINDING                       = $8A28;
  GL_UNIFORM_BUFFER_START                         = $8A29;
  GL_UNIFORM_BUFFER_SIZE                          = $8A2A;
  GL_MAX_VERTEX_UNIFORM_BLOCKS                    = $8A2B;
  GL_MAX_GEOMETRY_UNIFORM_BLOCKS                  = $8A2C;
  GL_MAX_FRAGMENT_UNIFORM_BLOCKS                  = $8A2D;
  GL_MAX_COMBINED_UNIFORM_BLOCKS                  = $8A2E;
  GL_MAX_UNIFORM_BUFFER_BINDINGS                  = $8A2F;
  GL_MAX_UNIFORM_BLOCK_SIZE                       = $8A30;
  GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS       = $8A31;
  GL_MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS     = $8A32;
  GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS     = $8A33;
  GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT              = $8A34;
  GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH         = $8A35;
  GL_ACTIVE_UNIFORM_BLOCKS                        = $8A36;
  GL_UNIFORM_TYPE                                 = $8A37;
  GL_UNIFORM_SIZE                                 = $8A38;
  GL_UNIFORM_NAME_LENGTH                          = $8A39;
  GL_UNIFORM_BLOCK_INDEX                          = $8A3A;
  GL_UNIFORM_OFFSET                               = $8A3B;
  GL_UNIFORM_ARRAY_STRIDE                         = $8A3C;
  GL_UNIFORM_MATRIX_STRIDE                        = $8A3D;
  GL_UNIFORM_IS_ROW_MAJOR                         = $8A3E;
  GL_UNIFORM_BLOCK_BINDING                        = $8A3F;
  GL_UNIFORM_BLOCK_DATA_SIZE                      = $8A40;
  GL_UNIFORM_BLOCK_NAME_LENGTH                    = $8A41;
  GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS                = $8A42;
  GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES         = $8A43;
  GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER    = $8A44;
  GL_UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER  = $8A45;
  GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER  = $8A46;
  GL_INVALID_INDEX                                = $FFFFFFFF;
  
// PROC PROTOTYPES
type PFNGLGETUNIFORMINDICESPROC = procedure(progObj: GLuint; uniformCount: GLsizei;
  const uniformNames: PPGLchar; uniformIndices: PGLint); stdcall;
type PFNGLGETACTIVEUNIFORMSIVPROC = procedure(progObj: GLuint; uniformCount: GLsizei;
  const uniformIndices: PGLint; pname: GLenum; params: PGLint); stdcall;
type PFNGLGETACTIVEUNIFORMNAMEPROC = procedure(progObj, uniformIndex: GLuint;
  bufSize: GLsizei; length: PGLsizei; uniformName: PGLchar); stdcall;
type PFNGLGETUNIFORMBLOCKINDEXPROC = function(progObj: GLuint;
  const uniformBlockName: PGLchar): GLuint; stdcall;
type PFNGLGETACTIVEUNIFORMBLOCKIVPROC = procedure(progObj, uniformBlockIndex: GLuint;
  pname: GLenum; params: PGLint); stdcall;
type PFNGLGETACTIVEUNIFORMBLOCKNAMEPROC = procedure(progObj, uniformBlockIndex: GLuint;
  bufSize: GLsizei; length: PGLsizei; uniformBlockName: PGLchar); stdcall;
type PFNGLBINDBUFFERRANGEPROC = procedure(target: GLenum; index, buffer: GLuint;
  offset: GLintptr; size: GLsizeiptr); stdcall;
type PFNGLBINDBUFFERBASEPROC = procedure(target: GLenum; index, buffer: GLuint); stdcall;
type PFNGLGETINTEGERI_VPROC = procedure(target: GLenum; index: GLuint;
  data: PGLint); stdcall;
type PFNGLUNIFORMBLOCKBINDINGPROC = procedure(progObj, uniformBlockIndex,
  uniformBlockBinding: GLuint); stdcall;

// PROC VARIABLE POINTERS
var
  glGetUniformIndices:          PFNGLGETUNIFORMINDICESPROC;
  glGetActiveUniformsiv:        PFNGLGETACTIVEUNIFORMSIVPROC;
  glGetActiveUniformName:       PFNGLGETACTIVEUNIFORMNAMEPROC;
  glGetUniformBlockIndex:       PFNGLGETUNIFORMBLOCKINDEXPROC;
  glGetActiveUniformBlockiv:    PFNGLGETACTIVEUNIFORMBLOCKIVPROC;
  glGetActiveUniformBlockName:  PFNGLGETACTIVEUNIFORMBLOCKNAMEPROC;
  glBindBufferRange:            PFNGLBINDBUFFERRANGEPROC;
  glBindBufferBase:             PFNGLBINDBUFFERBASEPROC;
  glGetIntegeri_v:              PFNGLGETINTEGERI_VPROC;
  glUniformBlockBinding:        PFNGLUNIFORMBLOCKBINDINGPROC;
// End Core ARB Uniform buffer object (UBO) ************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 3.2 Extensions    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_3_2}


// Core ARB Draw elements base vertex ******************************************
{$DEFINE GL_ARB_draw_elements_base_vertex}
const
  GL_ARB_draw_elements_base_vertex_str = 'GL_ARB_draw_elements_base_vertex';
  
// PROC PROTOTYPES
type PFNGLDRAWELEMENTSBASEVERTEXPROC = procedure(mode: GLenum; count: GLsizei;
  indexType: GLenum; const indices: PGLvoid; baseVertex: GLint); stdcall;
type PFNGLDRAWRANGEELEMENTSBASEVERTEXPROC = procedure(mode: GLenum;
  indexStart, indexEnd: GLuint; count: GLsizei; indexType: GLenum;
  const indices: PGLvoid; baseVertex: GLint); stdcall;
type PFNGLDRAWELEMENTSINSTANCEDBASEVERTEXPROC = procedure(mode: GLenum;
  count: GLsizei; indexType: GLenum; const indices: PGLvoid; instanceCount: GLsizei;
  baseVertex: GLint); stdcall;
type PFNGLMULTIDRAWELEMENTSBASEVERTEXPROC = procedure(mode: GLenum;
  const count: PGLsizei; indexType: GLenum; const indices: PPGLvoid;
  drawCOunt: GLsizei; const baseVertex: PGLint); stdcall;

// PROC VARIABLE POINTERS
var
  glDrawElementsBaseVertex:           PFNGLDRAWELEMENTSBASEVERTEXPROC;
  glDrawRangeElementsBaseVertex:      PFNGLDRAWRANGEELEMENTSBASEVERTEXPROC;
  glDrawElementsInstancedBaseVertex:  PFNGLDRAWELEMENTSINSTANCEDBASEVERTEXPROC;
  glMultiDrawElementsBaseVertex:      PFNGLMULTIDRAWELEMENTSBASEVERTEXPROC;
// End Core ARB Draw elements base vertex **************************************


// Core ARB Provoking vertex ***************************************************
{$DEFINE GL_ARB_provoking_vertex}
const
  GL_ARB_provoking_vertex_str = 'GL_ARB_provoking_vertex';
  //
  GL_FIRST_VERTEX_CONVENTION                  = $8E4D;
  GL_LAST_VERTEX_CONVENTION                   = $8E4E;
  GL_PROVOKING_VERTEX                         = $8E4F;
  GL_QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION = $8E4C;
  
// PROC PROTOTYPES
type PFNGLPROVOKINGVERTEXPROC = procedure(node: GLenum); stdcall;

// PROC VARIABLE POINTERS
var
  glProvokingVertex: PFNGLPROVOKINGVERTEXPROC;
// End Core ARB Provoking vertex ***********************************************


// Core ARB Seampless cubemap **************************************************
{$DEFINE GL_ARB_seamless_cube_map}
const
  GL_ARB_seamless_cube_map_str = 'GL_ARB_seamless_cube_map';
  //
  GL_TEXTURE_CUBE_MAP_SEAMLESS = $884F;
  
// End Core ARB Seampless cubemap **********************************************


// Core ARB Texture multisample ************************************************
{$DEFINE GL_ARB_texture_multisample}
const
  GL_ARB_texture_multisample_str = 'GL_ARB_texture_multisample';
  //
  GL_SAMPLE_POSITION                            = $8E50;
  GL_SAMPLE_MASK                                = $8E51;
  GL_SAMPLE_MASK_VALUE                          = $8E52;
  GL_TEXTURE_2D_MULTISAMPLE                     = $9100;
  GL_PROXY_TEXTURE_2D_MULTISAMPLE               = $9101;
  GL_TEXTURE_2D_MULTISAMPLE_ARRAY               = $9102;
  GL_PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY         = $9103;
  GL_MAX_SAMPLE_MASK_WORDS                      = $8E59;
  GL_MAX_COLOR_TEXTURE_SAMPLES                  = $910E;
  GL_MAX_DEPTH_TEXTURE_SAMPLES                  = $910F;
  GL_MAX_INTEGER_SAMPLES                        = $9110;
  GL_TEXTURE_BINDING_2D_MULTISAMPLE             = $9104;
  GL_TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY       = $9105;
  GL_TEXTURE_SAMPLES                            = $9106;
  GL_TEXTURE_FIXED_SAMPLE_LOCATIONS             = $9107;
  GL_SAMPLER_2D_MULTISAMPLE                     = $9108;
  GL_INT_SAMPLER_2D_MULTISAMPLE                 = $9109;
  GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE        = $910A;
  GL_SAMPLER_2D_MULTISAMPLE_ARRAY               = $910B;
  GL_INT_SAMPLER_2D_MULTISAMPLE_ARRAY           = $910C;
  GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY  = $910D;
  
// PROC PROTOTYPES
type PFNGLTEXIMAGE2DMULTISAMPLEPROC = procedure(target: GLenum; samples:
  GLsizei; internalFmt: GLenum; width, height: GLsizei; fixedSampleLocations: GLboolean); stdcall;
type PFNGLTEXIMAGE3DMULTISAMPLEPROC = procedure(target: GLenum; samples:
  GLsizei; internalFmt: GLenum; width, height: GLsizei; depth: GLsizei;
  fixedSampleLocations: GLboolean); stdcall;
type PFNGLGETMULTISAMPLEFVPROC = procedure(pname: GLenum; index: GLuint;
  val: PGLfloat); stdcall;
type PFNGLSAMPLEMASKIPROC = procedure(index: GLuint; mask: GLbitfield); stdcall;

// PROC VARIABLE POINTERS
var
  glTexImage2DMultisample:  PFNGLTEXIMAGE2DMULTISAMPLEPROC;
  glTexImage3DMultisample:  PFNGLTEXIMAGE3DMULTISAMPLEPROC;
  glGetMultisamplefv:       PFNGLGETMULTISAMPLEFVPROC;
  glSampleMaski:            PFNGLSAMPLEMASKIPROC;
// End Core ARB Texture multisample ********************************************


// Core ARB Depth clamp ********************************************************
{$DEFINE GL_ARB_depth_clamp}
const
  GL_ARB_depth_clamp_str = 'GL_ARB_depth_clamp';
  //
  GL_DEPTH_CLAMP = $864F;
  
// End Core ARB Depth clamp ****************************************************


// Core ARB Sync ***************************************************************
{$DEFINE GL_ARB_sync}
const
  GL_ARB_sync_str = 'GL_ARB_sync';
  //
  GL_MAX_SERVER_WAIT_TIMEOUT    = $9111;
  GL_SYNC_OBJECT_TYPE           = $9112;
  GL_SYNC_CONDITION             = $9113;
  GL_SYNC_STATUS                = $9114;
  GL_SYNC_FLAGS                 = $9115;
  GL_SYNC_FENCE                 = $9116;
  GL_SYNC_GPU_COMMANDS_COMPLETE = $9117;
  GL_UNSIGNALED                 = $9118;
  GL_SIGNALED                   = $9119;
  GL_SYNC_FLUSH_COMMANDS_BIT    = $00000001;
  GL_TIMEOUT_IGNORED            = Int64($FFFFFFFFFFFFFFFF);
  GL_ALREADY_SIGNALED           = $911A;
  GL_TIMEOUT_EXPIRED            = $911B;
  GL_CONDITION_SATISFIED        = $911C;
  GL_WAIT_FAILED                = $911D;
  
// PROC PROTOTYPES
type PFNGLFENCESYNCPROC = function(condition: GLenum;
  flags: GLbitfield): GLsync; stdcall;
type PFNGLISSYNCPROC = function(sync: GLsync): GLboolean; stdcall;
type PFNGLDELETESYNCPROC = procedure(sync: GLsync); stdcall;
type PFNGLCLIENTWAITSYNCPROC = function(sync: GLsync; flags: GLbitfield;
  timeout: GLuint64): GLenum; stdcall;
type PFNGLWAITSYNCPROC = procedure(sync: GLsync; flags: GLbitfield;
  timeout: GLuint64); stdcall;
type PFNGLGETINTEGER64VPROC = procedure(pname: GLenum; params: PGLint64); stdcall;
type PFNGLGETSYNCIVPROC = procedure(sync: GLsync; pname: GLenum;
  bufSize: GLsizei; length: PGLsizei; values: PGLint); stdcall;

// PROC VARIABLE POINTERS
var
  glFenceSync:      PFNGLFENCESYNCPROC;
  glIsSync:         PFNGLISSYNCPROC;
  glDeleteSync:     PFNGLDELETESYNCPROC;
  glClientWaitSync: PFNGLCLIENTWAITSYNCPROC;
  glWaitSync:       PFNGLWAITSYNCPROC;
  glGetInteger64v:  PFNGLGETINTEGER64VPROC;
  glGetSynciv:      PFNGLGETSYNCIVPROC;
// End Core ARB Sync ***********************************************************


// ARB Geometry shader 4 *******************************************************
{$DEFINE GL_ARB_geometry_shader4}
const
  GL_ARB_geometry_shader4_str = 'GL_ARB_geometry_shader4';
  //
  GL_GEOMETRY_SHADER                      = $8DD9;
  GL_GEOMETRY_VERTICES_OUT                = $8DDA;
  GL_GEOMETRY_INPUT_TYPE                  = $8DDB;
  GL_GEOMETRY_OUTPUT_TYPE                 = $8DDC;
  GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS     = $8C29;
  GL_MAX_GEOMETRY_VARYING_COMPONENTS      = $8DDD;
  GL_MAX_VERTEX_VARYING_COMPONENTS        = $8DDE;
  GL_MAX_VARYING_COMPONENTS               = $8B4B;
  GL_MAX_GEOMETRY_UNIFORM_COMPONENTS      = $8DDF;
  GL_MAX_GEOMETRY_OUTPUT_VERTICES         = $8DE0;
  GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS = $8DE1;
  GL_LINES_ADJACENCY                      = $A;
  GL_LINE_STRIP_ADJACENCY                 = $B;
  GL_TRIANGLES_ADJACENCY                  = $C;
  GL_TRIANGLE_STRIP_ADJACENCY             = $D;
  GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS = $8DA8;
  GL_FRAMEBUFFER_INCOMPLETE_LAYER_COUNT   = $8DA9;
  GL_FRAMEBUFFER_ATTACHMENT_LAYERED       = $8DA7;
  GL_PROGRAM_POINT_SIZE                   = $8642;
  
// PROC PROTOTYPES
type PFNGLPROGRAMPARAMETERIARBPROC = procedure(prog: GLuint; pname: GLenum;
  value: GLint); stdcall;
type PFNGLFRAMEBUFFERTEXTUREARBPROC = procedure(target, attachment: GLenum;
  texture: GLuint; level: GLint); stdcall;
type PFNGLFRAMEBUFFERTEXTURELAYERARBPROC = procedure(target, attachment: GLenum;
  texture: GLuint; level, layer: GLint); stdcall;
type PFNGLFRAMEBUFFERTEXTUREFACEARBPROC = procedure(target, attachment: GLenum;
  texture: GLuint; level: GLint; face: GLenum); stdcall;

// PROC VARIABLE POINTERS
var
  glProgramParameteriARB:       PFNGLPROGRAMPARAMETERIARBPROC;
  glFramebufferTextureARB:      PFNGLFRAMEBUFFERTEXTUREARBPROC;
  glFramebufferTextureLayerARB: PFNGLFRAMEBUFFERTEXTURELAYERARBPROC;
  glFramebufferTextureFaceARB:  PFNGLFRAMEBUFFERTEXTUREFACEARBPROC;
// End ARB Geometry shader 4 ***************************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 3.3 Extensions    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_3_3}


// Core ARB Blend func extended ************************************************
{$DEFINE GL_ARB_blend_func_extended}
const
  GL_ARB_blend_func_extended_str = 'GL_ARB_blend_func_extended';
  //
  GL_SRC1_COLOR                   = $88F9;
  GL_SRC1_ALPHA                   = $8589;
  GL_ONE_MINUS_SRC1_COLOR         = $88FA;
  GL_ONE_MINUS_SRC1_ALPHA         = $88FB;
	GL_MAX_DUAL_SOURCE_DRAW_BUFFERS = $88FC;
  
// PROC PROTOTYPES
type PFNGLBINDFRAGDATALOCATIONINDEXEDPROC = procedure(prog, colorNumber, index: GLuint;
  const name: PGLchar); stdcall;
type PFNGLGETFRAGDATAINDEXPROC = function(prog: GLuint; const name: PGLchar): GLint; stdcall;

// PROC VARIABLE POINTERS
var
  glBindFragDataLocationIndexed:  PFNGLBINDFRAGDATALOCATIONINDEXEDPROC;
  glGetFragDataIndex:             PFNGLGETFRAGDATAINDEXPROC;
// End Core ARB Blend func extended ********************************************


// Core ARB Occlusion query 2 **************************************************
{$DEFINE GL_ARB_occlusion_query2}
const
  GL_ARB_occlusion_query2_str = 'GL_ARB_occlusion_query2';
  //
  GL_ANY_SAMPLES_PASSED = $8C2F;
  
// End Core ARB Occlusion query 2 **********************************************


// Core ARB Texture swizzle ****************************************************
{$DEFINE GL_ARB_texture_swizzle}
const
  GL_ARB_texture_swizzle_str = 'GL_ARB_texture_swizzle';
  //
  GL_TEXTURE_SWIZZLE_R =    $8E42;
  GL_TEXTURE_SWIZZLE_G =    $8E43;
  GL_TEXTURE_SWIZZLE_B =    $8E44;
  GL_TEXTURE_SWIZZLE_A =    $8E45;
  GL_TEXTURE_SWIZZLE_RGBA = $8E46;

// End Core ARB Texture swizzle ************************************************


// Core ARB Texture RGB10_A2UI *************************************************
{$DEFINE GL_ARB_texture_rgb10_a2ui}
const
  GL_ARB_texture_rgb10_a2ui_str = 'GL_ARB_texture_rgb10_a2ui';
  //
  GL_RGB10_A2UI = $906F;

// End Core ARB Texture RGB10_A2UI *********************************************


// Core ARB Sampler objects ****************************************************
{$DEFINE GL_ARB_sampler_objects}
const
  GL_ARB_sampler_objects_str = 'GL_ARB_sampler_objects';
  //
  GL_SAMPLER_BINDING = $8919;
  
// PROC PROTOTYPES
type PFNGLGENSAMPLERSPROC = procedure(count: GLsizei; samplers: PGLuint); stdcall;
type PFNGLDELETESAMPLERSPROC = procedure(count: GLsizei; const samplers: PGLuint); stdcall;
type PFNGLISSAMPLERPROC = function(sampler: GLuint): GLboolean;
type PFNGLBINDSAMPLERPROC = procedure(texUnit, sampler: GLuint); stdcall;
type PFNGLSAMPLERPARAMETERIPROC = procedure(sampler: GLuint; pname: GLenum;
  param: GLint); stdcall;
type PFNGLSAMPLERPARAMETERFPROC = procedure(sampler: GLuint; pname: GLenum;
  param: GLfloat); stdcall;
type PFNGLSAMPLERPARAMETERIVPROC = procedure(sampler: GLuint; pname: GLenum;
  const params: PGLint); stdcall;
type PFNGLSAMPLERPARAMETERFVPROC = procedure(sampler: GLuint; pname: GLenum;
  const params: PGLfloat); stdcall;
type PFNGLSAMPLERPARAMETERIIVPROC = procedure(sampler: GLuint; pname: GLenum;
  const params: PGLint); stdcall;
type PFNGLSAMPLERPARAMETERIUIVPROC = procedure(sampler: GLuint; pname: GLenum;
const uparams: PGLint); stdcall;
type PFNGLGETSAMPLERPARAMETERIVPROC = procedure(sampler: GLuint; pname: GLenum;
  params: PGLint); stdcall;
type PFNGLGETSAMPLERPARAMETERFVPROC = procedure(sampler: GLuint; pname: GLenum;
  params: PGLfloat); stdcall;
type PFNGLGETSAMPLERPARAMETERIIVPROC = procedure(sampler: GLuint; pname: GLenum;
  params: PGLint); stdcall;
type PFNGLGETSAMPLERPARAMETERIUIVPROC = procedure(sampler: GLuint; pname: GLenum;
  uparams: PGLint); stdcall;

// PROC VARIABLE POINTERS
var
  glGenSamplers:              PFNGLGENSAMPLERSPROC;
  glDeleteSamplers:           PFNGLDELETESAMPLERSPROC;
  glIsSampler:                PFNGLISSAMPLERPROC;
  glBindSampler:              PFNGLBINDSAMPLERPROC;
  glSamplerParameteri:        PFNGLSAMPLERPARAMETERIPROC;
  glSamplerParameterf:        PFNGLSAMPLERPARAMETERFPROC;
  glSamplerParameteriv:       PFNGLSAMPLERPARAMETERIVPROC;
  glSamplerParameterfv:       PFNGLSAMPLERPARAMETERFVPROC;
  glSamplerParameterIiv:      PFNGLSAMPLERPARAMETERIIVPROC;
  glSamplerParameterIuiv:     PFNGLSAMPLERPARAMETERIUIVPROC;
  glGetSamplerParameteriv:    PFNGLGETSAMPLERPARAMETERIVPROC;
  glGetSamplerParameterfv:    PFNGLGETSAMPLERPARAMETERFVPROC;
  glGetSamplerParameterIiv:   PFNGLGETSAMPLERPARAMETERIIVPROC;
  glGetSamplerParameterIuiv:  PFNGLGETSAMPLERPARAMETERIUIVPROC;
// End Core ARB Sampler objects ************************************************


// Core ARB Timer query ********************************************************
{$DEFINE GL_ARB_timer_query}
const
  GL_ARB_timer_query_str = 'GL_ARB_timer_query';
  //
  GL_TIME_ELAPSED = $88BF;
  GL_TIMESTAMP    = $8E28;
  
// PROC PROTOTYPES
type PFNGLQUERYCOUNTERPROC = procedure(id: GLuint; target: GLenum); stdcall;
type PFNGLGETQUERYOBJECTI64VPROC = procedure(id: GLuint; pname: GLenum;
  params: PGLint64); stdcall;
type PFNGLGETQUERYOBJECTUI64VPROC = procedure(id: GLuint; pname: GLenum;
  params: PGLuint64); stdcall;

// PROC VARIABLE POINTERS
var
  glQueryCounter:         PFNGLQUERYCOUNTERPROC;
  glGetQueryObjecti64v:   PFNGLGETQUERYOBJECTI64VPROC;
  glGetQueryObjectui64v:  PFNGLGETQUERYOBJECTUI64VPROC;
// End Core ARB Timer query ****************************************************


// Core ARB Instanced arrays ***************************************************
{$DEFINE GL_ARB_instanced_arrays}
const
  GL_ARB_instanced_arrays_str = 'GL_ARB_instanced_arrays';
  //
  GL_VERTEX_ATTRIB_ARRAY_DIVISOR = $88FE;
  
// PROC PROTOTYPES
type PFNGLVERTEXATTRIBDIVISORARBPROC = procedure(index, divisor: GLuint); stdcall;
type PFNGLVERTEXARRAYVERTEXATTRIBDIVISOREXTPROC = procedure(
  vaoObj, index, divisor: GLuint); stdcall; // need OpenGL 4.5

// PROC VARIABLE POINTERS
var
  glVertexAttribDivisorARB:             PFNGLVERTEXATTRIBDIVISORARBPROC;
  glVertexArrayVertexAttribDivisorEXT:  PFNGLVERTEXARRAYVERTEXATTRIBDIVISOREXTPROC;
// End Core ARB Instanced arrays ***********************************************


// Core ARB Normalized vertex type INT & UINT "2_10_10_10_REV" *****************
{$DEFINE GL_ARB_vertex_type_2_10_10_10_rev}
const
  GL_ARB_vertex_type_2_10_10_10_rev_str = 'GL_ARB_vertex_type_2_10_10_10_rev';
  //
  GL_UNSIGNED_INT_2_10_10_10_REV  = $8368;
  GL_INT_2_10_10_10_REV           = $8D9F;
  
// PROC PROTOTYPES
type PFNGLVERTEXP2UIPROC = procedure(dataType: GLenum; value: GLuint); stdcall;
type PFNGLVERTEXP3UIPROC = procedure(dataType: GLenum; value: GLuint); stdcall;
type PFNGLVERTEXP4UIPROC = procedure(dataType: GLenum; value: GLuint); stdcall;
type PFNGLVERTEXP2UIVPROC = procedure(dataType: GLenum; const value: PGLuint); stdcall;
type PFNGLVERTEXP3UIVPROC = procedure(dataType: GLenum; const value: PGLuint); stdcall;
type PFNGLVERTEXP4UIVPROC = procedure(dataType: GLenum; const value: PGLuint); stdcall;
type PFNGLTEXCOORDP1UIPROC = procedure(dataType: GLenum; coords: GLuint); stdcall;
type PFNGLTEXCOORDP2UIPROC = procedure(dataType: GLenum; coords: GLuint); stdcall;
type PFNGLTEXCOORDP3UIPROC = procedure(dataType: GLenum; coords: GLuint); stdcall;
type PFNGLTEXCOORDP4UIPROC = procedure(dataType: GLenum; coords: GLuint); stdcall;
type PFNGLTEXCOORDP1UIVPROC = procedure(dataType: GLenum; const coords: PGLuint); stdcall;
type PFNGLTEXCOORDP2UIVPROC = procedure(dataType: GLenum; const coords: PGLuint); stdcall;
type PFNGLTEXCOORDP3UIVPROC = procedure(dataType: GLenum; const coords: PGLuint); stdcall;
type PFNGLTEXCOORDP4UIVPROC = procedure(dataType: GLenum; const coords: PGLuint); stdcall;
type PFNGLMULTITEXCOORDP1UIPROC = procedure(texture: GLenum; dataType: GLenum;
  coords: GLuint); stdcall;
type PFNGLMULTITEXCOORDP2UIPROC = procedure(texture: GLenum; dataType: GLenum;
  coords: GLuint); stdcall;
type PFNGLMULTITEXCOORDP3UIPROC = procedure(texture: GLenum; dataType: GLenum;
  coords: GLuint); stdcall;
type PFNGLMULTITEXCOORDP4UIPROC = procedure(texture: GLenum; dataType: GLenum;
  coords: GLuint); stdcall;
type PFNGLMULTITEXCOORDP1UIVPROC = procedure(texture: GLenum; dataType: GLenum;
  const coords: PGLuint); stdcall;
type PFNGLMULTITEXCOORDP2UIVPROC = procedure(texture: GLenum; dataType: GLenum;
  const coords: PGLuint); stdcall;
type PFNGLMULTITEXCOORDP3UIVPROC = procedure(texture: GLenum; dataType: GLenum;
  const coords: PGLuint); stdcall;
type PFNGLMULTITEXCOORDP4UIVPROC = procedure(texture: GLenum; dataType: GLenum;
  const coords: PGLuint); stdcall;
type PFNGLNORMALP3UIPROC = procedure(dataType: GLenum; coords: GLuint); stdcall;
type PFNGLNORMALP3UIVPROC = procedure(dataType: GLenum; const coords: PGLuint); stdcall;
type PFNGLCOLORP3UIPROC = procedure(dataType: GLenum; color: GLuint); stdcall;
type PFNGLCOLORP4UIPROC = procedure(dataType: GLenum; color: GLuint); stdcall;
type PFNGLCOLORP3UIVPROC = procedure(dataType: GLenum; const color: PGLuint); stdcall;
type PFNGLCOLORP4UIVPROC = procedure(dataType: GLenum; const color: PGLuint); stdcall;
type PFNGLSECONDARYCOLORP3UIPROC = procedure(dataType: GLenum; color: GLuint); stdcall;
type PFNGLSECONDARYCOLORP3UIVPROC = procedure(dataType: GLenum; const color: PGLuint); stdcall;
type PFNGLVERTEXATTRIBP1UIPROC = procedure(index: GLuint; dataType: GLenum;
  normalized: GLboolean; value: GLuint); stdcall;
type PFNGLVERTEXATTRIBP2UIPROC = procedure(index: GLuint; dataType: GLenum;
  normalized: GLboolean; value: GLuint); stdcall;
type PFNGLVERTEXATTRIBP3UIPROC = procedure(index: GLuint; dataType: GLenum;
  normalized: GLboolean; value: GLuint); stdcall;
type PFNGLVERTEXATTRIBP4UIPROC = procedure(index: GLuint; dataType: GLenum;
  normalized: GLboolean; value: GLuint); stdcall;
type PFNGLVERTEXATTRIBP1UIVPROC = procedure(index: GLuint; dataType: GLenum;
  normalized: GLboolean; const value: PGLuint); stdcall;
type PFNGLVERTEXATTRIBP2UIVPROC = procedure(index: GLuint; dataType: GLenum;
  normalized: GLboolean; const value: PGLuint); stdcall;
type PFNGLVERTEXATTRIBP3UIVPROC = procedure(index: GLuint; dataType: GLenum;
  normalized: GLboolean; const value: PGLuint); stdcall;
type PFNGLVERTEXATTRIBP4UIVPROC = procedure(index: GLuint; dataType: GLenum;
  normalized: GLboolean; const value: PGLuint); stdcall;

// PROC VARIABLE POINTERS
var
  glVertexP2ui:           PFNGLVERTEXP2UIPROC;
  glVertexP3ui:           PFNGLVERTEXP3UIPROC;
  glVertexP4ui:           PFNGLVERTEXP4UIPROC;
  glVertexP2uiv:          PFNGLVERTEXP2UIVPROC;
  glVertexP3uiv:          PFNGLVERTEXP3UIVPROC;
  glVertexP4uiv:          PFNGLVERTEXP4UIVPROC;
  glTexCoordP1ui:         PFNGLTEXCOORDP1UIPROC;
  glTexCoordP2ui:         PFNGLTEXCOORDP2UIPROC;
  glTexCoordP3ui:         PFNGLTEXCOORDP3UIPROC;
  glTexCoordP4ui:         PFNGLTEXCOORDP4UIPROC;
  glTexCoordP1uiv:        PFNGLTEXCOORDP1UIVPROC;
  glTexCoordP2uiv:        PFNGLTEXCOORDP2UIVPROC;
  glTexCoordP3uiv:        PFNGLTEXCOORDP3UIVPROC;
  glTexCoordP4uiv:        PFNGLTEXCOORDP4UIVPROC;
  glMultiTexCoordP1ui:    PFNGLMULTITEXCOORDP1UIPROC;
  glMultiTexCoordP2ui:    PFNGLMULTITEXCOORDP2UIPROC;
  glMultiTexCoordP3ui:    PFNGLMULTITEXCOORDP3UIPROC;
  glMultiTexCoordP4ui:    PFNGLMULTITEXCOORDP4UIPROC;
  glMultiTexCoordP1uiv:   PFNGLMULTITEXCOORDP1UIVPROC;
  glMultiTexCoordP2uiv:   PFNGLMULTITEXCOORDP2UIVPROC;
  glMultiTexCoordP3uiv:   PFNGLMULTITEXCOORDP3UIVPROC;
  glMultiTexCoordP4uiv:   PFNGLMULTITEXCOORDP4UIVPROC;
  glNormalP3ui:           PFNGLNORMALP3UIPROC;
  glNormalP3uiv:          PFNGLNORMALP3UIVPROC;
  glColorP3ui:            PFNGLCOLORP3UIPROC;
  glColorP4ui:            PFNGLCOLORP4UIPROC;
  glColorP3uiv:           PFNGLCOLORP3UIVPROC;
  glColorP4uiv:           PFNGLCOLORP4UIVPROC;
  glSecondaryColorP3ui:   PFNGLSECONDARYCOLORP3UIPROC;
  glSecondaryColorP3uiv:  PFNGLSECONDARYCOLORP3UIVPROC;
  glVertexAttribP1ui:     PFNGLVERTEXATTRIBP1UIPROC;
  glVertexAttribP2ui:     PFNGLVERTEXATTRIBP2UIPROC;
  glVertexAttribP3ui:     PFNGLVERTEXATTRIBP3UIPROC;
  glVertexAttribP4ui:     PFNGLVERTEXATTRIBP4UIPROC;
  glVertexAttribP1uiv:    PFNGLVERTEXATTRIBP1UIVPROC;
  glVertexAttribP2uiv:    PFNGLVERTEXATTRIBP2UIVPROC;
  glVertexAttribP3uiv:    PFNGLVERTEXATTRIBP3UIVPROC;
  glVertexAttribP4uiv:    PFNGLVERTEXATTRIBP4UIVPROC;
// End Core ARB Normalized vertex type INT & UINT "2_10_10_10_REV" *************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 4.0 Extensions    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_4_0}


// Core ARB Sample Shading *****************************************************
{$DEFINE GL_ARB_sample_shading}
const
  GL_ARB_sample_shading_str = 'GL_ARB_sample_shading';
  //
  GL_SAMPLE_SHADING           = $8C36;
  GL_MIN_SAMPLE_SHADING_VALUE = $8C37;
  
// PROC PROTOTYPES
type PFNGLMINSAMPLESHADINGARBPROC = procedure(value: GLclampf); stdcall;

// PROC VARIABLE POINTERS
var
  glMinSampleShadingARB: PFNGLMINSAMPLESHADINGARBPROC; 
// End Core ARB Sample Shading *************************************************


// Core ARB Texture cubemap array *********************************************
{$DEFINE GL_ARB_texture_cube_map_array}
const
  GL_ARB_texture_cube_map_array_str = 'GL_ARB_texture_cube_map_array';
  //
  GL_TEXTURE_CUBE_MAP_ARRAY               = $9009;
  GL_TEXTURE_BINDING_CUBE_MAP_ARRAY       = $900A;
  GL_PROXY_TEXTURE_CUBE_MAP_ARRAY         = $900B;
  GL_SAMPLER_CUBE_MAP_ARRAY               = $900C;
  GL_SAMPLER_CUBE_MAP_ARRAY_SHADOW        = $900D;
  GL_INT_SAMPLER_CUBE_MAP_ARRAY           = $900E;
  GL_UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY  = $900F;
  
// End Core ARB Texture cubemap array ******************************************


// Core ARB Texture gather *****************************************************
{$DEFINE GL_ARB_texture_gather}
const
  GL_ARB_texture_gather_str = 'GL_ARB_texture_gather';
  //
  GL_MIN_PROGRAM_TEXTURE_GATHER_OFFSET      = $8E5E;
  GL_MAX_PROGRAM_TEXTURE_GATHER_OFFSET      = $8E5E;
  GL_MAX_PROGRAM_TEXTURE_GATHER_COMPONENTS  = $8F9F;

// End Core ARB Texture gather *************************************************


// Core ARB GPU Shader 5 *******************************************************
{$DEFINE GL_ARB_gpu_shader5}
const
  GL_ARB_gpu_shader5_str = 'GL_ARB_gpu_shader5';
  //
  GL_GEOMETRY_SHADER_INVOCATIONS        = $887F;
  GL_MAX_GEOMETRY_SHADER_INVOCATIONS    = $8E5A;
  GL_MIN_FRAGMENT_INTERPOLATION_OFFSET  = $8E5B;
  GL_MAX_FRAGMENT_INTERPOLATION_OFFSET  = $8E5C;
  GL_FRAGMENT_INTERPOLATION_OFFSET_BITS = $8E5D;
  GL_MAX_VERTEX_STREAMS                 = $8E71;
  
// End Core ARB GPU Shader 5 ***************************************************


// Core ARB Draw indirect ******************************************************
{$DEFINE GL_ARB_draw_indirect}
const
  GL_ARB_draw_indirect_str = 'GL_ARB_draw_indirect';
  //
  GL_DRAW_INDIRECT_BUFFER         = $8F3F;
  GL_DRAW_INDIRECT_BUFFER_BINDING = $8F43;

// PROC PROTOTYPES
type PFNGLARRAYSPROC = procedure(mode: GLenum;
  const indirect: PGLDrawArraysIndirectCommand); stdcall;
type PFNGLELEMENTSPROC = procedure(mode, indirectDataType: GLenum;
  const indirect: PGLDrawElementsIndirectCommand); stdcall;

// PROC VARIABLE POINTERS
var
  glDrawArraysIndirect:   PFNGLARRAYSPROC;
  glDrawElementsIndirect: PFNGLELEMENTSPROC;
// End Core ARB Draw indirect **************************************************


// Core ARB Transform feedback 2 ***********************************************
{$DEFINE GL_ARB_transform_feedback2}
const
  GL_ARB_transform_feedback2_str = 'GL_GL_ARB_transform_feedback2';
  //
  GL_TRANSFORM_FEEDBACK               = $8E22;
  GL_TRANSFORM_FEEDBACK_BUFFER_PAUSED = $8E23;
  GL_TRANSFORM_FEEDBACK_BUFFER_ACTIVE = $8E24;
  GL_TRANSFORM_FEEDBACK_BINDING       = $8E25;

// PROC PROTOTYPES
type PFNGLBINDTRANSFORMFEEDBACKPROC = procedure(target: GLenum; id: GLuint); stdcall;
type PFNGLDELETETRANSFORMFEEDBACKSPROC = procedure(n: GLsizei; const ids: PGLuint); stdcall;
type PFNGLGENTRANSFORMFEEDBACKSPROC = procedure(n: GLsizei; ids: PGLuint); stdcall;
type PFNGLISTRANSFORMFEEDBACKPROC = function(id: GLuint): GLboolean;
type PFNGLPAUSETRANSFORMFEEDBACKPROC = procedure(); stdcall;
type PFNGLRESUMETRANSFORMFEEDBACKPROC = procedure(); stdcall;
type PFNGLDRAWTRANSFORMFEEDBACKPROC = procedure(mode: GLenum; id: GLuint); stdcall;

// PROC VARIABLE POINTERS
var
  glBindTransformFeedback:    PFNGLBINDTRANSFORMFEEDBACKPROC;
  glDeleteTransformFeedbacks: PFNGLDELETETRANSFORMFEEDBACKSPROC;
  glGenTransformFeedbacks:    PFNGLGENTRANSFORMFEEDBACKSPROC;
  glIsTransformFeedback:      PFNGLISTRANSFORMFEEDBACKPROC;
  glPauseTransformFeedback:   PFNGLPAUSETRANSFORMFEEDBACKPROC;
  glResumeTransformFeedback:  PFNGLRESUMETRANSFORMFEEDBACKPROC;
  glDrawTransformFeedback:    PFNGLDRAWTRANSFORMFEEDBACKPROC;
// End ARB Transform feedback 2 ************************************************


// Core ARB Transform feedback 3 ***********************************************
{$DEFINE GL_ARB_transform_feedback3}
const
  GL_ARB_transform_feedback3_str = 'GL_GL_ARB_transform_feedback3';
  //
  GL_MAX_TRANSFORM_FEEDBACK_BUFFERS = $8E70;

// PROC PROTOTYPES
type PFNGLDRAWTRANSFORMFEEDBACKSTREAMPROC = procedure(mode: GLenum;
  id, stream: GLuint); stdcall;
type PFNGLBEGINQUERYINDEXEDPROC = procedure(target: GLenum; index, id: GLuint); stdcall;
type PFNGLENDQUERYINDEXEDPROC = procedure(target: GLenum; index: GLuint); stdcall;
type PFNGLGETQUERYINDEXEDIVPROC = procedure(target: GLenum; index: GLuint;
  pname: GLenum; params: GLint); stdcall;

// PROC VARIABLE POINTERS
var
  glDrawTransformFeedbackStream:  PFNGLDRAWTRANSFORMFEEDBACKSTREAMPROC;
  glBeginQueryIndexed:            PFNGLBEGINQUERYINDEXEDPROC;
  glEndQueryIndexed:              PFNGLENDQUERYINDEXEDPROC;
  glGetQueryIndexediv:            PFNGLGETQUERYINDEXEDIVPROC;
// End Core ARB Transform feedback 3 *******************************************


// Core ARB Tesselation shader *************************************************
{$DEFINE GL_ARB_tessellation_shader}
const
  GL_ARB_tessellation_shader_str = 'GL_ARB_tessellation_shader';
  //
  GL_PATCHES                                            = $E;
  GL_PATCH_VERTICES                                     = $8E72;
  GL_PATCH_DEFAULT_INNER_LEVEL                          = $8E73;
  GL_PATCH_DEFAULT_OUTER_LEVEL                          = $8E74;
  GL_TESS_CONTROL_OUTPUT_VERTICES                       = $8E75;
  GL_TESS_GEN_MODE                                      = $8E76;
  GL_TESS_GEN_SPACING                                   = $8E77;
  GL_TESS_GEN_VERTEX_ORDER                              = $8E78;
  GL_TESS_GEN_POINT_MODE                                = $8E79;
  GL_ISOLINES                                           = $8E7A;
  GL_FRACTIONAL_ODD                                     = $8E7B;
  GL_FRACTIONAL_EVEN                                    = $8E7C;
  GL_MAX_PATCH_VERTICES                                 = $8E7D;
  GL_MAX_TESS_GEN_LEVEL                                 = $8E7E;
  GL_MAX_TESS_CONTROL_UNIFORM_COMPONENTS                = $8E7F;
  GL_MAX_TESS_EVALUATION_UNIFORM_COMPONENTS             = $8E80;
  GL_MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS               = $8E81;
  GL_MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS            = $8E82;
  GL_MAX_TESS_CONTROL_OUTPUT_COMPONENTS                 = $8E83;
  GL_MAX_TESS_PATCH_COMPONENTS                          = $8E84;
  GL_MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS           = $8E85;
  GL_MAX_TESS_EVALUATION_OUTPUT_COMPONENTS              = $8E86;
  GL_MAX_TESS_CONTROL_UNIFORM_BLOCKS                    = $8E89;
  GL_MAX_TESS_EVALUATION_UNIFORM_BLOCKS                 = $8E8A;
  GL_MAX_TESS_CONTROL_INPUT_COMPONENTS                  = $886C;
  GL_MAX_TESS_EVALUATION_INPUT_COMPONENTS               = $886D;
  GL_MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS       = $8E1E;
  GL_MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS    = $8E1F;
  GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER    = $84F0;
  GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER = $84F1;
  GL_TESS_EVALUATION_SHADER                             = $8E87;
  GL_TESS_CONTROL_SHADER                                = $8E88;
  
// PROC PROTOTYPES
type PFNGLPATCHPARAMETERIPROC = procedure(pname: GLenum; value: GLint); stdcall;
type PFNGLPATCHPARAMETERFVPROC = procedure(pname: GLenum;
  const values: PGLfloat); stdcall;

// PROC VARIABLE POINTERS
var
  glPatchParameteri:  PFNGLPATCHPARAMETERIPROC;
  glPatchParameterfv: PFNGLPATCHPARAMETERFVPROC;
// End Core ARB Tesselation shader *********************************************


// Core ARB GPU Shader FP64 ****************************************************
{$DEFINE GL_ARB_gpu_shader_fp64}
const
  GL_ARB_gpu_shader_fp64_str = 'GL_ARB_gpu_shader_fp64';
  //
  GL_DOUBLE_VEC2    = $8FFC;
  GL_DOUBLE_VEC3    = $8FFD;
  GL_DOUBLE_VEC4    = $8FFE;
  GL_DOUBLE_MAT2    = $8F46;
  GL_DOUBLE_MAT3    = $8F47;
  GL_DOUBLE_MAT4    = $8F48;
  GL_DOUBLE_MAT2x3  = $8F49;
  GL_DOUBLE_MAT2x4  = $8F4A;
  GL_DOUBLE_MAT3x2  = $8F4B;
  GL_DOUBLE_MAT3x4  = $8F4C;
  GL_DOUBLE_MAT4x2  = $8F4D;
  GL_DOUBLE_MAT4x3  = $8F4E;
  
// PROC PROTOTYPES
type PFNGLUNIFORM1DPROC = procedure(location: GLint; x: GLdouble); stdcall;
type PFNGLUNIFORM2DPROC = procedure(location: GLint; x, y: GLdouble); stdcall;
type PFNGLUNIFORM3DPROC = procedure(location: GLint; x, y, z: GLdouble); stdcall;
type PFNGLUNIFORM4DPROC = procedure(location: GLint; x, y, z, w: GLdouble); stdcall;
type PFNGLUNIFORM1DVPROC = procedure(location: GLint; count: GLsizei;
  const value: PGLdouble); stdcall;
type PFNGLUNIFORM2DVPROC = procedure(location: GLint; count: GLsizei;
  const value: PGLdouble); stdcall;
type PFNGLUNIFORM3DVPROC = procedure(location: GLint; count: GLsizei;
  const value: PGLdouble); stdcall;
type PFNGLUNIFORM4DVPROC = procedure(location: GLint; count: GLsizei;
  const value: PGLdouble); stdcall;
type PFNGLUNIFORMMATRIX2DVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLUNIFORMMATRIX3DVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLUNIFORMMATRIX4DVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLUNIFORMMATRIX2x3DVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLUNIFORMMATRIX2x4DVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLUNIFORMMATRIX3x2DVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLUNIFORMMATRIX3x4DVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLUNIFORMMATRIX4x2DVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLUNIFORMMATRIX4x3DVPROC = procedure(location: GLint; count: GLsizei;
  transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLGetUNIFORMDVPROC = procedure(progObj: GLuint; location: GLint;
  params: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORM1DEXTPROC = procedure(progObj: GLuint; location: GLint;
  x: GLdouble); stdcall;
type PFNGLPROGRAMUNIFORM2DEXTPROC = procedure(progObj: GLuint; location: GLint;
  x, y: GLdouble); stdcall;
type PFNGLPROGRAMUNIFORM3DEXTPROC = procedure(progObj: GLuint; location: GLint;
  x, y, z: GLdouble); stdcall;
type PFNGLPROGRAMUNIFORM4DEXTPROC = procedure(progObj: GLuint; location: GLint;
  x, y, z, w: GLdouble); stdcall;
type PFNGLPROGRAMUNIFORM1DVEXTPROC = procedure(progObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORM2DVEXTPROC = procedure(progObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORM3DVEXTPROC = procedure(progObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORM4DVEXTPROC = procedure(progObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX2DVEXTPROC = procedure(progObj: GLuint; location: GLint;
  count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX3DVEXTPROC = procedure(progObj: GLuint; location: GLint;
  count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX4DVEXTPROC = procedure(progObj: GLuint; location: GLint;
  count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX2X3DVEXTPROC = procedure(progObj: GLuint; location: GLint;
  count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX2X4DVEXTPROC = procedure(progObj: GLuint; location: GLint;
  count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX3X2DVEXTPROC = procedure(progObj: GLuint; location: GLint;
  count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX3X4DVEXTPROC = procedure(progObj: GLuint; location: GLint;
  count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX4X2DVEXTPROC = procedure(progObj: GLuint; location: GLint;
  count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX4X3DVEXTPROC = procedure(progObj: GLuint; location: GLint;
  count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;

// PROC VARIABLE POINTERS
var
  glUniform1d:                    PFNGLUNIFORM1DPROC;
  glUniform2d:                    PFNGLUNIFORM2DPROC;
  glUniform3d:                    PFNGLUNIFORM3DPROC;
  glUniform4d:                    PFNGLUNIFORM4DPROC;
  glUniform1dv:                   PFNGLUNIFORM1DVPROC;
  glUniform2dv:                   PFNGLUNIFORM2DVPROC;
  glUniform3dv:                   PFNGLUNIFORM3DVPROC;
  glUniform4dv:                   PFNGLUNIFORM4DVPROC;
  glUniformMatrix2dv:             PFNGLUNIFORMMATRIX2DVPROC;
  glUniformMatrix3dv:             PFNGLUNIFORMMATRIX3DVPROC;
  glUniformMatrix4dv:             PFNGLUNIFORMMATRIX4DVPROC;
  glUniformMatrix2x3dv:           PFNGLUNIFORMMATRIX2X3DVPROC;
  glUniformMatrix2x4dv:           PFNGLUNIFORMMATRIX2X4DVPROC;
  glUniformMatrix3x2dv:           PFNGLUNIFORMMATRIX3X2DVPROC;
  glUniformMatrix3x4dv:           PFNGLUNIFORMMATRIX3X4DVPROC;
  glUniformMatrix4x2dv:           PFNGLUNIFORMMATRIX4X2DVPROC;
  glUniformMatrix4x3dv:           PFNGLUNIFORMMATRIX4X3DVPROC;
  glGetUniformdv:                 PFNGLGETUNIFORMDVPROC;
  glProgramUniform1dEXT:          PFNGLPROGRAMUNIFORM1DEXTPROC;
  glProgramUniform2dEXT:          PFNGLPROGRAMUNIFORM2DEXTPROC;
  glProgramUniform3dEXT:          PFNGLPROGRAMUNIFORM3DEXTPROC;
  glProgramUniform4dEXT:          PFNGLPROGRAMUNIFORM4DEXTPROC;
  glProgramUniform1dvEXT:         PFNGLPROGRAMUNIFORM1DVEXTPROC;
  glProgramUniform2dvEXT:         PFNGLPROGRAMUNIFORM2DVEXTPROC;
  glProgramUniform3dvEXT:         PFNGLPROGRAMUNIFORM3DVEXTPROC;
  glProgramUniform4dvEXT:         PFNGLPROGRAMUNIFORM4DVEXTPROC;
  glProgramUniformMatrix2dvEXT:   PFNGLPROGRAMUNIFORMMATRIX2DVEXTPROC;
  glProgramUniformMatrix3dvEXT:   PFNGLPROGRAMUNIFORMMATRIX3DVEXTPROC;
  glProgramUniformMatrix4dvEXT:   PFNGLPROGRAMUNIFORMMATRIX4DVEXTPROC;
  glProgramUniformMatrix2x3dvEXT: PFNGLPROGRAMUNIFORMMATRIX2X3DVEXTPROC;
  glProgramUniformMatrix2x4dvEXT: PFNGLPROGRAMUNIFORMMATRIX2X4DVEXTPROC;
  glProgramUniformMatrix3x2dvEXT: PFNGLPROGRAMUNIFORMMATRIX3X2DVEXTPROC;
  glProgramUniformMatrix3x4dvEXT: PFNGLPROGRAMUNIFORMMATRIX3X4DVEXTPROC;
  glProgramUniformMatrix4x2dvEXT: PFNGLPROGRAMUNIFORMMATRIX4X2DVEXTPROC;
  glProgramUniformMatrix4x3dvEXT: PFNGLPROGRAMUNIFORMMATRIX4X3DVEXTPROC;
// End Core ARB GPU Shader FP64 ************************************************


// Core ARB Shader subroutine **************************************************
{$DEFINE GL_ARB_shader_subroutine}
const
  GL_ARB_shader_subroutine_str = 'GL_ARB_shader_subroutine';
  //
  GL_ACTIVE_SUBROUTINES                   = $8DE5;
  GL_ACTIVE_SUBROUTINE_UNIFORMS           = $8DE6;
  GL_ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS  = $8E47;
  GL_ACTIVE_SUBROUTINE_MAX_LENGTH         = $8E48;
  GL_ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH = $8E49;
  GL_MAX_SUBROUTINES                      = $8DE7;
  GL_MAX_SUBROUTINE_UNIFORM_LOCATIONS     = $8DE8;
  GL_NUM_COMPATIBLE_SUBROUTINES           = $8E4A;
  GL_COMPATIBLE_SUBROUTINES               = $8E4B;
  
// PROC PROTOTYPES
type PFNGLGETSUBROUTINEUNIFORMLOCATIONPROC = function(programObj: GLuint;
  shaderType: GLenum; const name: PGLchar): GLint; stdcall;
type PFNGLGETSUBROUTINEINDEXPROC = function(programObj: GLuint; shaderType: GLenum;
  const name: PGLchar): GLuint; stdcall;
type PFNGLGETACTIVESUBROUTINEUNIFORMIVPROC = procedure(programObj: GLuint;
  shaderType: GLenum; index: GLuint; pname: GLenum; values: PGLint); stdcall;
type PFNGLGETACTIVESUBROUTINEUNIFORMNAMEPROC = procedure(programObj: GLuint;
  shaderType: GLenum; index: GLuint; bufSize: GLsizei; length: PGLsizei;
  name: PGLchar); stdcall;
type PFNGLGETACTIVESUBROUTINENAMEPROC = procedure(programObj: GLuint;
  shaderType: GLenum; index: GLuint;  bufSize: GLsizei; length: PGLsizei;
  name: PGLchar); stdcall;
type PFNGLUNIFORMSUBROUTINESUIVPROC = procedure(shaderType: GLenum;
  count: GLsizei; const indices: PGLuint); stdcall;
type PFNGLGETUNIFORMSUBROUTINEUIVPROC = procedure(shaderType: GLenum;
  location: GLint; params: PGLuint); stdcall;
type PFNGLGETPROGRAMSTAGEIVPROC = procedure(programObj: GLuint;
  shaderType: GLenum; pname: GLenum; values: PGLint); stdcall;

// PROC VARIABLE POINTERS
var
  glGetSubroutineUniformLocation:   PFNGLGETSUBROUTINEUNIFORMLOCATIONPROC;
  glGetSubroutineIndex:             PFNGLGETSUBROUTINEINDEXPROC;
  glGetActiveSubroutineUniformiv:   PFNGLGETACTIVESUBROUTINEUNIFORMIVPROC;
  glGetActiveSubroutineUniformName: PFNGLGETACTIVESUBROUTINEUNIFORMNAMEPROC;
  glGetActiveSubroutineName:        PFNGLGETACTIVESUBROUTINENAMEPROC;
  glUniformSubroutinesuiv:          PFNGLUNIFORMSUBROUTINESUIVPROC;
  glGetUniformSubroutineuiv:        PFNGLGETUNIFORMSUBROUTINEUIVPROC;
  glGetProgramStageiv:              PFNGLGETPROGRAMSTAGEIVPROC;              
// End Core ARB Shader subroutine **********************************************


// ARB Draw buffers blend ******************************************************
{$DEFINE GL_ARB_draw_buffers_blend}
const
  GL_ARB_draw_buffers_blend_str = 'GL_ARB_draw_buffers_blend';
  
// PROC PROTOTYPES
type PFNGLBLENDEQUATIONIARBPROC = procedure(buf: GLuint; mode: GLenum); stdcall;
type PFNGLBLENDEQUATIONSEPARATEIARBPROC = procedure(buf: GLuint;
  modeRGB, modeAlpha: GLenum); stdcall;
type PFNGLBLENDFUNCIARBPROC = procedure(buf: GLuint; src, dst: GLenum); stdcall;
type PFNGLBLENDFUNCSEPARATEIARBPROC = procedure(buf: GLuint;
  srcRGB, dstRGB, srcAlpha, dstAlpha: GLenum); stdcall;

// PROC VARIABLE POINTERS
var
  glBlendEquationiARB:          PFNGLBLENDEQUATIONIARBPROC;
  glBlendEquationSeparateiARB:  PFNGLBLENDEQUATIONSEPARATEIARBPROC;
  glBlendFunciARB:              PFNGLBLENDFUNCIARBPROC;
  glBlendFuncSeparateiARB:      PFNGLBLENDFUNCSEPARATEIARBPROC;
// End ARB Draw buffers blend **************************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 4.1 Extensions    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_4_1}


// Core ARB Get program binary *************************************************
{$DEFINE GL_ARB_get_program_binary}
const
  GL_ARB_get_program_binary_str = 'GL_ARB_get_program_binary';
  //
  GL_PROGRAM_BINARY_RETRIEVABLE_HINT =  $8257;
  GL_PROGRAM_BINARY_LENGTH =            $8741;
  GL_NUM_PROGRAM_BINARY_FORMATS =       $87FE;
  GL_PROGRAM_BINARY_FORMATS =           $87FF;
  
// PROC PROTOTYPES
type PFNGLGETPROGRAMBINARYPROC = procedure(programObj: GLuint; bufSize: GLsizei;
  length: PGLSizei; binFmt: PGLenum; binData: PGLvoid); stdcall;
type PFNGLPROGRAMBINARYPROC = procedure(programObj: GLuint; binFmt: GLenum;
  const binData: PGLvoid; length: GLsizei); stdcall;
type PFNGLPROGRAMPARAMETERIPROC = procedure(programObj: GLuint; pname: GLenum;
  value: GLint); stdcall;

// PROC VARIABLE POINTERS
var
  glGetProgramBinary:   PFNGLGETPROGRAMBINARYPROC;
  glProgramBinary:      PFNGLPROGRAMBINARYPROC;
  glProgramParameteri:  PFNGLPROGRAMPARAMETERIPROC;
// End Core ARB Get program binary *********************************************


// Core ARB Viewport array *****************************************************
{$DEFINE GL_ARB_viewport_array}
const
  GL_ARB_viewport_array_str = 'GL_ARB_viewport_array';
  //
  GL_MAX_VIEWPORTS                    = $825B;
  GL_VIEWPORT_SUBPIXEL_BITS           = $825C;
  GL_VIEWPORT_BOUNDS_RANGE            = $825D;
  GL_LAYER_PROVOKING_VERTEX           = $825E;
  GL_VIEWPORT_INDEX_PROVOKING_VERTEX  = $825F;
  GL_SCISSOR_BOX                      = $0C10;
  GL_VIEWPORT                         = $0BA2;
  GL_DEPTH_RANGE                      = $0B70;
  GL_SCISSOR_TEST                     = $0C11;
  GL_UNDEFINED_VERTEX                 = $8260;
  
// PROC PROTOTYPES
type PFNGLVIEWPORTARRAYVPROC = procedure(first: GLuint; count: GLsizei;
  const v: PGLfloat); stdcall;
type PFNGLVIEWPORTINDEXEDFPROC = procedure(index: GLuint; x, y, w, h: GLfloat); stdcall;
type PFNGLVIEWPORTINDEXEDFVPROC = procedure(index: GLuint; const v: PGLfloat); stdcall;
type PFNGLSCISSORARRAYVPROC = procedure(first: GLuint; count: GLsizei;
  const v: PGLint); stdcall;
type PFNGLSCISSORINDEXEDPROC = procedure(index: GLuint; left, bottom: GLint;
  width, height: GLsizei); stdcall;
type PFNGLSCISSORINDEXEDVPROC = procedure(index: GLuint; const v: PGLint); stdcall;
type PFNGLDEPTHRANGEARRAYVPROC = procedure(first: GLuint; count: GLsizei;
  const v: PGLclampd); stdcall;
type PFNGLDEPTHRANGEINDEXEDPROC = procedure(index: GLuint; n, f: GLclampd); stdcall;
type PFNGLGETFLOATI_VPROC = procedure(target: GLenum; index: GLuint;
  data: PGLfloat); stdcall;
type PFNGLGETDOUBLEI_VPROC = procedure(target: GLenum; index: GLuint;
  data: PGLdouble); stdcall;

// PROC VARIABLE POINTERS
var
  glViewportArrayv:     PFNGLVIEWPORTARRAYVPROC;
  glViewportIndexedf:   PFNGLVIEWPORTINDEXEDFPROC;
  glViewportIndexedfv:  PFNGLVIEWPORTINDEXEDFVPROC;
  glScissorArrayv:      PFNGLSCISSORARRAYVPROC;
  glScissorIndexed:     PFNGLSCISSORINDEXEDPROC;
  glScissorIndexedv:    PFNGLSCISSORINDEXEDVPROC;
  glDepthRangeArrayv:   PFNGLDEPTHRANGEARRAYVPROC;
  glDepthRangeIndexed:  PFNGLDEPTHRANGEINDEXEDPROC;
  glGetFloati_v:        PFNGLGETFLOATI_VPROC;
  glGetDoublei_v:       PFNGLGETDOUBLEI_VPROC;
// End Core ARB Viewport array *************************************************


// Core ARB Vertex attrib 64-bit ***********************************************
{$DEFINE GL_ARB_vertex_attrib_64bit}
const
  GL_ARB_vertex_attrib_64bit_str = 'GL_ARB_vertex_attrib_64bit';
  
// PROC PROTOTYPES
type PFNGLVERTEXATTRIBL1DPROC = procedure(index: GLuint; x: GLdouble); stdcall;
type PFNGLVERTEXATTRIBL2DPROC = procedure(index: GLuint; x, y: GLdouble); stdcall;
type PFNGLVERTEXATTRIBL3DPROC = procedure(index: GLuint; x, y, z: GLdouble); stdcall;
type PFNGLVERTEXATTRIBL4DPROC = procedure(index: GLuint; x, y, z, w: GLdouble); stdcall;
type PFNGLVERTEXATTRIBL1DVPROC = procedure(index: GLuint; const v: PGLdouble); stdcall;
type PFNGLVERTEXATTRIBL2DVPROC = procedure(index: GLuint; const v: PGLdouble); stdcall;
type PFNGLVERTEXATTRIBL3DVPROC = procedure(index: GLuint; const v: PGLdouble); stdcall;
type PFNGLVERTEXATTRIBL4DVPROC = procedure(index: GLuint; const v: PGLdouble); stdcall;
type PFNGLVERTEXATTRIBLPOINTERPROC = procedure(index: GLuint; size: GLint; dataType: GLenum;
  stride: GLsizei; const data: PGLvoid); stdcall;
type PFNGLGETVERTEXATTRIBLDVPROC = procedure(index: GLuint; pname: GLenum;
  params: PGLdouble); stdcall;
type PFNGLVERTEXARRAYVERTEXATTRIBLOFFSETEXTPROC = procedure(vaobj, buffer, index: GLuint;
  size: GLint; dataType: GLenum; stride: GLsizei; offset: GLintptr); stdcall;

// PROC VARIABLE POINTERS
var
  glVertexAttribL1d:                    PFNGLVERTEXATTRIBL1DPROC;
  glVertexAttribL2d:                    PFNGLVERTEXATTRIBL2DPROC;
  glVertexAttribL3d:                    PFNGLVERTEXATTRIBL3DPROC;
  glVertexAttribL4d:                    PFNGLVERTEXATTRIBL4DPROC;
  glVertexAttribL1dv:                   PFNGLVERTEXATTRIBL1DVPROC;
  glVertexAttribL2dv:                   PFNGLVERTEXATTRIBL2DVPROC;
  glVertexAttribL3dv:                   PFNGLVERTEXATTRIBL3DVPROC;
  glVertexAttribL4dv:                   PFNGLVERTEXATTRIBL4DVPROC;
  glVertexAttribLPointer:               PFNGLVERTEXATTRIBLPOINTERPROC;
  glGetVertexAttribLdv:                 PFNGLGETVERTEXATTRIBLDVPROC;
  glVertexArrayVertexAttribLOffsetEXT:  PFNGLVERTEXARRAYVERTEXATTRIBLOFFSETEXTPROC;
// End Core ARB Vertex attrib 64-bit *******************************************


// Core ARB OpenGL ES 2.0 compatibility ****************************************
{$DEFINE GL_ARB_ES2_compatibility}
const
  GL_ARB_ES2_compatibility_str = 'GL_ARB_ES2_compatibility';
  //
  GL_SHADER_COMPILER                  = $8DFA;
  GL_SHADER_BINARY_FORMATS            = $8DF8;
  GL_NUM_SHADER_BINARY_FORMATS        = $8DF9;
  GL_MAX_VERTEX_UNIFORM_VECTORS       = $8DFB;
  GL_MAX_VARYING_VECTORS              = $8DFC;
  GL_MAX_FRAGMENT_UNIFORM_VECTORS     = $8DFD;
  GL_IMPLEMENTATION_COLOR_READ_TYPE   = $8B9A;
  GL_IMPLEMENTATION_COLOR_READ_FORMAT = $8B9B;
  GL_FIXED                            = $140C;
  GL_LOW_FLOAT                        = $8DF0;
  GL_MEDIUM_FLOAT                     = $8DF1;
  GL_HIGH_FLOAT                       = $8DF2;
  GL_LOW_INT                          = $8DF3;
  GL_MEDIUM_INT                       = $8DF4;
  GL_HIGH_INT                         = $8DF5;
  GL_RGB565                           = $8D62;
  
// PROC PROTOTYPES
type PFNGLRELEASESHADERCOMPILERPROC = procedure(); stdcall;
type PFNGLSHADERBINARYPROC = procedure(count: GLsizei; const shaders: PGLuint;
  binFmt: GLenum; const binData: PGLvoid; length: GLsizei); stdcall;
type PFNGLGETSHADERPRECISSIONFORMATPROC = procedure(shaderType, precissionType: GLenum;
  range, precission: PGLint); stdcall;
type PFNGLDEPTHRANGEFPROC = procedure(m, f: GLclampf); stdcall;
type PFNGLCLEARDEPTHFPROC = procedure(d: GLclampf); stdcall;

// PROC VARIABLE POINTERS
var
  glReleaseShaderCompiler:      PFNGLRELEASESHADERCOMPILERPROC;
  glShaderBinary:               PFNGLSHADERBINARYPROC;
  glGetShaderPrecissionFormat:  PFNGLGETSHADERPRECISSIONFORMATPROC;
  glDepthRangef:                PFNGLDEPTHRANGEFPROC;
  glClearDepthf:                PFNGLCLEARDEPTHFPROC;
// End Core ARB OpenGL ES 2.0 compatibility ************************************


// Core ARB Separate shader objects ********************************************
{$DEFINE GL_ARB_separate_shader_objects}
const
  GL_ARB_separate_shader_objects_str = 'GL_ARB_separate_shader_objects';
  //
  GL_VERTEX_SHADER_BIT          = $00000001;
  GL_FRAGMENT_SHADER_BIT        = $00000002;
  GL_GEOMETRY_SHADER_BIT        = $00000004;
  GL_TESS_CONTROL_SHADER_BIT    = $00000008;
  GL_TESS_EVALUATION_SHADER_BIT = $00000010;
  GL_ALL_SHADER_BITS            = $FFFFFFFF;
  GL_PROGRAM_SEPARABLE          = $8258;
  GL_ACTIVE_PROGRAM             = $8259;
  GL_PROGRAM_PIPELINE_BINDING   = $825A;
  
// PROC PROTOTYPES
type PFNGLUSEPROGRAMSTAGESPROC = procedure(pipeline: GLuint; stages: GLbitfield;
  programObj: GLuint); stdcall;
type PFNGLACTIVESHADERPROGRAMPROC = procedure(pipeline: GLuint; programObj: GLuint); stdcall;
type PFNGLCREATESHADERPROGRAMVPROC = function(objType: GLenum; count: GLsizei;
  const strings: PPGLchar): GLuint;  stdcall;
type PFNGLBINDPROGRAMPIPELINEPROC = procedure(pipeline: GLuint); stdcall;
type PFNGLDELETEPROGRAMPIPELINESPROC = procedure(n: GLsizei; const pipelines: PGLuint); stdcall;
type PFNGLGENPROGRAMPIPELINESPROC = procedure(n: GLsizei; pipelines: PGLuint); stdcall;
type PFNGLISPROGRAMPIPELINEPROC = function(pipeline: GLuint): GLboolean;  stdcall;
type PFNGLGETPROGRAMPIPELINEIVPROC = procedure(pipeline: GLuint; pname: GLenum;
  params: PGLint); stdcall;
type PFNGLPROGRAMUNIFORM1IPROC = procedure(programObj: GLuint; location: GLint;
  x: GLint); stdcall;
type PFNGLPROGRAMUNIFORM2IPROC = procedure(programObj: GLuint; location: GLint;
  x, y: GLint); stdcall;
type PFNGLPROGRAMUNIFORM3IPROC = procedure(programObj: GLuint; location: GLint;
  x, y, z: GLint); stdcall;
type PFNGLPROGRAMUNIFORM4IPROC = procedure(programObj: GLuint; location: GLint;
  x, y, z, w: GLint); stdcall;
type PFNGLPROGRAMUNIFORM1UIPROC = procedure(programObj: GLuint; location: GLint;
  x: GLuint); stdcall;
type PFNGLPROGRAMUNIFORM2UIPROC = procedure(programObj: GLuint; location: GLint;
  x, y: GLuint); stdcall;
type PFNGLPROGRAMUNIFORM3UIPROC = procedure(programObj: GLuint; location: GLint;
  x, y, z: GLuint); stdcall;
type PFNGLPROGRAMUNIFORM4UIPROC = procedure(programObj: GLuint; location: GLint;
  x, y, z, w: GLuint); stdcall;
type PFNGLPROGRAMUNIFORM1FPROC = procedure(programObj: GLuint; location: GLint;
  x: GLfloat); stdcall;
type PFNGLPROGRAMUNIFORM2FPROC = procedure(programObj: GLuint; location: GLint;
  x, y: GLfloat); stdcall;
type PFNGLPROGRAMUNIFORM3FPROC = procedure(programObj: GLuint; location: GLint;
  x, y, z: GLfloat); stdcall;
type PFNGLPROGRAMUNIFORM4FPROC = procedure(programObj: GLuint; location: GLint;
  x, y, z, w: GLfloat); stdcall;
type PFNGLPROGRAMUNIFORM1DPROC = procedure(programObj: GLuint; location: GLint;
  x: GLdouble); stdcall;
type PFNGLPROGRAMUNIFORM2DPROC = procedure(programObj: GLuint; location: GLint;
  x, y: GLdouble); stdcall;
type PFNGLPROGRAMUNIFORM3DPROC = procedure(programObj: GLuint; location: GLint;
  x, y, z: GLdouble); stdcall;
type PFNGLPROGRAMUNIFORM4DPROC = procedure(programObj: GLuint; location: GLint;
  x, y, z, w: GLdouble); stdcall;
type PFNGLPROGRAMUNIFORM1IVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLint); stdcall;
type PFNGLPROGRAMUNIFORM2IVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLint); stdcall;
type PFNGLPROGRAMUNIFORM3IVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLint); stdcall;
type PFNGLPROGRAMUNIFORM4IVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLint); stdcall;
type PFNGLPROGRAMUNIFORM1UIVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const uvalue: PGLint); stdcall;
type PFNGLPROGRAMUNIFORM2UIVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const uvalue: PGLint); stdcall;
type PFNGLPROGRAMUNIFORM3UIVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const uvalue: PGLint); stdcall;
type PFNGLPROGRAMUNIFORM4UIVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const uvalue: PGLint); stdcall;
type PFNGLPROGRAMUNIFORM1FVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORM2FVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORM3FVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORM4FVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORM1DVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORM2DVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORM3DVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORM4DVPROC = procedure(programObj: GLuint; location: GLint;
  count: GLsizei; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX2FVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX3FVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX4FVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX2DVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX3DVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX4DVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX2X3FVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX3X2FVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX2X4FVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX4X2FVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX3X4FVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX4X3FVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX2X3DVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX3X2DVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX2X4DVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX4X2DVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX3X4DVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX4X3DVPROC = procedure(programObj: GLuint; location:
  GLint; count: GLsizei; transpose: GLboolean; const value: PGLdouble); stdcall;
type PFNGLVALIDATEPROGRAMPIPELINEPROC = procedure(pipeline: GLuint); stdcall;
type PFNGLGETPROGRAMPIPELINEINFOLOGPROC = procedure(pipeline: GLuint; bufSize:
  GLsizei; length: PGLsizei; infoLog: PGLchar); stdcall;

// PROC VARIABLE POINTERS
var
  glUseProgramStages:           PFNGLUSEPROGRAMSTAGESPROC;
  glActiveShaderProgram:        PFNGLACTIVESHADERPROGRAMPROC;
  glCreateShaderProgramv:       PFNGLCREATESHADERPROGRAMVPROC;
  glBindProgramPipeline:        PFNGLBINDPROGRAMPIPELINEPROC;
  glDeleteProgramPipelines:     PFNGLDELETEPROGRAMPIPELINESPROC;
  glGenProgramPipelines:        PFNGLGENPROGRAMPIPELINESPROC;
  glIsProgramPipeline:          PFNGLISPROGRAMPIPELINEPROC;
  glGetProgramPipelineiv:       PFNGLGETPROGRAMPIPELINEIVPROC;
  glProgramUniform1i:           PFNGLPROGRAMUNIFORM1IPROC;
  glProgramUniform2i:           PFNGLPROGRAMUNIFORM2IPROC;
  glProgramUniform3i:           PFNGLPROGRAMUNIFORM3IPROC;
  glProgramUniform4i:           PFNGLPROGRAMUNIFORM4IPROC;
  glProgramUniform1ui:          PFNGLPROGRAMUNIFORM1UIPROC;
  glProgramUniform2ui:          PFNGLPROGRAMUNIFORM2UIPROC;
  glProgramUniform3ui:          PFNGLPROGRAMUNIFORM3UIPROC;
  glProgramUniform4ui:          PFNGLPROGRAMUNIFORM4UIPROC;
  glProgramUniform1f:           PFNGLPROGRAMUNIFORM1FPROC;
  glProgramUniform2f:           PFNGLPROGRAMUNIFORM2FPROC;
  glProgramUniform3f:           PFNGLPROGRAMUNIFORM3FPROC;
  glProgramUniform4f:           PFNGLPROGRAMUNIFORM4FPROC;
  glProgramUniform1d:           PFNGLPROGRAMUNIFORM1DPROC;
  glProgramUniform2d:           PFNGLPROGRAMUNIFORM2DPROC;
  glProgramUniform3d:           PFNGLPROGRAMUNIFORM3DPROC;
  glProgramUniform4d:           PFNGLPROGRAMUNIFORM4DPROC;
  glProgramUniform1iv:          PFNGLPROGRAMUNIFORM1IVPROC;
  glProgramUniform2iv:          PFNGLPROGRAMUNIFORM2IVPROC;
  glProgramUniform3iv:          PFNGLPROGRAMUNIFORM3IVPROC;
  glProgramUniform4iv:          PFNGLPROGRAMUNIFORM4IVPROC;
  glProgramUniform1uiv:         PFNGLPROGRAMUNIFORM1UIVPROC;
  glProgramUniform2uiv:         PFNGLPROGRAMUNIFORM2UIVPROC;
  glProgramUniform3uiv:         PFNGLPROGRAMUNIFORM3UIVPROC;
  glProgramUniform4uiv:         PFNGLPROGRAMUNIFORM4UIVPROC;
  glProgramUniform1fv:          PFNGLPROGRAMUNIFORM1FVPROC;
  glProgramUniform2fv:          PFNGLPROGRAMUNIFORM2FVPROC;
  glProgramUniform3fv:          PFNGLPROGRAMUNIFORM3FVPROC;
  glProgramUniform4fv:          PFNGLPROGRAMUNIFORM4FVPROC;
  glProgramUniform1dv:          PFNGLPROGRAMUNIFORM1DVPROC;
  glProgramUniform2dv:          PFNGLPROGRAMUNIFORM2DVPROC;
  glProgramUniform3dv:          PFNGLPROGRAMUNIFORM3DVPROC;
  glProgramUniform4dv:          PFNGLPROGRAMUNIFORM4DVPROC;
  glProgramUniformMatrix2fv:    PFNGLPROGRAMUNIFORMMATRIX2FVPROC;
  glProgramUniformMatrix3fv:    PFNGLPROGRAMUNIFORMMATRIX3FVPROC;
  glProgramUniformMatrix4fv:    PFNGLPROGRAMUNIFORMMATRIX4FVPROC;
  glProgramUniformMatrix2dv:    PFNGLPROGRAMUNIFORMMATRIX2DVPROC;
  glProgramUniformMatrix3dv:    PFNGLPROGRAMUNIFORMMATRIX3DVPROC;
  glProgramUniformMatrix4dv:    PFNGLPROGRAMUNIFORMMATRIX4DVPROC;
  glProgramUniformMatrix2x3fv:  PFNGLPROGRAMUNIFORMMATRIX2X3FVPROC;
  glProgramUniformMatrix3x2fv:  PFNGLPROGRAMUNIFORMMATRIX3X2FVPROC;
  glProgramUniformMatrix2x4fv:  PFNGLPROGRAMUNIFORMMATRIX2X4FVPROC;
  glProgramUniformMatrix4x2fv:  PFNGLPROGRAMUNIFORMMATRIX4X2FVPROC;
  glProgramUniformMatrix3x4fv:  PFNGLPROGRAMUNIFORMMATRIX3X4FVPROC;
  glProgramUniformMatrix4x3fv:  PFNGLPROGRAMUNIFORMMATRIX4X3FVPROC;
  glProgramUniformMatrix2x3dv:  PFNGLPROGRAMUNIFORMMATRIX2X3DVPROC;
  glProgramUniformMatrix3x2dv:  PFNGLPROGRAMUNIFORMMATRIX3X2DVPROC;
  glProgramUniformMatrix2x4dv:  PFNGLPROGRAMUNIFORMMATRIX2X4DVPROC;
  glProgramUniformMatrix4x2dv:  PFNGLPROGRAMUNIFORMMATRIX4X2DVPROC;
  glProgramUniformMatrix3x4dv:  PFNGLPROGRAMUNIFORMMATRIX3X4DVPROC;
  glProgramUniformMatrix4x3dv:  PFNGLPROGRAMUNIFORMMATRIX4X3DVPROC;
  glValidateProgramPipeline:    PFNGLVALIDATEPROGRAMPIPELINEPROC;
  glGetProgramPipelineInfoLog:  PFNGLGETPROGRAMPIPELINEINFOLOGPROC;
// End Core ARB Separate shader objects ****************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 4.2 Extensions    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_4_2}


// ARB Texture compression BPTC ************************************************
{$DEFINE GL_ARB_texture_compression_bptc}
const
  GL_ARB_texture_compression_bptc_str = 'GL_ARB_texture_compression_bptc';
  //
  GL_COMPRESSED_RGBA_BPTC_UNORM =         $8E8C;
  GL_COMPRESSED_SRGB_ALPHA_BPTC_UNORM =   $8E8D;
  GL_COMPRESSED_RGB_BPTC_SIGNED_FLOAT =   $8E8E;
  GL_COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT = $8E8F;
  
// End ARB Texture compression BPTC ********************************************


// Core ARB Map buffer aligment ************************************************
{$DEFINE GL_ARB_map_buffer_alignment}
const
  GL_ARB_map_buffer_alignment_str = 'GL_ARB_map_buffer_alignment';
  //
  GL_MIN_MAP_BUFFER_ALIGNMENT = $90BC;
  
// End Core ARB Map buffer aligment ********************************************


// Core ARB Compressed texture pixel storage ***********************************
{$DEFINE GL_ARB_compressed_texture_pixel_storage}
const
  GL_ARB_compressed_texture_pixel_storage_str = 'GL_ARB_compressed_texture_pixel_storage';
  //
  GL_UNPACK_COMPRESSED_BLOCK_WIDTH  = $9127;
  GL_UNPACK_COMPRESSED_BLOCK_HEIGHT = $9128;
  GL_UNPACK_COMPRESSED_BLOCK_DEPTH  = $9129;
  GL_UNPACK_COMPRESSED_BLOCK_SIZE   = $912A;
  GL_PACK_COMPRESSED_BLOCK_WIDTH    = $912B;
  GL_PACK_COMPRESSED_BLOCK_HEIGHT   = $912C;
  GL_PACK_COMPRESSED_BLOCK_DEPTH    = $912D;
  GL_PACK_COMPRESSED_BLOCK_SIZE     = $912E;
  
// End Core ARB Compressed texture pixel storage *******************************


// Core ARB Shader atomic counters *********************************************
{$DEFINE GL_ARB_shader_atomic_counters}
const
  GL_ARB_shader_atomic_counters_str = 'GL_ARB_shader_atomic_counters';
  //
  GL_ATOMIC_COUNTER_BUFFER                                      = $92C0;
  GL_ATOMIC_COUNTER_BUFFER_BINDING                              = $92C1;
  GL_ATOMIC_COUNTER_BUFFER_START                                = $92C2;
  GL_ATOMIC_COUNTER_BUFFER_SIZE                                 = $92C3;
  GL_ATOMIC_COUNTER_BUFFER_DATA_SIZE                            = $92C4;
  GL_ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTERS               = $92C5;
  GL_ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTER_INDICES        = $92C6;
  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_VERTEX_SHADER          = $92C7;
  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_CONTROL_SHADER    = $92C8;
  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_EVALUATION_SHADER = $92C9;
  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_GEOMETRY_SHADER        = $92CA;
  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_FRAGMENT_SHADER        = $92CB;
  GL_MAX_VERTEX_ATOMIC_COUNTER_BUFFERS                          = $92CC;
  GL_MAX_TESS_CONTROL_ATOMIC_COUNTER_BUFFERS                    = $92CD;
  GL_MAX_TESS_EVALUATION_ATOMIC_COUNTER_BUFFERS                 = $92CE;
  GL_MAX_GEOMETRY_ATOMIC_COUNTER_BUFFERS                        = $92CF;
  GL_MAX_FRAGMENT_ATOMIC_COUNTER_BUFFERS                        = $92D0;
  GL_MAX_COMBINED_ATOMIC_COUNTER_BUFFERS                        = $92D1;
  GL_MAX_VERTEX_ATOMIC_COUNTERS                                 = $92D2;
  GL_MAX_TESS_CONTROL_ATOMIC_COUNTERS                           = $92D3;
  GL_MAX_TESS_EVALUATION_ATOMIC_COUNTERS                        = $92D4;
  GL_MAX_GEOMETRY_ATOMIC_COUNTERS                               = $92D5;
  GL_MAX_FRAGMENT_ATOMIC_COUNTERS                               = $92D6;
  GL_MAX_COMBINED_ATOMIC_COUNTERS                               = $92D7;
  GL_MAX_ATOMIC_COUNTER_BUFFER_SIZE                             = $92D8;
  GL_MAX_ATOMIC_COUNTER_BUFFER_BINDINGS                         = $92DC;
  GL_ACTIVE_ATOMIC_COUNTER_BUFFERS                              = $92D9;
  GL_UNIFORM_ATOMIC_COUNTER_BUFFER_INDEX                        = $92DA;
  GL_UNSIGNED_INT_ATOMIC_COUNTER                                = $92DB;
  
// PROC PROTOTYPES
type PFNGLGETACTIVEATOMICCOUNTERBUFFERIVPROC = procedure(programObj, buffIndex: GLuint;
  pname: GLenum; params: PGLint); stdcall;

// PROC VARIABLE POINTERS
var
  glGetActiveAtomicCounterBufferiv: PFNGLGETACTIVEATOMICCOUNTERBUFFERIVPROC;
// End Core ARB Shader atomic counters *****************************************


// Core ARB Shader image load store ********************************************
{$DEFINE GL_ARB_shader_image_load_store}
const
  GL_ARB_shader_image_load_store_str = 'GL_ARB_shader_image_load_store';
  //
  GL_MAX_IMAGE_UNITS                                = $8F38;
  GL_MAX_COMBINED_IMAGE_UNITS_AND_FRAGMENT_OUTPUTS  = $8F39;
  GL_MAX_IMAGE_SAMPLES                              = $906D;
  GL_MAX_VERTEX_IMAGE_UNIFORMS                      = $90CA;
  GL_MAX_TESS_CONTROL_IMAGE_UNIFORMS                = $90CB;
  GL_MAX_TESS_EVALUATION_IMAGE_UNIFORMS             = $90CC;
  GL_MAX_GEOMETRY_IMAGE_UNIFORMS                    = $90CD;
  GL_MAX_FRAGMENT_IMAGE_UNIFORMS                    = $90CE;
  GL_MAX_COMBINED_IMAGE_UNIFORMS                    = $90CF;
  GL_IMAGE_BINDING_NAME                             = $8F3A;
  GL_IMAGE_BINDING_LEVEL                            = $8F3B;
  GL_IMAGE_BINDING_LAYERED                          = $8F3C;
  GL_IMAGE_BINDING_LAYER                            = $8F3D;
  GL_IMAGE_BINDING_ACCESS                           = $8F3E;
  GL_IMAGE_BINDING_FORMAT                           = $906E;
  GL_VERTEX_ATTRIB_ARRAY_BARRIER_BIT                = $00000001;
  GL_ELEMENT_ARRAY_BARRIER_BIT                      = $00000002;
  GL_UNIFORM_BARRIER_BIT                            = $00000004;
  GL_TEXTURE_FETCH_BARRIER_BIT                      = $00000008;
  GL_SHADER_IMAGE_ACCESS_BARRIER_BIT                = $00000020;
  GL_COMMAND_BARRIER_BIT                            = $00000040;
  GL_PIXEL_BUFFER_BARRIER_BIT                       = $00000080;
  GL_TEXTURE_UPDATE_BARRIER_BIT                     = $00000100;
  GL_BUFFER_UPDATE_BARRIER_BIT                      = $00000200;
  GL_FRAMEBUFFER_BARRIER_BIT                        = $00000400;
  GL_TRANSFORM_FEEDBACK_BARRIER_BIT                 = $00000800;
  GL_ATOMIC_COUNTER_BARRIER_BIT                     = $00001000;
  GL_ALL_BARRIER_BITS                               = $FFFFFFFF;
  GL_IMAGE_1D                                       = $904C;
  GL_IMAGE_2D                                       = $904D;
  GL_IMAGE_3D                                       = $904E;
  GL_IMAGE_2D_RECT                                  = $904F;
  GL_IMAGE_CUBE                                     = $9050;
  GL_IMAGE_BUFFER                                   = $9051;
  GL_IMAGE_1D_ARRAY                                 = $9052;
  GL_IMAGE_2D_ARRAY                                 = $9053;
  GL_IMAGE_CUBE_MAP_ARRAY                           = $9054;
  GL_IMAGE_2D_MULTISAMPLE                           = $9055;
  GL_IMAGE_2D_MULTISAMPLE_ARRAY                     = $9056;
  GL_INT_IMAGE_1D                                   = $9057;
  GL_INT_IMAGE_2D                                   = $9058;
  GL_INT_IMAGE_3D                                   = $9059;
  GL_INT_IMAGE_2D_RECT                              = $905A;
  GL_INT_IMAGE_CUBE                                 = $905B;
  GL_INT_IMAGE_BUFFER                               = $905C;
  GL_INT_IMAGE_1D_ARRAY                             = $905D;
  GL_INT_IMAGE_2D_ARRAY                             = $905E;
  GL_INT_IMAGE_CUBE_MAP_ARRAY                       = $905F;
  GL_INT_IMAGE_2D_MULTISAMPLE                       = $9060;
  GL_INT_IMAGE_2D_MULTISAMPLE_ARRAY                 = $9061;
  GL_UNSIGNED_INT_IMAGE_1D                          = $9062;
  GL_UNSIGNED_INT_IMAGE_2D                          = $9063;
  GL_UNSIGNED_INT_IMAGE_3D                          = $9064;
  GL_UNSIGNED_INT_IMAGE_2D_RECT                     = $9065;
  GL_UNSIGNED_INT_IMAGE_CUBE                        = $9066;
  GL_UNSIGNED_INT_IMAGE_BUFFER                      = $9067;
  GL_UNSIGNED_INT_IMAGE_1D_ARRAY                    = $9068;
  GL_UNSIGNED_INT_IMAGE_2D_ARRAY                    = $9069;
  GL_UNSIGNED_INT_IMAGE_CUBE_MAP_ARRAY              = $906A;
  GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE              = $906B;
  GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE_ARRAY        = $906C;
  GL_IMAGE_FORMAT_COMPATIBILITY_TYPE                = $90C7;
  GL_IMAGE_FORMAT_COMPATIBILITY_BY_SIZE             = $90C8;
  GL_IMAGE_FORMAT_COMPATIBILITY_BY_CLASS            = $90C9;

  
// PROC PROTOTYPES
type PFNGLBINDIMAGETEXTUREPROC = procedure(image, texture: GLuint; level: GLint;
  layered: GLboolean; layer: GLint; access, fmt: GLenum); stdcall;
type PFNGLMEMORYBARRIERPROC = procedure(barriers: GLbitfield); stdcall;

// PROC VARIABLE POINTERS
var
  glBindImageTexture: PFNGLBINDIMAGETEXTUREPROC;  
  glMemoryBarrier:    PFNGLMEMORYBARRIERPROC;
// End Core ARB Shader image load store ****************************************


// Core ARB Texture storaige ***************************************************
{$DEFINE GL_ARB_texture_storage}
const
  GL_ARB_texture_storage_str = 'GL_ARB_texture_storage';
  //
  GL_TEXTURE_IMMUTABLE_FORMAT = $912F;

// PROC PROTOTYPES
type PFNGLTEXSTORAGE1DPROC = procedure(target: GLenum; levels: GLsizei;
  internalFmt: GLenum; width: GLsizei); stdcall;
type PFNGLTEXSTORAGE2DPROC = procedure(target: GLenum; levels: GLsizei;
  internalFmt: GLenum; width, height: GLsizei); stdcall;
type PFNGLTEXSTORAGE3DPROC = procedure(target: GLenum; levels: GLsizei;
  internalFmt: GLenum; width, height, depth: GLsizei); stdcall;
type PFNGLTEXTURESTORAGE1DEXTPROC = procedure(texture: GLuint; target: GLenum;
  levels: GLsizei; internalFmt: GLenum; width: GLsizei); stdcall;
type PFNGLTEXTURESTORAGE2DEXTPROC = procedure(texture: GLuint; target: GLenum;
  levels: GLsizei; internalFmt: GLenum; width, height: GLsizei); stdcall;
type PFNGLTEXTURESTORAGE3DEXTPROC = procedure(texture: GLuint; target: GLenum;
  levels: GLsizei; internalFmt: GLenum; width, height, depth: GLsizei); stdcall;

// PROC VARIABLE POINTERS
var
  glTexStorage1D:         PFNGLTEXSTORAGE1DPROC;
  glTexStorage2D:         PFNGLTEXSTORAGE2DPROC;
  glTexStorage3D:         PFNGLTEXSTORAGE3DPROC;
  glTextureStorage1DEXT:  PFNGLTEXTURESTORAGE1DEXTPROC;
  glTextureStorage2DEXT:  PFNGLTEXTURESTORAGE2DEXTPROC;
  glTextureStorage3DEXT:  PFNGLTEXTURESTORAGE3DEXTPROC;
// End Core ARB Texture storaige ***********************************************


// Core ARB Transform feedback instanced ***************************************
{$DEFINE GL_ARB_transform_feedback_instanced}
const
  GL_ARB_transform_feedback_instanced_str = 'GL_ARB_transform_feedback_instanced';
  
// PROC PROTOTYPES
type PFNGLDRAWTRANSFORMFEEDBACKINSTANCEDPROC = procedure(mode: Glenum; id: GLuint;
  primcount: GLsizei); stdcall;
type PFNGLDRAWTRANSFORMFEEDBACKSTREAMINSTANCEDPROC = procedure(mode: Glenum;
  id, stream: GLuint; primcount: GLsizei); stdcall;

// PROC VARIABLE POINTERS
var
  glDrawTransformFeedbackInstanced:       PFNGLDRAWTRANSFORMFEEDBACKINSTANCEDPROC;
  glDrawTransformFeedbackStreamInstanced: PFNGLDRAWTRANSFORMFEEDBACKSTREAMINSTANCEDPROC;
// End Core ARB Transform feedback instanced ***********************************


// Core ARB Base instance ******************************************************
{$DEFINE GL_ARB_base_instance}
const
  GL_ARB_base_instance_str = 'GL_ARB_base_instance';
  
// PROC PROTOTYPES
type PFNGLDRAWARRAYSINSTANCEDBASEINSTANCEPROC = procedure(mode: GLenum; first: GLint;
  count, primcount: GLsizei; baseInstance: GLuint); stdcall;
type PFNGLDRAWELEMENTSINSTANCEDBASEINSTANCEPROC = procedure(mode: GLenum;
  count: GLsizei; indexType: GLenum; const indices: PGLvoid; primcount: GLsizei;
  baseInstance: GLuint); stdcall;
type PFNGLDRAWELEMENTSINSTANCEDBASEVERTEXBASEINSTANCEPROC = procedure(mode: GLenum;
  count: GLsizei; indexType: GLenum; const indices: PGLvoid; primcount: GLsizei;
  baseVertex: GLint; baseInstance: GLuint); stdcall;

// PROC VARIABLE POINTERS
var
  glDrawArraysInstancedBaseInstance:              PFNGLDRAWARRAYSINSTANCEDBASEINSTANCEPROC;
  glDrawElementsInstancedBaseInstance:            PFNGLDRAWELEMENTSINSTANCEDBASEINSTANCEPROC;
  glDrawElementsInstancedBaseVertexBaseInstance:  PFNGLDRAWELEMENTSINSTANCEDBASEVERTEXBASEINSTANCEPROC;
// End Core ARB Base instance **************************************************


// Core ARB Internal format querry *********************************************
{$DEFINE GL_ARB_internalformat_query}
const
  GL_ARB_internalformat_query_str = 'GL_ARB_internalformat_query';
  //
  GL_NUM_SAMPLE_COUNTS = $9380;
  
// PROC PROTOTYPES
type PFNGLGETINTERNALFORMATIVPROC = procedure(target, internalFmt, pname: GLenum;
  bufSize: GLsizei; params: PGLint); stdcall;

// PROC VARIABLE POINTERS
var
  glGetInternalformativ: PFNGLGETINTERNALFORMATIVPROC;
// End Core ARB Internal format querry *****************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 4.3 Extensions    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_4_3}


// Core ARB Explicit uniform location ******************************************
{$DEFINE GL_ARB_explicit_uniform_location}
const
  GL_ARB_explicit_uniform_location_str = 'GL_ARB_explicit_uniform_location';
  //
  GL_MAX_UNIFORM_LOCATIONS = $826E;
  
// End Core ARB Explicit uniform location **************************************


// Core ARB Vertex attrib binding **********************************************
{$DEFINE GL_ARB_vertex_attrib_binding}
const
  GL_ARB_vertex_attrib_binding_str = 'GL_ARB_vertex_attrib_binding';
  //
  GL_VERTEX_ATTRIB_BINDING              = $82D4;
  GL_VERTEX_ATTRIB_RELATIVE_OFFSET      = $82D5;
  GL_VERTEX_BINDING_DIVISOR             = $82D6;
  GL_VERTEX_BINDING_OFFSET              = $82D7;
  GL_VERTEX_BINDING_STRIDE              = $82D8;
  GL_VERTEX_BINDING_BUFFER              = $8F4F;
  GL_MAX_VERTEX_ATTRIB_RELATIVE_OFFSET  = $82D9;
  GL_MAX_VERTEX_ATTRIB_BINDINGS         = $82DA;  

  
// PROC PROTOTYPES
type PFNGLBINDVERTEXBUFFERPROC = procedure(bindingIndex, buffer: GLuint;
  offset: GLintptr; stride: GLsizei); stdcall;
type PFNGLVERTEXATTRIBFORMATPROC = procedure(attribIndex: GLuint; size: GLint;
  dataType: GLenum; normalized: GLboolean; relativeOffset: GLuint); stdcall;
type PFNGLVERTEXATTRIBIFORMATPROC = procedure(attribIndex: GLuint; size: GLint;
  dataType: GLenum; relativeOffset: GLuint); stdcall;
type PFNGLVERTEXATTRIBLFORMATPROC = procedure(attribIndex: GLuint; size: GLint;
  dataType: GLenum; relativeOffset: GLuint); stdcall;
type PFNGLVERTEXATTRIBBINDINGPROC = procedure(attribIndex, bindingIndex: GLuint); stdcall;
type PFNGLVERTEXBINDINGDIVISORPROC = procedure(bindingIndex, divisor: GLuint); stdcall;
type PFNGLVERTEXARRAYBINDVERTEXBUFFEREXTPROC = procedure(vao, bindingIndex, buffer: GLuint;
  offset: GLintptr; stride: GLsizei); stdcall;
type PFNGLVERTEXARRAYVERTEXATTRIBFORMATEXTPROC = procedure(vao, attribIndex: GLuint;
  size: GLint; dataType: GLenum; normalized: GLboolean; relativeOffset: GLuint); stdcall;
type PFNGLVERTEXARRAYVERTEXATTRIBIFORMATEXTPROC = procedure(vao, attribIndex: GLuint;
  size: GLint; dataType: GLenum; relativeOffset: GLuint); stdcall;
type PFNGLVERTEXARRAYVERTEXATTRIBLFORMATEXTPROC = procedure(vao, attribIndex: GLuint;
  size: GLint; dataType: GLenum; relativeOffset: GLuint); stdcall;
type PFNGLVERTEXARRAYVERTEXATTRIBBINDINGEXTPROC = procedure(
  vao, attribIndex, bindingIndex: GLuint); stdcall;
type PFNGLVERTEXARRAYVERTEXBINDINGDIVISOREXTPROC = procedure(
  vao, bindingIndex, divisor: GLuint); stdcall;

// PROC VARIABLE POINTERS
var
  glBindVertexBuffer:                   PFNGLBINDVERTEXBUFFERPROC;
  glVertexAttribFormat:                 PFNGLVERTEXATTRIBFORMATPROC;
  glVertexAttribIFormat:                PFNGLVERTEXATTRIBIFORMATPROC;
  glVertexAttribLFormat:                PFNGLVERTEXATTRIBLFORMATPROC;
  glVertexAttribBinding:                PFNGLVERTEXATTRIBBINDINGPROC;
  glVertexBindingDivisor:               PFNGLVERTEXBINDINGDIVISORPROC;
  glVertexArrayBindVertexBufferEXT:     PFNGLVERTEXARRAYBINDVERTEXBUFFEREXTPROC;
  glVertexArrayVertexAttribFormatEXT:   PFNGLVERTEXARRAYVERTEXATTRIBFORMATEXTPROC;
  glVertexArrayVertexAttribIFormatEXT:  PFNGLVERTEXARRAYVERTEXATTRIBIFORMATEXTPROC;
  glVertexArrayVertexAttribLFormatEXT:  PFNGLVERTEXARRAYVERTEXATTRIBLFORMATEXTPROC;
  glVertexArrayVertexAttribBindingEXT:  PFNGLVERTEXARRAYVERTEXATTRIBBINDINGEXTPROC;
  glVertexArrayVertexBindingDivisorEXT: PFNGLVERTEXARRAYVERTEXBINDINGDIVISOREXTPROC;
// End Core ARB Vertex attrib binding ******************************************


// Core ARB Texture view *******************************************************
{$DEFINE GL_ARB_texture_view}
const
  GL_ARB_texture_view_str = 'GL_ARB_texture_view';
  //
  GL_TEXTURE_VIEW_MIN_LEVEL   = $82DB;
  GL_TEXTURE_VIEW_NUM_LEVEL   = $82DC;
  GL_TEXTURE_VIEW_MIN_LAYER   = $82DD;
  GL_TEXTURE_VIEW_NUM_LAYERS  = $82DE;
  GL_TEXTURE_IMMUTABLE_LEVELS = $82DF;
  
// PROC PROTOTYPES
type PFNGLTEXTUREVIEWPROC = procedure(texture: GLuint; target: GLenum;
  origTexture: GLuint; internalFmt: GLenum;
  minLevel, numLevels, minLayer, numLayers: GLuint); stdcall;

// PROC VARIABLE POINTERS
var
  glTextureView: PFNGLTEXTUREVIEWPROC;
// End Core ARB Texture view ***************************************************


// Core ARB Internal format query 2 ********************************************
{$DEFINE GL_ARB_internalformat_query2}
const
  GL_ARB_internalformat_query2_str = 'GL_ARB_internalformat_query2';
  //
  GL_SAMPLES                                = $80A9;
  GL_INTERNALFORMAT_SUPPORTED               = $826F;
  GL_INTERNALFORMAT_PREFERRED               = $8270;
  GL_INTERNALFORMAT_RED_SIZE                = $8271;
  GL_INTERNALFORMAT_GREEN_SIZE              = $8272;
  GL_INTERNALFORMAT_BLUE_SIZE               = $8273;
  GL_INTERNALFORMAT_ALPHA_SIZE              = $8274;
  GL_INTERNALFORMAT_DEPTH_SIZE              = $8275;
  GL_INTERNALFORMAT_STENCIL_SIZE            = $8276;
  GL_INTERNALFORMAT_SHARED_SIZE             = $8277;
  GL_INTERNALFORMAT_RED_TYPE                = $8278;
  GL_INTERNALFORMAT_GREEN_TYPE              = $8279;
  GL_INTERNALFORMAT_BLUE_TYPE               = $827A;
  GL_INTERNALFORMAT_ALPHA_TYPE              = $827B;
  GL_INTERNALFORMAT_DEPTH_TYPE              = $827C;
  GL_INTERNALFORMAT_STENCIL_TYPE            = $827D;
  GL_MAX_WIDTH                              = $827E;
  GL_MAX_HEIGHT                             = $827F;
  GL_MAX_DEPTH                              = $8280;
  GL_MAX_LAYERS                             = $8281;
  GL_MAX_COMBINED_DIMENSIONS                = $8282;
  GL_COLOR_COMPONENTS                       = $8283;
  GL_DEPTH_COMPONENTS                       = $8284;
  GL_STENCIL_COMPONENTS                     = $8285;
  GL_COLOR_RENDERABLE                       = $8286;
  GL_DEPTH_RENDERABLE                       = $8287;
  GL_STENCIL_RENDERABLE                     = $8288;
  GL_FRAMEBUFFER_RENDERABLE                 = $8289;
  GL_FRAMEBUFFER_RENDERABLE_LAYERED         = $828A;
  GL_FRAMEBUFFER_BLEND                      = $828B;
  GL_READ_PIXELS                            = $828C;
  GL_READ_PIXELS_FORMAT                     = $828D;
  GL_READ_PIXELS_TYPE                       = $828E;
  GL_TEXTURE_IMAGE_FORMAT                   = $828F;
  GL_TEXTURE_IMAGE_TYPE                     = $8290;
  GL_GET_TEXTURE_IMAGE_FORMAT               = $8291;
  GL_GET_TEXTURE_IMAGE_TYPE                 = $8292;
  GL_MIPMAP                                 = $8293;
  GL_MANUAL_GENERATE_MIPMAP                 = $8294;
  GL_AUTO_GENERATE_MIPMAP                   = $8295;
  GL_COLOR_ENCODING                         = $8296;
  GL_SRGB_READ                              = $8297;
  GL_SRGB_WRITE                             = $8298;
  GL_SRGB_DECODE_ARB                        = $8299;
  GL_FILTER                                 = $829A;
  GL_VERTEX_TEXTURE                         = $829B;
  GL_TESS_CONTROL_TEXTURE                   = $829C;
  GL_TESS_EVALUATION_TEXTURE                = $829D;
  GL_GEOMETRY_TEXTURE                       = $829E;
  GL_FRAGMENT_TEXTURE                       = $829F;
  GL_COMPUTE_TEXTURE                        = $82A0;
  GL_TEXTURE_SHADOW                         = $82A1;
  GL_TEXTURE_GATHER                         = $82A2;
  GL_TEXTURE_GATHER_SHADOW                  = $82A3;
  GL_SHADER_IMAGE_LOAD                      = $82A4;
  GL_SHADER_IMAGE_STORE                     = $82A5;
  GL_SHADER_IMAGE_ATOMIC                    = $82A6;
  GL_IMAGE_TEXEL_SIZE                       = $82A7;
  GL_IMAGE_COMPATIBILITY_CLASS              = $82A8;
  GL_IMAGE_PIXEL_FORMAT                     = $82A9;
  GL_IMAGE_PIXEL_TYPE                       = $82AA;
  GL_SIMULTANEOUS_TEXTURE_AND_DEPTH_TEST    = $82AC;
  GL_SIMULTANEOUS_TEXTURE_AND_STENCIL_TEST  = $82AD;
  GL_SIMULTANEOUS_TEXTURE_AND_DEPTH_WRITE   = $82AE;
  GL_SIMULTANEOUS_TEXTURE_AND_STENCIL_WRITE = $82AF;
  GL_TEXTURE_COMPRESSED_BLOCK_WIDTH         = $82B1;
  GL_TEXTURE_COMPRESSED_BLOCK_HEIGHT        = $82B2;
  GL_TEXTURE_COMPRESSED_BLOCK_SIZE          = $82B3;
  GL_CLEAR_BUFFER                           = $82B4;
  GL_TEXTURE_VIEW                           = $82B5;
  GL_VIEW_COMPATIBILITY_CLASS               = $82B6;
  GL_FULL_SUPPORT                           = $82B7;
  GL_CAVEAT_SUPPORT                         = $82B8;
  GL_IMAGE_CLASS_4_X_32                     = $82B9;
  GL_IMAGE_CLASS_2_X_32                     = $82BA;
  GL_IMAGE_CLASS_1_X_32                     = $82BB;
  GL_IMAGE_CLASS_4_X_16                     = $82BC;
  GL_IMAGE_CLASS_2_X_16                     = $82BD;
  GL_IMAGE_CLASS_1_X_16                     = $82BE;
  GL_IMAGE_CLASS_4_X_8                      = $82BF;
  GL_IMAGE_CLASS_2_X_8                      = $82C0;
  GL_IMAGE_CLASS_1_X_8                      = $82C1;
  GL_IMAGE_CLASS_11_11_10                   = $82C2;
  GL_IMAGE_CLASS_10_10_10_2                 = $82C3;
  GL_VIEW_CLASS_128_BITS                    = $82C4;
  GL_VIEW_CLASS_96_BITS                     = $82C5;
  GL_VIEW_CLASS_64_BITS                     = $82C6;
  GL_VIEW_CLASS_48_BITS                     = $82C7;
  GL_VIEW_CLASS_32_BITS                     = $82C8;
  GL_VIEW_CLASS_24_BITS                     = $82C9;
  GL_VIEW_CLASS_16_BITS                     = $82CA;
  GL_VIEW_CLASS_8_BITS                      = $82CB;
  GL_VIEW_CLASS_S3TC_DXT1_RGB               = $82CC;
  GL_VIEW_CLASS_S3TC_DXT1_RGBA              = $82CD;
  GL_VIEW_CLASS_S3TC_DXT3_RGBA              = $82CE;
  GL_VIEW_CLASS_S3TC_DXT5_RGBA              = $82CF;
  GL_VIEW_CLASS_RGTC1_RED                   = $82D0;
  GL_VIEW_CLASS_RGTC2_RG                    = $82D1;
  GL_VIEW_CLASS_BPTC_UNORM                  = $82D2;
  GL_VIEW_CLASS_BPTC_FLOAT                  = $82D3;
  GL_VIEW_CLASS_EAC_R11                     = $9383;
  GL_VIEW_CLASS_EAC_RG11                    = $9384;
  GL_VIEW_CLASS_ETC2_RGB                    = $9385;
  GL_VIEW_CLASS_ETC2_RGBA                   = $9386;
  GL_VIEW_CLASS_ETC2_EAC_RGBA               = $9387;
  GL_VIEW_CLASS_ASTC_4x4_RGBA               = $9388;
  GL_VIEW_CLASS_ASTC_5x4_RGBA               = $9389;
  GL_VIEW_CLASS_ASTC_5x5_RGBA               = $938A;
  GL_VIEW_CLASS_ASTC_6x5_RGBA               = $938B;
  GL_VIEW_CLASS_ASTC_6x6_RGBA               = $938C;
  GL_VIEW_CLASS_ASTC_8x5_RGBA               = $938D;
  GL_VIEW_CLASS_ASTC_8x6_RGBA               = $938E;
  GL_VIEW_CLASS_ASTC_8x8_RGBA               = $938F;
  GL_VIEW_CLASS_ASTC_10x5_RGBA              = $9390;
  GL_VIEW_CLASS_ASTC_10x6_RGBA              = $9391;
  GL_VIEW_CLASS_ASTC_10x8_RGBA              = $9392;
  GL_VIEW_CLASS_ASTC_10x10_RGBA             = $9393;
  GL_VIEW_CLASS_ASTC_12x10_RGBA             = $9394;
  GL_VIEW_CLASS_ASTC_12x12_RGBA             = $9395;

  
// PROC PROTOTYPES
type PFNGLGETINTERNALFORMATI64PROC = procedure(target, internalFmt, pname: GLenum;
  bufSize: GLsizei; params: PGLint64); stdcall;

// PROC VARIABLE POINTERS
var
  glGetInternalformati64v: PFNGLGETINTERNALFORMATI64PROC;
// End Core ARB Internal format query 2 ****************************************


// Core ARB Texture storage multisample ****************************************
{$DEFINE GL_ARB_texture_storage_multisample}
const
  GL_ARB_texture_storage_multisample_str = 'GL_ARB_texture_storage_multisample';
  
// PROC PROTOTYPES
type PFNGLTEXSTORAGE2DMULTISAMPLEPROC = procedure(target: GLenum; samples: GLsizei;
  internalFmt: GLenum; width, height: GLsizei; fixedSampleLocation: GLboolean); stdcall;
type PFNGLTEXSTORAGE3DMULTISAMPLEPROC = procedure(target: GLenum; samples: GLsizei;
  internalFmt: GLenum; width, height, depth: GLsizei;
  fixedSampleLocation: GLboolean); stdcall;
type PFNGLTEXTURESTORAGE2DMULTISAMPLEEXTPROC = procedure(texture: GLuint;
  target: GLenum; samples: GLsizei; internalFmt: GLenum; width, height: GLsizei;
  fixedSampleLocation: GLboolean); stdcall;
type PFNGLTEXTURESTORAGE3DMULTISAMPLEEXTPROC = procedure(texture: GLuint;
  target: GLenum; samples: GLsizei; internalFmt: GLenum; width, height, depth: GLsizei;
  fixedSampleLocation: GLboolean); stdcall;

// PROC VARIABLE POINTERS
var
  glTexStorage2DMultisample:        PFNGLTEXSTORAGE2DMULTISAMPLEPROC;
  glTexStorage3DMultisample:        PFNGLTEXSTORAGE3DMULTISAMPLEPROC;
  glTextureStorage2DMultisampleEXT: PFNGLTEXTURESTORAGE2DMULTISAMPLEEXTPROC;
  glTextureStorage3DMultisampleEXT: PFNGLTEXTURESTORAGE3DMULTISAMPLEEXTPROC;
// End Core ARB Texture storage multisample ************************************


// Core ARB Texture buffer range ***********************************************
{$DEFINE GL_ARB_texture_buffer_range}
const
  GL_ARB_texture_buffer_range_str = 'GL_ARB_texture_buffer_range';
  //
  GL_TEXTURE_BUFFER_OFFSET            = $919D;
  GL_TEXTURE_BUFFER_SIZE              = $919E;
  GL_TEXTURE_BUFFER_OFFSET_ALIGNMENT  = $919F;
  
// PROC PROTOTYPES
type PFNGLTEXBUFFERRANGEPROC = procedure(target, internalFmt: GLenum; buffer: GLuint;
  offset: GLintptr; size: GLsizeiptr); stdcall;
type PFNGLTEXTUREBUFFERRANGEEXTPROC = procedure(texture: GLuint;
  target, internalFmt: GLenum; buffer: GLuint; offset: GLintptr;
  size: GLsizeiptr); stdcall;

// PROC VARIABLE POINTERS
var
  glTexBufferRange:         PFNGLTEXBUFFERRANGEPROC;
  glTextureBufferRangeEXT:  PFNGLTEXTUREBUFFERRANGEEXTPROC;
// End Core ARB Texture buffer range *******************************************


// Core ARB Stencil texturing **************************************************
{$DEFINE GL_ARB_stencil_texturing}
const
  GL_AGL_ARB_stencil_texturing_str = 'GL_ARB_stencil_texturing';
  //
  GL_DEPTH_STENCIL_TEXTURE_MODE = $90EA;
  
// End Core ARB Stencil texturing **********************************************


// Core ARB Shader storage buffer object (SBO) *********************************
{$DEFINE GL_ARB_shader_storage_buffer_object}
const
  GL_ARB_shader_storage_buffer_object_str = 'GL_ARB_shader_storage_buffer_object';
  //
  GL_SHADER_STORAGE_BUFFER                      = $90D2;
  GL_SHADER_STORAGE_BUFFER_BINDING              = $90D3;
  GL_SHADER_STORAGE_BUFFER_START                = $90D4;
  GL_SHADER_STORAGE_BUFFER_SIZE                 = $90D5;
  GL_MAX_VERTEX_SHADER_STORAGE_BLOCKS           = $90D6;
  GL_MAX_GEOMETRY_SHADER_STORAGE_BLOCKS         = $90D7;
  GL_MAX_TESS_CONTROL_SHADER_STORAGE_BLOCKS     = $90D8;
  GL_MAX_TESS_EVALUATION_SHADER_STORAGE_BLOCKS  = $90D9;
  GL_MAX_FRAGMENT_SHADER_STORAGE_BLOCKS         = $90DA;
  GL_MAX_COMPUTE_SHADER_STORAGE_BLOCKS          = $90DB;
  GL_MAX_COMBINED_SHADER_STORAGE_BLOCKS         = $90DC;
  GL_MAX_SHADER_STORAGE_BUFFER_BINDINGS         = $90DD;
  GL_MAX_SHADER_STORAGE_BLOCK_SIZE              = $90DE;
  GL_SHADER_STORAGE_BUFFER_OFFSET_ALIGNMENT     = $90DF;
  GL_SHADER_STORAGE_BARRIER_BIT                 = $2000;
  GL_MAX_COMBINED_SHADER_OUTPUT_RESOURCES       = $8F39;
  
// PROC PROTOTYPES
type PFNGLSHADERSTORAGEBLOCKBINDINGPROC = procedure(
  programObj, storageBlockIndex, storageBlockBinding: GLuint); stdcall;

// PROC VARIABLE POINTERS
var
  glShaderStorageBlockBinding: PFNGLSHADERSTORAGEBLOCKBINDINGPROC;
// End Core ARB Shader storage buffer object (SBO) *****************************


// Core ARB Multi draw indirect ************************************************
{$DEFINE GL_ARB_multi_draw_indirect}
const
  GL_ARB_multi_draw_indirect_str = 'GL_ARB_multi_draw_indirect';
  
// PROC PROTOTYPES
type PFNGLMULTIDRAWARRAYSINDIRECTPROC = procedure(mode: GLenum; const indirect: PGLvoid;
  primcount, stride: GLsizei); stdcall;
type PFNGLMULTIDRAWELEMENTSINDIRECTPROC = procedure(mode, dataType: GLenum;
  const indirect: PGLvoid; primcount, stride: GLsizei); stdcall;

// PROC VARIABLE POINTERS
var
  glMultiDrawArraysIndirect:    PFNGLMULTIDRAWARRAYSINDIRECTPROC;
  glMultiDrawElementsIndirect:  PFNGLMULTIDRAWELEMENTSINDIRECTPROC;
// End Core ARB Multi draw indirect ********************************************


// Core ARB Invalidate subdata *************************************************
{$DEFINE GL_ARB_invalidate_subdata}
const
  GL_ARB_invalidate_subdata_str = 'GL_ARB_invalidate_subdata';
  
// PROC PROTOTYPES
type PFNGLINVALIDATETEXSUBIMAGEPROC = procedure(texture: GLuint;
  level, xoffset, yoffset, zoffset: GLint;
  width, height, depth: GLsizei); stdcall;
type PFNGLINVALIDATETEXIMAGEPROC = procedure(texture: GLuint; level: GLint); stdcall;
type PFNGLINVALIDATEBUFFERSUBDATAPROC = procedure(buffer: Gluint; offset: GLintptr;
  length: GLsizeiptr); stdcall;
type PFNGLINVALIDATEBUFFERDATAPROC = procedure(buffer: Gluint); stdcall;
type PFNGLINVALIDATEFRAMEBUFFERPROC = procedure(target: GLenum;
  numAttachments: GLsizei; const attachments: PGLenum); stdcall;
type PFNGLINVALIDATESUBFRAMEBUFFERPROC = procedure(target: GLenum;
  numAttachments: GLsizei; const attachments: PGLenum;
  x, y: GLint; width, height: GLsizei); stdcall;

// PROC VARIABLE POINTERS
var
  glInvalidateTexSubImage:    PFNGLINVALIDATETEXSUBIMAGEPROC;
  glInvalidateTexImage:       PFNGLINVALIDATETEXIMAGEPROC;
  glInvalidateBufferSubData:  PFNGLINVALIDATEBUFFERSUBDATAPROC;
  glInvalidateBufferData:     PFNGLINVALIDATEBUFFERDATAPROC;
  glInvalidateFramebuffer:    PFNGLINVALIDATEFRAMEBUFFERPROC;
  glInvalidateSubFramebuffer: PFNGLINVALIDATESUBFRAMEBUFFERPROC;
// End Core ARB Invalidate subdata *********************************************


// Core ARB OpenGL ES 3.0 compatibility ****************************************
{$DEFINE GL_ARB_ES3_compatibility}
const
  GL_ARB_ES3_compatibility_str = 'GL_ARB_ES3_compatibility';
  //
  GL_COMPRESSED_RGB8_ETC2                       = $9274;
  GL_COMPRESSED_SRGB8_ETC2                      = $9275;
  GL_COMPRESSED_RGB8_PUNCHTHROUGH_ALPHA1_ETC2   = $9276;
  GL_COMPRESSED_SRGB8_PUNCHTHROUGH_ALPHA1_ETC2  = $9277;
  GL_COMPRESSED_RGBA8_ETC2_EAC                  = $9278;
  GL_COMPRESSED_SRGB8_ALPHA8_ETC2_EAC           = $9279;
  GL_COMPRESSED_R11_EAC                         = $9270;
  GL_COMPRESSED_SIGNED_R11_EAC                  = $9271;
  GL_COMPRESSED_RG11_EAC                        = $9272;
  GL_COMPRESSED_SIGNED_RG11_EAC                 = $9273;
  GL_PRIMITIVE_RESTART_FIXED_INDEX              = $8D69;
  GL_ANY_SAMPLES_PASSED_CONSERVATIVE            = $8D6A;
  GL_MAX_ELEMENT_INDEX                          = $8D6B;

// End Core ARB OpenGL ES 3.0 compatibility  ***********************************


// Core ARB Copy image *********************************************************
{$DEFINE GL_ARB_copy_image}
const
  GL_ARB_copy_image_str = 'GL_ARB_copy_image';
  
// PROC PROTOTYPES
type PFNGLCOPYIMAGESUBDATAPROC = procedure(
  srcName: GLuint; srcTarget: GLenum;
  srcLevel, srcX, srcY, srcZ: GLint;
  dstName: GLuint; dstTarget: GLenum;
  dstLevel, dstX, dstY, dstZ: GLint;
  srcWidth, srcHeight, srcDepth: GLsizei); stdcall;

// PROC VARIABLE POINTERS
var
  glCopyImageSubData: PFNGLCOPYIMAGESUBDATAPROC;
// End Core ARB Copy image *****************************************************


// Core ARB Compute shader *****************************************************
{$DEFINE GL_ARB_compute_shader}
const
  GL_ARB_compute_shader_str = 'GL_ARB_compute_shader';
  //
  GL_COMPUTE_SHADER                                     = $91B9;
  GL_MAX_COMPUTE_UNIFORM_BLOCKS                         = $91BB;
  GL_MAX_COMPUTE_TEXTURE_IMAGE_UNITS                    = $91BC;
  GL_MAX_COMPUTE_IMAGE_UNIFORMS                         = $91BD;
  GL_MAX_COMPUTE_SHARED_MEMORY_SIZE                     = $8262;
  GL_MAX_COMPUTE_UNIFORM_COMPONENTS                     = $8263;
  GL_MAX_COMPUTE_ATOMIC_COUNTER_BUFFERS                 = $8264;
  GL_MAX_COMPUTE_ATOMIC_COUNTERS                        = $8265;
  GL_MAX_COMBINED_COMPUTE_UNIFORM_COMPONENTS            = $8266;
  GL_MAX_COMPUTE_WORK_GROUP_INVOCATIONS                 = $90EB;
  GL_MAX_COMPUTE_WORK_GROUP_COUNT                       = $91BE;
  GL_MAX_COMPUTE_WORK_GROUP_SIZE                        = $91BF;
  GL_COMPUTE_WORK_GROUP_SIZE                            = $8267;
  GL_UNIFORM_BLOCK_REFERENCED_BY_COMPUTE_SHADER         = $90EC;
  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_COMPUTE_SHADER = $90ED;
  GL_DISPATCH_INDIRECT_BUFFER                           = $90EE;
  GL_DISPATCH_INDIRECT_BUFFER_BINDING                   = $90EF;
  GL_COMPUTE_SHADER_BIT                                 = $00000020;
  
// PROC PROTOTYPES
type PFNGLDISPATCHCOMPUTEPROC = procedure(
  num_groups_x, num_groups_y, num_groups_z: GLuint); stdcall;
type PFNGLDISPATCHCOMPUTEINDIRECTPROC = procedure(indirect: GLintptr); stdcall;

// PROC VARIABLE POINTERS
var
  glDispatchCompute:          PFNGLDISPATCHCOMPUTEPROC;
  glDispatchComputeIndirect:  PFNGLDISPATCHCOMPUTEINDIRECTPROC;
// End Core ARB Compute shader *************************************************


// Core ARB Clear buffer object ************************************************
{$DEFINE GL_ARB_clear_buffer_object}
const
  GL_ARB_clear_buffer_object_str = 'GL_ARB_clear_buffer_object';
  
// PROC PROTOTYPES
type PFNGLCLEARBUFFERDATAPROC = procedure(target, internalFmt, dataFmt, dataType: GLenum;
  const data: PGLvoid); stdcall;
type PFNGLCLEARBUFFERSUBDATAPROC = procedure(target, internalFmt: GLenum;
  offset: GLintptr; size: GLsizeiptr; dataFmt, dataType: GLenum;
  const data: PGLvoid); stdcall;
type PFNGLCLEARNAMEDBUFFERDATAEXTPROC = procedure(buffer: GLuint;
  internalFmt, dataFmt, dataType: GLenum; const data: PGLvoid); stdcall;
type PFNGLCLEARNAMEDBUFFERSUBDATAEXTPROC = procedure(buffer: GLuint;
  internalFmt: GLenum; offset: GLintptr; size: GLsizeiptr; dataFmt, dataType: GLenum;
  const data: PGLvoid); stdcall;

// PROC VARIABLE POINTERS
var
  glClearBufferData:            PFNGLCLEARBUFFERDATAPROC;
  glClearBufferSubData:         PFNGLCLEARBUFFERSUBDATAPROC;
  glClearNamedBufferDataEXT:    PFNGLCLEARNAMEDBUFFERDATAEXTPROC;
  glClearNamedBufferSubDataEXT: PFNGLCLEARNAMEDBUFFERSUBDATAEXTPROC;
// End Core ARB Clear buffer object ********************************************


// Core ARB Framebuffer no attachments *****************************************
{$DEFINE GL_ARB_framebuffer_no_attachments}
const
  GL_ARB_framebuffer_no_attachments_str = 'GL_ARB_framebuffer_no_attachments';
  //
  GL_FRAMEBUFFER_DEFAULT_WIDTH                  = $9310;
  GL_FRAMEBUFFER_DEFAULT_HEIGHT                 = $9311;
  GL_FRAMEBUFFER_DEFAULT_LAYERS                 = $9312;
  GL_FRAMEBUFFER_DEFAULT_SAMPLES                = $9313;
  GL_FRAMEBUFFER_DEFAULT_FIXED_SAMPLE_LOCATIONS = $9314;
  GL_MAX_FRAMEBUFFER_WIDTH                      = $9315;
  GL_MAX_FRAMEBUFFER_HEIGHT                     = $9316;
  GL_MAX_FRAMEBUFFER_LAYERS                     = $9317;
  GL_MAX_FRAMEBUFFER_SAMPLES                    = $9318;
  
// PROC PROTOTYPES
type PFNGLFRAMEBUFFERPARAMETERIPROC = procedure(target, pname: GLenum;
  param: GLint); stdcall;
type PFNGLGETFRAMEBUFFERPARAMETERIVPROC = procedure(target, pname: GLenum;
  params: PGLint); stdcall;
type PFNGLNAMEDFRAMEBUFFERPARAMETERIEXTPROC = procedure(framebuffer: GLuint;
  pname: GLenum; param: GLint); stdcall;
type PFNGLGETNAMEDFRAMEBUFFERPARAMETERIVEXTPROC = procedure(framebuffer: GLuint;
  pname: GLenum; params: PGLint); stdcall;

// PROC VARIABLE POINTERS
var
  glFramebufferParameteri:              PFNGLFRAMEBUFFERPARAMETERIPROC;
  glGetFramebufferParameteriv:          PFNGLGETFRAMEBUFFERPARAMETERIVPROC;
  glNamedFramebufferParameteriEXT:      PFNGLNAMEDFRAMEBUFFERPARAMETERIEXTPROC;
  glGetNamedFramebufferParameterivEXT:  PFNGLGETNAMEDFRAMEBUFFERPARAMETERIVEXTPROC;
// End Core ARB Framebuffer no attachments *************************************


// Core ARB Program interface query ********************************************
{$DEFINE GL_ARB_program_interface_query}
const
  GL_ARB_program_interface_query_str = 'GL_ARB_program_interface_query';
  //
  GL_UNIFORM                              = $92E1;
  GL_UNIFORM_BLOCK                        = $92E2;
  GL_PROGRAM_INPUT                        = $92E3;
  GL_PROGRAM_OUTPUT                       = $92E4;
  GL_BUFFER_VARIABLE                      = $92E5;
  GL_SHADER_STORAGE_BLOCK                 = $92E6;
  GL_VERTEX_SUBROUTINE                    = $92E8;
  GL_TESS_CONTROL_SUBROUTINE              = $92E9;
  GL_TESS_EVALUATION_SUBROUTINE           = $92EA;
  GL_GEOMETRY_SUBROUTINE                  = $92EB;
  GL_FRAGMENT_SUBROUTINE                  = $92EC;
  GL_COMPUTE_SUBROUTINE                   = $92ED;
  GL_VERTEX_SUBROUTINE_UNIFORM            = $92EE;
  GL_TESS_CONTROL_SUBROUTINE_UNIFORM      = $92EF;
  GL_TESS_EVALUATION_SUBROUTINE_UNIFORM   = $92F0;
  GL_GEOMETRY_SUBROUTINE_UNIFORM          = $92F1;
  GL_FRAGMENT_SUBROUTINE_UNIFORM          = $92F2;
  GL_COMPUTE_SUBROUTINE_UNIFORM           = $92F3;
  GL_TRANSFORM_FEEDBACK_VARYING           = $92F4;
  GL_ACTIVE_RESOURCES                     = $92F5;
  GL_MAX_NAME_LENGTH                      = $92F6;
  GL_MAX_NUM_ACTIVE_VARIABLES             = $92F7;
  GL_MAX_NUM_COMPATIBLE_SUBROUTINES       = $92F8;
  GL_NAME_LENGTH                          = $92F9;
  GL_TYPE                                 = $92FA;
  GL_ARRAY_SIZE                           = $92FB;
  GL_OFFSET                               = $92FC;
  GL_BLOCK_INDEX                          = $92FD;
  GL_ARRAY_STRIDE                         = $92FE;
  GL_MATRIX_STRIDE                        = $92FF;
  GL_IS_ROW_MAJOR                         = $9300;
  GL_ATOMIC_COUNTER_BUFFER_INDEX          = $9301;
  GL_BUFFER_BINDING                       = $9302;
  GL_BUFFER_DATA_SIZE                     = $9303;
  GL_NUM_ACTIVE_VARIABLES                 = $9304;
  GL_ACTIVE_VARIABLES                     = $9305;
  GL_REFERENCED_BY_VERTEX_SHADER          = $9306;
  GL_REFERENCED_BY_TESS_CONTROL_SHADER    = $9307;
  GL_REFERENCED_BY_TESS_EVALUATION_SHADER = $9308;
  GL_REFERENCED_BY_GEOMETRY_SHADER        = $9309;
  GL_REFERENCED_BY_FRAGMENT_SHADER        = $930A;
  GL_REFERENCED_BY_COMPUTE_SHADER         = $930B;
  GL_TOP_LEVEL_ARRAY_SIZE                 = $930C;
  GL_TOP_LEVEL_ARRAY_STRIDE               = $930D;
  GL_LOCATION                             = $930E;
  GL_LOCATION_INDEX                       = $930F;
  GL_IS_PER_PATCH                         = $92E7;
  
// PROC PROTOTYPES
type PFNGLGETPROGRAMINTERFACEIVPROC = procedure(programObj: GLuint;
  programInferface, pname: GLenum; params: PGLint); stdcall;
type PFNGLGETPROGRAMRESOURCEINDEXPROC = function(programObj: GLuint;
  programInferface: GLenum; const name: PGLchar): GLuint; stdcall;
type PFNGLGETPROGRAMRESOURCENAMEPROC = procedure(programObj: GLuint;
  programInferface: GLenum; index: GLuint; bufSize: GLsizei; length: PGLsizei;
  name: PGLchar); stdcall;
type PFNGLGETPROGRAMRESOURCEIVPROC = procedure(programObj: GLuint;
  programInferface: GLenum; index: GLuint; propCount: GLsizei;
  const props: PGLenum; bufSize: GLsizei; length: PGLsizei;
  params: PGLint); stdcall;
type PFNGLGETPROGRAMRESOURCELOCATIONPROC = function(programObj: GLuint;
  programInferface: GLenum; const name: PGLchar): GLint; stdcall;
type PFNGLGETPROGRAMRESOURCELOCATIONINDEXPROC = function(programObj: GLuint;
  programInferface: GLenum; const name: PGLchar): GLint; stdcall;

// PROC VARIABLE POINTERS
var
  glGetProgramInterfaceiv:            PFNGLGETPROGRAMINTERFACEIVPROC;
  glGetProgramResourceIndex:          PFNGLGETPROGRAMRESOURCEINDEXPROC;
  glGetProgramResourceName:           PFNGLGETPROGRAMRESOURCENAMEPROC;
  glGetProgramResourceiv:             PFNGLGETPROGRAMRESOURCEIVPROC;
  glGetProgramResourceLocation:       PFNGLGETPROGRAMRESOURCELOCATIONPROC;
  glGetProgramResourceLocationIndex:  PFNGLGETPROGRAMRESOURCELOCATIONINDEXPROC;
// End Core ARB Program interface query ****************************************


// Core ARB KHR Debug **********************************************************
{$DEFINE GL_KHR_debug}
const
  GL_KHR_debug_str = 'GL_KHR_debug';
  //
  GL_DEBUG_OUTPUT                     = $92E0;
  GL_DEBUG_OUTPUT_SYNCHRONOUS         = $8242;
  GL_CONTEXT_FLAG_DEBUG_BIT           = $00000002;
  GL_MAX_DEBUG_MESSAGE_LENGTH         = $9143;
  GL_MAX_DEBUG_LOGGED_MESSAGES        = $9144;
  GL_DEBUG_LOGGED_MESSAGES            = $9145;
  GL_DEBUG_NEXT_LOGGED_MESSAGE_LENGTH = $8243;
  GL_MAX_DEBUG_GROUP_STACK_DEPTH      = $826C;
  GL_DEBUG_GROUP_STACK_DEPTH          = $826D;
  GL_MAX_LABEL_LENGTH                 = $82E8;
  GL_DEBUG_CALLBACK_FUNCTION          = $8244;
  GL_DEBUG_CALLBACK_USER_PARAM        = $8245;
  GL_DEBUG_SOURCE_API                 = $8246;
  GL_DEBUG_SOURCE_WINDOW_SYSTEM       = $8247;
  GL_DEBUG_SOURCE_SHADER_COMPILER     = $8248;
  GL_DEBUG_SOURCE_THIRD_PARTY         = $8249;
  GL_DEBUG_SOURCE_APPLICATION         = $824A;
  GL_DEBUG_SOURCE_OTHER               = $824B;
  GL_DEBUG_TYPE_ERROR                 = $824C;
  GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR   = $824D;
  GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR    = $824E;
  GL_DEBUG_TYPE_PORTABILITY           = $824F;
  GL_DEBUG_TYPE_PERFORMANCE           = $8250;
  GL_DEBUG_TYPE_OTHER                 = $8251;
  GL_DEBUG_TYPE_MARKER                = $8268;
  GL_DEBUG_TYPE_PUSH_GROUP            = $8269;
  GL_DEBUG_TYPE_POP_GROUP             = $826A;
  GL_DEBUG_SEVERITY_HIGH              = $9146;
  GL_DEBUG_SEVERITY_MEDIUM            = $9147;
  GL_DEBUG_SEVERITY_LOW               = $9148;
  GL_DEBUG_SEVERITY_NOTIFICATION      = $826B;
  GL_STACK_UNDERFLOW                  = $0504;
  GL_STACK_OVERFLOW                   = $0503;
  GL_BUFFER                           = $82E0;
  GL_SHADER                           = $82E1;
  GL_PROGRAM                          = $82E2;
  GL_QUERY                            = $82E3;
  GL_PROGRAM_PIPELINE                 = $82E4;
  GL_SAMPLER                          = $82E6;
  GL_DISPLAY_LIST                     = $82E7;
  
// PROC PROTOTYPES
type PFNGLDEBUGMESSAGECONTROLPROC = procedure(source, debugType, severity: GLenum;
  count: GLsizei; const ids: PGLint; enabled: GLboolean); stdcall;
type PFNGLDEBUGMESSAGEINSERTPROC = procedure(source, debugType: GLenum;
  id: GLuint; severity: GLenum; length: GLsizei; const buf: PGLchar); stdcall;
type PFNGLDEBUGMESSAGECALLBACKPROC = procedure(callback: GLDEBUGPROC;
  const userParam: PGLvoid); stdcall;
type PFNGLGETDEBUGMESSAGELOGPROC = function(count: GLuint; bufSize: GLsizei;
  sources, debugTypes: PGLenum; ids: PGLint; severities: PGLenum;
    lengths: PGLsizei; messageLog: PGLchar): GLuint; stdcall;
type PFNGLPUSHDEBUGGROUPPROC = procedure(source: GLenum; id: GLuint;
  length: GLsizei; const msg: PGLchar); stdcall;
type PFNGLPOPDEBUGGROUPPROC = procedure(); stdcall;
type PFNGLOBJECTLABELPROC = procedure(identifier: GLenum; name: GLuint;
  length: GLsizei; const strLabel: PGLchar); stdcall;
type PFNGLGETOBJECTLABELPROC = procedure(identifier: GLenum; name: GLuint;
  bufSize: GLsizei; length: PGLsizei; strLabel: PGLchar); stdcall;
type PFNGLOBJECTPTRLABELPROC = procedure(ptr: PGLvoid; length: GLsizei;
  const strLabel: PGLchar); stdcall;
type PFNGLGETOBJECTPTRLABELPROC = procedure(ptr: PGLvoid; bufSize: GLsizei;
  length: PGLsizei; strLabel: PGLchar); stdcall;

// PROC VARIABLE POINTERS
var
  glDebugMessageControl:  PFNGLDEBUGMESSAGECONTROLPROC;
  glDebugMessageInsert:   PFNGLDEBUGMESSAGEINSERTPROC;
  glDebugMessageCallback: PFNGLDEBUGMESSAGECALLBACKPROC;
  glGetDebugMessageLog:   PFNGLGETDEBUGMESSAGELOGPROC;
  glPushDebugGroup:       PFNGLPUSHDEBUGGROUPPROC;
  glPopDebugGroup:        PFNGLPOPDEBUGGROUPPROC;
  glObjectLabel:          PFNGLOBJECTLABELPROC;
  glGetObjectLabel:       PFNGLGETOBJECTLABELPROC;
  glObjectPtrLabel:       PFNGLOBJECTPTRLABELPROC;
  glGetObjectPtrLabel:    PFNGLGETOBJECTPTRLABELPROC;
// End Core ARB KHR Debug ******************************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 4.4 Core Extensions    ////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_4_4}


// Core ARB Texture stencil 8 **************************************************
{$DEFINE GL_ARB_texture_stencil8}
const
  GL_ARB_texture_stencil8_str = 'GL_ARB_texture_stencil8';
  //
  GL_STENCIL_INDEX  = $1901;

// End Core ARB Texture stencil 8 **********************************************


// Core ARB Texture mirror clamp to edge ***************************************
{$DEFINE GL_ARB_texture_mirror_clamp_to_edge}
const
  GL_ARB_texture_mirror_clamp_to_edge_str = 'GL_ARB_texture_mirror_clamp_to_edge';
  //
  GL_MIRROR_CLAMP_TO_EDGE = $8743;
  
// End Core ARB Texture mirror clamp to edge ***********************************


// Core ARB Query buffer object ************************************************
{$DEFINE GL_ARB_query_buffer_object}
const
  GL_ARB_query_buffer_object_str = 'GL_ARB_query_buffer_object';
  //
  GL_QUERY_BUFFER             = $9192;
  GL_QUERY_BUFFER_BINDING     = $9193;
  GL_QUERY_RESULT_NO_WAIT     = $9194;
  GL_QUERY_BUFFER_BARRIER_BIT = $00008000;
  
// End Core ARB Query buffer object ********************************************


// Core ARB Enhanced layouts ***************************************************
{$DEFINE GL_ARB_enhanced_layouts}
const
  GL_ARB_enhanced_layouts_str = 'GL_ARB_enhanced_layouts';
  //
  GL_LOCATION_COMPONENT               = $934A;
  GL_TRANSFORM_FEEDBACK_BUFFER_INDEX  = $934B;
  GL_TRANSFORM_FEEDBACK_BUFFER_STRIDE = $934C;

// End Core ARB Enhanced layout ************************************************


// Core ARB Clear texture ******************************************************
{$DEFINE GL_ARB_clear_texture}
const
  GL_ARB_clear_texture_str = 'GL_ARB_clear_texture';
  //
  GL_CLEAR_TEXTURE = $9365;
  
// PROC PROTOTYPES
type PFNGLCLEARTEXIMAGEPROC = procedure(
    texture: GLuint;
    level: GLint;
    textureFmt, dataType: GLenum;
    const data: PGLvoid
  ); stdcall;
type PFNGLCLEARTEXSUBIMAGEPROC = procedure(
    texture: GLuint;
    level, xoffset, yoffset, zoffset: GLint;
    width, height, depth: GLsizei;
    textureFmt, dataType: GLenum;
    const data: PGLvoid
  ); stdcall;

// PROC VARIABLE POINTERS
var
  glClearTexImage:    PFNGLCLEARTEXIMAGEPROC;
  glClearTexSubImage: PFNGLCLEARTEXSUBIMAGEPROC;
// End Core ARB Clear texture **************************************************


// Core ARB Multi bind *********************************************************
{$DEFINE GL_ARB_multi_bind}
const
  GL_ARB_multi_bind_str = 'GL_ARB_multi_bind';
  
// PROC PROTOTYPES
type PFNGLBINDBUFFERSBASEPROC = procedure(target: GLenum; first: GLuint;
  count: GLsizei; const buffers: PGLuint); stdcall;
type PFNGLBINDBUFFERSRANGEPROC = procedure(target: GLenum; first: GLuint;
  count: GLsizei; const buffers: PGLuint; const offsets: PGLintptr;
  const sizes: PGLsizeiptr); stdcall;
type PFNGLBINDTEXTURESPROC = procedure(first: GLuint; count: GLsizei;
  const textures: PGLuint); stdcall;
type PFNGLBINDSAMPLERSPROC = procedure(first: GLuint; count: GLsizei;
  const samplers: PGLuint); stdcall;
type PFNGLBINDIMAGETEXTURESPROC = procedure(first: GLuint; count: GLsizei;
  const textures: PGLuint); stdcall;
type PFNGLBINDVERTEXBUFFERSPROC = procedure(first: GLuint; count: GLsizei;
  const buffers: PGLuint; const offsets: PGLintptr;
  const strides: PGLsizei); stdcall;

// PROC VARIABLE POINTERS
var
  glBindBuffersBase:    PFNGLBINDBUFFERSBASEPROC;
  glBindBuffersRange:   PFNGLBINDBUFFERSRANGEPROC;
  glBindTextures:       PFNGLBINDTEXTURESPROC;
  glBindSamplers:       PFNGLBINDSAMPLERSPROC;
  glBindImageTextures:  PFNGLBINDIMAGETEXTURESPROC;
  glBindVertexBuffers:  PFNGLBINDVERTEXBUFFERSPROC;
// End Core ARB Multi bind *****************************************************


// Core ARB Buffer storage *****************************************************
{$DEFINE GL_ARB_buffer_storage}
const
  GL_ARB_buffer_storage_str = 'GL_ARB_buffer_storage';
  //
  GL_MAP_READ_BIT                     = $0001;
  GL_MAP_WRITE_BIT                    = $0002;
  GL_MAP_PERSISTENT_BIT               = $0040;
  GL_MAP_COHERENT_BIT                 = $0080;
  GL_DYNAMIC_STORAGE_BIT              = $0100;
  GL_CLIENT_STORAGE_BIT               = $0200;
  GL_BUFFER_IMMUTABLE_STORAGE         = $821F;
  GL_BUFFER_STORAGE_FLAGS             = $8220;
  GL_CLIENT_MAPPED_BUFFER_BARRIER_BIT = $00004000;
  
// PROC PROTOTYPES
type PFNGLBUFFERSTORAGEPROC = procedure(target: GLenum; size: GLsizeiptr;
  const data: PGLvoid; flags: GLbitfield); stdcall;
type PFNGLNAMEDBUFFERSTORAGEEXTPROC = procedure(buffer: GLuint; size: GLsizeiptr;
  const data: PGLvoid; flags: GLbitfield); stdcall;

// PROC VARIABLE POINTERS
var
  glBufferStorage:          PFNGLBUFFERSTORAGEPROC;
  glNamedBufferStorageEXT:  PFNGLNAMEDBUFFERSTORAGEEXTPROC;
// End Core ARB Buffer storage *************************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 4.5 Core Extensions    ////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_4_5}


// Core ARB KHR roubstness *****************************************************
{$DEFINE GL_KHR_robustness}
const
  GL_KHR_robustness_str = 'GL_KHR_robustness';
  //
  GL_NO_ERROR                     = $0000;
  GL_GUILTY_CONTEXT_RESET         = $8253;
  GL_INNOCENT_CONTEXT_RESET       = $8254;
  GL_UNKNOWN_CONTEXT_RESET        = $8255;
  GL_CONTEXT_ROBUST_ACCESS        = $90F3;
  GL_RESET_NOTIFICATION_STRATEGY  = $8256;
  GL_LOSE_CONTEXT_ON_RESET        = $8252;
  GL_NO_RESET_NOTIFICATION        = $8261;
  GL_CONTEXT_LOST                 = $0507;
  
// PROC PROTOTYPES
type PFNGLGETGRAPHICSRESETSTATUSPROC = function(): GLenum; stdcall;
type PFNGLREADNPIXELSPROC = procedure(x, y: GLint; width, height: GLsizei;
  pixelFmt, dataType: GLenum; bufSize: GLsizei; data: PGLvoid); stdcall;
type PFNGLGETNUNIFORMFVPROC = procedure(programObj: GLuint; location: GLint;
  bufSize: GLsizei; params: PGLfloat); stdcall;
type PFNGLGETNUNIFORMIVPROC = procedure(programObj: GLuint; location: GLint;
  bufSize: GLsizei; params: PGLint); stdcall;
type PFNGLGETNUNIFORMUIVPROC = procedure(programObj: GLuint; location: GLint;
  bufSize: GLsizei; params: PGLuint); stdcall;

// PROC VARIABLE POINTERS
var
  glGetGraphicsResetStatus: PFNGLGETGRAPHICSRESETSTATUSPROC;
  glReadnPixels:            PFNGLREADNPIXELSPROC;
  glGetnUniformfv:          PFNGLGETNUNIFORMFVPROC;
  glGetnUniformiv:          PFNGLGETNUNIFORMIVPROC;
  glGetnUniformuiv:         PFNGLGETNUNIFORMUIVPROC;
// End Core ARB KHR roubstness *************************************************


// Core ARB Get texture sub image **********************************************
{$DEFINE GL_ARB_get_texture_sub_image}
const
  GL_ARB_get_texture_sub_image_str = 'GL_ARB_get_texture_sub_image';
  
// PROC PROTOTYPES
type PFNGLGETTEXTURESUBIMAGEPROC = procedure(
    texture: GLuint;
    level, xoffset, yoffset, zoffset: GLint;
    width, height, depth: GLsizei;
    pixelFmt, dataType: GLenum;
    bufSize: GLsizei;
    data: PGLvoid
  ); stdcall;
type PFNGLGETCOMPRESSEDTEXTURESUBIMAGEPROC = procedure(
    texture: GLuint;
    level, xoffset, yoffset, zoffset: GLint;
    width, height, depth, bufSize: GLsizei;
    data: PGLvoid
  ); stdcall;

// PROC VARIABLE POINTERS
var
  glGetTextureSubImage:           PFNGLGETTEXTURESUBIMAGEPROC;
  glGetCompressedTextureSubImage: PFNGLGETCOMPRESSEDTEXTURESUBIMAGEPROC;
// End Core ARB Get texture sub image ******************************************


// Core ARB Conditional render inverted ****************************************
{$DEFINE GL_ARB_conditional_render_inverted}
const
  GL_ARB_conditional_render_inverted_str = 'GL_ARB_conditional_render_inverted';
  //
  GL_QUERY_WAIT_INVERTED              = $8E17;
  GL_QUERY_NO_WAIT_INVERTED           = $8E18;
  GL_QUERY_BY_REGION_WAIT_INVERTED    = $8E19;
  GL_QUERY_BY_REGION_NO_WAIT_INVERTED = $8E1A;
  
// End Core ARB Conditional render inverted ************************************


// Core ARB Cull distance ******************************************************
{$DEFINE GL_ARB_cull_distance}
const
  GL_ARB_cull_distance_str = 'GL_ARB_cull_distance';
  //
  GL_MAX_CULL_DISTANCES                 = $82F9;
  MAX_COMBINED_CLIP_AND_CULL_DISTANCES  = $82FA;
  
// End Core ARB Cull distance **************************************************


// Core ARB OpenGL ES 3.1 Compatibility ****************************************
{$DEFINE GL_ARB_ES3_1_compatibility}
const
  GL_ARB_ES3_1_compatibility_str = 'GL_ARB_ES3_1_compatibility';
  
// PROC PROTOTYPES
type PFNGLMEMORYBARRIERBYREGIONPROC = procedure(barriers: GLbitfield); stdcall;

// PROC VARIABLE POINTERS
var
  glMemoryBarrierByRegion: PFNGLMEMORYBARRIERBYREGIONPROC;
// End Core ARB OpenGL ES 3.1 Compatibility ************************************


// Core ARB Clip Control *******************************************************
{$DEFINE GL_ARB_clip_control}
const
  GL_ARB_clip_control_str = 'GL_ARB_clip_control';
  //
  GL_LOWER_LEFT           = $8CA1;
  GL_UPPER_LEFT           = $8CA2;
  GL_NEGATIVE_ONE_TO_ONE  = $935E;
  GL_ZERO_TO_ONE          = $935F;
  GL_CLIP_ORIGIN          = $935C;
  GL_CLIP_DEPTH_MODE      = $935D;
  
// PROC PROTOTYPES
type PFNGLCLIPCONTROLPROC = procedure(origin, depth: GLenum); stdcall;

// PROC VARIABLE POINTERS
var
  glClipControl: PFNGLCLIPCONTROLPROC;
// End Core ARB Clip Control ***************************************************


// Core ARB Direct state access ************************************************
{$DEFINE GL_ARB_direct_state_access}
const
  GL_ARB_direct_state_access_str = 'GL_ARB_direct_state_access';
  //
  GL_TEXTURE_TARGET = $1006;
  GL_QUERY_TARGET   = $82EA;

// PROC PROTOTYPES
type PFNGLCREATETRANSFORMFEEDBACKSPROC = procedure(n: GLsizei; ids: PGLuint); stdcall;
type PFNGLTRANSFORMFEEDBACKBUFFERBASEPROC = procedure(xfb: GLuint; index: GLuint;
  buffer: GLuint); stdcall;
type PFNGLTRANSFORMFEEDBACKBUFFERRANGEPROC = procedure(xfb: GLuint; index: GLuint;
  buffer: GLuint; offset: GLintptr; size: GLsizeiptr); stdcall;
type PFNGLGETTRANSFORMFEEDBACKIVPROC = procedure(xfb: GLuint; pname: GLenum;
  param: PGLint); stdcall;
type PFNGLGETTRANSFORMFEEDBACKI_VPROC = procedure(xfb: GLuint; pname: GLenum;
  index: GLuint; param: PGLint); stdcall;
type PFNGLGETTRANSFORMFEEDBACKI64_VPROC = procedure(xfb: GLuint; pname: GLenum;
  index: GLuint; param: PGLint64); stdcall;
type PFNGLCREATEBUFFERSPROC = procedure(n: GLsizei; buffers: PGLuint); stdcall;
type PFNGLNAMEDBUFFERSTORAGEPROC = procedure(buffer: GLuint; size: GLsizeiptr;
  const data: PGLvoid; flags: GLbitfield); stdcall;
type PFNGLNAMEDBUFFERDATAPROC = procedure(buffer: GLuint; size: GLsizeiptr;
  const data: PGLvoid; usage: GLenum); stdcall;
type PFNGLNAMEDBUFFERSUBDATAPROC = procedure(buffer: GLuint; offset: GLintptr;
  size: GLsizeiptr; const data: PGLvoid); stdcall;
type PFNGLCOPYNAMEDBUFFERSUBDATAPROC = procedure(readBuffer, writeBuffer: GLuint;
  readOffset, writeOffset: GLintptr; size: GLsizeiptr); stdcall;
type PFNGLCLEARNAMEDBUFFERDATAPROC = procedure(buffer: GLuint; internalFmt: GLenum;
  fmt: GLenum; dataType: GLenum; const data: PGLvoid); stdcall;
type PFNGLCLEARNAMEDBUFFERSUBDATAPROC = procedure(buffer: GLuint; internalFmt: GLenum;
  offset: GLintptr; size: GLsizeiptr; fmt: GLenum; dataType: GLenum;
  const data: PGLvoid); stdcall;
type PFNGLMAPNAMEDBUFFERPROC = function(buffer: GLuint;
  access: GLenum): PGLvoid; stdcall;
type PFNGLMAPNAMEDBUFFERRANGEPROC = function(buffer: GLuint; offset: GLintptr;
  length: GLsizeiptr; access: GLbitfield): PGLvoid; stdcall;
type PFNGLUNMAPNAMEDBUFFERPROC = function(buffer: GLuint): GLboolean; stdcall;
type PFNGLFLUSHMAPPEDNAMEDBUFFERRANGEPROC = procedure(buffer: GLuint;
  offset: GLintptr; length: GLsizeiptr); stdcall;
type PFNGLGETNAMEDBUFFERPARAMETERIVPROC = procedure(buffer: GLuint; pname: GLenum;
  params: PGLint); stdcall;
type PFNGLGETNAMEDBUFFERPARAMETERI64VPROC = procedure(buffer: GLuint; pname: GLenum;
  params: PGLint64); stdcall;
type PFNGLGETNAMEDBUFFERPOINTERVPROC = procedure(buffer: GLuint; pname: GLenum;
  params: PPGLvoid); stdcall;
type PFNGLGETNAMEDBUFFERSUBDATAPROC = procedure(buffer: GLuint; offset: GLintptr;
  size: GLsizeiptr; data: PGLvoid); stdcall;
type PFNGLCREATEFRAMEBUFFERSPROC = procedure(n: GLsizei;
  framebuffers: PGLuint); stdcall;
type PFNGLNAMEDFRAMEBUFFERRENDERBUFFERPROC = procedure(framebuffer: GLuint;
  attachment: GLenum; renderbuffertarget: GLenum; renderbuffer: GLuint); stdcall;
type PFNGLNAMEDFRAMEBUFFERPARAMETERIPROC = procedure(framebuffer: GLuint;
  pname: GLenum; param: GLint); stdcall;
type PFNGLNAMEDFRAMEBUFFERTEXTUREPROC = procedure(framebuffer: GLuint;
  attachment: GLenum; texture: GLuint; level: GLint); stdcall;
type PFNGLNAMEDFRAMEBUFFERTEXTURELAYERPROC = procedure(framebuffer: GLuint;
  attachment: GLenum; texture: GLuint; level: GLint; layer: GLint); stdcall;
type PFNGLNAMEDFRAMEBUFFERDRAWBUFFERPROC = procedure(framebuffer: GLuint;
  mode: GLenum); stdcall;
type PFNGLNAMEDFRAMEBUFFERDRAWBUFFERSPROC = procedure(framebuffer: GLuint;
  n: GLsizei; const bufs: PGLenum); stdcall;
type PFNGLNAMEDFRAMEBUFFERREADBUFFERPROC = procedure(framebuffer: GLuint;
  mode: GLenum); stdcall;
type PFNGLINVALIDATENAMEDFRAMEBUFFERDATAPROC = procedure(framebuffer: GLuint;
  numAttachments: GLsizei; const attachments: PGLenum); stdcall;
type PFNGLINVALIDATENAMEDFRAMEBUFFERSUBDATAPROC = procedure(framebuffer: GLuint;
  numAttachments: GLsizei; const attachments: PGLenum; x, y: GLint;
  width, height: GLsizei); stdcall;
type PFNGLCLEARNAMEDFRAMEBUFFERIVPROC = procedure(framebuffer: GLuint;
  buffer: GLenum; drawbuffer: GLint; const value: PGLint); stdcall;
type PFNGLCLEARNAMEDFRAMEBUFFERUIVPROC = procedure(framebuffer: GLuint;
  buffer: GLenum; drawbuffer: GLint; const value: PGLuint); stdcall;
type PFNGLCLEARNAMEDFRAMEBUFFERFVPROC = procedure(framebuffer: GLuint;
  buffer: GLenum; drawbuffer: GLint; const value: PGLfloat); stdcall;
type PFNGLCLEARNAMEDFRAMEBUFFERfIPROC = procedure(framebuffer: GLuint;
  buffer: GLenum; drawbuffer: GLint; depth: GLfloat; stencil: GLint); stdcall;
type PFNGLBLITNAMEDFRAMEBUFFERPROC = procedure(readFramebuffer, drawFramebuffer: GLuint;
  srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1: GLint; mask: GLbitfield;
  filter: GLenum); stdcall;
type PFNGLCHECKNAMEDFRAMEBUFFERSTATUSPROC = function(framebuffer: GLuint;
  target: GLenum): GLenum; stdcall;
type PFNGLGETNAMEDFRAMEBUFFERPARAMETERIVPROC = procedure(framebuffer: GLuint;
  pname: GLenum; param: PGLint); stdcall;
type PFNGLGETNAMEDFRAMEBUFFERATTACHMENTPARAMETERIVPROC = procedure(
  framebuffer: GLuint; attachment: GLenum; pname: GLenum; params: PGLint); stdcall;
type PFNGLCREATERENDERBUFFERSPROC = procedure(n: GLsizei;
  renderbuffers: PGLuint); stdcall;
type PFNGLNAMEDRENDERBUFFERSTORAGEPROC = procedure(renderbuffer: GLuint;
  internalFmt: GLenum; width, height: GLsizei); stdcall;
type PFNGLNAMEDRENDERBUFFERSTORAGEMULTISAMPLEPROC = procedure(renderbuffer: GLuint;
  samples: GLsizei; internalFmt: GLenum; width, height: GLsizei); stdcall;
type PFNGLGETNAMEDRENDERBUFFERPARAMETERIVPROC = procedure(renderbuffer: GLuint;
  pname: GLenum; params: PGLint); stdcall;
type PFNGLCREATETEXTURESPROC = procedure(target: GLenum; n: GLsizei;
  textures: PGLuint); stdcall;
type PFNGLTEXTUREBUFFERPROC = procedure(texture: GLuint; internalFmt: GLenum;
  buffer: GLuint); stdcall;
type PFNGLTEXTUREBUFFERRANGEPROC = procedure(texture: GLuint; internalFmt: GLenum;
  buffer: GLuint; offset: GLintptr; size: GLsizeiptr); stdcall;
type PFNGLTEXTURESTORAGE1DPROC = procedure(texture: GLuint; levels: GLsizei;
  internalFmt: GLenum; width: GLsizei); stdcall;
type PFNGLTEXTURESTORAGE2DPROC = procedure(texture: GLuint; levels: GLsizei;
  internalFmt: GLenum; width, height: GLsizei); stdcall;
type PFNGLTEXTURESTORAGE3DPROC = procedure(texture: GLuint; levels: GLsizei;
  internalFmt: GLenum; width, height, depth: GLsizei); stdcall;
type PFNGLTEXTURESTORAGE2DMULTISAMPLEPROC = procedure(texture: GLuint;
  samples: GLsizei; internalFmt: GLenum; width, height: GLsizei;
  fixedsamplelocations: GLboolean); stdcall;
type PFNGLTEXTURESTORAGE3DMULTISAMPLEPROC = procedure(texture: GLuint;
  samples: GLsizei; internalFmt: GLenum; width, height, depth: GLsizei;
  fixedsamplelocations: GLboolean); stdcall;
type PFNGLTEXTURESUBIMAGE1DPROC = procedure(texture: GLuint; level: GLint;
  xoffset: GLint; width: GLsizei; fmt: GLenum; dataType: GLenum;
  const pixels: PGLvoid); stdcall;
type PFNGLTEXTURESUBIMAGE2DPROC = procedure(texture: GLuint; level: GLint;
  xoffset, yoffset: GLint; width, height: GLsizei; fmt: GLenum; dataType: GLenum;
  const pixels: PGLvoid); stdcall;
type PFNGLTEXTURESUBIMAGE3DPROC = procedure(texture: GLuint; level: GLint;
  xoffset, yoffset, zoffset: GLint; width, height, depth: GLsizei; fmt: GLenum;
  dataType: GLenum; const pixels: PGLvoid); stdcall;
type PFNGLCOMPRESSEDTEXTURESUBIMAGE1DPROC = procedure(texture: GLuint; level: GLint;
  xoffset: GLint; width: GLsizei; fmt: GLenum; imageSize: GLsizei;
  const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDTEXTURESUBIMAGE2DPROC = procedure(texture: GLuint; level: GLint;
  xoffset, yoffset: GLint; width, height: GLsizei; fmt: GLenum; imageSize: GLsizei;
  const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDTEXTURESUBIMAGE3DPROC = procedure(texture: GLuint; level: GLint;
  xoffset, yoffset, zoffset: GLint; width, height, depth: GLsizei; fmt: GLenum;
  imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLCOPYTEXTURESUBIMAGE1DPROC = procedure(texture: GLuint; level: GLint;
  xoffset: GLint; x, y: GLint; width: GLsizei); stdcall;
type PFNGLCOPYTEXTURESUBIMAGE2DPROC = procedure(texture: GLuint; level: GLint;
  xoffset, yoffset: GLint; x, y: GLint; width, height: GLsizei); stdcall;
type PFNGLCOPYTEXTURESUBIMAGE3DPROC = procedure(texture: GLuint; level: GLint;
  xoffset, yoffset, zoffset: GLint; x, y: GLint; width, height: GLsizei); stdcall;
type PFNGLTEXTUREPARAMETERFPROC = procedure(texture: GLuint; pname: GLenum;
  param: GLfloat); stdcall;
type PFNGLTEXTUREPARAMETERFVPROC = procedure(texture: GLuint; pname: GLenum;
  const param: PGLfloat); stdcall;
type PFNGLTEXTUREPARAMETERIPROC = procedure(texture: GLuint; pname: GLenum;
  param: GLint); stdcall;
type PFNGLTEXTUREPARAMETERIIVPROC = procedure(texture: GLuint; pname: GLenum;
  const params: PGLint); stdcall;
type PFNGLTEXTUREPARAMETERIUIVPROC = procedure(texture: GLuint; pname: GLenum;
  const params: PGLuint); stdcall;
type PFNGLTEXTUREPARAMETERIVPROC = procedure(texture: GLuint; pname: GLenum;
  const param: PGLint); stdcall;
type PFNGLGENERATETEXTUREMIPMAPPROC = procedure(texture: GLuint); stdcall;
type PFNGLBINDTEXTUREUNITPROC = procedure(unitTex: GLuint; texture: GLuint); stdcall;
type PFNGLGETTEXTUREIMAGEPROC = procedure(texture: GLuint; level: GLint;
  fmt: GLenum; dataType: GLenum; bufSize: GLsizei; pixels: PGLvoid); stdcall;
type PFNGLGETCOMPRESSEDTEXTUREIMAGEPROC = procedure(texture: GLuint; level: GLint;
  bufSize: GLsizei; pixels: PGLvoid); stdcall;
type PFNGLGETTEXTURELEVELPARAMETERFVPROC = procedure(texture: GLuint; level: GLint;
  pname: GLenum; params: PGLfloat); stdcall;
type PFNGLGETTEXTURELEVELPARAMETERIVPROC = procedure(texture: GLuint; level: GLint;
  pname: GLenum; params: PGLint); stdcall;
type PFNGLGETTEXTUREPARAMETERFVPROC = procedure(texture: GLuint; pname: GLenum;
  params: PGLfloat); stdcall;
type PFNGLGETTEXTUREPARAMETERIIVPROC = procedure(texture: GLuint; pname: GLenum;
  params: PGLint); stdcall;
type PFNGLGETTEXTUREPARAMETERIUIVPROC = procedure(texture: GLuint; pname: GLenum;
  params: PGLuint); stdcall;
type PFNGLGETTEXTUREPARAMETERIVPROC = procedure(texture: GLuint; pname: GLenum;
  params: PGLint); stdcall;
type PFNGLCREATEVERTEXARRAYSPROC = procedure(n: GLsizei; arrayList: PGLuint); stdcall;
type PFNGLDISABLEVERTEXARRAYATTRIBPROC = procedure(vao: GLuint; index: GLuint); stdcall;
type PFNGLENABLEVERTEXARRAYATTRIBPROC = procedure(vao: GLuint; index: GLuint); stdcall;
type PFNGLVERTEXARRAYELEMENTBUFFERPROC = procedure(vao: GLuint; buffer: GLuint); stdcall;
type PFNGLVERTEXARRAYVERTEXBUFFERPROC = procedure(vao: GLuint; bindingindex: GLuint;
  buffer: GLuint; offset: GLintptr; stride: GLsizei); stdcall;
type PFNGLVERTEXARRAYVERTEXBUFFERSPROC = procedure(vao: GLuint; first: GLuint;
  count: GLsizei; const buffers: PGLuint; const offsets: PGLintptr;
  const strides: PGLsizei); stdcall;
type PFNGLVERTEXARRAYATTRIBFORMATPROC = procedure(vao: GLuint; attribindex: GLuint;
  size: GLint; dataType: GLenum; normalized: GLboolean;
  relativeoffset: GLuint); stdcall;
type PFNGLVERTEXARRAYATTRIBIFORMATPROC = procedure(vao: GLuint; attribindex: GLuint;
  size: GLint; dataType: GLenum; relativeoffset: GLuint); stdcall;
type PFNGLVERTEXARRAYATTRIBLFORMATPROC = procedure(vao: GLuint; attribindex: GLuint;
  size: GLint; dataType: GLenum; relativeoffset: GLuint); stdcall;
type PFNGLVERTEXARRAYATTRIBBINDINGPROC = procedure(vao: GLuint; attribindex: GLuint;
  bindingindex: GLuint); stdcall;
type PFNGLVERTEXARRAYBINDINGDIVISORPROC = procedure(vao: GLuint; bindingindex: GLuint;
divisor: GLuint); stdcall;
type PFNGLGETVERTEXARRAYIVPROC = procedure(vao: GLuint; pname: GLenum;
  param: PGLint); stdcall;
type PFNGLGETVERTEXARRAYINDEXEDIVPROC = procedure(vao: GLuint; index: GLuint;
  pname: GLenum; param: PGLint); stdcall;
type PFNGLGETVERTEXARRAYINDEXED64IVPROC = procedure(vao: GLuint; index: GLuint;
  pname: GLenum; param: PGLint64); stdcall;
type PFNGLCREATESAMPLERSPROC = procedure(n: GLsizei; samplers: PGLuint); stdcall;
type PFNGLCREATEPROGRAMPIPELINESPROC = procedure(n: GLsizei;
  pipelines: PGLuint); stdcall;
type PFNGLCREATEQUERIESPROC = procedure(target: GLenum; n: GLsizei;
  ids: PGLuint); stdcall;
type PFNGLGETQUERYBUFFEROBJECTIVPROC = procedure(id: GLuint; buffer: GLuint;
  pname: GLenum; offset: GLintptr); stdcall;
type PFNGLGETQUERYBUFFEROBJECTUIVPROC = procedure(id: GLuint; buffer: GLuint;
  pname: GLenum; offset: GLintptr); stdcall;
type PFNGLGETQUERYBUFFEROBJECTI64VPROC = procedure(id: GLuint; buffer: GLuint;
  pname: GLenum; offset: GLintptr); stdcall;
type PFNGLGETQUERYBUFFEROBJECTUI64VPROC = procedure(id: GLuint; buffer: GLuint;
  pname: GLenum; offset: GLintptr); stdcall;

// PROC VARIABLE POINTERS
var
  glCreateTransformFeedbacks:                 PFNGLCREATETRANSFORMFEEDBACKSPROC;
  glTransformFeedbackBufferBase:              PFNGLTRANSFORMFEEDBACKBUFFERBASEPROC;
  glTransformFeedbackBufferRange:             PFNGLTRANSFORMFEEDBACKBUFFERRANGEPROC;
  glGetTransformFeedbackiv:                   PFNGLGETTRANSFORMFEEDBACKIVPROC;
  glGetTransformFeedbacki_v:                  PFNGLGETTRANSFORMFEEDBACKI_VPROC;
  glGetTransformFeedbacki64_v:                PFNGLGETTRANSFORMFEEDBACKI64_VPROC;
  glCreateBuffers:                            PFNGLCREATEBUFFERSPROC;
  glNamedBufferStorage:                       PFNGLNAMEDBUFFERSTORAGEPROC;
  glNamedBufferData:                          PFNGLNAMEDBUFFERDATAPROC;
  glNamedBufferSubData:                       PFNGLNAMEDBUFFERSUBDATAPROC;
  glCopyNamedBufferSubData:                   PFNGLCOPYNAMEDBUFFERSUBDATAPROC;
  glClearNamedBufferData:                     PFNGLCOPYNAMEDBUFFERSUBDATAPROC;
  glClearNamedBufferSubData:                  PFNGLCLEARNAMEDBUFFERSUBDATAPROC;
  glMapNamedBuffer:                           PFNGLMAPNAMEDBUFFERPROC;
  glMapNamedBufferRange:                      PFNGLMAPNAMEDBUFFERRANGEPROC;
  glUnmapNamedBuffer:                         PFNGLUNMAPNAMEDBUFFERPROC;
  glFlushMappedNamedBufferRange:              PFNGLFLUSHMAPPEDNAMEDBUFFERRANGEPROC;
  glGetNamedBufferParameteriv:                PFNGLGETNAMEDBUFFERPARAMETERIVPROC;
  glGetNamedBufferParameteri64v:              PFNGLGETNAMEDBUFFERPARAMETERI64VPROC;
  glGetNamedBufferPointerv:                   PFNGLGETNAMEDBUFFERPOINTERVPROC;
  glGetNamedBufferSubData:                    PFNGLGETNAMEDBUFFERSUBDATAPROC;
  glCreateFramebuffers:                       PFNGLCREATEFRAMEBUFFERSPROC;
  glNamedFramebufferRenderbuffer:             PFNGLNAMEDFRAMEBUFFERRENDERBUFFERPROC;
  glNamedFramebufferParameteri:               PFNGLNAMEDFRAMEBUFFERPARAMETERIPROC;
  glNamedFramebufferTexture:                  PFNGLNAMEDFRAMEBUFFERTEXTUREPROC;
  glNamedFramebufferTextureLayer:             PFNGLNAMEDFRAMEBUFFERTEXTURELAYERPROC;
  glNamedFramebufferDrawBuffer:               PFNGLNAMEDFRAMEBUFFERDRAWBUFFERPROC;
  glNamedFramebufferDrawBuffers:              PFNGLNAMEDFRAMEBUFFERDRAWBUFFERSPROC;
  glNamedFramebufferReadBuffer:               PFNGLNAMEDFRAMEBUFFERREADBUFFERPROC;
  glInvalidateNamedFramebufferData:           PFNGLINVALIDATENAMEDFRAMEBUFFERDATAPROC;
  glInvalidateNamedFramebufferSubData:        PFNGLINVALIDATENAMEDFRAMEBUFFERSUBDATAPROC;
  glClearNamedFramebufferiv:                  PFNGLCLEARNAMEDFRAMEBUFFERIVPROC;
  glClearNamedFramebufferuiv:                 PFNGLCLEARNAMEDFRAMEBUFFERUIVPROC;
  glClearNamedFramebufferfv:                  PFNGLCLEARNAMEDFRAMEBUFFERFVPROC;
  glClearNamedFramebufferfi:                  PFNGLCLEARNAMEDFRAMEBUFFERFIPROC;
  glBlitNamedFramebuffer:                     PFNGLBLITNAMEDFRAMEBUFFERPROC;
  glCheckNamedFramebufferStatus:              PFNGLCHECKNAMEDFRAMEBUFFERSTATUSPROC;
  glGetNamedFramebufferParameteriv:           PFNGLGETNAMEDFRAMEBUFFERPARAMETERIVPROC;
  glGetNamedFramebufferAttachmentParameteriv: PFNGLGETNAMEDFRAMEBUFFERATTACHMENTPARAMETERIVPROC;
  glCreateRenderbuffers:                      PFNGLCREATERENDERBUFFERSPROC;
  glNamedRenderbufferStorage:                 PFNGLNAMEDRENDERBUFFERSTORAGEPROC;
  glNamedRenderbufferStorageMultisample:      PFNGLNAMEDRENDERBUFFERSTORAGEMULTISAMPLEPROC;
  glGetNamedRenderbufferParameteriv:          PFNGLGETNAMEDRENDERBUFFERPARAMETERIVPROC;
  glCreateTextures:                           PFNGLCREATETEXTURESPROC;
  glTextureBuffer:                            PFNGLTEXTUREBUFFERPROC;
  glTextureBufferRange:                       PFNGLTEXTUREBUFFERRANGEPROC;
  glTextureStorage1D:                         PFNGLTEXTURESTORAGE1DPROC;
  glTextureStorage2D:                         PFNGLTEXTURESTORAGE2DPROC;
  glTextureStorage3D:                         PFNGLTEXTURESTORAGE3DPROC;
  glTextureStorage2DMultisample:              PFNGLTEXTURESTORAGE2DMULTISAMPLEPROC;
  glTextureStorage3DMultisample:              PFNGLTEXTURESTORAGE3DMULTISAMPLEPROC;
  glTextureSubImage1D:                        PFNGLTEXTURESUBIMAGE1DPROC;
  glTextureSubImage2D:                        PFNGLTEXTURESUBIMAGE2DPROC;
  glTextureSubImage3D:                        PFNGLTEXTURESUBIMAGE3DPROC;
  glCompressedTextureSubImage1D:              PFNGLCOMPRESSEDTEXTURESUBIMAGE1DPROC;
  glCompressedTextureSubImage2D:              PFNGLCOMPRESSEDTEXTURESUBIMAGE2DPROC;
  glCompressedTextureSubImage3D:              PFNGLCOMPRESSEDTEXTURESUBIMAGE3DPROC;
  glCopyTextureSubImage1D:                    PFNGLCOPYTEXTURESUBIMAGE1DPROC;
  glCopyTextureSubImage2D:                    PFNGLCOPYTEXTURESUBIMAGE2DPROC;
  glCopyTextureSubImage3D:                    PFNGLCOPYTEXTURESUBIMAGE3DPROC;
  glTextureParameterf:                        PFNGLTEXTUREPARAMETERFPROC;
  glTextureParameterfv:                       PFNGLTEXTUREPARAMETERFVPROC;
  glTextureParameteri:                        PFNGLTEXTUREPARAMETERIPROC;
  glTextureParameterIiv:                      PFNGLTEXTUREPARAMETERIIVPROC;
  glTextureParameterIuiv:                     PFNGLTEXTUREPARAMETERIUIVPROC;
  glTextureParameteriv:                       PFNGLTEXTUREPARAMETERIVPROC;
  glGenerateTextureMipmap:                    PFNGLGENERATETEXTUREMIPMAPPROC;
  glBindTextureUnit:                          PFNGLBINDTEXTUREUNITPROC;
  glGetTextureImage:                          PFNGLGETTEXTUREIMAGEPROC;
  glGetCompressedTextureImage:                PFNGLGETCOMPRESSEDTEXTUREIMAGEPROC;
  glGetTextureLevelParameterfv:               PFNGLGETTEXTURELEVELPARAMETERFVPROC;
  glGetTextureLevelParameteriv:               PFNGLGETTEXTURELEVELPARAMETERIVPROC;
  glGetTextureParameterfv:                    PFNGLGETTEXTUREPARAMETERFVPROC;
  glGetTextureParameterIiv:                   PFNGLGETTEXTUREPARAMETERIIVPROC;
  glGetTextureParameterIuiv:                  PFNGLGETTEXTUREPARAMETERIUIVPROC;
  glGetTextureParameteriv:                    PFNGLGETTEXTUREPARAMETERIVPROC;
  glCreateVertexArrays:                       PFNGLCREATEVERTEXARRAYSPROC;
  glDisableVertexArrayAttrib:                 PFNGLDISABLEVERTEXARRAYATTRIBPROC;
  glEnableVertexArrayAttrib:                  PFNGLENABLEVERTEXARRAYATTRIBPROC;
  glVertexArrayElementBuffer:                 PFNGLVERTEXARRAYELEMENTBUFFERPROC;
  glVertexArrayVertexBuffer:                  PFNGLVERTEXARRAYVERTEXBUFFERPROC;
  glVertexArrayVertexBuffers:                 PFNGLVERTEXARRAYVERTEXBUFFERSPROC;
  glVertexArrayAttribFormat:                  PFNGLVERTEXARRAYATTRIBFORMATPROC;
  glVertexArrayAttribIFormat:                 PFNGLVERTEXARRAYATTRIBIFORMATPROC;
  glVertexArrayAttribLFormat:                 PFNGLVERTEXARRAYATTRIBLFORMATPROC;
  glVertexArrayAttribBinding:                 PFNGLVERTEXARRAYATTRIBBINDINGPROC;
  glVertexArrayBindingDivisor:                PFNGLVERTEXARRAYBINDINGDIVISORPROC;
  glGetVertexArrayiv:                         PFNGLGETVERTEXARRAYIVPROC;
  glGetVertexArrayIndexediv:                  PFNGLGETVERTEXARRAYINDEXEDIVPROC;
  glGetVertexArrayIndexed64iv:                PFNGLGETVERTEXARRAYINDEXED64IVPROC;
  glCreateSamplers:                           PFNGLCREATESAMPLERSPROC;
  glCreateProgramPipelines:                   PFNGLCREATEPROGRAMPIPELINESPROC;
  glCreateQueries:                            PFNGLCREATEQUERIESPROC;
  glGetQueryBufferObjectiv:                   PFNGLGETQUERYBUFFEROBJECTIVPROC;
  glGetQueryBufferObjectuiv:                  PFNGLGETQUERYBUFFEROBJECTUIVPROC;
  glGetQueryBufferObjecti64v:                 PFNGLGETQUERYBUFFEROBJECTI64VPROC;
  glGetQueryBufferObjectui64v:                PFNGLGETQUERYBUFFEROBJECTUI64VPROC;
// End Core ARB Direct state access ********************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 4.6 Core Extensions    ////////////////////////
////////////////////////////////////////////////////////////////////////////////

{$DEFINE GL_VERSION_4_6}


// Core ARB KHR no error *******************************************************
{$DEFINE GL_KHR_no_error}
const
  GL_KHR_no_error_str = 'GL_KHR_no_error';
  //
  GL_CONTEXT_FLAG_NO_ERROR_BIT_KHR  = $00000008;
  
// End Core ARB KHR no error ***************************************************


// Core ARB Polygon offset clamp ***********************************************
{$DEFINE GL_ARB_polygon_offset_clamp}
const
  GL_ARB_polygon_offset_clamp_str = 'GL_ARB_polygon_offset_clamp';
  //
  GL_POLYGON_OFFSET_CLAMP = $8E1B;
  
// PROC PROTOTYPES
type PFNGLPOLYGONOFFSETCLAMPPROC = procedure(
  factor, units, clamp: GLfloat); stdcall;

// PROC VARIABLE POINTERS
var
  glPolygonOffsetClamp: PFNGLPOLYGONOFFSETCLAMPPROC;
// End Core ARB Polygon offset clamp *******************************************


// Core ARB Texture folter anisotropic *****************************************
{$DEFINE GL_ARB_texture_filter_anisotropic}
const
  GGL_ARB_texture_filter_anisotropic_str = 'GL_ARB_texture_filter_anisotropic';
  //
  GL_TEXTURE_MAX_ANISOTROPY     = $84FE;
  GL_MAX_TEXTURE_MAX_ANISOTROPY = $84FF;
  
// End Core ARB Texture folter anisotropic *************************************


// Core ARB Pipeline statistics query ******************************************
{$DEFINE GL_ARB_pipeline_statistics_query}
const
  GL_ARB_pipeline_statistics_query_str = 'GL_ARB_pipeline_statistics_query';
  //
  GL_VERTICES_SUBMITTED                 = $82EE;
  GL_PRIMITIVES_SUBMITTED               = $82EF;
  GL_VERTEX_SHADER_INVOCATIONS          = $82F0;
  GL_TESS_CONTROL_SHADER_PATCHES        = $82F1;
  GL_TESS_EVALUATION_SHADER_INVOCATIONS = $82F2;
  GL_GEOMETRY_SHADER_PRIMITIVES_EMITTED = $82F3;
  GL_FRAGMENT_SHADER_INVOCATIONS        = $82F4;
  GL_COMPUTE_SHADER_INVOCATIONS         = $82F5;
  GL_CLIPPING_INPUT_PRIMITIVES          = $82F6;
  GL_CLIPPING_OUTPUT_PRIMITIVES         = $82F7;
  
// End Core ARB Pipeline statistics query **************************************


// Core ARB Transform feedback overflow query **********************************
{$DEFINE GL_ARB_transform_feedback_overflow_query}
const
  GL_ARB_transform_feedback_overflow_query_str = 'GL_ARB_transform_feedback_overflow_query';
  //
  GL_TRANSFORM_FEEDBACK_OVERFLOW        = $82EC;
  GL_TRANSFORM_FEEDBACK_STREAM_OVERFLOW = $82ED;
  
// End Core ARB Transform feedback overflow query ******************************


// Core ARB SPIR-V Shader language *********************************************
{$DEFINE GL_ARB_gl_spirv}
const
  GL_ARB_gl_spirv_str = 'GL_ARB_gl_spirv';
  //
  GL_SHADER_BINARY_FORMAT_SPIR_V  = $9551;
  GL_SPIR_V_BINARY                = $9552;

// PROC PROTOTYPES
type PFNGLSPECIALIZESHADERARBPROC = procedure(shader: GLuint;
  const pEntryPoint: PGLchar; numSpecializationConstants: GLuint;
  const pConstantIndex, pConstantValue: PGLuint); stdcall;

// PROC VARIABLE POINTERS
var
  glSpecializeShaderARB: PFNGLSPECIALIZESHADERARBPROC;
// End Core ARB SPIR-V Shader language *****************************************


// Core ARB SPIR-V Shader language ext *****************************************
{$DEFINE GL_ARB_spirv_extensions}
const
  GL_ARB_spirv_extensions_str = 'GL_ARB_spirv_extensions';
  //
  GL_SPIR_V_EXTENSIONS      = $9553;
  GL_NUM_SPIR_V_EXTENSIONS  = $9554;

// End Core ARB SPIR-V Shader language ext *************************************


// Core ARB Indirect parameters ************************************************
{$DEFINE GL_ARB_indirect_parameters}
const
  GL_ARB_indirect_parameters_str = 'GL_ARB_indirect_parameters';
  //
  GL_PARAMETER_BUFFER         = $80EE;
  GL_PARAMETER_BUFFER_BINDING = $80EF;
  
// PROC PROTOTYPES
type PFNGLMULTIDRAWARRAYSINDIRECTCOUNTARBPROC = procedure(
    mode: GLenum;
    const indirect: PGLvoid; drawCount: GLintptr;
    maxDrawCount, stride: GLsizei
  ); stdcall;
type PFNGLMULTIDRAWELEMENTSINDIRECTCOUNTARBPROC = procedure(
    mode, dataType: GLenum;
    const indirect: PGLvoid; drawCount: GLintptr;
    maxDrawCount, stride: GLsizei
  ); stdcall;

// PROC VARIABLE POINTERS
var
  glMultiDrawArraysIndirectCountARB:    PFNGLMULTIDRAWARRAYSINDIRECTCOUNTARBPROC;
  glMultiDrawElementsIndirectCountARB:  PFNGLMULTIDRAWELEMENTSINDIRECTCOUNTARBPROC;
// End Core ARB Indirect parameters ********************************************
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
//////////////////////    Another ARB & EXT    /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


// NV Texture barrier **********************************************************
{$DEFINE GL_NV_texture_barrier}
const
  GL_NV_texture_barrier_str = 'GL_NV_texture_barrier';
  
// PROC PROTOTYPES
type PFNGLTEXTUREBARRIERNVPROC = procedure(); stdcall;

// PROC VARIABLE POINTERS
var
  glTextureBarrierNV: PFNGLTEXTUREBARRIERNVPROC;
// End NV Texture barrier ******************************************************


// EXT Texture compression S3TC ************************************************
{$DEFINE GL_EXT_texture_compression_s3tc}
const
  GL_EXT_texture_compression_s3tc_str = 'GL_EXT_texture_compression_s3tc';
  //
  GL_COMPRESSED_RGB_S3TC_DXT1   = $83F0;
  GL_COMPRESSED_RGBA_S3TC_DXT1  = $83F1;
  GL_COMPRESSED_RGBA_S3TC_DXT3  = $83F2;
  GL_COMPRESSED_RGBA_S3TC_DXT4  = $83F3;

// End EXT Texture compression S3TC ********************************************


// EXT Direct state access *****************************************************
{$DEFINE GL_EXT_direct_state_access}
const
  GL_EXT_direct_state_access_str = 'GL_EXT_direct_state_access';
  //
  GL_PROGRAM_MATRIX             = $8E2D;
  GL_TRANSPOSE_PROGRAM_MATRIX   = $8E2E;
  GL_PROGRAM_MATRIX_STACK_DEPTH = $8E2F;
  
// PROC PROTOTYPES
  type PFNGLCLIENTATTRIBDEFAULTEXTPROC = procedure(mask: GLbitfield); stdcall;
type PFNGLPUSHCLIENTATTRIBDEFAULTEXTPROC = procedure(mask: GLbitfield); stdcall;
type PFNGLMATRIXLOADFEXTPROC = procedure(matrixMode: GLenum; const m: PGLfloat); stdcall;
type PFNGLMATRIXLOADDEXTPROC = procedure(matrixMode: GLenum; const m: PGLdouble); stdcall;
type PFNGLMATRIXMULTFEXTPROC = procedure(matrixMode: GLenum; const m: PGLfloat); stdcall;
type PFNGLMATRIXMULTDEXTPROC = procedure(matrixMode: GLenum; const m: PGLdouble); stdcall;
type PFNGLMATRIXLOADIDENTITYEXTPROC = procedure(matrixMode: GLenum); stdcall;
type PFNGLMATRIXROTATEFEXTPROC = procedure(matrixMode: GLenum; angle: GLfloat; x, y, z: GLfloat); stdcall;
type PFNGLMATRIXROTATEDEXTPROC = procedure(matrixMode: GLenum; angle: GLdouble; x, y, z: GLdouble); stdcall;
type PFNGLMATRIXSCALEFEXTPROC = procedure(matrixMode: GLenum; x, y, z: GLfloat); stdcall;
type PFNGLMATRIXSCALEDEXTPROC = procedure(matrixMode: GLenum; x, y, z: GLdouble); stdcall;
type PFNGLMATRIXTRANSLATEFEXTPROC = procedure(matrixMode: GLenum; x, y, z: GLfloat); stdcall;
type PFNGLMATRIXTRANSLATEDEXTPROC = procedure(matrixMode: GLenum; x, y, z: GLdouble); stdcall;
type PFNGLMATRIXORTHOEXTPROC = procedure(matrixMode: GLenum; l, r, b, t, n, f: GLdouble); stdcall;
type PFNGLMATRIXFRUSTUMEXTPROC = procedure(matrixMode: GLenum; l, r, b, t, n, f: GLdouble); stdcall;
type PFNGLMATRIXPUSHEXTPROC = procedure(matrixMode: GLenum); stdcall;
type PFNGLMATRIXPOPEXTPROC = procedure(matrixMode: GLenum); stdcall;
type PFNGLTEXTUREPARAMETERIEXTPROC = procedure(texture: GLuint; target: GLenum; pname: GLenum; param: GLint); stdcall;
type PFNGLTEXTUREPARAMETERIVEXTPROC = procedure(texture: GLuint; target: GLenum; pname: GLenum; const param: PGLint); stdcall;
type PFNGLTEXTUREPARAMETERFEXTPROC = procedure(texture: GLuint; target: GLenum; pname: GLenum; param: GLfloat); stdcall;
type PFNGLTEXTUREPARAMETERFVEXTPROC = procedure(texture: GLuint; target: GLenum; pname: GLenum; const param: PGLfloat); stdcall;
type PFNGLTEXTUREIMAGE1DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; internalFmt: GLint; width: GLsizei; border: GLint; dataFmt: GLenum; dataType: GLenum; const pixels: PGLvoid); stdcall;
type PFNGLTEXTUREIMAGE2DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; internalFmt: GLint; width, height: GLsizei; border: GLint; dataFmt: GLenum; dataType: GLenum; const pixels: PGLvoid); stdcall;
type PFNGLTEXTURESUBIMAGE1DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; xoffset: GLint; width: GLsizei; dataFmt: GLenum; dataType: GLenum; const pixels: PGLvoid); stdcall;
type PFNGLTEXTURESUBIMAGE2DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; xoffset, yoffset: GLint; width, height: GLsizei; dataFmt: GLenum; dataType: GLenum; const pixels: PGLvoid); stdcall;
type PFNGLCOPYTEXTUREIMAGE1DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; internalFmt: GLenum; x, y: GLint; width: GLsizei; border: GLint); stdcall;
type PFNGLCOPYTEXTUREIMAGE2DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; internalFmt: GLenum; x, y: GLint; width, height: GLsizei; border: GLint); stdcall;
type PFNGLCOPYTEXTURESUBIMAGE1DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; xoffset: GLint; x, y: GLint; width: GLsizei); stdcall;
type PFNGLCOPYTEXTURESUBIMAGE2DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; xoffset, yoffset: GLint; x, y: GLint; width, height: GLsizei); stdcall;
type PFNGLGETTEXTUREIMAGEEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; dataFmt: GLenum; dataType: GLenum; pixels: PGLvoid); stdcall;
type PFNGLGETTEXTUREPARAMETERFVEXTPROC = procedure(texture: GLuint; target: GLenum; pname: GLenum; params: PGLfloat); stdcall;
type PFNGLGETTEXTUREPARAMETERIVEXTPROC = procedure(texture: GLuint; target: GLenum; pname: GLenum; params: PGLint); stdcall;
type PFNGLGETTEXTURELEVELPARAMETERFVEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; pname: GLenum; params: PGLfloat); stdcall;
type PFNGLGETTEXTURELEVELPARAMETERIVEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; pname: GLenum; params: PGLint); stdcall;
type PFNGLTEXTUREIMAGE3DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; internalFmt: GLint; width, height, depth: GLsizei; border: GLint; dataFmt: GLenum; dataType: GLenum; const pixels: PGLvoid); stdcall;
type PFNGLTEXTURESUBIMAGE3DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; xoffset, yoffset, zoffset: GLint; width, height, depth: GLsizei; dataFmt: GLenum; dataType: GLenum; const pixels: PGLvoid); stdcall;
type PFNGLCOPYTEXTURESUBIMAGE3DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; xoffset, yoffset, zoffset: GLint; x, y: GLint; width, height: GLsizei); stdcall;
type PFNGLBINDMULTITEXTUREEXTPROC = procedure(texUnit: GLenum; target: GLenum; texture: GLuint); stdcall;
type PFNGLMULTITEXCOORDPOINTEREXTPROC = procedure(texUnit: GLenum; size: GLint; dataType: GLenum; stride: GLsizei; const ptr: PGLvoid); stdcall;
type PFNGLMULTITEXENVFEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; param: GLfloat); stdcall;
type PFNGLMULTITEXENVFVEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; const params: PGLfloat); stdcall;
type PFNGLMULTITEXENVIEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; param: GLint); stdcall;
type PFNGLMULTITEXENVIVEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; const params: PGLint); stdcall;
type PFNGLMULTITEXGENDEXTPROC = procedure(texUnit: GLenum; coord: GLenum; pname: GLenum; param: GLdouble); stdcall;
type PFNGLMULTITEXGENDVEXTPROC = procedure(texUnit: GLenum; coord: GLenum; pname: GLenum; const params: PGLdouble); stdcall;
type PFNGLMULTITEXGENFEXTPROC = procedure(texUnit: GLenum; coord: GLenum; pname: GLenum; param: GLfloat); stdcall;
type PFNGLMULTITEXGENFVEXTPROC = procedure(texUnit: GLenum; coord: GLenum; pname: GLenum; const params: PGLfloat); stdcall;
type PFNGLMULTITEXGENIEXTPROC = procedure(texUnit: GLenum; coord: GLenum; pname: GLenum; param: GLint); stdcall;
type PFNGLMULTITEXGENIVEXTPROC = procedure(texUnit: GLenum; coord: GLenum; pname: GLenum; const params: PGLint); stdcall;
type PFNGLGETMULTITEXENVFVEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; params: PGLfloat); stdcall;
type PFNGLGETMULTITEXENVIVEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; params: PGLint); stdcall;
type PFNGLGETMULTITEXGENDVEXTPROC = procedure(texUnit: GLenum; coord: GLenum; pname: GLenum; params: PGLdouble); stdcall;
type PFNGLGETMULTITEXGENFVEXTPROC = procedure(texUnit: GLenum; coord: GLenum; pname: GLenum; params: PGLfloat); stdcall;
type PFNGLGETMULTITEXGENIVEXTPROC = procedure(texUnit: GLenum; coord: GLenum; pname: GLenum; params: PGLint); stdcall;
type PFNGLMULTITEXPARAMETERIEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; param: GLint); stdcall;
type PFNGLMULTITEXPARAMETERIVEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; const param: PGLint); stdcall;
type PFNGLMULTITEXPARAMETERFEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; param: GLfloat); stdcall;
type PFNGLMULTITEXPARAMETERFVEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; const param: PGLfloat); stdcall;
type PFNGLMULTITEXIMAGE1DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; internalFmt: GLint; width: GLsizei; border: GLint; dataFmt: GLenum; dataType: GLenum; const pixels: PGLvoid); stdcall;
type PFNGLMULTITEXIMAGE2DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; internalFmt: GLint; width, height: GLsizei; border: GLint; dataFmt: GLenum; dataType: GLenum; const pixels: PGLvoid); stdcall;
type PFNGLMULTITEXSUBIMAGE1DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; xoffset: GLint; width: GLsizei; dataFmt: GLenum; dataType: GLenum; const pixels: PGLvoid); stdcall;
type PFNGLMULTITEXSUBIMAGE2DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; xoffset, yoffset: GLint; width, height: GLsizei; dataFmt: GLenum; dataType: GLenum; const pixels: PGLvoid); stdcall;
type PFNGLCOPYMULTITEXIMAGE1DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; internalFmt: GLenum; x, y: GLint; width: GLsizei; border: GLint); stdcall;
type PFNGLCOPYMULTITEXIMAGE2DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; internalFmt: GLenum; x, y: GLint; width, height: GLsizei; border: GLint); stdcall;
type PFNGLCOPYMULTITEXSUBIMAGE1DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; xoffset: GLint; x, y: GLint; width: GLsizei); stdcall;
type PFNGLCOPYMULTITEXSUBIMAGE2DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; xoffset, yoffset: GLint; x, y: GLint; width, height: GLsizei); stdcall;
type PFNGLGETMULTITEXIMAGEEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; dataFmt: GLenum; dataType: GLenum; pixels: PGLvoid); stdcall;
type PFNGLGETMULTITEXPARAMETERFVEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; params: PGLfloat); stdcall;
type PFNGLGETMULTITEXPARAMETERIVEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; params: PGLint); stdcall;
type PFNGLGETMULTITEXLEVELPARAMETERFVEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; pname: GLenum; params: PGLfloat); stdcall;
type PFNGLGETMULTITEXLEVELPARAMETERIVEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; pname: GLenum; params: PGLint); stdcall;
type PFNGLMULTITEXIMAGE3DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; internalFmt: GLint; width, height, depth: GLsizei; border: GLint; dataFmt: GLenum; dataType: GLenum; const pixels: PGLvoid); stdcall;
type PFNGLMULTITEXSUBIMAGE3DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; xoffset, yoffset, zoffset: GLint; width, height, depth: GLsizei; dataFmt: GLenum; dataType: GLenum; const pixels: PGLvoid); stdcall;
type PFNGLCOPYMULTITEXSUBIMAGE3DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; xoffset, yoffset, zoffset: GLint; x, y: GLint; width, height: GLsizei); stdcall;
type PFNGLENABLECLIENTSTATEINDEXEDEXTPROC = procedure(arrayid: GLenum; index: GLuint); stdcall;
type PFNGLDISABLECLIENTSTATEINDEXEDEXTPROC = procedure(arrayid: GLenum; index: GLuint); stdcall;
type PFNGLENABLECLIENTSTATEIEXTPROC = procedure(arrayid: GLenum; index: GLuint); stdcall;
type PFNGLDISABLECLIENTSTATEIEXTPROC = procedure(arrayid: GLenum; index: GLuint); stdcall;
type PFNGLGETFLOATINDEXEDVEXTPROC = procedure(target: GLenum; index: GLuint; params: PGLfloat); stdcall;
type PFNGLGETDOUBLEINDEXEDVEXTPROC = procedure(target: GLenum; index: GLuint; params: PGLdouble); stdcall;
type PFNGLGETPOINTERINDEXEDVEXTPROC = procedure(target: GLenum; index: GLuint; params: PPGLvoid); stdcall;
type PFNGLGETFLOATI_VEXTPROC = procedure(pname: GLenum; index: GLuint; params: PGLfloat); stdcall;
type PFNGLGETDOUBLEI_VEXTPROC = procedure(pname: GLenum; index: GLuint; params: PGLdouble); stdcall;
type PFNGLGETPOINTERI_VEXTPROC = procedure(pname: GLenum; index: GLuint; params: PPGLvoid); stdcall;
type PFNGLENABLEINDEXEDEXTPROC = procedure(cap: GLenum; index: GLuint); stdcall;
type PFNGLDISABLEINDEXEDEXTPROC = procedure(cap: GLenum; index: GLuint); stdcall;
type PFNGLISENABLEDINDEXEDEXTPROC = function(target: GLenum; index: GLuint): GLboolean; stdcall;
type PFNGLGETINTEGERINDEXEDVEXTPROC = procedure(target: GLenum; index: GLuint; params: PGLint); stdcall;
type PFNGLGETBOOLEANINDEXEDVEXTPROC = procedure(target: GLenum; index: GLuint; params: PGLboolean); stdcall;
type PFNGLNAMEDPROGRAMSTRINGEXTPROC = procedure(programObj: GLuint; target: GLenum; dataFmt: GLenum; len: GLsizei; const str: PGLvoid); stdcall; 
type PFNGLNAMEDPROGRAMLOCALPARAMETER4DEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; x, y, z, w: GLdouble); stdcall;
type PFNGLNAMEDPROGRAMLOCALPARAMETER4DVEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; const params: PGLdouble); stdcall;
type PFNGLNAMEDPROGRAMLOCALPARAMETER4FEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; x, y, z, w: GLfloat); stdcall;
type PFNGLNAMEDPROGRAMLOCALPARAMETER4FVEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; const params: PGLfloat); stdcall;
type PFNGLGETNAMEDPROGRAMLOCALPARAMETERDVEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; params: PGLdouble); stdcall;
type PFNGLGETNAMEDPROGRAMLOCALPARAMETERFVEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; params: PGLfloat); stdcall;
type PFNGLGETNAMEDPROGRAMIVEXTPROC = procedure(programObj: GLuint; target: GLenum; pname: GLenum; params: PGLint); stdcall;
type PFNGLGETNAMEDPROGRAMSTRINGEXTPROC = procedure(programObj: GLuint; target: GLenum; pname: GLenum; str: PGLvoid); stdcall;
type PFNGLCOMPRESSEDTEXTUREIMAGE3DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; internalFmt: GLenum; width, height, depth: GLsizei; border: GLint; imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDTEXTUREIMAGE2DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; internalFmt: GLenum; width, height: GLsizei; border: GLint; imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDTEXTUREIMAGE1DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; internalFmt: GLenum; width: GLsizei; border: GLint; imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDTEXTURESUBIMAGE3DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; xoffset, yoffset, zoffset: GLint; width, height, depth: GLsizei; dataFmt: GLenum; imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDTEXTURESUBIMAGE2DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; xoffset, yoffset: GLint; width, height: GLsizei; dataFmt: GLenum; imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDTEXTURESUBIMAGE1DEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; xoffset: GLint; width: GLsizei; dataFmt: GLenum; imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLGETCOMPRESSEDTEXTUREIMAGEEXTPROC = procedure(texture: GLuint; target: GLenum; level: GLint; img: PGLvoid); stdcall;
type PFNGLCOMPRESSEDMULTITEXIMAGE3DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; internalFmt: GLenum; width, height, depth: GLsizei; border: GLint; imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDMULTITEXIMAGE2DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; internalFmt: GLenum; width, height: GLsizei; border: GLint; imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDMULTITEXIMAGE1DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; internalFmt: GLenum; width: GLsizei; border: GLint; imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDMULTITEXSUBIMAGE3DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; xoffset, yoffset, zoffset: GLint; width, height, depth: GLsizei; dataFmt: GLenum; imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDMULTITEXSUBIMAGE2DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; xoffset, yoffset: GLint; width, height: GLsizei; dataFmt: GLenum; imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLCOMPRESSEDMULTITEXSUBIMAGE1DEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; xoffset: GLint; width: GLsizei; dataFmt: GLenum; imageSize: GLsizei; const data: PGLvoid); stdcall;
type PFNGLGETCOMPRESSEDMULTITEXIMAGEEXTPROC = procedure(texUnit: GLenum; target: GLenum; level: GLint; img: PGLvoid); stdcall;
type PFNGLMATRIXLOADTRANSPOSEFEXTPROC = procedure(matrixMode: GLenum; const m: PGLfloat); stdcall;
type PFNGLMATRIXLOADTRANSPOSEDEXTPROC = procedure(matrixMode: GLenum; const m: PGLdouble); stdcall;
type PFNGLMATRIXMULTTRANSPOSEFEXTPROC = procedure(matrixMode: GLenum; const m: PGLfloat); stdcall;
type PFNGLMATRIXMULTTRANSPOSEDEXTPROC = procedure(matrixMode: GLenum; const m: PGLdouble); stdcall;
type PFNGLNAMEDBUFFERDATAEXTPROC = procedure(buffer: GLuint; size: GLsizeiptr; const data: PGLvoid; usage: GLenum); stdcall;
type PFNGLNAMEDBUFFERSUBDATAEXTPROC = procedure(buffer: GLuint; offset: GLintptr; size: GLsizeiptr; const data: PGLvoid); stdcall;
type PFNGLMAPNAMEDBUFFEREXTPROC = function(buffer: GLuint; access: GLenum): PGLvoid; stdcall;
type PFNGLUNMAPNAMEDBUFFEREXTPROC = function(buffer: GLuint): GLboolean; stdcall;
type PFNGLGETNAMEDBUFFERPARAMETERIVEXTPROC = procedure(buffer: GLuint; pname: GLenum; params: PGLint); stdcall;
type PFNGLGETNAMEDBUFFERPOINTERVEXTPROC = procedure(buffer: GLuint; pname: GLenum; params: PPGLvoid); stdcall;
type PFNGLGETNAMEDBUFFERSUBDATAEXTPROC = procedure(buffer: GLuint; offset: GLintptr; size: GLsizeiptr; data: PGLvoid); stdcall;
type PFNGLPROGRAMUNIFORM1FEXTPROC = procedure(programObj: GLuint; location: GLint; v0: GLfloat); stdcall;
type PFNGLPROGRAMUNIFORM2FEXTPROC = procedure(programObj: GLuint; location: GLint; v0, v1: GLfloat); stdcall;
type PFNGLPROGRAMUNIFORM3FEXTPROC = procedure(programObj: GLuint; location: GLint; v0, v1, v2: GLfloat); stdcall;
type PFNGLPROGRAMUNIFORM4FEXTPROC = procedure(programObj: GLuint; location: GLint; v0, v1, v2, v3: GLfloat); stdcall;
type PFNGLPROGRAMUNIFORM1IEXTPROC = procedure(programObj: GLuint; location: GLint; v0: GLint); stdcall;
type PFNGLPROGRAMUNIFORM2IEXTPROC = procedure(programObj: GLuint; location: GLint; v0, v1: GLint); stdcall;
type PFNGLPROGRAMUNIFORM3IEXTPROC = procedure(programObj: GLuint; location: GLint; v0, v1, v2: GLint); stdcall;
type PFNGLPROGRAMUNIFORM4IEXTPROC = procedure(programObj: GLuint; location: GLint; v0, v1, v2, v3: GLint); stdcall;
type PFNGLPROGRAMUNIFORM1FVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORM2FVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORM3FVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORM4FVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORM1IVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; const value: PGLint); stdcall;
type PFNGLPROGRAMUNIFORM2IVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; const value: PGLint); stdcall;
type PFNGLPROGRAMUNIFORM3IVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; const value: PGLint); stdcall;
type PFNGLPROGRAMUNIFORM4IVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; const value: PGLint); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX2FVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX3FVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX4FVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX2X3FVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX3X2FVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX2X4FVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX4X2FVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX3X4FVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLPROGRAMUNIFORMMATRIX4X3FVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; transpose: GLboolean; const value: PGLfloat); stdcall;
type PFNGLTEXTUREBUFFEREXTPROC = procedure(texture: GLuint; target: GLenum; internalFmt: GLenum; buffer: GLuint); stdcall;
type PFNGLMULTITEXBUFFEREXTPROC = procedure(texUnit: GLenum; target: GLenum; internalFmt: GLenum; buffer: GLuint); stdcall;
type PFNGLTEXTUREPARAMETERIIVEXTPROC = procedure(texture: GLuint; target: GLenum; pname: GLenum; const params: PGLint); stdcall;
type PFNGLTEXTUREPARAMETERIUIVEXTPROC = procedure(texture: GLuint; target: GLenum; pname: GLenum; const uparams: PGLint); stdcall;
type PFNGLGETTEXTUREPARAMETERIIVEXTPROC = procedure(texture: GLuint; target: GLenum; pname: GLenum; params: PGLint); stdcall;
type PFNGLGETTEXTUREPARAMETERIUIVEXTPROC = procedure(texture: GLuint; target: GLenum; pname: GLenum; uparams: PGLint); stdcall;
type PFNGLMULTITEXPARAMETERIIVEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; const params: PGLint); stdcall;
type PFNGLMULTITEXPARAMETERIUIVEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; const uparams: PGLint); stdcall;
type PFNGLGETMULTITEXPARAMETERIIVEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; params: PGLint); stdcall;
type PFNGLGETMULTITEXPARAMETERIUIVEXTPROC = procedure(texUnit: GLenum; target: GLenum; pname: GLenum; uparams: PGLint); stdcall;
type PFNGLPROGRAMUNIFORM1UIEXTPROC = procedure(programObj: GLuint; location: GLint; v0: GLuint); stdcall;
type PFNGLPROGRAMUNIFORM2UIEXTPROC = procedure(programObj: GLuint; location: GLint; v0, v1: GLuint); stdcall;
type PFNGLPROGRAMUNIFORM3UIEXTPROC = procedure(programObj: GLuint; location: GLint; v0, v1, v2: GLuint); stdcall;
type PFNGLPROGRAMUNIFORM4UIEXTPROC = procedure(programObj: GLuint; location: GLint; v0, v1, v2, v3: GLuint); stdcall;
type PFNGLPROGRAMUNIFORM1UIVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; const value: PGLuint); stdcall;
type PFNGLPROGRAMUNIFORM2UIVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; const value: PGLuint); stdcall;
type PFNGLPROGRAMUNIFORM3UIVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; const value: PGLuint); stdcall;
type PFNGLPROGRAMUNIFORM4UIVEXTPROC = procedure(programObj: GLuint; location: GLint; count: GLsizei; const value: PGLuint); stdcall;
type PFNGLNAMEDPROGRAMLOCALPARAMETERS4FVEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; count: GLsizei; const params: PGLfloat); stdcall; 
type PFNGLNAMEDPROGRAMLOCALPARAMETERI4IEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; x, y, z, w: GLint); stdcall;
type PFNGLNAMEDPROGRAMLOCALPARAMETERI4IVEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; const params: PGLint); stdcall;
type PFNGLNAMEDPROGRAMLOCALPARAMETERsI4IVEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; count: GLsizei; const params: PGLint); stdcall;
type PFNGLNAMEDPROGRAMLOCALPARAMETERI4UIEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; x, y, z, w: GLuint); stdcall;
type PFNGLNAMEDPROGRAMLOCALPARAMETERI4UIVEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; const uparams: PGLint); stdcall;
type PFNGLNAMEDPROGRAMLOCALPARAMETERSI4UIVEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; count: GLsizei; const uparams: PGLint); stdcall;
type PFNGLGETNAMEDPROGRAMLOCALPARAMETERIIVEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; params: PGLint); stdcall;
type PFNGLGETNAMEDPROGRAMLOCALPARAMETERIUIVEXTPROC = procedure(programObj: GLuint; target: GLenum; index: GLuint; uparams: PGLint); stdcall;
type PFNGLNAMEDRENDERBUFFERSTORAGEEXTPROC = procedure(renderbuffer: GLuint; internalFmt: GLenum; width, height: GLsizei); stdcall;
type PFNGLGETNAMEDRENDERBUFFERPARAMETERIVEXTPROC = procedure(renderbuffer: GLuint; pname: GLenum; params: PGLint); stdcall;
type PFNGLNAMEDRENDERBUFFERSTORAGEMULTISAMPLEEXTPROC = procedure(renderbuffer: GLuint; samples: GLsizei; internalFmt: GLenum; width, height: GLsizei); stdcall;
type PFNGLNAMEDRENDERBUFFERSTORAGEMULTISAMPLECOVERAGEEXTPROC = procedure(renderbuffer: GLuint; coverageSamples, colorSamples: GLsizei; internalFmt: GLenum; width, height: GLsizei); stdcall;
type PFNGLCHECKNAMEDFRAMEBUFFERSTATUSEXTPROC = function(framebuffer: GLuint; target: GLenum): GLenum; stdcall;
type PFNGLNAMEDFRAMEBUFFERTEXTURE1DEXTPROC = procedure(framebuffer: GLuint; attachment: GLenum; textarget: GLenum; texture: GLuint; level: GLint); stdcall;
type PFNGLNAMEDFRAMEBUFFERTEXTURE2DEXTPROC = procedure(framebuffer: GLuint; attachment: GLenum; textarget: GLenum; texture: GLuint; level: GLint); stdcall;
type PFNGLNAMEDFRAMEBUFFERTEXTURE3DEXTPROC = procedure(framebuffer: GLuint; attachment: GLenum; textarget: GLenum; texture: GLuint; level, zoffset: GLint); stdcall;
type PFNGLNAMEDFRAMEBUFFERRENDERBUFFEREXTPROC = procedure(framebuffer: GLuint; attachment: GLenum; renderbuffertarget: GLenum; renderbuffer: GLuint); stdcall;
type PFNGLGETNAMEDFRAMEBUFFERATTACHMENTPARAMETERIVEXTPROC = procedure(framebuffer: GLuint; attachment: GLenum; pname: GLenum; params: PGLint); stdcall;
type PFNGLGENERATETEXTUREMIPMAPEXTPROC = procedure(texture: GLuint; target: GLenum); stdcall;
type PFNGLGENERATEMULTITEXMIPMAPEXTPROC = procedure(texUnit: GLenum; target: GLenum); stdcall;
type PFNGLFRAMEBUFFERDRAWBUFFEREXTPROC = procedure(framebuffer: GLuint; mode: GLenum); stdcall;
type PFNGLFRAMEBUFFERDRAWBUFFERSEXTPROC = procedure(framebuffer: GLuint; n: GLsizei; const bufs: PGLenum); stdcall;
type PFNGLFRAMEBUFFERREADBUFFEREXTPROC = procedure(framebuffer: GLuint; mode: GLenum); stdcall;
type PFNGLGETFRAMEBUFFERPARAMETERIVEXTPROC = procedure(framebuffer: GLuint; pname: GLenum; param: PGLint); stdcall;
type PFNGLNAMEDCOPYBUFFERSUBDATAEXTPROC = procedure(readbuf, writebuf, readoffset, writeoffset: GLintptr; size: GLsizeiptr); stdcall;
type PFNGLNAMEDFRAMEBUFFERTEXTUREEXTPROC = procedure(framebuffer: GLuint; attachment: GLenum; texture: GLuint; level: GLint); stdcall;
type PFNGLNAMEDFRAMEBUFFERTEXTURELAYEREXTPROC = procedure(framebuffer: GLuint; attachment: GLenum; texture: GLuint; level: GLint; layer: GLint); stdcall;
type PFNGLNAMEDFRAMEBUFFERTEXTUREFACEEXTPROC = procedure(framebuffer: GLuint; attachment: GLenum; texture: GLuint; level: GLint; face: GLenum); stdcall;
type PFNGLTEXTURERENDERBUFFEREXTPROC = procedure(texture: GLuint; target: GLenum; renderbuffer: GLuint); stdcall;
type PFNGLMULTITEXRENDERBUFFEREXTPROC = procedure(texUnit: GLenum; target: GLenum; renderbuffer: GLuint); stdcall;
type PFNGLVERTEXARRAYVERTEXOFFSETEXTPROC = procedure(vao: GLuint; buffer: GLuint; size: GLint; dataType: GLenum; stride: GLsizei; offset: GLintptr); stdcall;
type PFNGLVERTEXARRAYCOLOROFFSETEXTPROC = procedure(vao: GLuint; buffer: GLuint; size: GLint; dataType: GLenum; stride: GLsizei; offset: GLintptr); stdcall;
type PFNGLVERTEXARRAYEDGEFLAGOFFSETEXTPROC = procedure(vao: GLuint; buffer: GLuint; stride: GLsizei; offset: GLintptr); stdcall;
type PFNGLVERTEXARRAYINDEXOFFSETEXTPROC = procedure(vao: GLuint; buffer: GLuint; dataType: GLenum; stride: GLsizei; offset: GLintptr); stdcall;
type PFNGLVERTEXARRAYNORMALOFFSETEXTPROC = procedure(vao: GLuint; buffer: GLuint; dataType: GLenum; stride: GLsizei; offset: GLintptr); stdcall;
type PFNGLVERTEXARRAYTEXCOORDOFFSETEXTPROC = procedure(vao: GLuint; buffer: GLuint; size: GLint; dataType: GLenum; stride: GLsizei; offset: GLintptr); stdcall;
type PFNGLVERTEXARRAYMULTITEXCOORDOFFSETEXTPROC = procedure(vao: GLuint; buffer: GLuint; texUnit: GLenum; size: GLint; dataType: GLenum; stride: GLsizei; offset: GLintptr); stdcall;
type PFNGLVERTEXARRAYFOGCOORDOFFSETEXTPROC = procedure(vao: GLuint; buffer: GLuint; dataType: GLenum; stride: GLsizei; offset: GLintptr); stdcall;
type PFNGLVERTEXARRAYSECONDARYCOLOROFFSETEXTPROC = procedure(vao: GLuint; buffer: GLuint; size: GLint; dataType: GLenum; stride: GLsizei; offset: GLintptr); stdcall;
type PFNGLVERTEXARRAYVERTEXATTRIBOFFSETEXTPROC = procedure(vao: GLuint; buffer: GLuint; index: GLuint; size: GLint; dataType: GLenum; normalized: GLboolean; stride: GLsizei; offset: GLintptr); stdcall;
type PFNGLVERTEXARRAYVERTEXATTRIBIOFFSETEXTPROC = procedure(vao: GLuint; buffer: GLuint; index: GLuint; size: GLint; dataType: GLenum; stride: GLsizei; offset: GLintptr); stdcall;
type PFNGLENABLEVERTEXARRAYEXTPROC = procedure(vao: GLuint; arrayid: GLenum); stdcall;
type PFNGLDISABLEVERTEXARRAYEXTPROC = procedure(vao: GLuint; arrayid: GLenum); stdcall;
type PFNGLENABLEVERTEXARRAYATTRIBEXTPROC = procedure(vao: GLuint; index: GLuint); stdcall;
type PFNGLDISABLEVERTEXARRAYATTRIBEXTPROC = procedure(vao: GLuint; index: GLuint); stdcall;
type PFNGLGETVERTEXARRAYINTEGERVEXTPROC = procedure(vao: GLuint; pname: GLenum; param: PGLint); stdcall;
type PFNGLGETVERTEXARRAYPOINTERVEXTPROC = procedure(vao: GLuint; pname: GLenum; param: PPGLvoid); stdcall;
type PFNGLGETVERTEXARRAYINTEGERI_VEXTPROC = procedure(vao: GLuint; index: GLuint; pname: GLenum; param: PGLint); stdcall;
type PFNGLGETVERTEXARRAYPOINTERI_VEXTPROC = procedure(vao: GLuint; index: GLuint; pname: GLenum; param: PPGLvoid); stdcall;
type PFNGLMAPNAMEDBUFFERRANGEEXTPROC = function(buffer: GLuint; offset: GLintptr; length: GLsizeiptr; access: GLbitfield): PGLvoid; stdcall;
type PFNGLFLUSHMAPPEDNAMEDBUFFERRANGEEXTPROC = procedure(buffer: GLuint; offset: GLintptr; length: GLsizeiptr); stdcall;

// PROC VARIABLE POINTERS
var
  glClientAttribDefaultEXT:                         PFNGLCLIENTATTRIBDEFAULTEXTPROC; 
  glPushClientAttribDefaultEXT:                     PFNGLPUSHCLIENTATTRIBDEFAULTEXTPROC;
  glMatrixLoadfEXT:                                 PFNGLMATRIXLOADFEXTPROC;
  glMatrixLoaddEXT:                                 PFNGLMATRIXLOADDEXTPROC;
  glMatrixMultfEXT:                                 PFNGLMATRIXMULTFEXTPROC;
  glMatrixMultdEXT:                                 PFNGLMATRIXMULTDEXTPROC;
  glMatrixLoadIdentityEXT:                          PFNGLMATRIXLOADIDENTITYEXTPROC;
  glMatrixRotatefEXT:                               PFNGLMATRIXROTATEFEXTPROC;
  glMatrixRotatedEXT:                               PFNGLMATRIXROTATEDEXTPROC;
  glMatrixScalefEXT:                                PFNGLMATRIXSCALEFEXTPROC;
  glMatrixScaledEXT:                                PFNGLMATRIXSCALEDEXTPROC;
  glMatrixTranslatefEXT:                            PFNGLMATRIXTRANSLATEFEXTPROC;
  glMatrixTranslatedEXT:                            PFNGLMATRIXTRANSLATEDEXTPROC;
  glMatrixOrthoEXT:                                 PFNGLMATRIXORTHOEXTPROC;
  glMatrixFrustumEXT:                               PFNGLMATRIXFRUSTUMEXTPROC;
  glMatrixPushEXT:                                  PFNGLMATRIXPUSHEXTPROC;
  glMatrixPopEXT:                                   PFNGLMATRIXPOPEXTPROC;
  glTextureParameteriEXT:                           PFNGLTEXTUREPARAMETERIEXTPROC;
  glTextureParameterivEXT:                          PFNGLTEXTUREPARAMETERIVEXTPROC;
  glTextureParameterfEXT:                           PFNGLTEXTUREPARAMETERFEXTPROC;
  glTextureParameterfvEXT:                          PFNGLTEXTUREPARAMETERFVEXTPROC;
  glTextureImage1DEXT:                              PFNGLTEXTUREIMAGE1DEXTPROC;
  glTextureImage2DEXT:                              PFNGLTEXTUREIMAGE2DEXTPROC;
  glTextureSubImage1DEXT:                           PFNGLTEXTURESUBIMAGE1DEXTPROC;
  glTextureSubImage2DEXT:                           PFNGLTEXTURESUBIMAGE2DEXTPROC;
  glCopyTextureImage1DEXT:                          PFNGLCOPYTEXTUREIMAGE1DEXTPROC;
  glCopyTextureImage2DEXT:                          PFNGLCOPYTEXTUREIMAGE2DEXTPROC;
  glCopyTextureSubImage1DEXT:                       PFNGLCOPYTEXTURESUBIMAGE1DEXTPROC;
  glCopyTextureSubImage2DEXT:                       PFNGLCOPYTEXTURESUBIMAGE2DEXTPROC;
  glGetTextureImageEXT:                             PFNGLGETTEXTUREIMAGEEXTPROC;
  glGetTextureParameterfvEXT:                       PFNGLGETTEXTUREPARAMETERFVEXTPROC;
  glGetTextureParameterivEXT:                       PFNGLGETTEXTUREPARAMETERIVEXTPROC;
  glGetTextureLevelParameterfvEXT:                  PFNGLGETTEXTURELEVELPARAMETERFVEXTPROC;
  glGetTextureLevelParameterivEXT:                  PFNGLGETTEXTURELEVELPARAMETERIVEXTPROC;
  glTextureImage3DEXT:                              PFNGLTEXTUREIMAGE3DEXTPROC;
  glTextureSubImage3DEXT:                           PFNGLTEXTURESUBIMAGE3DEXTPROC;
  glCopyTextureSubImage3DEXT:                       PFNGLCOPYTEXTURESUBIMAGE3DEXTPROC;
  glBindMultiTextureEXT:                            PFNGLBINDMULTITEXTUREEXTPROC;
  glMultiTexCoordPointerEXT:                        PFNGLMULTITEXCOORDPOINTEREXTPROC;
  glMultiTexEnvfEXT:                                PFNGLMULTITEXENVFEXTPROC;
  glMultiTexEnvfvEXT:                               PFNGLMULTITEXENVFVEXTPROC;
  glMultiTexEnviEXT:                                PFNGLMULTITEXENVIEXTPROC;
  glMultiTexEnvivEXT:                               PFNGLMULTITEXENVIVEXTPROC;
  glMultiTexGendEXT:                                PFNGLMULTITEXGENDEXTPROC;
  glMultiTexGendvEXT:                               PFNGLMULTITEXGENDVEXTPROC;
  glMultiTexGenfEXT:                                PFNGLMULTITEXGENFEXTPROC;
  glMultiTexGenfvEXT:                               PFNGLMULTITEXGENFVEXTPROC;
  glMultiTexGeniEXT:                                PFNGLMULTITEXGENIEXTPROC;
  glMultiTexGenivEXT:                               PFNGLMULTITEXGENIVEXTPROC;
  glGetMultiTexEnvfvEXT:                            PFNGLGETMULTITEXENVFVEXTPROC;
  glGetMultiTexEnvivEXT:                            PFNGLGETMULTITEXENVIVEXTPROC;
  glGetMultiTexGendvEXT:                            PFNGLGETMULTITEXGENDVEXTPROC;
  glGetMultiTexGenfvEXT:                            PFNGLGETMULTITEXGENFVEXTPROC;
  glGetMultiTexGenivEXT:                            PFNGLGETMULTITEXGENIVEXTPROC;
  glMultiTexParameteriEXT:                          PFNGLMULTITEXPARAMETERIEXTPROC;
  glMultiTexParameterivEXT:                         PFNGLMULTITEXPARAMETERIVEXTPROC;
  glMultiTexParameterfEXT:                          PFNGLMULTITEXPARAMETERFEXTPROC;
  glMultiTexParameterfvEXT:                         PFNGLMULTITEXPARAMETERFVEXTPROC;
  glMultiTexImage1DEXT:                             PFNGLMULTITEXIMAGE1DEXTPROC;
  glMultiTexImage2DEXT:                             PFNGLMULTITEXIMAGE2DEXTPROC;
  glMultiTexSubImage1DEXT:                          PFNGLMULTITEXSUBIMAGE1DEXTPROC;
  glMultiTexSubImage2DEXT:                          PFNGLMULTITEXSUBIMAGE2DEXTPROC;
  glCopyMultiTexImage1DEXT:                         PFNGLCOPYMULTITEXIMAGE1DEXTPROC;
  glCopyMultiTexImage2DEXT:                         PFNGLCOPYMULTITEXIMAGE2DEXTPROC;
  glCopyMultiTexSubImage1DEXT:                      PFNGLCOPYMULTITEXSUBIMAGE1DEXTPROC;
  glCopyMultiTexSubImage2DEXT:                      PFNGLCOPYMULTITEXSUBIMAGE2DEXTPROC;
  glGetMultiTexImageEXT:                            PFNGLGETMULTITEXIMAGEEXTPROC;
  glGetMultiTexParameterfvEXT:                      PFNGLGETMULTITEXPARAMETERFVEXTPROC;
  glGetMultiTexParameterivEXT:                      PFNGLGETMULTITEXPARAMETERIVEXTPROC;
  glGetMultiTexLevelParameterfvEXT:                 PFNGLGETMULTITEXLEVELPARAMETERFVEXTPROC;
  glGetMultiTexLevelParameterivEXT:                 PFNGLGETMULTITEXLEVELPARAMETERIVEXTPROC;
  glMultiTexImage3DEXT:                             PFNGLMULTITEXIMAGE3DEXTPROC;
  glMultiTexSubImage3DEXT:                          PFNGLMULTITEXSUBIMAGE3DEXTPROC;
  glCopyMultiTexSubImage3DEXT:                      PFNGLCOPYMULTITEXSUBIMAGE3DEXTPROC;
  glEnableClientStateIndexedEXT:                    PFNGLENABLECLIENTSTATEINDEXEDEXTPROC;
  glDisableClientStateIndexedEXT:                   PFNGLDISABLECLIENTSTATEINDEXEDEXTPROC;
  glEnableClientStateiEXT:                          PFNGLENABLECLIENTSTATEIEXTPROC;
  glDisableClientStateiEXT:                         PFNGLDISABLECLIENTSTATEIEXTPROC;
  glGetFloatIndexedvEXT:                            PFNGLGETFLOATINDEXEDVEXTPROC;
  glGetDoubleIndexedvEXT:                           PFNGLGETDOUBLEINDEXEDVEXTPROC;
  glGetPointerIndexedvEXT:                          PFNGLGETPOINTERINDEXEDVEXTPROC;
  glGetFloati_vEXT:                                 PFNGLGETFLOATI_VEXTPROC; 
  glGetDoublei_vEXT:                                PFNGLGETDOUBLEI_VEXTPROC;
  glGetPointeri_vEXT:                               PFNGLGETPOINTERI_VEXTPROC;
  glEnableIndexedEXT:                               PFNGLENABLEINDEXEDEXTPROC;
  glDisableIndexedEXT:                              PFNGLDISABLEINDEXEDEXTPROC;
  glIsEnabledIndexedEXT:                            PFNGLISENABLEDINDEXEDEXTPROC;
  glGetIntegerIndexedvEXT:                          PFNGLGETINTEGERINDEXEDVEXTPROC;
  glGetBooleanIndexedvEXT:                          PFNGLGETBOOLEANINDEXEDVEXTPROC;
  glNamedProgramStringEXT:                          PFNGLNAMEDPROGRAMSTRINGEXTPROC;
  glNamedProgramLocalParameter4dEXT:                PFNGLNAMEDPROGRAMLOCALPARAMETER4DEXTPROC;
  glNamedProgramLocalParameter4dvEXT:               PFNGLNAMEDPROGRAMLOCALPARAMETER4DVEXTPROC;
  glNamedProgramLocalParameter4fEXT:                PFNGLNAMEDPROGRAMLOCALPARAMETER4FEXTPROC;
  glNamedProgramLocalParameter4fvEXT:               PFNGLNAMEDPROGRAMLOCALPARAMETER4FVEXTPROC;
  glGetNamedProgramLocalParameterdvEXT:             PFNGLGETNAMEDPROGRAMLOCALPARAMETERDVEXTPROC;
  glGetNamedProgramLocalParameterfvEXT:             PFNGLGETNAMEDPROGRAMLOCALPARAMETERFVEXTPROC;
  glGetNamedProgramivEXT:                           PFNGLGETNAMEDPROGRAMIVEXTPROC;
  glGetNamedProgramStringEXT:                       PFNGLGETNAMEDPROGRAMSTRINGEXTPROC;
  glCompressedTextureImage3DEXT:                    PFNGLCOMPRESSEDTEXTUREIMAGE3DEXTPROC;
  glCompressedTextureImage2DEXT:                    PFNGLCOMPRESSEDTEXTUREIMAGE2DEXTPROC;
  glCompressedTextureImage1DEXT:                    PFNGLCOMPRESSEDTEXTUREIMAGE1DEXTPROC;
  glCompressedTextureSubImage3DEXT:                 PFNGLCOMPRESSEDTEXTURESUBIMAGE3DEXTPROC;
  glCompressedTextureSubImage2DEXT:                 PFNGLCOMPRESSEDTEXTURESUBIMAGE2DEXTPROC;
  glCompressedTextureSubImage1DEXT:                 PFNGLCOMPRESSEDTEXTURESUBIMAGE1DEXTPROC;
  glGetCompressedTextureImageEXT:                   PFNGLGETCOMPRESSEDTEXTUREIMAGEEXTPROC;
  glCompressedMultiTexImage3DEXT:                   PFNGLCOMPRESSEDMULTITEXIMAGE3DEXTPROC;
  glCompressedMultiTexImage2DEXT:                   PFNGLCOMPRESSEDMULTITEXIMAGE2DEXTPROC;
  glCompressedMultiTexImage1DEXT:                   PFNGLCOMPRESSEDMULTITEXIMAGE1DEXTPROC;
  glCompressedMultiTexSubImage3DEXT:                PFNGLCOMPRESSEDMULTITEXSUBIMAGE3DEXTPROC;
  glCompressedMultiTexSubImage2DEXT:                PFNGLCOMPRESSEDMULTITEXSUBIMAGE2DEXTPROC;
  glCompressedMultiTexSubImage1DEXT:                PFNGLCOMPRESSEDMULTITEXSUBIMAGE1DEXTPROC;
  glGetCompressedMultiTexImageEXT:                  PFNGLGETCOMPRESSEDMULTITEXIMAGEEXTPROC;
  glMatrixLoadTransposefEXT:                        PFNGLMATRIXLOADTRANSPOSEFEXTPROC;
  glMatrixLoadTransposedEXT:                        PFNGLMATRIXLOADTRANSPOSEDEXTPROC;
  glMatrixMultTransposefEXT:                        PFNGLMATRIXMULTTRANSPOSEFEXTPROC;
  glMatrixMultTransposedEXT:                        PFNGLMATRIXMULTTRANSPOSEDEXTPROC;
  glNamedBufferDataEXT:                             PFNGLNAMEDBUFFERDATAEXTPROC;
  glNamedBufferSubDataEXT:                          PFNGLNAMEDBUFFERSUBDATAEXTPROC;
  glMapNamedBufferEXT:                              PFNGLMAPNAMEDBUFFEREXTPROC;
  glUnmapNamedBufferEXT:                            PFNGLUNMAPNAMEDBUFFEREXTPROC;
  glGetNamedBufferParameterivEXT:                   PFNGLGETNAMEDBUFFERPARAMETERIVEXTPROC;
  glGetNamedBufferPointervEXT:                      PFNGLGETNAMEDBUFFERPOINTERVEXTPROC;
  glGetNamedBufferSubDataEXT:                       PFNGLGETNAMEDBUFFERSUBDATAEXTPROC;
  glProgramUniform1fEXT:                            PFNGLPROGRAMUNIFORM1FEXTPROC;
  glProgramUniform2fEXT:                            PFNGLPROGRAMUNIFORM2FEXTPROC;
  glProgramUniform3fEXT:                            PFNGLPROGRAMUNIFORM3FEXTPROC;
  glProgramUniform4fEXT:                            PFNGLPROGRAMUNIFORM4FEXTPROC;
  glProgramUniform1iEXT:                            PFNGLPROGRAMUNIFORM1IEXTPROC;
  glProgramUniform2iEXT:                            PFNGLPROGRAMUNIFORM2IEXTPROC;
  glProgramUniform3iEXT:                            PFNGLPROGRAMUNIFORM3IEXTPROC;
  glProgramUniform4iEXT:                            PFNGLPROGRAMUNIFORM4IEXTPROC;
  glProgramUniform1fvEXT:                           PFNGLPROGRAMUNIFORM1FVEXTPROC;
  glProgramUniform2fvEXT:                           PFNGLPROGRAMUNIFORM2FVEXTPROC;
  glProgramUniform3fvEXT:                           PFNGLPROGRAMUNIFORM3FVEXTPROC;
  glProgramUniform4fvEXT:                           PFNGLPROGRAMUNIFORM4FVEXTPROC;
  glProgramUniform1ivEXT:                           PFNGLPROGRAMUNIFORM1IVEXTPROC;
  glProgramUniform2ivEXT:                           PFNGLPROGRAMUNIFORM2IVEXTPROC;
  glProgramUniform3ivEXT:                           PFNGLPROGRAMUNIFORM3IVEXTPROC;
  glProgramUniform4ivEXT:                           PFNGLPROGRAMUNIFORM4IVEXTPROC;
  glProgramUniformMatrix2fvEXT:                     PFNGLPROGRAMUNIFORMMATRIX2FVEXTPROC;
  glProgramUniformMatrix3fvEXT:                     PFNGLPROGRAMUNIFORMMATRIX3FVEXTPROC;
  glProgramUniformMatrix4fvEXT:                     PFNGLPROGRAMUNIFORMMATRIX4FVEXTPROC;
  glProgramUniformMatrix2x3fvEXT:                   PFNGLPROGRAMUNIFORMMATRIX2X3FVEXTPROC;
  glProgramUniformMatrix3x2fvEXT:                   PFNGLPROGRAMUNIFORMMATRIX3X2FVEXTPROC;
  glProgramUniformMatrix2x4fvEXT:                   PFNGLPROGRAMUNIFORMMATRIX2X4FVEXTPROC;
  glProgramUniformMatrix4x2fvEXT:                   PFNGLPROGRAMUNIFORMMATRIX4X2FVEXTPROC;
  glProgramUniformMatrix3x4fvEXT:                   PFNGLPROGRAMUNIFORMMATRIX3X4FVEXTPROC;
  glProgramUniformMatrix4x3fvEXT:                   PFNGLPROGRAMUNIFORMMATRIX4X3FVEXTPROC;
  glTextureBufferEXT:                               PFNGLTEXTUREBUFFEREXTPROC;
  glMultiTexBufferEXT:                              PFNGLMULTITEXBUFFEREXTPROC;
  glTextureParameterIivEXT:                         PFNGLTEXTUREPARAMETERIIVEXTPROC;
  glTextureParameterIuivEXT:                        PFNGLTEXTUREPARAMETERIUIVEXTPROC;
  glGetTextureParameterIivEXT:                      PFNGLGETTEXTUREPARAMETERIIVEXTPROC;
  glGetTextureParameterIuivEXT:                     PFNGLGETTEXTUREPARAMETERIUIVEXTPROC;
  glMultiTexParameterIivEXT:                        PFNGLMULTITEXPARAMETERIIVEXTPROC;
  glMultiTexParameterIuivEXT:                       PFNGLMULTITEXPARAMETERIUIVEXTPROC;
  glGetMultiTexParameterIivEXT:                     PFNGLGETMULTITEXPARAMETERIIVEXTPROC;
  glGetMultiTexParameterIuivEXT:                    PFNGLGETMULTITEXPARAMETERIUIVEXTPROC;
  glProgramUniform1uiEXT:                           PFNGLPROGRAMUNIFORM1UIEXTPROC;
  glProgramUniform2uiEXT:                           PFNGLPROGRAMUNIFORM2UIEXTPROC;
  glProgramUniform3uiEXT:                           PFNGLPROGRAMUNIFORM3UIEXTPROC;
  glProgramUniform4uiEXT:                           PFNGLPROGRAMUNIFORM4UIEXTPROC;
  glProgramUniform1uivEXT:                          PFNGLPROGRAMUNIFORM1UIVEXTPROC;
  glProgramUniform2uivEXT:                          PFNGLPROGRAMUNIFORM2UIVEXTPROC;
  glProgramUniform3uivEXT:                          PFNGLPROGRAMUNIFORM3UIVEXTPROC;
  glProgramUniform4uivEXT:                          PFNGLPROGRAMUNIFORM4UIVEXTPROC;
  glNamedProgramLocalParameters4fvEXT:              PFNGLNAMEDPROGRAMLOCALPARAMETERS4FVEXTPROC;
  glNamedProgramLocalParameterI4iEXT:               PFNGLNAMEDPROGRAMLOCALPARAMETERI4IEXTPROC;
  glNamedProgramLocalParameterI4ivEXT:              PFNGLNAMEDPROGRAMLOCALPARAMETERI4IVEXTPROC;
  glNamedProgramLocalParametersI4ivEXT:             PFNGLNAMEDPROGRAMLOCALPARAMETERSI4IVEXTPROC;
  glNamedProgramLocalParameterI4uiEXT:              PFNGLNAMEDPROGRAMLOCALPARAMETERI4UIEXTPROC;
  glNamedProgramLocalParameterI4uivEXT:             PFNGLNAMEDPROGRAMLOCALPARAMETERI4UIVEXTPROC;
  glNamedProgramLocalParametersI4uivEXT:            PFNGLNAMEDPROGRAMLOCALPARAMETERSI4UIVEXTPROC;
  glGetNamedProgramLocalParameterIivEXT:            PFNGLGETNAMEDPROGRAMLOCALPARAMETERIIVEXTPROC;
  glGetNamedProgramLocalParameterIuivEXT:           PFNGLGETNAMEDPROGRAMLOCALPARAMETERIUIVEXTPROC;
  glNamedRenderbufferStorageEXT:                    PFNGLNAMEDRENDERBUFFERSTORAGEEXTPROC;
  glGetNamedRenderbufferParameterivEXT:             PFNGLGETNAMEDRENDERBUFFERPARAMETERIVEXTPROC;
  glNamedRenderbufferStorageMultisampleEXT:         PFNGLNAMEDRENDERBUFFERSTORAGEMULTISAMPLEEXTPROC;
  glNamedRenderbufferStorageMultisampleCoverageEXT: PFNGLNAMEDRENDERBUFFERSTORAGEMULTISAMPLECOVERAGEEXTPROC;
  glCheckNamedFramebufferStatusEXT:                 PFNGLCHECKNAMEDFRAMEBUFFERSTATUSEXTPROC;
  glNamedFramebufferTexture1DEXT:                   PFNGLNAMEDFRAMEBUFFERTEXTURE1DEXTPROC;
  glNamedFramebufferTexture2DEXT:                   PFNGLNAMEDFRAMEBUFFERTEXTURE2DEXTPROC;
  glNamedFramebufferTexture3DEXT:                   PFNGLNAMEDFRAMEBUFFERTEXTURE3DEXTPROC;
  glNamedFramebufferRenderbufferEXT:                PFNGLNAMEDFRAMEBUFFERRENDERBUFFEREXTPROC;
  glGetNamedFramebufferAttachmentParameterivEXT:    PFNGLGETNAMEDFRAMEBUFFERATTACHMENTPARAMETERIVEXTPROC;
  glGenerateTextureMipmapEXT:                       PFNGLGENERATETEXTUREMIPMAPEXTPROC;
  glGenerateMultiTexMipmapEXT:                      PFNGLGENERATEMULTITEXMIPMAPEXTPROC;
  glFramebufferDrawBufferEXT:                       PFNGLFRAMEBUFFERDRAWBUFFEREXTPROC;
  glFramebufferDrawBuffersEXT:                      PFNGLFRAMEBUFFERDRAWBUFFERSEXTPROC;
  glFramebufferReadBufferEXT:                       PFNGLFRAMEBUFFERREADBUFFEREXTPROC;
  glGetFramebufferParameterivEXT:                   PFNGLGETFRAMEBUFFERPARAMETERIVEXTPROC;
  glNamedCopyBufferSubDataEXT:                      PFNGLNAMEDCOPYBUFFERSUBDATAEXTPROC;
  glNamedFramebufferTextureEXT:                     PFNGLNAMEDFRAMEBUFFERTEXTUREEXTPROC;
  glNamedFramebufferTextureLayerEXT:                PFNGLNAMEDFRAMEBUFFERTEXTURELAYEREXTPROC;
  glNamedFramebufferTextureFaceEXT:                 PFNGLNAMEDFRAMEBUFFERTEXTUREFACEEXTPROC;
  glTextureRenderbufferEXT:                         PFNGLTEXTURERENDERBUFFEREXTPROC;
  glMultiTexRenderbufferEXT:                        PFNGLMULTITEXRENDERBUFFEREXTPROC;
  glVertexArrayVertexOffsetEXT:                     PFNGLVERTEXARRAYVERTEXOFFSETEXTPROC;
  glVertexArrayColorOffsetEXT:                      PFNGLVERTEXARRAYCOLOROFFSETEXTPROC;
  glVertexArrayEdgeFlagOffsetEXT:                   PFNGLVERTEXARRAYEDGEFLAGOFFSETEXTPROC;
  glVertexArrayIndexOffsetEXT:                      PFNGLVERTEXARRAYINDEXOFFSETEXTPROC;
  glVertexArrayNormalOffsetEXT:                     PFNGLVERTEXARRAYNORMALOFFSETEXTPROC;
  glVertexArrayTexCoordOffsetEXT:                   PFNGLVERTEXARRAYTEXCOORDOFFSETEXTPROC;
  glVertexArrayMultiTexCoordOffsetEXT:              PFNGLVERTEXARRAYMULTITEXCOORDOFFSETEXTPROC;
  glVertexArrayFogCoordOffsetEXT:                   PFNGLVERTEXARRAYFOGCOORDOFFSETEXTPROC;
  glVertexArraySecondaryColorOffsetEXT:             PFNGLVERTEXARRAYSECONDARYCOLOROFFSETEXTPROC;
  glVertexArrayVertexAttribOffsetEXT:               PFNGLVERTEXARRAYVERTEXATTRIBOFFSETEXTPROC;
  glVertexArrayVertexAttribIOffsetEXT:              PFNGLVERTEXARRAYVERTEXATTRIBIOFFSETEXTPROC;
  glEnableVertexArrayEXT:                           PFNGLENABLEVERTEXARRAYEXTPROC;
  glDisableVertexArrayEXT:                          PFNGLDISABLEVERTEXARRAYEXTPROC;
  glEnableVertexArrayAttribEXT:                     PFNGLENABLEVERTEXARRAYATTRIBEXTPROC;
  glDisableVertexArrayAttribEXT:                    PFNGLDISABLEVERTEXARRAYATTRIBEXTPROC;
  glGetVertexArrayIntegervEXT:                      PFNGLGETVERTEXARRAYINTEGERVEXTPROC;
  glGetVertexArrayPointervEXT:                      PFNGLGETVERTEXARRAYPOINTERVEXTPROC;
  glGetVertexArrayIntegeri_vEXT:                    PFNGLGETVERTEXARRAYINTEGERI_VEXTPROC;
  glGetVertexArrayPointeri_vEXT:                    PFNGLGETVERTEXARRAYPOINTERI_VEXTPROC;
  glMapNamedBufferRangeEXT:                         PFNGLMAPNAMEDBUFFERRANGEEXTPROC;
  glFlushMappedNamedBufferRangeEXT:                 PFNGLFLUSHMAPPEDNAMEDBUFFERRANGEEXTPROC;

// End EXT Direct state access *************************************************
////////////////////////////////////////////////////////////////////////////////


function TestOpenGLVersion(const MajorVersion, MinorVersion: Integer): Boolean;
function IsExistExtension(const ExtensionName: String): Boolean;
procedure LoadOpenGLExtensions();


implementation


////////////////////////////////////////////////////////////////////////////////
//////////////////////    OpenGL 1.1 Core Extensions    ////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Vertex array EXT ************************************************************
procedure glArrayElement(index: GLint); stdcall;
  external opengl32 name 'glArrayElement';
procedure glDrawArrays(mode: GLenum; first: GLint; count: GLsizei); stdcall;
  external opengl32 name 'glDrawArrays';
procedure glDrawElements(mode: GLenum; count: GLsizei; indexType: GLenum;
  const indices: PGLvoid); stdcall; external opengl32 name 'glDrawElements';
procedure glVertexPointer(size: GLint; dataType: GLenum; stride: GLsizei;
  const data: PGLvoid); stdcall; external opengl32 name 'glVertexPointer';
procedure glNormalPointer(dataType: GLenum; stride: GLsizei;
  const data: PGLvoid); stdcall; external opengl32 name 'glNormalPointer';
procedure glColorPointer(size: GLint; dataType: GLenum; stride: GLsizei;
  const data: PGLvoid); stdcall; external opengl32 name 'glColorPointer';
procedure glIndexPointer(dataType: GLenum; stride: GLsizei;
  const data: PGLvoid); stdcall; external opengl32 name 'glIndexPointer';
procedure glTexCoordPointer(size: GLint; dataType: GLenum; stride: GLsizei;
  const data: PGLvoid); stdcall; external opengl32 name 'glTexCoordPointer';
procedure glEdgeFlagPointer(stride: GLsizei; const data: PGLboolean);
  stdcall; external opengl32 name 'glEdgeFlagPointer';
procedure glFogCoordPointer(dataType: GLenum; stride: GLsizei;
  const data: PGLvoid); stdcall; external opengl32 name 'glFogCoordPointer';
procedure glGetPointerv(pname: GLenum; params: PPGLvoid); stdcall;
  external opengl32 name 'glGetPointerv';
procedure glEnableClientState(cap: GLenum); stdcall;
  external opengl32 name 'glEnableClientState';
procedure glDisableClientState(cap: GLenum); stdcall;
  external opengl32 name 'glDisableClientState';

// texture object EXT **********************************************************
procedure glGenTextures(n: GLsizei; textures: PGLuint); stdcall;
  external opengl32 name 'glGenTextures';
procedure glDeleteTextures(n: GLsizei; const textures: PGLuint); stdcall;
  external opengl32 name 'glDeleteTextures';
procedure glBindTexture(target:	GLenum; texture: GLuint); stdcall;
  external opengl32 name 'glBindTexture';
procedure glPrioritizeTextures(n: GLsizei; const textures: PGLuint;
  const priorities: PGLclampf); stdcall;
  external opengl32 name 'glPrioritizeTextures';
function glAreTexturesResident(n: GLsizei; textures: PGLuint;
  const residences: PGLboolean): GLboolean; stdcall;
  external opengl32 name 'glAreTexturesResident';
function glIsTexture(texture: GLuint): GLboolean; stdcall;
  external opengl32 name 'glIsTexture';

// Copy texture EXT
procedure glCopyTexImage1D(target: GLenum; level: GLint; internalFormat: GLenum;
  x, y: GLint; width: GLsizei; border: GLint); stdcall;
  external opengl32 name 'glCopyTexImage1D';
procedure glCopyTexImage2D(target: GLenum; level: GLint; internalFormat: GLenum;
  x, y: GLint; width, height: GLsizei; border: GLint); stdcall;
  external opengl32 name 'glCopyTexImage2D';
procedure glCopyTexSubImage1D(target: GLenum; level, xOffset, x, y: GLint;
  width: GLsizei); stdcall; external opengl32 name 'glCopyTexSubImage1D';
procedure glCopyTexSubImage2D(target: GLenum; level, xOffset, yOffset, x, y: GLint;
  width, height: GLsizei); stdcall; external opengl32 name 'glCopyTexSubImage2D';

// Subtexture EXT
procedure glTexSubImage1D(target: GLenum; level, xOffset: GLint; width: GLsizei;
  format, pixelType: GLenum;
  const pixels: PGLvoid); stdcall; external opengl32 name 'glTexSubImage1D';
procedure glTexSubImage2D(target: GLenum; level, xOffset, yOffset: GLint;
  width, height: GLsizei; format, pixelType: GLenum;
  const pixels: PGLvoid); stdcall; external opengl32 name 'glTexSubImage2D';

// Polygon offset EXT
procedure glPolygonOffset(factor, bias: GLfloat); stdcall;
  external opengl32 name 'glPolygonOffset';



////////////////////////////////////////////////////////////////////////////////
////////////////////    OpenGL 1.2+ Initialization    //////////////////////////
////////////////////////////////////////////////////////////////////////////////
var
  isOpenGLExtensionsInitialized: Boolean = False;

function TestOpenGLVersion(const MajorVersion, MinorVersion: Integer): Boolean;
begin
  {$R-}
  Result:=Boolean(MajorVersion >= OpenGLVersionValues[0]);
  if (Result) then Result:=Boolean(MinorVersion >= OpenGLVersionValues[1]);
  {$R+}
end;

function IsExistExtension(const ExtensionName: String): Boolean;
begin
  {$R-}
  Result:=Boolean(Pos(ExtensionName, OpenGLExtArbList) > 0);
  {$R+}
end;

function CheckAndLoadOpenGLproc(var LoadProcPtr: Pointer; const ProcName: String): Boolean;
begin
  {$R-}
  LoadProcPtr:=wglGetProcAddress(PAnsiChar(ProcName));
  Result:=Boolean(LoadProcPtr <> nil);
  {$R-}
end;

procedure LoadOpenGLExtensions();
var
  i, j: Integer;
  tmpStr: String;
begin
  {$R-}
  if (isOpenGLExtensionsInitialized) then Exit;

  OpenGLVersion:=     glGetString(GL_VERSION);
  OpenGLVendor:=      glGetString(GL_VENDOR);
  OpenGLRenderer:=    glGetString(GL_RENDERER);
  OpenGLExtArbList:=  glGetString(GL_EXTENSIONS);

  i:=Pos(' ', OpenGLVersion);
  tmpStr:=Copy(OpenGLVersion, 1, i - 1);
  Val(tmpStr, OpenGLVersionValues[0], j);
  Delete(tmpStr, 1, j);
  Val(tmpStr, OpenGLVersionValues[1], j);
  //
  Str(OpenGLVersionValues[0], OpenGLVersionShort);
  Str(OpenGLVersionValues[1], tmpStr);
  OpenGLVersionShort:=OpenGLVersionShort + '.' + tmpStr;

  if (OpenGLVersionValues[0] >= 2) then
    begin
      OpenGLShaderVersion:=glGetString(GL_SHADING_LANGUAGE_VERSION);
      //
      i:=Pos(' ', OpenGLShaderVersion);
      tmpStr:=Copy(OpenGLShaderVersion, 1, i - 1);
      Val(tmpStr, OpenGLShaderVersionValues[0], j);
      Delete(tmpStr, 1, j);
      Val(tmpStr, OpenGLShaderVersionValues[1], j);
      if (j > 0) then
        begin
          Delete(tmpStr, 1, j);
          Val(tmpStr, OpenGLShaderVersionValues[2], j);
        end;
    end;

  ////////////////// 942 functions /////////////////
	// 1.2
	
	// EXT GL_EXT_blend_minmax
  CheckAndLoadOpenGLproc(@glBlendEquationEXT, 'glBlendEquationEXT');

	/// GL_EXT_blend_color
	CheckAndLoadOpenGLproc(@glBlendColorEXT, 'glBlendColorEXT');
	
	// GL_EXT_histogram
	CheckAndLoadOpenGLproc(@glHistogramEXT, 'glHistogramEXT');
  CheckAndLoadOpenGLproc(@glResetHistogramEXT, 'glResetHistogramEXT');
  CheckAndLoadOpenGLproc(@glGetHistogramEXT, 'glGetHistogramEXT');
  CheckAndLoadOpenGLproc(@glGetHistogramParameterivEXT, 'glGetHistogramParameterivEXT');
  CheckAndLoadOpenGLproc(@glGetHistogramParameterfvEXT, 'glGetHistogramParameterfvEXT');
  CheckAndLoadOpenGLproc(@glMinmaxEXT, 'glMinmaxEXT');
  CheckAndLoadOpenGLproc(@glResetMinmaxEXT, 'glResetMinmaxEXT');
  CheckAndLoadOpenGLproc(@glGetMinmaxEXT, 'glGetMinmaxEXT');
  CheckAndLoadOpenGLproc(@glGetMinmaxParameterivEXT, 'glGetMinmaxParameterivEXT');
  CheckAndLoadOpenGLproc(@glGetMinmaxParameterfvEXT, 'glGetMinmaxParameterfvEXT');
	
	// GL_SGI_color_table
	CheckAndLoadOpenGLproc(@glColorTableSGI, 'glColorTableSGI');
  CheckAndLoadOpenGLproc(@glCopyColorTableSGI, 'glCopyColorTableSGI');
  CheckAndLoadOpenGLproc(@glColorTableParameterivSGI, 'glColorTableParameterivSGI');
  CheckAndLoadOpenGLproc(@glColorTableParameterfvSGI, 'glColorTableParameterfvSGI');
  CheckAndLoadOpenGLproc(@glGetColorTableSGI, 'glGetColorTableSGI');
  CheckAndLoadOpenGLproc(@glGetColorTableParameterivSGI, 'glGetColorTableParameterivSGI');
  CheckAndLoadOpenGLproc(@glGetColorTableParameterfvSGI, 'glGetColorTableParameterfvSGI');
	
	// GL_EXT_color_subtable
	CheckAndLoadOpenGLproc(@glColorSubTableEXT, 'glColorSubTableEXT');
  CheckAndLoadOpenGLproc(@glCopyColorSubTableEXT, 'glCopyColorSubTableEXT');
	
	// GL_EXT_texture3D
	CheckAndLoadOpenGLproc(@glTexImage3DEXT, 'glTexImage3DEXT');
  CheckAndLoadOpenGLproc(@glTexSubImage3DEXT, 'glTexSubImage3DEXT');
  CheckAndLoadOpenGLproc(@glCopyTexSubImage3DEXT, 'glCopyTexSubImage3DEXT');
	
	// GL_EXT_draw_range_elements
	CheckAndLoadOpenGLproc(@glDrawRangeElementsEXT, 'glDrawRangeElementsEXT');
	
	// GL_EXT_convolution
	CheckAndLoadOpenGLproc(@glConvolutionFilter1DEXT, 'glConvolutionFilter1DEXT');
  CheckAndLoadOpenGLproc(@glConvolutionFilter2DEXT, 'glConvolutionFilter2DEXT');
  CheckAndLoadOpenGLproc(@glCopyConvolutionFilter1DEXT, 'glCopyConvolutionFilter1DEXT');
  CheckAndLoadOpenGLproc(@glCopyConvolutionFilter2DEXT, 'glCopyConvolutionFilter2DEXT');
  CheckAndLoadOpenGLproc(@glGetConvolutionFilterEXT, 'glGetConvolutionFilterEXT');
  CheckAndLoadOpenGLproc(@glSeparableFilter2DEXT, 'glSeparableFilter2DEXT');
  CheckAndLoadOpenGLproc(@glGetSeparableFilterEXT, 'glGetSeparableFilterEXT');
  CheckAndLoadOpenGLproc(@glConvolutionParameteriEXT, 'glConvolutionParameteriEXT');
  CheckAndLoadOpenGLproc(@glConvolutionParameterivEXT, 'glConvolutionParameterivEXT');
  CheckAndLoadOpenGLproc(@glConvolutionParameterfEXT, 'glConvolutionParameterfEXT');
  CheckAndLoadOpenGLproc(@glConvolutionParameterfvEXT, 'glConvolutionParameterfvEXT');
  CheckAndLoadOpenGLproc(@glGetConvolutionParameterivEXT, 'glGetConvolutionParameterivEXT');
  CheckAndLoadOpenGLproc(@glGetConvolutionParameterfvEXT, 'glGetConvolutionParameterfvEXT');
	
	///////////////////////////////////////////////////////
	// 1.3
	
	// GL_ARB_texture_compression
	CheckAndLoadOpenGLproc(@glCompressedTexImage3DARB, 'glCompressedTexImage3DARB');
  CheckAndLoadOpenGLproc(@glCompressedTexImage2DARB, 'glCompressedTexImage2DARB');
  CheckAndLoadOpenGLproc(@glCompressedTexImage1DARB, 'glCompressedTexImage1DARB');
  CheckAndLoadOpenGLproc(@glCompressedTexSubImage3DARB, 'glCompressedTexSubImage3DARB');
  CheckAndLoadOpenGLproc(@glCompressedTexSubImage2DARB, 'glCompressedTexSubImage2DARB');
  CheckAndLoadOpenGLproc(@glCompressedTexSubImage1DARB, 'glCompressedTexSubImage1DARB');
  CheckAndLoadOpenGLproc(@glGetCompressedTexImageARB, 'glGetCompressedTexImageARB');
	
	// GL_ARB_transpose_matrix
	CheckAndLoadOpenGLproc(@glLoadTransposeMatrixdARB, 'glLoadTransposeMatrixdARB');
  CheckAndLoadOpenGLproc(@glLoadTransposeMatrixfARB, 'glLoadTransposeMatrixfARB');
  CheckAndLoadOpenGLproc(@glMultTransposeMatrixdARB, 'glMultTransposeMatrixdARB');
  CheckAndLoadOpenGLproc(@glMultTransposeMatrixfARB, 'glMultTransposeMatrixfARB');
	
	// GL_ARB_multitexture
	CheckAndLoadOpenGLproc(@glActiveTextureARB, 'glActiveTextureARB');
  CheckAndLoadOpenGLproc(@glClientActiveTextureARB, 'glClientActiveTextureARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord1sARB, 'glMultiTexCoord1sARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord2sARB, 'glMultiTexCoord2sARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord3sARB, 'glMultiTexCoord3sARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord4sARB, 'glMultiTexCoord4sARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord1iARB, 'glMultiTexCoord1iARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord2iARB, 'glMultiTexCoord2iARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord3iARB, 'glMultiTexCoord3iARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord4iARB, 'glMultiTexCoord4iARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord1fARB, 'glMultiTexCoord1fARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord2fARB, 'glMultiTexCoord2fARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord3fARB, 'glMultiTexCoord3fARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord4fARB, 'glMultiTexCoord4fARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord1dARB, 'glMultiTexCoord1dARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord2dARB, 'glMultiTexCoord2dARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord3dARB, 'glMultiTexCoord3dARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord4dARB, 'glMultiTexCoord4dARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord1svARB, 'glMultiTexCoord1svARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord2svARB, 'glMultiTexCoord2svARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord3svARB, 'glMultiTexCoord3svARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord4svARB, 'glMultiTexCoord4svARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord1ivARB, 'glMultiTexCoord1ivARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord2ivARB, 'glMultiTexCoord2ivARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord3ivARB, 'glMultiTexCoord3ivARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord4ivARB, 'glMultiTexCoord4ivARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord1fvARB, 'glMultiTexCoord1fvARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord2fvARB, 'glMultiTexCoord2fvARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord3fvARB, 'glMultiTexCoord3fvARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord4fvARB, 'glMultiTexCoord4fvARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord1dvARB, 'glMultiTexCoord1dvARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord2dvARB, 'glMultiTexCoord2dvARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord3dvARB, 'glMultiTexCoord3dvARB');
  CheckAndLoadOpenGLproc(@glMultiTexCoord4dvARB, 'glMultiTexCoord4dvARB');
	
	// GL_ARB_multisample
	CheckAndLoadOpenGLproc(@glSampleCoverageARB, 'glSampleCoverageARB');
	
	///////////////////////////////////////////////////////////
	// 1.4
	
	// GL_ARB_window_pos
	CheckAndLoadOpenGLproc(@glWindowPos2sARB, 'glWindowPos2sARB');
  CheckAndLoadOpenGLproc(@glWindowPos2iARB, 'glWindowPos2iARB');
  CheckAndLoadOpenGLproc(@glWindowPos2fARB, 'glWindowPos2fARB');
  CheckAndLoadOpenGLproc(@glWindowPos2dARB, 'glWindowPos2dARB');
  CheckAndLoadOpenGLproc(@glWindowPos2svARB, 'glWindowPos2svARB');
  CheckAndLoadOpenGLproc(@glWindowPos2ivARB, 'glWindowPos2ivARB');
  CheckAndLoadOpenGLproc(@glWindowPos2fvARB, 'glWindowPos2fvARB');
  CheckAndLoadOpenGLproc(@glWindowPos2dvARB, 'glWindowPos2dvARB');
  CheckAndLoadOpenGLproc(@glWindowPos3sARB, 'glWindowPos3sARB');
  CheckAndLoadOpenGLproc(@glWindowPos3iARB, 'glWindowPos3iARB');
  CheckAndLoadOpenGLproc(@glWindowPos3fARB, 'glWindowPos3fARB');
  CheckAndLoadOpenGLproc(@glWindowPos3dARB, 'glWindowPos3dARB');
  CheckAndLoadOpenGLproc(@glWindowPos3svARB, 'glWindowPos3svARB');
  CheckAndLoadOpenGLproc(@glWindowPos3ivARB, 'glWindowPos3ivARB');
  CheckAndLoadOpenGLproc(@glWindowPos3fvARB, 'glWindowPos3fvARB');
  CheckAndLoadOpenGLproc(@glWindowPos3dvARB, 'glWindowPos3dvARB');
	
	// GL_EXT_blend_func_separate
	CheckAndLoadOpenGLproc(@glBlendFuncSeparateEXT, 'glBlendFuncSeparateEXT');
	
	// GL_EXT_multi_draw_arrays
	CheckAndLoadOpenGLproc(@glMultiDrawArraysEXT, 'glMultiDrawArraysEXT');
  CheckAndLoadOpenGLproc(@glMultiDrawElementsEXT, 'glMultiDrawElementsEXT');
	
	// GL_ARB_point_parameters
	CheckAndLoadOpenGLproc(@glPointParameterfARB, 'glPointParameterfARB');
  CheckAndLoadOpenGLproc(@glPointParameterfvARB, 'glPointParameterfvARB');
	
	// GL_EXT_fog_coord
	CheckAndLoadOpenGLproc(@glFogCoordfEXT, 'glFogCoordfEXT');
  CheckAndLoadOpenGLproc(@glFogCoorddEXT, 'glFogCoorddEXT');
  CheckAndLoadOpenGLproc(@glFogCoordfvEXT, 'glFogCoordfvEXT');
  CheckAndLoadOpenGLproc(@glFogCoorddvEXT, 'glFogCoorddvEXT');
  CheckAndLoadOpenGLproc(@glFogCoordPointerEXT, 'glFogCoordPointerEXT');
	
	// GL_EXT_secondary_color
	CheckAndLoadOpenGLproc(@glSecondaryColor3bEXT, 'glSecondaryColor3bEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3bvEXT, 'glSecondaryColor3bvEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3sEXT, 'glSecondaryColor3sEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3svEXT, 'glSecondaryColor3svEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3iEXT, 'glSecondaryColor3iEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3ivEXT, 'glSecondaryColor3ivEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3fEXT, 'glSecondaryColor3fEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3fvEXT, 'glSecondaryColor3fvEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3dEXT, 'glSecondaryColor3dEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3dvEXT, 'glSecondaryColor3dvEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3ubEXT, 'glSecondaryColor3ubEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3ubvEXT, 'glSecondaryColor3ubvEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3usEXT, 'glSecondaryColor3usEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3usvEXT, 'glSecondaryColor3usvEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3uiEXT, 'glSecondaryColor3uiEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColor3uivEXT, 'glSecondaryColor3uivEXT');
  CheckAndLoadOpenGLproc(@glSecondaryColorPointerEXT, 'glSecondaryColorPointerEXT');
	
	//////////////////////////////////////////////////////////////////
	// 1.5
	
	// GL_ARB_occlusion_query
	CheckAndLoadOpenGLproc(@glGenQueriesARB, 'glGenQueriesARB');
  CheckAndLoadOpenGLproc(@glDeleteQueriesARB, 'glDeleteQueriesARB');
  CheckAndLoadOpenGLproc(@glIsQueryARB, 'glIsQueryARB');
  CheckAndLoadOpenGLproc(@glBeginQueryARB, 'glBeginQueryARB');
  CheckAndLoadOpenGLproc(@glEndQueryARB, 'glEndQueryARB');
  CheckAndLoadOpenGLproc(@glGetQueryivARB, 'glGetQueryivARB');
  CheckAndLoadOpenGLproc(@glGetQueryObjectivARB, 'glGetQueryObjectivARB');
  CheckAndLoadOpenGLproc(@glGetQueryObjectuivARB, 'glGetQueryObjectuivARB');
	
	// GL_ARB_vertex_buffer_object
	CheckAndLoadOpenGLproc(@glBindBufferARB, 'glBindBufferARB');
  CheckAndLoadOpenGLproc(@glDeleteBuffersARB, 'glDeleteBuffersARB');
  CheckAndLoadOpenGLproc(@glGenBuffersARB, 'glGenBuffersARB');
  CheckAndLoadOpenGLproc(@glIsBufferARB, 'glIsBufferARB');
  CheckAndLoadOpenGLproc(@glBufferDataARB, 'glBufferDataARB');
  CheckAndLoadOpenGLproc(@glBufferSubDataARB, 'glBufferSubDataARB');
  CheckAndLoadOpenGLproc(@glGetBufferSubDataARB, 'glGetBufferSubDataARB');
  CheckAndLoadOpenGLproc(@glMapBufferARB, 'glMapBufferARB');
  CheckAndLoadOpenGLproc(@glUnmapBufferARB, 'glUnmapBufferARB');
  CheckAndLoadOpenGLproc(@glGetBufferParameterivARB, 'glGetBufferParameterivARB');
  CheckAndLoadOpenGLproc(@glGetBufferPointervARB, 'glGetBufferPointervARB');
	
	////////////////////////////////////////////////////////////////
	// 2.0
	
	// GL_ATI_separate_stencil
	CheckAndLoadOpenGLproc(@glStencilOpSeparateATI, 'glStencilOpSeparateATI');
  CheckAndLoadOpenGLproc(@glStencilFuncSeparateATI, 'glStencilFuncSeparateATI');
	
	// GL_EXT_stencil_two_side
	CheckAndLoadOpenGLproc(@glActiveStencilFaceEXT, 'glActiveStencilFaceEXT');
	
	// GL_ARB_draw_buffers
	CheckAndLoadOpenGLproc(@glDrawBuffersARB, 'glDrawBuffersARB');
	
	// GL_ARB_vertex_shader
	CheckAndLoadOpenGLproc(@glVertexAttrib1fARB, 'glVertexAttrib1fARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib1sARB, 'glVertexAttrib1sARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib1dARB, 'glVertexAttrib1dARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib2fARB, 'glVertexAttrib2fARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib2sARB, 'glVertexAttrib2sARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib2dARB, 'glVertexAttrib2dARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib3fARB, 'glVertexAttrib3fARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib3sARB, 'glVertexAttrib3sARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib3dARB, 'glVertexAttrib3dARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4fARB, 'glVertexAttrib4fARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4sARB, 'glVertexAttrib4sARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4dARB, 'glVertexAttrib4dARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4NubARB, 'glVertexAttrib4NubARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib1fvARB, 'glVertexAttrib1fvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib1svARB, 'glVertexAttrib1svARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib1dvARB, 'glVertexAttrib1dvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib2fvARB, 'glVertexAttrib2fvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib2svARB, 'glVertexAttrib2svARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib2dvARB, 'glVertexAttrib2dvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib3fvARB, 'glVertexAttrib3fvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib3svARB, 'glVertexAttrib3svARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib3dvARB, 'glVertexAttrib3dvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4fvARB, 'glVertexAttrib4fvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4svARB, 'glVertexAttrib4svARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4dvARB, 'glVertexAttrib4dvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4ivARB, 'glVertexAttrib4ivARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4bvARB, 'glVertexAttrib4bvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4ubvARB, 'glVertexAttrib4ubvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4usvARB, 'glVertexAttrib4usvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4uivARB, 'glVertexAttrib4uivARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4NbvARB, 'glVertexAttrib4NbvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4NsvARB, 'glVertexAttrib4NsvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4NivARB, 'glVertexAttrib4NivARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4NubvARB, 'glVertexAttrib4NubvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4NusvARB, 'glVertexAttrib4NusvARB');
  CheckAndLoadOpenGLproc(@glVertexAttrib4NuivARB, 'glVertexAttrib4NuivARB');
  CheckAndLoadOpenGLproc(@glVertexAttribPointerARB, 'glVertexAttribPointerARB');
  CheckAndLoadOpenGLproc(@glEnableVertexAttribArrayARB, 'glEnableVertexAttribArrayARB');
  CheckAndLoadOpenGLproc(@glDisableVertexAttribArrayARB, 'glDisableVertexAttribArrayARB');
  CheckAndLoadOpenGLproc(@glBindAttribLocationARB, 'glBindAttribLocationARB');
  CheckAndLoadOpenGLproc(@glGetActiveAttribARB, 'glGetActiveAttribARB');
  CheckAndLoadOpenGLproc(@glGetAttribLocationARB, 'glGetAttribLocationARB');
  CheckAndLoadOpenGLproc(@glGetVertexAttribdvARB, 'glGetVertexAttribdvARB');
  CheckAndLoadOpenGLproc(@glGetVertexAttribfvARB, 'glGetVertexAttribfvARB');
  CheckAndLoadOpenGLproc(@glGetVertexAttribivARB, 'glGetVertexAttribivARB');
  CheckAndLoadOpenGLproc(@glGetVertexAttribPointervARB, 'glGetVertexAttribPointervARB');
	
	// GL_ARB_shader_objects
	CheckAndLoadOpenGLproc(@glDeleteObjectARB, 'glDeleteObjectARB');
  CheckAndLoadOpenGLproc(@glGetHandleARB, 'glGetHandleARB');
  CheckAndLoadOpenGLproc(@glDetachObjectARB, 'glDetachObjectARB');
  CheckAndLoadOpenGLproc(@glCreateShaderObjectARB, 'glCreateShaderObjectARB');
  CheckAndLoadOpenGLproc(@glShaderSourceARB, 'glShaderSourceARB');
  CheckAndLoadOpenGLproc(@glCompileShaderARB, 'glCompileShaderARB');
  CheckAndLoadOpenGLproc(@glCreateProgramObjectARB, 'glCreateProgramObjectARB');
  CheckAndLoadOpenGLproc(@glAttachObjectARB, 'glAttachObjectARB');
  CheckAndLoadOpenGLproc(@glLinkProgramARB, 'glLinkProgramARB');
  CheckAndLoadOpenGLproc(@glUseProgramObjectARB, 'glUseProgramObjectARB');
  CheckAndLoadOpenGLproc(@glValidateProgramARB, 'glValidateProgramARB');
  CheckAndLoadOpenGLproc(@glGetObjectParameterfvARB, 'glGetObjectParameterfvARB');
  CheckAndLoadOpenGLproc(@glGetObjectParameterivARB, 'glGetObjectParameterivARB');
  CheckAndLoadOpenGLproc(@glGetInfoLogARB, 'glGetInfoLogARB');
  CheckAndLoadOpenGLproc(@glGetAttachedObjectsARB, 'glGetAttachedObjectsARB');
  CheckAndLoadOpenGLproc(@glGetUniformLocationARB, 'glGetUniformLocationARB');
  CheckAndLoadOpenGLproc(@glGetActiveUniformARB, 'glGetActiveUniformARB');
  CheckAndLoadOpenGLproc(@glGetUniformfvARB, 'glGetUniformfvARB');
  CheckAndLoadOpenGLproc(@glGetUniformivARB, 'glGetUniformivARB');
  CheckAndLoadOpenGLproc(@glGetShaderSourceARB, 'glGetShaderSourceARB');
  CheckAndLoadOpenGLproc(@glUniform1fARB, 'glUniform1fARB');
  CheckAndLoadOpenGLproc(@glUniform2fARB, 'glUniform2fARB');
  CheckAndLoadOpenGLproc(@glUniform3fARB, 'glUniform3fARB');
  CheckAndLoadOpenGLproc(@glUniform4fARB, 'glUniform4fARB');
  CheckAndLoadOpenGLproc(@glUniform1iARB, 'glUniform1iARB');
  CheckAndLoadOpenGLproc(@glUniform2iARB, 'glUniform2iARB');
  CheckAndLoadOpenGLproc(@glUniform3iARB, 'glUniform3iARB');
  CheckAndLoadOpenGLproc(@glUniform4iARB, 'glUniform4iARB');
  CheckAndLoadOpenGLproc(@glUniform1fvARB, 'glUniform1fvARB');
  CheckAndLoadOpenGLproc(@glUniform2fvARB, 'glUniform2fvARB');
  CheckAndLoadOpenGLproc(@glUniform3fvARB, 'glUniform3fvARB');
  CheckAndLoadOpenGLproc(@glUniform4fvARB, 'glUniform4fvARB');
  CheckAndLoadOpenGLproc(@glUniform1ivARB, 'glUniform1ivARB');
  CheckAndLoadOpenGLproc(@glUniform2ivARB, 'glUniform2ivARB');
  CheckAndLoadOpenGLproc(@glUniform3ivARB, 'glUniform3ivARB');
  CheckAndLoadOpenGLproc(@glUniform4ivARB, 'glUniform4ivARB');
  CheckAndLoadOpenGLproc(@glUniformMatrix2fvARB, 'glUniformMatrix2fvARB');
  CheckAndLoadOpenGLproc(@glUniformMatrix3fvARB, 'glUniformMatrix3fvARB');
  CheckAndLoadOpenGLproc(@glUniformMatrix4fvARB, 'glUniformMatrix4fvARB');
	
	  /////////////////////////////////////////////////////////////////
  // 2.1
  
  // GL_NV_non_square_matrices
  CheckAndLoadOpenGLproc(@glUniformMatrix2x3fvNV, 'glUniformMatrix2x3fvNV');
  CheckAndLoadOpenGLproc(@glUniformMatrix2x4fvNV, 'glUniformMatrix2x4fvNV');
  CheckAndLoadOpenGLproc(@glUniformMatrix3x2fvNV, 'glUniformMatrix3x2fvNV');
  CheckAndLoadOpenGLproc(@glUniformMatrix3x4fvNV, 'glUniformMatrix3x4fvNV');
  CheckAndLoadOpenGLproc(@glUniformMatrix4x2fvNV, 'glUniformMatrix4x2fvNV');
  CheckAndLoadOpenGLproc(@glUniformMatrix4x3fvNV, 'glUniformMatrix4x3fvNV');  
  
  //////////////////////////////////////////////////////////////////
  // 3.0
  
  // GL_NV_conditional_render
  CheckAndLoadOpenGLproc(@glBeginConditionalRenderNV, 'glBeginConditionalRenderNV');
  CheckAndLoadOpenGLproc(@glEndConditionalRenderNV, 'glEndConditionalRenderNV');
  
  // GL_ARB_color_buffer_float
  CheckAndLoadOpenGLproc(@glClampColorARB, 'glClampColorARB');
  
  // GL_NV_depth_buffer_float
  CheckAndLoadOpenGLproc(@glDepthRangedNV, 'glDepthRangedNV');
  CheckAndLoadOpenGLproc(@glClearDepthdNV, 'glClearDepthdNV');
  CheckAndLoadOpenGLproc(@glDepthBoundsdNV, 'glDepthBoundsdNV');
  
  // GL_EXT_draw_buffers2
  CheckAndLoadOpenGLproc(@glColorMaskIndexedEXT, 'glColorMaskIndexedEXT');
  
  // GL_EXT_texture_array
  CheckAndLoadOpenGLproc(@glFramebufferTextureLayerEXT, 'glFramebufferTextureLayerEXT');
  
  // GL_EXT_texture_integer
  CheckAndLoadOpenGLproc(@glClearColorIiEXT, 'glClearColorIiEXT');
  CheckAndLoadOpenGLproc(@glClearColorIuiEXT, 'glClearColorIuiEXT');
  CheckAndLoadOpenGLproc(@glTexParameterIivEXT, 'glTexParameterIivEXT');
  CheckAndLoadOpenGLproc(@glTexParameterIuivEXT, 'glTexParameterIuivEXT');
  CheckAndLoadOpenGLproc(@glGetTexParameterIivEXT, 'glGetTexParameterIivEXT');
  CheckAndLoadOpenGLproc(@glGetTexParameterIuivEXT, 'glGetTexParameterIuivEXT');
  
  // GL_NV_transform_feedback
  CheckAndLoadOpenGLproc(@glBindBufferOffsetNV, 'glBindBufferOffsetNV');
  CheckAndLoadOpenGLproc(@glTransformFeedbackAttribsNV, 'glTransformFeedbackAttribsNV');
  CheckAndLoadOpenGLproc(@glTransformFeedbackVaryingsNV, 'glTransformFeedbackVaryingsNV');
  CheckAndLoadOpenGLproc(@glBeginTransformFeedbackNV, 'glBeginTransformFeedbackNV');
  CheckAndLoadOpenGLproc(@glEndTransformFeedbackNV, 'glEndTransformFeedbackNV');
  CheckAndLoadOpenGLproc(@glGetVaryingLocationNV, 'GetVaryingLocationNV');
  CheckAndLoadOpenGLproc(@glGetActiveVaryingNV, 'glGetActiveVaryingNV');
  CheckAndLoadOpenGLproc(@glActiveVaryingNV, 'glActiveVaryingNV');
  CheckAndLoadOpenGLproc(@glGetTransformFeedbackVaryingNV, 'glGetTransformFeedbackVaryingNV');
  
  // GL_ARB_vertex_array_object
  CheckAndLoadOpenGLproc(@glBindVertexArray, 'glBindVertexArray');
  CheckAndLoadOpenGLproc(@glDeleteVertexArrays, 'glDeleteVertexArrays');
  CheckAndLoadOpenGLproc(@glGenVertexArrays, 'glGenVertexArrays');
  CheckAndLoadOpenGLproc(@glIsVertexArray, 'glIsVertexArray');
  CheckAndLoadOpenGLproc(@glVertexAttribIPointer, 'glVertexAttribIPointer');
  
  // GL_ARB_framebuffer_object
  CheckAndLoadOpenGLproc(@glBindRenderbuffer, 'glBindRenderbuffer');
  CheckAndLoadOpenGLproc(@glDeleteRenderbuffers, 'glDeleteRenderbuffers');
  CheckAndLoadOpenGLproc(@glGenRenderbuffers, 'glGenRenderbuffers');
  CheckAndLoadOpenGLproc(@glIsRenderbuffer, 'glIsRenderbuffer');
  CheckAndLoadOpenGLproc(@glRenderbufferStorage, 'glRenderbufferStorage');
  CheckAndLoadOpenGLproc(@glRenderbufferStorageMultisample, 'glRenderbufferStorageMultisample');
  CheckAndLoadOpenGLproc(@glGetRenderbufferParameteriv, 'glGetRenderbufferParameteriv');
  CheckAndLoadOpenGLproc(@glBindFramebuffer, 'glBindFramebuffer');
  CheckAndLoadOpenGLproc(@glDeleteFramebuffers, 'glDeleteFramebuffers');
  CheckAndLoadOpenGLproc(@glGenFramebuffers, 'glGenFramebuffers');
  CheckAndLoadOpenGLproc(@glIsFramebuffer, 'glIsFramebuffer');
  CheckAndLoadOpenGLproc(@glFramebufferTexture1D, 'glFramebufferTexture1D');
  CheckAndLoadOpenGLproc(@glFramebufferTexture2D, 'glFramebufferTexture2D');
  CheckAndLoadOpenGLproc(@glFramebufferTexture3D, 'glFramebufferTexture3D');
  CheckAndLoadOpenGLproc(@glGetFramebufferAttachmentParameteriv, 'glGetFramebufferAttachmentParameteriv');
  CheckAndLoadOpenGLproc(@glCheckFramebufferStatus, 'glCheckFramebufferStatus');
  CheckAndLoadOpenGLproc(@glBlitFramebuffer, 'glBlitFramebuffer');
  CheckAndLoadOpenGLproc(@glFramebufferRenderbuffer, 'glFramebufferRenderbuffer');
  CheckAndLoadOpenGLproc(@glGenerateMipmap, 'glGenerateMipmap');
  
  ////////////////////////////////////////////////////////////////////////
  // 3.1
  
  // GL_ARB_texture_buffer_object
  CheckAndLoadOpenGLproc(@glTexBufferARB, 'glTexBufferARB');  
  
  // GL_NV_primitive_restart
  CheckAndLoadOpenGLproc(@glPrimitiveRestartNV, 'glPrimitiveRestartNV');
  CheckAndLoadOpenGLproc(@glPrimitiveRestartIndexNV, 'glPrimitiveRestartIndexNV');
  
  // GL_ARB_draw_instanced
  CheckAndLoadOpenGLproc(@glDrawArraysInstancedARB, 'glDrawArraysInstancedARB');
  CheckAndLoadOpenGLproc(@glDrawElementsInstancedARB, 'glDrawElementsInstancedARB');
  
  // GL_ARB_copy_buffer
  CheckAndLoadOpenGLproc(@glCopyBufferSubData, 'glCopyBufferSubData');
  
  // GL_ARB_uniform_buffer_object
  CheckAndLoadOpenGLproc(@glGetUniformIndices, 'glGetUniformIndices');
  CheckAndLoadOpenGLproc(@glGetActiveUniformsiv, 'glGetActiveUniformsiv');
  CheckAndLoadOpenGLproc(@glGetActiveUniformName, 'glGetActiveUniformName');
  CheckAndLoadOpenGLproc(@glGetUniformBlockIndex, 'glGetUniformBlockIndex');
  CheckAndLoadOpenGLproc(@glGetActiveUniformBlockiv, 'glGetActiveUniformBlockiv');
  CheckAndLoadOpenGLproc(@glGetActiveUniformBlockName, 'glGetActiveUniformBlockName');
  CheckAndLoadOpenGLproc(@glBindBufferRange, 'glBindBufferRange');
  CheckAndLoadOpenGLproc(@glBindBufferBase, 'glBindBufferBase');
  CheckAndLoadOpenGLproc(@glGetIntegeri_v, 'glGetIntegeri_v');
  CheckAndLoadOpenGLproc(@glUniformBlockBinding, 'glUniformBlockBinding');
  
  /////////////////////////////////////////////////////////////////
  // 3.2
  
  // GL_ARB_draw_elements_base_vertex
  CheckAndLoadOpenGLproc(@glDrawElementsBaseVertex, 'glDrawElementsBaseVertex');
  CheckAndLoadOpenGLproc(@glDrawRangeElementsBaseVertex, 'glDrawRangeElementsBaseVertex');
  CheckAndLoadOpenGLproc(@glDrawElementsInstancedBaseVertex, 'glDrawElementsInstancedBaseVertex');
  CheckAndLoadOpenGLproc(@glMultiDrawElementsBaseVertex, 'glMultiDrawElementsBaseVertex');
  
  // GL_ARB_provoking_vertex
  CheckAndLoadOpenGLproc(@glProvokingVertex, 'glProvokingVertex');
  
  // GL_ARB_texture_multisample
  CheckAndLoadOpenGLproc(@glTexImage2DMultisample, 'glTexImage2DMultisample');
  CheckAndLoadOpenGLproc(@glTexImage3DMultisample, 'glTexImage3DMultisample');
  CheckAndLoadOpenGLproc(@glGetMultisamplefv, 'glGetMultisamplefv');
  CheckAndLoadOpenGLproc(@glSampleMaski, 'glSampleMaski');
  
  // GL_ARB_sync
  CheckAndLoadOpenGLproc(@glFenceSync, 'glFenceSync');
  CheckAndLoadOpenGLproc(@glIsSync, 'glIsSync');
  CheckAndLoadOpenGLproc(@glDeleteSync, 'glDeleteSync');
  CheckAndLoadOpenGLproc(@glClientWaitSync, 'glClientWaitSync');
  CheckAndLoadOpenGLproc(@glWaitSync, 'glWaitSync');
  CheckAndLoadOpenGLproc(@glGetInteger64v, 'glGetInteger64v');
  CheckAndLoadOpenGLproc(@glGetSynciv, 'glGetSynciv');
  
  // GL_ARB_geometry_shader4
  CheckAndLoadOpenGLproc(@glProgramParameteriARB, 'glProgramParameteriARB');
  CheckAndLoadOpenGLproc(@glFramebufferTextureARB, 'glFramebufferTextureARB');
  CheckAndLoadOpenGLproc(@glFramebufferTextureLayerARB, 'glFramebufferTextureLayerARB');
  CheckAndLoadOpenGLproc(@glFramebufferTextureFaceARB, 'glFramebufferTextureFaceARB');
  
  //////////////////////////////////////////////////////////////////
  // 3.3 
  
  // GL_ARB_blend_func_extended
  CheckAndLoadOpenGLproc(@glBindFragDataLocationIndexed, 'glBindFragDataLocationIndexed');
  CheckAndLoadOpenGLproc(@glGetFragDataIndex, 'glGetFragDataIndex');
  
  // GL_ARB_sampler_objects
  CheckAndLoadOpenGLproc(@glGenSamplers, 'glGenSamplers');
  CheckAndLoadOpenGLproc(@glDeleteSamplers, 'glDeleteSamplers');
  CheckAndLoadOpenGLproc(@glIsSampler, 'glIsSampler');
  CheckAndLoadOpenGLproc(@glBindSampler, 'glBindSampler');
  CheckAndLoadOpenGLproc(@glSamplerParameteri, 'glSamplerParameteri');
  CheckAndLoadOpenGLproc(@glSamplerParameterf, 'glSamplerParameterf');
  CheckAndLoadOpenGLproc(@glSamplerParameteriv, 'glSamplerParameteriv');
  CheckAndLoadOpenGLproc(@glSamplerParameterfv, 'glSamplerParameterfv');
  CheckAndLoadOpenGLproc(@glSamplerParameterIiv, 'glSamplerParameterIiv');
  CheckAndLoadOpenGLproc(@glSamplerParameterIuiv, 'glSamplerParameterIuiv');
  CheckAndLoadOpenGLproc(@glGetSamplerParameteriv, 'glGetSamplerParameteriv');
  CheckAndLoadOpenGLproc(@glGetSamplerParameterfv, 'glGetSamplerParameterfv');
  CheckAndLoadOpenGLproc(@glGetSamplerParameterIiv, 'glGetSamplerParameterIiv');
  CheckAndLoadOpenGLproc(@glGetSamplerParameterIuiv, 'glGetSamplerParameterIuiv');
  
  // GL_ARB_timer_query
  CheckAndLoadOpenGLproc(@glQueryCounter, 'glQueryCounter');
  CheckAndLoadOpenGLproc(@glGetQueryObjecti64v, 'glGetQueryObjecti64v');
  CheckAndLoadOpenGLproc(@glGetQueryObjectui64v, 'glGetQueryObjectui64v');
  
  // GL_ARB_instanced_arrays
  CheckAndLoadOpenGLproc(@glVertexAttribDivisorARB, 'glVertexAttribDivisorARB');
  CheckAndLoadOpenGLproc(@glVertexArrayVertexAttribDivisorEXT, 'glVertexArrayVertexAttribDivisorEXT');
  
  // GL_ARB_vertex_type_2_10_10_10_rev
  CheckAndLoadOpenGLproc(@glVertexP2ui, 'glVertexP2ui');
  CheckAndLoadOpenGLproc(@glVertexP3ui, 'glVertexP3ui');
  CheckAndLoadOpenGLproc(@glVertexP4ui, 'glVertexP4ui');
  CheckAndLoadOpenGLproc(@glVertexP2uiv, 'glVertexP2uiv');
  CheckAndLoadOpenGLproc(@glVertexP3uiv, 'glVertexP3uiv');
  CheckAndLoadOpenGLproc(@glVertexP4uiv, 'glVertexP4uiv');
  CheckAndLoadOpenGLproc(@glTexCoordP1ui, 'glTexCoordP1ui');
  CheckAndLoadOpenGLproc(@glTexCoordP1ui, 'glTexCoordP1ui');
  CheckAndLoadOpenGLproc(@glTexCoordP2ui, 'glTexCoordP2ui');
  CheckAndLoadOpenGLproc(@glTexCoordP3ui, 'glTexCoordP3ui');
  CheckAndLoadOpenGLproc(@glTexCoordP1uiv, 'glTexCoordP1uiv');
  CheckAndLoadOpenGLproc(@glTexCoordP2uiv, 'glTexCoordP2uiv');
  CheckAndLoadOpenGLproc(@glTexCoordP3uiv, 'glTexCoordP3uiv');
  CheckAndLoadOpenGLproc(@glTexCoordP4uiv, 'glTexCoordP4uiv');
  CheckAndLoadOpenGLproc(@glMultiTexCoordP1ui, 'glMultiTexCoordP1ui');
  CheckAndLoadOpenGLproc(@glMultiTexCoordP2ui, 'glMultiTexCoordP2ui');
  CheckAndLoadOpenGLproc(@glMultiTexCoordP3ui, 'glMultiTexCoordP3ui');
  CheckAndLoadOpenGLproc(@glMultiTexCoordP4ui, 'glMultiTexCoordP4ui');
  CheckAndLoadOpenGLproc(@glMultiTexCoordP1uiv, 'glMultiTexCoordP1uiv');
  CheckAndLoadOpenGLproc(@glMultiTexCoordP2uiv, 'glMultiTexCoordP2uiv');
  CheckAndLoadOpenGLproc(@glMultiTexCoordP3uiv, 'glMultiTexCoordP3uiv');
  CheckAndLoadOpenGLproc(@glMultiTexCoordP4uiv, 'glMultiTexCoordP4uiv');
  CheckAndLoadOpenGLproc(@glNormalP3ui, 'glNormalP3ui');
  CheckAndLoadOpenGLproc(@glNormalP3uiv, 'glNormalP3uiv');
  CheckAndLoadOpenGLproc(@glColorP3ui, 'glColorP3ui');
  CheckAndLoadOpenGLproc(@glColorP4ui, 'glColorP4ui');
  CheckAndLoadOpenGLproc(@glColorP3uiv, 'glColorP3uiv');
  CheckAndLoadOpenGLproc(@glColorP4uiv, 'glColorP4uiv');
  CheckAndLoadOpenGLproc(@glSecondaryColorP3ui, 'glSecondaryColorP3ui');
  CheckAndLoadOpenGLproc(@glSecondaryColorP3uiv, 'glSecondaryColorP3uiv');
  CheckAndLoadOpenGLproc(@glVertexAttribP1ui, 'glVertexAttribP1ui');
  CheckAndLoadOpenGLproc(@glVertexAttribP2ui, 'glVertexAttribP2ui');
  CheckAndLoadOpenGLproc(@glVertexAttribP3ui, 'glVertexAttribP3ui');
  CheckAndLoadOpenGLproc(@glVertexAttribP4ui, 'glVertexAttribP4ui');
  CheckAndLoadOpenGLproc(@glVertexAttribP1uiv, 'glVertexAttribP1uiv');
  CheckAndLoadOpenGLproc(@glVertexAttribP2uiv, 'glVertexAttribP2uiv');
  CheckAndLoadOpenGLproc(@glVertexAttribP3uiv, 'glVertexAttribP3uiv');
  CheckAndLoadOpenGLproc(@glVertexAttribP4uiv, 'glVertexAttribP4uiv');
  
  //////////////////////////////////////////////////////////////////
  // 4.0
  
  // GL_ARB_sample_shading
  CheckAndLoadOpenGLproc(@glMinSampleShadingARB, 'glMinSampleShadingARB');
  
  // GL_ARB_draw_indirect
  CheckAndLoadOpenGLproc(@glDrawArraysIndirect, 'glDrawArraysIndirect');
  CheckAndLoadOpenGLproc(@glDrawElementsIndirect, 'glDrawElementsIndirect');
  
  // GL_ARB_transform_feedback2
  CheckAndLoadOpenGLproc(@glBindTransformFeedback, 'glBindTransformFeedback');
  CheckAndLoadOpenGLproc(@glDeleteTransformFeedbacks, 'glDeleteTransformFeedbacks');
  CheckAndLoadOpenGLproc(@glGenTransformFeedbacks, 'glGenTransformFeedbacks');
  CheckAndLoadOpenGLproc(@glIsTransformFeedback, 'glIsTransformFeedback');
  CheckAndLoadOpenGLproc(@glPauseTransformFeedback, 'glPauseTransformFeedback');
  CheckAndLoadOpenGLproc(@glResumeTransformFeedback, 'glResumeTransformFeedback');
  CheckAndLoadOpenGLproc(@glDrawTransformFeedback, 'glDrawTransformFeedback');
  
  // GL_ARB_transform_feedback3
  CheckAndLoadOpenGLproc(@glDrawTransformFeedbackStream, 'glDrawTransformFeedbackStream');
  CheckAndLoadOpenGLproc(@glBeginQueryIndexed, 'glBeginQueryIndexed');
  CheckAndLoadOpenGLproc(@glEndQueryIndexed, 'glEndQueryIndexed');
  CheckAndLoadOpenGLproc(@glGetQueryIndexediv, 'glGetQueryIndexediv');
  
  // GL_ARB_tessellation_shader
  CheckAndLoadOpenGLproc(@glPatchParameteri, 'glPatchParameteri');
  CheckAndLoadOpenGLproc(@glPatchParameterfv, 'glPatchParameterfv');
  
  // GL_ARB_gpu_shader_fp64
  CheckAndLoadOpenGLproc(@glUniform1d, 'glUniform1d');
  CheckAndLoadOpenGLproc(@glUniform2d, 'glUniform2d');
  CheckAndLoadOpenGLproc(@glUniform3d, 'glUniform3d');
  CheckAndLoadOpenGLproc(@glUniform4d, 'glUniform4d');
  CheckAndLoadOpenGLproc(@glUniform1dv, 'glUniform1dv');
  CheckAndLoadOpenGLproc(@glUniform2dv, 'glUniform2dv');
  CheckAndLoadOpenGLproc(@glUniform3dv, 'glUniform3dv');
  CheckAndLoadOpenGLproc(@glUniform4dv, 'glUniform4dv');
  CheckAndLoadOpenGLproc(@glUniformMatrix2dv, 'glUniformMatrix2dv');
  CheckAndLoadOpenGLproc(@glUniformMatrix3dv, 'glUniformMatrix3dv');
  CheckAndLoadOpenGLproc(@glUniformMatrix4dv, 'glUniformMatrix4dv');
  CheckAndLoadOpenGLproc(@glUniformMatrix2x3dv, 'glUniformMatrix2x3dv');
  CheckAndLoadOpenGLproc(@glUniformMatrix2x4dv, 'glUniformMatrix2x4dv');
  CheckAndLoadOpenGLproc(@glUniformMatrix3x2dv, 'glUniformMatrix3x2dv');
  CheckAndLoadOpenGLproc(@glUniformMatrix3x4dv, 'glUniformMatrix3x4dv');
  CheckAndLoadOpenGLproc(@glUniformMatrix4x2dv, 'glUniformMatrix4x2dv');
  CheckAndLoadOpenGLproc(@glUniformMatrix4x3dv, 'glUniformMatrix4x3dv');
  CheckAndLoadOpenGLproc(@glGetUniformdv, 'glGetUniformdv');
  CheckAndLoadOpenGLproc(@glProgramUniform1dEXT, 'glProgramUniform1dEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform2dEXT, 'glProgramUniform2dEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform3dEXT, 'glProgramUniform3dEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform4dEXT, 'glProgramUniform4dEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform1dvEXT, 'glProgramUniform1dvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform2dvEXT, 'glProgramUniform2dvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform3dvEXT, 'glProgramUniform3dvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform4dvEXT, 'glProgramUniform4dvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix2dvEXT, 'glProgramUniformMatrix2dvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix3dvEXT, 'glProgramUniformMatrix3dvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix4dvEXT, 'glProgramUniformMatrix4dvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix2x3dvEXT, 'glProgramUniformMatrix2x3dvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix2x4dvEXT, 'glProgramUniformMatrix2x4dvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix3x2dvEXT, 'glProgramUniformMatrix3x2dvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix3x4dvEXT, 'glProgramUniformMatrix3x4dvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix4x2dvEXT, 'glProgramUniformMatrix4x2dvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix4x3dvEXT, 'glProgramUniformMatrix4x3dvEXT');
  
  // GL_ARB_shader_subroutine
  CheckAndLoadOpenGLproc(@glGetSubroutineUniformLocation, 'glGetSubroutineUniformLocation');
  CheckAndLoadOpenGLproc(@glGetSubroutineIndex, 'glGetSubroutineIndex');
  CheckAndLoadOpenGLproc(@glGetActiveSubroutineUniformiv, 'glGetActiveSubroutineUniformiv');
  CheckAndLoadOpenGLproc(@glGetActiveSubroutineUniformName, 'glGetActiveSubroutineUniformName');
  CheckAndLoadOpenGLproc(@glGetActiveSubroutineName, 'glGetActiveSubroutineName');
  CheckAndLoadOpenGLproc(@glUniformSubroutinesuiv, 'glUniformSubroutinesuiv');
  CheckAndLoadOpenGLproc(@glGetUniformSubroutineuiv, 'glGetUniformSubroutineuiv');
  CheckAndLoadOpenGLproc(@glGetProgramStageiv, 'glGetProgramStageiv');   
  
  // GL_ARB_draw_buffers_blend
  CheckAndLoadOpenGLproc(@glBlendEquationiARB, 'glBlendEquationiARB');
  CheckAndLoadOpenGLproc(@glBlendEquationSeparateiARB, 'glBlendEquationSeparateiARB');
  CheckAndLoadOpenGLproc(@glBlendFunciARB, 'glBlendFunciARB');
  CheckAndLoadOpenGLproc(@glBlendFuncSeparateiARB, 'glBlendFuncSeparateiARB');
  
  /////////////////////////////////////////////////////////////////////
  // 4.1 
  
  // GL_ARB_get_program_binary
  CheckAndLoadOpenGLproc(@glGetProgramBinary, 'glGetProgramBinary');
  CheckAndLoadOpenGLproc(@glProgramBinary, 'glProgramBinary');
  CheckAndLoadOpenGLproc(@glProgramParameteri, 'glProgramParameteri');
  
  // GL_ARB_viewport_array
  CheckAndLoadOpenGLproc(@glViewportArrayv, 'glViewportArrayv');
  CheckAndLoadOpenGLproc(@glViewportIndexedf, 'glViewportIndexedf');
  CheckAndLoadOpenGLproc(@glViewportIndexedfv, 'glViewportIndexedfv');
  CheckAndLoadOpenGLproc(@glScissorArrayv, 'glScissorArrayv');
  CheckAndLoadOpenGLproc(@glScissorIndexed, 'glScissorIndexed');
  CheckAndLoadOpenGLproc(@glScissorIndexedv, 'glScissorIndexedv');
  CheckAndLoadOpenGLproc(@glDepthRangeArrayv, 'glDepthRangeArrayv');
  CheckAndLoadOpenGLproc(@glDepthRangeIndexed, 'glDepthRangeIndexed');
  CheckAndLoadOpenGLproc(@glGetFloati_v, 'glGetFloati_v');
  CheckAndLoadOpenGLproc(@glGetDoublei_v, 'glGetDoublei_v');
  
  // GL_ARB_vertex_attrib_64bit
  CheckAndLoadOpenGLproc(@glVertexAttribL1d, 'glVertexAttribL1d');
  CheckAndLoadOpenGLproc(@glVertexAttribL2d, 'glVertexAttribL2d');
  CheckAndLoadOpenGLproc(@glVertexAttribL3d, 'glVertexAttribL3d');
  CheckAndLoadOpenGLproc(@glVertexAttribL4d, 'glVertexAttribL4d');
  CheckAndLoadOpenGLproc(@glVertexAttribL1dv, 'glVertexAttribL1dv');
  CheckAndLoadOpenGLproc(@glVertexAttribL2dv, 'glVertexAttribL2dv');
  CheckAndLoadOpenGLproc(@glVertexAttribL3dv, 'glVertexAttribL3dv');
  CheckAndLoadOpenGLproc(@glVertexAttribL4dv, 'glVertexAttribL4dv');
  CheckAndLoadOpenGLproc(@glVertexAttribLPointer, 'glVertexAttribLPointer');
  CheckAndLoadOpenGLproc(@glGetVertexAttribLdv, 'glGetVertexAttribLdv');
  CheckAndLoadOpenGLproc(@glVertexArrayVertexAttribLOffsetEXT, 'glVertexArrayVertexAttribLOffsetEXT');
  
  // GL_ARB_ES2_compatibility
  CheckAndLoadOpenGLproc(@glReleaseShaderCompiler, 'glReleaseShaderCompiler');
  CheckAndLoadOpenGLproc(@glShaderBinary, 'glShaderBinary');
  CheckAndLoadOpenGLproc(@glGetShaderPrecissionFormat, 'glGetShaderPrecissionFormat');
  CheckAndLoadOpenGLproc(@glDepthRangef, 'glDepthRangef');
  CheckAndLoadOpenGLproc(@glClearDepthf, 'glClearDepthf');
  
  // GL_ARB_separate_shader_objects
  CheckAndLoadOpenGLproc(@glUseProgramStages, 'glUseProgramStages');
  CheckAndLoadOpenGLproc(@glActiveShaderProgram, 'glActiveShaderProgram');
  CheckAndLoadOpenGLproc(@glCreateShaderProgramv, 'glCreateShaderProgramv');
  CheckAndLoadOpenGLproc(@glBindProgramPipeline, 'glBindProgramPipeline');
  CheckAndLoadOpenGLproc(@glDeleteProgramPipelines, 'glDeleteProgramPipelines');
  CheckAndLoadOpenGLproc(@glGenProgramPipelines, 'glGenProgramPipelines');
  CheckAndLoadOpenGLproc(@glIsProgramPipeline, 'glIsProgramPipeline');
  CheckAndLoadOpenGLproc(@glGetProgramPipelineiv, 'glGetProgramPipelineiv');
  CheckAndLoadOpenGLproc(@glProgramUniform1i, 'glProgramUniform1i');
  CheckAndLoadOpenGLproc(@glProgramUniform2i, 'glProgramUniform2i');
  CheckAndLoadOpenGLproc(@glProgramUniform3i, 'glProgramUniform3i');
  CheckAndLoadOpenGLproc(@glProgramUniform4i, 'glProgramUniform4i');
  CheckAndLoadOpenGLproc(@glProgramUniform1ui, 'glProgramUniform1ui');
  CheckAndLoadOpenGLproc(@glProgramUniform2ui, 'glProgramUniform2ui');
  CheckAndLoadOpenGLproc(@glProgramUniform3ui, 'glProgramUniform3ui');
  CheckAndLoadOpenGLproc(@glProgramUniform4ui, 'glProgramUniform4ui');
  CheckAndLoadOpenGLproc(@glProgramUniform1f, 'glProgramUniform1f');
  CheckAndLoadOpenGLproc(@glProgramUniform2f, 'glProgramUniform2f');
  CheckAndLoadOpenGLproc(@glProgramUniform3f, 'glProgramUniform3f');
  CheckAndLoadOpenGLproc(@glProgramUniform4f, 'glProgramUniform4f');
  CheckAndLoadOpenGLproc(@glProgramUniform1d, 'glProgramUniform1d');
  CheckAndLoadOpenGLproc(@glProgramUniform2d, 'glProgramUniform2d');
  CheckAndLoadOpenGLproc(@glProgramUniform3d, 'glProgramUniform3d');
  CheckAndLoadOpenGLproc(@glProgramUniform4d, 'glProgramUniform4d');
  CheckAndLoadOpenGLproc(@glProgramUniform1iv, 'glProgramUniform1iv');
  CheckAndLoadOpenGLproc(@glProgramUniform2iv, 'glProgramUniform2iv');
  CheckAndLoadOpenGLproc(@glProgramUniform3iv, 'glProgramUniform3iv');
  CheckAndLoadOpenGLproc(@glProgramUniform4iv, 'glProgramUniform4iv');
  CheckAndLoadOpenGLproc(@glProgramUniform1uiv, 'glProgramUniform1uiv');
  CheckAndLoadOpenGLproc(@glProgramUniform2uiv, 'glProgramUniform2uiv');
  CheckAndLoadOpenGLproc(@glProgramUniform3uiv, 'glProgramUniform3uiv');
  CheckAndLoadOpenGLproc(@glProgramUniform4uiv, 'glProgramUniform4uiv');
  CheckAndLoadOpenGLproc(@glProgramUniform1fv, 'glProgramUniform1fv');
  CheckAndLoadOpenGLproc(@glProgramUniform2fv, 'glProgramUniform2fv');
  CheckAndLoadOpenGLproc(@glProgramUniform3fv, 'glProgramUniform3fv');
  CheckAndLoadOpenGLproc(@glProgramUniform4fv, 'glProgramUniform4fv');
  CheckAndLoadOpenGLproc(@glProgramUniform1dv, 'glProgramUniform1dv');
  CheckAndLoadOpenGLproc(@glProgramUniform2dv, 'glProgramUniform2dv');
  CheckAndLoadOpenGLproc(@glProgramUniform3dv, 'glProgramUniform3dv');
  CheckAndLoadOpenGLproc(@glProgramUniform4dv, 'glProgramUniform4dv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix2fv, 'glProgramUniformMatrix2fv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix3fv, 'glProgramUniformMatrix3fv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix4fv, 'glProgramUniformMatrix4fv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix2dv, 'glProgramUniformMatrix2dv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix3dv, 'glProgramUniformMatrix3dv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix4dv, 'glProgramUniformMatrix4dv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix2x3fv, 'glProgramUniformMatrix2x3fv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix3x2fv, 'glProgramUniformMatrix3x2fv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix2x4fv, 'glProgramUniformMatrix2x4fv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix4x2fv, 'glProgramUniformMatrix4x2fv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix3x4fv, 'glProgramUniformMatrix3x4fv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix4x3fv, 'glProgramUniformMatrix4x3fv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix2x3dv, 'glProgramUniformMatrix2x3dv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix3x2dv, 'glProgramUniformMatrix3x2dv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix2x4dv, 'glProgramUniformMatrix2x4dv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix4x2dv, 'glProgramUniformMatrix4x2dv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix3x4dv, 'glProgramUniformMatrix3x4dv');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix4x3dv, 'glProgramUniformMatrix4x3dv');
  CheckAndLoadOpenGLproc(@glValidateProgramPipeline, 'glValidateProgramPipeline');
  CheckAndLoadOpenGLproc(@glGetProgramPipelineInfoLog, 'glGetProgramPipelineInfoLog');
  
  ////////////////////////////////////////////////////////////////////
  // 4.2
  
  // GL_ARB_shader_atomic_counters
  CheckAndLoadOpenGLproc(@glGetActiveAtomicCounterBufferiv, 'glGetActiveAtomicCounterBufferiv');
  
  // GL_ARB_shader_image_load_store
  CheckAndLoadOpenGLproc(@glBindImageTexture, 'glBindImageTexture');  
  CheckAndLoadOpenGLproc(@glMemoryBarrier, 'glMemoryBarrier');
  
  // GL_ARB_texture_storage
  CheckAndLoadOpenGLproc(@glTexStorage1D, 'glTexStorage1D');
  CheckAndLoadOpenGLproc(@glTexStorage2D, 'glTexStorage2D');
  CheckAndLoadOpenGLproc(@glTexStorage3D, 'glTexStorage3D');
  CheckAndLoadOpenGLproc(@glTextureStorage1DEXT, 'glTextureStorage1DEXT');
  CheckAndLoadOpenGLproc(@glTextureStorage2DEXT, 'glTextureStorage2DEXT');
  CheckAndLoadOpenGLproc(@glTextureStorage3DEXT, 'glTextureStorage3DEXT');
  
  // GL_ARB_transform_feedback_instanced
  CheckAndLoadOpenGLproc(@glDrawTransformFeedbackInstanced, 'glDrawTransformFeedbackInstanced');
  CheckAndLoadOpenGLproc(@glDrawTransformFeedbackStreamInstanced, 'glDrawTransformFeedbackStreamInstanced');
  
  // GL_ARB_base_instance
  CheckAndLoadOpenGLproc(@glDrawArraysInstancedBaseInstance, 'glDrawArraysInstancedBaseInstance');
  CheckAndLoadOpenGLproc(@glDrawElementsInstancedBaseInstance, 'glDrawElementsInstancedBaseInstance');
  CheckAndLoadOpenGLproc(@glDrawElementsInstancedBaseVertexBaseInstance, 'glDrawElementsInstancedBaseVertexBaseInstance');
  
  // GL_ARB_internalformat_query
  CheckAndLoadOpenGLproc(@glGetInternalformativ, 'glGetInternalformativ');
  
  ///////////////////////////////////////////////////////////////////////
  // 4.3
  
  // GL_ARB_vertex_attrib_binding
  CheckAndLoadOpenGLproc(@glBindVertexBuffer, 'glBindVertexBuffer');
  CheckAndLoadOpenGLproc(@glVertexAttribFormat, 'glVertexAttribFormat');
  CheckAndLoadOpenGLproc(@glVertexAttribIFormat, 'glVertexAttribIFormat');
  CheckAndLoadOpenGLproc(@glVertexAttribLFormat, 'glVertexAttribLFormat');
  CheckAndLoadOpenGLproc(@glVertexAttribBinding, 'glVertexAttribBinding');
  CheckAndLoadOpenGLproc(@glVertexBindingDivisor, 'glVertexBindingDivisor');
  CheckAndLoadOpenGLproc(@glVertexArrayBindVertexBufferEXT, 'glVertexArrayBindVertexBufferEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayVertexAttribFormatEXT, 'glVertexArrayVertexAttribFormatEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayVertexAttribIFormatEXT, 'glVertexArrayVertexAttribIFormatEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayVertexAttribLFormatEXT, 'glVertexArrayVertexAttribLFormatEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayVertexAttribBindingEXT, 'glVertexArrayVertexAttribBindingEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayVertexBindingDivisorEXT, 'glVertexArrayVertexBindingDivisorEXT');
  
  // GL_ARB_texture_view
  CheckAndLoadOpenGLproc(@glTextureView, 'glTextureView');
  
  // GL_ARB_internalformat_query2
  CheckAndLoadOpenGLproc(@glGetInternalformati64v, 'glGetInternalformati64v');
  
  // GL_ARB_texture_storage_multisample
  CheckAndLoadOpenGLproc(@glTexStorage2DMultisample, 'glTexStorage2DMultisample');
  CheckAndLoadOpenGLproc(@glTexStorage3DMultisample, 'glTexStorage3DMultisample');
  CheckAndLoadOpenGLproc(@glTextureStorage2DMultisampleEXT, 'glTextureStorage2DMultisampleEXT');
  CheckAndLoadOpenGLproc(@glTextureStorage3DMultisampleEXT, 'glTextureStorage3DMultisampleEXT');
  
  // GL_ARB_texture_buffer_range
  CheckAndLoadOpenGLproc(@glTexBufferRange, 'glTexBufferRange');
  CheckAndLoadOpenGLproc(@glTextureBufferRangeEXT, 'glTextureBufferRangeEXT');
  
  // GL_ARB_shader_storage_buffer_object
  CheckAndLoadOpenGLproc(@glShaderStorageBlockBinding, 'glShaderStorageBlockBinding');
  
  // GL_ARB_multi_draw_indirect
  CheckAndLoadOpenGLproc(@glMultiDrawArraysIndirect, 'glMultiDrawArraysIndirect');
  CheckAndLoadOpenGLproc(@glMultiDrawElementsIndirect, 'glMultiDrawElementsIndirect');
  
  // GL_ARB_invalidate_subdata
  CheckAndLoadOpenGLproc(@glInvalidateTexSubImage, 'glInvalidateTexSubImage');
  CheckAndLoadOpenGLproc(@glInvalidateTexImage, 'glInvalidateTexImage');
  CheckAndLoadOpenGLproc(@glInvalidateBufferSubData, 'glInvalidateBufferSubData');
  CheckAndLoadOpenGLproc(@glInvalidateBufferData, 'glInvalidateBufferData');
  CheckAndLoadOpenGLproc(@glInvalidateFramebuffer, 'glInvalidateFramebuffer');
  CheckAndLoadOpenGLproc(@glInvalidateSubFramebuffer, 'glInvalidateSubFramebuffer');
  
  // GL_ARB_copy_image
  CheckAndLoadOpenGLproc(@glCopyImageSubData, 'glCopyImageSubData');
  
  // GL_ARB_compute_shader
  CheckAndLoadOpenGLproc(@glDispatchCompute, 'glDispatchCompute');
  CheckAndLoadOpenGLproc(@glDispatchComputeIndirect, 'glDispatchComputeIndirect');
  
  // GL_ARB_clear_buffer_object
  CheckAndLoadOpenGLproc(@glClearBufferData, 'glClearBufferData');
  CheckAndLoadOpenGLproc(@glClearBufferSubData, 'glClearBufferSubData');
  CheckAndLoadOpenGLproc(@glClearNamedBufferDataEXT, 'glClearNamedBufferDataEXT');
  CheckAndLoadOpenGLproc(@glClearNamedBufferSubDataEXT, 'glClearNamedBufferSubDataEXT');
  
  // GL_ARB_framebuffer_no_attachments
  CheckAndLoadOpenGLproc(@glFramebufferParameteri, 'glFramebufferParameteri');
  CheckAndLoadOpenGLproc(@glGetFramebufferParameteriv, 'glGetFramebufferParameteriv');
  CheckAndLoadOpenGLproc(@glNamedFramebufferParameteriEXT, 'glNamedFramebufferParameteriEXT');
  CheckAndLoadOpenGLproc(@glGetNamedFramebufferParameterivEXT, 'glGetNamedFramebufferParameterivEXT');
  
  // GL_ARB_program_interface_query
  CheckAndLoadOpenGLproc(@glGetProgramInterfaceiv, 'glGetProgramInterfaceiv');
  CheckAndLoadOpenGLproc(@glGetProgramResourceIndex, 'glGetProgramResourceIndex');
  CheckAndLoadOpenGLproc(@glGetProgramResourceName, 'glGetProgramResourceName');
  CheckAndLoadOpenGLproc(@glGetProgramResourceiv, 'glGetProgramResourceiv');
  CheckAndLoadOpenGLproc(@glGetProgramResourceLocation, 'glGetProgramResourceLocation');
  CheckAndLoadOpenGLproc(@glGetProgramResourceLocationIndex, 'glGetProgramResourceLocationIndex');
  
  // GL_KHR_debug
  CheckAndLoadOpenGLproc(@glDebugMessageControl, 'glDebugMessageControl');
  CheckAndLoadOpenGLproc(@glDebugMessageInsert, 'glDebugMessageInsert');
  CheckAndLoadOpenGLproc(@glDebugMessageCallback, 'glDebugMessageCallback');
  CheckAndLoadOpenGLproc(@glGetDebugMessageLog, 'glGetDebugMessageLog');
  CheckAndLoadOpenGLproc(@glPushDebugGroup, 'glPushDebugGroup');
  CheckAndLoadOpenGLproc(@glPopDebugGroup, 'glPopDebugGroup');
  CheckAndLoadOpenGLproc(@glObjectLabel, 'glObjectLabel');
  CheckAndLoadOpenGLproc(@glGetObjectLabel, 'glGetObjectLabel');
  CheckAndLoadOpenGLproc(@glObjectPtrLabel, 'glObjectPtrLabel');
  CheckAndLoadOpenGLproc(@glGetObjectPtrLabel, 'glGetObjectPtrLabel');
  
  ////////////////////////////////////////////////////////////////////
  // 4.4
  
  // GL_ARB_clear_texture
  CheckAndLoadOpenGLproc(@glClearTexImage, 'glClearTexImage');
  CheckAndLoadOpenGLproc(@glClearTexSubImage, 'glClearTexSubImage');
  
  // GL_ARB_multi_bind
  CheckAndLoadOpenGLproc(@glBindBuffersBase, 'glBindBuffersBase');
  CheckAndLoadOpenGLproc(@glBindBuffersRange, 'glBindBuffersRange');
  CheckAndLoadOpenGLproc(@glBindTextures, 'glBindTextures');
  CheckAndLoadOpenGLproc(@glBindSamplers, 'glBindSamplers');
  CheckAndLoadOpenGLproc(@glBindImageTextures, 'glBindImageTextures');
  CheckAndLoadOpenGLproc(@glBindVertexBuffers, 'glBindVertexBuffers');
  
  // GL_ARB_buffer_storage
  CheckAndLoadOpenGLproc(@glBufferStorage, 'glBufferStorage');
  CheckAndLoadOpenGLproc(@glNamedBufferStorageEXT, 'glNamedBufferStorageEXT');
  
  /////////////////////////////////////////////////////////////////////
  // 4.5
  
  // GL_KHR_robustness
  CheckAndLoadOpenGLproc(@glGetGraphicsResetStatus, 'glGetGraphicsResetStatus');
  CheckAndLoadOpenGLproc(@glReadnPixels, 'glReadnPixels');
  CheckAndLoadOpenGLproc(@glGetnUniformfv, 'glGetnUniformfv');
  CheckAndLoadOpenGLproc(@glGetnUniformiv, 'glGetnUniformiv');
  CheckAndLoadOpenGLproc(@glGetnUniformuiv, 'glGetnUniformuiv');
  
  // GL_ARB_get_texture_sub_image
  CheckAndLoadOpenGLproc(@glGetTextureSubImage, 'glGetTextureSubImage');
  CheckAndLoadOpenGLproc(@glGetCompressedTextureSubImage, 'glGetCompressedTextureSubImage');
  
  // GL_ARB_ES3_1_compatibility
  CheckAndLoadOpenGLproc(@glMemoryBarrierByRegion, 'glMemoryBarrierByRegion');
  
  // GL_ARB_clip_control
  CheckAndLoadOpenGLproc(@glClipControl, 'glClipControl');
  
  // GL_ARB_direct_state_access
  CheckAndLoadOpenGLproc(@glCreateTransformFeedbacks, 'glCreateTransformFeedbacks');
  CheckAndLoadOpenGLproc(@glTransformFeedbackBufferBase, 'glTransformFeedbackBufferBase');
  CheckAndLoadOpenGLproc(@glTransformFeedbackBufferRange, 'glTransformFeedbackBufferRange');
  CheckAndLoadOpenGLproc(@glGetTransformFeedbackiv, 'glGetTransformFeedbackiv');
  CheckAndLoadOpenGLproc(@glGetTransformFeedbacki_v, 'glGetTransformFeedbacki_v');
  CheckAndLoadOpenGLproc(@glGetTransformFeedbacki64_v, 'glGetTransformFeedbacki64_v');
  CheckAndLoadOpenGLproc(@glCreateBuffers, 'glCreateBuffers');
  CheckAndLoadOpenGLproc(@glNamedBufferStorage, 'glNamedBufferStorage');
  CheckAndLoadOpenGLproc(@glNamedBufferData, 'glNamedBufferData');
  CheckAndLoadOpenGLproc(@glNamedBufferSubData, 'glNamedBufferSubData');
  CheckAndLoadOpenGLproc(@glCopyNamedBufferSubData, 'glCopyNamedBufferSubData');
  CheckAndLoadOpenGLproc(@glClearNamedBufferData, 'glClearNamedBufferData');
  CheckAndLoadOpenGLproc(@glClearNamedBufferSubData, 'glClearNamedBufferSubData');
  CheckAndLoadOpenGLproc(@glMapNamedBuffer, 'glMapNamedBuffer');
  CheckAndLoadOpenGLproc(@glMapNamedBufferRange, 'glMapNamedBufferRange');
  CheckAndLoadOpenGLproc(@glUnmapNamedBuffer, 'glUnmapNamedBuffer');
  CheckAndLoadOpenGLproc(@glFlushMappedNamedBufferRange, 'glFlushMappedNamedBufferRange');
  CheckAndLoadOpenGLproc(@glGetNamedBufferParameteriv, 'glGetNamedBufferParameteriv');
  CheckAndLoadOpenGLproc(@glGetNamedBufferParameteri64v, 'glGetNamedBufferParameteri64v');
  CheckAndLoadOpenGLproc(@glGetNamedBufferPointerv, 'glGetNamedBufferPointerv');
  CheckAndLoadOpenGLproc(@glGetNamedBufferSubData, 'glGetNamedBufferSubData');
  CheckAndLoadOpenGLproc(@glCreateFramebuffers, 'glCreateFramebuffers');
  CheckAndLoadOpenGLproc(@glNamedFramebufferRenderbuffer, 'glNamedFramebufferRenderbuffer');
  CheckAndLoadOpenGLproc(@glNamedFramebufferParameteri, 'glNamedFramebufferParameteri');
  CheckAndLoadOpenGLproc(@glNamedFramebufferTexture, 'glNamedFramebufferTexture');
  CheckAndLoadOpenGLproc(@glNamedFramebufferTextureLayer, 'glNamedFramebufferTextureLayer');
  CheckAndLoadOpenGLproc(@glNamedFramebufferDrawBuffer, 'glNamedFramebufferDrawBuffer');
  CheckAndLoadOpenGLproc(@glNamedFramebufferDrawBuffers, 'glNamedFramebufferDrawBuffers');
  CheckAndLoadOpenGLproc(@glNamedFramebufferReadBuffer, 'glNamedFramebufferReadBuffer');
  CheckAndLoadOpenGLproc(@glInvalidateNamedFramebufferData, 'glInvalidateNamedFramebufferData');
  CheckAndLoadOpenGLproc(@glInvalidateNamedFramebufferSubData, 'glInvalidateNamedFramebufferSubData');
  CheckAndLoadOpenGLproc(@glClearNamedFramebufferiv, 'glClearNamedFramebufferiv');
  CheckAndLoadOpenGLproc(@glClearNamedFramebufferuiv, 'glClearNamedFramebufferuiv');
  CheckAndLoadOpenGLproc(@glClearNamedFramebufferfv, 'glClearNamedFramebufferfv');
  CheckAndLoadOpenGLproc(@glClearNamedFramebufferfi, 'glClearNamedFramebufferfi');
  CheckAndLoadOpenGLproc(@glBlitNamedFramebuffer, 'glBlitNamedFramebuffer');
  CheckAndLoadOpenGLproc(@glCheckNamedFramebufferStatus, 'glCheckNamedFramebufferStatus');
  CheckAndLoadOpenGLproc(@glGetNamedFramebufferParameteriv, 'glGetNamedFramebufferParameteriv');
  CheckAndLoadOpenGLproc(@glGetNamedFramebufferAttachmentParameteriv, 'glGetNamedFramebufferAttachmentParameteriv');
  CheckAndLoadOpenGLproc(@glCreateRenderbuffers, 'glCreateRenderbuffers');
  CheckAndLoadOpenGLproc(@glNamedRenderbufferStorage, 'glNamedRenderbufferStorage');
  CheckAndLoadOpenGLproc(@glNamedRenderbufferStorageMultisample, 'glNamedRenderbufferStorageMultisample');
  CheckAndLoadOpenGLproc(@glGetNamedRenderbufferParameteriv, 'glGetNamedRenderbufferParameteriv');
  CheckAndLoadOpenGLproc(@glCreateTextures, 'glCreateTextures');
  CheckAndLoadOpenGLproc(@glTextureBuffer, 'glTextureBuffer');
  CheckAndLoadOpenGLproc(@glTextureBufferRange, 'glTextureBufferRange');
  CheckAndLoadOpenGLproc(@glTextureStorage1D, 'glTextureStorage1D');
  CheckAndLoadOpenGLproc(@glTextureStorage2D, 'glTextureStorage2D');
  CheckAndLoadOpenGLproc(@glTextureStorage3D, 'glTextureStorage3D');
  CheckAndLoadOpenGLproc(@glTextureStorage2DMultisample, 'glTextureStorage2DMultisample');
  CheckAndLoadOpenGLproc(@glTextureStorage3DMultisample, 'glTextureStorage3DMultisample');
  CheckAndLoadOpenGLproc(@glTextureSubImage1D, 'glTextureSubImage1D');
  CheckAndLoadOpenGLproc(@glTextureSubImage2D, 'glTextureSubImage2D');
  CheckAndLoadOpenGLproc(@glTextureSubImage3D, 'glTextureSubImage3D');
  CheckAndLoadOpenGLproc(@glCompressedTextureSubImage1D, 'glCompressedTextureSubImage1D');
  CheckAndLoadOpenGLproc(@glCompressedTextureSubImage2D, 'glCompressedTextureSubImage2D');
  CheckAndLoadOpenGLproc(@glCompressedTextureSubImage3D, 'glCompressedTextureSubImage3D');
  CheckAndLoadOpenGLproc(@glCopyTextureSubImage1D, 'glCopyTextureSubImage1D');
  CheckAndLoadOpenGLproc(@glCopyTextureSubImage2D, 'glCopyTextureSubImage2D');
  CheckAndLoadOpenGLproc(@glCopyTextureSubImage3D, 'glCopyTextureSubImage3D');
  CheckAndLoadOpenGLproc(@glTextureParameterf, 'glTextureParameterf');
  CheckAndLoadOpenGLproc(@glTextureParameterfv, 'glTextureParameterfv');
  CheckAndLoadOpenGLproc(@glTextureParameteri, 'glTextureParameteri');
  CheckAndLoadOpenGLproc(@glTextureParameterIiv, 'glTextureParameterIiv');
  CheckAndLoadOpenGLproc(@glTextureParameterIuiv, 'glTextureParameterIuiv');
  CheckAndLoadOpenGLproc(@glTextureParameteriv, 'glTextureParameteriv');
  CheckAndLoadOpenGLproc(@glGenerateTextureMipmap, 'glGenerateTextureMipmap');
  CheckAndLoadOpenGLproc(@glBindTextureUnit, 'glBindTextureUnit');
  CheckAndLoadOpenGLproc(@glGetTextureImage, 'glGetTextureImage');
  CheckAndLoadOpenGLproc(@glGetCompressedTextureImage, 'glGetCompressedTextureImage');
  CheckAndLoadOpenGLproc(@glGetTextureLevelParameterfv, 'glGetTextureLevelParameterfv');
  CheckAndLoadOpenGLproc(@glGetTextureLevelParameteriv, 'glGetTextureLevelParameteriv');
  CheckAndLoadOpenGLproc(@glGetTextureParameterfv, 'glGetTextureParameterfv');
  CheckAndLoadOpenGLproc(@glGetTextureParameterIiv, 'glGetTextureParameterIiv');
  CheckAndLoadOpenGLproc(@glGetTextureParameterIuiv, 'glGetTextureParameterIuiv');
  CheckAndLoadOpenGLproc(@glGetTextureParameteriv, 'glGetTextureParameteriv');
  CheckAndLoadOpenGLproc(@glCreateVertexArrays, 'glCreateVertexArrays');
  CheckAndLoadOpenGLproc(@glDisableVertexArrayAttrib, 'glDisableVertexArrayAttrib');
  CheckAndLoadOpenGLproc(@glEnableVertexArrayAttrib, 'glEnableVertexArrayAttrib');
  CheckAndLoadOpenGLproc(@glVertexArrayElementBuffer, 'glVertexArrayElementBuffer');
  CheckAndLoadOpenGLproc(@glVertexArrayVertexBuffer, 'glVertexArrayVertexBuffer');
  CheckAndLoadOpenGLproc(@glVertexArrayVertexBuffers, 'glVertexArrayVertexBuffers');
  CheckAndLoadOpenGLproc(@glVertexArrayAttribFormat, 'glVertexArrayAttribFormat');
  CheckAndLoadOpenGLproc(@glVertexArrayAttribIFormat, 'glVertexArrayAttribIFormat');
  CheckAndLoadOpenGLproc(@glVertexArrayAttribLFormat, 'glVertexArrayAttribLFormat');
  CheckAndLoadOpenGLproc(@glVertexArrayAttribBinding, 'glVertexArrayAttribBinding');
  CheckAndLoadOpenGLproc(@glVertexArrayBindingDivisor, 'glVertexArrayBindingDivisor');
  CheckAndLoadOpenGLproc(@glGetVertexArrayiv, 'glGetVertexArrayiv');
  CheckAndLoadOpenGLproc(@glGetVertexArrayIndexediv, 'glGetVertexArrayIndexediv');
  CheckAndLoadOpenGLproc(@glGetVertexArrayIndexed64iv, 'glGetVertexArrayIndexed64iv');
  CheckAndLoadOpenGLproc(@glCreateSamplers, 'glCreateSamplers');
  CheckAndLoadOpenGLproc(@glCreateProgramPipelines, 'glCreateProgramPipelines');
  CheckAndLoadOpenGLproc(@glCreateQueries, 'glCreateQueries');
  CheckAndLoadOpenGLproc(@glGetQueryBufferObjectiv, 'glGetQueryBufferObjectiv');
  CheckAndLoadOpenGLproc(@glGetQueryBufferObjectuiv, 'glGetQueryBufferObjectuiv');
  CheckAndLoadOpenGLproc(@glGetQueryBufferObjecti64v, 'glGetQueryBufferObjecti64v');
  CheckAndLoadOpenGLproc(@glGetQueryBufferObjectui64v, 'glGetQueryBufferObjectui64v');
  
  ///////////////////////////////////////////////////////////////////
  // 4.6
  
  // GL_ARB_polygon_offset_clamp
  CheckAndLoadOpenGLproc(@glPolygonOffsetClamp, 'glPolygonOffsetClamp');
  
  // GL_ARB_gl_spirv
  CheckAndLoadOpenGLproc(@glSpecializeShaderARB, 'glSpecializeShaderARB');
  
  // GL_ARB_indirect_parameters
  CheckAndLoadOpenGLproc(@glMultiDrawArraysIndirectCountARB, 'glMultiDrawArraysIndirectCountARB');
  CheckAndLoadOpenGLproc(@glMultiDrawElementsIndirectCountARB, 'glMultiDrawElementsIndirectCountARB');
  
  //////////////////////////////////////////////////////////////////
  // Another ARB & EXT
  
  // GL_NV_texture_barrier
  CheckAndLoadOpenGLproc(@glTextureBarrierNV, 'glTextureBarrierNV');
  
  // GL_EXT_direct_state_access
  CheckAndLoadOpenGLproc(@glClientAttribDefaultEXT, 'glClientAttribDefaultEXT'); 
  CheckAndLoadOpenGLproc(@glPushClientAttribDefaultEXT, 'glPushClientAttribDefaultEXT');
  CheckAndLoadOpenGLproc(@glMatrixLoadfEXT, 'glMatrixLoadfEXT');
  CheckAndLoadOpenGLproc(@glMatrixLoaddEXT, 'glMatrixLoaddEXT');
  CheckAndLoadOpenGLproc(@glMatrixMultfEXT, 'glMatrixMultfEXT');
  CheckAndLoadOpenGLproc(@glMatrixMultdEXT, 'glMatrixMultdEXT');
  CheckAndLoadOpenGLproc(@glMatrixLoadIdentityEXT, 'glMatrixLoadIdentityEXT');
  CheckAndLoadOpenGLproc(@glMatrixRotatefEXT, 'glMatrixRotatefEXT');
  CheckAndLoadOpenGLproc(@glMatrixRotatedEXT, 'glMatrixRotatedEXT');
  CheckAndLoadOpenGLproc(@glMatrixScalefEXT, 'glMatrixScalefEXT');
  CheckAndLoadOpenGLproc(@glMatrixScaledEXT, 'glMatrixScaledEXT');
  CheckAndLoadOpenGLproc(@glMatrixTranslatefEXT, 'glMatrixTranslatefEXT');
  CheckAndLoadOpenGLproc(@glMatrixTranslatedEXT, 'glMatrixTranslatedEXT');
  CheckAndLoadOpenGLproc(@glMatrixOrthoEXT, 'glMatrixOrthoEXT');
  CheckAndLoadOpenGLproc(@glMatrixFrustumEXT, 'glMatrixFrustumEXT');
  CheckAndLoadOpenGLproc(@glMatrixPushEXT, 'glMatrixPushEXT');
  CheckAndLoadOpenGLproc(@glMatrixPopEXT, 'glMatrixPopEXT');
  CheckAndLoadOpenGLproc(@glTextureParameteriEXT, 'glTextureParameteriEXT');
  CheckAndLoadOpenGLproc(@glTextureParameterivEXT, 'glTextureParameterivEXT');
  CheckAndLoadOpenGLproc(@glTextureParameterfEXT, 'glTextureParameterfEXT');
  CheckAndLoadOpenGLproc(@glTextureParameterfvEXT, 'glTextureParameterfvEXT');
  CheckAndLoadOpenGLproc(@glTextureImage1DEXT, 'glTextureImage1DEXT');
  CheckAndLoadOpenGLproc(@glTextureImage2DEXT, 'glTextureImage2DEXT');
  CheckAndLoadOpenGLproc(@glTextureSubImage1DEXT, 'glTextureSubImage1DEXT');
  CheckAndLoadOpenGLproc(@glTextureSubImage2DEXT, 'glTextureSubImage2DEXT');
  CheckAndLoadOpenGLproc(@glCopyTextureImage1DEXT, 'glCopyTextureImage1DEXT');
  CheckAndLoadOpenGLproc(@glCopyTextureImage2DEXT, 'glCopyTextureImage2DEXT');
  CheckAndLoadOpenGLproc(@glCopyTextureSubImage1DEXT, 'glCopyTextureSubImage1DEXT');
  CheckAndLoadOpenGLproc(@glCopyTextureSubImage2DEXT, 'glCopyTextureSubImage2DEXT');
  CheckAndLoadOpenGLproc(@glGetTextureImageEXT, 'glGetTextureImageEXT');
  CheckAndLoadOpenGLproc(@glGetTextureParameterfvEXT, 'glGetTextureParameterfvEXT');
  CheckAndLoadOpenGLproc(@glGetTextureParameterivEXT, 'glGetTextureParameterivEXT');
  CheckAndLoadOpenGLproc(@glGetTextureLevelParameterfvEXT, 'glGetTextureLevelParameterfvEXT');
  CheckAndLoadOpenGLproc(@glGetTextureLevelParameterivEXT, 'glGetTextureLevelParameterivEXT');
  CheckAndLoadOpenGLproc(@glTextureImage3DEXT, 'glTextureImage3DEXT');
  CheckAndLoadOpenGLproc(@glTextureSubImage3DEXT, 'glTextureSubImage3DEXT');
  CheckAndLoadOpenGLproc(@glTextureSubImage3DEXT, 'glTextureSubImage3DEXT');
  CheckAndLoadOpenGLproc(@glBindMultiTextureEXT, 'glBindMultiTextureEXT');
  CheckAndLoadOpenGLproc(@glMultiTexCoordPointerEXT, 'glMultiTexCoordPointerEXT');
  CheckAndLoadOpenGLproc(@glMultiTexEnvfEXT, 'glMultiTexEnvfEXT');
  CheckAndLoadOpenGLproc(@glMultiTexEnvfvEXT, 'glMultiTexEnvfvEXT');
  CheckAndLoadOpenGLproc(@glMultiTexEnviEXT, 'glMultiTexEnviEXT');
  CheckAndLoadOpenGLproc(@glMultiTexEnvivEXT, 'glMultiTexEnvivEXT');
  CheckAndLoadOpenGLproc(@glMultiTexGendEXT, 'glMultiTexGendEXT');
  CheckAndLoadOpenGLproc(@glMultiTexGendvEXT, 'glMultiTexGendvEXT');
  CheckAndLoadOpenGLproc(@glMultiTexGenfEXT, 'glMultiTexGenfEXT');
  CheckAndLoadOpenGLproc(@glMultiTexGenfvEXT, 'glMultiTexGenfvEXT');
  CheckAndLoadOpenGLproc(@glMultiTexGeniEXT, 'glMultiTexGeniEXT');
  CheckAndLoadOpenGLproc(@glMultiTexGenivEXT, 'glMultiTexGenivEXT');
  CheckAndLoadOpenGLproc(@glGetMultiTexEnvfvEXT, 'glGetMultiTexEnvfvEXT');
  CheckAndLoadOpenGLproc(@glGetMultiTexEnvivEXT, 'glGetMultiTexEnvivEXT');
  CheckAndLoadOpenGLproc(@glGetMultiTexGendvEXT, 'glGetMultiTexGendvEXT');
  CheckAndLoadOpenGLproc(@glGetMultiTexGenfvEXT, 'glGetMultiTexGenfvEXT');
  CheckAndLoadOpenGLproc(@glGetMultiTexGenivEXT, 'glGetMultiTexGenivEXT');
  CheckAndLoadOpenGLproc(@glMultiTexParameteriEXT, 'glMultiTexParameteriEXT');
  CheckAndLoadOpenGLproc(@glMultiTexParameterivEXT, 'glMultiTexParameterivEXT');
  CheckAndLoadOpenGLproc(@glMultiTexParameterfEXT, 'glMultiTexParameterfEXT');
  CheckAndLoadOpenGLproc(@glMultiTexParameterfvEXT, 'glMultiTexParameterfvEXT');
  CheckAndLoadOpenGLproc(@glMultiTexImage1DEXT, 'glMultiTexImage1DEXT');
  CheckAndLoadOpenGLproc(@glMultiTexImage2DEXT, 'glMultiTexImage2DEXT');
  CheckAndLoadOpenGLproc(@glMultiTexSubImage1DEXT, 'glMultiTexSubImage1DEXT');
  CheckAndLoadOpenGLproc(@glMultiTexSubImage2DEXT, 'glMultiTexSubImage2DEXT');
  CheckAndLoadOpenGLproc(@glCopyMultiTexImage1DEXT, 'glCopyMultiTexImage1DEXT');
  CheckAndLoadOpenGLproc(@glCopyMultiTexImage2DEXT, 'glCopyMultiTexImage2DEXT');
  CheckAndLoadOpenGLproc(@glCopyMultiTexSubImage1DEXT, 'glCopyMultiTexSubImage1DEXT');
  CheckAndLoadOpenGLproc(@glCopyMultiTexSubImage2DEXT, 'glCopyMultiTexSubImage2DEXT');
  CheckAndLoadOpenGLproc(@glGetMultiTexImageEXT, 'glGetMultiTexImageEXT');
  CheckAndLoadOpenGLproc(@glGetMultiTexParameterfvEXT, 'glGetMultiTexParameterfvEXT');
  CheckAndLoadOpenGLproc(@glGetMultiTexParameterivEXT, 'glGetMultiTexParameterivEXT');
  CheckAndLoadOpenGLproc(@glGetMultiTexLevelParameterfvEXT, 'glGetMultiTexLevelParameterfvEXT');
  CheckAndLoadOpenGLproc(@glGetMultiTexLevelParameterivEXT, 'glGetMultiTexLevelParameterivEXT');
  CheckAndLoadOpenGLproc(@glMultiTexImage3DEXT, 'glMultiTexImage3DEXT');
  CheckAndLoadOpenGLproc(@glMultiTexSubImage3DEXT, 'glMultiTexSubImage3DEXT');
  CheckAndLoadOpenGLproc(@glCopyMultiTexSubImage3DEXT, 'glCopyMultiTexSubImage3DEXT');
  CheckAndLoadOpenGLproc(@glEnableClientStateIndexedEXT, 'glEnableClientStateIndexedEXT');
  CheckAndLoadOpenGLproc(@glDisableClientStateIndexedEXT, 'glDisableClientStateIndexedEXT');
  CheckAndLoadOpenGLproc(@glEnableClientStateiEXT, 'glEnableClientStateiEXT');
  CheckAndLoadOpenGLproc(@glDisableClientStateiEXT, 'glDisableClientStateiEXT');
  CheckAndLoadOpenGLproc(@glGetFloatIndexedvEXT, 'glGetFloatIndexedvEXT');
  CheckAndLoadOpenGLproc(@glGetDoubleIndexedvEXT, 'glGetDoubleIndexedvEXT');
  CheckAndLoadOpenGLproc(@glGetPointerIndexedvEXT, 'glGetPointerIndexedvEXT');
  CheckAndLoadOpenGLproc(@glGetFloati_vEXT, 'glGetFloati_vEXT'); 
  CheckAndLoadOpenGLproc(@glGetDoublei_vEXT, 'glGetDoublei_vEXT');
  CheckAndLoadOpenGLproc(@glGetPointeri_vEXT, 'glGetPointeri_vEXT');
  CheckAndLoadOpenGLproc(@glEnableIndexedEXT, 'glEnableIndexedEXT');
  CheckAndLoadOpenGLproc(@glDisableIndexedEXT, 'glDisableIndexedEXT');
  CheckAndLoadOpenGLproc(@glIsEnabledIndexedEXT, 'glIsEnabledIndexedEXT');
  CheckAndLoadOpenGLproc(@glGetIntegerIndexedvEXT, 'glGetIntegerIndexedvEXT');
  CheckAndLoadOpenGLproc(@glGetBooleanIndexedvEXT, 'glGetBooleanIndexedvEXT');
  CheckAndLoadOpenGLproc(@glNamedProgramStringEXT, 'glNamedProgramStringEXT');
  CheckAndLoadOpenGLproc(@glNamedProgramLocalParameter4dEXT, 'glNamedProgramLocalParameter4dEXT');
  CheckAndLoadOpenGLproc(@glNamedProgramLocalParameter4dvEXT, 'glNamedProgramLocalParameter4dvEXT');
  CheckAndLoadOpenGLproc(@glNamedProgramLocalParameter4fEXT, 'glNamedProgramLocalParameter4fEXT');
  CheckAndLoadOpenGLproc(@glNamedProgramLocalParameter4fvEXT, 'glNamedProgramLocalParameter4fvEXT');
  CheckAndLoadOpenGLproc(@glGetNamedProgramLocalParameterdvEXT, 'glGetNamedProgramLocalParameterdvEXT');
  CheckAndLoadOpenGLproc(@glGetNamedProgramLocalParameterfvEXT, 'glGetNamedProgramLocalParameterfvEXT');
  CheckAndLoadOpenGLproc(@glGetNamedProgramivEXT, 'glGetNamedProgramivEXT');
  CheckAndLoadOpenGLproc(@glGetNamedProgramStringEXT, 'glGetNamedProgramStringEXT');
  CheckAndLoadOpenGLproc(@glCompressedTextureImage3DEXT, 'glCompressedTextureImage3DEXT');
  CheckAndLoadOpenGLproc(@glCompressedTextureImage2DEXT, 'glCompressedTextureImage2DEXT');
  CheckAndLoadOpenGLproc(@glCompressedTextureImage1DEXT, 'glCompressedTextureImage1DEXT');
  CheckAndLoadOpenGLproc(@glCompressedTextureSubImage3DEXT, 'glCompressedTextureSubImage3DEXT');
  CheckAndLoadOpenGLproc(@glCompressedTextureSubImage2DEXT, 'glCompressedTextureSubImage2DEXT');
  CheckAndLoadOpenGLproc(@glCompressedTextureSubImage1DEXT, 'glCompressedTextureSubImage1DEXT');
  CheckAndLoadOpenGLproc(@glGetCompressedTextureImageEXT, 'glGetCompressedTextureImageEXT');
  CheckAndLoadOpenGLproc(@glCompressedMultiTexImage3DEXT, 'glCompressedMultiTexImage3DEXT');
  CheckAndLoadOpenGLproc(@glCompressedMultiTexImage2DEXT, 'glCompressedMultiTexImage2DEXT');
  CheckAndLoadOpenGLproc(@glCompressedMultiTexImage1DEXT, 'glCompressedMultiTexImage1DEXT');
  CheckAndLoadOpenGLproc(@glCompressedMultiTexSubImage3DEXT, 'glCompressedMultiTexSubImage3DEXT');
  CheckAndLoadOpenGLproc(@glCompressedMultiTexSubImage2DEXT, 'glCompressedMultiTexSubImage2DEXT');
  CheckAndLoadOpenGLproc(@glCompressedMultiTexSubImage1DEXT, 'glCompressedMultiTexSubImage1DEXT');
  CheckAndLoadOpenGLproc(@glGetCompressedMultiTexImageEXT, 'glGetCompressedMultiTexImageEXT');
  CheckAndLoadOpenGLproc(@glMatrixLoadTransposefEXT, 'glMatrixLoadTransposefEXT');
  CheckAndLoadOpenGLproc(@glMatrixLoadTransposedEXT, 'glMatrixLoadTransposedEXT');
  CheckAndLoadOpenGLproc(@glMatrixMultTransposefEXT, 'glMatrixMultTransposefEXT');
  CheckAndLoadOpenGLproc(@glMatrixMultTransposedEXT, 'glMatrixMultTransposedEXT');
  CheckAndLoadOpenGLproc(@glNamedBufferDataEXT, 'glNamedBufferDataEXT');
  CheckAndLoadOpenGLproc(@glNamedBufferSubDataEXT, 'glNamedBufferSubDataEXT');
  CheckAndLoadOpenGLproc(@glMapNamedBufferEXT, 'glMapNamedBufferEXT');
  CheckAndLoadOpenGLproc(@glUnmapNamedBufferEXT, 'glUnmapNamedBufferEXT');
  CheckAndLoadOpenGLproc(@glGetNamedBufferParameterivEXT, 'glGetNamedBufferParameterivEXT');
  CheckAndLoadOpenGLproc(@glGetNamedBufferPointervEXT, 'glGetNamedBufferPointervEXT');
  CheckAndLoadOpenGLproc(@glGetNamedBufferSubDataEXT, 'glGetNamedBufferSubDataEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform1fEXT, 'glProgramUniform1fEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform2fEXT, 'glProgramUniform2fEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform3fEXT, 'glProgramUniform3fEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform4fEXT, 'glProgramUniform4fEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform1iEXT, 'glProgramUniform1iEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform2iEXT, 'glProgramUniform2iEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform3iEXT, 'glProgramUniform3iEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform4iEXT, 'glProgramUniform4iEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform1fvEXT, 'glProgramUniform1fvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform2fvEXT, 'glProgramUniform2fvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform3fvEXT, 'glProgramUniform3fvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform4fvEXT, 'glProgramUniform4fvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform1ivEXT, 'glProgramUniform1ivEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform2ivEXT, 'glProgramUniform2ivEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform3ivEXT, 'glProgramUniform3ivEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform4ivEXT, 'glProgramUniform4ivEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix2fvEXT, 'glProgramUniformMatrix2fvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix3fvEXT, 'glProgramUniformMatrix3fvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix4fvEXT, 'glProgramUniformMatrix4fvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix2x3fvEXT, 'glProgramUniformMatrix2x3fvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix3x2fvEXT, 'glProgramUniformMatrix3x2fvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix2x4fvEXT, 'glProgramUniformMatrix2x4fvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix4x2fvEXT, 'glProgramUniformMatrix4x2fvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix3x4fvEXT, 'glProgramUniformMatrix3x4fvEXT');
  CheckAndLoadOpenGLproc(@glProgramUniformMatrix4x3fvEXT, 'glProgramUniformMatrix4x3fvEXT');
  CheckAndLoadOpenGLproc(@glTextureBufferEXT, 'glTextureBufferEXT');
  CheckAndLoadOpenGLproc(@glMultiTexBufferEXT, 'glMultiTexBufferEXT');
  CheckAndLoadOpenGLproc(@glTextureParameterIivEXT, 'glTextureParameterIivEXT');
  CheckAndLoadOpenGLproc(@glTextureParameterIuivEXT, 'glTextureParameterIuivEXT');
  CheckAndLoadOpenGLproc(@glGetTextureParameterIivEXT, 'glGetTextureParameterIivEXT');
  CheckAndLoadOpenGLproc(@glGetTextureParameterIuivEXT, 'glGetTextureParameterIuivEXT');
  CheckAndLoadOpenGLproc(@glMultiTexParameterIivEXT, 'glMultiTexParameterIivEXT');
  CheckAndLoadOpenGLproc(@glMultiTexParameterIuivEXT, 'glMultiTexParameterIuivEXT');
  CheckAndLoadOpenGLproc(@glGetMultiTexParameterIivEXT, 'glGetMultiTexParameterIivEXT');
  CheckAndLoadOpenGLproc(@glGetMultiTexParameterIuivEXT, 'glGetMultiTexParameterIuivEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform1uiEXT, 'glProgramUniform1uiEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform2uiEXT, 'glProgramUniform2uiEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform3uiEXT, 'glProgramUniform3uiEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform4uiEXT, 'glProgramUniform4uiEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform1uivEXT, 'glProgramUniform1uivEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform2uivEXT, 'glProgramUniform2uivEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform3uivEXT, 'glProgramUniform3uivEXT');
  CheckAndLoadOpenGLproc(@glProgramUniform4uivEXT, 'glProgramUniform4uivEXT');
  CheckAndLoadOpenGLproc(@glNamedProgramLocalParameters4fvEXT, 'glNamedProgramLocalParameters4fvEXT');
  CheckAndLoadOpenGLproc(@glNamedProgramLocalParameterI4iEXT, 'glNamedProgramLocalParameterI4iEXT');
  CheckAndLoadOpenGLproc(@glNamedProgramLocalParameterI4ivEXT, 'glNamedProgramLocalParameterI4ivEXT');
  CheckAndLoadOpenGLproc(@glNamedProgramLocalParametersI4ivEXT, 'glNamedProgramLocalParametersI4ivEXT');
  CheckAndLoadOpenGLproc(@glNamedProgramLocalParameterI4uiEXT, 'glNamedProgramLocalParameterI4uiEXT');
  CheckAndLoadOpenGLproc(@glNamedProgramLocalParameterI4uivEXT, 'glNamedProgramLocalParameterI4uivEXT');
  CheckAndLoadOpenGLproc(@glNamedProgramLocalParametersI4uivEXT, 'glNamedProgramLocalParametersI4uivEXT');
  CheckAndLoadOpenGLproc(@glGetNamedProgramLocalParameterIivEXT, 'glGetNamedProgramLocalParameterIivEXT');
  CheckAndLoadOpenGLproc(@glGetNamedProgramLocalParameterIuivEXT, 'glGetNamedProgramLocalParameterIuivEXT');
  CheckAndLoadOpenGLproc(@glNamedRenderbufferStorageEXT, 'glNamedRenderbufferStorageEXT');
  CheckAndLoadOpenGLproc(@glGetNamedRenderbufferParameterivEXT, 'glGetNamedRenderbufferParameterivEXT');
  CheckAndLoadOpenGLproc(@glNamedRenderbufferStorageMultisampleEXT, 'glNamedRenderbufferStorageMultisampleEXT');
  CheckAndLoadOpenGLproc(@glNamedRenderbufferStorageMultisampleCoverageEXT, 'glNamedRenderbufferStorageMultisampleCoverageEXT');
  CheckAndLoadOpenGLproc(@glCheckNamedFramebufferStatusEXT, 'glCheckNamedFramebufferStatusEXT');
  CheckAndLoadOpenGLproc(@glNamedFramebufferTexture1DEXT, 'glNamedFramebufferTexture1DEXT');
  CheckAndLoadOpenGLproc(@glNamedFramebufferTexture2DEXT, 'glNamedFramebufferTexture2DEXT');
  CheckAndLoadOpenGLproc(@glNamedFramebufferTexture3DEXT, 'glNamedFramebufferTexture3DEXT');
  CheckAndLoadOpenGLproc(@glNamedFramebufferRenderbufferEXT, 'glNamedFramebufferRenderbufferEXT');
  CheckAndLoadOpenGLproc(@glGetNamedFramebufferAttachmentParameterivEXT, 'glGetNamedFramebufferAttachmentParameterivEXT');
  CheckAndLoadOpenGLproc(@glGenerateTextureMipmapEXT, 'glGenerateTextureMipmapEXT');
  CheckAndLoadOpenGLproc(@glGenerateMultiTexMipmapEXT, 'glGenerateMultiTexMipmapEXT');
  CheckAndLoadOpenGLproc(@glFramebufferDrawBufferEXT, 'glFramebufferDrawBufferEXT');
  CheckAndLoadOpenGLproc(@glFramebufferDrawBuffersEXT, 'glFramebufferDrawBuffersEXT');
  CheckAndLoadOpenGLproc(@glFramebufferReadBufferEXT, 'glFramebufferReadBufferEXT');
  CheckAndLoadOpenGLproc(@glGetFramebufferParameterivEXT, 'glGetFramebufferParameterivEXT');
  CheckAndLoadOpenGLproc(@glNamedCopyBufferSubDataEXT, 'glNamedCopyBufferSubDataEXT');
  CheckAndLoadOpenGLproc(@glNamedFramebufferTextureEXT, 'glNamedFramebufferTextureEXT');
  CheckAndLoadOpenGLproc(@glNamedFramebufferTextureLayerEXT, 'glNamedFramebufferTextureLayerEXT');
  CheckAndLoadOpenGLproc(@glNamedFramebufferTextureFaceEXT, 'glNamedFramebufferTextureFaceEXT');
  CheckAndLoadOpenGLproc(@glTextureRenderbufferEXT, 'glTextureRenderbufferEXT');
  CheckAndLoadOpenGLproc(@glMultiTexRenderbufferEXT, 'glMultiTexRenderbufferEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayVertexOffsetEXT, 'glVertexArrayVertexOffsetEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayColorOffsetEXT, 'glVertexArrayColorOffsetEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayEdgeFlagOffsetEXT, 'glVertexArrayEdgeFlagOffsetEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayIndexOffsetEXT, 'glVertexArrayIndexOffsetEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayNormalOffsetEXT, 'glVertexArrayNormalOffsetEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayTexCoordOffsetEXT, 'glVertexArrayTexCoordOffsetEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayMultiTexCoordOffsetEXT, 'glVertexArrayMultiTexCoordOffsetEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayFogCoordOffsetEXT, 'glVertexArrayFogCoordOffsetEXT');
  CheckAndLoadOpenGLproc(@glVertexArraySecondaryColorOffsetEXT, 'glVertexArraySecondaryColorOffsetEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayVertexAttribOffsetEXT, 'glVertexArrayVertexAttribOffsetEXT');
  CheckAndLoadOpenGLproc(@glVertexArrayVertexAttribIOffsetEXT, 'glVertexArrayVertexAttribIOffsetEXT');
  CheckAndLoadOpenGLproc(@glEnableVertexArrayEXT, 'glEnableVertexArrayEXT');
  CheckAndLoadOpenGLproc(@glDisableVertexArrayEXT, 'glDisableVertexArrayEXT');
  CheckAndLoadOpenGLproc(@glEnableVertexArrayAttribEXT, 'glEnableVertexArrayAttribEXT');
  CheckAndLoadOpenGLproc(@glDisableVertexArrayAttribEXT, 'glDisableVertexArrayAttribEXT');
  CheckAndLoadOpenGLproc(@glGetVertexArrayIntegervEXT, 'glGetVertexArrayIntegervEXT');
  CheckAndLoadOpenGLproc(@glGetVertexArrayPointervEXT, 'glGetVertexArrayPointervEXT');
  CheckAndLoadOpenGLproc(@glGetVertexArrayIntegeri_vEXT, 'glGetVertexArrayIntegeri_vEXT');
  CheckAndLoadOpenGLproc(@glGetVertexArrayPointeri_vEXT, 'glGetVertexArrayPointeri_vEXT');
  CheckAndLoadOpenGLproc(@glMapNamedBufferRangeEXT, 'glMapNamedBufferRangeEXT');
  CheckAndLoadOpenGLproc(@glFlushMappedNamedBufferRangeEXT, 'glFlushMappedNamedBufferRangeEXT');
	
  {$R+}
end;


end.
