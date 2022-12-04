unit UnitBrushModel;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

interface

uses SysUtils, Windows, Classes, UnitVec, OpenGL;

type tBrushModel = record
    vMin, vMax: tVec3f;
    Origin: tVec3f;
    iNode: Integer;
    iFirstFace, nFaces: Integer; // Primary to Face array
  end;
type PBrushModel = ^tBrushModel;
type ABrushModel = array of tBrushModel;

type tBrushModelInfo = record
    isBrushWithEntityOrigin: Boolean;
    isBrushWithNonZeroOrigin: Boolean;
    Origin: tVec3f;
    EntityId: Integer;
    BBOXf: tBBOXf;
  end;
type PBrushModelInfo = ^tBrushModelInfo;
type ABrushModelInfo = array of tBrushModelInfo;

function TestGoodBrushModelBBOX(const Brush: tBrushModel): Boolean;

function TestPointInBrush(const Brush: tBrushModel; const Point: tVec3f): boolean; overload;
function TestPointInBrush(const Brush: tBrushModel; const Point: tVec3s): boolean; overload;


implementation


function TestGoodBrushModelBBOX(const Brush: tBrushModel): Boolean;
begin
  {$R-}
  TestGoodBrushModelBBOX:=False;
  with Brush do
    begin
      if (vMin.x > vMax.x) then Exit;
      if (vMin.y > vMax.y) then Exit;
      if (vMin.z > vMax.z) then Exit;
    end;
  TestGoodBrushModelBBOX:=True;
  {$R+}
end;

function TestPointInBrush(const Brush: tBrushModel; const Point: tVec3f): boolean; overload;
begin
  {$R-}
  TestPointInBrush:=False;
  with Brush do
    begin
      if (Point.x < vMin.x) then Exit;
      if (Point.y < vMin.y) then Exit;
      if (Point.z < vMin.z) then Exit;
      if (Point.x > vMax.x) then Exit;
      if (Point.y > vMax.y) then Exit;
      if (Point.z > vMax.z) then Exit;
    end;
  TestPointInBrush:=True;
  {$R+}
end;

function TestPointInBrush(const Brush: tBrushModel; const Point: tVec3s): boolean; overload;
begin
  {$R-}
  TestPointInBrush:=False;
  with Brush do
    begin
      if (Point.x < vMin.x) then Exit;
      if (Point.y < vMin.y) then Exit;
      if (Point.z < vMin.z) then Exit;
      if (Point.x > vMax.x) then Exit;
      if (Point.y > vMax.y) then Exit;
      if (Point.z > vMax.z) then Exit;
    end;
  TestPointInBrush:=True;
  {$R+}
end;

end.
