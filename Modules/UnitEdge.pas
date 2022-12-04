unit UnitEdge;

// Copyright (c) 2019 Sergey-KoRJiK, Belarus

interface

uses SysUtils, Windows, Classes, UnitVec;

type tEdge = record
    v0, v1: WORD;
  end;
type PEdge = ^tEdge;
type AEdge = array of tEdge;

//*****************************************************************************
type tSurfEdge = Integer;
type PSurfEdge = ^tSurfEdge;
type ASurfEdge = array of tSurfEdge;


implementation


end.
