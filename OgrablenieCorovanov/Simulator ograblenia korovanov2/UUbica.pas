unit UUbica;

interface

uses System.UITypes, System.Types, System.Generics.Collections;

type
  TUb = class
    Road: Integer;
    Pos: Integer;
    Damage: Integer;
    LSD: Integer;
    Interval : Integer;
    Point: Integer;
    function SetDamage (ALSD, ADamage: Integer): Integer;
    constructor Create (APos, ARoad: Integer);
  end;

  TUbs = class   (TObjectList<TUb>)
    procedure NewGr (APos, ARoad: Integer);
  end;

  Const
    LSD1 = 5;
    Damage1 = 4;

implementation

{ TGr }

constructor TUb.Create(APos, Aroad: Integer);
begin
  Pos := APos;
  Damage := Damage1;
  LSD := LSD1;
  Road := ARoad;
  Interval := 0;
  Point := 0;
end;

function TUb.SetDamage(ALSD, ADamage: Integer): Integer;
begin
  Result :=0;
  if (Interval * ALSD = 100) then
    begin
      Result := ADamage;
      Interval := 0;
    end
  else
    Interval := Interval + 1;

end;

{ TGrs }
procedure TUbs.NewGr(APos, ARoad: Integer);
begin
  Add(TUb.Create(APos, ARoad));
end;

end.
