unit UnitOpenGLErrorManager;

// Copyright (c) 2020 Sergey-KoRJiK, Belarus
// github.com/Sergey-KoRJiK

interface

uses
  Windows,
  OpenGL;

// Clear error queue
procedure glClearErrorQueue();

// Get list of last errors of OpenGL error queue.
// Max size of list is 16384 Errors. Ff errors more then queue limit,
// then function return False.
function glScanErrors(): ByteBool;

// Get upper error from scanned queue and remove this from queue
function glPopError(): GLenum;

// Get upper error from scanned queue
function glReadUpperError(): GLenum;

// Get current count of scanned errors into queue
function glGetCountErrors(): Integer;

// Return errors into string
function glGetStrErrors(const ErrStrSeparator: Char): String;

// Call glScanErrors, next show message dialog by glGetStrErrors()
// where separator is new line, and finish by clear error queue.
procedure glShowErrorsMessageBox();


implementation


const
  STR_UNKNOW_                         = 'UNKNOW_';                        //  7
  STR_NO_ERROR                        = 'NO_ERROR';                       //  8
  STR_INVALID_ENUM                    = 'INVALID_ENUM';                   // 12
  STR_INVALID_VALUE                   = 'INVALID_VALUE';                  // 13
  STR_INVALID_OPERATION               = 'INVALID_OPERATION';              // 17
  STR_STACK_OVERFLOW                  = 'STACK_OVERFLOW';                 // 14
  STR_STACK_UNDERFLOW                 = 'STACK_UNDERFLOW';                // 15
  STR_OUT_OF_MEMORY                   = 'OUT_OF_MEMORY';                  // 13
  STR_INVALID_FRAMEBUFFER_OPERATION   = 'INVALID_FRAMEBUFFER_OPERATION';  // 29
  STR_CONTEXT_LOST                    = 'CONTEXT_LOST';                   // 12
  STR_TABLE_TOO_LARGE                 = 'TABLE_TOO_LARGE';                // 15
  //
  GL_INVALID_FRAMEBUFFER_OPERATION    = $0506;
  GL_CONTEXT_LOST                     = $0507;
  GL_TABLE_TOO_LARGE                  = $8031;

type PGLenum = ^GLenum;

var
  glErrorQueue, glUpperError, glUpperLimit: PGLenum;

procedure glClearErrorQueue();
asm
  {$R-}
  push EDI
  mov EDI, glErrorQueue
  mov glUpperError, EDI
  xor EAX, EAX // Filler EAX = 0
  mov ECX, $00004000 // $4000 = 16384 = 65536 / 4;
  rep stosd
  // rep:
  // 1. MOV [EDX], EAX
  // 2. EDI = EDI + 4
  // 3. ECX = ECX - 1
  // 4. if (ECX <> 0) go to step 1.
  pop EDI
  {$R+}
end;

function glScanErrors(): ByteBool;
begin
  {$R-}
  if (glErrorQueue = nil) then
    begin
      Result:=False;
      Exit;
    end;

  while (glUpperError <> glUpperLimit) do
    begin
      glUpperError^:=glGetError();
      if (glUpperError^ = GL_NO_ERROR) then Break;
      Inc(glUpperError);
    end;
  Result:=(glUpperError = glUpperLimit);
  if (glUpperError^ <> GL_NO_ERROR) then Dec(glUpperError);
  {$R+}
end;

function glPopError(): GLenum;
begin
  {$R-}
  if ((glErrorQueue = nil) or (glUpperError = glErrorQueue)) then
    begin
      Result:=GL_NO_ERROR;
      Exit;
    end;

  Result:=glUpperError^;
  Dec(glUpperError);
  {$R+}
end;

function glReadUpperError(): GLenum;
begin
  {$R-}
  if (glErrorQueue = nil) then
    begin
      Result:=GL_NO_ERROR;
      Exit;
    end;

  Result:=glUpperError^;
  {$R+}
end;

function glGetCountErrors(): Integer;
begin
  {$R-}
  if (glErrorQueue = nil) then
    begin
      Result:=0;
      Exit;
    end;

  Result:=((DWORD(glUpperError) - DWORD(glErrorQueue)) div SizeOf(GLenum)) + 1;
  {$R+}
end;

function glGetStrErrors(const ErrStrSeparator: Char): String;
var
  CurrPtr: PGLenum;
  tmpStr: String;
begin
  {$R-}
  if (glErrorQueue = nil) then
    begin
      Result:='';
      Exit;
    end;

  // 1. Get string length
  Result:='';
  CurrPtr:=glUpperError;
  while (CurrPtr <> glErrorQueue) do
    begin
      case (CurrPtr^) of
        GL_NO_ERROR: Result:=Result + STR_NO_ERROR;
        GL_INVALID_ENUM: Result:=Result + STR_INVALID_ENUM;
        GL_INVALID_VALUE: Result:=Result + STR_INVALID_VALUE;
        GL_INVALID_OPERATION: Result:=Result + STR_INVALID_OPERATION;
        GL_STACK_OVERFLOW: Result:=Result + STR_STACK_OVERFLOW;
        GL_STACK_UNDERFLOW: Result:=Result + STR_STACK_UNDERFLOW;
        GL_OUT_OF_MEMORY: Result:=Result + STR_OUT_OF_MEMORY;
        GL_INVALID_FRAMEBUFFER_OPERATION: Result:=Result + STR_INVALID_FRAMEBUFFER_OPERATION;
        GL_CONTEXT_LOST: Result:=Result + STR_CONTEXT_LOST;
        GL_TABLE_TOO_LARGE: Result:=Result + STR_TABLE_TOO_LARGE;
      else
        Str(CurrPtr^, tmpStr);
        Result:=Result + STR_UNKNOW_ + tmpStr;
      end;
      Result:=Result + ErrStrSeparator;
      Dec(CurrPtr);
    end;
  //
  case (CurrPtr^) of
    GL_NO_ERROR: Result:=Result + STR_NO_ERROR;
    GL_INVALID_ENUM: Result:=Result + STR_INVALID_ENUM;
    GL_INVALID_VALUE: Result:=Result + STR_INVALID_VALUE;
    GL_INVALID_OPERATION: Result:=Result + STR_INVALID_OPERATION;
    GL_STACK_OVERFLOW: Result:=Result + STR_STACK_OVERFLOW;
    GL_STACK_UNDERFLOW: Result:=Result + STR_STACK_UNDERFLOW;
    GL_OUT_OF_MEMORY: Result:=Result + STR_OUT_OF_MEMORY;
    GL_INVALID_FRAMEBUFFER_OPERATION: Result:=Result + STR_INVALID_FRAMEBUFFER_OPERATION;
    GL_CONTEXT_LOST: Result:=Result + STR_CONTEXT_LOST;
    GL_TABLE_TOO_LARGE: Result:=Result + STR_TABLE_TOO_LARGE;
  else
    Str(CurrPtr^, tmpStr);
    Result:=Result + STR_UNKNOW_ + tmpStr;
  end;
  {$R+}
end;

procedure glShowErrorsMessageBox();
begin
  {$R-}
  glScanErrors();
  MessageBox(0, PAnsiChar(glGetStrErrors(#$0A)),
    'OpenGL Error Manager', MB_OK or MB_ICONERROR or MB_TASKMODAL);
  glClearErrorQueue();
  {$R-}
end;


initialization
  {$R-}
  glErrorQueue:=VirtualAlloc(nil, 64*1024, MEM_RESERVE or MEM_COMMIT, PAGE_READWRITE);
  if (glErrorQueue <> nil) then
    begin
      glClearErrorQueue();
      //
      glUpperLimit:=glErrorQueue;
      Inc(glUpperLimit, (64*1024) div SizeOf(GLenum));
    end;
  {$R+}

finalization
  {$R-}
  glClearErrorQueue();
  if (glErrorQueue <> nil) then VirtualFree(glErrorQueue, 0, MEM_RELEASE);
  {$R+}

end.
