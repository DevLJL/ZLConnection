unit uZLMigration;

interface

type
  TZLMigration = class
  private
    FDescription: String;
    FScript: String;
    constructor Create(const ADescription, AScript: string);
  public
    class function Make(const ADescription, AScript: string): TZLMigration;
    function Description(AValue: String): TZLMigration; overload;
    function Description: String; overload;

    function Script(AValue: String): TZLMigration; overload;
    function Script: String; overload;
  end;

implementation

{ TZLMigration }

constructor TZLMigration.Create(const ADescription, AScript: string);
begin
  inherited Create;
  FDescription := ADescription;
  FScript      := AScript;
end;

function TZLMigration.Description: String;
begin
  Result := FDescription;
end;

class function TZLMigration.Make(const ADescription, AScript: string): TZLMigration;
begin
  Result := Self.Create(ADescription, AScript);
end;

function TZLMigration.Description(AValue: String): TZLMigration;
begin
  Result := Self;
  FDescription := AValue;
end;

function TZLMigration.Script: String;
begin
  Result := FScript;
end;

function TZLMigration.Script(AValue: String): TZLMigration;
begin
  Result := Self;
  FScript := AValue;
end;

end.
