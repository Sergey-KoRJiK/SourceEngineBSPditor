unit UnitVertexBufferArrayManager;

// Copyright (c) 2020 Sergey-KoRJiK, Belarus
// github.com/Sergey-KoRJiK

interface

uses
  SysUtils,
  Windows,
  Classes,
  OpenGL,
  UnitOpenGLext;

const MaxCountVertexAttributes = 16;

type tFillAttribInfo = record
    Size: GLint;
    AttribType: GLenum;
    bNormalized: GLboolean;
    Stride: GLsizei;
    Offset: PGLvoid;
    Divisor: GLuint;
  end;
type PFillAttribInfo = ^tFillAttribInfo;
type AFillAttribInfo = array of tFillAttribInfo;

type CVertexBufferArrayManager = class
  private
    iVAO                  : GLuint;
    iCountAttribs         : Integer;
    wFillAttribBits       : Word;
    bIsCreated            : Boolean;
    bIsAllAttribs         : Boolean;
  public
    property IsCreated:             Boolean read bIsCreated;
    property IsFillAllAttribs:      Boolean read bIsAllAttribs;
    property CountAttributes:       Integer read iCountAttribs;
    property BitFieldFillAttribs:   Word read wFillAttribBits;
    //
    constructor CreateManager();
    destructor DeleteManager();
    //
    procedure Clear();
    //
    function CreateAndFillVertexArray(const FillAttribInfoList: PFillAttribInfo;
      const VBOList: PGLuint; const CountAttribs: Integer): Boolean;
    function CreateNullVertexArray(const CountAttribs: Integer): Boolean;
    function AddArrayAttrib(const AttribIndex: Integer;
      const Info: tFillAttribInfo): Boolean; overload;
    function AddArrayAttrib(const AttribIndex: Integer;
      const Size: GLint; const AttribType: GLenum; const bNormalized: GLboolean;
      const Stride: GLint; const Offset: PGLVoid;
      const Divisor: GLuint): Boolean; overload;
    //
    function BindVertexArray(): Boolean;
    procedure UnbindVertexArray();
  end;


implementation


const wFillAttribBitMask: array[0..15] of Word = (
    $0001, $0003, $0007, $000F,
    $001F, $003F, $007F, $00FF,
    $01FF, $03FF, $07FF, $0FFF,
    $1FFF, $3FFF, $7FFF, $FFFF
  );

constructor CVertexBufferArrayManager.CreateManager();
begin
  {$R-}
  Self.iVAO:=0;
  Self.iCountAttribs:=0;
  Self.bIsCreated:=False;
  Self.bIsAllAttribs:=False;
  Self.wFillAttribBits:=$0000;
  {$R+}
end;

destructor CVertexBufferArrayManager.DeleteManager();
begin
  {$R-}
  Self.Clear();
  {$R+}
end;


procedure CVertexBufferArrayManager.Clear();
begin
  {$R-}
  glDeleteVertexArrays(1, @Self.iVAO);
  Self.iCountAttribs:=0;
  Self.bIsCreated:=False;
  Self.bIsAllAttribs:=False;
  Self.wFillAttribBits:=$0000;
  {$R+}
end;

function CVertexBufferArrayManager.CreateAndFillVertexArray(
  const FillAttribInfoList: PFillAttribInfo; const VBOList: PGLuint;
  const CountAttribs: Integer): Boolean;
var
  i: Integer;
begin
  {$R-}
  Self.Clear();

  Self.iCountAttribs:=CountAttribs;
  if (Self.iCountAttribs < 0) then
    begin
      Self.iCountAttribs:=0;
    end;
  if (Self.iCountAttribs >= MaxCountVertexAttributes) then
    begin
      Self.iCountAttribs:=MaxCountVertexAttributes - 1;
    end;

  glGenVertexArrays(1, @Self.iVAO);
  if (Self.iVAO = 0) then
    begin
      Self.Clear();
      Result:=False;
      Exit;
    end;

  glBindVertexArray(Self.iVAO);

  for i:=0 to (Self.iCountAttribs - 1) do
    begin
      glBindBufferARB(GL_ARRAY_BUFFER, AGLuint(VBOList)[i]);
      glEnableVertexAttribArrayARB(i);
      case (AFillAttribInfo(FillAttribInfoList)[i].AttribType) of
        GL_FLOAT, GL_HALF_FLOAT,
        GL_FIXED, GL_INT_2_10_10_10_REV,
        GL_UNSIGNED_INT_2_10_10_10_REV,
        GL_UNSIGNED_INT_10F_11F_11F_REV:
          glVertexAttribPointerARB(
            i,
            AFillAttribInfo(FillAttribInfoList)[i].Size,
            AFillAttribInfo(FillAttribInfoList)[i].AttribType,
            AFillAttribInfo(FillAttribInfoList)[i].bNormalized,
            AFillAttribInfo(FillAttribInfoList)[i].Stride,
            AFillAttribInfo(FillAttribInfoList)[i].Offset
          );
        //
        GL_BYTE, GL_UNSIGNED_BYTE,
        GL_SHORT, GL_UNSIGNED_SHORT,
        GL_INT, GL_UNSIGNED_INT:
          glVertexAttribIPointer(
            i,
            AFillAttribInfo(FillAttribInfoList)[i].Size,
            AFillAttribInfo(FillAttribInfoList)[i].AttribType,
            AFillAttribInfo(FillAttribInfoList)[i].Stride,
            AFillAttribInfo(FillAttribInfoList)[i].Offset
          );
        //
        GL_DOUBLE:
          glVertexAttribLPointer(
            i,
            AFillAttribInfo(FillAttribInfoList)[i].Size,
            GL_DOUBLE,
            AFillAttribInfo(FillAttribInfoList)[i].Stride,
            AFillAttribInfo(FillAttribInfoList)[i].Offset
          );
      end;
      glVertexAttribDivisorARB(i, AFillAttribInfo(FillAttribInfoList)[i].Divisor);
      Self.wFillAttribBits:=Self.wFillAttribBits or (1 shl i);
    end;

  glBindBufferARB(GL_ARRAY_BUFFER, 0);
  glBindVertexArray(0); //}

  Self.bIsCreated:=True;
  Self.bIsAllAttribs:=True;
  Result:=True;
  {$R+}
end;

function CVertexBufferArrayManager.CreateNullVertexArray(
  const CountAttribs: Integer): Boolean;
begin
  {$R-}
  Self.Clear();

  Self.iCountAttribs:=CountAttribs;
  if (Self.iCountAttribs < 0) then
    begin
      Self.iCountAttribs:=0;
    end;
  if (Self.iCountAttribs >= MaxCountVertexAttributes) then
    begin
      Self.iCountAttribs:=MaxCountVertexAttributes - 1;
    end;

  glGenVertexArrays(1, @Self.iVAO);
  if (Self.iVAO = 0) then
    begin
      Self.Clear();
      Result:=False;
      Exit;
    end;

  Self.bIsCreated:=True;
  Result:=True;
  {$R+}
end;

function CVertexBufferArrayManager.AddArrayAttrib(const AttribIndex: Integer;
  const Info: tFillAttribInfo): Boolean;
begin
  {$R-}
  if ((Self.bIsCreated = False) or (Self.bIsAllAttribs)
      or (AttribIndex < 0) or (AttribIndex >= Self.iCountAttribs)) then
    begin
      Result:=False;
      Exit;
    end;

  if ((Self.wFillAttribBits and (1 shl AttribIndex)) <> 0) then
    begin
      // Attrib already filled
      Result:=False;
      Exit;
    end;

  glEnableVertexAttribArrayARB(AttribIndex);
  case (Info.AttribType) of
    GL_FLOAT, GL_HALF_FLOAT, GL_FIXED,
    GL_INT_2_10_10_10_REV, GL_UNSIGNED_INT_2_10_10_10_REV,
    GL_UNSIGNED_INT_10F_11F_11F_REV: glVertexAttribPointerARB(
      AttribIndex,
      Info.Size,
      Info.AttribType,
      Info.bNormalized,
      Info.Stride,
      Info.Offset
    );
    //
    GL_BYTE, GL_UNSIGNED_BYTE,
    GL_SHORT, GL_UNSIGNED_SHORT,
    GL_INT, GL_UNSIGNED_INT: glVertexAttribIPointer(
      AttribIndex,
      Info.Size,
      Info.AttribType,
      Info.Stride,
      Info.Offset
    );
    //
    GL_DOUBLE: glVertexAttribLPointer(
      AttribIndex,
      Info.Size,
      GL_DOUBLE,
      Info.Stride,
      Info.Offset
    );
  end;

  glVertexAttribDivisorARB(AttribIndex, Info.Divisor);
  Self.wFillAttribBits:=Self.wFillAttribBits or (1 shl AttribIndex);

  Self.bIsAllAttribs:=Boolean(Self.wFillAttribBits = wFillAttribBitMask[Self.iCountAttribs]);
  Result:=True;
  {$R+}
end;

function CVertexBufferArrayManager.AddArrayAttrib(const AttribIndex: Integer;
  const Size: GLint; const AttribType: GLenum; const bNormalized: GLboolean;
  const Stride: GLint; const Offset: PGLVoid; const Divisor: GLuint): Boolean;
begin
  {$R-}
  if ((Self.bIsCreated = False) or (Self.bIsAllAttribs)
      or (AttribIndex < 0) or (AttribIndex >= Self.iCountAttribs)) then
    begin
      Result:=False;
      Exit;
    end;

  if ((Self.wFillAttribBits and (1 shl AttribIndex)) <> 0) then
    begin
      // Attrib already filled
      Result:=False;
      Exit;
    end;

  glEnableVertexAttribArrayARB(AttribIndex);
  case (AttribType) of
    GL_FLOAT, GL_HALF_FLOAT, GL_FIXED,
    GL_INT_2_10_10_10_REV, GL_UNSIGNED_INT_2_10_10_10_REV,
    GL_UNSIGNED_INT_10F_11F_11F_REV: glVertexAttribPointerARB(
      AttribIndex,
      Size,
      AttribType,
      bNormalized,
      Stride,
      Offset
    );
    //
    GL_BYTE, GL_UNSIGNED_BYTE,
    GL_SHORT, GL_UNSIGNED_SHORT,
    GL_INT, GL_UNSIGNED_INT: glVertexAttribIPointer(
      AttribIndex,
      Size,
      AttribType,
      Stride,
      Offset
    );
    //
    GL_DOUBLE: glVertexAttribLPointer(
      AttribIndex,
      Size,
      GL_DOUBLE,
      Stride,
      Offset
    );
  end;

  glVertexAttribDivisorARB(AttribIndex, Divisor);
  Self.wFillAttribBits:=Self.wFillAttribBits or (1 shl AttribIndex);

  Self.bIsAllAttribs:=Boolean(Self.wFillAttribBits = wFillAttribBitMask[Self.iCountAttribs]);
  Result:=True;
  {$R+}
end;

function CVertexBufferArrayManager.BindVertexArray(): Boolean;
begin
  {$R-}
  if (Self.bIsCreated) then glBindVertexArray(Self.iVAO);
  Result:=Self.bIsCreated;
  {$R+}
end;

procedure CVertexBufferArrayManager.UnbindVertexArray();
begin
  {$R-}
  if (Self.bIsCreated) then glBindVertexArray(0);
  {$R+}
end;

end.
