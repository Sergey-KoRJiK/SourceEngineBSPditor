unit UnitRadianceHDR;

// Copyright (c) 2019 Sergey Smolovsky, Belarus

// For import\export Lightmap BSP data to *.hdr Radiance RGBE image format
// http://radsite.lbl.gov/radiance/refer/filefmts.pdf

// This product includes Radiance software
// (http://radsite.lbl.gov/)
// developed by the Lawrence Berkeley National Laboratory
// (http://www.lbl.gov/).

interface

uses
  SysUtils,
  Windows,
  Classes;


const
  SignatureRad = '#?RADIANCE';
  SignatureRadSize = Length(SignatureRad);
  HeaderFormatRad = 'FORMAT=32-bit_rle_rgbe';
  HeaderFormatRadSize = Length(HeaderFormatRad);
  HeaderDelemiterRad: Byte = $0A;
  SpaceDelemiterRad: Byte = $20;
  EndOfHeaderRad: Word = $0A0A;
  //
  DirSize = 2; // Sign char + char 'X' or char 'Y'
  DirLeftRight = '+X';
  DirRightLeft = '-X';
  DirTopBottom = '-Y';
  DirBottomTop = '+Y';
  //
  MinHDRFileSize = 37;
  

type eLoadStateHDR = (
    hdrOK,
    hdrNoExists,
    hdrBadHeader,
    hdrBadFormat,
    hdrMinSize,
    hdrBadWidth,
    hdrBadHeight,
    hdrBadScanWidth,
    hdrBadScanHeight,
    hdrBadRLE
  );
  
type tHDREntry = record
    r, g, b: Byte;
    e: ShortInt;
  end;
type PHDREntry = ^tHDREntry;
type AHDREntry = array of tHDREntry;


procedure WriteBytesRLE(const ByteFile: File; const lpData: PByte; const numbytes: Integer);
procedure SaveToHDRFile(const FileName: String; const Width, Height: Integer;
  const Lightmaps: PHDREntry);
function LoadFromHDRFile(const FileName: String; const Width, Height: Integer;
  const Lightmaps: PHDREntry): eLoadStateHDR;
function ShowLoadHDRError(const hdrError: eLoadStateHDR): String;


implementation


type AByte = array of Byte;


procedure WriteBytesRLE(const ByteFile: File; const lpData: PByte; const numbytes: Integer);
const
  MinRunLength = 4;
var
  cur, beg_run, run_count, old_run_count, nonrun_count: Integer;
  buf: array[0..1] of Byte;
begin
  {$R-}
  cur:=0;
  while (cur < numbytes) do
    begin
      beg_run:=cur;

      // find next run of length at least 4 if one exists
      run_count:=0;
      old_run_count:=0;
      while ((run_count < MinRunLength) and (beg_run < numbytes)) do
        begin
          Inc(beg_run, run_count);
          old_run_count:=run_count;

          run_count:=1;
          while ( ((beg_run + run_count) < numbytes) and (run_count < 127)
            and (AByte(lpData)[beg_run] = AByte(lpData)[beg_run + run_count]) ) do
            begin
              Inc(run_count);
            end;
        end;

      // if data before next big run is a short run then write it as such
      if ( (old_run_count > 1) and (old_run_count = (beg_run - cur)) ) then
        begin
          // write short run
          buf[0]:=128 + old_run_count;
          buf[1]:=AByte(lpData)[cur];
          BlockWrite(ByteFile, Pointer(@buf[0])^, 2);

          cur:=beg_run;
        end;

      // write out bytes until we reach the start of the next run
      while (cur < beg_run) do
        begin
          nonrun_count:=beg_run - cur;
          if (nonrun_count > 128) then nonrun_count:=128;

          buf[0]:=nonrun_count;
          BlockWrite(ByteFile, Pointer(@buf[0])^, 1);
          BlockWrite(ByteFile, Pointer(@(AByte(lpData)[cur]))^, nonrun_count);

          Inc(cur, nonrun_count);
        end;

      // write out next run if one was found
      if (run_count >= MinRunLength) then
        begin
          buf[0]:=128 + run_count;
          buf[1]:=AByte(lpData)[beg_run];
          BlockWrite(ByteFile, Pointer(@buf[0])^, 2);

          Inc(cur, run_count);
        end;
    end;
  {$R+}
end;

procedure SaveToHDRFile(const FileName: String; const Width, Height: Integer;
  const Lightmaps: PHDREntry);
var
  FileHDR: File;
  tmpStr: String;
  tmpPointer: PHDREntry;
  Buffer: AByte;
  RunLenHeader: array[0..3] of Byte;
  i, j, SqrSize: Integer;
begin
  {$R-}
  AssignFile(FileHDR, FileName + '.hdr');
  Rewrite(FileHDR, 1);

  // Write simple header with minimal information
  // 1. Write Signature "RADIANCE"
  BlockWrite(FileHDR, Pointer(@SignatureRad[1])^, SignatureRadSize);
  BlockWrite(FileHDR, Pointer(@HeaderDelemiterRad)^, 1);
  // 2. Write Format "RGBE with RLE"
  BlockWrite(FileHDR, Pointer(@HeaderFormatRad[1])^, HeaderFormatRadSize);
  BlockWrite(FileHDR, Pointer(@HeaderDelemiterRad)^, 1);
  // 3. Write null string - end of header
  BlockWrite(FileHDR, Pointer(@HeaderDelemiterRad)^, 1);

  // Next write image size info with standard write direction "left->right, top->bottom"
  // 1. Get direction format
  tmpStr:=DirTopBottom
    + ' ' + IntToStr(Height)
    + ' ' + DirLeftRight
    + ' ' + IntToStr(Width);
  // 2. Write direction format with end byte
  BlockWrite(FileHDR, Pointer(@tmpStr[1])^, Length(tmpStr));
  BlockWrite(FileHDR, Pointer(@HeaderDelemiterRad)^, 1);

  // Final - write pixel data
  SqrSize:=Width*Height;
  tmpPointer:=Lightmaps;
  if ((Width < 8) or (Width > $7FFF)) then
    begin
      // run length encoding is not allowed so write flat
      if ((Width > 0) and (Height > 0)) then
        begin
          SetLength(Buffer, SizeOf(tHDREntry)*SqrSize);
          // Correct Lightmap RGBExp to Radiance RGBE
          for i:=0 to (SqrSize - 1) do
            begin
              Buffer[i*4]:=tmpPointer.r;
              Buffer[i*4 + 1]:=tmpPointer.g;
              Buffer[i*4 + 2]:=tmpPointer.b;
              Buffer[i*4 + 3]:=tmpPointer.e + 128;
              Inc(tmpPointer);
            end;
          BlockWrite(FileHDR, Pointer(@Buffer[0])^, SizeOf(tHDREntry)*SqrSize);
        end;
    end
  else
    begin
      // Create header for run-length
      // width write to file in Big-Endian
      RunLenHeader[0]:=2;
      RunLenHeader[1]:=2;
      RunLenHeader[2]:=Width shr 8;
      RunLenHeader[3]:=(Width and $FF);

      SetLength(Buffer, SizeOf(tHDREntry)*Width);
      for i:=0 to (Height - 1) do
        begin
          // Write Run-Length Header
          BlockWrite(FileHDR, Pointer(@RunLenHeader[0])^, 4);

          // Correct Lightmap RGBExp to Radiance RGBE
          for j:=0 to (Width - 1) do
            begin
              Buffer[j]:=tmpPointer.r;
              Buffer[j + Width]:=tmpPointer.g;
              Buffer[j + 2*Width]:=tmpPointer.b;
              Buffer[j + 3*Width]:=tmpPointer.e + 128;
              Inc(tmpPointer);
            end;

          // write out each of the four channels separately run length encoded
          // first red, then green, then blue, then exponent
          WriteBytesRLE(FileHDR, @Buffer[0], Width);
          WriteBytesRLE(FileHDR, @Buffer[Width], Width);
          WriteBytesRLE(FileHDR, @Buffer[2*Width], Width);
          WriteBytesRLE(FileHDR, @Buffer[3*Width], Width);
        end;
    end;
  SetLength(Buffer, 0);
  CloseFile(FileHDR);
  {$R+}
end;

function LoadFromHDRFile(const FileName: String; const Width, Height: Integer;
  const Lightmaps: PHDREntry): eLoadStateHDR;
var
  FileHDR: File;
  tmpStr: String;
  tmpPointer: PHDREntry;
  Buffer: AByte;
  RunLenHeader: array[0..3] of Byte;
  i, j, SqrSize, SizeOfFile, Count, k: Integer;
  tmpList: TStringList;
  //
  BufWord: array[0..1] of Byte;
  ptr, ptr_end: PByte;
begin
  {$R-}
  if (FileExists(FileName) = False) then
    begin
      Result:=hdrNoExists;
      Exit;
    end;

  AssignFile(FileHDR, FileName);
  Reset(FileHDR, 1);

  SizeOfFile:=FileSize(FileHDR);
  if (SizeOfFile < MinHDRFileSize) then
    begin
      CloseFile(FileHDR);
      Result:=hdrMinSize;
      Exit;
    end;

  // Scan Header
  SetLength(tmpStr, 2);
  i:=2;
  BlockRead(FileHDR, Pointer(@tmpStr[1])^, 2);
  while not( (tmpStr[i - 1] = Char(HeaderDelemiterRad))
    and (tmpStr[i] = Char(HeaderDelemiterRad)) ) do
    begin
      Inc(i);
      SetLength(tmpStr, i);
      BlockRead(FileHDR, Pointer(@tmpStr[i])^, 1);

      if (EOF(FileHDR)) then
        begin
          CloseFile(FileHDR);
          Result:=hdrBadHeader;
          Exit;
        end;
    end;

  tmpList:=TStringList.Create();
  // Check Format
  {tmpList.Delimiter:=Char(HeaderDelemiterRad);
  tmpList.DelimitedText:=tmpStr;
  if (tmpList.Find(HeaderFormatRad, i) = False) then
    begin
      CloseFile(FileHDR);
      tmpList.Destroy;
      Result:=hdrBadFormat;
      Exit;
    end;
  tmpList.Clear; //}

  // Scan Width and Height;
  SetLength(tmpStr, 1);
  i:=1;
  BlockRead(FileHDR, Pointer(@tmpStr[1])^, 1);
  while (tmpStr[i] <> Char(HeaderDelemiterRad)) do
    begin
      Inc(i);
      SetLength(tmpStr, i);
      BlockRead(FileHDR, Pointer(@tmpStr[i])^, 1);

      if (EOF(FileHDR)) then
        begin
          CloseFile(FileHDR);
          Result:=hdrBadScanWidth;
          Exit;
        end;
    end;

  tmpList.Delimiter:=' ';
  tmpList.DelimitedText:=tmpStr;
  if (tmpList.Count < 4) then
    begin
      CloseFile(FileHDR);
      tmpList.Destroy;
      Result:=hdrBadScanWidth;
      Exit;
    end;
  if ((tmpList.Strings[0] <> DirTopBottom)
    or (tmpList.Strings[2] <> DirLeftRight)) then
    begin
      CloseFile(FileHDR);
      tmpList.Destroy;
      Result:=hdrBadScanWidth;
      Exit;
    end;

  i:=StrToIntDef(tmpList.Strings[1], -1);
  if (i = -1) then
    begin
      CloseFile(FileHDR);
      tmpList.Destroy;
      Result:=hdrBadScanHeight;
      Exit;
    end;
  if (i <> Height) then
    begin
      CloseFile(FileHDR);
      tmpList.Destroy;
      Result:=hdrBadHeight;
      Exit;
    end;

  i:=StrToIntDef(tmpList.Strings[3], -1);
  if (i = -1) then
    begin
      CloseFile(FileHDR);
      tmpList.Destroy;
      Result:=hdrBadScanWidth;
      Exit;
    end;
  if (i <> Width) then
    begin
      CloseFile(FileHDR);
      tmpList.Destroy;
      Result:=hdrBadWidth;
      Exit;
    end;
  tmpList.Destroy;

  // Final - Read and unpack Pixel data
  SqrSize:=Width*Height;
  tmpPointer:=Lightmaps;
  if ((Width < 8) or (Width > $7fff)) then
    begin
      // run length encoding is not allowed so read flat*/
      if ((Width > 0) and (Height > 0)) then
        begin
          SetLength(Buffer, SizeOf(tHDREntry)*SqrSize);
          BlockRead(FileHDR, Pointer(@Buffer[0])^, SizeOf(tHDREntry)*SqrSize);
          // Correct Lightmap RGBExp to Radiance RGBE
          for i:=0 to (SqrSize - 1) do
            begin
              tmpPointer.r:=Buffer[i*4];
              tmpPointer.g:=Buffer[i*4 + 1];
              tmpPointer.b:=Buffer[i*4 + 2];
              tmpPointer.e:=Buffer[i*4 + 3] - 128;
              Inc(tmpPointer);
            end;
        end;
    end
  else
    begin
      try
        SetLength(Buffer, SizeOf(tHDREntry)*Width);
        for i:=0 to (Height - 1) do
          begin
            // Read RLD Header
            BlockRead(FileHDR, Pointer(@RunLenHeader[0])^, 4);

            // is this file is run length?
            if ((RunLenHeader[0] <> 2)
              or (RunLenHeader[1] <> 2)
              or (RunLenHeader[2] >= $80)) then
              begin
                // correct first pixel sample
                tmpPointer.r:=RunLenHeader[0];
                tmpPointer.g:=RunLenHeader[1];
                tmpPointer.b:=RunLenHeader[2];
                tmpPointer.e:=RunLenHeader[3] - 128;
                Inc(tmpPointer);

                SetLength(Buffer, SizeOf(tHDREntry)*(SqrSize - 1));
                BlockRead(FileHDR, Pointer(@Buffer[0])^, SizeOf(tHDREntry)*(SqrSize - 1));
                // Correct Lightmap RGBExp to Radiance RGBE
                for j:=0 to (SqrSize - 1) do
                  begin
                    tmpPointer.r:=Buffer[j*4];
                    tmpPointer.g:=Buffer[j*4 + 1];
                    tmpPointer.b:=Buffer[j*4 + 2];
                    tmpPointer.e:=Buffer[j*4 + 3] - 128;
                    Inc(tmpPointer);
                  end;

                CloseFile(FileHDR);
                SetLength(Buffer, 0);
                Result:=hdrOK;
                Exit;
              end;

            // is correct width in RLE Header
            j:=(RunLenHeader[2] shl 8) + RunLenHeader[3];
            if (j <> Width) then
              begin
                CloseFile(FileHDR);
                SetLength(Buffer, 0);
                Result:=hdrBadRLE;
                Exit;
              end;

            Ptr:=@Buffer[0];
            // read each of the four channels for the scanline into the buffer
            for j:=0 to 3 do
              begin
                ptr_end:=@Buffer[(j + 1)*Width];
                while (DWORD(ptr) < DWORD(ptr_end)) do
                  begin
                    BlockRead(FileHDR, Pointer(@BufWord[0])^, 2);

                    if (BufWord[0] > 128) then
                      begin
                        // a run of the same value
                        Count:=BufWord[0] - 128;
                        if ( (Count = 0)
                          or (Count > Integer(DWORD(ptr_end) - DWORD(ptr))) ) then
                          begin
                            CloseFile(FileHDR);
                            SetLength(Buffer, 0);
                            Result:=hdrBadRLE;
                            Exit;
                          end;

                        for k:=0 to (Count - 1) do
                          begin
	                          ptr^:=BufWord[1];
                            Inc(ptr);
                          end;
                      end
                    else
                      begin
                        // a non-run
                        Count:=BufWord[0];
                        if ( (Count = 0)
                          or (Count > Integer(DWORD(ptr_end) - DWORD(ptr))) ) then
                          begin
                            CloseFile(FileHDR);
                            SetLength(Buffer, 0);
                            Result:=hdrBadRLE;
                            Exit;
                          end;

                        ptr^:=BufWord[1];
                        Inc(ptr);
                        Dec(Count);

                        if (Count > 0) then
                          begin
                            BlockRead(FileHDR, Pointer(ptr)^, Count);
                            Inc(ptr, Count);
                          end;
                      end;
	                end;
              end;

            // now convert data from buffer into floats
            for j:=0 to (Width - 1) do
              begin
                tmpPointer.r:=Buffer[j];
                tmpPointer.g:=Buffer[j + Width];
                tmpPointer.b:=Buffer[j + 2*Width];
                tmpPointer.e:=Buffer[j + 3*Width] - 128;
                Inc(tmpPointer);
              end;
          end;
      except
        CloseFile(FileHDR);
        SetLength(Buffer, 0);
        Result:=hdrBadRLE;
        Exit;
      end;
    end;

  CloseFile(FileHDR);
  SetLength(Buffer, 0);
  Result:=hdrOK;
  {$R+}
end;

function ShowLoadHDRError(const hdrError: eLoadStateHDR): String;
begin
  {$R-}
  Result:='';
  case (hdrError) of
    hdrOK:              Result:='No Errors!';
    hdrNoExists:        Result:='File Not Exists!';
    hdrMinSize:         Result:='File have size less then ' + IntToStr(MinHDRFileSize) + ' Bytes!';
    hdrBadHeader:       Result:='File have bad header!';
    hdrBadFormat:       Result:='Unknown Data format, support only RGBE with RLE!';
    hdrBadWidth:        Result:='Width must be equal Lightmap Width!';
    hdrBadHeight:       Result:='Height must be equal Lightmap Height!';
    hdrBadScanWidth:    Result:='Width by File Header is NaN!';
    hdrBadScanHeight:   Result:='Height by File Header is NaN!';
    hdrBadRLE:          Result:='Error in RLE data unpack!';
  end;
  {$R+}
end;

end.
