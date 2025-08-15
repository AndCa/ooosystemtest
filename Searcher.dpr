program Searcher;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {FrmMain},
  TaskManager in 'TaskManager.pas',
  DLLLoader in 'DLLLoader.pas',
  SharedAPI in 'SharedAPI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
