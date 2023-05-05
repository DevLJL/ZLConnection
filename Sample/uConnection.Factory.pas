unit uConnection.Factory;

interface

uses
  uZLConnection.Interfaces,
  uZLConnection.Types;

type
  TConnectionFactory = class
  public
    class function Make(const AConnType: TZLConnLibType = ctDefault): IZLConnection;
  end;

implementation

{ TConnectionFactory }

uses
  uZLConnection.FireDAC,
  uEnv;

class function TConnectionFactory.Make(const AConnType: TZLConnLibType): IZLConnection;
var
  lConnType: TZLConnLibType;
begin
  lConnType := AConnType;
  if (lConnType = ctDefault) then
    lConnType := Env.DefaultConnLibType;

  case lConnType of
    ctFireDAC: Result := TZLConnectionFireDAC.Make(
      ENV.Database,
      ENV.Server,
      ENV.UserName,
      ENV.Password,
      ENV.Driver,
      ENV.VendorLib
    );
    ctADO: {TZLConnectionADO.Make(
      ENV.Database,
      ENV.Server,
      ENV.UserName,
      ENV.Password,
      ENV.Driver,
      ENV.VendorLib
    )};
    ctZEOS: {TZLConnectionZEOS.Make(
      ENV.Database,
      ENV.Server,
      ENV.UserName,
      ENV.Password,
      ENV.Driver,
      ENV.VendorLib
    )};
  end;
end;

end.
