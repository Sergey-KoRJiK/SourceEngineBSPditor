unit UnitClipNode;

// Copyright (c) 2019 Sergey Smolovsky, Belarus

interface

uses SysUtils, Windows, Classes, UnitVec;

type eClipNodeCollision = (cnSolid = -2, cnNonSolid = -1);

type tClipNode = record
    iPlane: DWORD;
    iChildren: array[0..1] of SmallInt;
  end;
type AClipNode = array of tClipNode;

function ShowClipNodeInfo(const ClipNode: tClipNode): String;
procedure SaveClipNodesToTextFile(const FileName: String; const ClipNodes: AClipNode; const Count: Integer);

implementation

function ShowClipNodeInfo(const ClipNode: tClipNode): String;
begin
  {$R-}
  Result:=
    '   Plane Index = ' + IntToStr(ClipNode.iPlane) + CRLF +
    '   Children[0] is ';
  case ClipNode.iChildren[0] of
    -1: Result:=Result + 'null' + CRLF;
    -2: Result:=Result + 'null' + CRLF;
  else
    Result:=Result + 'Front ClipNode with Index ' + IntToStr(ClipNode.iChildren[0]) + CRLF;
  end;
  Result:=Result + '   Children[1] is ';
  case ClipNode.iChildren[1] of
    -1: Result:=Result + 'null' + CRLF;
    -2: Result:=Result + 'null' + CRLF;
  else
    Result:=Result + 'Back ClipNode with Index ' + IntToStr(ClipNode.iChildren[0]) + CRLF;
  end;

  case ClipNode.iChildren[0] of
    -1: Result:=Result + '    Front part Solid' + CRLF;
    -2: Result:=Result + '    Front part NonSolid' + CRLF;
  end;
  case ClipNode.iChildren[1] of
    -1: Result:=Result + '    Back part Solid' + CRLF;
    -2: Result:=Result + '    Back part NonSolid' + CRLF;
  end;
  {$R+}
end;

procedure SaveClipNodesToTextFile(const FileName: String; const ClipNodes: AClipNode; const Count: Integer);
var
  ClipNodeFile: TextFile;
  i: Integer;
begin
  {$R-}
  AssignFile(ClipNodeFile, FileName);
  Rewrite(ClipNodeFile);

  Writeln(ClipNodeFile, ' Total Count Clip Nodes = ', Count);
  Writeln(ClipNodeFile, '');
  For i:=0 to Count-1 do
    begin
      Writeln(ClipNodeFile, 'Clip Node Index ', i, ': ');
      Writeln(ClipNodeFile, ShowClipNodeInfo(ClipNodes[i]));
      Writeln(ClipNodeFile, '');
    end;

  CloseFile(ClipNodeFile);
  {$R+}
end;

end.
 