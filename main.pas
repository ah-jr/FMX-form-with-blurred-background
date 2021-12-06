unit main;

interface

uses
  Windows,
  Winapi.Messages,
  VCL.Graphics,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Effects,
  FMX.Filter.Effects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Objects,

  BlurBehindControl;

  function newWndProc(hwnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;

type

  TMainForm = class(TForm)
    Button1: TButton;

  private
    { Private declarations }
    BlurPanel : TBlurBehindControl;

    procedure UpdateBlurPanel;
    procedure RepaintBlurPanel;

  public
    constructor Create(AOwner: TComponent); override;

  end;

var
  MainForm: TMainForm;

  OldWindowProc: Pointer = nil;
  NewWindowProc: Pointer = nil;


implementation

uses
  GraphicUtils,
  VCL.Themes,
  FMX.Platform.Win;

{$R *.fmx}

constructor TMainForm.Create(AOwner: TComponent);
var
  ScreenShot : TBitMap;
begin
  ScreenShot := TakeScreenShot;

  inherited;

  BlurPanel := TBlurBehindControl.Create(Self);
  BlurPanel.Position.X := 0;
  BlurPanel.Position.Y := 0;

  BlurPanel.Width  := Width;
  BlurPanel.Height := Height;

  BlurPanel.BackGroundBitmap := ScreenShot;

  BlurPanel.SendToBack;

  Button1.BringToFront;

  ScreenShot.Free;

  OldWindowProc:= Pointer(GetWindowLong(FmxHandleToHWND(self.Handle), GWL_WNDPROC));
  NewWindowProc:= Pointer(SetWindowLong(FmxHandleToHWND(self.Handle), GWL_WNDPROC, Integer(@newWndProc)));
end;

procedure TMainForm.UpdateBlurPanel;
var
  ScreenShot : TBitMap;
begin
  ScreenShot := TakeScreenShot;

  MainForm.Visible := False;
  BlurPanel.BackGroundBitmap := ScreenShot;
  MainForm.Visible := True;

  BlurPanel.Repaint;

  ScreenShot.Free;
end;

procedure TMainForm.RepaintBlurPanel;
begin
  BlurPanel.Repaint;
end;

function newWndProc(hwnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var Mess : TMessage;
begin
  if hwnd = FmxHandleToHWND(MainForm.Handle) then
  begin
    case uMsg of
      WM_MOVE:
      begin
        MainForm.RepaintBlurPanel;
      end;
      WM_SHOWWINDOW, WM_SETFOCUS:
      begin
        MainForm.UpdateBlurPanel;
      end
      else
      Result := CallWindowProc(OldWindowProc, hwnd, uMsg, wParam, lParam);
    end;
  end
  else Result := CallWindowProc(OldWindowProc, hwnd, uMsg, wParam, lParam);
end;


end.

