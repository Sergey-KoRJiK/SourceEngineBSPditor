unit UnitBSPstruct;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

// Pipeline of BSP load

interface

uses
  SysUtils,
  Windows,
  Classes,
  Graphics,
  Math,
  OpenGL,
  EXTOpengl32Glew32,
  UnitVec,
  UnitEntity,
  UnitPlane,
  UnitTexture,
  UnitVertex,
  UnitMapHeader,
  UnitPVS,
  UnitNode,
  UnitFace,
  UnitLightmap,
  UnitVisLeaf,
  UnitMarkSurface,
  UnitEdge,
  UnitBrushModel,
  UnitDisplacement,
  UnitLeafAmbientLight,
  UnitGameLump,
  UnitToneMapControl;


//*****************************************************************************
type eLoadMapErrors = (erNoErrors = 0, erFileNotExists, erMinSize, erBadVersion,
  erBadEOFbyHeader, erNoEntData, erNoPlanes, erNoTextures, erNoVertex,
  erNoNodes, erNoTexInfos, erNoFaces, erNoClipNodes, erNoLeaf, erNoMarkSurface,
  erNoEdge, erNoSurfEdge, erNoBrushes, erNoPVS, erNoLight);

type tMapBSP = record
    LoadState: eLoadMapErrors;
    MapFileSize: Integer;
    FileRawData: AByte;
    MapHeader: tMapHeader; // BSP

    SizeEndData: Integer;
    EntDataLump: String; // BSP
    CountEntities: Integer;
    Entities: AEntity;

    PlaneLump: APlane;  // BSP
    CountPlanes: Integer;

    VertexLump: AVertex; // BSP
    CountVertices: Integer;

    SizeVisibilityLump: Integer;
    CountClusters: Integer; // BSP
    VisOffsets: AVisOffset; // BSP, Len = CountVisLeafWithPVS
    PackedVisibility: AByte; // BSP
    SizePackedVisibility: Integer;

    NodeLump: ANode; // BSP
    NodeInfos: ANodeInfo;
    CountNodes: Integer;
    RootIndex: Integer;

    TexInfoLump: ATexInfo; // BSP
    CountTexInfos: Integer;

    FaceLump: AFace; // BSP
    FaceInfos: AFaceInfo;
    CountFaces: Integer;

    isLDR: Boolean;
    isHDR: Boolean;
    LightingLump: ALightmapColor; // BSP
    LightingHDRLump: ALightmapColor; // BSP
    CountLightMaps: Integer;

    LeafLump: AVisLeaf; // BSP
    VisLeafInfos: AVisLeafInfo;
    CountLeafs: Integer;

    MarkSurfaceLump: AMarkSurface; // BSP
    CountMarkSurfaces: Integer;

    EdgeLump: AEdge; // BSP
    CountEdges: Integer;

    SurfEdgeLump: ASurfEdge; // BSP
    CountSurfEdges: Integer;

    ModelLump: ABrushModel; // BSP
    ModelInfos: ABrushModelInfo;
    CountBrushModels: Integer;
    MapBBOXf: tBBOXf;
    ScaleForMapBBOX: tVec3f;

    DispInfoLump: ADispInfo; // BSP
    DispRenderInfo: ADispRenderInfo;
    CountDispInfos: Integer;
    isAviableDisps: Boolean;

    DispVertex: ADispVert; // BSP
    CountDispVertex: Integer;

    DispLightmapsPos: AByte; // BSP
    SizeDispLightmapsPos: Integer;

    LeafAmbientListLDR: ALeafAmbientLighting; // BSP
    CountLeafAmbientsLDR: Integer;
    LeafAmbientIndexesLDR: ALeafAmbientIndex; // BSP
    CountLeafAmbentIndexLDR: Integer;
    AmbientInfoListLDR: ALeafAmbientInfo; // Leaf Count

    LeafAmbientListHDR: ALeafAmbientLighting; // BSP
    CountLeafAmbientsHDR: Integer;
    LeafAmbientIndexesHDR: ALeafAmbientIndex; // BSP
    CountLeafAmbentIndexHDR: Integer;
    AmbientInfoListHDR: ALeafAmbientInfo; // Leaf Count
  end;

procedure FreeMapBSP(var Map: tMapBSP);

function LoadBSP30FromFile(const FileName: String; var Map: tMapBSP): boolean;
function ShowLoadBSPMapError(const LoadMapErrorType: eLoadMapErrors): String;

procedure UpdateFaceInfo(const Map: tMapBSP; const FaceId: Integer);
procedure UpdateBrushFaceIndex(const Map: tMapBSP);
procedure UpDateVisLeafInfo(const Map: tMapBSP; const VisLeafId: Integer);
procedure UpdateVisLeafEntBrushes(const Map: tMapBSP; const VisLeafId: Integer);
procedure UpDateNodeInfo(const Map: tMapBSP; const NodeInfoId: Integer);
procedure UpDateEntityInfo(const Map: tMapBSP; const EntityId: Integer);
procedure UpdateRenderDispInfo(const Map: tMapBSP; const DispInfoId: Integer);
procedure UpdateVisLeafDisplaments(const Map: tMapBSP; const VisLeafId: Integer);
procedure UpdateLeafAmbientInfoLDR(const Map: tMapBSP; const VisLeafId: Integer);
procedure UpdateLeafAmbientInfoHDR(const Map: tMapBSP; const VisLeafId: Integer);

function GetLeafIndexByPoint(const NodeInfos: ANodeInfo; const Point: tVec3f;
  const RootIndex: Integer): Integer;

implementation


//*****************************************************************************
procedure FreeMapBSP(var Map: tMapBSP);
var
  i: Integer;
begin
  {$R-}
  SetLength(Map.FileRawData, 0);
  Map.MapFileSize:=0;

  SetLength(Map.Entities, 0);
  Map.CountEntities:=0;
  Map.EntDataLump:='';
  Map.SizeEndData:=0;

  SetLength(Map.PlaneLump, 0);
  Map.CountPlanes:=0;

  SetLength(Map.VertexLump, 0);
  Map.CountVertices:=0;

  SetLength(Map.PackedVisibility, 0);
  Map.SizePackedVisibility:=0;
  Map.SizeVisibilityLump:=0;
  Map.CountClusters:=0;
  SetLength(Map.VisOffsets, 0);

  SetLength(Map.NodeLump, 0);
  SetLength(Map.NodeInfos, 0);
  Map.CountNodes:=0;

  SetLength(Map.TexInfoLump, 0);
  Map.CountTexInfos:=0;

  SetLength(Map.FaceLump, 0);
  for i:=0 to (Map.CountFaces - 1) do
    begin
      SetLength(Map.FaceInfos[i].Vertex, 0);
      SetLength(Map.FaceInfos[i].LmpCoords, 0);
      glDeleteTextures(4, @Map.FaceInfos[i].LmpPages[0]);
      glDeleteTextures(4, @Map.FaceInfos[i].LmpPagesHDR[0]);
    end;
  SetLength(Map.FaceInfos, 0);
  Map.CountFaces:=0;

  SetLength(Map.LightingLump, 0);
  SetLength(Map.LightingHDRLump, 0);
  Map.isLDR:=False;
  Map.isHDR:=False;
  Map.CountLightMaps:=0;

  SetLength(Map.LeafAmbientListLDR, 0);
  SetLength(Map.LeafAmbientIndexesLDR, 0);
  SetLength(Map.LeafAmbientListHDR, 0);
  SetLength(Map.LeafAmbientIndexesHDR, 0);
  for i:=0 to (Length(Map.AmbientInfoListLDR) - 1) do
    begin
      ClearLeafAmbientInfo(@Map.AmbientInfoListLDR[i]);
    end;
  for i:=0 to (Length(Map.AmbientInfoListHDR) - 1) do
    begin
      ClearLeafAmbientInfo(@Map.AmbientInfoListHDR[i]);
    end;
  SetLength(Map.AmbientInfoListLDR, 0);
  SetLength(Map.AmbientInfoListHDR, 0);
  Map.CountLeafAmbientsLDR:=0;
  Map.CountLeafAmbientsHDR:=0;
  Map.CountLeafAmbentIndexLDR:=0;
  Map.CountLeafAmbentIndexHDR:=0;

  SetLength(Map.LeafLump, 0);
  for i:=0 to (Map.CountLeafs - 1) do
    begin
      SetLength(Map.VisLeafInfos[i].FaceInfoIndex, 0);
      SetLength(Map.VisLeafInfos[i].EntBrushIndex, 0);
      SetLength(Map.VisLeafInfos[i].DispIndex, 0);
      SetLength(Map.VisLeafInfos[i].PVS, 0);
    end;
  SetLength(Map.VisLeafInfos, 0);
  Map.CountLeafs:=0;

  SetLength(Map.MarkSurfaceLump, 0);
  Map.CountMarkSurfaces:=0;
  SetLength(Map.EdgeLump, 0);
  Map.CountEdges:=0;
  SetLength(Map.SurfEdgeLump, 0);
  Map.CountSurfEdges:=0;

  SetLength(Map.ModelLump, 0);
  SetLength(Map.ModelInfos, 0);
  Map.CountBrushModels:=0;

  SetLength(Map.DispInfoLump, 0);
  for i:=0 to (Map.CountDispInfos - 1) do
    begin
      SetLength(Map.DispRenderInfo[i].TriangleList, 0);
      SetLength(Map.DispRenderInfo[i].TrianglesToRender, 0);
    end;
  SetLength(Map.DispRenderInfo, 0);
  Map.CountDispInfos:=0;

  SetLength(Map.DispVertex, 0);
  Map.CountDispVertex:=0;

  SetLength(Map.DispLightmapsPos, 0);
  Map.SizeDispLightmapsPos:=0;
  {$R+}
end;

function LoadBSP30FromFile(const FileName: String; var Map: tMapBSP): boolean;
var
  i, tmp: Integer;
  MapFile: File;
  tmpList: TStringList;
begin
  {$R-}
  LoadBSP30FromFile:=False;
  Map.LoadState:=erNoErrors;
  
  if (FileExists(FileName) = False) then
    begin
      Map.LoadState:=erFileNotExists;
      Exit;
    end;

  AssignFile(MapFile, FileName);
  Reset(MapFile, 1);

  Map.MapFileSize:=FileSize(MapFile);
  if (Map.MapFileSize < MAP_HEADER_SIZE) then
    begin
      Map.LoadState:=erMinSize;
      CloseFile(MapFile);
      Exit;
    end;

  BlockRead(MapFile, Map.MapHeader, MAP_HEADER_SIZE);
  if ((Map.MapHeader.Signature <> MapSignature) or
    (Map.MapHeader.nVersion < MapVersionMin) or
    (Map.MapHeader.nVersion > MapVersionMax)) then
    begin
      Map.LoadState:=erBadVersion;
      CloseFile(MapFile);
      Exit;
    end;
  {if (GetEOFbyHeader(Map.MapHeader) < Map.MapFileSize) then
    begin
      Map.LoadState:=erBadEOFbyHeader;
      CloseFile(MapFile);
      Exit;
    end; //}

  // Set Lump Sizes
  with Map, MapHeader do
    begin
      if (LumpsInfo[LUMP_LIGHTING].nLength > 0) then isLDR:=True else isLDR:=False;
      if (LumpsInfo[LUMP_LIGHTING_HDR].nLength > 0) then isHDR:=True else isHDR:=False;

      if ((isLDR or isHDR) = False) then
        begin
          LoadState:=erNoLight;
          CloseFile(MapFile);
          Exit;
        end;

      SizeEndData:=           LumpsInfo[LUMP_ENTITIES].nLength;
      CountPlanes:=           LumpsInfo[LUMP_PLANES].nLength div SizeOf(tPlane);
      CountVertices:=         LumpsInfo[LUMP_VERTICES].nLength div SizeOf(tVertex);
      SizeVisibilityLump:=    LumpsInfo[LUMP_VISIBILITY].nLength;
      CountNodes:=            LumpsInfo[LUMP_NODES].nLength div SizeOf(tNode);
      CountTexInfos:=         LumpsInfo[LUMP_TEXINFO].nLength div SizeOf(tTexInfo);
      CountFaces:=            LumpsInfo[LUMP_FACES].nLength div SizeOf(tFace);
      if (Map.isLDR) then
        begin
          CountLightMaps:=          LumpsInfo[LUMP_LIGHTING].nLength div LightmapColorSize;
          CountLeafAmbientsLDR:=    LumpsInfo[LUMP_LEAF_AMBIENT_LIGHTING].nLength div LeafAmbSize;
          CountLeafAmbentIndexLDR:= LumpsInfo[LUMP_LEAF_AMBIENT_INDEX].nLength div LeafAmbIndexSize;
        end;
      if (Map.isHDR) then
        begin
          CountLightMaps:=          LumpsInfo[LUMP_LIGHTING_HDR].nLength div LightmapColorSize;
          CountLeafAmbientsHDR:=    LumpsInfo[LUMP_LEAF_AMBIENT_LIGHTING_HDR].nLength div LeafAmbSize;
          CountLeafAmbentIndexHDR:= LumpsInfo[LUMP_LEAF_AMBIENT_INDEX_HDR].nLength div LeafAmbIndexSize;
        end;
      CountLeafs:=            LumpsInfo[LUMP_LEAVES].nLength div SizeOf(tVisLeaf);
      CountMarkSurfaces:=     LumpsInfo[LUMP_MARKSURFACES].nLength div SizeOf(tMarkSurface);
      CountEdges:=            LumpsInfo[LUMP_EDGES].nLength div SizeOf(tEdge);
      CountSurfEdges:=        LumpsInfo[LUMP_SURFEDGES].nLength div SizeOf(tSurfEdge);
      CountBrushModels:=      LumpsInfo[LUMP_BRUSHES].nLength div SizeOf(tBrushModel);
      CountDispInfos:=        LumpsInfo[LUMP_DISPINFO].nLength div SizeOf(tDispInfo);
      CountDispVertex:=       LumpsInfo[LUMP_DISP_VERTS].nLength div SizeOf(tDispVert);
      SizeDispLightmapsPos:=  LumpsInfo[LUMP_DISP_LIGHTMAPS].nLength; //}
    end;

  // Read EntData
  if (Map.SizeEndData > 0) then
    begin
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_ENTITIES].nOffset);
      SetLength(Map.EntDataLump, Map.SizeEndData);
      BlockRead(MapFile, (@Map.EntDataLump[1])^, Map.SizeEndData);
      FixEntityStrEndToWin(Map.EntDataLump, Map.SizeEndData);
      tmpList:=SplitEntDataByRow(Map.EntDataLump, Map.SizeEndData);
      Map.CountEntities:=GetEntityList(tmpList, Map.Entities);
      if (tmpList <> nil) then
        begin
          tmpList.Clear;
          tmpList.Destroy;
        end;
    end
  else
    begin
      Map.LoadState:=erNoEntData;
      CloseFile(MapFile);
      Exit;
    end;

  // Read Planes
  if (Map.CountPlanes > 0) then
    begin
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_PLANES].nOffset);
      SetLength(Map.PlaneLump, Map.CountPlanes);
      BlockRead(MapFile, (@Map.PlaneLump[0])^, Map.MapHeader.LumpsInfo[LUMP_PLANES].nLength);
    end
  else
    begin
      Map.LoadState:=erNoPlanes;
      CloseFile(MapFile);
      Exit;
    end;

  // Read Vertecies
  if (Map.CountVertices > 0) then
    begin
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_VERTICES].nOffset);
      SetLength(Map.VertexLump, Map.CountVertices);
      BlockRead(MapFile, (@Map.VertexLump[0])^, Map.MapHeader.LumpsInfo[LUMP_VERTICES].nLength);
    end
  else
    begin
      Map.LoadState:=erNoVertex;
      CloseFile(MapFile);
      Exit;
    end;

  // Read PVS
  if (Map.SizeVisibilityLump > 0) then
    begin
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_VISIBILITY].nOffset);

      BlockRead(MapFile, (@Map.CountClusters)^, SizeOf(Integer));
      SetLength(Map.VisOffsets, Map.CountClusters);
      BlockRead(MapFile, (@Map.VisOffsets[0])^, Map.CountClusters*SizeOf(tVisOffset));

      tmp:=SizeOf(Integer) + Map.CountClusters*SizeOf(tVisOffset);
      for i:=0 to (Map.CountClusters - 1) do
        begin
          Dec(Map.VisOffsets[i].OffsetPVS, tmp);
          Dec(Map.VisOffsets[i].OffsetPAS, tmp);
        end;

      Map.SizePackedVisibility:=Map.SizeVisibilityLump - tmp;
      SetLength(Map.PackedVisibility, Map.SizePackedVisibility);
      BlockRead(MapFile, (@Map.PackedVisibility[0])^, Map.SizePackedVisibility);
    end
  else
    begin
      Map.LoadState:=erNoPVS;
      CloseFile(MapFile);
      Exit;
    end;

  // Read Nodes
  if (Map.CountNodes > 0) then
    begin
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_NODES].nOffset);
      SetLength(Map.NodeLump, Map.CountNodes);
      BlockRead(MapFile, (@Map.NodeLump[0])^, Map.MapHeader.LumpsInfo[LUMP_NODES].nLength);
    end
  else
    begin
      Map.LoadState:=erNoNodes;
      CloseFile(MapFile);
      Exit;
    end;

  // Read TexInfos
  if (Map.CountTexInfos > 0) then
    begin
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_TEXINFO].nOffset);
      SetLength(Map.TexInfoLump, Map.CountTexInfos);
      BlockRead(MapFile, (@Map.TexInfoLump[0])^, Map.MapHeader.LumpsInfo[LUMP_TEXINFO].nLength);
    end
  else
    begin
      Map.LoadState:=erNoTexInfos;
      CloseFile(MapFile);
      Exit;
    end;

  // Read Faces
  if (Map.CountFaces > 0) then
    begin
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_FACES].nOffset);
      SetLength(Map.FaceLump, Map.CountFaces);
      BlockRead(MapFile, (@Map.FaceLump[0])^, Map.MapHeader.LumpsInfo[LUMP_FACES].nLength);
    end
  else
    begin
      Map.LoadState:=erNoFaces;
      CloseFile(MapFile);
      Exit;
    end;

  // Read Lighting
  if (Map.CountLightMaps > 0) then
    begin
      if (Map.isLDR) then
        begin
          Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_LIGHTING].nOffset);
          SetLength(Map.LightingLump, Map.CountLightMaps);
          BlockRead(MapFile, (@Map.LightingLump[0])^, Map.MapHeader.LumpsInfo[LUMP_LIGHTING].nLength);
        end;
      if (Map.isHDR) then
        begin
          Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_LIGHTING_HDR].nOffset);
          SetLength(Map.LightingHDRLump, Map.CountLightMaps);
          BlockRead(MapFile, (@Map.LightingHDRLump[0])^, Map.MapHeader.LumpsInfo[LUMP_LIGHTING_HDR].nLength);
        end;
    end;

  // Read VisLeaves
  if (Map.CountLeafs > 0) then
    begin
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_LEAVES].nOffset);
      SetLength(Map.LeafLump, Map.CountLeafs);
      BlockRead(MapFile, (@Map.LeafLump[0])^, Map.MapHeader.LumpsInfo[LUMP_LEAVES].nLength);
    end
  else
    begin
      Map.LoadState:=erNoLeaf;
      CloseFile(MapFile);
      Exit;
    end;

  // Read MarkSurfaces or "LeafFace Indexes"
  if (Map.CountMarkSurfaces > 0) then
    begin
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_MARKSURFACES].nOffset);
      SetLength(Map.MarkSurfaceLump, Map.CountMarkSurfaces);
      BlockRead(MapFile, (@Map.MarkSurfaceLump[0])^, Map.MapHeader.LumpsInfo[LUMP_MARKSURFACES].nLength);
    end
  else
    begin
      Map.LoadState:=erNoMarkSurface;
      CloseFile(MapFile);
      Exit;
    end;

  // Read Edges
  if (Map.CountEdges > 0) then
    begin
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_EDGES].nOffset);
      SetLength(Map.EdgeLump, Map.CountEdges);
      BlockRead(MapFile, (@Map.EdgeLump[0])^, Map.MapHeader.LumpsInfo[LUMP_EDGES].nLength);
    end
  else
    begin
      Map.LoadState:=erNoEdge;
      CloseFile(MapFile);
      Exit;
    end;

  // Read SurfEdges
  if (Map.CountSurfEdges > 0) then
    begin
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_SURFEDGES].nOffset);
      SetLength(Map.SurfEdgeLump, Map.CountSurfEdges);
      BlockRead(MapFile, (@Map.SurfEdgeLump[0])^, Map.MapHeader.LumpsInfo[LUMP_SURFEDGES].nLength);
    end
  else
    begin
      Map.LoadState:=erNoSurfEdge;
      CloseFile(MapFile);
      Exit;
    end;

  // Read Brush Models
  if (Map.CountBrushModels > 0) then
    begin
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_BRUSHES].nOffset);
      SetLength(Map.ModelLump, Map.CountBrushModels);
      BlockRead(MapFile, (@Map.ModelLump[0])^, Map.MapHeader.LumpsInfo[LUMP_BRUSHES].nLength);
      // in any map must be one "zero's" BrushModel, that contain total info about map
      // And we can get Root to NodeTree and Global src vmf BBOX
      Map.RootIndex:=Map.ModelLump[0].iNode;
      Map.MapBBOXf.vMin:=Map.ModelLump[0].vMin;
      Map.MapBBOXf.vMax:=Map.ModelLump[0].vMax;
      GetSizeBBOXf(@Map.MapBBOXf, @Map.ScaleForMapBBOX);
    end
  else
    begin
      Map.LoadState:=erNoBrushes;
      CloseFile(MapFile);
      Exit;
    end;

  // Read Displacements
  if (Map.CountDispInfos > 0) then Map.isAviableDisps:=True else Map.isAviableDisps:=False;
  if (Map.isAviableDisps) then
    begin
      // Read Disp Info's
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_DISPINFO].nOffset);
      SetLength(Map.DispInfoLump, Map.CountDispInfos);
      BlockRead(MapFile, (@Map.DispInfoLump[0])^,
        Map.MapHeader.LumpsInfo[LUMP_DISPINFO].nLength);

      // Read Disp Vertex Manipulations
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_DISP_VERTS].nOffset);
      SetLength(Map.DispVertex, Map.CountDispVertex);
      BlockRead(MapFile, (@Map.DispVertex[0])^,
        Map.MapHeader.LumpsInfo[LUMP_DISP_VERTS].nLength);

      // Read Packed Disp Lightmaps Sample Positions
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_DISP_LIGHTMAPS].nOffset);
      SetLength(Map.DispLightmapsPos, Map.SizeDispLightmapsPos);
      BlockRead(MapFile, (@Map.DispLightmapsPos[0])^,
        Map.MapHeader.LumpsInfo[LUMP_DISP_LIGHTMAPS].nLength);
    end;

  // Read LDR Leaf Ambient Light
  if (Map.isLDR) then
    begin
      SetLength(Map.LeafAmbientListLDR, Map.CountLeafAmbientsLDR);
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_LEAF_AMBIENT_LIGHTING].nOffset);
      BlockRead(MapFile, (@Map.LeafAmbientListLDR[0])^,
        Map.MapHeader.LumpsInfo[LUMP_LEAF_AMBIENT_LIGHTING].nLength);

      SetLength(Map.LeafAmbientIndexesLDR, Map.CountLeafAmbentIndexLDR);
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_LEAF_AMBIENT_INDEX].nOffset);
      BlockRead(MapFile, (@Map.LeafAmbientIndexesLDR[0])^,
        Map.MapHeader.LumpsInfo[LUMP_LEAF_AMBIENT_INDEX].nLength);
    end;

  // Read HDR Leaf Ambient Light
  if (Map.isHDR) then
    begin
      SetLength(Map.LeafAmbientListHDR, Map.CountLeafAmbientsHDR);
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_LEAF_AMBIENT_LIGHTING_HDR].nOffset);
      BlockRead(MapFile, (@Map.LeafAmbientListHDR[0])^,
        Map.MapHeader.LumpsInfo[LUMP_LEAF_AMBIENT_LIGHTING_HDR].nLength);

      SetLength(Map.LeafAmbientIndexesHDR, Map.CountLeafAmbentIndexHDR);
      Seek(MapFile, Map.MapHeader.LumpsInfo[LUMP_LEAF_AMBIENT_INDEX_HDR].nOffset);
      BlockRead(MapFile, (@Map.LeafAmbientIndexesHDR[0])^,
        Map.MapHeader.LumpsInfo[LUMP_LEAF_AMBIENT_INDEX_HDR].nLength);
    end;

  Seek(MapFile, 0);
  SetLength(Map.FileRawData, Map.MapFileSize);
  BlockRead(MapFile, (@Map.FileRawData[0])^, Map.MapFileSize);

  CloseFile(MapFile);
  LoadBSP30FromFile:=True;

  // Update BrushModels
  SetLength(Map.ModelInfos, Map.CountBrushModels);
  for i:=0 to (Map.CountBrushModels - 1) do
    begin
      Map.ModelInfos[i].BBOXf.vMin:=Map.ModelLump[i].vMin;
      Map.ModelInfos[i].BBOXf.vMax:=Map.ModelLump[i].vMax;
      Map.ModelInfos[i].isBrushWithNonZeroOrigin:=isVec3fIsZero(@Map.ModelInfos[i].Origin);
    end;

  // UpDate Face Info
  SetLength(Map.FaceInfos, Map.CountFaces);
  for i:=0 to (Map.CountFaces - 1) do
    begin
      UpDateFaceInfo(Map, i);
    end;
  UpdateBrushFaceIndex(Map);

  // Create Binary Tree
  SetLength(Map.VisLeafinfos, Map.CountLeafs);
  for i:=0 to (Map.CountLeafs - 1) do
    begin
      UpDateVisLeafInfo(Map, i);
    end;
  
  SetLength(Map.NodeInfos, Map.CountNodes);
  for i:=0 to (Map.CountNodes - 1) do
    begin
      UpDateNodeInfo(Map, i);
    end;

  // Update Entities
  for i:=0 to (Map.CountEntities - 1) do
    begin
      UpDateEntityInfo(Map, i);
    end;

  // Update Render Disp Infos
  SetLength(Map.DispRenderInfo, Map.CountDispInfos);
  for i:=0 to (Map.CountDispInfos - 1) do
    begin
      UpdateRenderDispInfo(Map, i);
    end;

  // Update Displacements and Entity Brushes for VisLeafs
  for i:=0 to (Map.CountLeafs - 1) do
    begin
      UpdateVisLeafEntBrushes(Map, i);
      UpdateVisLeafDisplaments(Map, i);
    end;

  // Update Leaf Ambient Light
  if (Map.isLDR) then SetLength(Map.AmbientInfoListLDR, Map.CountLeafs);
  if (Map.isHDR) then SetLength(Map.AmbientInfoListHDR, Map.CountLeafs);
  for i:=0 to (Map.CountLeafs - 1) do
    begin
      UpdateLeafAmbientInfoLDR(Map, i);
      UpdateLeafAmbientInfoHDR(Map, i);
    end;
  {$R+}
end;

function ShowLoadBSPMapError(const LoadMapErrorType: eLoadMapErrors): String;
begin
  {$R-}
  Result:='';
  case LoadMapErrorType of
    erNoErrors : Result:='No Errors in load Map File';
    erFileNotExists : Result:='Map File Not Exists';
    erMinSize : Result:='Map File have size less then size of Header';
    erBadVersion : Result:='Map File have bad BSP version';
    erBadEOFbyHeader : Result:='Size of Map File less then contained in Header';
    erNoEntData : Result:='Map File not have Entity lump';
    erNoTextures : Result:='Map File not have Texture lump';
    erNoPlanes : Result:='Map File not have Plane lump';
    erNoVertex : Result:='Map File not have Vertex lump';
    erNoNodes : Result:='Map File not have Node lump';
    erNoLeaf : Result:='Map File not have VisLeaf lump';
    erNoTexInfos : Result:='Map File not have TexInfo lump';
    erNoFaces : Result:='Map File not have Face lump';
    erNoEdge : Result:='Map File not have Edge lump';
    erNoSurfEdge : Result:='Map File not have SurfEdge lump';
    erNoMarkSurface : Result:='Map File not have MarkSurface lump';
    erNoBrushes : Result:='Map File not have ModelBrush lump';
    erNoClipNodes : Result:='Map File not have ClipNode lump';
    erNoPVS : Result:='Map File not have PVS Table lump';
    erNoLight : Result:='Map File not have Lightmaps';
  end;
  {$R+}
end;

procedure UpdateFaceInfo(const Map: tMapBSP; const FaceId: Integer);
var
  lpFace: PFace;
  lpFaceInfo: PFaceInfo;
  i, EdgeIndex: Integer;
  tmpVec2f: tVec2f;
begin
  {$R-}
  lpFace:=@Map.FaceLump[FaceId];
  lpFaceInfo:=@Map.FaceInfos[FaceId];

  lpFaceInfo.isValidToRender:=False;
  lpFaceInfo.CountLightStyles:=0;

  lpFaceInfo.CountVertex:=lpFace.nSurfEdges;
  lpFaceInfo.CountTriangles:=lpFaceInfo.CountVertex - 2;
  // Check valid face by Count of Vertecies.
  // (for minimum one triangle need 3 vertecies)
  if (lpFaceInfo.CountTriangles < 1) then
    begin
      lpFaceInfo.CountVertex:=0;
      lpFaceInfo.CountTriangles:=0;
      Exit;
    end;

  SetLength(lpFaceInfo.Vertex, lpFaceInfo.CountVertex);
  SetLength(lpFaceInfo.LmpCoords, lpFaceInfo.CountVertex);
  // Get Vertecies
  for i:=0 to (lpFace.nSurfEdges - 1) do
    begin
      EdgeIndex:=Map.SurfEdgeLump[lpFace.iFirstSurfEdge + i];
      if (EdgeIndex >= 0) then
        begin
          lpFaceInfo.Vertex[i]:=Map.VertexLump[Map.EdgeLump[EdgeIndex].v0];
        end
      else
        begin
          lpFaceInfo.Vertex[i]:=Map.VertexLump[Map.EdgeLump[-EdgeIndex].v1];
        end;
    end;

  lpFaceInfo.TexInfo:=Map.TexInfoLump[lpFace.iTextureInfo];
  // Check valid render by TexInfo Flags (Face No tool texture)
  {if ((lpFaceInfo.TexInfo.nFlags and SurfSky2D) = SurfSky2D) then Exit;
  if ((lpFaceInfo.TexInfo.nFlags and SurfSky) = SurfSky) then Exit;
  if ((lpFaceInfo.TexInfo.nFlags and SurfNodraw) = SurfNodraw) then Exit;
  if ((lpFaceInfo.TexInfo.nFlags and SurfHint) = SurfHint) then Exit;
  if ((lpFaceInfo.TexInfo.nFlags and SurfSkip) = SurfSkip) then Exit; //}

  // Check is have lightmaps for render
  if (lpFace.nLightmapOffset < 0) then
    begin
      lpFaceInfo.OffsetLmp:=-1;
      Exit;
    end;
  lpFaceInfo.OffsetLmp:=Integer(lpFace.nLightmapOffset) div LightmapColorSize;

  // Check if is have additional 3's bump lightmap pages
  lpFaceInfo.isHaveBumpLightmap:=False;
  if ((lpFaceInfo.TexInfo.nFlags and SurfBump) = SurfBump) then
    begin
      lpFaceInfo.isHaveBumpLightmap:=True;
    end;

  // Get Normal
  lpFaceInfo.Plane:=Map.PlaneLump[lpFace.iPlane];
  
  lpFaceInfo.LmpSize.X:=lpFace.LmpWidth + 1;
  lpFaceInfo.LmpSize.Y:=lpFace.LmpHeight + 1;
  lpFaceInfo.LmpSquare:=lpFaceInfo.LmpSize.X*lpFaceInfo.LmpSize.Y;

  // Coorection Ligtmap Coord offset
  lpFaceInfo.TexInfo.Lmp.OffsetS:=lpFaceInfo.TexInfo.Lmp.OffsetS - lpFace.LmpMinS;
  lpFaceInfo.TexInfo.Lmp.OffsetT:=lpFaceInfo.TexInfo.Lmp.OffsetT - lpFace.LmpMinT;
  // Scale Lightmap info By Height and Width;
  lpFaceInfo.TexInfo.Lmp.SX:=(lpFaceInfo.TexInfo.Lmp.SX)/(lpFace.LmpWidth + 1);
  lpFaceInfo.TexInfo.Lmp.SY:=(lpFaceInfo.TexInfo.Lmp.SY)/(lpFace.LmpWidth + 1);
  lpFaceInfo.TexInfo.Lmp.SZ:=(lpFaceInfo.TexInfo.Lmp.SZ)/(lpFace.LmpWidth + 1);
  lpFaceInfo.TexInfo.Lmp.OffsetS:=(lpFaceInfo.TexInfo.Lmp.OffsetS)/(lpFace.LmpWidth + 1);
  lpFaceInfo.TexInfo.Lmp.TX:=(lpFaceInfo.TexInfo.Lmp.TX)/(lpFace.LmpHeight + 1);
  lpFaceInfo.TexInfo.Lmp.TY:=(lpFaceInfo.TexInfo.Lmp.TY)/(lpFace.LmpHeight + 1);
  lpFaceInfo.TexInfo.Lmp.TZ:=(lpFaceInfo.TexInfo.Lmp.TZ)/(lpFace.LmpHeight + 1);
  lpFaceInfo.TexInfo.Lmp.OffsetT:=(lpFaceInfo.TexInfo.Lmp.OffsetT)/(lpFace.LmpHeight + 1);

  lpFaceInfo.BrushId:=0; // WorldBrush
  lpFaceInfo.VisLeafId:=0; // Null Leaf

  // Get Vertecies textures coordinates
  for i:=0 to (lpFaceInfo.CountVertex - 1) do
    begin
      //GetTexureCoordST(@lpFaceInfo.Vertex[i], @lpFaceInfo.TexInfo, @lpFaceInfo.TexCoords[i]);
      GetLightmapCoordST(@lpFaceInfo.Vertex[i], @lpFaceInfo.TexInfo, @lpFaceInfo.LmpCoords[i]);
    end;

  // Flip Lightmap Coords
  if (lpFace.DispInfoIndex >= 0) then
    begin
      tmpVec2f:=lpFaceInfo.LmpCoords[0];
      lpFaceInfo.LmpCoords[0]:=lpFaceInfo.LmpCoords[1];
      lpFaceInfo.LmpCoords[1]:=tmpVec2f;
      tmpVec2f:=lpFaceInfo.LmpCoords[2];
      lpFaceInfo.LmpCoords[2]:=lpFaceInfo.LmpCoords[3];
      lpFaceInfo.LmpCoords[3]:=tmpVec2f;
    end; //}

  // how much we can read lightmaps pages? from min 1 to max 4 pages
  lpFaceInfo.CountLightStyles:=1;
  if ((lpFace.nStyles[1] <> $FF) and (lpFace.nStyles[1] <> $00)) then Inc(lpFaceInfo.CountLightStyles);
  if ((lpFace.nStyles[2] <> $FF) and (lpFace.nStyles[2] <> $00)) then Inc(lpFaceInfo.CountLightStyles);
  if ((lpFace.nStyles[3] <> $FF) and (lpFace.nStyles[3] <> $00)) then Inc(lpFaceInfo.CountLightStyles);

  // Set NULL OpenGL textures
  lpFaceInfo.TextureRender:=0;
  lpFaceInfo.LmpPages[0]:=0;
  lpFaceInfo.LmpPages[1]:=0;
  lpFaceInfo.LmpPages[2]:=0;
  lpFaceInfo.LmpPages[3]:=0;
  lpFaceInfo.LmpPagesHDR[0]:=0;
  lpFaceInfo.LmpPagesHDR[1]:=0;
  lpFaceInfo.LmpPagesHDR[2]:=0;
  lpFaceInfo.LmpPagesHDR[3]:=0;

  { Lightmaps data struct for Face without bumpmap: | Index in Lightmap Lump array
    ##############################################################################
    Average for Style[3] if Style[3] aviable        | -4
    Average for Style[2] if Style[2] aviable        | -3
    Average for Style[1] if Style[1] aviable        | -2
    Average for Style[0]                            | -1
    ##############################################################################
    Lightmaps for Style[0]                          |  0
    Lightmaps for Style[1] if aviable Style[1]      |  1*LmpSquare
    Lightmaps for Style[2] if aviable Style[2]      |  2*LmpSquare
    Lightmaps for Style[3] if aviable Style[3]      |  3*LmpSquare


    Lightmaps data struct for Face with bumpmap:    | Index in Lightmap Lump array
    ##############################################################################
    Average for Style[3] if Style[3] aviable        | -4
    Average for Style[2] if Style[2] aviable        | -3
    Average for Style[1] if Style[1] aviable        | -2
    Average for Style[0]                            | -1
    ##############################################################################
    Lightmaps for Style[0]                          |  0
    Lightmaps for Style[0] with bumpmap, page 0     |  1*LmpSquare
    Lightmaps for Style[0] with bumpmap, page 1     |  2*LmpSquare
    Lightmaps for Style[0] with bumpmap, page 2     |  3*LmpSquare
    ##############################################################################
    Lightmaps for Style[1] if aviable Style[1]      |  4*LmpSquare
    Lightmaps for Style[1] with bumpmap, page 0     |  5*LmpSquare
    Lightmaps for Style[1] with bumpmap, page 1     |  6*LmpSquare
    Lightmaps for Style[1] with bumpmap, page 2     |  7*LmpSquare
    ##############################################################################
    Lightmaps for Style[2] if aviable Style[2]      |  8*LmpSquare
    Lightmaps for Style[2] with bumpmap, page 0     |  9*LmpSquare
    Lightmaps for Style[2] with bumpmap, page 1     | 10*LmpSquare
    Lightmaps for Style[2] with bumpmap, page 2     | 11*LmpSquare
    ##############################################################################
    Lightmaps for Style[3] if aviable Style[3]      | 12*LmpSquare
    Lightmaps for Style[3] with bumpmap, page 0     | 13*LmpSquare
    Lightmaps for Style[3] with bumpmap, page 1     | 14*LmpSquare
    Lightmaps for Style[3] with bumpmap, page 2     | 15*LmpSquare
  }
  if (lpFaceInfo.isHaveBumpLightmap) then
    begin
      if (Map.isLDR) then
        begin
          lpFaceInfo.lpFirstLightmap[0]:=@Map.LightingLump[lpFaceInfo.OffsetLmp];
          lpFaceInfo.lpFirstLightmap[1]:=@Map.LightingLump[lpFaceInfo.OffsetLmp + 4*lpFaceInfo.LmpSquare];
          lpFaceInfo.lpFirstLightmap[2]:=@Map.LightingLump[lpFaceInfo.OffsetLmp + 8*lpFaceInfo.LmpSquare];
          lpFaceInfo.lpFirstLightmap[3]:=@Map.LightingLump[lpFaceInfo.OffsetLmp + 12*lpFaceInfo.LmpSquare];
        end;

      if (Map.isHDR) then
        begin
          lpFaceInfo.lpFirstLightmapHDR[0]:=@Map.LightingHDRLump[lpFaceInfo.OffsetLmp];
          lpFaceInfo.lpFirstLightmapHDR[1]:=@Map.LightingHDRLump[lpFaceInfo.OffsetLmp + 4*lpFaceInfo.LmpSquare];
          lpFaceInfo.lpFirstLightmapHDR[2]:=@Map.LightingHDRLump[lpFaceInfo.OffsetLmp + 8*lpFaceInfo.LmpSquare];
          lpFaceInfo.lpFirstLightmapHDR[3]:=@Map.LightingHDRLump[lpFaceInfo.OffsetLmp + 12*lpFaceInfo.LmpSquare];
        end;
    end
  else
    begin
      if (Map.isLDR) then
        begin
          lpFaceInfo.lpFirstLightmap[0]:=@Map.LightingLump[lpFaceInfo.OffsetLmp];
          lpFaceInfo.lpFirstLightmap[1]:=@Map.LightingLump[lpFaceInfo.OffsetLmp + lpFaceInfo.LmpSquare];
          lpFaceInfo.lpFirstLightmap[2]:=@Map.LightingLump[lpFaceInfo.OffsetLmp + 2*lpFaceInfo.LmpSquare];
          lpFaceInfo.lpFirstLightmap[3]:=@Map.LightingLump[lpFaceInfo.OffsetLmp + 3*lpFaceInfo.LmpSquare];
        end;

      if (Map.isHDR) then
        begin
          lpFaceInfo.lpFirstLightmapHDR[0]:=@Map.LightingHDRLump[lpFaceInfo.OffsetLmp];
          lpFaceInfo.lpFirstLightmapHDR[1]:=@Map.LightingHDRLump[lpFaceInfo.OffsetLmp + lpFaceInfo.LmpSquare];
          lpFaceInfo.lpFirstLightmapHDR[2]:=@Map.LightingHDRLump[lpFaceInfo.OffsetLmp + 2*lpFaceInfo.LmpSquare];
          lpFaceInfo.lpFirstLightmapHDR[3]:=@Map.LightingHDRLump[lpFaceInfo.OffsetLmp + 3*lpFaceInfo.LmpSquare];
        end;
    end;
  UpdateFaceRatio(lpFaceInfo, Map.isHDR, Map.isLDR);

  // Get average lightmaps from BSP (don't recalculate it)
  if (Map.isLDR) then
    begin
      for i:=0 to (lpFaceInfo.CountLightStyles - 1) do
        begin
          lpFaceInfo.AverageLmp[i]:=Map.LightingLump[lpFaceInfo.OffsetLmp - (1 + i)];
        end;
    end;

  if (Map.isHDR) then
    begin
      for i:=0 to (lpFaceInfo.CountLightStyles - 1) do
        begin
          lpFaceInfo.AverageLmpHDR[i]:=Map.LightingHDRLump[lpFaceInfo.OffsetLmp - (1 + i)];
        end;
    end;

  lpFaceInfo.isValidToRender:=True;
  {$R+}
end;

procedure UpdateBrushFaceIndex(const Map: tMapBSP);
var
  lpBrush: PBrushModel;
  i, j: Integer;
begin
  {$R-}
  if (Map.CountBrushModels = 1) then Exit;
  for i:=1 to Map.CountBrushModels-1 do
    begin
      lpBrush:=@Map.ModelLump[i];
      if (lpBrush.nFaces <= 0) then continue;
      for j:=0 to Map.CountFaces-1 do
        begin
          if ((j >= lpBrush.iFirstFace) and (j < (lpBrush.iFirstFace + lpBrush.nFaces)))
            then Map.FaceInfos[j].BrushId:=i;
        end;
    end;
  {$R+}
end;

procedure UpDateVisLeafInfo(const Map: tMapBSP; const VisLeafId: Integer);
var
  lpVisLeaf: PVisLeaf;
  lpVisLeafInfo: PVisLeafInfo;
  i, j, FaceIndex: Integer;
begin
  {$R-}
  lpVisLeaf:=@Map.LeafLump[VisLeafId];
  lpVisLeafInfo:=@Map.VisLeafInfos[VisLeafId];

  // Get BBOXf
  lpVisLeafInfo.BBOXf.vMin.x:=lpVisLeaf.nMin.x;
  lpVisLeafInfo.BBOXf.vMin.y:=lpVisLeaf.nMin.y;
  lpVisLeafInfo.BBOXf.vMin.z:=lpVisLeaf.nMin.z;
  lpVisLeafInfo.BBOXf.vMax.x:=lpVisLeaf.nMax.x;
  lpVisLeafInfo.BBOXf.vMax.y:=lpVisLeaf.nMax.y;
  lpVisLeafInfo.BBOXf.vMax.z:=lpVisLeaf.nMax.z;

  // Get BBOXs
  lpVisLeafInfo.BBOXs.nMin:=lpVisLeaf.nMin;
  lpVisLeafInfo.BBOXs.nMax:=lpVisLeaf.nMax;

  lpVisLeafInfo.CountFaces:=0;
  lpVisLeafInfo.CountEntBrushes:=0;
  lpVisLeafInfo.CountPVS:=0;
  lpVisLeafInfo.CountDisplaments:=0;

  // is Valid To Render
  if ((VisLeafId = 0) or (lpVisLeaf.nClusterId < 0)) then
    begin
      lpVisLeafInfo.isValidToRender:=False;
      Exit;
    end;
  lpVisLeafInfo.isValidToRender:=True;

  // Get Final Faces Indecies
  lpVisLeafInfo.CountFaces:=lpVisLeaf.nMarkSurfaces;
  SetLength(lpVisLeafInfo.FaceInfoIndex, lpVisLeafInfo.CountFaces);
  j:=0;
  for i:=0 to (lpVisLeafInfo.CountFaces - 1) do
    begin
      FaceIndex:=Map.MarkSurfaceLump[lpVisLeaf.iFirstMarkSurface + i];
      if (Map.FaceInfos[FaceIndex].isValidToRender) then
        begin
          lpVisLeafInfo.FaceInfoIndex[j]:=FaceIndex;
          Map.FaceInfos[FaceIndex].VisLeafId:=VisLeafId;
          Inc(j);
        end;
    end;
  lpVisLeafInfo.CountFaces:=j;
  SetLength(lpVisLeafInfo.FaceInfoIndex, lpVisLeafInfo.CountFaces);

  // Get Final PVS Data
  lpVisLeafInfo.CountPVS:=0;
  SetLength(lpVisLeafInfo.PVS, 0);
  if ((VisLeafId <> 0) and (lpVisLeaf.nClusterId >=0)
    and (lpVisLeaf.nClusterId < Map.CountClusters)) then
    begin
      lpVisLeafInfo.CountPVS:=Map.CountClusters;
      UnPackPVS(
        @Map.PackedVisibility[Map.VisOffsets[lpVisLeaf.nClusterId].OffsetPVS],
        lpVisLeafInfo.PVS,
        Map.CountClusters,
        Map.SizePackedVisibility);
    end; //}
  {$R+}
end;

procedure UpdateVisLeafEntBrushes(const Map: tMapBSP; const VisLeafId: Integer);
var
  lpVisLeafInfo: PVisLeafInfo;
  i, j, k, n: Integer;
begin
  {$R-}
  lpVisLeafInfo:=@Map.VisLeafInfos[VisLeafId];
  if (lpVisLeafInfo.isValidToRender = False) then Exit;

  lpVisLeafInfo.CountEntBrushes:=0;
  j:=0;
  for i:=1 to (Map.CountBrushModels - 1) do
    begin
      if (TestIntersectionTwoBBOX(@lpVisLeafInfo.BBOXf,
        @Map.ModelInfos[i].BBOXf)) then
        begin
          n:=Map.ModelLump[i].nFaces;
          Inc(j, n);
          SetLength(lpVisLeafInfo.EntBrushIndex, j);

          for k:=0 to (n - 1) do
            begin
              lpVisLeafInfo.EntBrushIndex[j - n + k]:=Map.ModelLump[i].iFirstFace + k;
            end;
        end;
    end;
  lpVisLeafInfo.CountEntBrushes:=j;
  {$R+}
end;

procedure UpDateNodeInfo(const Map: tMapBSP; const NodeInfoId: Integer);
var
  lpNode: PNode;
  lpNodeInfo: PNodeInfo;
begin
  {$R-}
  lpNode:=@Map.NodeLump[NodeInfoId];
  lpNodeInfo:=@Map.NodeInfos[NodeInfoId];

  // UpDate Plane Info
  lpNodeInfo.Plane:=Map.PlaneLump[lpNode.iPlane];

  // UpDate BBOXf
  lpNodeInfo.BBOXf.vMin.x:=lpNode.nMin.x;
  lpNodeInfo.BBOXf.vMin.y:=lpNode.nMin.y;
  lpNodeInfo.BBOXf.vMin.z:=lpNode.nMin.z;
  lpNodeInfo.BBOXf.vMax.x:=lpNode.nMax.x;
  lpNodeInfo.BBOXf.vMax.y:=lpNode.nMax.y;
  lpNodeInfo.BBOXf.vMax.z:=lpNode.nMax.z;

  lpNodeInfo.BBOXs.nMin:=lpNode.nMin;
  lpNodeInfo.BBOXs.nMax:=lpNode.nMax;

  // Update Front Child
  if isLeafChildrenId0(lpNode) then
    begin
      lpNodeInfo.IsFrontNode:=False;
      lpNodeInfo.FrontIndex:=GetIndexLeafChildrenId0(lpNode);
      lpNodeInfo.lpFrontLeafInfo:=@Map.VisLeafInfos[lpNodeInfo.FrontIndex];
    end
  else
    begin
      lpNodeInfo.IsFrontNode:=True;
      lpNodeInfo.FrontIndex:=lpNode.iChildren[0];
      lpNodeInfo.lpFrontNodeInfo:=@Map.NodeInfos[lpNodeInfo.FrontIndex];
    end;

  // UpDate Back Child
  if isLeafChildrenId1(lpNode) then
    begin
      lpNodeInfo.IsBackNode:=False;
      lpNodeInfo.BackIndex:=GetIndexLeafChildrenId1(lpNode);
      lpNodeInfo.lpBackLeafInfo:=@Map.VisLeafInfos[lpNodeInfo.BackIndex];
    end
  else
    begin
      lpNodeInfo.IsBackNode:=True;
      lpNodeInfo.BackIndex:=lpNode.iChildren[1];
      lpNodeInfo.lpBackNodeInfo:=@Map.NodeInfos[lpNodeInfo.BackIndex];
    end;
  {$R+}
end;


function GetLeafIndexByPoint(const NodeInfos: ANodeInfo; const Point: tVec3f;
  const RootIndex: Integer): Integer;
var
  lpNodeInfo: PNodeInfo;
begin
  {$R-}
  Result:=0;
  lpNodeInfo:=@NodeInfos[RootIndex];

  // Walk in Binary Tree
  while (TestPointInBBOX(lpNodeInfo.BBOXf, Point)) do
    begin
      if (isPointInFrontPlaneSpace(@lpNodeInfo.Plane, Point)) then
        begin
          // Front plane part + Point on plane
          if (lpNodeInfo.IsFrontNode) then
            begin
              // Next Front Child is Node
              lpNodeInfo:=lpNodeInfo.lpFrontNodeInfo;
            end
          else
            begin
              // Next Front Child is Leaf
              Result:=lpNodeInfo.FrontIndex;
              Exit;
            end;
        end
      else
        begin
          // Back plane part
          if (lpNodeInfo.IsBackNode) then
            begin
              // Next Back Child is Node
              lpNodeInfo:=lpNodeInfo.lpBackNodeInfo;
            end
          else
            begin
              // Next Back Child is Leaf
              Result:=lpNodeInfo.BackIndex;
              Exit;
            end;
        end;
    end;
  {$R+}
end;

procedure UpDateEntityInfo(const Map: tMapBSP; const EntityId: Integer);
var
  lpEntity: PEntity;
  tmpStr: String;
  i: Integer;
  isHaveEntOrigin: Boolean;
  //
  lpModel: PBrushModel;
  lpModelInfo: PBrushModelInfo;
begin
  {$R-}
  lpEntity:=@Map.Entities[EntityId];

  // UpDate VisLeaf Id
  tmpStr:='';
  lpEntity.VisLeaf:=0;
  isHaveEntOrigin:=False;
  lpEntity.Origin:=VEC_ZERO;
  lpEntity.Angles:=VEC_ZERO;

  i:=GetPairIndexByKey(lpEntity.Pairs, lpEntity.CountPairs, KeyOrigin);
  if (i >= 0) then
    begin
      isHaveEntOrigin:=True;
      tmpStr:=lpEntity.Pairs[i].Value;
      if (StrToVec(tmpStr, @lpEntity.Origin)) then
        begin
          lpEntity.VisLeaf:=GetLeafIndexByPoint(Map.NodeInfos, lpEntity.Origin, Map.RootIndex);
        end;
    end;

  i:=GetPairIndexByKey(lpEntity.Pairs, lpEntity.CountPairs, KeyAngles);
  if (i >= 0) then
    begin
      tmpStr:=lpEntity.Pairs[i].Value;
      StrToVec(tmpStr, @lpEntity.Angles);
    end;

  // Update BrushModel Id
  lpEntity.BrushModel:=-1;
  i:=GetPairIndexByKey(lpEntity.Pairs, lpEntity.CountPairs, 'model');
  if (i >= 0) then
    begin
      tmpStr:=lpEntity.Pairs[i].Value;

      if (tmpStr[1] = '*') then
        begin
          Delete(tmpStr, 1, 1);
          lpEntity.BrushModel:=StrToIntDef(tmpStr, -1);

          if (lpEntity.BrushModel > 0) then
            begin
              lpModel:=@Map.ModelLump[lpEntity.BrushModel];
              lpModelInfo:=@Map.ModelInfos[lpEntity.BrushModel];

              lpModelInfo.EntityId:=EntityId;
              lpModelInfo.isBrushWithEntityOrigin:=isHaveEntOrigin;

              if (isHaveEntOrigin) then
                begin
                  TranslateBBOXf(@lpModelInfo.BBOXf, @lpEntity.Origin);
                  for i:=lpModel.iFirstFace to (lpModel.nFaces + lpModel.iFirstFace - 1) do
                    begin
                      TranslateVertexArray(
                        Map.FaceInfos[i].Vertex,
                        @lpEntity.Origin,
                        Map.FaceInfos[i].CountVertex
                     );
                    end;
                end;
            end;
        end;
    end;
  {$R+}
end;

procedure UpdateRenderDispInfo(const Map: tMapBSP; const DispInfoId: Integer);
var
  lpDispRenderInfo: PDispRenderInfo;
  lpDispInfo: PDispInfo;
  lpSrcFaceInfo: PFaceInfo;
  lpTable: PByte;
  lpDispTrig: PDispTrig;
  i, j, Offset: Integer;
  VertexGrid: AVec3f;
  LmpCoordGrid: AVec2f;
  //
  FlatVertex, Edge0, Edge1: tVec3f;
  tmpOffset: PVec3f;
  tmpDist, tmpScale: Single;
begin
  {$R-}
  lpDispInfo:=@Map.DispInfoLump[DispInfoId];
  lpDispRenderInfo:=@Map.DispRenderInfo[DispInfoId];

  lpDispRenderInfo.isValidToRender:=False;
  lpDispRenderInfo.Size:=0;
  lpDispRenderInfo.SqrSize:=0;
  lpDispRenderInfo.CountTriangles:=0;
  lpDispRenderInfo.BBOXf.vMin:=VEC_INF_P;
  lpDispRenderInfo.BBOXf.vMax:=VEC_INF_N;

  if (lpDispInfo.MapFace >= Map.CountFaces) then Exit;
  lpSrcFaceInfo:=@Map.FaceInfos[lpDispInfo.MapFace];

  if (lpSrcFaceInfo.CountVertex <> 4) then Exit;

  if (lpDispInfo.DispVertStart < 0) then Exit;
  if (lpDispInfo.LightmapSamplePosStart < 0) then Exit;

  case (lpDispInfo.Power) of
    2: lpDispRenderInfo.Size:=DISP_SIZE_BY_POWER_2;
    3: lpDispRenderInfo.Size:=DISP_SIZE_BY_POWER_3;
    4: lpDispRenderInfo.Size:=DISP_SIZE_BY_POWER_4;
  else
    Exit;
  end;
  lpDispRenderInfo.SqrSize:=Sqr(lpDispRenderInfo.Size);
  lpDispRenderInfo.CountTriangles:=Sqr(lpDispRenderInfo.Size - 1)*2;

  // Set NULL OpenGL textures
  lpDispRenderInfo.TextureRender:=0;

  // Get Final Vertex Table
  tmpScale:=1/(lpDispRenderInfo.Size - 1);
  GetEdge(lpSrcFaceInfo.Vertex[0], lpSrcFaceInfo.Vertex[1], @Edge0, tmpScale);
  GetEdge(lpSrcFaceInfo.Vertex[0], lpSrcFaceInfo.Vertex[3], @Edge1, tmpScale);

  SetLength(VertexGrid, lpDispRenderInfo.SqrSize);
  for i:=0 to (lpDispRenderInfo.Size - 1) do
    begin
      Offset:=i*lpDispRenderInfo.Size;
      for j:=0 to (lpDispRenderInfo.Size - 1) do
        begin
          FlatVertex.x:=lpDispInfo.StartPosition.x + Edge1.x*j + Edge0.x*i;
          FlatVertex.y:=lpDispInfo.StartPosition.y + Edge1.y*j + Edge0.y*i;
          FlatVertex.z:=lpDispInfo.StartPosition.z + Edge1.z*j + Edge0.z*i;

          tmpOffset:=@Map.DispVertex[lpDispInfo.DispVertStart + j + Offset].DirOffset;
          tmpDist:=Map.DispVertex[lpDispInfo.DispVertStart + j + Offset].DistOffset;

          VertexGrid[Offset + j].x:=FlatVertex.x + tmpOffset.x*tmpDist;
          VertexGrid[Offset + j].y:=FlatVertex.y + tmpOffset.y*tmpDist;
          VertexGrid[Offset + j].z:=FlatVertex.z + tmpOffset.z*tmpDist;

          UpdateBBOX(@lpDispRenderInfo.BBOXf, @VertexGrid[Offset + j]);
        end;
    end;

  // Get Final Lightmap TexCoord Table
  GetEdge(lpSrcFaceInfo.LmpCoords[0], lpSrcFaceInfo.LmpCoords[1], @Edge0, tmpScale);
  GetEdge(lpSrcFaceInfo.LmpCoords[0], lpSrcFaceInfo.LmpCoords[3], @Edge1, tmpScale);

  SetLength(LmpCoordGrid, lpDispRenderInfo.SqrSize);
  for i:=0 to (lpDispRenderInfo.Size - 1) do
    begin
      Offset:=i*lpDispRenderInfo.Size;
      for j:=0 to (lpDispRenderInfo.Size - 1) do
        begin
          LmpCoordGrid[Offset + j].x:=lpSrcFaceInfo.LmpCoords[0].x + Edge1.x*j + Edge0.x*i;
          LmpCoordGrid[Offset + j].y:=lpSrcFaceInfo.LmpCoords[0].y + Edge1.y*j + Edge0.y*i;
        end;
    end;

  if (DISP_TRIG_INDEX_TABLE_VALID = False) then
    begin
      InitDispTriangleIndexTable();
    end;
  lpTable:=nil;
  case (lpDispInfo.Power) of
    2: lpTable:=@DISP_TRIG_INDEX_TABLE_POWER_2[0];
    3: lpTable:=@DISP_TRIG_INDEX_TABLE_POWER_3[0];
    4: lpTable:=@DISP_TRIG_INDEX_TABLE_POWER_4[0];
  end;

  // Set Triangle Vertexes
  SetLength(lpDispRenderInfo.TriangleList, lpDispRenderInfo.CountTriangles);
  SetLength(lpDispRenderInfo.DegenerateTriangles, lpDispRenderInfo.CountTriangles);
  for i:=0 to (lpDispRenderInfo.CountTriangles - 1) do
    begin
      lpDispTrig:=@lpDispRenderInfo.TriangleList[i];
      lpDispTrig.V0:=VertexGrid[lpTable^];
      lpDispTrig.L0:=LmpCoordGrid[lpTable^];
      Inc(lpTable);
      lpDispTrig.V1:=VertexGrid[lpTable^];
      lpDispTrig.L1:=LmpCoordGrid[lpTable^];
      Inc(lpTable);
      lpDispTrig.V2:=VertexGrid[lpTable^];
      lpDispTrig.L2:=LmpCoordGrid[lpTable^];
      Inc(lpTable);

      GetEdge(lpDispTrig.V0, lpDispTrig.V1, @lpDispTrig.Edge0);
      GetEdge(lpDispTrig.V0, lpDispTrig.V2, @lpDispTrig.Edge1);
      lpDispRenderInfo.DegenerateTriangles[i]:=not GetNormalByEdges(
        @lpDispTrig.Edge1, @lpDispTrig.Edge0, @lpDispTrig.Normal);
    end;
  SetLength(VertexGrid, 0);
  SetLength(LmpCoordGrid, 0);

  SetLength(lpDispRenderInfo.TrianglesToRender, lpDispRenderInfo.CountTriangles);
  ZeroFillChar(@lpDispRenderInfo.TrianglesToRender[0], lpDispRenderInfo.CountTriangles);

  lpDispRenderInfo.isValidToRender:=True;
  {$R+}
end;

procedure UpdateVisLeafDisplaments(const Map: tMapBSP; const VisLeafId: Integer);
var
  lpVisLeafInfo: PVisLeafInfo;
  i, j: Integer;
begin
  {$R-}
  lpVisLeafInfo:=@Map.VisLeafInfos[VisLeafId];
  if (lpVisLeafInfo.isValidToRender = False) then Exit;

  lpVisLeafInfo.CountDisplaments:=0;
  j:=0;
  for i:=0 to (Map.CountDispInfos - 1) do
    begin
      if (Map.DispRenderInfo[i].isValidToRender = False) then Continue;
      
      if (TestIntersectionTwoBBOX(@lpVisLeafInfo.BBOXf,
        @Map.DispRenderInfo[i].BBOXf)) then
        begin
          Inc(j);
          SetLength(lpVisLeafInfo.DispIndex, j);
          lpVisLeafInfo.DispIndex[j - 1]:=i;
        end;
    end;
  lpVisLeafInfo.CountDisplaments:=j;
  {$R+}
end;

procedure UpdateLeafAmbientInfoLDR(const Map: tMapBSP; const VisLeafId: Integer);
var
  lpVisLeafInfo: PVisLeafInfo;
  lpAmbientInfo: PLeafAmbientInfo;
  lpLeafAmbient: PLeafAmbientLighting;
  lpAmbientIndex: PLeafAmbientIndex;
  i, j: Integer;
  tmpVec: tVec3f;
begin
  {$R-}
  if (Map.isLDR = False) then  Exit;
  lpAmbientInfo:=@Map.AmbientInfoListLDR[VisLeafId];
  lpAmbientInfo.SampleCount:=0;

  lpVisLeafInfo:=@Map.VisLeafInfos[VisLeafId];
  if (lpVisLeafInfo.isValidToRender = False) then Exit;

  lpAmbientIndex:=@Map.LeafAmbientIndexesLDR[VisLeafId];
  lpAmbientInfo.SampleCount:=lpAmbientIndex.CountSamples;
  lpAmbientInfo.FirstSampleIndex:=lpAmbientIndex.FirstSample;

  SetLength(lpAmbientInfo.CubeList, lpAmbientInfo.SampleCount);
  for i:=0 to (lpAmbientInfo.SampleCount - 1) do
    begin
      lpLeafAmbient:=@Map.LeafAmbientListLDR[lpAmbientInfo.FirstSampleIndex + i];

      lpAmbientInfo.CubeList[i].RawPosition.x:=lpLeafAmbient.x;
      lpAmbientInfo.CubeList[i].RawPosition.y:=lpLeafAmbient.y;
      lpAmbientInfo.CubeList[i].RawPosition.z:=lpLeafAmbient.z;

      GetAmbientSampleWorldPos(
        lpLeafAmbient,
        @lpVisLeafInfo.BBOXf,
        @lpAmbientInfo.CubeList[i].Position
      );

      GetCubeBBOXfByPosAndSize(
        @lpAmbientInfo.CubeList[i].BBOXf,
        lpAmbientInfo.CubeList[i].Position,
        AmbientCubeSize
      );

      for j:=0 to 5 do
        begin
          lpAmbientInfo.CubeList[i].RawColor[j]:=lpLeafAmbient.colors[j];
          RGBExpToVec3f(@lpLeafAmbient.colors[j], @tmpVec);
          ApplyLinearToneMap(@tmpVec, @AmbientColorScale);
          ClampVec3fToOne(@tmpVec);
          lpAmbientInfo.CubeList[i].RenderColor[j]:=tmpVec;
        end;
    end;

  lpAmbientInfo.StepSize.x:=(lpVisLeafInfo.BBOXf.vMax.x - lpVisLeafInfo.BBOXf.vMin.x)*inv255f;
  lpAmbientInfo.StepSize.y:=(lpVisLeafInfo.BBOXf.vMax.y - lpVisLeafInfo.BBOXf.vMin.y)*inv255f;
  lpAmbientInfo.StepSize.z:=(lpVisLeafInfo.BBOXf.vMax.z - lpVisLeafInfo.BBOXf.vMin.z)*inv255f;
  {$R+}
end;

procedure UpdateLeafAmbientInfoHDR(const Map: tMapBSP; const VisLeafId: Integer);
var
  lpVisLeafInfo: PVisLeafInfo;
  lpAmbientInfo: PLeafAmbientInfo;
  lpLeafAmbient: PLeafAmbientLighting;
  lpAmbientIndex: PLeafAmbientIndex;
  i, j: Integer;
  tmpVec: tVec3f;
begin
  {$R-}
  if (Map.isHDR = False) then  Exit;
  lpAmbientInfo:=@Map.AmbientInfoListHDR[VisLeafId];
  lpAmbientInfo.SampleCount:=0;

  lpVisLeafInfo:=@Map.VisLeafInfos[VisLeafId];
  if (lpVisLeafInfo.isValidToRender = False) then Exit;

  lpAmbientIndex:=@Map.LeafAmbientIndexesHDR[VisLeafId];
  lpAmbientInfo.SampleCount:=lpAmbientIndex.CountSamples;
  lpAmbientInfo.FirstSampleIndex:=lpAmbientIndex.FirstSample;

  SetLength(lpAmbientInfo.CubeList, lpAmbientInfo.SampleCount);
  for i:=0 to (lpAmbientInfo.SampleCount - 1) do
    begin
      lpLeafAmbient:=@Map.LeafAmbientListHDR[lpAmbientInfo.FirstSampleIndex + i];

      lpAmbientInfo.CubeList[i].RawPosition.x:=lpLeafAmbient.x;
      lpAmbientInfo.CubeList[i].RawPosition.y:=lpLeafAmbient.y;
      lpAmbientInfo.CubeList[i].RawPosition.z:=lpLeafAmbient.z;
      
      GetAmbientSampleWorldPos(
        lpLeafAmbient,
        @lpVisLeafInfo.BBOXf,
        @lpAmbientInfo.CubeList[i].Position
      );

      GetCubeBBOXfByPosAndSize(
        @lpAmbientInfo.CubeList[i].BBOXf,
        lpAmbientInfo.CubeList[i].Position,
        AmbientCubeSize
      );

      for j:=0 to 5 do
        begin
          lpAmbientInfo.CubeList[i].RawColor[j]:=lpLeafAmbient.colors[j];
          RGBExpToVec3f(@lpLeafAmbient.colors[j], @tmpVec);
          ApplyLinearToneMap(@tmpVec, @AmbientColorScale);
          ClampVec3fToOne(@tmpVec);
          lpAmbientInfo.CubeList[i].RenderColor[j]:=tmpVec;
        end;
    end;

  lpAmbientInfo.StepSize.x:=(lpVisLeafInfo.BBOXf.vMax.x - lpVisLeafInfo.BBOXf.vMin.x)*inv255f;
  lpAmbientInfo.StepSize.y:=(lpVisLeafInfo.BBOXf.vMax.y - lpVisLeafInfo.BBOXf.vMin.y)*inv255f;
  lpAmbientInfo.StepSize.z:=(lpVisLeafInfo.BBOXf.vMax.z - lpVisLeafInfo.BBOXf.vMin.z)*inv255f;
  {$R+}
end;

end.
