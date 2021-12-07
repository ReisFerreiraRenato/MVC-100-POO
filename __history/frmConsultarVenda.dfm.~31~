object frmConsultarVendas: TfrmConsultarVendas
  Left = 0
  Top = 0
  Caption = 'frmConsultarVendas'
  ClientHeight = 458
  ClientWidth = 879
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 23
  object Label1: TLabel
    Left = 8
    Top = 3
    Width = 46
    Height = 23
    Caption = 'Data:'
  end
  object Label2: TLabel
    Left = 168
    Top = 3
    Width = 166
    Height = 23
    Caption = 'N'#250'mero da Venda: '
  end
  object Label3: TLabel
    Left = 60
    Top = 7
    Width = 96
    Height = 19
    Caption = '(00/00/0000)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object tbNumeroVenda: TEdit
    Left = 168
    Top = 32
    Width = 432
    Height = 31
    NumbersOnly = True
    TabOrder = 1
    OnKeyDown = tbNumeroVendaKeyDown
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 80
    Width = 879
    Height = 378
    Align = alBottom
    DataSource = dmPrincipal.dsConsultarVenda
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentFont = False
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object btnBuscar: TButton
    Left = 602
    Top = 32
    Width = 101
    Height = 31
    Caption = 'Buscar'
    TabOrder = 2
    OnClick = btnBuscarClick
  end
  object Button2: TButton
    Left = 709
    Top = 32
    Width = 147
    Height = 31
    Caption = 'Consultar Itens'
    TabOrder = 3
    OnClick = Button2Click
  end
  object tbData: TEdit
    Left = 8
    Top = 32
    Width = 154
    Height = 31
    TabOrder = 0
    OnExit = tbDataExit
    OnKeyDown = tbDataKeyDown
  end
end
