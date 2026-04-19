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
    procedure Load(name:string);
    procedure FormCreate(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function SetFullscreenMode:Boolean;

    { Private declarations }
  public
  procedure RestoreDefaultMode;
    { Public declarations }
  end;

var
  Main: TMain;
  Pn:1..4=1;
  Str1:TStringStream;
  for_doors:integer;
  cl:string[1];

implementation

uses Unit1;

{$R *.DFM}


procedure TMain.BitBtn1Click(Sender: TObject);
begin
load(opendialog1.FileName);
Main.Visible:=false;
if n16.Checked then SetFullscreenMode;
form1.show;
end;

procedure TMain.N5Click(Sender: TObject);
begin
N5.Checked:=true;

end;

procedure TMain.N6Click(Sender: TObject);
begin
n6.Checked:=true;
n5.Checked:=false;
MousePlayer:=1;
end;

procedure TMain.N3Click(Sender: TObject);
begin
Application.terminate;
end;

procedure TMain.N8Click(Sender: TObject);
begin
MousePlayer:=2;
end;

procedure TMain.N15Click(Sender: TObject);
begin
openDialog1.Filter:='TnT levels|*.TnT|All files|*.*';
if opendialog1.Execute then Load(opendialog1.FileName);

end;
//----------
procedure TMain.Load(name:string);
var level:Textfile;
    a,b,pesk:integer;
    bufer:string;

begin
//for_doors:=-1;
if name='' then name:='Default.TnT';
randomize;
assignFile(level,Name);
reset(level);
for a:=0 to LengthY do
    begin
      readln(level,bufer);
      for b:=0 to LengthX do
        begin

        matrix[b,a].tip:=bufer[b+1];
        case bufer[b+1] of
          'p':begin
              pesk:=random(5);
              case pesk of
                0,1:matrix[b,a].tip:='[';
                2,3:matrix[b,a].tip:='p';
                4,5:matrix[b,a].tip:=']';
              end;
              matrix[b,a].zizn:=pesok_zizn;
              end;
          's':begin
              pesk:=random(5);
              case pesk of
                0,1:matrix[b,a].tip:='s';
                2,3:matrix[b,a].tip:='q';
                4,5:matrix[b,a].tip:='e';
              end;
              matrix[b,a].zizn:=skala_zizn;
              end;
          'k':matrix[b,a].zizn:=kirpich_zizn;
          'l':begin;
              matrix[b,a].zizn:=kley_zizn;

              end;
          '0'..'9':begin;
                         for_doors:=for_doors+1;
                         doors[bufer[b+1]].x[for_doors]:=b;
                         doors[bufer[b+1]].y[for_doors]:=a;
                  end;
        end;
        end;
    end;

closefile(level);
end;//--------




procedure TMain.FormCreate(Sender: TObject);
begin
{if not SetPriorityClass(GetCurrentProcess,REALTIME_PRIORITY_CLASS) then
   ShowMessage('Error setting priority class.');
if not SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_HIGHEST) then
   ShowMessage('Error setting theard priority class.');}
Fone.Picture.LoadFromFile('Images\fone.jpg');
end;

function TMain.SetFullscreenMode:Boolean;
var DeviceMode : TDevMode;
begin
with DeviceMode do begin
dmSize:=SizeOf(DeviceMode);
dmBitsPerPel:=16;
dmPelsWidth:=640;
dmPelsHeight:=480;
dmFields:=DM_BITSPERPEL or DM_PELSWIDTH or DM_PELSHEIGHT;
result:=False;
if ChangeDisplaySettings(DeviceMode,CDS_TEST or CDS_FULLSCREEN) <> DISP_CHANGE_SUCCESSFUL
then Exit;
Result:=ChangeDisplaySettings(DeviceMode,CDS_FULLSCREEN) = DISP_CHANGE_SUCCESSFUL;
end;end;
procedure TMain.RestoreDefaultMode;
var T : TDevMode;// absolute 0;
begin ChangeDisplaySettings(T,CDS_FULLSCREEN);
end;


procedure TMain.N16Click(Sender: TObject);
begin
n16.Checked:=not(n16.Checked);
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
main.RestoreDefaultMode;
end;

end.
