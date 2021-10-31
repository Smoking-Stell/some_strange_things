program ProjectGame;

uses
  System.StartUpCopy,
  FMX.Forms,
  UMain in 'UMain.pas' {Form1},
  UGod in 'UGod.pas',
  UMyHuman in 'UMyHuman.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
