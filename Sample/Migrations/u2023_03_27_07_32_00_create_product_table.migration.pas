unit u2023_03_27_07_32_00_create_product_table.migration;

interface

uses
  uBase.Migration;

type
  TMigration = class(TBaseMigration)
    constructor Create;
  end;

var
  Migration: TMigration;

implementation

uses
  uConnMigration;

constructor TMigration.Create;
const
  L_SCRIPT = ' CREATE TABLE IF NOT EXISTS `product` ( '+
             '   id bigint NOT NULL AUTO_INCREMENT, '+
             '   name varchar(80) NOT NULL, '+
             '   price decimal(18,4) DEFAULT NULL, '+
             '   note text, '+
             '   PRIMARY KEY (`id`) '+
             ' ) ';
begin
  inherited Create;
  ConnMigration.AddMigration(Self.UnitName, L_SCRIPT);
end;

initialization
  Migration := TMigration.Create;
  Migration.Free;

end.
