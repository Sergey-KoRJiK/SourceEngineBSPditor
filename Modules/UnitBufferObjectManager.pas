unit UnitBufferObjectManager;

// Copyright (c) 2021 Sergey-KoRJiK, Belarus

interface

uses
  SysUtils,
  Windows,
  Classes,
  OpenGL,
  UnitOpenGLext;

type CBufferObjectManager = class
  private
    iBufferObject:  GLuint;
    eTarget:        GLenum;
    eUsage:         GLenum;     // Only for Mutable Storage (glBufferData)
    bitFlags:       GLbitfield; // Only for Immutable Storage (glBufferStorage)
    //
    iSize:          GLsizeiptr;
    iMapPtrAlign:   GLint;
    iBindIndex:     GLint;
    //
    bIsCreated:     Boolean;
    bIsBinded:      Boolean;
    bIsImmutable:   Boolean;
    bIsAllocated:   Boolean;    // mean first call of glBufferData or glBufferStorage
    bIsMapped:      Boolean;
  public
    property IsCreated:       Boolean     read bIsCreated;
    property IsBinded:        Boolean     read bIsBinded;
    property IsImmutable:     Boolean     read bIsImmutable;
    property IsAllocated:     Boolean     read bIsAllocated;
    property IsMapped:        Boolean     read bIsMapped;
    //
    property BindedTarget:    GLenum      read eTarget;
    property MutableUsage:    GLenum      read eUsage;
    property ImmutableFlags:  GLbitfield  read bitFlags;
    property AllocatedSize:   GLsizeiptr  read iSize;
    property MappedPtrAlign:  GLint       read iMapPtrAlign;
    property BindedIndex:     GLint       read iBindIndex;
    //
    constructor CreateManager();
    destructor DeleteManager();
    //
    procedure Clear();
    function CreateBuffer(): Boolean;
    function BindBuffer(const target: GLenum): Boolean;
    function BindBufferBase(const target: GLenum; const index: GLint): Boolean;
    procedure UnbindBuffer();
    //
    function AllocateImmutable(const size: GLsizeiptr; const data: PGLvoid;
      const flags: GLbitfield): Boolean;
    function AllocateMutable(const size: GLsizeiptr; const data: PGLvoid;
      const usage: GLenum): Boolean;
    //
    function WriteToBuffer(const writeOffset: GLintptr;
      const writeSize: GLsizeiptr; const data: PGLvoid): Boolean;
    function ReadFromBuffer(const readOffset: GLintptr;
      const readSize: GLsizeiptr; const data: PGLvoid): Boolean;
    //
    function InvalidateBuffer(const offset: GLintptr;
      const size: GLsizeiptr): Boolean;
    function InternalCopyBuffer(const offsetSrc, offsetDst: GLintptr;
      const size: GLsizeiptr): Boolean;
    //
    function MapBuffer(const eAccess: GLenum): Pointer;
    function UnmapBuffer(): Boolean;
  end;


implementation


constructor CBufferObjectManager.CreateManager();
begin
  {$R-}
  inherited;

  Self.iBufferObject:=0;
  Self.eTarget:=0;
  Self.eUsage:=0;
  Self.bitFlags:=0;
  //
  Self.bIsCreated:=False;
  Self.bIsBinded:=False;
  Self.bIsImmutable:=False;
  Self.bIsAllocated:=False;
  //
  Self.iSize:=0;
  Self.iMapPtrAlign:=64;
  Self.iBindIndex:=-1;
  {$R+}
end;

destructor CBufferObjectManager.DeleteManager();
begin
  {$R-}
  glDeleteBuffersARB(1, @Self.iBufferObject);

  inherited;
  {$R+}
end;


procedure CBufferObjectManager.Clear();
begin
  {$R-}
  glDeleteBuffersARB(1, @Self.iBufferObject);
  Self.iBufferObject:=0;
  Self.eTarget:=0;
  Self.eUsage:=0;
  Self.bitFlags:=0;
  //
  Self.bIsCreated:=False;
  Self.bIsBinded:=False;
  Self.bIsImmutable:=False;
  Self.bIsAllocated:=False;
  //
  Self.iSize:=0;
  Self.iMapPtrAlign:=64;
  Self.iBindIndex:=-1;
  {$R+}
end;

function CBufferObjectManager.CreateBuffer(): Boolean;
begin
  {$R-}
  Self.Clear();
  glGenBuffersARB(1, @Self.iBufferObject);
  if (Self.iBufferObject <> 0) then Self.bIsCreated:=True;
  Result:=Self.bIsCreated;
  {$R+}
end;

function CBufferObjectManager.BindBuffer(const target: GLenum): Boolean;
begin
  {$R-}
  if (not Self.bIsCreated) then
    begin
      Result:=False;
      Exit;
    end;

  Self.eTarget:=target;
  Self.iBindIndex:=-1;
  glBindBufferARB(Self.eTarget, Self.iBufferObject);
  Self.bIsBinded:=True;
  Result:=True;
  {$R+}
end;

function CBufferObjectManager.BindBufferBase(const target: GLenum;
  const index: GLint): Boolean;
begin
  {$R-}
  if (not Self.bIsCreated) then
    begin
      Result:=False;
      Exit;
    end;

  Self.eTarget:=target;
  Self.iBindIndex:=index;
  glBindBufferBase(Self.eTarget, GLuint(Self.iBindIndex), Self.iBufferObject);
  Self.bIsBinded:=True;
  Result:=True;
  {$R+}
end;

procedure CBufferObjectManager.UnbindBuffer();
begin
  {$R-}
  glBindBufferARB(Self.eTarget, 0);
  Self.eTarget:=0;
  Self.bIsBinded:=False;
  {$R+}
end;


function CBufferObjectManager.AllocateImmutable(const size: GLsizeiptr;
  const data: PGLvoid; const flags: GLbitfield): Boolean;
begin
  {$R-}
  if ((not Self.bIsBinded) or (Self.bIsAllocated) or (size <= 0)) then
    begin
      Result:=False;
      Exit;
    end;

  Self.iSize:=size;     
  Self.bitFlags:=flags;
  glBufferStorage(Self.eTarget, Self.iSize, data, Self.bitFlags);
  Self.bIsAllocated:=True;
  Self.bIsImmutable:=True;
  Result:=True;
  {$R+}
end;


function CBufferObjectManager.AllocateMutable(const size: GLsizeiptr;
  const data: PGLvoid; const usage: GLenum): Boolean;
begin
  {$R-}
  if ((not Self.bIsBinded) or (Self.bIsAllocated) or (size <= 0)) then
    begin
      Result:=False;
      Exit;
    end;

  Self.iSize:=size;
  Self.eUsage:=usage;
  glBufferDataARB(Self.eTarget, Self.iSize, data, Self.eUsage);
  Self.bIsAllocated:=True;
  Self.bIsImmutable:=False;
  Result:=True;
  {$R+}
end;


function CBufferObjectManager.WriteToBuffer(const writeOffset: GLintptr;
  const writeSize: GLsizeiptr; const data: PGLvoid): Boolean;
begin
  {$R-}
  if ((not Self.bIsAllocated) or (data = nil)
    or ((writeOffset + writeSize) > Self.iSize)
    or (writeOffset < 0) or (writeSize <= 0)) then
    begin
      Result:=False;
      Exit;
    end;

  glBufferSubDataARB(Self.eTarget, writeOffset, writeSize, data);
  Result:=True;
  {$R+}
end;

function CBufferObjectManager.ReadFromBuffer(const readOffset: GLintptr;
  const readSize: GLsizeiptr; const data: PGLvoid): Boolean;
begin
  {$R-}
  if ((not Self.bIsAllocated) or (data = nil)
    or ((readOffset + readSize) > Self.iSize)
    or (readOffset < 0) or (readSize <= 0)) then
    begin
      Result:=False;
      Exit;
    end;

  glGetBufferSubDataARB(Self.eTarget, readOffset, readSize, data);
  Result:=True;
  {$R+}
end;


function CBufferObjectManager.InvalidateBuffer(const offset: GLintptr;
  const size: GLsizeiptr): Boolean;
begin
  {$R-}
  if ((not Self.bIsAllocated) or ((offset + size) > Self.iSize)
    or (offset < 0) or (size <= 0)) then
    begin
      Result:=False;
      Exit;
    end;

  glInvalidateBufferSubData(Self.iBufferObject, offset, size);
  Result:=True;
  {$R+}
end;

function CBufferObjectManager.InternalCopyBuffer(const offsetSrc,
  offsetDst: GLintptr; const size: GLsizeiptr): Boolean;
begin
  {$R-}
  if ((not Self.bIsAllocated) or (offsetSrc < 0) or (offsetDst < 0)
    or (size <= 0) or (size > Self.iSize) or ((offsetDst + size) > Self.iSize)
    or ((offsetSrc + size) > Self.iSize)) then
    begin
      Result:=False;
      Exit;
    end;

  glCopyBufferSubData(Self.eTarget, Self.eTarget, offsetSrc, offsetDst, size);
  Result:=True;
  {$R+}
end;


function CBufferObjectManager.MapBuffer(const eAccess: GLenum): Pointer;
begin
  {$R-}
  if ((not Self.bIsAllocated) or (Self.bIsMapped)) then
    begin
      Result:=nil;
      Exit;
    end;

  Self.bIsMapped:=True;
  Result:=glMapBufferARB(Self.eTarget, eAccess);
  {$R+}
end;

function CBufferObjectManager.UnmapBuffer(): Boolean;
begin
  {$R-}
  if (Self.bIsMapped = False) then
    begin
      Result:=False;
      Exit;
    end;

  Self.iMapPtrAlign:=0;
  Self.bIsMapped:=False;
  Result:=glUnmapBufferARB(Self.eTarget);
  {$R+}
end;

end.
