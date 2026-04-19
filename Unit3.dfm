object Main: TMain
  Left = 144
  Top = 9
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Main'
  ClientHeight = 499
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Fone: TImage
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    AutoSize = True
  end
  object BitBtn1: TBitBtn
    Left = 232
    Top = 296
    Width = 75
    Height = 25
    Caption = 'GO !!!!!'
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkIgnore
  end
  object MainMenu1: TMainMenu
    AutoLineReduction = maManual
    Left = 120
    Top = 24
    object N1: TMenuItem
      Caption = #1048#1075#1088#1072
      object N2: TMenuItem
        Caption = #1053#1086#1074#1072#1103' '#1073#1080#1090#1074#1072
      end
      object N15: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1091#1088#1086#1074#1077#1085#1100
        OnClick = N15Click
      end
      object N3: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = N3Click
      end
    end
    object Yfcnhjqrb1: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      RadioItem = True
      object N16: TMenuItem
        Caption = #1042#1086' '#1074#1077#1089#1100' '#1101#1082#1088#1072#1085
        OnClick = N16Click
      end
      object N4: TMenuItem
        Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077
        object N11: TMenuItem
          Caption = #1048#1075#1088#1086#1082' 1'
          object N5: TMenuItem
            Caption = #1050#1083#1072#1074#1072
            Checked = True
            OnClick = N5Click
          end
          object N6: TMenuItem
            Caption = #1052#1099#1096#1100
            OnClick = N6Click
          end
          object N14: TMenuItem
            Caption = #1050#1083#1072#1074#1080#1096#1080' ...'
          end
        end
        object N21: TMenuItem
          Caption = #1048#1075#1088#1086#1082' 2'
          object N7: TMenuItem
            Caption = #1050#1083#1072#1074#1072
          end
          object N8: TMenuItem
            Caption = #1052#1099#1096#1100
            OnClick = N8Click
          end
        end
        object N41: TMenuItem
          Caption = #1048#1075#1088#1086#1082' 3'
          object N9: TMenuItem
            Caption = #1050#1083#1072#1074#1072
          end
          object N10: TMenuItem
            Caption = #1052#1099#1096#1100
          end
        end
        object N42: TMenuItem
          Caption = #1048#1075#1088#1086#1082' 4'
          object N12: TMenuItem
            Caption = #1050#1083#1072#1074#1072
          end
          object N13: TMenuItem
            Caption = #1052#1099#1096#1100
          end
        end
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 280
    Top = 16
  end
end
