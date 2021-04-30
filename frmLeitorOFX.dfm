object Form1: TForm1
  Left = 192
  Top = 125
  Width = 928
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 912
    Height = 41
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 432
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Ler'
      TabOrder = 0
      OnClick = Button1Click
    end
    object FilenameEdit1: TFilenameEdit
      Left = 8
      Top = 12
      Width = 401
      Height = 21
      NumGlyphs = 1
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 912
    Height = 400
    Align = alClient
    TabOrder = 1
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 910
      Height = 398
      Align = alClient
      TabOrder = 0
    end
  end
end
