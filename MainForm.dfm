object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'Task Manager'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 250
    Width = 800
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 200
    ExplicitWidth = 600
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 450
    Width = 800
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 400
    ExplicitWidth = 600
  end
  object pnlTasks: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 250
    Align = alTop
    Caption = 'pnlTasks'
    TabOrder = 0
    ExplicitWidth = 796
    object lvAvailableTasks: TListView
      Left = 1
      Top = 42
      Width = 798
      Height = 207
      Align = alClient
      Columns = <
        item
          Caption = 'Task Name'
          Width = 200
        end
        item
          Caption = 'Description'
          Width = 500
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      ExplicitWidth = 794
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 798
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 794
      object Label1: TLabel
        Left = 120
        Top = 12
        Width = 73
        Height = 13
        Caption = 'Available Tasks'
      end
      object btnLoadDLL: TButton
        Left = 8
        Top = 8
        Width = 100
        Height = 25
        Caption = 'Load DLL...'
        TabOrder = 0
        OnClick = btnLoadDLLClick
      end
    end
  end
  object pnlRunning: TPanel
    Left = 0
    Top = 255
    Width = 800
    Height = 195
    Align = alTop
    Caption = 'pnlRunning'
    TabOrder = 1
    ExplicitWidth = 796
    object lvRunningTasks: TListView
      Left = 1
      Top = 42
      Width = 798
      Height = 152
      Align = alClient
      Columns = <
        item
          Caption = 'Task Name'
          Width = 200
        end
        item
          Caption = 'Status'
          Width = 100
        end
        item
          Caption = 'Progress'
          Width = 100
        end
        item
          Caption = 'Started At'
          Width = 150
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      ExplicitWidth = 794
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 798
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 794
      object Label2: TLabel
        Left = 8
        Top = 12
        Width = 69
        Height = 13
        Caption = 'Running Tasks'
      end
    end
  end
  object pnlCompleted: TPanel
    Left = 0
    Top = 455
    Width = 800
    Height = 145
    Align = alClient
    Caption = 'pnlCompleted'
    TabOrder = 2
    ExplicitWidth = 796
    ExplicitHeight = 144
    object lvCompletedTasks: TListView
      Left = 1
      Top = 42
      Width = 798
      Height = 102
      Align = alClient
      Columns = <
        item
          Caption = 'Task Name'
          Width = 200
        end
        item
          Caption = 'Status'
          Width = 100
        end
        item
          Caption = 'Completed At'
          Width = 150
        end
        item
          Caption = 'Result'
          Width = 300
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      ExplicitWidth = 794
      ExplicitHeight = 101
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 798
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 794
      object Label3: TLabel
        Left = 8
        Top = 12
        Width = 81
        Height = 13
        Caption = 'Completed Tasks'
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Dynamic Link Libraries (*.dll)|*.dll'
    Left = 384
    Top = 296
  end
end
