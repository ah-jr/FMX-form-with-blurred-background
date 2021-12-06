unit BlurBehindControl;

interface

uses
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Graphics,
  FMX.Filter.Effects;

type
  TBlurBehindControl = class(TControl)
  private
    FBitmapOfControlBehind : TBitMap;
    FBitmapBlurredFull     : TBitmap;
    FBitmapBlurredPart     : TBitmap;
    FGaussianBlurEffect    : TGaussianBlurEffect;
    FBlurAmount            : Single;
    procedure SetBlurAmount(const sValue : Single);
    procedure UpdateBitmapOfControlBehind;
    procedure UpdateBitmapBlurred;
    procedure SetBitmapOfControlBehind(ABitmapOfControlBehind : TBitmap);
  protected
    procedure ParentChanged; override;
    procedure Paint; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure ForcePaint;
    procedure UpdateScreenShot;
  published
    property BlurAmount       : Single  read FBlurAmount            write SetBlurAmount;
    property BackGroundBitmap : TBitMap read FBitmapOfControlBehind write SetBitmapOfControlBehind;

    property Position;
    property Height;
    property Width;

  end;

implementation

uses
  System.SysUtils,
  System.Types,
  FMX.Forms,
  main;

////////////////////////////////////////////////////////////////////////////////
constructor TBlurBehindControl.Create(AOwner: TComponent);
begin
  inherited;
  Parent := TControl(AOwner);
  HitTest := False;
  FBitMapOfControlBehind := FMX.Graphics.TBitMap.Create;
  FBitMapBlurredFull     := FMX.Graphics.TBitMap.Create;
  FBitMapBlurredPart     := FMX.Graphics.TBitMap.Create;

  FGaussianBlurEffect := TGaussianBlurEffect.Create(Self);
  FBlurAmount := 1.5;
end;

////////////////////////////////////////////////////////////////////////////////
destructor TBlurBehindControl.Destroy;
begin
  FBitMapBlurredFull.Free;
  FBitMapBlurredPart.Free;
  FBitMapOfControlBehind.Free;
  FGaussianBlurEffect.Free;
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TBlurBehindControl.ForcePaint;
begin
  Paint;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TBlurBehindControl.Paint;
begin
  //UpdateBitMapOfControlBehind;

  UpdateBitmapBlurred;

  Canvas.BeginScene;
  try
    Canvas.DrawBitmap(FBitMapBlurredPart,
                      RectF(0,0,FBitMapBlurredPart.Width, FBitMapBlurredPart.Height),
                      LocalRect,
                      1);
  finally
    Canvas.EndScene;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TBlurBehindControl.ParentChanged;
begin
  inherited;

end;

////////////////////////////////////////////////////////////////////////////////
procedure TBlurBehindControl.SetBitmapOfControlBehind(ABitmapOfControlBehind: TBitMap);
begin
  FBitmapOfControlBehind.SetSize(ABitmapOfControlBehind.Width, ABitmapOfControlBehind.Height);
  FBitmapOfControlBehind.CopyFromBitmap(ABitMapOfControlBehind);
  FBitmapOfControlBehind.Resize(ABitmapOfControlBehind.Width div 2, ABitmapOfControlBehind.Height div 2);

  UpdateScreenShot;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TBlurBehindControl.SetBlurAmount(const sValue: Single);
begin
  if sValue <> FBlurAmount then
  begin
    FBlurAmount := sValue;
    Repaint;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TBlurBehindControl.UpdateBitmapBlurred;
var
  TargetWidth  : Integer;
  TargetHeight : Integer;
  AreaOfInterest : TRect;
begin
  TargetWidth  := Round(0.5 * Width);
  TargetHeight := Round(0.5 * Height);
  FBitMapBlurredPart.SetSize(TargetWidth, TargetHeight);

  AreaOfInterest.Left   := Trunc(0.5 * (Position.X + MainForm.Left + 8));
  AreaOfInterest.Top    := Trunc(0.5 * (Position.Y + MainForm.Top + 30));
  AreaOfInterest.Width  := TargetWidth;
  AreaOfInterest.Height := TargetHeight;

  FBitMapBlurredPart.CopyFromBitmap(FBitMapBlurredFull, AreaOfInterest, 0, 0);
end;

{
////////////////////////////////////////////////////////////////////////////////
procedure TBlurBehindControl.UpdateBitmapOfControlBehind;
var
  CanvasBehind  : TCanvas;
  ControlBehind : TControl;
  TESTE         : TCustomForm;
  TargetWidth   : Integer;
  TargetHeight  : Integer;
begin
  //Assert(Parent is TControl);
  //ControlBehind := TControl(Parent);

  TESTE := TCustomForm(Parent);

  //TargetWidth  := Round(0.5 * ControlBehind.Width);
  //TargetHeight := Round(0.5 * ControlBehind.Height);
  TargetWidth  := Round(0.5 * TESTE.Width);
  TargetHeight := Round(0.5 * TESTE.Height);

  FBitmapOfControlBehind.SetSize(TargetWidth, TargetHeight);

  CanvasBehind := FBitmapOfControlBehind.Canvas;
  CanvasBehind.BeginScene;
  FDisablePaint := True;
  try
    //ControlBehind.PaintTo(CanvasBehind, RectF(0,0,TargetWidth,TargetHeight));
    TESTE.PaintTo(CanvasBehind, RectF(0,0,TargetWidth,TargetHeight);
  finally
    FDisablePaint := False;
    CanvasBehind.EndScene;
  end;
end;                     }

////////////////////////////////////////////////////////////////////////////////
procedure TBlurBehindControl.UpdateBitmapOfControlBehind;
var
  CanvasBehind  : TCanvas;
  TESTE         : TCustomForm;
  TargetWidth   : Integer;
  TargetHeight  : Integer;
begin

  //Assert(Parent is TControl);
  //ControlBehind := TControl(Parent);

  TESTE := TCustomForm(Parent);

  //TargetWidth  := Round(0.5 * ControlBehind.Width);
  //TargetHeight := Round(0.5 * ControlBehind.Height);
  TargetWidth  := Round(0.5 * TESTE.Width);
  TargetHeight := Round(0.5 * TESTE.Height);

  FBitmapOfControlBehind.SetSize(TargetWidth, TargetHeight);

  CanvasBehind := FBitmapOfControlBehind.Canvas;
  CanvasBehind.BeginScene;
  FDisablePaint := True;
  try
    //ControlBehind.PaintTo(CanvasBehind, RectF(0,0,TargetWidth,TargetHeight));
    TESTE.PaintTo(CanvasBehind);
  finally
    FDisablePaint := False;
    CanvasBehind.EndScene;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TBlurBehindControl.UpdateScreenShot;
begin
  FBitMapBlurredFull.SetSize(FBitMapOfControlBehind.Width,
                             FBitMapOfControlBehind.Height);

  FBitMapBlurredFull.CopyFromBitmap(FBitMapOfControlBehind);

  FGaussianBlurEffect.BlurAmount := FBlurAmount;
  FGaussianBlurEffect.ProcessEffect(nil, FBitMapBlurredFull, 0);

  FGaussianBlurEffect.BlurAmount := FBlurAmount * 0.4;
  FGaussianBlurEffect.ProcessEffect(nil, FBitMapBlurredFull, 0);
end;

end.

