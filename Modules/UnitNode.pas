unit UnitNode;

// Copyright (c) 2019 Sergey Smolovsky, Belarus

// NODE Tree LUMP

interface

uses SysUtils, Windows, Classes, UnitVec, UnitPlane;

type tNode = record
    iPlane: Integer;
    iChildren: array[0..1] of Integer;
    nMin, nMax: tVec3s; //BBOX
    firstFace, nFaces: WORD;
    Area: SmallInt;
    Padding: SmallInt;
  end;
type PNode = ^tNode;
type ANode = array of tNode;

// Note Tree elements
type tNodeInfo = record
    Plane: tPlane;
    BBOXf: tBBOXf;
    BBOXs: tBBOXs;
    IsFrontNode: Boolean;
    IsBackNode: Boolean;
    FrontIndex: Integer;
    BackIndex: Integer;
    // Primary Node Child's Addres
    lpFrontNodeInfo: Pointer;
    lpBackNodeInfo: Pointer;
    lpFrontLeafInfo: Pointer;
    lpBackLeafInfo: Pointer;
  end;
type PNodeInfo = ^tNodeInfo;
type ANodeInfo = array of tNodeInfo;

function TestGoodNodeBBOX(const Node: PNode): Boolean;
function isLeafChildrenId0(const Node: PNode): Boolean;
function isLeafChildrenId1(const Node: PNode): Boolean;
function GetIndexLeafChildrenId0(const Node: PNode): Integer;
function GetIndexLeafChildrenId1(const Node: PNode): Integer;

function TestPointInNode(const Node: PNode; const Point: PVec3f): boolean; overload;
function TestPointInNode(const Node: PNode; const Point: PVec3s): boolean; overload;


implementation


function TestGoodNodeBBOX(const Node: PNode): Boolean;
begin
  {$R-}
  TestGoodNodeBBOX:=False;
  if (Node.nMin.x > Node.nMax.x) then Exit;
  if (Node.nMin.y > Node.nMax.y) then Exit;
  if (Node.nMin.z > Node.nMax.z) then Exit;
  TestGoodNodeBBOX:=True;
  {$R+}
end;

function isLeafChildrenId0(const Node: PNode): Boolean;
begin
  {$R-}
  if (Node.iChildren[0] <= 0) then isLeafChildrenId0:=True
  else isLeafChildrenId0:=False;
  {$R+}
end;

function isLeafChildrenId1(const Node: PNode): Boolean;
begin
  {$R-}
  if (Node.iChildren[1] <= 0) then isLeafChildrenId1:=True
  else isLeafChildrenId1:=False;
  {$R+}
end;

function GetIndexLeafChildrenId0(const Node: PNode): Integer;
begin
  {$R-}
  GetIndexLeafChildrenId0:=Integer(-Node.iChildren[0] - 1);
  {$R+}
end;

function GetIndexLeafChildrenId1(const Node: PNode): Integer;
begin
  {$R-}
  GetIndexLeafChildrenId1:=Integer(-Node.iChildren[1] - 1);
  {$R+}
end;

function TestPointInNode(const Node: PNode; const Point: PVec3f): boolean; overload;
begin
  {$R-}
  TestPointInNode:=False;
  if (Point.x < Node.nMin.x) then Exit;
  if (Point.y < Node.nMin.y) then Exit;
  if (Point.z < Node.nMin.z) then Exit;
  if (Point.x > Node.nMax.x) then Exit;
  if (Point.y > Node.nMax.y) then Exit;
  if (Point.z > Node.nMax.z) then Exit;
  TestPointInNode:=True;
  {$R+}
end;

function TestPointInNode(const Node: PNode; const Point: PVec3s): boolean; overload;
begin
  {$R-}
  TestPointInNode:=False;
  if (Point.x < Node.nMin.x) then Exit;
  if (Point.y < Node.nMin.y) then Exit;
  if (Point.z < Node.nMin.z) then Exit;
  if (Point.x > Node.nMax.x) then Exit;
  if (Point.y > Node.nMax.y) then Exit;
  if (Point.z > Node.nMax.z) then Exit;
  TestPointInNode:=True;
  {$R+}
end;

end.
