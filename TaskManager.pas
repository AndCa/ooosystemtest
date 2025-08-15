unit TaskManager;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, SharedAPI, DLLLoader;

type
  TTaskManager = class
  private
    FDLLLoaders: TObjectList<TDLLLoader>;
    FAvailableTasks: TList<ITask>;
    FRunningTasks: TDictionary<string, ITask>;
    FCompletedTasks: TDictionary<string, TTaskResult>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadDLL(const Path: string);
    function AvailableTaskCount: Integer;
    function GetAvailableTaskInfo(Index: Integer): TTaskInfo;
    procedure RunTask(TaskIndex: Integer; Parameters: TTaskParameters; Callback: ITaskCallback);
    procedure CancelTask(const TaskID: string);

    property RunningTasks: TDictionary<string, ITask> read FRunningTasks;
    property CompletedTasks: TDictionary<string, TTaskResult> read FCompletedTasks;
  end;

implementation

constructor TTaskManager.Create;
begin
  inherited;
  FDLLLoaders := TObjectList<TDLLLoader>.Create(True);
  FAvailableTasks := TList<ITask>.Create;
  FRunningTasks := TDictionary<string, ITask>.Create;
  FCompletedTasks := TDictionary<string, TTaskResult>.Create;
end;

destructor TTaskManager.Destroy;
begin
  FCompletedTasks.Free;
  FRunningTasks.Free;
  FAvailableTasks.Free;
  FDLLLoaders.Free;
  inherited;
end;

procedure TTaskManager.LoadDLL(const Path: string);
var
  DLLLoader: TDLLLoader;
  TaskProvider: ITaskProvider;
  i, TaskCount: Integer;
begin
  DLLLoader := TDLLLoader.Create(Path);
  try
    TaskProvider := DLLLoader.GetTaskProvider;
    if Assigned(TaskProvider) then
    begin
      FDLLLoaders.Add(DLLLoader);
      TaskCount := TaskProvider.GetTaskCount;
      for i := 0 to TaskCount - 1 do
        FAvailableTasks.Add(TaskProvider.GetTask(i));
    end
    else
      DLLLoader.Free;
  except
    DLLLoader.Free;
    raise;
  end;
end;

function TTaskManager.AvailableTaskCount: Integer;
begin
  Result := FAvailableTasks.Count;
end;

function TTaskManager.GetAvailableTaskInfo(Index: Integer): TTaskInfo;
begin
  if (Index < 0) or (Index >= FAvailableTasks.Count) then
    raise EListError.Create('Index out of bounds');

  Result := FAvailableTasks[Index].GetTaskInfo;
end;

procedure TTaskManager.RunTask(TaskIndex: Integer; Parameters: TTaskParameters;
  Callback: ITaskCallback);
var
  Task: ITask;
  TaskInfo: TTaskInfo;
begin
  if (TaskIndex < 0) or (TaskIndex >= FAvailableTasks.Count) then
    raise EListError.Create('Index out of bounds');

  Task := FAvailableTasks[TaskIndex];
  TaskInfo := Task.GetTaskInfo;

  FRunningTasks.Add(TaskInfo.TaskID, Task);

  // Запускаем задачу в отдельном потоке
  TThread.CreateAnonymousThread(
    procedure
    begin
      Task.Execute(Parameters, Callback);
    end
  ).Start;
end;

procedure TTaskManager.CancelTask(const TaskID: string);
var
  Task: ITask;
begin
  if FRunningTasks.TryGetValue(TaskID, Task) then
    Task.Cancel;
end;


end.
