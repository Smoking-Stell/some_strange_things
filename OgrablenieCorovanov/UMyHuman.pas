unit UMyHuman;

interface

Uses
  System.UITypes, System.Types, System.Generics.Collections;

type
  TVelocity = record
    Value : Single;
    Direct: Integer;
  end;

  TMyHuman = class
    private
      Health: Integer;
      VelocityX: TVelocity;
      VelocityY: TVelocity;
      PosX: Single;
      PosY: Single;
      Field: boolean;
     public
      Constructor Create(APosX, APosY: Single);  virtual;
      Procedure SetHealth(AHealth: integer);
      Procedure SetVelocityX(AVelocityX: TVelocity);
      Procedure SetVelocityY(AVelocityY: TVelocity);
      Procedure SetPosX(APosX: Single);
      Procedure SetPosY(APosY: Single);
      Procedure SetField(AField: boolean);
      Function GetHealth: Integer;
      Function GetVelocityX: TVelocity;
      Function GetVelocityY: TVelocity;
      Function GetPosX: Single;
      Function GetPosY: Single;
      Function GetField: Boolean;
  end;

    TTank = class(TMyHuman)
      Constructor Create(APosX, APosY: Single);  override;
    end;

    TDemon = class(TMyHuman)
      private
        Btoom: boolean;
      public
        procedure SetBtoom(ABtoom: boolean);
        function  GetBtoom: boolean;
        Co
    end;


implementation

{ TMyHuman }

constructor TMyHuman.Create(APosX, APosY: Single);
begin
  Health := 1;
  VelocityX := 2;
  VelocityY := 2;
  PosX := APosX;
  PosY := APosY;
end;

function TMyHuman.GetField: Boolean;
begin
   Result := Field;
end;

function TMyHuman.GetHealth: Integer;
begin
    Result := Health;
end;

function TMyHuman.GetPosX: Single;
begin
    Result := PosX;
end;

function TMyHuman.GetPosY: Single;
begin
    Result := PosY;
end;

function TMyHuman.GetVelocityX: TVelocity;
begin
    Result := VelocityX;
end;

function TMyHuman.GetVelocityY: TVelocity;
begin
    Result := VelocityY;
end;

procedure TMyHuman.SetField(AField: boolean);
begin
    Field := AField;
end;

procedure TMyHuman.SetHealth(AHealth: integer);
begin
    Health := AHealth;
end;

procedure TMyHuman.SetPosX(APosX: Single);
begin
    PosX := APosX
end;

procedure TMyHuman.SetPosY(APosY: Single);
begin
    PosY := APosY;
end;

procedure TMyHuman.SetVelocityX(AVelocityX: TVelocity);
begin
   VelocityX := AVelocityX;
end;

procedure TMyHuman.SetVelocityY(AVelocityY: TVelocity);
begin
   VelocityY := AVelocityY;
end;

{ TTank }

constructor TTank.Create(APosX, APosY: Single);
begin
  inherited;
  Health := 5;
  VelocityX := 1;
  VelocityY := 1;
end;

end.
