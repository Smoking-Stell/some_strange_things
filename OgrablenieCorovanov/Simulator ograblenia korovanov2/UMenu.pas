unit UMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, UMain, FMX.Objects;

type
  TFrMenu = class(TFrame)
    Text1: TText;
    RectPlay: TRoundRect;
    RectExit: TCircle;
    Text2: TText;
    Text3: TText;
    procedure RectExitClick(Sender: TObject);
    procedure RectPlayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses UGame;

{$R *.fmx}

procedure TFrMenu.RectExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrMenu.RectPlayClick(Sender: TObject);
begin
 SetFrame (TFrGame);
 //SetFrame (TFrGame2);
end;

end.
