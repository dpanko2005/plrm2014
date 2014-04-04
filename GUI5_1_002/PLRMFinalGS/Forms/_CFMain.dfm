inherited MainForm2: TMainForm2
  Caption = 'MainForm2'
  PixelsPerInch = 120
  TextHeight = 16
  inherited BrowserPanel1: TPanel
    inherited BrowserPageControl: TPageControl
      inherited BrowserDataPage: TTabSheet
        inherited BrowserDataSplitter: TSplitter
          Top = 204
        end
        inherited ItemsLabel: TLabel
          Top = 180
        end
        inherited BrowserToolBar: TToolBar
          Height = 22
          inherited BrowserBtnUp: TToolButton [1]
            Left = 26
            Top = 0
            ExplicitLeft = 26
            ExplicitTop = 0
          end
          inherited BrowserBtnDelete: TToolButton [2]
            Left = 52
            ExplicitLeft = 52
          end
          inherited BrowserBtnEdit: TToolButton [3]
            Left = 78
            Wrap = False
            ExplicitLeft = 78
          end
          inherited BrowserBtnDown: TToolButton
            Left = 104
            Top = 0
            ExplicitLeft = 104
            ExplicitTop = 0
          end
          inherited BrowserBtnSort: TToolButton
            Left = 130
            Top = 0
            ExplicitLeft = 130
            ExplicitTop = 0
          end
        end
        inherited ItemListBox: TVirtualListBox
          Top = 207
          Height = 267
        end
      end
      inherited BrowserMapPage: TTabSheet
        ExplicitWidth = 173
        ExplicitHeight = 474
        inherited MapScrollBox: TScrollBox
          ExplicitWidth = 173
          ExplicitHeight = 474
        end
      end
    end
  end
end
