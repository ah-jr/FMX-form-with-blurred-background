unit main;

interface

uses
  Windows,
  Winapi.Messages,
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

  private
    m_BlurPanel     : TBlurBehindControl;
    m_bmpScreenShot : TBitMap;

    procedure UpdateBlurPanel;
    procedure RepaintBlurPanel;

  public
    constructor Create(AOwner: TComponent); override;

    property ScreenShot : TBitMap read m_bmpScreenShot write m_bmpScreenShot;
  end;

var
  MainForm      : TMainForm;
  OldWindowProc : Pointer = nil;
  NewWindowProc : Pointer = nil;


implementation

uses
  GraphicUtils,
  VCL.Themes,
  FMX.Platform.Win;

{$R *.fmx}

constructor TMainForm.Create(AOwner: TComponent);
begin
  Inherited;

  OldWindowProc:= Pointer(GetWindowLong(FmxHandleToHWND(self.Handle), GWL_WNDPROC));
  NewWindowProc:= Pointer(SetWindowLong(FmxHandleToHWND(self.Handle), GWL_WNDPROC, Integer(@newWndProc)));

  m_BlurPanel := TBlurBehindControl.Create(Self);
  m_BlurPanel.SendToBack;

  UpdateBlurPanel;
end;

procedure TMainForm.UpdateBlurPanel;
begin
  MainForm.Visible := False;

  if m_bmpScreenShot = nil then
    m_bmpScreenShot := TakeScreenShot;

  m_BlurPanel.BackGroundBitmap := m_bmpScreenShot;
  RepaintBlurPanel;
  FreeAndNil(m_bmpScreenShot);

  MainForm.Visible := True;
end;

procedure TMainForm.RepaintBlurPanel;
begin
  m_BlurPanel.Position.X := 0;
  m_BlurPanel.Position.Y := 0;
  m_BlurPanel.Width      := Width;
  m_BlurPanel.Height     := Height;
  m_BlurPanel.Repaint;
end;

function newWndProc(hwnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var Mess : TMessage;
begin
  if hwnd = FmxHandleToHWND(MainForm.Handle) then
  begin
    case uMsg of
      WM_MOVE, WM_SIZE:
      begin
        MainForm.RepaintBlurPanel;
      end;
      WM_ACTIVATEAPP:
      begin
        MainForm.UpdateBlurPanel;
        Result := CallWindowProc(OldWindowProc, hwnd, uMsg, wParam, lParam);
      end
      else
      Result := CallWindowProc(OldWindowProc, hwnd, uMsg, wParam, lParam);
    end;
  end
  else Result := CallWindowProc(OldWindowProc, hwnd, uMsg, wParam, lParam);
end;


end.

