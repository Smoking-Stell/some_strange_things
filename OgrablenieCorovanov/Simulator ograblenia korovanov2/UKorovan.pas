unit UKorovan;

interface

  uses System.UITypes, System.Types, System.Generics.Collections;

  type

    TKorovan = class
      Health: Integer;
      Weight: Integer;
      Speed: Integer;
      Road: Integer;
      Pos: Integer;
      Length: Integer;
      Constructor Create (AWave: Integer);
      Procedure Move;
      Function  CheckDie(ADamage: Integer): Boolean;
      Function  CheckOut(RectOut: TRectF): Boolean;

    end;

    TKorovans = class (TObjectList<TKorovan>)
       Interval: Integer;
       procedure NewKorovan (LWave: Integer);
    end;

implementation

{ TKorovan }

function TKorovan.CheckOut(RectOut: TRectF): Boolean;
begin
  Result := False;
  if  (Pos < RectOut.Left) or
     (Pos > RectOut.Right) then
      begin
         Result := True;
      end;
end;

constructor TKorovan.Create(AWave: Integer);
begin
  Health :=AWave + 3;
  Speed := AWave + 2;
  if (AWave = 1) then
    Weight := 5
  else
    Weight := AWave + 1;
  Length := 50;
  Road := Random(4)+ 1;
end;

function TKorovan.CheckDie(ADamage: Integer): Boolean;
begin
  Result := False;
  Health := Health - ADamage;
  if Health <= 0 then
    Result := True;
end;

procedure TKorovan.Move;
begin
  Pos := Pos + Speed;
end;


{ TKorovans }

procedure TKorovans.NewKorovan(LWave: Integer);
begin
   if Interval >= 20 then
    begin
      Add(TKorovan.Create(LWave));
      Interval := 0;
    end
   else
    inc(Interval);
end;

end.
