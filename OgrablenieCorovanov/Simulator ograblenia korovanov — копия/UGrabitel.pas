unit UGrabitel;

interface

uses System.UITypes, System.Types, System.Generics.Collections;

type
  TGr = class
    Road: Integer;
    Pos: Integer;
    Damage: Integer;
    LSD: Integer;
    constructor Create (APos, ADamage, ALSD: Integer);
  end;

  TGrs = class   (TObjectList<TGr>)
    procedure NewGr (APos, ADamage, ALSD: Integer);
  end;

implementation

{ TGr }

constructor TGr.Create(APos, ADamage, ALSD: Integer);
begin
  Pos := APos;
  Damage := ADamage;
  LSD := ALSD;
end;

{ TGrs }

procedure TGrs.NewGr(APos, ADamage, ALSD: Integer);
begin
  Add(TGr.Create(APos, ADamage, ALSD));
end;

end.
