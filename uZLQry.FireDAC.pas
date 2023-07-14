unit uZLQry.FireDAC;

interface

uses
  uZLQry.Interfaces,
  uZLMemTable.Interfaces,
  FireDAC.Comp.Client,
  Data.DB;

type
  TZLQryFireDAC = class(TInterfacedObject, IZLQry)
  private
    FConnection: TFDConnection;
    FQry: TFDQuery;
    constructor Create(AConnection: TFDConnection);
  public
    class function Make(AConnection: TFDConnection): IZLQry;
    destructor Destroy; override;

    function Open(ASQL: String): IZLQry;
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
    function ToMemTable: IZLMemTable;
  end;

implementation

uses
  System.SysUtils,
  uZLMemTable.FireDAC;

{ TZLQryFireDAC }

function TZLQryFireDAC.Close: IZLQry;
begin
  Result := Self;
  FQry.Close;
end;

constructor TZLQryFireDAC.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection     := AConnection;
  FQry            := TFDQuery.Create(nil);
  FQry.Connection := FConnection;
end;

function TZLQryFireDAC.DataSet: TDataSet;
begin
  Result := TDataSet(FQry);
end;

destructor TZLQryFireDAC.Destroy;
begin
  if Assigned(FQry) then FreeAndNil(FQry);

  inherited;
end;

function TZLQryFireDAC.Eof: Boolean;
begin
  Result := FQry.Eof;
end;

function TZLQryFireDAC.ExecSQL(ASQL: String): IZLQry;
begin
  Result := Self;

  if FQry.Active then
    FQry.Close;

  FQry.ExecSQL(ASQL);
end;

function TZLQryFireDAC.Filter(AFilter: String): IZLQry;
begin
  Result := Self;
  FQry.Filter := AFilter;
end;

function TZLQryFireDAC.Filter: String;
begin
  Result := FQry.Filter;
end;

function TZLQryFireDAC.Filtered(AValue: Boolean): IZLQry;
begin
  Result := Self;
  FQry.Filtered := AValue;
end;

function TZLQryFireDAC.Filtered: Boolean;
begin
  Result := FQry.Filtered;
end;

function TZLQryFireDAC.First: IZLQry;
begin
  Result := Self;
  FQry.First;
end;

function TZLQryFireDAC.IsEmpty: Boolean;
begin
  Result := FQry.IsEmpty;
end;

function TZLQryFireDAC.Locate(AKeyFields, AKeyValues: String): Boolean;
begin
  Result := FQry.Locate(AKeyFields, AKeyValues, []);
end;

class function TZLQryFireDAC.Make(AConnection: TFDConnection): IZLQry;
begin
  Result := Self.Create(AConnection);
end;

function TZLQryFireDAC.Next: IZLQry;
begin
  Result := Self;
  FQry.Next;
end;

function TZLQryFireDAC.Open(ASQL: String): IZLQry;
begin
  Result := Self;

  if FQry.Active                  then FQry.Close;
  if FQry.Filtered                then FQry.Filtered := False;
  if not FQry.Filter.Trim.IsEmpty then FQry.Filter   := EmptyStr;

  FQry.Open(ASQL);
end;

function TZLQryFireDAC.RecordCount: Integer;
begin
  Result := FQry.RecordCount;
end;

function TZLQryFireDAC.ToMemTable: IZLMemTable;
begin
  Result := TZLMemTableFireDAC.Make.FromDataSet(FQry);
end;

end.
