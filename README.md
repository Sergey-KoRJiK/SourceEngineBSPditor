Copyright (c) 2019 Sergey-KoRJiK, Belarus

# This program created for Edit Lightmaps and Ambient Lighting of Source Engine 2013 BSP.
Support import and export Lightmap textures on Face\Displacement
to *.hdr (for HDRShop, HDRSee, Photoshop with work them like 
HDR Images) for each Styles on Face. 

### For download compiled standalone tool, click [here](https://github.com/Sergey-KoRJiK/SourceEngineBSPditor/raw/master/SourceEngineMapViewer.exe)

The main goal - Color\Pixel Correction of calculated light after VRAD
(bad color, bad black pixel, ... for fun color change). 
For make it:
 - Load BSP Map;
 - Use 3d camera fo find interested Lightmaps;
 - Select Face;
 - Choose Style and save to HDR.
 - open HDR on any Image tool, that support HDR.
 - save with same size of textures
 - import HDR
 - go File->Save BSP.
 
Camera help:
view by left mouse botton
move Forward\Backward by keys W\S
step Left\Right by keys A\D.
If camera get out from current Leaf (showed in bottom toolbar)
render is disabled. BSP render only by aviable leaf Visibility Table,
while camera in any leaf, contain faces.
Don't support camera collision with Faces.

- Leaf ambient render only current camera Leaf.

Select Face: click by right mouse button on 2d window on interest 
visible lightmap. And on right Face toolbar showed Face info and
tools for choose Lightmap Style and export\import Ligthmaps.
Import Lightmap must be have equal size of Face lightmap W\H.

Select Ambient cubes" click by right mouse botton on 2d window on interest
ambient cube. And on right Ambient toolbar showed cube info (color and position)
and tools for choose color and position. Color can be selected by click on
color square (opened color dialog menu) or by enter color component in edit field
and press button "apply". 
Selected cubes showes with green wireframe cell.

### LIGHTMAP AMBIENT COLOR PRE-SCALE BY 256.0 FOR RENDER IN SCENCE.

In Option up toolbar u can select which Faces need render 
(World Brush\ Entity Brush \ Displacement) and select
render type (WallHack (XRay) or Default), select show/hode toolbars.

In right Face toolBar is present ToneMap Control for 
select showing lightmaps hdr color subrange, in default
at load bsp all hdr colors clamped to one.

In right Ambient toolBar is present pre-calculated ambient light for six directions 
in current camera position and both ambient color for camera direction (if intertp
camera dir as normal with face as window srceen).
Calculated color may be difference with in-game ambient color, becouse it based on
vrad restore function in color gamma spece for rejection ambient cubes in part of compress 
ambient lighting.

Valid VisLeaf showed as Blue BBOX.
Invalid Leaf showed as Red BBOX.
Green BBOX - vmf src map BBOX.
