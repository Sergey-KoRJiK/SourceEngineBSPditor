unit UnitShaderManager;

// Copyright (c) 2020 Sergey-KoRJiK, Belarus
// github.com/Sergey-KoRJiK

interface

uses
  SysUtils,
  Windows,
  Classes,
  OpenGL,
  UnitOpenGLext;

type CShaderManager = class
  private
    iVertexObj, iGeometryObj, iFragmentObj, iProgramObj: GLuint;
    bVertexFileLoad, bGeometryFileLoad, bFragmentFileLoad: Boolean;
    bVertexObjCreated, bGeometryObjCreated, bFragmentObjCreated: Boolean;
    bProgramObjLinked: Boolean;
    //
  public
    property isVertexShaderLoaded:      Boolean read bVertexFileLoad;
    property isGeometryShaderLoaded:    Boolean read bGeometryFileLoad;
    property isFragmentShaderLoaded:    Boolean read bFragmentFileLoad;
    //
    property isVertexShaderCompiled:    Boolean read bVertexObjCreated;
    property isGeometryShaderCompiled:  Boolean read bGeometryObjCreated;
    property isFragmentShaderCompiled:  Boolean read bFragmentObjCreated;
    property isProgramLinked:           Boolean read bProgramObjLinked;
    //
    constructor   CreateManager();
    destructor    DeleteManager();
    //
    procedure Clear();
    function CreateShadersAndProgram(const VertexShaderFN, GeometryShaderFN,
      FragmentShaderFN: String; const bEnableVertexShader, bEnableGeometryShader,
      bEnableFragmentShader: Boolean): String; // Return Log file
    //
    function UseProgram(): Boolean;
    procedure FihishUseProgram(); // call glUseProgram(0);
    //
    // Uniform** return True if UniformName exist and applied to program,
    // or return False if UniformName don't exists
    function Uniform1f(const UniformName: String; const v0: GLfloat): Boolean;
    function Uniform2f(const UniformName: String; const v0, v1: GLfloat): Boolean;
    function Uniform3f(const UniformName: String; const v0, v1, v2: GLfloat): Boolean;
    function Uniform4f(const UniformName: String; const v0, v1, v2, v3: GLfloat): Boolean;
    //
    function Uniform1i(const UniformName: String; const v0: GLint): Boolean;
    function Uniform2i(const UniformName: String; const v0, v1: GLint): Boolean;
    function Uniform3i(const UniformName: String; const v0, v1, v2: GLint): Boolean;
    function Uniform4i(const UniformName: String; const v0, v1, v2, v3: GLint): Boolean;
    //
    // VectorDataType = {GL_INT, GL_UNSIGNED_INT, GL_FLOAT}.
    // NumOfComponents = number of VectorPtr components.
    // ArrayLength = length of array, if VectorPtr is link to array of Vectors.
    // ArrayLength = 1, if VectorPtr is link to single Vector;
    function UniformPtr(const UniformName: String; const VectorDataType: GLenum;
      const NumOfComponents, ArrayLength: Integer; const VectorPtr: PGLvoid): Boolean;
    //
    // MatrixSize = 2, 3 or 4 - size of square matrix.
    // transpose - in need transpose matrix before send to program.
    // ArrayLength = length of array, if MatrixPtr is link to array of Matrix.
    // ArrayLength = 1, if MatrixPtr is link to single Matrix;
    function UniformMatrix(const UniformName: String; const transpose: GLboolean;
      const MatrixSize, ArrayLength: Integer; const MatrixPtr: PGLfloat): Boolean;
    //
    // Function UniformTexture equivalent next 3 code lines:
    //   1. glActiveTextureARB(GL_TEXTURE0 + ActiveTexNumber);
    //   2. glBindTexture(TexTarget, TexId);
    //   3. glUniform1iARB(glGetUniformLocationARB(programObj, TextureName), ActiveTexNumber);
    // TexTarget is one of GL_TEXTURE_1D and ect.
    // ActiveTexNumber = [0..(MaxCount - 1)], where GLint MaxCount can be founded as
    // glGetIntegerv(GL_MAX_TEXTURE_UNITS, @MaxCount);
    function UniformTexture(const TextureName: String; const TexTarget: GLenum;
      const ActiveTexNumber, TexId: GLuint): Boolean;
  end;


implementation


constructor CShaderManager.CreateManager();
begin
  {$R-}
  Self.iVertexObj:=0;
  Self.iGeometryObj:=0;
  Self.iFragmentObj:=0;
  Self.iProgramObj:=0;
  //
  Self.bVertexObjCreated:=False;
  Self.bGeometryObjCreated:=False;
  Self.bFragmentObjCreated:=False;
  Self.bProgramObjLinked:=False;
  //
  Self.bVertexFileLoad:=False;
  Self.bGeometryFileLoad:=False;
  Self.bFragmentFileLoad:=False;
  {$R+}
end;

destructor CShaderManager.DeleteManager();
begin
  {$R-}
  Self.Clear();
  {$R+}
end;


procedure CShaderManager.Clear();
begin
  {$R-}
  glDetachObjectARB(Self.iProgramObj, Self.iVertexObj);
  glDetachObjectARB(Self.iProgramObj, Self.iGeometryObj);
  glDetachObjectARB(Self.iProgramObj, Self.iFragmentObj);
  //
  glDeleteObjectARB(Self.iVertexObj);
  glDeleteObjectARB(Self.iGeometryObj);
  glDeleteObjectARB(Self.iFragmentObj);
  //
  glDeleteObjectARB(Self.iProgramObj);

  Self.bVertexFileLoad:=False;
  Self.bGeometryFileLoad:=False;
  Self.bFragmentFileLoad:=False;
  //
  Self.bVertexObjCreated:=False;
  Self.bGeometryObjCreated:=False;
  Self.bFragmentObjCreated:=False;
  Self.bProgramObjLinked:=False;
  {$R+}
end;

function CShaderManager.CreateShadersAndProgram(
  const VertexShaderFN, GeometryShaderFN, FragmentShaderFN: String;
  const bEnableVertexShader, bEnableGeometryShader, bEnableFragmentShader: Boolean): String;
var
  ShaderFile: File;
  ShaderCodeStr, LogStr: AGLChar;
  ShaderCodeLen: Integer;
  CompileState, MaxLogLen: GLint;
  //
  VertexInfoStr, GeometryInfoStr, FragmentInfoStr: String;
  ProgramInfoStr: String;
begin
  {$R-}
  Self.Clear();
  if (bEnableVertexShader or bEnableGeometryShader or bEnableFragmentShader) then
    begin
      if (bEnableVertexShader) then
        begin
          // Load and Create Vertex Shader
          if (FileExists(VertexShaderFN)) then
            begin
              // 1. Load code from text file
              AssignFile(ShaderFile, VertexShaderFN);
              Reset(ShaderFile, 1);
              //
              // Get shader code length and allocate memory for code
              ShaderCodeLen:=FileSize(ShaderFile);
              SetLength(ShaderCodeStr, ShaderCodeLen + 1);
              //
              // Fill memory of code with zero char - make null-terminated string
              FillChar(ShaderCodeStr[0], ShaderCodeLen + 1, #0);
              //
              // Load code from file to memory and close file.
              // Set vertex code file load flag = True
              BlockRead(ShaderFile, ShaderCodeStr[0], ShaderCodeLen);
              CloseFile(ShaderFile);
              Self.bVertexFileLoad:=True;

              // 2. Create and compile shader from loaded code
              Self.iVertexObj:=glCreateShaderObjectARB(GL_VERTEX_SHADER);
              glShaderSourceARB(Self.iVertexObj, 1, PPGLchar(@PGLchar(ShaderCodeStr)), nil);
              glCompileShaderARB(Self.iVertexObj);
              //
              // free temporary loaded code data memory
              ShaderCodeLen:=0;
              SetLength(ShaderCodeStr, ShaderCodeLen);
              //
              // Get compilations status and set shader create flag by status value
              glGetObjectParameterivARB(Self.iVertexObj, GL_OBJECT_COMPILE_STATUS, @CompileState);
              Self.bVertexObjCreated:=GLboolean(CompileState);
              //
              // Get length of generated compile log, allocate memory for log data
              // and extract compilation log
              glGetObjectParameterivARB(Self.iVertexObj, GL_OBJECT_INFO_LOG_LENGTH, @MaxLogLen);
              SetLength(LogStr, MaxLogLen + 1);
              glGetInfoLogARB(Self.iVertexObj, MaxLogLen, @MaxLogLen, @LogStr[0]);
              //
              // Generate text info
              if (Self.bVertexObjCreated) then
                begin
                  VertexInfoStr:='OK: Vertex shader created: ' + #10 + PChar(LogStr);
                end
              else
                begin
                  VertexInfoStr:='ERROR: Vertex shader not created: ' + #10 + PChar(LogStr);
                  glDeleteObjectARB(Self.iVertexObj);
                end;
              //
              // Free temporary log memory
              SetLength(LogStr, 0);
            end
          else
            begin
              // Generate text info, set vertex code file load flag = False
              VertexInfoStr:='ERROR: invalid file path' + #10 + VertexShaderFN;
              Self.bVertexFileLoad:=False;
            end;
        end
      else
        begin
          // Generate text info
          VertexInfoStr:='Vertex shader is disabled for create.';
        end;

      if (bEnableGeometryShader) then
        begin
          // Load and Create Geometry Shader
          if (FileExists(GeometryShaderFN)) then
            begin
              // 1. Load code from text file
              AssignFile(ShaderFile, GeometryShaderFN);
              Reset(ShaderFile, 1);
              //
              // Get shader code length and allocate memory for code
              ShaderCodeLen:=FileSize(ShaderFile);
              SetLength(ShaderCodeStr, ShaderCodeLen + 1);
              //
              // Fill memory of code with zero char - make null-terminated string
              FillChar(ShaderCodeStr[0], ShaderCodeLen + 1, #0);
              //
              // Load code from file to memory and close file.
              // Set geometry code file load flag = True
              BlockRead(ShaderFile, ShaderCodeStr[0], ShaderCodeLen);
              CloseFile(ShaderFile);
              Self.bGeometryFileLoad:=True;

              // 2. Create and compile shader from loaded code
              Self.iGeometryObj:=glCreateShaderObjectARB(GL_GEOMETRY_SHADER);
              glShaderSourceARB(Self.iGeometryObj, 1, PPGLchar(@PGLchar(ShaderCodeStr)), nil);
              glCompileShaderARB(Self.iGeometryObj);
              //
              // free temporary loaded code data memory
              ShaderCodeLen:=0;
              SetLength(ShaderCodeStr, ShaderCodeLen);
              //
              // Get compilations status and set shader create flag by status value
              glGetObjectParameterivARB(Self.iGeometryObj, GL_OBJECT_COMPILE_STATUS, @CompileState);
              Self.bGeometryObjCreated:=GLboolean(CompileState);
              //
              // Get length of generated compile log, allocate memory for log data
              // and extract compilation log
              glGetObjectParameterivARB(Self.iGeometryObj, GL_OBJECT_INFO_LOG_LENGTH, @MaxLogLen);
              SetLength(LogStr, MaxLogLen + 1);
              glGetInfoLogARB(Self.iGeometryObj, MaxLogLen, @MaxLogLen, @LogStr[0]);
              //
              // Generate text info
              if (Self.bGeometryObjCreated) then
                begin
                  GeometryInfoStr:='OK: Geometry shader created: ' + #10 + PChar(LogStr);
                end
              else
                begin
                  GeometryInfoStr:='ERROR: Geometry shader not created: ' + #10 + PChar(LogStr);
                  glDeleteObjectARB(Self.iGeometryObj);
                end;
              //
              // Free temporary log memory
              SetLength(LogStr, 0);
            end
          else
            begin
              // Generate text info, set geometry code file load flag = False
              GeometryInfoStr:='ERROR: invalid file path' + #10 + GeometryShaderFN;
              Self.bGeometryFileLoad:=False;
            end;
        end
      else
        begin
          // Generate text info
          GeometryInfoStr:='Geometry shader is disabled for create.';
        end;

      if (bEnableFragmentShader) then
        begin
          // Load and Create Fragment Shader
          if (FileExists(FragmentShaderFN)) then
            begin
              // 1. Load code from text file
              AssignFile(ShaderFile, FragmentShaderFN);
              Reset(ShaderFile, 1);
              //
              // Get shader code length and allocate memory for code
              ShaderCodeLen:=FileSize(ShaderFile);
              SetLength(ShaderCodeStr, ShaderCodeLen + 1);
              //
              // Fill memory of code with zero char - make null-terminated string
              FillChar(ShaderCodeStr[0], ShaderCodeLen + 1, #0);
              //
              // Load code from file to memory and close file.
              // Set fragment code file load flag = True
              BlockRead(ShaderFile, ShaderCodeStr[0], ShaderCodeLen);
              CloseFile(ShaderFile);
              Self.bGeometryFileLoad:=True;

              // 2. Create and compile shader from loaded code
              Self.iFragmentObj:=glCreateShaderObjectARB(GL_FRAGMENT_SHADER);
              glShaderSourceARB(Self.iFragmentObj, 1, PPGLchar(@PGLchar(ShaderCodeStr)), nil);
              glCompileShaderARB(Self.iFragmentObj);
              //
              // free temporary loaded code data memory
              ShaderCodeLen:=0;
              SetLength(ShaderCodeStr, ShaderCodeLen);
              //
              // Get compilations status and set shader create flag by status value
              glGetObjectParameterivARB(Self.iFragmentObj, GL_OBJECT_COMPILE_STATUS, @CompileState);
              Self.bFragmentObjCreated:=GLboolean(CompileState);
              //
              // Get length of generated compile log, allocate memory for log data
              // and extract compilation log
              glGetObjectParameterivARB(Self.iFragmentObj, GL_OBJECT_INFO_LOG_LENGTH, @MaxLogLen);
              SetLength(LogStr, MaxLogLen + 1);
              glGetInfoLogARB(Self.iFragmentObj, MaxLogLen, @MaxLogLen, @LogStr[0]);
              //
              // Generate text info
              if (Self.bFragmentObjCreated) then
                begin
                  FragmentInfoStr:='OK: Fragment shader created: ' + #10 + PChar(LogStr);
                end
              else
                begin
                  FragmentInfoStr:='ERROR: Fragment shader not created: ' + #10 + PChar(LogStr);
                  glDeleteObjectARB(Self.iFragmentObj);
                end;
              //
              // Free temporary log memory
              SetLength(LogStr, 0);
            end
          else
            begin
              // Generate text info, set fragment code file load flag = False
              FragmentInfoStr:='ERROR: invalid file path' + #10 + FragmentShaderFN;
              Self.bFragmentFileLoad:=False;
            end;
        end
      else
        begin
          // Generate text info
          FragmentInfoStr:='Fragment shader is disabled for create.';
        end;

      // Next - create programm process
      if ((Self.bVertexObjCreated or Self.bGeometryObjCreated
        or Self.bFragmentObjCreated) = False) then
        begin
          // If no one shader created - do not create program and exit
          // Generate text info
          Self.bProgramObjLinked:=False;
          ProgramInfoStr:='ERROR: no one shader created - program creating disable!';
        end
      else
        begin
          // Create program object
          Self.iProgramObj:=glCreateProgramObjectARB();
          //
          // attach created shaders, if it's aviable
          if (Self.bVertexObjCreated) then  glAttachObjectARB(Self.iProgramObj, Self.iVertexObj);
          if (Self.bGeometryObjCreated) then  glAttachObjectARB(Self.iProgramObj, Self.iGeometryObj);
          if (Self.bFragmentObjCreated) then  glAttachObjectARB(Self.iProgramObj, Self.iFragmentObj);
          //
          // link attached shaders to program
          glLinkProgramARB(Self.iProgramObj);
          //
          // Get link status and set shader create flag by status value
          glGetObjectParameterivARB(Self.iProgramObj, GL_OBJECT_LINK_STATUS, @CompileState);
          Self.bProgramObjLinked:=GLboolean(CompileState);
          //
          // Get length of generated link log, allocate memory for log data
          // and extract compilation log
          glGetObjectParameterivARB(Self.iProgramObj, GL_OBJECT_INFO_LOG_LENGTH, @MaxLogLen);
          SetLength(LogStr, MaxLogLen + 1);
          glGetInfoLogARB(Self.iProgramObj, MaxLogLen, @MaxLogLen, @LogStr[0]);
          //
          // Generate text info
          if (Self.bProgramObjLinked) then
            begin
              ProgramInfoStr:='OK: Program linked: ' + #10 + PChar(LogStr);
            end
          else
            begin
              ProgramInfoStr:='ERROR: Program link failed: ' + #10 + PChar(LogStr);
              glDeleteObjectARB(Self.iProgramObj);
              glDeleteObjectARB(Self.iVertexObj);
              glDeleteObjectARB(Self.iGeometryObj);
              glDeleteObjectARB(Self.iFragmentObj);
            end;
          //
          // Free temporary log memory, detach shaders from program
          SetLength(LogStr, 0);
          glDetachObjectARB(Self.iProgramObj, Self.iVertexObj);
          glDetachObjectARB(Self.iProgramObj, Self.iGeometryObj);
          glDetachObjectARB(Self.iProgramObj, Self.iFragmentObj);
        end;

      // Make final log
      Result:=
        VertexInfoStr + #10 +
        GeometryInfoStr + #10 +
        FragmentInfoStr + #10 +
        ProgramInfoStr;
    end
  else
    begin
      Result:='Shader not created: no one shader selected for create!';
    end;
  {$R+}
end;




function CShaderManager.UseProgram(): Boolean;
begin
  {$R-}
  if (Self.bProgramObjLinked) then glUseProgramObjectARB(Self.iProgramObj);
  Result:=Self.bProgramObjLinked;
  {$R+}
end;

procedure CShaderManager.FihishUseProgram();
begin
  {$R-}
  if (Self.bProgramObjLinked) then glUseProgramObjectARB(0);
  {$R+}
end;


function CShaderManager.Uniform1f(const UniformName: String;
  const v0: GLfloat): Boolean;
var
  tmpStr: String;
  id: GLint;
begin
  {$R-}
  if (Self.bProgramObjLinked) then
    begin
      tmpStr:=UniformName + #0; // Make null-terminated string
      id:=glGetUniformLocationARB(Self.iProgramObj, PGLChar(tmpStr));
      if (id < 0) then
        begin
          Result:=False;
        end
      else
        begin
          glUniform1fARB(id, v0);
          Result:=True;
        end;
    end
  else Result:=False;
  {$R+}
end;

function CShaderManager.Uniform2f(const UniformName: String;
  const v0, v1: GLfloat): Boolean;
var
  tmpStr: String;
  id: GLint;
begin
  {$R-}
    if (Self.bProgramObjLinked) then
    begin
      tmpStr:=UniformName + #0; // Make null-terminated string
      id:=glGetUniformLocationARB(Self.iProgramObj, PGLChar(tmpStr));
      if (id < 0) then
        begin
          Result:=False;
        end
      else
        begin
          glUniform2fARB(id, v0, v1);
          Result:=True;
        end;
    end
  else Result:=False;
  {$R+}
end;

function CShaderManager.Uniform3f(const UniformName: String; 
  const v0, v1, v2: GLfloat): Boolean;
var
  tmpStr: String;
  id: GLint;
begin
  {$R-}
    if (Self.bProgramObjLinked) then
    begin
      tmpStr:=UniformName + #0; // Make null-terminated string
      id:=glGetUniformLocationARB(Self.iProgramObj, PGLChar(tmpStr));
      if (id < 0) then
        begin
          Result:=False;
        end
      else
        begin
          glUniform3fARB(id, v0, v1, v2);
          Result:=True;
        end;
    end
  else Result:=False;
  {$R+}
end;

function CShaderManager.Uniform4f(const UniformName: String; 
  const v0, v1, v2, v3: GLfloat): Boolean;
var
  tmpStr: String;
  id: GLint;
begin
  {$R-}
    if (Self.bProgramObjLinked) then
    begin
      tmpStr:=UniformName + #0; // Make null-terminated string
      id:=glGetUniformLocationARB(Self.iProgramObj, PGLChar(tmpStr));
      if (id < 0) then
        begin
          Result:=False;
        end
      else
        begin
          glUniform4fARB(id, v0, v1, v2, v3);
          Result:=True;
        end;
    end
  else Result:=False;
  {$R+}
end;


function CShaderManager.Uniform1i(const UniformName: String; 
  const v0: GLint): Boolean;
var
  tmpStr: String;
  id: GLint;
begin
  {$R-}
    if (Self.bProgramObjLinked) then
    begin
      tmpStr:=UniformName + #0; // Make null-terminated string
      id:=glGetUniformLocationARB(Self.iProgramObj, PGLChar(tmpStr));
      if (id < 0) then
        begin
          Result:=False;
        end
      else
        begin
          glUniform1iARB(id, v0);
          Result:=True;
        end;
    end
  else Result:=False;
  {$R+}
end;

function CShaderManager.Uniform2i(const UniformName: String; 
  const v0, v1: GLint): Boolean;
var
  tmpStr: String;
  id: GLint;
begin
  {$R-}
    if (Self.bProgramObjLinked) then
    begin
      tmpStr:=UniformName + #0; // Make null-terminated string
      id:=glGetUniformLocationARB(Self.iProgramObj, PGLChar(tmpStr));
      if (id < 0) then
        begin
          Result:=False;
        end
      else
        begin
          glUniform2iARB(id, v0, v1);
          Result:=True;
        end;
    end
  else Result:=False;
  {$R+}
end;

function CShaderManager.Uniform3i(const UniformName: String; 
  const v0, v1, v2: GLint): Boolean;
var
  tmpStr: String;
  id: GLint;
begin
  {$R-}
    if (Self.bProgramObjLinked) then
    begin
      tmpStr:=UniformName + #0; // Make null-terminated string
      id:=glGetUniformLocationARB(Self.iProgramObj, PGLChar(tmpStr));
      if (id < 0) then
        begin
          Result:=False;
        end
      else
        begin
          glUniform3iARB(id, v0, v1, v2);
          Result:=True;
        end;
    end
  else Result:=False;
  {$R+}
end;

function CShaderManager.Uniform4i(const UniformName: String; 
  const v0, v1, v2, v3: GLint): Boolean;
var
  tmpStr: String;
  id: GLint;
begin
  {$R-}
    if (Self.bProgramObjLinked) then
    begin
      tmpStr:=UniformName + #0; // Make null-terminated string
      id:=glGetUniformLocationARB(Self.iProgramObj, PGLChar(tmpStr));
      if (id < 0) then
        begin
          Result:=False;
        end
      else
        begin
          glUniform4iARB(id, v0, v1, v2, v3);
          Result:=True;
        end;
    end
  else Result:=False;
  {$R+}
end;


function CShaderManager.UniformPtr(const UniformName: String;
  const VectorDataType: GLenum; const NumOfComponents, ArrayLength: Integer;
  const VectorPtr: PGLvoid): Boolean;
var
  tmpStr: String;
  id: GLint;
begin
  {$R-}
  if (ArrayLength < 1) then
    begin
      Result:=False;
      Exit;
    end;

  if (Self.bProgramObjLinked) then
    begin
      tmpStr:=UniformName + #0; // Make null-terminated string
      id:=glGetUniformLocationARB(Self.iProgramObj, PGLChar(tmpStr));
      if (id < 0) then
        begin
          Result:=False;
        end
      else
        begin
          Result:=True;
          case (VectorDataType) of
            GL_INT:
              begin
                case (NumOfComponents) of
                  1: glUniform1ivARB(id, ArrayLength, VectorPtr);
                  2: glUniform2ivARB(id, ArrayLength, VectorPtr);
                  3: glUniform3ivARB(id, ArrayLength, VectorPtr);
                  4: glUniform4ivARB(id, ArrayLength, VectorPtr);
                else
                  Result:=False;
                end;
              end;
            GL_FLOAT:
              begin
                case (NumOfComponents) of
                  1: glUniform1fvARB(id, ArrayLength, VectorPtr);
                  2: glUniform2fvARB(id, ArrayLength, VectorPtr);
                  3: glUniform3fvARB(id, ArrayLength, VectorPtr);
                  4: glUniform4fvARB(id, ArrayLength, VectorPtr);
                else
                  Result:=False;
                end;
              end;
          else
            Result:=False;
          end;
        end;
    end
  else Result:=False;
  {$R+}
end;

function CShaderManager.UniformMatrix(const UniformName: String;
  const transpose: GLboolean; const MatrixSize, ArrayLength: Integer;
  const MatrixPtr: PGLfloat): Boolean;
var
  tmpStr: String;
  id: GLint;
begin
  {$R-}
  if (ArrayLength < 1) then
    begin
      Result:=False;
      Exit;
    end;

  if (Self.bProgramObjLinked) then
    begin
      tmpStr:=UniformName + #0; // Make null-terminated string
      id:=glGetUniformLocationARB(Self.iProgramObj, PGLChar(tmpStr));
      if (id < 0) then
        begin
          Result:=False;
        end
      else
        begin
          Result:=True;
          case (MatrixSize) of
            2: glUniformMatrix2fvARB(id, ArrayLength, transpose, MatrixPtr);
            3: glUniformMatrix3fvARB(id, ArrayLength, transpose, MatrixPtr);
            4: glUniformMatrix4fvARB(id, ArrayLength, transpose, MatrixPtr);
          else
            Result:=False;
          end;
        end;
    end
  else Result:=False;
  {$R+}
end;

function CShaderManager.UniformTexture(const TextureName: String;
  const TexTarget: GLenum; const ActiveTexNumber, TexId: GLuint): Boolean;
var
  tmpStr: String;
  id: GLint;
begin
  {$R-}
  if (Self.bProgramObjLinked) then
    begin
      tmpStr:=TextureName + #0; // Make null-terminated string
      id:=glGetUniformLocationARB(Self.iProgramObj, PGLChar(tmpStr));
      if (id < 0) then
        begin
          Result:=False;
        end
      else
        begin
          Result:=True;
          glActiveTextureARB(GL_TEXTURE0 + ActiveTexNumber);
          glBindTexture(TexTarget, TexId);
          glUniform1iARB(id, ActiveTexNumber);
        end;
    end
  else Result:=False;
  {$R+}
end;

end.
