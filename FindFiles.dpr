library FindFiles;

uses
  System.SysUtils,
  System.Classes,
  SharedAPI,
  FindFilesTask in 'FindFilesTask.pas';

function GetTaskProvider: ITaskProvider; stdcall;
begin
  Result := TFindFilesTaskProvider.Create;
end;

exports

  GetTaskProvider;

begin
end.
