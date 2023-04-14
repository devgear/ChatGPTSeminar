program ChatGPTQuery;

uses
  Vcl.Forms,
  MForm in 'MForm.pas' {Form1},
  DModule in 'DModule.pas' {MyDModule: TDataModule},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glow');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TMyDModule, MyDModule);
  Application.Run;
end.
