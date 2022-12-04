unit UnitVertex;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

interface

uses SysUtils, Windows, Classes, UnitVec;

type tVertex = tVec3f;
type AVertex = array of tVertex;

function ShowVertexInfo(const Vertex: tVertex): String;
procedure SaveVerteciesToTextFile(const FileName: String; const Vertecies: AVertex; const CountVertex: Integer);

implementation

function ShowVertexInfo(const Vertex: tVertex): String;
begin
  {$R-}
  Result:='   Pos' + VecToStr(Vertex) + CRLF;
  {$R+}
end;

procedure SaveVerteciesToTextFile(const FileName: String; const Vertecies: AVertex; const CountVertex: Integer);
var
  i: Integer;
  VertFile: TextFile;
begin
  {$R-}
  AssignFile(VertFile, FileName);
  Rewrite(VertFile);
  Writeln(VertFile, 'Total Count Vertecies = ', CountVertex);
  for i:=0 to CountVertex-1 do
    begin
      Writeln(VertFile, VecToStr(Vertecies[i]));
    end;
  CloseFile(VertFile);
  {$R+}
end;

end.
 
