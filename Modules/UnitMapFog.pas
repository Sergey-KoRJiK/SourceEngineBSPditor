unit UnitMapFog;

// Copyright (c) 2019 Sergey Smolovsky, Belarus

interface

uses
  SysUtils, Windows, Classes, OpenGL, UnitVec, UnitEntity;

const
  ClassNameFog = 'env_fog_controller';
  ValueFogStart = 'fogstart'; // Float
  ValueFogEnd = 'fogend';  // Float
  ValueFogDir = 'fogdir'; // Float Vec3
  ValueFogFirstColor = 'fogcolor'; // Byte Vec3
  ValueFogSecondColor = 'fogcolor2'; // Byte Vec3
  ValueFogBlend = 'fogblend';


type CFog = class
  private
    isEnable: Boolean;
    FogStart: GLfloat;
    FogEnd: GLfloat;
    ColorForward: tVec3f;
    ColorBackward: tVec3f;
    Dir: tVec3f;
    isDirDisable: Boolean;
    //
    CurrViewDir: tVec3f;
    CurrBlendFactor: GLfloat; // = (Dot(Dir, ViewDir) + 1)*0.5
    DiffColor: tVec3f;
    CurrColor: array[0..3] of GLfloat;
    //
    procedure SetEnable(const Enable: Boolean);
    procedure SetStartDist(const StartDist: GLfloat);
    procedure SetEndDist(const EndDist: GLfloat);
    procedure SetFogDir(const Dir: tVec3f);
    procedure SetColorForward(const Color: tVec3f);
    procedure SetColorBackward(const Color: tVec3f);
    //
    procedure UpdateBlendFactor();
    procedure UpdateColor();
  public
    property Enable: Boolean read isEnable write SetEnable;
    property StartDist: GLfloat read FogStart write SetStartDist;
    property EndDist: GLfloat read FogEnd write SetEndDist;
    property PrimaryColor: tVec3f read ColorForward write SetColorForward;
    property SecondaryColor: tVec3f read ColorBackward write SetColorBackward;
    property FogDir: tVec3f read Dir write SetFogDir;
    //
    constructor CreateFogDisabled();
    destructor DeleteFog();
    //
    procedure UpdateColorByViewDir(const ViewDir: tVec3f);
    function UpdateFogByEntity(const FogEntity: tEntity): Boolean;
  end;


implementation


procedure CFog.SetEnable(const Enable: Boolean);
begin
  {$R-}
  Self.isEnable:=Enable;
  if (Self.isEnable) then glEnable(GL_FOG) else glDisable(GL_FOG);
  {$R+}
end;

procedure CFog.SetStartDist(const StartDist: GLfloat);
begin
  {$R-}
  Self.FogStart:=StartDist;
  glFogfv(GL_FOG_START, @Self.FogStart);
  {$R+}
end;

procedure CFog.SetEndDist(const EndDist: GLfloat);
begin
  {$R-}
  Self.FogEnd:=EndDist;
  glFogfv(GL_FOG_END, @Self.FogEnd);
  {$R+}
end;

procedure CFog.SetFogDir(const Dir: tVec3f);
begin
  {$R-}
  Self.Dir:=Dir;

  if ((Self.Dir.x = 0) and
    (Self.Dir.y = 0) and
    (Self.Dir.z = 0)) then
    begin
      Self.isDirDisable:=True;
      Self.CurrBlendFactor:=1.0;
    end
  else
    begin
      Self.isDirDisable:=False;
      NormalizeVec3f(@Self.Dir);
      Self.UpdateBlendFactor();
    end;
    
  Self.UpdateColor();
  {$R+}
end;

procedure CFog.SetColorForward(const Color: tVec3f);
begin
  {$R-}
  Self.ColorForward:=Color;

  Self.DiffColor.x:=Self.ColorForward.x - Self.ColorBackward.x;
  Self.DiffColor.y:=Self.ColorForward.y - Self.ColorBackward.y;
  Self.DiffColor.z:=Self.ColorForward.z - Self.ColorBackward.z;

  Self.UpdateColor();
  {$R+}
end;

procedure CFog.SetColorBackward(const Color: tVec3f);
begin
  {$R-}
  Self.ColorBackward:=Color;

  Self.DiffColor.x:=Self.ColorForward.x - Self.ColorBackward.x;
  Self.DiffColor.y:=Self.ColorForward.y - Self.ColorBackward.y;
  Self.DiffColor.z:=Self.ColorForward.z - Self.ColorBackward.z;

  Self.UpdateColor();
  {$R+}
end;

procedure CFog.UpdateBlendFactor();
begin
  {$R-}
  Self.CurrBlendFactor:=(1.0 +
    Self.Dir.x*Self.CurrViewDir.x +
    Self.Dir.y*Self.CurrViewDir.y +
    Self.Dir.z*Self.CurrViewDir.z)*0.5;
  {$R+}
end;

procedure CFog.UpdateColor();
begin
  {$R-}
  Self.CurrColor[0]:=Self.DiffColor.x*Self.CurrBlendFactor + Self.ColorBackward.x;
  Self.CurrColor[1]:=Self.DiffColor.y*Self.CurrBlendFactor + Self.ColorBackward.y;
  Self.CurrColor[2]:=Self.DiffColor.z*Self.CurrBlendFactor + Self.ColorBackward.z;
  glFogfv(GL_FOG_COLOR, @Self.CurrColor[0]);
  {$R+}
end;

constructor CFog.CreateFogDisabled();
begin
  {$R-}
  Self.SetEnable(False);
  glFogi(GL_FOG_MODE, GL_LINEAR);
  //  GL_EXP, GL_EXP2, GL_LINEAR
  // GL_EXP = e^(dens*z); GL_EXP2 = e^((dens*z)^2); GL_LINEAR = (end - z)/(end - start)
  glHint(GL_FOG_HINT, GL_NICEST); // GL_NICEST, GL_FASTEST

  Self.Dir:=VEC_ORT_Z;
  Self.CurrViewDir:=VEC_ORT_Z;
  Self.isDirDisable:=True;
  Self.ColorForward:=VEC_ZERO;
  Self.ColorBackward:=VEC_ZERO;
  Self.DiffColor:=VEC_ZERO;
  Self.CurrBlendFactor:=1.0;

  Self.CurrColor[0]:=0.0;
  Self.CurrColor[1]:=0.0;
  Self.CurrColor[2]:=0.0;
  Self.CurrColor[3]:=0.0;

  // OpenGL in Create Context set default RGBA Color Zeros
  // Set Dafault start = 0 and end = 1, Default Density zero
  Self.FogStart:=0.0;
  Self.FogEnd:=0.0;
  {$R+}
end;

destructor CFog.DeleteFog();
begin
  {$R-}
  glDisable(GL_FOG);
  {$R+}
end;


procedure CFog.UpdateColorByViewDir(const ViewDir: tVec3f);
begin
  {$R-}
  Self.CurrViewDir:=ViewDir;
  NormalizeVec3f(@Self.CurrViewDir);

  if (Self.isDirDisable = False) then Self.UpdateBlendFactor();
  Self.UpdateColor();
  {$R+}
end;

function CFog.UpdateFogByEntity(const FogEntity: tEntity): Boolean;
var
  i: Integer;
  tmpVec: tVec3f;
  tmp: GLfloat;
begin
  {$R-}
  // First check that entities is Fog controller
  if (FogEntity.ClassName <> ClassNameFog) then
    begin
      Result:=False;
      Exit;
    end;

  // Parse fog Dir
  i:=GetPairIndexByKey(FogEntity.Pairs, FogEntity.CountPairs, ValueFogDir);
  if (i >= 0) then
    begin
      if (StrToVec(FogEntity.Pairs[i].Value, @tmpVec)) then
        begin
          NormalizeVec3f(@tmpVec);
          Self.SetFogDir(tmpVec);
        end;
    end;

  // Parse fog Start
  i:=GetPairIndexByKey(FogEntity.Pairs, FogEntity.CountPairs, ValueFogStart);
  if (i >= 0) then
    begin
      try
        tmp:=StrToFloat(StringReplace(FogEntity.Pairs[i].Value, '.', ',', [rfReplaceAll]));
        Self.SetStartDist(tmp);
      finally

      end;
    end;

  // Parse fog End
  i:=GetPairIndexByKey(FogEntity.Pairs, FogEntity.CountPairs, ValueFogEnd);
  if (i >= 0) then
    begin
      try
        tmp:=StrToFloat(StringReplace(FogEntity.Pairs[i].Value, '.', ',', [rfReplaceAll]));
        Self.SetEndDist(tmp);
      finally

      end;
    end;

  // Parse First Color
  i:=GetPairIndexByKey(FogEntity.Pairs, FogEntity.CountPairs, ValueFogFirstColor);
  if (i >= 0) then
    begin
      if (StrToVec(FogEntity.Pairs[i].Value, @tmpVec)) then
        begin
          tmpVec.x:=tmpVec.x/255;
          tmpVec.y:=tmpVec.y/255;
          tmpVec.z:=tmpVec.z/255;
          Self.SetColorForward(tmpVec);
        end;
    end;

  // Parse Second Color
  i:=GetPairIndexByKey(FogEntity.Pairs, FogEntity.CountPairs, ValueFogBlend);
  if (i >= 0) then
    begin
      i:=GetPairIndexByKey(FogEntity.Pairs, FogEntity.CountPairs, ValueFogSecondColor);
      if (i >= 0) then
        begin
          if (StrToVec(FogEntity.Pairs[i].Value, @tmpVec)) then
            begin
              tmpVec.x:=tmpVec.x/255;
              tmpVec.y:=tmpVec.y/255;
              tmpVec.z:=tmpVec.z/255;
              Self.SetColorBackward(tmpVec);
            end;
        end
      else Self.SetColorBackward(Self.ColorForward);
    end
  else Self.SetColorBackward(Self.ColorForward);

  Result:=True;
  {$R+}
end;

end.
