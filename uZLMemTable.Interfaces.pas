unit uZLMemTable.Interfaces;

interface

uses
  Data.DB;

type
  IZLMemTable = interface
    ['{94ECF304-DF9C-4861-A332-8C438DBD0483}']

    function FromJson(AJsonString: String): IZLMemTable;
    function FromDataSet(ADataSet: TDataSet): IZLMemTable;
    function ToJson(const AOnlyUpdatedRecords: Boolean = False; const AChildRecords: Boolean = True; const AValueRecords: Boolean = True; const AEncodeBase64Blob: Boolean = True): string;
    function ToJsonArray(const AOnlyUpdatedRecords: Boolean = False; const AChildRecords: Boolean = True; const AValueRecords: Boolean = True; const AEncodeBase64Blob: Boolean = True): string;
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
    function FindField(AValue: String): TField;
    function FieldCount: Integer;
    function UnsignEvents: IZLMemTable;
    function Fields: TFields;
  end;


implementation

end.
