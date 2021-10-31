program ProjectSOK;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  UMain in 'UMain.pas' {Form1},
  UKorovan in 'UKorovan.pas',
  UGrabitel in 'UGrabitel.pas',
  UMenu in 'UMenu.pas' {FrMenu: TFrame},
  UGame in 'UGame.pas' {FrGame: TFrame},
  UKyst in 'UKyst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
