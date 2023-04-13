unit uZLConnection.Interfaces;

interface

uses
  System.Classes,
  uZLQry.Interfaces,
  uZLScript.Interfaces,
  uZLConnection.Types;

type
  IZLConnection = interface
    ['{264DE292-C1C2-471D-93C7-81C2582F29CE}']

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
    function CreateSeederTableIfNotExists: IZLConnection;
    function AddSeeder(const ADescription, AScript: String): IZLConnection;
    function SeedersHasBeenPerformed: IZLQry;
    function RunPendingSeeders: IZLConnection;
  end;

implementation

end.
