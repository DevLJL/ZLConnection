unit uZLScript.Interfaces;

interface

type
  IZLScript = interface
    ['{C567853B-7C44-41AC-BBEC-919AC4DA6FF5}']

    function SQLScriptsClear: IZLScript;
    function SQLScriptsAdd(AValue: String): IZLScript;
    function ValidateAll: Boolean;
    function ExecuteAll: Boolean;
  end;

implementation

end.
