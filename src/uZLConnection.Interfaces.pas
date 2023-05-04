unit uZLConnection.Interfaces;

interface

uses
  System.Classes,
  uZLQry.Interfaces,
  uZLScript.Interfaces,
  uZLMemTable.Interfaces,
  uZLConnection.Types;

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
    function CreateSeederTableIfNotExists: IZLConnection;
    function AddSeeder(const ADescription, AScript: String): IZLConnection;
    function SeedersHasBeenPerformed: IZLQry;
    function RunPendingSeeders: IZLConnection;
  end;

implementation

end.
