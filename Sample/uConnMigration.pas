unit uConnMigration;

interface

uses
  uZLConnection.Interfaces;

type
  TConnMigration = class
  private
    FConn: IZLConnection;
    function Conn: IZLConnection;
  public
    constructor Create;
    function AddMigration(const ADescription, AScript: String): TConnMigration;
    procedure RunPendingMigrations;
  end;

var
  ConnMigration: TConnMigration;

implementation

{ TConnMigration }

uses
  uConnection.Factory;

function TConnMigration.AddMigration(const ADescription, AScript: String): TConnMigration;
begin
  Result := Self;
  FConn.AddMigration(ADescription, AScript);
end;

function TConnMigration.Conn: IZLConnection;
begin
  Result := FConn;
end;

constructor TConnMigration.Create;
begin
  inherited Create;
  FConn := TConnectionFactory.Make;
end;

procedure TConnMigration.RunPendingMigrations;
begin
  FConn.RunPendingMigrations;
  Self.Free;
end;

initialization
  ConnMigration := TConnMigration.Create;

end.
