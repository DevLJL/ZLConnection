unit uZLConnection.FireDAC;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Comp.UI,
  System.Classes,

  uZLConnection.Interfaces,
  uZLQry.Interfaces,
  uZLScript.Interfaces,
  uZLConnection.Types,
  System.Generics.Collections,
  uZLMigration,
  uZLSeeder;

type
  TZLConnectionFireDAC = class(TInterfacedObject, IZLConnection)
  private
    FConn: TFDConnection;
    FMySQLDriverLink: TFDPhysMySQLDriverLink;
    FConnectionType: TZLConnLibType;
    FDriverDB: TZLDriverDB;
    FDatabase,
    FServer,
    FUserName,
    FPassword,
    FDriverID,
    FVendorLib: String;
    FMigrations: TObjectList<TZLMigration>;
    FSeeders: TObjectList<TZLSeeder>;
    constructor Create(ADatabase, AServer, AUserName, APassword, ADriverID, AVendorLib: String);
    function SetUp: IZLConnection;
  public
    destructor Destroy; override;
    class function Make(ADatabase, AServer, AUserName, APassword, ADriverID, AVendorLib: String): IZLConnection;

    function ConnectionType: TZLConnLibType;
    function DriverDB: TZLDriverDB;
    function DataBaseName: String;
    function IsConnected: Boolean;
    function Connect: IZLConnection;
    function Disconnect: IZLConnection;
    function MakeQry: IZLQry;
    function MakeScript: IZLScript;
    function Instance: TComponent;
    function InTransaction: Boolean;
    function StartTransaction: IZLConnection;
    function CommitTransaction: IZLConnection;
    function RollBackTransaction: IZLConnection;
    function CreateMigrationTableIfNotExists: IZLConnection;
    function AddMigration(const ADescription, AScript: String): IZLConnection;
    function MigrationsHasBeenPerformed: IZLQry;
    function RunPendingMigrations: IZLConnection;
    function NextUUID: String;
    function CreateSeederTableIfNotExists: IZLConnection;
    function AddSeeder(const ADescription, AScript: String): IZLConnection;
    function SeedersHasBeenPerformed: IZLQry;
    function RunPendingSeeders: IZLConnection;
  end;

implementation

uses
  System.SysUtils,
  uZLQry.FireDAC,
  uZLScript.FireDAC,
  Winapi.Windows;

{ TConnection }

function TZLConnectionFireDAC.AddMigration(const ADescription, AScript: String): IZLConnection;
begin
  Result := Self;
  FMigrations.Add(TZLMigration.Make(ADescription, AScript));
end;

function TZLConnectionFireDAC.AddSeeder(const ADescription, AScript: String): IZLConnection;
begin
  Result := Self;
  FSeeders.Add(TZLSeeder.Make(ADescription, AScript));
end;

function TZLConnectionFireDAC.CommitTransaction: IZLConnection;
begin
  Result := Self;
  if FConn.InTransaction then
    FConn.Commit;
end;

function TZLConnectionFireDAC.Connect: IZLConnection;
begin
  Result := Self;
  FConn.Connected := True;
end;

function TZLConnectionFireDAC.ConnectionType: TZLConnLibType;
begin
  Result := ctFireDAC;
end;

constructor TZLConnectionFireDAC.Create(ADatabase, AServer, AUserName, APassword, ADriverID, AVendorLib: String);
begin
  inherited Create;

  FConn            := TFDConnection.Create(nil);
  FMySQLDriverLink := TFDPhysMySQLDriverLink.Create(nil);
  FDatabase        := ADatabase;
  FServer          := AServer;
  FUserName        := AUserName;
  FPassword        := APassword;
  FDriverID        := ADriverID;
  FVendorLib       := AVendorLib;
  FMigrations      := TObjectList<TZLMigration>.Create;
  FSeeders         := TObjectList<TZLSeeder>.Create;
  SetUp;
end;

function TZLConnectionFireDAC.CreateMigrationTableIfNotExists: IZLConnection;
const
  SELECT_MIGRATION_MYSQL = 'SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = %s AND table_name = %s';
  CREATE_MIGRATION_MYSQL = ' CREATE TABLE `migration` (                         '+
                           '   `id` bigint NOT NULL AUTO_INCREMENT,             '+
                           '   `description` varchar(255) NOT NULL,             '+
                           '   `executed_at` datetime DEFAULT NULL,             '+
                           '   `duration` decimal(18,4) DEFAULT NULL,           '+
                           '   `batch` varchar(36) DEFAULT NULL,                '+
                           '   PRIMARY KEY (`id`),                              '+
                           '   KEY `migration_idx_description` (`description`), '+
                           '   KEY `migration_idx_batch` (`batch`)              '+
                           ' )                                                  ';
var
  lQry: IZLQry;
begin
  // Criar Migration para o MySQL ###Precisa refatorar###
  if (FDriverDB = TZLDriverDB.ddMySql) then
  begin
    lQry := MakeQry.Open(Format(SELECT_MIGRATION_MYSQL, [QuotedStr(FDatabase), QuotedStr('migration')]));
    if (lQry.DataSet.Fields[0].AsInteger <= 0) then
      lQry.ExecSQL(CREATE_MIGRATION_MYSQL);
  end;
end;

function TZLConnectionFireDAC.CreateSeederTableIfNotExists: IZLConnection;
const
  SELECT_SEEDER_MYSQL = 'SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = %s AND table_name = %s';
  CREATE_SEEDER_MYSQL = ' CREATE TABLE `seeder` (                               '+
                           '   `id` bigint NOT NULL AUTO_INCREMENT,             '+
                           '   `description` varchar(255) NOT NULL,             '+
                           '   `executed_at` datetime DEFAULT NULL,             '+
                           '   `duration` decimal(18,4) DEFAULT NULL,           '+
                           '   `batch` varchar(36) DEFAULT NULL,                '+
                           '   PRIMARY KEY (`id`),                              '+
                           '   KEY `seeder_idx_description` (`description`),    '+
                           '   KEY `seeder_idx_batch` (`batch`)                 '+
                           ' )                                                  ';
var
  lQry: IZLQry;
begin
  // Criar Seeder para o MySQL ###Precisa refatorar###
  if (FDriverDB = TZLDriverDB.ddMySql) then
  begin
    lQry := MakeQry.Open(Format(SELECT_SEEDER_MYSQL, [QuotedStr(FDatabase), QuotedStr('seeder')]));
    if (lQry.DataSet.Fields[0].AsInteger <= 0) then
      lQry.ExecSQL(CREATE_SEEDER_MYSQL);
  end;
end;

function TZLConnectionFireDAC.DataBaseName: String;
begin
  Result := FConn.Params.Database;
end;

destructor TZLConnectionFireDAC.Destroy;
begin
  if Assigned(FConn)            then FreeAndNil(FConn);
  if Assigned(FMySQLDriverLink) then FreeAndNil(FMySQLDriverLink);
  if Assigned(FMigrations)      then FreeAndNil(FMigrations);
  if Assigned(FSeeders)         then FreeAndNil(FSeeders);

  inherited;
end;

function TZLConnectionFireDAC.Disconnect: IZLConnection;
begin
  Result := Self;
  FConn.Connected := False;
end;

function TZLConnectionFireDAC.DriverDB: TZLDriverDB;
begin
  Result := FDriverDB;
end;

function TZLConnectionFireDAC.Instance: TComponent;
begin
  Result := FConn;
end;

function TZLConnectionFireDAC.InTransaction: Boolean;
begin
  Result := FConn.InTransaction;
end;

function TZLConnectionFireDAC.IsConnected: Boolean;
begin
  Result := FConn.Connected;
end;

class function TZLConnectionFireDAC.Make(ADatabase, AServer, AUserName, APassword, ADriverID, AVendorLib: String): IZLConnection;
begin
  Result := Self.Create(ADatabase, AServer, AUserName, APassword, ADriverID, AVendorLib);
end;

function TZLConnectionFireDAC.MakeQry: IZLQry;
begin
  Result := TZLQryFireDAC.Make(FConn);
end;

function TZLConnectionFireDAC.MakeScript: IZLScript;
begin
  Result := TZLScriptFireDAC.Make(FConn);
end;

function TZLConnectionFireDAC.MigrationsHasBeenPerformed: IZLQry;
const
  MIGRATION_ORDER_BY_DESCRIPTION = 'select * from migration order by id';
begin
  Result := MakeQry.Open(MIGRATION_ORDER_BY_DESCRIPTION);
end;

function TZLConnectionFireDAC.NextUUID: String;
const
  L_CHARS_TO_REMOVE: TArray<String> = ['[',']','{','}'];
var
  lI: Integer;
begin
  Result := TGUID.NewGuid.ToString;
  for lI := 0 to High(L_CHARS_TO_REMOVE) do
    Result := StringReplace(Result, L_CHARS_TO_REMOVE[lI], '', [rfReplaceAll]);
end;

function TZLConnectionFireDAC.RollBackTransaction: IZLConnection;
begin
  Result := Self;
  FConn.Rollback;
end;

function TZLConnectionFireDAC.RunPendingMigrations: IZLConnection;
const
  L_INSERT_MIGRATION = ' INSERT INTO migration                         '+
                       '   (description, duration, batch, executed_at) '+
                       ' VALUES                                        '+
                       '   (%s, %s, %s, %s)                            ';
var
  lPendingMigrationsQry, lQryMigration: IZLQry;
  lScript: IZLScript;
  lMigration: TZLMigration;
  lStartTime: Cardinal;
  lDuration: Double;
  lBatch: String;
begin
  Result := Self;

  CreateMigrationTableIfNotExists;
  lPendingMigrationsQry := Self.MigrationsHasBeenPerformed;
  lQryMigration         := Self.MakeQry;
  lScript               := Self.MakeScript;
  lBatch                := Self.NextUUID;

  for lMigration in FMigrations do
  begin
    if lPendingMigrationsQry.First.Locate('description', lMigration.Description) then
      Continue;

    try
      lStartTime := GetTickCount;
      Self.StartTransaction;
      lScript
        .SQLScriptsClear
        .SQLScriptsAdd(lMigration.Script)
        .ValidateAll;
      if not lScript.ExecuteAll then
        raise Exception.Create('Error validation in migration: ' + lMigration.Description);

      // Registrar Migration
      lDuration := (GetTickCount - lStartTime)/1000;
      lQryMigration.ExecSQL(Format(L_INSERT_MIGRATION, [
        QuotedStr(lMigration.Description),
        QuotedStr(StringReplace(FormatFloat('0.0000', lDuration), FormatSettings.DecimalSeparator, '.', [rfReplaceAll,rfIgnoreCase])),
        QuotedStr(lBatch),
        QuotedStr(FormatDateTime('YYYY-MM-DD HH:MM:SS', now))
      ]));

      // Commit
      Self.CommitTransaction;
    Except
      Self.RollBackTransaction;
      raise;
    end;
  end;
end;

function TZLConnectionFireDAC.RunPendingSeeders: IZLConnection;
const
  L_INSERT_SEEDER = ' INSERT INTO seeder                               '+
                       '   (description, duration, batch, executed_at) '+
                       ' VALUES                                        '+
                       '   (%s, %s, %s, %s)                            ';
var
  lPendingSeedersQry, lQrySeeder: IZLQry;
  lScript: IZLScript;
  lSeeder: TZLSeeder;
  lStartTime: Cardinal;
  lDuration: Double;
  lBatch: String;
begin
  Result := Self;

  CreateSeederTableIfNotExists;
  lPendingSeedersQry    := Self.SeedersHasBeenPerformed;
  lQrySeeder            := Self.MakeQry;
  lScript               := Self.MakeScript;
  lBatch                := Self.NextUUID;

  for lSeeder in FSeeders do
  begin
    if lPendingSeedersQry.First.Locate('description', lSeeder.Description) then
      Continue;

    try
      lStartTime := GetTickCount;
      Self.StartTransaction;
      lScript
        .SQLScriptsClear
        .SQLScriptsAdd(lSeeder.Script)
        .ValidateAll;
      if not lScript.ExecuteAll then
        raise Exception.Create('Error validation in seeder: ' + lSeeder.Description);

      // Registrar Seeder
      lDuration := (GetTickCount - lStartTime)/1000;
      lQrySeeder.ExecSQL(Format(L_INSERT_SEEDER, [
        QuotedStr(lSeeder.Description),
        QuotedStr(StringReplace(FormatFloat('0.0000', lDuration), FormatSettings.DecimalSeparator, '.', [rfReplaceAll,rfIgnoreCase])),
        QuotedStr(lBatch),
        QuotedStr(FormatDateTime('YYYY-MM-DD HH:MM:SS', now))
      ]));

      // Commit
      Self.CommitTransaction;
    Except
      Self.RollBackTransaction;
      raise;
    end;
  end;
end;

function TZLConnectionFireDAC.SeedersHasBeenPerformed: IZLQry;
const
  SEEDER_ORDER_BY_DESCRIPTION = 'select * from seeder order by id';
begin
  Result := MakeQry.Open(SEEDER_ORDER_BY_DESCRIPTION);
end;

function TZLConnectionFireDAC.SetUp: IZLConnection;
begin
  Result := Self;
  With FConn.Params do
  begin
    Clear;
    Add('Database='  + FDatabase);
    Add('Server='    + FServer);
    Add('User_Name=' + FUserName);
    Add('Password='  + FPassword);
    Add('DriverID='  + FDriverID);
  end;
  FConn.LoginPrompt          := False;
  FMySQLDriverLink.VendorLib := FVendorLib;

  if (FDriverID.ToLower = 'mysql') then
    FDriverDB := ddMySql;
end;

function TZLConnectionFireDAC.StartTransaction: IZLConnection;
begin
  Result := Self;
  if not FConn.InTransaction then
    FConn.StartTransaction;
end;

end.
