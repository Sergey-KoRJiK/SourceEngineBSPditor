unit UnitToneMapControl;

// Copyright (c) 2019 Sergey Smolovsky, Belarus

// Used for Linear ToneMap HDR to LDR of Lightmaps in 3D pre-view;

interface

uses
  SysUtils, Windows, Classes, UnitVec;

procedure ApplyLinearToneMap(const lpVec3f: PVec3f; const lpScale: PSingle);


implementation


procedure ApplyLinearToneMap(const lpVec3f: PVec3f; const lpScale: PSingle);
const
  StandartGamma: Single = 1.0/2.2;
begin
  {$R-}
  // Power(Base, Exponent) = Exp(Exponent * Ln(Base)
  // a^b = Exp^(b * Ln(a))
  lpVec3f.x:=Exp(Ln(lpVec3f.x*lpScale^) * StandartGamma);
  lpVec3f.y:=Exp(Ln(lpVec3f.y*lpScale^) * StandartGamma);
  lpVec3f.z:=Exp(Ln(lpVec3f.z*lpScale^) * StandartGamma);
  {$R+}
end;

end.
