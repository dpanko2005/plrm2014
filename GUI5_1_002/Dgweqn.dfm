object GWEqnForm: TGWEqnForm
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Custom Groundwater Flow Equation Editor'
  ClientHeight = 320
  ClientWidth = 616
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Padding.Left = 8
  Padding.Top = 8
  Padding.Right = 8
  Padding.Bottom = 8
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 447
    Height = 15
    Caption = 
      'Enter an expression to use in addition to the standard equation ' +
      'for groundwater flow '
  end
  object Label3: TLabel
    Left = 8
    Top = 27
    Width = 250
    Height = 15
    Caption = '(leave blank to use only the standard equation):'
  end
  object Edit1: TEdit
    Left = 8
    Top = 48
    Width = 505
    Height = 23
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 8
    Top = 87
    Width = 505
    Height = 225
    Color = clBtnFace
    Lines.Strings = (
      
        'The result of evaluating your custom equation will be added onto' +
        ' the result of the '
      
        'standard equation. To replace the standard equation completely s' +
        'et all of its coefficients '
      
        'to 0. Remember that groundwater flow units are cfs/acre for US u' +
        'nits and cms/ha for '
      'metric units.'
      ''
      'You can use the following symbols in your expression:'
      '   Hgw (for height of the groundwater table)'
      '   Hsw (for height of the surface water above aquifer bottom)'
      '   Hcb (for height of the channel bottom above aquifer bottom)'
      ''
      
        'Use the STEP function to have flow only when the groundwater lev' +
        'el is above a '
      'certain threshold. For example, the expression:'
      '    0.001 * (Hgw - 5) * STEP(Hgw - 5)'
      'would generate flow only when Hgw was above 5.')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
    Visible = False
  end
  object OkBtn: TButton
    Left = 533
    Top = 11
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 533
    Top = 47
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object Button1: TButton
    Left = 533
    Top = 87
    Width = 75
    Height = 25
    Caption = 'Notes . . .'
    TabOrder = 4
    OnClick = Button1Click
  end
end
