unit uZLConnection.Interfaces;

interface

uses
  System.Classes,
  uZLQry.Interfaces,
  uZLScript.Interfaces,
  uZLMemTable.Interfaces,
  uZLConnection.Types,
  uZLMigration,
  uZLSeeder,
  System.Generics.Collections;

type
  IZLConnection = interface
    ['{1104BA52-D8CC-40ED-88DD-F41FE5074839}']

    function ConnectionType: TZLConnLibType;
    function DriverDB: TZLDriverDB;
    function DataBaseName: String;
    function IsConnected: Boolean;
    function Connect: IZLConnection;
    function Disconnect: IZLConnection;
    function MakeQry: IZLQry;
    function OpenQry(ASQL: String): IZLQry;
    function ExecSQLQry(ASQL: String): IZLQry;
    function MakeScript: IZLScript;
    function MakeMemTable: IZLMemTable;
    function Instance: TComponent;
    function InTransaction: Boolean;
    function StartTransaction: IZLConnection;
    function CommitTransaction: IZLConnection;
    function RollBackTransaction: IZLConnection;
    function CreateMigrationTableIfNotExists: IZLConnection;
    function AddMigration(const ADescription, AScript: String): IZLConnection;
    function MigrationsHasBeenPerformed: IZLQry;
    function RunPendingMigrations: IZLConnection;
    function Migrations: TObjectList<TZLMigration>;
    function CreateSeederTableIfNotExists: IZLConnection;
    function AddSeeder(const ADescription, AScript: String): IZLConnection;
    function SeedersHasBeenPerformed: IZLQry;
    function RunPendingSeeders: IZLConnection;
    function Seeders: TObjectList<TZLSeeder>;
  end;

implementation

end.
