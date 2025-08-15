unit DLLLoader;

interface

uses
  System.SysUtils, Winapi.Windows, SharedAPI;

type
  TDLLLoader = class
  private
    FDLLHandle: HMODULE;
    FGetTaskProvider: function: ITaskProvider; stdcall;
  public
    constructor Create(const DLLPath: string);
    destructor Destroy; override;

    function GetTaskProvider: ITaskProvider;
  end;

implementation

constructor TDLLLoader.Create(const DLLPath: string);
begin
  FDLLHandle := LoadLibrary(PChar(DLLPath));
  if FDLLHandle = 0 then
    raise Exception.Create('Failed to load DLL: ' + DLLPath);

  @FGetTaskProvider := GetProcAddress(FDLLHandle, 'GetTaskProvider');
  if not Assigned(FGetTaskProvider) then
  begin
    FreeLibrary(FDLLHandle);
    raise Exception.Create('DLL does not export GetTaskProvider function');
  end;
end;

destructor TDLLLoader.Destroy;
begin
  if FDLLHandle <> 0 then
    FreeLibrary(FDLLHandle);
  inherited;
end;

function TDLLLoader.GetTaskProvider: ITaskProvider;
begin
  Result := FGetTaskProvider;
end;

end.
