program ChatGPTFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainCGPT in 'MainCGPT.pas' {MForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMForm, MForm);
  Application.Run;
end.
