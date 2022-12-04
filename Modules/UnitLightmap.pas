unit UnitLightmap;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

interface

uses
  SysUtils,
  Windows,
  Classes,
  Math,
  UnitVec;

type tLightmapColor = record
    r, g, b: Byte;
    e: ShortInt;
  end;
type PLightmapColor = ^tLightmapColor;
type ALightmapColor = array of tLightmapColor;

type eLmpState = (NoLight = 0, OnlyLDR, OnlyHDR, BothLight);

const
  LightmapColorSize = SizeOf(tLightmapColor);
  // table of Pow(2.0, Index) from Index = -128 to 127
  // pow(2.0, Index) = Exp(Index * Ln(2))
  ScalerTable: array[0..255] of Double = (
    1.152445442E-41, 2.304890884E-41, 4.609781768E-41,
		9.219563536E-41, 1.843912707E-40, 3.687825414E-40, 
		7.375650829E-40, 1.475130166E-39, 2.950260331E-39, 
		5.900520663E-39, 1.180104133E-38, 2.360208265E-38, 
		4.72041653E-38, 9.440833061E-38, 1.888166612E-37, 
		3.776333224E-37, 7.552666449E-37, 1.51053329E-36, 
		3.021066579E-36, 6.042133159E-36, 1.208426632E-35, 
		2.416853264E-35, 4.833706527E-35, 9.667413054E-35, 
		1.933482611E-34, 3.866965222E-34, 7.733930443E-34, 
		1.546786089E-33, 3.093572177E-33, 6.187144355E-33, 
		1.237428871E-32, 2.474857742E-32, 4.949715484E-32, 
		9.899430967E-32, 1.979886193E-31, 3.959772387E-31, 
		7.919544774E-31, 1.583908955E-30, 3.16781791E-30, 
		6.335635819E-30, 1.267127164E-29, 2.534254328E-29, 
		5.068508655E-29, 1.013701731E-28, 2.027403462E-28, 
		4.054806924E-28, 8.109613849E-28, 1.62192277E-27, 
		3.243845539E-27, 6.487691079E-27, 1.297538216E-26, 
		2.595076432E-26, 5.190152863E-26, 1.038030573E-25, 
		2.076061145E-25, 4.15212229E-25, 8.304244581E-25, 
		1.660848916E-24, 3.321697832E-24, 6.643395665E-24, 
		1.328679133E-23, 2.657358266E-23, 5.314716532E-23, 
		1.062943306E-22, 2.125886613E-22, 4.251773225E-22, 
		8.503546451E-22, 1.70070929E-21, 3.40141858E-21, 
		6.802837161E-21, 1.360567432E-20, 2.721134864E-20, 
		5.442269729E-20, 1.088453946E-19, 2.176907891E-19, 
		4.353815783E-19, 8.707631566E-19, 1.741526313E-18, 
		3.483052626E-18, 6.966105253E-18, 1.393221051E-17, 
		2.786442101E-17, 5.572884202E-17, 1.11457684E-16, 
		2.229153681E-16, 4.458307362E-16, 8.916614723E-16, 
		1.783322945E-15, 3.566645889E-15, 7.133291779E-15, 
		1.426658356E-14, 2.853316711E-14, 5.706633423E-14, 
		1.141326685E-13, 2.282653369E-13, 4.565306738E-13, 
		9.130613477E-13, 1.826122695E-12, 3.652245391E-12, 
		7.304490781E-12, 1.460898156E-11, 2.921796313E-11, 
		5.843592625E-11, 1.168718525E-10, 2.33743705E-10, 
		4.6748741E-10, 9.3497482E-10, 1.86994964E-9, 
		3.73989928E-9, 7.47979856E-9, 1.495959712E-8, 
		2.991919424E-8, 5.983838848E-8, 1.19676777E-7, 
		2.393535539E-7, 4.787071078E-7, 9.574142157E-7, 
		1.914828431E-6, 3.829656863E-6, 7.659313725E-6, 
		0.00001531862745, 0.0000306372549, 0.0000612745098, 0.0001225490196, 
		0.0002450980392, 0.0004901960784, 0.0009803921569, 0.001960784314, 
		0.003921568627, 0.007843137255, 0.01568627451, 0.03137254902, 
		0.06274509804, 0.1254901961, 0.2509803922, 0.5019607843, 1.003921569, 
		2.007843137, 4.015686275, 8.031372549, 16.0627451, 32.1254902, 
		64.25098039, 128.5019608, 257.0039216, 514.0078431, 1028.015686, 
		2056.031373, 4112.062745, 8224.12549, 16448.25098, 32896.50196, 
		65793.00392, 131586.0078, 263172.0157, 526344.0314, 1.052688063E6, 
		2.105376125E6, 4.210752251E6, 8.421504502E6, 1.6843009E7, 
		3.368601801E7, 6.737203602E7, 1.34744072E8, 
		2.694881441E8, 5.389762881E8, 1.077952576E9, 
		2.155905153E9, 4.311810305E9, 8.62362061E9, 
		1.724724122E10, 3.449448244E10, 6.898896488E10, 
		1.379779298E11, 2.759558595E11, 5.51911719E11, 
		1.103823438E12, 2.207646876E12, 4.415293752E12, 
		8.830587505E12, 1.766117501E13, 3.532235002E13, 
		7.064470004E13, 1.412894001E14, 2.825788001E14, 
		5.651576003E14, 1.130315201E15, 2.260630401E15, 
		4.521260802E15, 9.042521605E15, 1.808504321E16, 
		3.617008642E16, 7.234017284E16, 1.446803457E17, 
		2.893606914E17, 5.787213827E17, 1.157442765E18, 
		2.314885531E18, 4.629771062E18, 9.259542123E18, 
		1.851908425E19, 3.703816849E19, 7.407633699E19, 
		1.48152674E20, 2.963053479E20, 5.926106959E20, 
		1.185221392E21, 2.370442784E21, 4.740885567E21, 
		9.481771134E21, 1.896354227E22, 3.792708454E22, 
		7.585416907E22, 1.517083381E23, 3.034166763E23, 
		6.068333526E23, 1.213666705E24, 2.42733341E24, 
		4.854666821E24, 9.709333641E24, 1.941866728E25, 
		3.883733457E25, 7.767466913E25, 1.553493383E26, 
		3.106986765E26, 6.213973531E26, 1.242794706E27, 
		2.485589412E27, 4.971178824E27, 9.942357649E27, 
		1.98847153E28, 3.97694306E28, 7.953886119E28, 
		1.590777224E29, 3.181554448E29, 6.363108895E29, 
		1.272621779E30, 2.545243558E30, 5.090487116E30, 
		1.018097423E31, 2.036194846E31, 4.072389693E31, 
		8.144779386E31, 1.628955877E32, 3.257911754E32, 
		6.515823509E32, 1.303164702E33, 2.606329403E33, 
		5.212658807E33, 1.042531761E34, 2.085063523E34, 
		4.170127046E34, 8.340254091E34, 1.668050818E35, 
		3.336101636E35, 6.672203273E35
  );


procedure RGBExpToVec3f(const lpRGBE: PLightmapColor; const lpVecHDR: PVec3f);
procedure RGBExpToVec3f_Add(const lpRGBE: PLightmapColor; const lpVecHDR: PVec3f);
procedure Vec3fToRGBExp(const lpRGBE: PLightmapColor; const lpVecHDR: PVec3f);

function LightmapToStr(const RGBE: tLightmapColor): String;

procedure GetAverageRGBExp32(const lpLightmaps, lpAverage: PLightmapColor;
  const LmpSize: TPoint);


implementation


procedure RGBExpToVec3f(const lpRGBE: PLightmapColor; const lpVecHDR: PVec3f);
begin
  {$R-}
  lpVecHDR.x:=lpRGBE.r*ScalerTable[lpRGBE.e + 128];
  lpVecHDR.y:=lpRGBE.g*ScalerTable[lpRGBE.e + 128];
  lpVecHDR.z:=lpRGBE.b*ScalerTable[lpRGBE.e + 128];
  {$R+}
end;

procedure RGBExpToVec3f_Add(const lpRGBE: PLightmapColor; const lpVecHDR: PVec3f);
begin
  {$R-}
  lpVecHDR.x:=lpVecHDR.x + lpRGBE.r*ScalerTable[lpRGBE.e + 128];
  lpVecHDR.y:=lpVecHDR.y + lpRGBE.g*ScalerTable[lpRGBE.e + 128];
  lpVecHDR.z:=lpVecHDR.z + lpRGBE.b*ScalerTable[lpRGBE.e + 128];
  {$R+}
end;

procedure Vec3fToRGBExp(const lpRGBE: PLightmapColor; const lpVecHDR: PVec3f);
var
  MaxVal: Double;
  Mant: Extended;
  tmp: Integer;
begin
  {$R-}
  MaxVal:=lpVecHDR.x;
  if (lpVecHDR.y > MaxVal) then MaxVal:=lpVecHDR.y;
  if (lpVecHDR.z > MaxVal) then MaxVal:=lpVecHDR.z;

  if (MaxVal < 1E-32) then
    begin
      PDWORD(lpRGBE)^:=0;
    end
  else
    begin
      Math.Frexp(MaxVal, Mant, tmp);

      //Dec(tmp, 8);
      if (tmp > 127) then lpRGBE.e:=127 else lpRGBE.e:=tmp;
      if (tmp < -128) then lpRGBE.e:=-128 else lpRGBE.e:=tmp;

      MaxVal:=Mant*255/MaxVal;
      lpRGBE.r:=Round(lpVecHDR.x*MaxVal);
      lpRGBE.g:=Round(lpVecHDR.y*MaxVal);
      lpRGBE.b:=Round(lpVecHDR.z*MaxVal);
    end;
  {$R+}
end;


function LightmapToStr(const RGBE: tLightmapColor): String;
begin
  {$R-}
  Result:=IntToStr(RGBE.r) + ',  ' + IntToStr(RGBE.g) + ',  '
    + IntToStr(RGBE.b) + ',  ' + IntToStr(RGBE.e);
  {$R+}
end;


procedure GetAverageRGBExp32(const lpLightmaps, lpAverage: PLightmapColor;
  const LmpSize: TPoint);
const
  Half: Single = 0.5;
var
  i, j, Count: Integer;
  AccVec: tVec3f;
  tmpScaler: Single;
begin
  {$R-}
  Count:=LmpSize.X*LmpSize.Y;
  if (Count <= 0) then Exit;
  AccVec:=VEC_ZERO;

  // First Add Corner Lightmaps
  RGBExpToVec3f_Add(@ALightmapColor(lpLightmaps)[0], @AccVec);
  RGBExpToVec3f_Add(@ALightmapColor(lpLightmaps)[Count - 1], @AccVec);
  RGBExpToVec3f_Add(@ALightmapColor(lpLightmaps)[LmpSize.X - 1], @AccVec);
  RGBExpToVec3f_Add(@ALightmapColor(lpLightmaps)[(LmpSize.Y - 1)*LmpSize.X], @AccVec);
  ScaleVec(@AccVec, @AccVec, @Half);

  // Add Border Lightmaps without Corner
  i:=(LmpSize.Y - 1)*LmpSize.X;
  for j:=1 to (LmpSize.X - 2) do
    begin
      RGBExpToVec3f_Add(@ALightmapColor(lpLightmaps)[j], @AccVec);
      RGBExpToVec3f_Add(@ALightmapColor(lpLightmaps)[i + j], @AccVec);
    end;
  j:=LmpSize.X;
  for i:=1 to (LmpSize.Y - 2) do
    begin
      RGBExpToVec3f_Add(@ALightmapColor(lpLightmaps)[j], @AccVec);
      Inc(j, LmpSize.X - 1);
      RGBExpToVec3f_Add(@ALightmapColor(lpLightmaps)[j], @AccVec);
      Inc(j);
    end;
  ScaleVec(@AccVec, @AccVec, @Half);

  // Add Middle Box Lightmaps
  for i:=1 to (LmpSize.Y - 2) do
    begin
      Count:=i*LmpSize.X;
      for j:=1 to (LmpSize.X - 2) do
        begin
          RGBExpToVec3f_Add(@ALightmapColor(lpLightmaps)[Count + j], @AccVec);
        end;
    end;

  // make scale
  tmpScaler:=1/((LmpSize.X - 1)*(LmpSize.Y - 1));
  ScaleVec(@AccVec, @AccVec, @tmpScaler);

  // save average
  Vec3fToRGBExp(lpAverage, @AccVec);
  {$R+}
end;

end.
