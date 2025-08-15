unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, SharedAPI, TaskManager, Generics.Collections;

type
  TFrmMain = class(TForm, ITaskCallback)
    pnlTasks: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    pnlRunning: TPanel;
    pnlCompleted: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    lvAvailableTasks: TListView;
    lvRunningTasks: TListView;
    lvCompletedTasks: TListView;
    btnLoadDLL: TButton;
    OpenDialog: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLoadDLLClick(Sender: TObject);
    procedure lvAvailableTasksDblClick(Sender: TObject);
  private
    FTaskManager: TTaskManager;
    procedure LoadTasksFromDLL(const DLLPath: string);
    procedure UpdateTaskLists;
    // ITaskCallback
    procedure UpdateProgress(TaskID: string; Progress: Integer);
    procedure SendLogMessage(TaskID: string; const Message: string);
    procedure TaskCompleted(TaskID: string; Result: TTaskResult);
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  FTaskManager := TTaskManager.Create;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  FTaskManager.Free;
end;
procedure TfrmMain.btnLoadDLLClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    LoadTasksFromDLL(OpenDialog.FileName);
    UpdateTaskLists;
  end;
end;

procedure TFrmMain.LoadTasksFromDLL(const DLLPath: string);
begin
  FTaskManager.LoadDLL(DLLPath);
end;

procedure TFrmMain.UpdateTaskLists;
var
  i: Integer;
  TaskInfo: TTaskInfo;
  Item: TListItem;
begin
  lvAvailableTasks.Items.Clear;
  for i := 0 to FTaskManager.AvailableTaskCount - 1 do
  begin
    TaskInfo := FTaskManager.GetAvailableTaskInfo(i);
    Item := lvAvailableTasks.Items.Add;
    Item.Caption := TaskInfo.Name;
    Item.SubItems.Add(TaskInfo.Description);
    Item.Data := Pointer(i);
  end;
end;

procedure TFrmMain.lvAvailableTasksDblClick(Sender: TObject);
var
  TaskIndex: Integer;
  Params: TTaskParameters;
  // Здесь должна быть логика получения параметров от пользователя
begin
  if lvAvailableTasks.Selected = nil then Exit;
  TaskIndex := Integer(lvAvailableTasks.Selected.Data);
  // TODO: Запросить параметры у пользователя
  SetLength(Params, 0);
  FTaskManager.RunTask(TaskIndex, Params, Self);
end;

// ITaskCallback implementation
procedure TfrmMain.UpdateProgress(TaskID: string; Progress: Integer);
begin
  // Обновить прогресс в интерфейсе
end;

procedure TfrmMain.SendLogMessage(TaskID: string; const Message: string);
begin
  // Добавить сообщение в лог
end;

procedure TfrmMain.TaskCompleted(TaskID: string; Result: TTaskResult);
begin
  // Обновить списки задач
  UpdateTaskLists;
  // Показать результаты
end;

end.
