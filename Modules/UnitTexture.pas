unit UnitTexture;

// Copyright (c) 2019 Sergey Smolovsky, Belarus

// For render Lightmap Textures

interface

uses SysUtils, Windows, Classes, UnitVec;

type TexInfoVecs = record
    SX, SY, SZ, OffsetS: Single;
    TX, TY, TZ, OffsetT: Single;
  end;

type tTexInfo = record
    Tex: TexInfoVecs;   // [s/t][xyz offset]
    Lmp: TexInfoVecs;   // [s/t][xyz offset] - length is in units of texels/area
    { [U, V], getted by TexInfoVecs need next divide
      by Width and Height of Texture/Ligtmap for normalize U and V by [0..1]}
    //
    nFlags: Integer; // usually = 0
    iMipTex: Integer;
  end;
type PTexInfo = ^tTexInfo;
type ATexInfo = array of tTexInfo;

const
  TexInfoSize = SizeOf(tTexInfo);
  // TexInfo Flags:
  SurfLight: Integer = $0001;     // value will hold the light strength
  SurfSky2D: Integer = $0002;     // don't draw
  SurfSky: Integer = $0004;       // don't draw
  SurfWarp: Integer = $0008;      // turbulent water warp
  SurfAlpha: Integer = $0010;     // texture is translucent
  SurfNoPortal: Integer = $0020;  // the surface can not have a portal placed on it
  SurfTrigger: Integer = $0040;   // Xbox
  SurfNodraw: Integer = $0080;    // don't bother referencing the texture
  SurfHint: Integer = $0100;      // make a primary bsp splitter
  SurfSkip: Integer = $0200;      // completely ignore, allowing non-closed brushes
  SurfNoLight: Integer = $0400;     // Don't calculate light
  SurfBump: Integer = $0800;      // calculate three lightmaps for bumpmapping
  SurfNoShadows: Integer = $1000; // Don't receive shadows
  SurfNoDecals: Integer = $2000;  // Don't receive decals
  SurfNoChop: Integer = $4000;    // Don't subdivide patches on this surface
  SurfHitBox: Integer = $8000;    // surface is part of a hitbox

procedure GetTexureCoordST(const lpVertex: PVec3f; const lpTexInfo: PTexInfo;
  const lpTexCoord: PVec2f);
procedure GetLightmapCoordST(const lpVertex: PVec3f; const lpTexInfo: PTexInfo;
  const lpLmpCoord: PVec2f);


implementation


procedure GetTexureCoordST(const lpVertex: PVec3f; const lpTexInfo: PTexInfo;
  const lpTexCoord: PVec2f);
begin
  {$R-}
  lpTexCoord.x:=lpVertex.X*lpTexInfo.Tex.SX + lpVertex.Y*lpTexInfo.Tex.SY +
    lpVertex.Z*lpTexInfo.Tex.SZ + lpTexInfo.Tex.OffsetS;

  lpTexCoord.y:=lpVertex.X*lpTexInfo.Tex.TX + lpVertex.Y*lpTexInfo.Tex.TY +
    lpVertex.Z*lpTexInfo.Tex.TZ + lpTexInfo.Tex.OffsetT;
  {$R+}
end;

procedure GetLightmapCoordST(const lpVertex: PVec3f; const lpTexInfo: PTexInfo;
  const lpLmpCoord: PVec2f);
begin
  {$R-}
  lpLmpCoord.x:=lpVertex.X*lpTexInfo.Lmp.SX + lpVertex.Y*lpTexInfo.Lmp.SY +
    lpVertex.Z*lpTexInfo.Lmp.SZ + lpTexInfo.Lmp.OffsetS;

  lpLmpCoord.y:=lpVertex.X*lpTexInfo.Lmp.TX + lpVertex.Y*lpTexInfo.Lmp.TY +
    lpVertex.Z*lpTexInfo.Lmp.TZ + lpTexInfo.Lmp.OffsetT;
  {$R+}
end;

end.
