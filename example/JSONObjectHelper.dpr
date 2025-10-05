program JSONObjectHelper;

uses
  Vcl.Forms,
  UFrmMain in 'UFrmMain.pas' {Form1},
  JSONHelper in 'JSONHelper.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows11 Polar Light');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
