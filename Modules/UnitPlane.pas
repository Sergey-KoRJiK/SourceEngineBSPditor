unit UnitPlane;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

// Plane LUMP doterminate and functions for work with them

interface

uses SysUtils, Windows, Classes, UnitVec;


const	
  // tPlane.AxisType cases:
  // |x| = abs(x), N = Plane Normal;
  // 0-2 are axial planes
  PLANE_X: Integer =    0; // vbsp (map.cpp) set when |N.x| = 0x3f800000;
  PLANE_Y: Integer =    1; // vbsp (map.cpp) set when |N.y| = 0x3f800000;
  PLANE_Z: Integer =    2; // vbsp (map.cpp) set when |N.z| = 0x3f800000;
  // 3-5 are non-axial planes snapped to the nearest
  PLANE_ANYX: Integer = 3; // vbsp (map.cpp) set when |N.x| >= Max(|N.y|, |N.z|);
  PLANE_ANYY: Integer = 4; // vbsp (map.cpp) set when |N.y| >= Max(|N.x|, |N.z|);
  PLANE_ANYZ: Integer = 5; // vbsp (map.cpp) set in other "non-axial plane" cases
  

type tPlane = record
    vNormal: tVec3f;
    fDist: Single;
    AxisType: Integer; // if not in 0..5 - do full tests by Dot3(Normal, Vector3)
  end;
type PPlane = ^tPlane;
type APlane = array of tPlane;


function isPointInFrontPlaneSpace(const Plane: PPlane; const Point: tVec3f): Boolean; overload;
function isPointInFrontPlaneSpace(const Plane: PPlane; const Point: tVec3d): Boolean; overload;
function isPointInFrontPlaneSpaceFull(const Plane: PPlane; const Point: tVec3f): Boolean; overload;
function isPointInFrontPlaneSpaceFull(const Plane: PPlane; const Point: tVec3d): Boolean; overload;
// Full test use only Dot(Normal, Point);
// other test use fast test by AxisType and if failure fast tests use Full Test.

function isRaySeeInFrontPlane(const Plane: tPlane; const Ray: tVec3f): Boolean;
// return True if Dot(Ray.Dir, Plane.Normal) < 0

function GetPlaneByPoints(const V0, V1, V2: tVec3f; const Plane: PPlane): Boolean; overload;
function GetPlaneByPoints(const V0, V1, V2: tVec3d; const Plane: PPlane): Boolean; overload;
// Normal = Cross(V2 - V0, V1 - V0), if Normal is zeros -> return False;


implementation


function isPointInFrontPlaneSpace(const Plane: PPlane; const Point: tVec3f): Boolean;
begin
  {$R-}
  if (Plane.AxisType = PLANE_X) then
    begin
      if (PInteger(@Plane.vNormal.x)^ > 0) then
        begin
          if (Point.x >= Plane.fDist) then isPointInFrontPlaneSpace:=True
          else isPointInFrontPlaneSpace:=False;
          Exit;
        end
      else
        begin
          if (Point.x <= -Plane.fDist) then isPointInFrontPlaneSpace:=True
          else isPointInFrontPlaneSpace:=False;
          Exit;
        end;
    end;

  if (Plane.AxisType = PLANE_Y) then
    begin
      if (PInteger(@Plane.vNormal.y)^ > 0) then
        begin
          if (Point.y >= Plane.fDist) then isPointInFrontPlaneSpace:=True
          else isPointInFrontPlaneSpace:=False;
          Exit;
        end
      else
        begin
          if (Point.y <= -Plane.fDist) then isPointInFrontPlaneSpace:=True
          else isPointInFrontPlaneSpace:=False;
          Exit;
        end;
    end;

  if (Plane.AxisType = PLANE_Z) then
    begin
      if (PInteger(@Plane.vNormal.z)^ > 0) then
        begin
          if (Point.z >= Plane.fDist) then isPointInFrontPlaneSpace:=True
          else isPointInFrontPlaneSpace:=False;
          Exit;
        end
      else
        begin
          if (Point.z <= -Plane.fDist) then isPointInFrontPlaneSpace:=True
          else isPointInFrontPlaneSpace:=False;
          Exit;
        end;
    end;

  if ((Plane.vNormal.x*Point.x + Plane.vNormal.y*Point.y +
    Plane.vNormal.z*Point.z) >= Plane.fDist) then Result:=True else Result:=False;
  {$R+}
end;

function isPointInFrontPlaneSpace(const Plane: PPlane; const Point: tVec3d): Boolean;
begin
  {$R-}
  if (Plane.AxisType = PLANE_X) then
    begin
      if (PInteger(@Plane.vNormal.x)^ > 0) then
        begin
          if (Point.x >= Plane.fDist) then Result:=True
          else Result:=False;
          Exit;
        end
      else
        begin
          if (Point.x <= -Plane.fDist) then Result:=True
          else Result:=False;
          Exit;
        end;
    end;

  if (Plane.AxisType = PLANE_Y) then
    begin
      if (PInteger(@Plane.vNormal.y)^ > 0) then
        begin
          if (Point.y >= Plane.fDist) then Result:=True
          else Result:=False;
          Exit;
        end
      else
        begin
          if (Point.y <= -Plane.fDist) then Result:=True
          else Result:=False;
          Exit;
        end;
    end;

  if (Plane.AxisType = PLANE_Z) then
    begin
      if (PInteger(@Plane.vNormal.z)^ > 0) then
        begin
          if (Point.z >= Plane.fDist) then Result:=True
          else Result:=False;
          Exit;
        end
      else
        begin
          if (Point.z <= -Plane.fDist) then Result:=True
          else Result:=False;
          Exit;
        end;
    end;

  if ((Plane.vNormal.x*Point.x + Plane.vNormal.y*Point.y +
    Plane.vNormal.z*Point.z) >= Plane.fDist) then Result:=True else Result:=False;
  {$R+}
end;


function isPointInFrontPlaneSpaceFull(const Plane: PPlane; const Point: tVec3f): Boolean;
begin
  {$R-}
  if ((Plane.vNormal.x*Point.x + Plane.vNormal.y*Point.y +
    Plane.vNormal.z*Point.z) >= Plane.fDist) then
    begin
      isPointInFrontPlaneSpaceFull:=True;
    end
  else
    begin
      isPointInFrontPlaneSpaceFull:=False;
    end;
  {$R+}
end;

function isPointInFrontPlaneSpaceFull(const Plane: PPlane; const Point: tVec3d): Boolean;
begin
  {$R-}
  if ((Plane.vNormal.x*Point.x + Plane.vNormal.y*Point.y +
    Plane.vNormal.z*Point.z) >= Plane.fDist) then
    begin
      isPointInFrontPlaneSpaceFull:=True;
    end
  else
    begin
      isPointInFrontPlaneSpaceFull:=False;
    end;
  {$R+}
end;


function isRaySeeInFrontPlane(const Plane: tPlane; const Ray: tVec3f): Boolean;
begin
  {$R-}
  if ((Plane.vNormal.x*Ray.x + Plane.vNormal.y*Ray.y + Plane.vNormal.z*Ray.z) < 0)
  then isRaySeeInFrontPlane:=True else isRaySeeInFrontPlane:=False;
  {$R+}
end;

function GetPlaneByPoints(const V0, V1, V2: tVec3f; const Plane: PPlane): Boolean;
var
  Edge1, Edge2: tVec3f;
begin
  {$R-}
  // Get Edges
  Edge1.x:=V1.x - V0.x;
  Edge1.y:=V1.y - V0.y;
  Edge1.z:=V1.z - V0.z;

  Edge2.x:=V2.x - V0.x;
  Edge2.y:=V2.y - V0.y;
  Edge2.z:=V2.z - V0.z;

  // Get Normal by Cross(Edge2, Edge1);
  Plane.vNormal.x:=Edge2.y*Edge1.z - Edge2.z*Edge1.y;
  Plane.vNormal.y:=Edge2.z*Edge1.x - Edge2.x*Edge1.z;
  Plane.vNormal.z:=Edge2.x*Edge1.y - Edge2.y*Edge1.x;

  // Normalize plane end check if normal is zeros
  if (NormalizeVec3f(@Plane.vNormal) = False) then
    begin
      // Triple Points V0..2 is bad, belong to both line.
      GetPlaneByPoints:=False;
      Exit;
    end;

  // Get fourth parameter of Plane Equation
  Plane.fDist:=Plane.vNormal.x*V0.x + Plane.vNormal.y*V0.y + Plane.vNormal.z*V0.z;

  // dont get AxisType, set default
  Plane.AxisType:=PLANE_ANYZ;
  Result:=True;
  {$R+}
end;

function GetPlaneByPoints(const V0, V1, V2: tVec3d; const Plane: PPlane): Boolean; overload;
var
  Edge1, Edge2: tVec3f;
begin
  {$R-}
  // Get Edges
  Edge1.x:=V1.x - V0.x;
  Edge1.y:=V1.y - V0.y;
  Edge1.z:=V1.z - V0.z;

  Edge2.x:=V2.x - V0.x;
  Edge2.y:=V2.y - V0.y;
  Edge2.z:=V2.z - V0.z;

  // Get Normal
  Cross(@Edge2, @Edge1, @Plane.vNormal);

  // Normalize plane end check if normal is zeros
  if (NormalizeVec3f(@Plane.vNormal) = False) then
    begin
      // Triple Points V0..2 is bad, belong to both line.
      GetPlaneByPoints:=False;
      Exit;
    end; //}

  // Get fourth parameter of Plane Equation
  Plane.fDist:=Plane.vNormal.x*V0.x + Plane.vNormal.y*V0.y + Plane.vNormal.z*V0.z;

  // dont get AxisType, set default
  Plane.AxisType:=PLANE_ANYZ;
  Result:=True;
  {$R+}
end;

end.
