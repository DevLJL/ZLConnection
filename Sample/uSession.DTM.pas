unit uSession.DTM;

interface

uses
  System.SysUtils, System.Classes;

type
  TSessionDTM = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  end;

var
  SessionDTM: TSessionDTM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
  uConnMigration;

{$R *.dfm}

procedure TSessionDTM.DataModuleCreate(Sender: TObject);
begin
  ConnMigration.RunPendingMigrations;
end;

end.
