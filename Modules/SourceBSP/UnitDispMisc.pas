unit UnitDispMisc;

interface

uses
  OpenGL,
  UnitUserTypes;

const
  DISP_SIZE_BY_POWER_2 = 5;   // 2^2 + 1
  DISP_SIZE_BY_POWER_3 = 9;   // 2^3 + 1
  DISP_SIZE_BY_POWER_4 = 17;  // 2^4 + 1

  // Disp Triangle Count = Sqr(Size - 1)*2;
  // Power = 2..4 -> Size = 5, 9, 17
  // -> Count = 32, 128, 512;
  // Disp Vertex Triangle Count = Count*3 -> 96, 384, 1536
  DISP_TRIG_INDEX_COUNT_POWER_2 = 96;
  DISP_TRIG_INDEX_COUNT_POWER_3 = 384;
  DISP_TRIG_INDEX_COUNT_POWER_4 = 1536;

var
  DISP_TRIG_INDEX_TABLE_VALID: Boolean = False;
  DISP_TRIG_INDEX_TABLE_POWER_2: array[0..DISP_TRIG_INDEX_COUNT_POWER_2-1] of GLuint;
  DISP_TRIG_INDEX_TABLE_POWER_3: array[0..DISP_TRIG_INDEX_COUNT_POWER_3-1] of GLuint;
  DISP_TRIG_INDEX_TABLE_POWER_4: array[0..DISP_TRIG_INDEX_COUNT_POWER_4-1] of GLuint;


procedure InitDispTriangleIndexTable();

// Tessellating point "p" in flat 4-polygon "poly" by fractions "f"
// f.xy must be [0..1], poly must be a list of four continious polygon vertices
// Formula:
//    tmpA = (1 - f.x)*poly[0] + f.x*poly[1];
//    tmpB = (1 - f.x)*poly[3] + f.x*poly[2];
//       p = (1 - f.y)*tmpA    + f.y*tmpB;
procedure TessellatingFlatDispPoint(const f: PVec2f; const poly, p: PVec3f);


implementation


procedure InitDispTriangleIndexTable();
var
  i, j, TrigIndex, PowerIndex: Integer;
  OffsetTrigIndex, VertOffset, VertOffsetNext: Integer;
  DispSizes: array[0..2] of Integer;
  DispTables: array[0..2] of Pointer;
begin
  {$R-}
  if (DISP_TRIG_INDEX_TABLE_VALID) then Exit;
  
  DispSizes[0]:=DISP_SIZE_BY_POWER_2;
  DispSizes[1]:=DISP_SIZE_BY_POWER_3;
  DispSizes[2]:=DISP_SIZE_BY_POWER_4;

  DispTables[0]:=@DISP_TRIG_INDEX_TABLE_POWER_2[0];
  DispTables[1]:=@DISP_TRIG_INDEX_TABLE_POWER_3[0];
  DispTables[2]:=@DISP_TRIG_INDEX_TABLE_POWER_4[0];

  // Get Table
  for PowerIndex:=0 to 2 do
    begin
      for i:=0 to (DispSizes[PowerIndex] - 2) do
        begin
          OffsetTrigIndex:=i*(DispSizes[PowerIndex] - 1)*2;
          VertOffset:=i*DispSizes[PowerIndex];
          VertOffsetNext:=VertOffset + DispSizes[PowerIndex];

          for j:=0 to (DispSizes[PowerIndex] - 2) do
            begin
              // Upper Triangle
              TrigIndex:=2*j + OffsetTrigIndex;
              AInt(DispTables[PowerIndex])[3*TrigIndex]:=      VertOffsetNext + j;
              AInt(DispTables[PowerIndex])[3*TrigIndex + 1]:=  VertOffset +     j + 1;
              AInt(DispTables[PowerIndex])[3*TrigIndex + 2]:=  VertOffset +     j;

              // Downer Triangle
              Inc(TrigIndex);
              AInt(DispTables[PowerIndex])[3*TrigIndex]:=      VertOffsetNext + j;
              AInt(DispTables[PowerIndex])[3*TrigIndex + 1]:=  VertOffsetNext + j + 1;
              AInt(DispTables[PowerIndex])[3*TrigIndex + 2]:=  VertOffset +     j + 1;
            end;
        end;
    end;

  DISP_TRIG_INDEX_TABLE_VALID:=True;
  {$R+}
end;


procedure TessellatingFlatDispPoint(const f: PVec2f; const poly, p: PVec3f);
var
  tmpA, tmpB: tVec3f;
begin
  {$R-}
  if (f = nil) or (poly = nil) or (p = nil) then Exit;

  tmpA.x:=(1 - f.x)*AVec3f(poly)[0].x + f.x*AVec3f(poly)[1].x;
  tmpA.y:=(1 - f.x)*AVec3f(poly)[0].y + f.x*AVec3f(poly)[1].y;
  tmpA.z:=(1 - f.x)*AVec3f(poly)[0].z + f.x*AVec3f(poly)[1].z;

  tmpB.x:=(1 - f.x)*AVec3f(poly)[3].x + f.x*AVec3f(poly)[2].x;
  tmpB.y:=(1 - f.x)*AVec3f(poly)[3].y + f.x*AVec3f(poly)[2].y;
  tmpB.z:=(1 - f.x)*AVec3f(poly)[3].z + f.x*AVec3f(poly)[2].z;

  p.x:=(1 - f.y)*tmpA.x + f.y*tmpB.x;
  p.y:=(1 - f.y)*tmpA.y + f.y*tmpB.y;
  p.z:=(1 - f.y)*tmpA.z + f.y*tmpB.z;
  {$R+}
end;

end.
