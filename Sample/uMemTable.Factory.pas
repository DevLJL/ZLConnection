unit uMemTable.Factory;

interface

uses
  uZLMemTable.Interfaces,
  uZLConnection.Types;

type
  TMemTableFactory = class
  public
    class function Make(const AConnType: TZLConnLibType = ctDefault): IZLMemTable;
  end;

implementation

{ TMemTableFactory }

uses
  uZLMemTable.FireDAC,
  uEnv;

class function TMemTableFactory.Make(const AConnType: TZLConnLibType): IZLMemTable;
var
  lConnType: TZLConnLibType;
begin
  lConnType := AConnType;
  if (lConnType = ctDefault) then
    lConnType := Env.DefaultConnLibType;

  case lConnType of
    ctFireDAC: Result := TZLMemTableFireDAC.Make;
    ctADO:     {Result := TZLMemTableADO.Make};
    ctZEOS:    {Result := TZLMemTableZEOS.Make};
  end;
end;

end.
