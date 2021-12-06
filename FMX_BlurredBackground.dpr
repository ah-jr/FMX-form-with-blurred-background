program FMX_BlurredBackground;

uses
  System.StartUpCopy,
  FMX.Forms,
  main in 'main.pas',
  BlurBehindControl in 'BlurBehindControl.pas',
  GraphicUtils in 'GraphicUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

