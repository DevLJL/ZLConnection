unit uZLQry.Interfaces;

interface

uses
  Data.DB;

type
  IZLQry = Interface
    ['{C374FAF8-B85B-4E34-8474-33F178F93222}']

    function Open(ASQL: String): IZLQry;
    function AOpen(ASQL: String): IZLQry;
    function ExecSQL(ASQL: String): IZLQry;
    function DataSet: TDataSet;
    function Close: IZLQry;
    function Locate(AKeyFields, AKeyValues: String): Boolean;
    function IsEmpty: Boolean;
    function First: IZLQry;
    function Eof: Boolean;
    function Next: IZLQry;
    function Filter(AFilter: String): IZLQry; overload;
    function Filter: String; overload;
    function Filtered(AValue: Boolean): IZLQry overload;
    function Filtered: Boolean; overload;
    function RecordCount: Integer;
  end;

implementation

end.
