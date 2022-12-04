unit UnitVisLeaf;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

interface

uses SysUtils, Windows, Classes, UnitVec;

const CONTENTS_NORMAL: Integer = 0;
const CONTENTS_EMPTY: Integer = 1;
const CONTENTS_SOLID: Integer = 2;
const CONTENTS_WATER: Integer = 3;
const CONTENTS_SLIME: Integer = 4;
const CONTENTS_LAVA: Integer = 5;
const CONTENTS_SKY: Integer = 6;
const CONTENTS_ORIGIN: Integer = 7;
const CONTENTS_CLIP: Integer = 8;
const CONTENTS_CURRENT_0: Integer = 9;
const CONTENTS_CURRENT_90: Integer = 10;
const CONTENTS_CURRENT_180: Integer = 11;
const CONTENTS_CURRENT_270: Integer = 12;
const CONTENTS_CURRENT_UP: Integer = 13;
const CONTENTS_CURRENT_DOWN: Integer = 14;
const CONTENTS_TRANSLUCENT: Integer = 15;

type tVisLeaf = record
    nContents: Integer;
    nClusterId: SmallInt;
    AreaFlags: SmallInt;
    nMin, nMax: tVec3s; //BBOX
    iFirstMarkSurface, nMarkSurfaces: SmallInt;
    iFirstMarkBrush, nMarkBrushes: SmallInt;
    leafWaterDataID: SmallInt; // -1 if not in water
    Padding: SmallInt;
  end;
type PVisLeaf = ^tVisLeaf;
type AVisLeaf = array of tVisLeaf;

// tVisLeaf is bad for use data for fast render
// tVisLeafInfo contain pre-calculated data for fast render and culling

type tVisLeafInfo = record
    isValidToRender: Boolean;
    BBOXf: tBBOXf; // additional BBOX with Float Vectors
    BBOXs: tBBOXs; // original Visleaf BBOX with int16 Vectors
    CountFaces: Integer;
    FaceInfoIndex: AInt; // list of WorldBrush Faces
    CountEntBrushes: Integer;
    EntBrushIndex: AInt; // list of EntityBrush Faces
    CountDisplaments: Integer; 
    DispIndex: AInt; // list if Displacements
    CountPVS: Integer;
    PVS: AByteBool; // Leaf Visibility Table for this Leaf
  end;
type PVisLeafInfo = ^tVisLeafInfo;
type AVisLeafInfo = array of tVisLeafInfo;

function TestGoodLeafBBOX(const Leaf: tVisLeaf): Boolean;
function IsGoodLeafContents(const Leaf: tVisLeaf): Boolean;

function TestPointInVisLeaf(const Leaf: tVisLeaf; const Point: tVec3f): Boolean; overload;
function TestPointInVisLeaf(const Leaf: tVisLeaf; const Point: tVec3s): Boolean; overload;
function TestPointInVisLeafInfo(const lpLeafInfo: PVisLeafInfo; const Point: tVec3d): Boolean;


implementation


function TestGoodLeafBBOX(const Leaf: tVisLeaf): Boolean;
begin
  {$R-}
  TestGoodLeafBBOX:=False;
  with Leaf do
    begin
      if (nMin.x > nMax.x) then Exit;
      if (nMin.y > nMax.y) then Exit;
      if (nMin.z > nMax.z) then Exit;
    end;
  TestGoodLeafBBOX:=True;
  {$R+}
end;

function IsGoodLeafContents(const Leaf: tVisLeaf): Boolean;
begin
  {$R-}
  if ( (Leaf.nContents > 1) and (Leaf.nContents < 15) )
  then IsGoodLeafContents:=False else IsGoodLeafContents:=True;
  {$R+}
end;

function TestPointInVisLeaf(const Leaf: tVisLeaf; const Point: tVec3f): Boolean;
begin
  {$R-}
  TestPointInVisLeaf:=False;
  with Leaf do
    begin
      if (Point.x <= nMin.x) then Exit;
      if (Point.y <= nMin.y) then Exit;
      if (Point.z <= nMin.z) then Exit;
      if (Point.x >= nMax.x) then Exit;
      if (Point.y >= nMax.y) then Exit;
      if (Point.z >= nMax.z) then Exit;
    end;
  TestPointInVisLeaf:=True;
  {$R+}
end;

function TestPointInVisLeaf(const Leaf: tVisLeaf; const Point: tVec3s): Boolean;
begin
  {$R-}
  TestPointInVisLeaf:=False;
  with Leaf do
    begin
      if (Point.x <= nMin.x) then Exit;
      if (Point.y <= nMin.y) then Exit;
      if (Point.z <= nMin.z) then Exit;
      if (Point.x >= nMax.x) then Exit;
      if (Point.y >= nMax.y) then Exit;
      if (Point.z >= nMax.z) then Exit;
    end;
  TestPointInVisLeaf:=True;
  {$R+}
end;

function TestPointInVisLeafInfo(const lpLeafInfo: PVisLeafInfo; const Point: tVec3d): Boolean;
begin
  {$R-}
  TestPointInVisLeafInfo:=False;
  if (Point.x <= lpLeafInfo.BBOXf.vMin.x) then Exit;
  if (Point.y <= lpLeafInfo.BBOXf.vMin.y) then Exit;
  if (Point.z <= lpLeafInfo.BBOXf.vMin.z) then Exit;
  if (Point.x >= lpLeafInfo.BBOXf.vMax.x) then Exit;
  if (Point.y >= lpLeafInfo.BBOXf.vMax.y) then Exit;
  if (Point.z >= lpLeafInfo.BBOXf.vMax.z) then Exit;
  TestPointInVisLeafInfo:=True;
  {$R+}
end;

end.
