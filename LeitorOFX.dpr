program LeitorOFX;

uses
  Forms,
  frmLeitorOFX in 'frmLeitorOFX.pas' {Form1},
  uLerOFX in 'uLerOFX.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
