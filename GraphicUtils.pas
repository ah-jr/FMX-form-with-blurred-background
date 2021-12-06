unit GraphicUtils;

interface

uses
  Windows,
  System.Classes,
  VCL.Graphics,
  FMX.Graphics,
  FMX.Filter.Effects;

////////////////////////////////////////////////////////////////////////////////

  function TakeScreenShot : FMX.Graphics.TBitmap;
  procedure WriteWindowsToStream(AStream: TStream);

////////////////////////////////////////////////////////////////////////////////

implementation

uses
  System.SysUtils,
  FMX.Forms;

////////////////////////////////////////////////////////////////////////////////
function TakeScreenShot : FMX.Graphics.TBitmap;
var
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  Result := FMX.Graphics.TBitmap.Create;
  try
    WriteWindowsToStream(Stream);
    Stream.Position := 0;
    Result.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure WriteWindowsToStream(AStream: TStream);
var
  dc: HDC; lpPal : PLOGPALETTE;
  bm: VCL.Graphics.TBitMap;
begin
  bm := VCL.Graphics.TBitmap.Create;

  bm.Width := Screen.Width;
  bm.Height := Screen.Height;

  dc := GetDc(0);
  if (dc = 0) then exit;
  if (GetDeviceCaps(dc, RASTERCAPS) AND RC_PALETTE = RC_PALETTE) then
  begin
    GetMem(lpPal, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)));
    FillChar(lpPal^, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)), #0);
    lpPal^.palVersion := $300;
    lpPal^.palNumEntries :=GetSystemPaletteEntries(dc,0,256,lpPal^.palPalEntry);
    if (lpPal^.PalNumEntries <> 0) then
    begin
      bm.Palette := CreatePalette(lpPal^);
    end;
    FreeMem(lpPal, sizeof(TLOGPALETTE) + (255 * sizeof(TPALETTEENTRY)));
  end;
  BitBlt(bm.Canvas.Handle,0,0,Screen.Width,Screen.Height,Dc,0,0,SRCCOPY);

  bm.SaveToStream(AStream);

  FreeAndNil(bm);
  ReleaseDc(0, dc);
end;

end.

