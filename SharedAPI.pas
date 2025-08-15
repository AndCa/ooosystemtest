unit SharedAPI;

interface

uses
  System.Classes, System.SysUtils;

type
  TTaskStatus = (tsReady, tsRunning, tsCompleted, tsError, tsCancelled);

  TTaskParameter = record
    Name: string;
    Value: Variant;
    ParamType: string;
    Description: string;
  end;

  TTaskParameters = array of TTaskParameter;

  TTaskInfo = record
    TaskID: string;
    Name: string;
    Description: string;
    Parameters: TTaskParameters;
  end;

  TTaskResult = record
    Status: TTaskStatus;
    Output: string;
    ErrorMessage: string;
    Log: TStrings;
    Progress: Integer;
  end;

  // Callback-интерфейс для взаимодействия с основной программой
  ITaskCallback = interface
    ['{CCF3CFCD-61F6-4287-905E-269F4BEC6471}']
    procedure UpdateProgress(TaskID: string; Progress: Integer);
    procedure SendLogMessage(TaskID: string; const Message: string);
    procedure TaskCompleted(TaskID: string; Result: TTaskResult);
  end;

  // Интерфейс для задач
  ITask = interface
    ['{5010D980-AE7B-4125-9E80-D0D2EF43C28D}']
    function GetTaskInfo: TTaskInfo;
    procedure Execute(Parameters: TTaskParameters; Callback: ITaskCallback);
    procedure Cancel;
  end;

  // Интерфейс для DLL
  ITaskProvider = interface
    ['{17F0327F-2752-446B-9D5C-C365A82364C2}']
    function GetTaskCount: Integer;
    function GetTask(Index: Integer): ITask;
  end;

// Функция, которую должна экспортировать каждая DLL
function GetTaskProvider: ITaskProvider; stdcall;

implementation

function GetTaskProvider: ITaskProvider; stdcall;
begin
  // Реализация в DLL
  Result := nil;
end;

end.
