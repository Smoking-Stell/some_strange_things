unit UMain;

interface

uses
  FMX.Types, FMX.Forms, System.Classes, System.Threading;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private

    { Private declarations }
  public
    Score: Integer;
    Level: Integer;
    { Public declarations }
  end;

  TFrameName = Class of TFrame;

  procedure SetFrame(NameFrame: TFrameName);

var
  Form1: TForm1;
  Frame: TFrame;

implementation
  uses UMenu;

{$R *.fmx}

procedure SetFrame(NameFrame: TFrameName);
begin
  TTask.Run(
    procedure
      begin
        TThread.Synchronize (nil,
        procedure
          begin
            if Assigned(Frame) then
            begin
              Form1.RemoveObject(Frame);
              {$IFDEF MSWINDOWS}
              Frame.Free;
              {$ELSE}
              Frame.DisposeOf;
              {$ENDIF}
              Frame := nil;
            end;
            Frame := NameFrame.Create(Form1);
            Frame.Parent := Form1;
            Frame.Align := TAlignLayout.Contents;
          end);
      end);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  SetFrame(TFrMenu);
end;

end.

