unit uZLSeeder;

interface

type
  TZLSeeder = class
  private
    FDescription: String;
    FScript: String;
    constructor Create(const ADescription, AScript: string);
  public
    class function Make(const ADescription, AScript: string): TZLSeeder;
    function Description(AValue: String): TZLSeeder; overload;
    function Description: String; overload;

    function Script(AValue: String): TZLSeeder; overload;
    function Script: String; overload;
  end;

implementation

{ TZLSeeder }

constructor TZLSeeder.Create(const ADescription, AScript: string);
begin
  inherited Create;
  FDescription := ADescription;
  FScript      := AScript;
end;

function TZLSeeder.Description: String;
begin
  Result := FDescription;
end;

class function TZLSeeder.Make(const ADescription, AScript: string): TZLSeeder;
begin
  Result := Self.Create(ADescription, AScript);
end;

function TZLSeeder.Description(AValue: String): TZLSeeder;
begin
  Result := Self;
  FDescription := AValue;
end;

function TZLSeeder.Script: String;
begin
  Result := FScript;
end;

function TZLSeeder.Script(AValue: String): TZLSeeder;
begin
  Result := Self;
  FScript := AValue;
end;

end.
