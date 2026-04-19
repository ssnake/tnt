unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, Buttons, ExtCtrls, jpeg;

type
  TMain = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Yfcnhjqrb1: TMenuItem;
    N4: TMenuItem;
    N11: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N14: TMenuItem;
    N21: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N41: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N42: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N15: TMenuItem;
    OpenDialog1: TOpenDialog;
    BitBtn1: TBitBtn;
    N16: TMenuItem;
    Fone: TImage;
    procedure BitBtn1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure Load(const levelName: string);
    procedure FormCreate(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function SetFullscreenMode: Boolean;

    { Private declarations }
  public
    procedure RestoreDefaultMode;
    { Public declarations }
  end;

var
  Main: TMain;
  Pn: 1..4 = 1;
  Str1: TStringStream;
  for_doors: Integer;
  cl: string[1];

implementation

uses Unit1;

{$R *.DFM}


procedure TMain.BitBtn1Click(Sender: TObject);
begin
  Load(OpenDialog1.FileName);
  Main.Visible := False;
  if N16.Checked then
    SetFullscreenMode;
  Form1.Show;
end;

procedure TMain.N5Click(Sender: TObject);
begin
  N5.Checked := True;
end;

procedure TMain.N6Click(Sender: TObject);
begin
  N6.Checked := True;
  N5.Checked := False;
  MousePlayer := 1;
end;

procedure TMain.N3Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMain.N8Click(Sender: TObject);
begin
  MousePlayer := 2;
end;

procedure TMain.N15Click(Sender: TObject);
begin
  OpenDialog1.Filter := 'TnT levels|*.TnT|All files|*.*';
  if OpenDialog1.Execute then
    Load(OpenDialog1.FileName);
end;

procedure TMain.Load(const levelName: string);
var
  levelFile: TextFile;
  row, col: Integer;
  randomVariant: Integer;
  lineBuffer: string;
  sourceLevelName: string;

  procedure ApplyRandomSandTile;
  begin
    randomVariant := Random(5);
    case randomVariant of
      0, 1:
        Matrix[col, row].tip := '[';
      2, 3:
        Matrix[col, row].tip := 'p';
      4:
        Matrix[col, row].tip := ']';
    end;
    Matrix[col, row].zizn := pesok_zizn;
  end;

  procedure ApplyRandomRockTile;
  begin
    randomVariant := Random(5);
    case randomVariant of
      0, 1:
        Matrix[col, row].tip := 's';
      2, 3:
        Matrix[col, row].tip := 'q';
      4:
        Matrix[col, row].tip := 'e';
    end;
    Matrix[col, row].zizn := skala_zizn;
  end;

begin
  sourceLevelName := levelName;
  if sourceLevelName = '' then
    sourceLevelName := 'Default.TnT';

  Randomize;
  AssignFile(levelFile, sourceLevelName);
  Reset(levelFile);

  for row := 0 to LengthY do
  begin
    ReadLn(levelFile, lineBuffer);
    for col := 0 to LengthX do
    begin
      Matrix[col, row].tip := lineBuffer[col + 1];
      case lineBuffer[col + 1] of
        'p':
          ApplyRandomSandTile;
        's':
          ApplyRandomRockTile;
        'k':
          Matrix[col, row].zizn := kirpich_zizn;
        'l':
          Matrix[col, row].zizn := kley_zizn;
        '0'..'9':
          begin
            for_doors := for_doors + 1;
            doors[lineBuffer[col + 1]].x[for_doors] := col;
            doors[lineBuffer[col + 1]].y[for_doors] := row;
          end;
      end;
    end;
  end;

  CloseFile(levelFile);
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  {if not SetPriorityClass(GetCurrentProcess,REALTIME_PRIORITY_CLASS) then
     ShowMessage('Error setting priority class.');
  if not SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_HIGHEST) then
     ShowMessage('Error setting theard priority class.');}
  Fone.Picture.LoadFromFile('Images\fone.jpg');
end;

function TMain.SetFullscreenMode: Boolean;
var
  DeviceMode: TDevMode;
begin
  with DeviceMode do
  begin
    dmSize := SizeOf(DeviceMode);
    dmBitsPerPel := 16;
    dmPelsWidth := 640;
    dmPelsHeight := 480;
    dmFields := DM_BITSPERPEL or DM_PELSWIDTH or DM_PELSHEIGHT;

    Result := False;
    if ChangeDisplaySettings(DeviceMode, CDS_TEST or CDS_FULLSCREEN) <> DISP_CHANGE_SUCCESSFUL then
      Exit;

    Result := ChangeDisplaySettings(DeviceMode, CDS_FULLSCREEN) = DISP_CHANGE_SUCCESSFUL;
  end;
end;

procedure TMain.RestoreDefaultMode;
var
  DefaultMode: TDevMode;
begin
  ChangeDisplaySettings(DefaultMode, CDS_FULLSCREEN);
end;

procedure TMain.N16Click(Sender: TObject);
begin
  N16.Checked := not N16.Checked;
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Main.RestoreDefaultMode;
end;

end.
