unit FindFilesTask;

interface

uses
  System.SysUtils, System.Classes, System.Variants,
  System.Generics.Collections, SharedAPI;

type
  TFindFilesTask = class(TInterfacedObject, ITask)
  private
    FTaskInfo: TTaskInfo;
    FCancelled: Boolean;
  public
    constructor Create(const ID, Name, Description: string);
    function GetTaskInfo: TTaskInfo;
    procedure Execute(Parameters: TTaskParameters; Callback: ITaskCallback);
    procedure Cancel;
  end;

  TFindFilesTaskProvider = class(TInterfacedObject, ITaskProvider)
  private
    FTasks: TList<ITask>;
  public
    constructor Create;
    destructor Destroy; override;
    function GetTaskCount: Integer;
    function GetTask(Index: Integer): ITask;
  end;

implementation

{ TSampleTask }

constructor TFindFilesTask.Create(const ID, Name, Description: string);
begin
  inherited Create;
  FTaskInfo.TaskID := ID;
  FTaskInfo.Name := Name;
  FTaskInfo.Description := Description;

  // Пример параметров
  SetLength(FTaskInfo.Parameters, 2);
  FTaskInfo.Parameters[0].Name := 'InputFile';
  FTaskInfo.Parameters[0].ParamType := 'string';
  FTaskInfo.Parameters[0].Description := 'Path to input file';

  FTaskInfo.Parameters[1].Name := 'Iterations';
  FTaskInfo.Parameters[1].ParamType := 'integer';
  FTaskInfo.Parameters[1].Description := 'Number of iterations';
end;

function TFindFilesTask.GetTaskInfo: TTaskInfo;
begin
  Result := FTaskInfo;
end;

procedure TFindFilesTask.Execute(Parameters: TTaskParameters; Callback: ITaskCallback);
var
  I: Integer;
  Iterations: Integer;
  Log: TStringList;
  Result: TTaskResult;
begin
  FCancelled := False;
  Log := TStringList.Create;
  try
    try
      // Получаем параметры
      Iterations := Parameters[1].Value;

      Log.Add('Starting task: ' + FTaskInfo.Name);
      Callback.SendLogMessage(FTaskInfo.TaskID, 'Task started');

      for I := 1 to Iterations do
      begin
        if FCancelled then
        begin
          Log.Add('Task cancelled by user');
          Callback.SendLogMessage(FTaskInfo.TaskID, 'Task cancelled');
          Break;
        end;

        // Имитация работы
        Sleep(500);

        // Обновляем прогресс
        Callback.UpdateProgress(FTaskInfo.TaskID, Round(I / Iterations * 100));
        Log.Add(Format('Iteration %d of %d completed', [I, Iterations]));
      end;

      // Формируем результат
      Result.Status := tsCompleted;
      Result.Output := 'Task completed successfully';
      Result.ErrorMessage := '';
      Result.Log := Log;
      Result.Progress := 100;

      Callback.TaskCompleted(FTaskInfo.TaskID, Result);
    except
      on E: Exception do
      begin
        Log.Add('Error: ' + E.Message);
        Result.Status := tsError;
        Result.Output := '';
        Result.ErrorMessage := E.Message;
        Result.Log := Log;
        Result.Progress := 0;
        Callback.TaskCompleted(FTaskInfo.TaskID, Result);
      end;
    end;
  finally
    Log.Free;
  end;
end;

procedure TFindFilesTask.Cancel;
begin
  FCancelled := True;
end;

{ TFindFilesTaskProvider }

constructor TFindFilesTaskProvider.Create;
begin
  inherited;
  FTasks := TList<ITask>.Create;
  // Регистрируем доступные задачи
  FTasks.Add(TFindFilesTask.Create('TASK1', 'Sample Task 1', 'This is a sample task 1'));
  FTasks.Add(TFindFilesTask.Create('TASK2', 'Sample Task 2', 'This is a sample task 2'));
end;

destructor TFindFilesTaskProvider.Destroy;
begin
  FTasks.Free;
  inherited;
end;

function TFindFilesTaskProvider.GetTaskCount: Integer;
begin
  Result := FTasks.Count;
end;

function TFindFilesTaskProvider.GetTask(Index: Integer): ITask;
begin
  if (Index < 0) or (Index >= FTasks.Count) then
    raise EListError.Create('Index out of bounds');

  Result := FTasks[Index];
end;

end.
