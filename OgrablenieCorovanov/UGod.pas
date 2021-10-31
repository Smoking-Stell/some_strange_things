unit UGod;

interface

Uses
  System.UITypes, System.Types, System.Generics.Collections;
type

  TGod = class
    private
      Health: integer;
      Damage: integer;
    Public
      Constructor Create(AHealth, ADamage: integer);
      Procedure SetHealth(AHealth: integer);
      Procedure SetDamage(ADamage: integer);
      Function GetHealth: Integer;
      Function GetDamage: Integer;
  end;

implementation

{ TGod }

constructor TGod.Create(AHealth, ADamage: integer);
begin
  Health := AHealth;
  Damage := ADamage;
end;

function TGod.GetDamage: Integer;
begin
    Result := Damage;
end;

function TGod.GetHealth: Integer;
begin
    Result := Health;
end;

procedure TGod.SetDamage(ADamage: integer);
begin
   Damage := ADamage;
end;

procedure TGod.SetHealth(AHealth: integer);
begin
   Health := AHealth;
end;

end.
