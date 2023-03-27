unit uZLMemTable.FireDAC;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  FireDAC.Comp.Client;

type
  TZLMemTableFireDAC = class(TInterfacedObject, IZLMemTable)
  private
    FMemTable: TFDMemTable;
    constructor Create;
  public
    destructor Destroy; override;
    class function Make: IZLMemTable;

    function FromJsonString(AJsonString: String): IZLMemTable;
    function FromDataSet(ADataSet: TDataSet): IZLMemTable;
    function ToJSONObjectString(const AOnlyUpdatedRecords: Boolean = False; const AChildRecords: Boolean = True; const AValueRecords: Boolean = True; const AEncodeBase64Blob: Boolean = True): string;
    function DataSet: TDataSet;
    function FieldDefs: TFieldDefs;
    function CreateDataSet: IZLMemTable;
    function Active: Boolean; overload;
    function Active(AValue: Boolean): IZLMemTable; overload;
    function EmptyDataSet: IZLMemTable;
    function Locate(AKeyFields, AKeyValues: Variant): Boolean;
    function AddField(AFieldName: String; AFieldType: TFieldType; ASize: Integer = 0; AFieldKind: TFieldKind = fkData; AExpression: String = ''): IZLMemTable;
    function IndexFieldNames(AValue: String): IZLMemTable; overload;
    function IndexFieldNames: String; overload;
    function Append: IZLMemTable;
    function Edit: IZLMemTable;
    function Post: IZLMemTable;
    function Delete: IZLMemTable;
    function Cancel: IZLMemTable;
    function FieldByName(AValue: String): TField;
    function First: IZLMemTable;
    function Eof: Boolean;
    function Next: IZLMemTable;
    function RecordCount: Int64;
    function AggregatesActive(AValue: Boolean): IZLMemTable; overload;
    function AggregatesActive: Boolean; overload;
    function State: TDataSetState;
    function DisableControls: IZLMemTable;
    function EnableControls: IZLMemTable;
    function GetBookMark: TArray<System.Byte>;
    function GoToBookMark(ABookMark: TArray<System.Byte>): IZLMemTable;
    function FreeBookMark(ABookMark: TArray<System.Byte>): IZLMemTable;
    function IsEmpty: Boolean;
    function AutoCalcFields: Boolean; overload;
    function AutoCalcFields(AValue: Boolean): IZLMemTable; overload;
    function CloneCursor(ASource: TDataSet; AReset: Boolean = False; AKeepSettings: Boolean = False): IZLMemTable;
  end;

implementation

uses
  System.SysUtils,
  DataSet.Serialize,
  FireDAC.Comp.DataSet,
  System.Classes;

{ TZLMemTableFireDAC }

function TZLMemTableFireDAC.Active(AValue: Boolean): IZLMemTable;
begin
  Result := Self;
  FMemTable.Active := AValue;
end;

function TZLMemTableFireDAC.AddField(AFieldName: String; AFieldType: TFieldType; ASize: Integer; AFieldKind: TFieldKind; AExpression: String): IZLMemTable;
var
  lField: TField;
  lAgg: TAggregateField;
begin
  Result := Self;

  // Campo do tipo AggregateField
  if (AFieldKind = fkAggregate) then
  begin
    lAgg               := TAggregateField.Create(FMemTable);
    lAgg.FieldName     := AFieldName;
    lAgg.Active        := true;
    lAgg.DisplayName   := AFieldName;
    lAgg.Expression    := AExpression;
    lAgg.DataSet       := FMemTable;
    lAgg.Alignment     := taRightJustify;
    lAgg.DisplayFormat := '#,###,##0.00';
    FMemTable.AggregatesActive := True;
    Exit;
  end;

  // Outros tipos de Field
  case AFieldType of
    ftString:   lField := TStringField.Create(FMemTable);
    ftSmallint: lField := TSmallintField.Create(FMemTable);
    ftInteger:  lField := TIntegerField.Create(FMemTable);
    ftBoolean:  lField := TBooleanField.Create(FMemTable);
    ftFloat:    lField := TFloatField.Create(FMemTable);
    ftCurrency: lField := TCurrencyField.Create(FMemTable);
    ftDate:     lField := TDateField.Create(FMemTable);
    ftDateTime: lField := TDateTimeField.Create(FMemTable);
    ftLargeint: lField := TLargeintField.Create(FMemTable);
  end;
  lField.FieldName         := AFieldName;
  lField.DisplayLabel      := AFieldName;
  lField.Size              := ASize;
  lField.Required          := False;
  lField.FieldKind         := AFieldKind;
  lField.DefaultExpression := AExpression;
  lField.DataSet           := FMemTable;
end;

//var
//  lField: TField;
//  lFieldDef: TFieldDef;
//  oField: TAggregateField;
//begin
//  Result := Self;
//
//  // Criar Aggregate
//  if (AFieldKind = fkAggregate) then
//  begin
//    oField := TAggregateField.Create(FMemTable);
//    oField.FieldName  := AFieldName;
//    oField.Expression := AExpression;
//    oField.DataSet    := FMemTable;
//
////    With FMemTable.Aggregates.Add do
////    begin
////      Expression := AExpression;
////      Name       := AFieldName;
////      Active     := True;
////    end;
//    Exit;
//  end;
//
//  // Criar CalcFields
//  case AFieldType of
//    ftString:   lField := TStringField.Create(FMemTable);
//    ftSmallint: lField := TSmallintField.Create(FMemTable);
//    ftInteger:  lField := TIntegerField.Create(FMemTable);
//    ftBoolean:  lField := TBooleanField.Create(FMemTable);
//    ftFloat:    lField := TFloatField.Create(FMemTable);
//    ftCurrency: lField := TCurrencyField.Create(FMemTable);
//    ftDate:     lField := TDateField.Create(FMemTable);
//    ftDateTime: lField := TDateTimeField.Create(FMemTable);
//    ftLargeint: lField := TLargeintField.Create(FMemTable);
//  end;
//
//  // Calculados
//  lField.FieldName    := AFieldName;
//  lField.DisplayLabel := AFieldName;
//  lField.Size         := ASize;
//  lField.Required     := False;
//  lField.FieldKind    := AFieldKind;
//  lField.DataSet      := FMemTable;
//end;

function TZLMemTableFireDAC.AggregatesActive: Boolean;
begin
  Result := FMemTable.AggregatesActive;
end;

function TZLMemTableFireDAC.AggregatesActive(AValue: Boolean): IZLMemTable;
begin
  Result := Self;
  FMemTable.AggregatesActive := AValue;
end;

function TZLMemTableFireDAC.Append: IZLMemTable;
begin
  Result := Self;
  FMemTable.Append;
end;

function TZLMemTableFireDAC.AutoCalcFields(AValue: Boolean): IZLMemTable;
begin
  Result := Self;
  FMemTable.AutoCalcFields := AValue;
end;

function TZLMemTableFireDAC.AutoCalcFields: Boolean;
begin
  Result := FMemTable.AutoCalcFields;
end;

function TZLMemTableFireDAC.Active: Boolean;
begin
  Result := FMemTable.Active;
end;

function TZLMemTableFireDAC.Cancel: IZLMemTable;
begin
  Result := Self;
  FMemTable.Cancel;
end;

function TZLMemTableFireDAC.CloneCursor(ASource: TDataSet; AReset, AKeepSettings: Boolean): IZLMemTable;
begin
  Result := Self;
  FMemTable.CloneCursor(TFDDataSet(ASource), AReset, AKeepSettings);
end;

constructor TZLMemTableFireDAC.Create;
begin
  inherited Create;
  FMemTable := TFDMemTable.Create(nil);
  FMemTable.Fields.Clear;
end;

function TZLMemTableFireDAC.CreateDataSet: IZLMemTable;
begin
  Result := Self;
  FMemTable.CreateDataSet;
end;

function TZLMemTableFireDAC.DataSet: TDataSet;
begin
  Result := TDataSet(FMemTable);
end;

function TZLMemTableFireDAC.Delete: IZLMemTable;
begin
  Result := Self;
  FMemTable.Delete;
end;

destructor TZLMemTableFireDAC.Destroy;
begin
  if Assigned(FMemTable) then FreeAndNil(FMemTable);

  inherited;
end;

function TZLMemTableFireDAC.DisableControls: IZLMemTable;
begin
  Result := Self;
  FMemTable.DisableControls;
end;

function TZLMemTableFireDAC.Edit: IZLMemTable;
begin
  Result := Self;
  FMemTable.Edit;
end;

function TZLMemTableFireDAC.EmptyDataSet: IZLMemTable;
begin
  Result := Self;
  if FMemTable.Active then
    FMemTable.EmptyDataSet;
end;

function TZLMemTableFireDAC.EnableControls: IZLMemTable;
begin
  Result := Self;
  FMemTable.EnableControls;
end;

function TZLMemTableFireDAC.Eof: Boolean;
begin
  Result := FMemTable.Eof;
end;

function TZLMemTableFireDAC.FieldByName(AValue: String): TField;
begin
  Result := FMemTable.FieldByName(AValue);
end;

function TZLMemTableFireDAC.FieldDefs: TFieldDefs;
begin
  Result := FMemTable.FieldDefs;
end;

function TZLMemTableFireDAC.First: IZLMemTable;
begin
  Result := Self;
  FMemTable.First;
end;

function TZLMemTableFireDAC.FreeBookMark(ABookMark: TArray<System.Byte>): IZLMemTable;
begin
  Result := Self;
  FMemTable.FreeBookmark(ABookMark);
end;

function TZLMemTableFireDAC.FromDataSet(ADataSet: TDataSet): IZLMemTable;
var
  lCloneSource: TFDMemTable;
  lI: Integer;
begin
  Result := Self;

  if not Assigned(FMemTable) then raise Exception.Create('FMemTable is null');
  if not Assigned(ADataSet)  then raise Exception.Create('ADataSet is null');
  if not ADataSet.Active     then raise Exception.Create('ADataSet is not active');

  Try
    lCloneSource := TFDMemTable.Create(nil);
    lCloneSource.CloneCursor(TFDMemTable(ADataSet), true);

    FMemTable.DisableControls;
    lCloneSource.DisableControls;

    // Limpar dados de Target se existir
    if FMemTable.Active then
    Begin
      FMemTable.EmptyDataSet;
      FMemTable.Close;
    End;

    // C�pia dos dados para Target
    FMemTable.Data := lCloneSource.Data;
    if ADataSet.Filtered then
    begin
      FMemTable.Filter   := ADataSet.Filter;
      FMemTable.Filtered := ADataSet.Filtered;
    end;

    // Nenhum campo � readonly
    for lI := 0 to Pred(ADataSet.Fields.Count) do
      ADataSet.Fields[lI].ReadOnly := False;
  Finally
    FMemTable.EnableControls;
    lCloneSource.EnableControls;
    if Assigned(lCloneSource) then
      FreeAndNil(lCloneSource);
  End;
end;

function TZLMemTableFireDAC.FromJsonString(AJsonString: String): IZLMemTable;
begin
  Result := Self;

  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := TCaseNameDefinition.cndLower;
  FMemTable.LoadFromJSON(AJsonString);
end;

function TZLMemTableFireDAC.GetBookMark: TArray<System.Byte>;
begin
  Result := FMemTable.GetBookmark;
end;

function TZLMemTableFireDAC.GoToBookMark(ABookMark: TArray<System.Byte>): IZLMemTable;
begin
  Result := Self;
  FMemTable.GotoBookmark(ABookMark);
end;

function TZLMemTableFireDAC.IndexFieldNames: String;
begin
  Result := FMemTable.IndexFieldNames;
end;

function TZLMemTableFireDAC.IsEmpty: Boolean;
begin
  Result := FMemTable.IsEmpty;
end;

function TZLMemTableFireDAC.IndexFieldNames(AValue: String): IZLMemTable;
begin
  Result := Self;
  FMemTable.IndexFieldNames := AValue;
end;

function TZLMemTableFireDAC.Locate(AKeyFields, AKeyValues: Variant): Boolean;
begin
  Result := FMemTable.Locate(AKeyFields, AKeyValues, [loCaseInsensitive]);
end;

class function TZLMemTableFireDAC.Make: IZLMemTable;
begin
  Result := Self.Create;
end;

function TZLMemTableFireDAC.Next: IZLMemTable;
begin
  Result := Self;
  FMemTable.Next;
end;

function TZLMemTableFireDAC.Post: IZLMemTable;
begin
  Result := Self;
  FMemTable.Post;
end;

function TZLMemTableFireDAC.RecordCount: Int64;
begin
  Result := FMemTable.RecordCount;
end;

function TZLMemTableFireDAC.State: TDataSetState;
begin
  Result := FMemTable.State;
end;

function TZLMemTableFireDAC.ToJSONObjectString(const AOnlyUpdatedRecords, AChildRecords, AValueRecords, AEncodeBase64Blob: Boolean): string;
begin
  Result := FMemTable.ToJSONObjectString(AOnlyUpdatedRecords, AChildRecords, AValueRecords, AEncodeBase64Blob);
end;

end.