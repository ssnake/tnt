unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, StdCtrls,mmSystem;
                            {^^^^^^^}
type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Image1: TImage;
    Pb1: TImage;
    Pb3: TImage;
    Pb4: TImage;
    Pb2: TImage;

    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure frame1(var NumFr:Smallint;var fr:integer;fr_sp:integer);
    procedure Rebuild(x1,y1:word);
    procedure See(var res:boolean;x1,y1:integer);
    procedure Dril(zader:shortint);
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pesok_check(var result:boolean;x,y:integer);
    procedure bomb_explore;
    procedure ReDraw(x1,y1:integer);
    procedure Explr(x1,y1:integer;kind:string;frm:shortint);
    procedure Bomb_check(x1,y1:integer;bomb_exp:integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NetKey(key:char);
    procedure Zriv(a:integer);
    procedure Move_Bombs(kind:string;a:shortint);
    procedure mine_exp(x1,y1:integer);
    procedure zalivka(x,y,num:integer;kind:char);
  private

    { Private declarations }
  public
    { Public declarations }
  end;
const MouseSpeed=15;
//      step=2;    //шаг передвижения героев
     // fr_sp=4;   //интервал между смены кадров героя
                 //всего кадров 4
      tb=3; //время смены кадров у бомбы
      ver_zrv=100;//вероятност зрыва бомбы
      smb_exp=149;
      b_exp=200;
      lengthY=44;//64x45 стандарт MB
      lengthX=63;
      kirpich_zizn=450;
      pesok_zizn=100;
      skala_zizn=300;
      kley_zizn=2*kirpich_zizn;
      exp_smbomb:array[0..2,0..2]of char=('010',
                                          '111',
                                          '010');

      exp_bomb:array[0..4,0..4]of char=('00100',
                                        '01110',
                                        '11111',
                                        '01110',
                                        '00100');

       exp_din:array[0..6,0..6]of char=('0011100',
                                        '0111110',
                                        '1111111',
                                        '1111111',
                                        '1111111',
                                        '0111110',
                                        '0011100');




type  frame=array[0..3] of TBitmap;
//      Tbombs=(smbomb);


var
  Form1: TForm1;
  Time:cardinal;
  NumberOfPlayers:2..4=3;
  NumberPlayer:1..4=1;
  TypeGame:(Normal,Net)=normal;
  NETGame:record
          NetPlayer:array[1..4] of record
                                   IP:string;
                                   Name:string;
                                   number:1..4;//?????????
                                   end;
          server:boolean;
          end;
  MousePlayer:integer;
  BufX,BufY:integer;         //переменные для мыши
  Way,way_for_stop:array[1..4] of char;   //направление объекта
  frm,dril_frm:array[1..4] of Smallint;
  Weapons:array[1..4,1..21] of record
                               kol:0..100;
                               kind:string;
                               end;

  DeadMans:array[1..4] of record  //герои 0
                          zizn:integer;
                          ver_zrv:0..100;
                          fr:integer;   //номер кадра
                          dril:integer;//мощность дрели
                          left,right,up,down:frame; //Картинки для играков
                          ld,rd,ud,dd:array[0..1] of TBitmap;
                          end;
  doors:array['0'..'9']of record
                       x,y:array[0..100] of Shortint;
                       end;
// типы квадратика
  MGrd,beton,kirpich,hkirpich,mkirpich,weapon,pesok,pesok2,pesok3,skala,skala2,skala3,hskala,mskala,krov,dveri,vikl1,vikl2,mine,block,kley:Tbitmap;
  dit_sm_1,dit_sm_2,dit_sm_3,dit_lg_1,dit_lg_2,dit_lg_3:TBitmap; //дитонаторы
// конец
  x,y,step:array[1..4]of real;//integer;  //координаты каждого героя
  Up,Down,lft,Right,Stoy,fire,detonate,select:array[1..4] of word; //клавиши героев
  NumberBomb,NumberOfBombs:integer; //текущая бомба,кол. бомб
  Numweapons:array[1..4]of integer;
  smbomb_,bomb_,dinamit_:frame;
  lazer_:array[0..1] of Tbitmap;
  explore:array[0..2] of TBitmap;
  bombTime:integer;

  bombs:array of record
                      time:-2..500000;
                      owner:1..4;
                      TimeToDie:boolean;
                      kind:string[20];
                      x,y:integer;
                      end;
  lazer:array[1..4]of record
                      bx,by:shortint;
                      lw:char;
                      step:smallint;
                      end;


  Matrix:array[0-7..lengthX+7,0-2..lengthY+2]of record
    {    ^^^^ - уровень}                    tip:char;
                                            zizn:Smallint;
                                            end;
implementation

uses Unit3;

{$R *.DFM}


procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);

begin

if bufX-X>=MouseSpeed then
   begin;
   way[MousePlayer]:='l';
   bufx:=x;
   end;
if abs(X-BufX)>=MouseSpeed then
   begin;
   way[MousePlayer]:='r';
   bufx:=x;
   end;

if bufY-Y>=MouseSpeed then
   begin;
   way[MousePlayer]:='u';
   bufy:=y;
   end;
if abs(Y-bufY)>=MouseSpeed then
   begin;
   way[MousePlayer]:='d';
   bufy:=y;
   end;


bufx:=x;
bufy:=y;

end;

procedure TForm1.FormCreate(Sender: TObject);
var a,b:word;
begin
{if not SetPriorityClass(GetCurrentProcess,REALTIME_PRIORITY_CLASS) then
   ShowMessage('Error setting priority class.');
if not SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_TIME_CRITICAL) then
   ShowMessage('Error setting theard priority class.');
   }
//SetFullscreenMode;

//-------------------------------------
//игрок 1
step[1]:=1.8;

weapons[1,1].kol:=10;
weapons[1,1].kind:='smbomb';
weapons[1,2].kol:=10;
weapons[1,2].kind:='bomb';
weapons[1,3].kol:=10;
weapons[1,3].kind:='dinamite';
weapons[1,4].kol:=99;
weapons[1,4].kind:='laz';
weapons[1,5].kol:=10;
weapons[1,5].kind:='det_sm';
weapons[1,6].kol:=99;
weapons[1,6].kind:='det_lg';
weapons[1,7].kol:=99;
weapons[1,7].kind:='test';


numWeapons[1]:=7;
Deadmans[1].dril:=100;
Deadmans[1].zizn:=300;
Deadmans[1].ver_zrv:=90;

Deadmans[1].left[0]:=TBitmap.Create;
Deadmans[1].left[0].LoadFromFile('Images\Heroes\player 1 l 1.bmp');
Deadmans[1].left[1]:=TBitmap.Create;
Deadmans[1].left[1].LoadFromFile('Images\Heroes\player 1 l 2.bmp');
Deadmans[1].left[2]:=TBitmap.Create;
Deadmans[1].left[2].LoadFromFile('Images\Heroes\player 1 l 3.bmp');
Deadmans[1].left[3]:=TBitmap.Create;
Deadmans[1].left[3].LoadFromFile('Images\Heroes\player 1 l 4.bmp');

Deadmans[1].right[0]:=TBitmap.Create;
Deadmans[1].right[0].LoadFromFile('Images\Heroes\player 1 p 1.bmp');
Deadmans[1].right[1]:=TBitmap.Create;
Deadmans[1].right[1].LoadFromFile('Images\Heroes\player 1 p 2.bmp');
Deadmans[1].right[2]:=TBitmap.Create;
Deadmans[1].right[2].LoadFromFile('Images\Heroes\player 1 p 3.bmp');
Deadmans[1].right[3]:=TBitmap.Create;
Deadmans[1].right[3].LoadFromFile('Images\Heroes\player 1 p 4.bmp');

Deadmans[1].up[0]:=TBitmap.Create;
Deadmans[1].up[0].LoadFromFile('Images\Heroes\player 1 v 1.bmp');
Deadmans[1].up[1]:=TBitmap.Create;
Deadmans[1].up[1].LoadFromFile('Images\Heroes\player 1 v 2.bmp');
Deadmans[1].up[2]:=TBitmap.Create;
Deadmans[1].up[2].LoadFromFile('Images\Heroes\player 1 v 3.bmp');
Deadmans[1].up[3]:=TBitmap.Create;
Deadmans[1].up[3].LoadFromFile('Images\Heroes\player 1 v 4.bmp');

Deadmans[1].down[0]:=TBitmap.Create;
Deadmans[1].down[0].LoadFromFile('Images\Heroes\player 1 n 1.bmp');
Deadmans[1].down[1]:=TBitmap.Create;
Deadmans[1].down[1].LoadFromFile('Images\Heroes\player 1 n 2.bmp');
Deadmans[1].down[2]:=TBitmap.Create;
Deadmans[1].down[2].LoadFromFile('Images\Heroes\player 1 n 3.bmp');
Deadmans[1].down[3]:=TBitmap.Create;
Deadmans[1].down[3].LoadFromFile('Images\Heroes\player 1 n 4.bmp');

Deadmans[1].ld[0]:=TBitmap.Create;
Deadmans[1].ld[0].LoadFromFile('Images\Heroes\player 1 l dr 1.bmp');
Deadmans[1].ld[1]:=TBitmap.Create;
Deadmans[1].ld[1].LoadFromFile('Images\Heroes\player 1 l dr 2.bmp');

Deadmans[1].rd[0]:=TBitmap.Create;
Deadmans[1].rd[0].LoadFromFile('Images\Heroes\player 1 p dr 1.bmp');
Deadmans[1].rd[1]:=TBitmap.Create;
Deadmans[1].rd[1].LoadFromFile('Images\Heroes\player 1 p dr 2.bmp');

Deadmans[1].ud[0]:=TBitmap.Create;
Deadmans[1].ud[0].LoadFromFile('Images\Heroes\player 1 v dr 1.bmp');
Deadmans[1].ud[1]:=TBitmap.Create;
Deadmans[1].ud[1].LoadFromFile('Images\Heroes\player 1 v dr 2.bmp');

Deadmans[1].dd[0]:=TBitmap.Create;
Deadmans[1].dd[0].LoadFromFile('Images\Heroes\player 1 n dr 1.bmp');
Deadmans[1].dd[1]:=TBitmap.Create;
Deadmans[1].dd[1].LoadFromFile('Images\Heroes\player 1 n dr 2.bmp');


//игрок 2
step[2]:=2.1;
Deadmans[2].dril:=10;
Deadmans[2].zizn:=150;
Deadmans[2].ver_zrv:=90;

weapons[2,3].kol:=10;
weapons[2,3].kind:='smbomb';
weapons[2,2].kol:=10;
weapons[2,2].kind:='bomb';
weapons[2,4].kol:=10;
weapons[2,4].kind:='dinamite';
weapons[2,1].kol:=10;
weapons[2,1].kind:='laz';
weapons[2,5].kol:=10;
weapons[2,5].kind:='det_sm';
weapons[2,6].kol:=10;
weapons[2,6].kind:='det_lg';
numWeapons[2]:=6;


Deadmans[2].left[0]:=TBitmap.Create;
Deadmans[2].left[0].LoadFromFile('Images\Heroes\player 2 l 1.bmp');
Deadmans[2].left[1]:=TBitmap.Create;
Deadmans[2].left[1].LoadFromFile('Images\Heroes\player 2 l 2.bmp');
Deadmans[2].left[2]:=TBitmap.Create;
Deadmans[2].left[2].LoadFromFile('Images\Heroes\player 2 l 3.bmp');
Deadmans[2].left[3]:=TBitmap.Create;
Deadmans[2].left[3].LoadFromFile('Images\Heroes\player 2 l 4.bmp');

Deadmans[2].right[0]:=TBitmap.Create;
Deadmans[2].right[0].LoadFromFile('Images\Heroes\player 2 p 1.bmp');
Deadmans[2].right[1]:=TBitmap.Create;
Deadmans[2].right[1].LoadFromFile('Images\Heroes\player 2 p 2.bmp');
Deadmans[2].right[2]:=TBitmap.Create;
Deadmans[2].right[2].LoadFromFile('Images\Heroes\player 2 p 3.bmp');
Deadmans[2].right[3]:=TBitmap.Create;
Deadmans[2].right[3].LoadFromFile('Images\Heroes\player 2 p 4.bmp');

Deadmans[2].up[0]:=TBitmap.Create;
Deadmans[2].up[0].LoadFromFile('Images\Heroes\player 2 v 1.bmp');
Deadmans[2].up[1]:=TBitmap.Create;
Deadmans[2].up[1].LoadFromFile('Images\Heroes\player 2 v 2.bmp');
Deadmans[2].up[2]:=TBitmap.Create;
Deadmans[2].up[2].LoadFromFile('Images\Heroes\player 2 v 3.bmp');
Deadmans[2].up[3]:=TBitmap.Create;
Deadmans[2].up[3].LoadFromFile('Images\Heroes\player 2 v 4.bmp');

Deadmans[2].down[0]:=TBitmap.Create;
Deadmans[2].down[0].LoadFromFile('Images\Heroes\player 2 n 1.bmp');
Deadmans[2].down[1]:=TBitmap.Create;
Deadmans[2].down[1].LoadFromFile('Images\Heroes\player 2 n 2.bmp');
Deadmans[2].down[2]:=TBitmap.Create;
Deadmans[2].down[2].LoadFromFile('Images\Heroes\player 2 n 3.bmp');
Deadmans[2].down[3]:=TBitmap.Create;
Deadmans[2].down[3].LoadFromFile('Images\Heroes\player 2 n 4.bmp');


Deadmans[2].ld[0]:=TBitmap.Create;
Deadmans[2].ld[0].LoadFromFile('Images\Heroes\PLAYER 2 L dr 1.bmp');
Deadmans[2].ld[1]:=TBitmap.Create;
Deadmans[2].ld[1].LoadFromFile('Images\Heroes\PLAYER 2 L dr 2.bmp');

Deadmans[2].rd[0]:=TBitmap.Create;
Deadmans[2].rd[0].LoadFromFile('Images\Heroes\PLAYER 2 p dr 1.bmp');
Deadmans[2].rd[1]:=TBitmap.Create;
Deadmans[2].rd[1].LoadFromFile('Images\Heroes\PLAYER 2 p dr 2.bmp');

Deadmans[2].ud[0]:=TBitmap.Create;
Deadmans[2].ud[0].LoadFromFile('Images\Heroes\player 2 v dr 1.bmp');
Deadmans[2].ud[1]:=TBitmap.Create;
Deadmans[2].ud[1].LoadFromFile('Images\Heroes\player 2 v dr 2.bmp');

Deadmans[2].dd[0]:=TBitmap.Create;
Deadmans[2].dd[0].LoadFromFile('Images\Heroes\player 2 n dr 1.bmp');
Deadmans[2].dd[1]:=TBitmap.Create;
Deadmans[2].dd[1].LoadFromFile('Images\Heroes\player 2 n dr 2.bmp');


//игрок 3
step[3]:=2;
Deadmans[3].dril:=10;
Deadmans[3].zizn:=150;

weapons[3,1].kol:=10;
weapons[3,1].kind:='smbomb';
weapons[3,2].kol:=10;
weapons[3,2].kind:='bomb';
weapons[3,3].kol:=10;
weapons[3,3].kind:='dinamite';
weapons[3,4].kol:=10;
weapons[3,4].kind:='laz';
weapons[3,5].kol:=10;
weapons[3,5].kind:='det_sm';
weapons[3,6].kol:=10;
weapons[3,6].kind:='det_lg';
numWeapons[3]:=6;


Deadmans[3].left[0]:=TBitmap.Create;
Deadmans[3].left[0].LoadFromFile('Images\Heroes\player 3 l 1.bmp');
Deadmans[3].left[1]:=TBitmap.Create;
Deadmans[3].left[1].LoadFromFile('Images\Heroes\player 3 l 2.bmp');
Deadmans[3].left[2]:=TBitmap.Create;
Deadmans[3].left[2].LoadFromFile('Images\Heroes\player 3 l 3.bmp');
Deadmans[3].left[3]:=TBitmap.Create;
Deadmans[3].left[3].LoadFromFile('Images\Heroes\player 3 l 4.bmp');

Deadmans[3].right[0]:=TBitmap.Create;
Deadmans[3].right[0].LoadFromFile('Images\Heroes\player 3 p 1.bmp');
Deadmans[3].right[1]:=TBitmap.Create;
Deadmans[3].right[1].LoadFromFile('Images\Heroes\player 3 p 2.bmp');
Deadmans[3].right[2]:=TBitmap.Create;
Deadmans[3].right[2].LoadFromFile('Images\Heroes\player 3 p 3.bmp');
Deadmans[3].right[3]:=TBitmap.Create;
Deadmans[3].right[3].LoadFromFile('Images\Heroes\player 3 p 4.bmp');

Deadmans[3].up[0]:=TBitmap.Create;
Deadmans[3].up[0].LoadFromFile('Images\Heroes\player 3 v 1.bmp');
Deadmans[3].up[1]:=TBitmap.Create;
Deadmans[3].up[1].LoadFromFile('Images\Heroes\player 3 v 2.bmp');
Deadmans[3].up[2]:=TBitmap.Create;
Deadmans[3].up[2].LoadFromFile('Images\Heroes\player 3 v 3.bmp');
Deadmans[3].up[3]:=TBitmap.Create;
Deadmans[3].up[3].LoadFromFile('Images\Heroes\player 3 v 4.bmp');

Deadmans[3].down[0]:=TBitmap.Create;
Deadmans[3].down[0].LoadFromFile('Images\Heroes\player 3 n 1.bmp');
Deadmans[3].down[1]:=TBitmap.Create;
Deadmans[3].down[1].LoadFromFile('Images\Heroes\player 3 n 2.bmp');
Deadmans[3].down[2]:=TBitmap.Create;
Deadmans[3].down[2].LoadFromFile('Images\Heroes\player 3 n 3.bmp');
Deadmans[3].down[3]:=TBitmap.Create;
Deadmans[3].down[3].LoadFromFile('Images\Heroes\player 3 n 4.bmp');

Deadmans[3].ld[0]:=TBitmap.Create;
Deadmans[3].ld[0].LoadFromFile('Images\Heroes\PLAYER 3 L dr 1.bmp');
Deadmans[3].ld[1]:=TBitmap.Create;
Deadmans[3].ld[1].LoadFromFile('Images\Heroes\PLAYER 3 L dr 2.bmp');

Deadmans[3].rd[0]:=TBitmap.Create;
Deadmans[3].rd[0].LoadFromFile('Images\Heroes\PLAYER 3 p dr 1.bmp');
Deadmans[3].rd[1]:=TBitmap.Create;
Deadmans[3].rd[1].LoadFromFile('Images\Heroes\PLAYER 3 p dr 2.bmp');

Deadmans[3].ud[0]:=TBitmap.Create;
Deadmans[3].ud[0].LoadFromFile('Images\Heroes\player 3 v dr 1.bmp');
Deadmans[3].ud[1]:=TBitmap.Create;
Deadmans[3].ud[1].LoadFromFile('Images\Heroes\player 3 v dr 2.bmp');

Deadmans[3].dd[0]:=TBitmap.Create;
Deadmans[3].dd[0].LoadFromFile('Images\Heroes\player 3 n dr 1.bmp');
Deadmans[3].dd[1]:=TBitmap.Create;
Deadmans[3].dd[1].LoadFromFile('Images\Heroes\player 3 n dr 2.bmp');



//бомбы
NumberOfBombs:=0;
SetLength(bombs,NumberOfBombs+1);
smbomb_[0]:=TBitmap.Create;
smbomb_[0].LoadFromFile('Images\Bombs\sm bomb 1.BMP');
smbomb_[1]:=TBitmap.Create;
smbomb_[1].LoadFromFile('Images\Bombs\sm bomb 2.BMP');
smbomb_[2]:=TBitmap.Create;
smbomb_[2].LoadFromFile('Images\Bombs\sm bomb 3.BMP');
smbomb_[3]:=TBitmap.Create;
smbomb_[3].LoadFromFile('Images\Bombs\sm bomb 4.BMP');

bomb_[0]:=TBitmap.Create;
bomb_[0].LoadFromFile('Images\Bombs\bomb 1.BMP');
bomb_[1]:=TBitmap.Create;
bomb_[1].LoadFromFile('Images\Bombs\bomb 2.BMP');
bomb_[2]:=TBitmap.Create;
bomb_[2].LoadFromFile('Images\Bombs\bomb 3.BMP');
bomb_[3]:=TBitmap.Create;
bomb_[3].LoadFromFile('Images\Bombs\bomb 4.BMP');

dinamit_[0]:=TBitmap.Create;
dinamit_[0].LoadFromFile('Images\Bombs\dinamit 1.BMP');
dinamit_[1]:=TBitmap.Create;
dinamit_[1].LoadFromFile('Images\Bombs\dinamit 2.BMP');
dinamit_[2]:=TBitmap.Create;
dinamit_[2].LoadFromFile('Images\Bombs\dinamit 3.BMP');
dinamit_[3]:=TBitmap.Create;
dinamit_[3].LoadFromFile('Images\Bombs\dinamit 4.BMP');

dit_sm_1:=TBitmap.Create;
dit_sm_1.LoadFromFile('Images\Bombs\ditnt sm 1.BMP');

dit_sm_2:=TBitmap.Create;
dit_sm_2.LoadFromFile('Images\Bombs\ditnt sm 2.BMP');

dit_sm_3:=TBitmap.Create;
dit_sm_3.LoadFromFile('Images\Bombs\ditnt sm 3.BMP');

dit_lg_1:=TBitmap.Create;
dit_lg_1.LoadFromFile('Images\Bombs\ditnt lg 1.BMP');

dit_lg_2:=TBitmap.Create;
dit_lg_2.LoadFromFile('Images\Bombs\ditnt lg 2.BMP');

dit_lg_3:=TBitmap.Create;
dit_lg_3.LoadFromFile('Images\Bombs\ditnt lg 3.BMP');

lazer_[0]:=TBitmap.Create;
lazer_[0].LoadFromFile('Images\Bombs\lazer2.BMP');

lazer_[1]:=TBitmap.Create;
lazer_[1].LoadFromFile('Images\Bombs\lazer1.BMP');

//взрывчики

explore[0]:=TBitmap.Create;
explore[0].LoadFromFile('Images\Bombs\expl1.BMP');
explore[1]:=TBitmap.Create;
explore[1].LoadFromFile('Images\Bombs\expl2.BMP');
explore[2]:=TBitmap.Create;
explore[2].LoadFromFile('Images\Bombs\expl3.BMP');



// квадратики
MGrd:=TBitmap.Create;
MGrd.LoadFromFile('Images\terrain\mgrd.bmp');
Beton:=TBitmap.Create;
Beton.LoadFromFile('Images\terrain\beton.bmp');
kirpich:=TBitmap.Create;
kirpich.LoadFromFile('Images\terrain\kirpich.bmp');

hkirpich:=TBitmap.Create;
hkirpich.LoadFromFile('Images\terrain\hard kirpich.bmp');
mkirpich:=TBitmap.Create;
mkirpich.LoadFromFile('Images\terrain\medium kirpich.bmp');

pesok:=TBitmap.Create;
pesok.LoadFromFile('Images\terrain\pesok.bmp');
pesok2:=TBitmap.Create;
pesok2.LoadFromFile('Images\terrain\pesok2.bmp');
pesok3:=TBitmap.Create;
pesok3.LoadFromFile('Images\terrain\pesok3.bmp');

skala:=TBitmap.Create;
skala.LoadFromFile('Images\terrain\skala.bmp');
skala2:=TBitmap.Create;
skala2.LoadFromFile('Images\terrain\skala2.bmp');
skala3:=TBitmap.Create;
skala3.LoadFromFile('Images\terrain\skala3.bmp');
hskala:=TBitmap.Create;
hskala.LoadFromFile('Images\terrain\hskala.bmp');
mskala:=TBitmap.Create;
mskala.LoadFromFile('Images\terrain\mskala.bmp');
Dveri:=TBitmap.Create;
Dveri.LoadFromFile('Images\terrain\dveri.bmp');
vikl1:=TBitmap.Create;
vikl1.LoadFromFile('Images\terrain\vikluchatel 1.bmp');
vikl2:=TBitmap.Create;
vikl2.LoadFromFile('Images\terrain\vikluchatel 2.bmp');
mine:=TBitmap.Create;
mine.LoadFromFile('Images\terrain\mine.bmp');

block:=TBitmap.Create;
block.LoadFromFile('Images\terrain\stone.bmp');
kley:=TBitmap.Create;
kley.LoadFromFile('Images\terrain\kley.bmp');




krov:=TBitmap.Create;
krov.LoadFromFile('Images\terrain\krov.bmp');



weapon:=TBitmap.Create;
weapon.LoadFromFile('Images\terrain\weapon.bmp');

//---------------------------------

Up[1]:=38;
Down[1]:=40;
lft[1]:=37;
Right[1]:=39;
Stoy[1]:=14;
fire[1]:=13;
detonate[1]:=32;
select[1]:=17;

Up[2]:=69;
Down[2]:=68;
lft[2]:=83;
Right[2]:=70;
Stoy[2]:=49;
FIRE[2]:=81;
detonate[2]:=90;
select[2]:=65;

Up[3]:=104;
Down[3]:=101;
lft[3]:=100;
Right[3]:=102;
Stoy[3]:=96;
FIRE[3]:=97;
detonate[3]:=98;
select[3]:=110;



x[1]:=200;y[1]:=320;
x[2]:=200;y[2]:=130;
x[3]:=210;y[3]:=140;

BufX:=mouse.CursorPos.x;
BufY:=mouse.CursorPos.Y;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var a:integer;
    rslt:boolean;


begin
if lazer[1].lw<>'0' then Move_bombs('laz',1);
for a:=1 to numberofplayers do Rebuild(round(X[a]) div 10,round(Y[a])div 10);
repeat;rslt:=true;
    case way[NumberPlayer] of
    'r':begin;{1}
    canvas.Draw(round(X[NumberPlayer]),round(y[NumberPlayer]),DeadMans[NumberPlayer].right[DeadMans[NumberPlayer].fr]);
    Y[NumberPlayer]:=round(Y[NumberPlayer]/10)*10;
    X[NumberPlayer]:=X[NumberPlayer]+step[NumberPlayer];

    see(rslt,round(X[NumberPlayer])div 10+1,round(y[NumberPlayer])div 10);
    if rslt=false then X[NumberPlayer]:=X[NumberPlayer]-step[NumberPlayer];

    frame1(frm[NumberPlayer],DeadMans[NumberPlayer].fr,2);
    pesok_check(rslt,round(x[NumberPlayer])div 10+1,round(y[NumberPlayer])div 10);
    end;{1}
    'l':begin;
    canvas.Draw(round(X[NumberPlayer]),round(y[NumberPlayer]),DeadMans[NumberPlayer].left[DeadMans[NumberPlayer].fr]);
    Y[NumberPlayer]:=round(Y[NumberPlayer]/10)*10;
    X[NumberPlayer]:=X[NumberPlayer]-step[NumberPlayer];
    see(rslt,round(X[NumberPlayer])div 10,round(y[NumberPlayer])div 10);
    if rslt=false then X[NumberPlayer]:=round(X[NumberPlayer]/10)*10;//X[NumberPlayer]+step[NumberPlayer];

    frame1(frm[NumberPlayer],DeadMans[NumberPlayer].fr,2);
    pesok_check(rslt,round(x[NumberPlayer])div 10-1,round(y[NumberPlayer])div 10);
    end;

    'u':begin;

    canvas.Draw(round(X[NumberPlayer]),round(y[NumberPlayer]),DeadMans[NumberPlayer].up[DeadMans[NumberPlayer].fr]);
    X[NumberPlayer]:=round(X[NumberPlayer]/10)*10;
    Y[NumberPlayer]:=Y[NumberPlayer]-step[NumberPlayer];

    see(rslt,round(X[NumberPlayer])div 10,round(y[NumberPlayer])div 10);
    if rslt=false then y[NumberPlayer]:=round(Y[NumberPlayer]/10)*10;//y[NumberPlayer]+step[NumberPlayer];

    frame1(frm[NumberPlayer],DeadMans[NumberPlayer].fr,2);
    pesok_check(rslt,round(x[NumberPlayer])div 10,round(y[NumberPlayer])div 10-1);
    end;

    'd':begin;

    canvas.Draw(round(X[NumberPlayer]),round(y[NumberPlayer]),DeadMans[NumberPlayer].down[DeadMans[NumberPlayer].fr]);
    X[NumberPlayer]:=round(X[NumberPlayer]/10)*10;
    Y[NumberPlayer]:=Y[NumberPlayer]+step[NumberPlayer];;

    see(rslt,round(X[NumberPlayer])div 10,round(y[NumberPlayer])div 10+1);
    if rslt=false then y[NumberPlayer]:=round(y[NumberPlayer]/10)*10;//y[NumberPlayer]-step[NumberPlayer];

    frame1(frm[NumberPlayer],DeadMans[NumberPlayer].fr,2);
    pesok_check(rslt,round(x[NumberPlayer])div 10,round(y[NumberPlayer])div 10+1);
    end;
    's':case way_for_stop[NumberPlayer] of
       'u':canvas.Draw(round(X[NumberPlayer]),round(y[NumberPlayer]),DeadMans[NumberPlayer].up[DeadMans[NumberPlayer].fr]);
       'd':canvas.Draw(round(X[NumberPlayer]),round(y[NumberPlayer]),DeadMans[NumberPlayer].down[DeadMans[NumberPlayer].fr]);
       'r':canvas.Draw(round(X[NumberPlayer]),round(y[NumberPlayer]),DeadMans[NumberPlayer].right[DeadMans[NumberPlayer].fr]);
       'l':canvas.Draw(round(X[NumberPlayer]),round(y[NumberPlayer]),DeadMans[NumberPlayer].left[DeadMans[NumberPlayer].fr]);
       end;
end;
//-----------------------------------------------------------------------------

if round(y[NumberPlayer]/10)<0 then begin;y[NumberPlayer]:=0;end;
if round(x[NumberPlayer]/10)<0 then begin;x[NumberPlayer]:=0;end;
if round(Y[NumberPlayer]/10)>=LengthY then begin;Y[NumberPlayer]:=(round(Y[NumberPlayer])div 10)*10;end;
if round(X[NumberPlayer]/10)>=LengthX then begin;X[NumberPlayer]:=(round(x[NumberPlayer])div 10)*10;end;


//оружие

bomb_explore;
//-----------------------------------------------------------------------------

//__________________________________
inc(NumberPlayer);
if NumberPlayer=numberofplayers+1 then NumberPlayer:=1;
//----------------------------------
until NumberPlayer=1;
end;

procedure Tform1.frame1(var NumFr:Smallint;var fr:integer;fr_sp:integer);

var a:real;
    b:integer;
begin

inc(Numfr);
if Numfr=fr_sp*3+1 then Numfr:=-(fr_sp*4-1);
    //---\\
    a:=int(Numfr/fr_sp);
    b:=abs(round(a));
    //---\\
    fr:=b;

end;



procedure Tform1.Rebuild(x1,y1:word);
var a,b:shortint;


begin
for a:=0 to 3 do for b:=0 to 3 do {begin;}
 if (a<>1)or(b<>1) then ReDraw(x1+a-1,y1+b-1);

end;



procedure TForm1.FormPaint(Sender: TObject);
var a,b:word;
begin
for a:=0 to lengthX do for b:=0 to lengthY do begin
reDraw(a,b);
end;

end;


procedure TForm1.See(var res:boolean;x1,y1:integer);
var  a,b,c:integer;
begin
case matrix[X1,Y1].tip of
  'k':begin{норм кирпич}
      res:=false;
      matrix[x1,y1].zizn:=matrix[x1,y1].zizn-DeadMans[NumberPlayer].dril;dril(2);
      if matrix[x1,y1].zizn<=0 then
      begin res:=true;matrix[x1,y1].tip:='g';end;
      end;
  'p','[',']':begin{песок}
      res:=false;
      matrix[x1,y1].zizn:=matrix[x1,y1].zizn-DeadMans[NumberPlayer].dril;
      if matrix[x1,y1].zizn<=0 then
      begin res:=true;matrix[x1,y1].tip:='g';end;
      end;
  'm':begin{мина}
      mine_exp(x1,y1);
      MessageBeep(0);
      res:=true;
      end;
  'l' :begin{клей}
      res:=false;
      matrix[x1,y1].zizn:=matrix[x1,y1].zizn-DeadMans[NumberPlayer].dril;//dril(2);
      if matrix[x1,y1].zizn<=0 then
      begin res:=true;matrix[x1,y1].tip:='g';end;
      end;

   'L':begin{блок}
      case way[NumberPlayer] of
       'u':if (matrix[x1,y1-1].tip='g')or(matrix[x1,y1-1].tip='K') then begin;matrix[x1,y1-1].tip:=matrix[X1,Y1].tip;matrix[x1,y1].tip:='g';redraw(x1,y1)end else begin;Way[NumberPlayer]:='s';res:=false;way_for_stop[NumberPlayer]:='u';end;
       'd':if (matrix[x1,y1+1].tip='g')or(matrix[x1,y1+1].tip='K') then begin;matrix[x1,y1+1].tip:=matrix[X1,Y1].tip;matrix[x1,y1].tip:='g';redraw(x1,y1)end else begin;Way[NumberPlayer]:='s';res:=false;way_for_stop[NumberPlayer]:='d';end;
       'l':if (matrix[x1-1,y1].tip='g')or(matrix[x1-1,y1].tip='K') then begin;matrix[x1-1,y1].tip:=matrix[X1,Y1].tip;matrix[x1,y1].tip:='g';redraw(x1,y1)end else begin;Way[NumberPlayer]:='s';res:=false;way_for_stop[NumberPlayer]:='l';end;
       'r':if (matrix[x1+1,y1].tip='g')or(matrix[x1+1,y1].tip='K') then begin;matrix[x1+1,y1].tip:=matrix[X1,Y1].tip;matrix[x1,y1].tip:='g';redraw(x1,y1)end else begin;Way[NumberPlayer]:='s';res:=false;way_for_stop[NumberPlayer]:='r';end;
       end;
      end;


  'b','0'..'9':begin;res:=false;way_for_stop[NumberPlayer]:=way[NumberPlayer];Way[NumberPlayer]:='s';end;
  '!'..'*':begin;res:=false;way_for_stop[NumberPlayer]:=way[NumberPlayer];Way[NumberPlayer]:='s';
            for b:=0 to for_doors do begin
            with matrix[doors[chr(ord(matrix[X1,Y1].tip)+15)].x[b],doors[chr(ord(matrix[X1,Y1].tip)+15)].y[b]] do
                begin
                if tip='g' then tip:=chr(ord(matrix[X1,Y1].tip)+15) else tip:='g';

                end;REdraw(doors[chr(ord(matrix[X1,Y1].tip)+15)].x[b],doors[chr(ord(matrix[X1,Y1].tip)+15)].y[b]);
            end;
           end;
  's','q','e':begin{скала}
      res:=false;
      matrix[x1,y1].zizn:=matrix[x1,y1].zizn-DeadMans[NumberPlayer].dril;dril(2);
      if matrix[x1,y1].zizn<=0 then
    begin matrix[x1,y1].tip:='g';end;
      end;
  '`','d','D','f','F','h','H':begin{smbomb}
      for a:=1 to NumberOfBombs do
      if (x1=bombs[a].x)and(y1=bombs[a].y) then
       case way[NumberPlayer] of
       'u':if (matrix[x1,y1-1].tip='g')or(matrix[x1,y1-1].tip='K') then begin;matrix[x1,y1-1].tip:=matrix[X1,Y1].tip;matrix[x1,y1].tip:='g';redraw(x1,y1);bombs[a].y:=bombs[a].y-1;end else begin;Way[NumberPlayer]:='s';res:=false;way_for_stop[NumberPlayer]:='u';end;
       'd':if (matrix[x1,y1+1].tip='g')or(matrix[x1,y1+1].tip='K') then begin;matrix[x1,y1+1].tip:=matrix[X1,Y1].tip;matrix[x1,y1].tip:='g';redraw(x1,y1);bombs[a].y:=bombs[a].y+1;end else begin;Way[NumberPlayer]:='s';res:=false;way_for_stop[NumberPlayer]:='d';end;
       'l':if (matrix[x1-1,y1].tip='g')or(matrix[x1-1,y1].tip='K') then begin;matrix[x1-1,y1].tip:=matrix[X1,Y1].tip;matrix[x1,y1].tip:='g';redraw(x1,y1);bombs[a].x:=bombs[a].x-1;end else begin;Way[NumberPlayer]:='s';res:=false;way_for_stop[NumberPlayer]:='l';end;
       'r':if (matrix[x1+1,y1].tip='g')or(matrix[x1+1,y1].tip='K') then begin;matrix[x1+1,y1].tip:=matrix[X1,Y1].tip;matrix[x1,y1].tip:='g';redraw(x1,y1);bombs[a].x:=bombs[a].x+1;end else begin;Way[NumberPlayer]:='s';res:=false;way_for_stop[NumberPlayer]:='r';end;
       end;
      end;

end;{case}
end;{procedure}

procedure TForm1.Dril(zader:shortint);
begin
MessageBeep(0);
inc(dril_frm[NumberPlayer]);if dril_frm[NumberPlayer]>=2*zader then dril_frm[NumberPlayer]:=0;
case way[NumberPlayer]of
  'l':canvas.Draw(round(X[NumberPlayer]+Step[NumberPlayer]),round(y[NumberPlayer]),Deadmans[NumberPlayer].ld[dril_frm[NumberPlayer] div zader]);
  'u':canvas.Draw(round(X[NumberPlayer]),round(y[NumberPlayer]+Step[NumberPlayer]),Deadmans[NumberPlayer].ud[dril_frm[NumberPlayer] div zader]);
  'd':canvas.Draw(round(X[NumberPlayer]),round(y[NumberPlayer]-step[NumberPlayer]),Deadmans[NumberPlayer].dd[dril_frm[NumberPlayer] div zader]);
  'r':canvas.Draw(round(X[NumberPlayer]-Step[NumberPlayer]),round(y[NumberPlayer]),Deadmans[NumberPlayer].rd[dril_frm[NumberPlayer] div zader]);
end;
end;
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
main.RestoreDefaultMode;
main.Close;
end;

procedure Tform1.pesok_check(var result:boolean;x,y:integer);
begin
case matrix[x,y].tip of
  '[',']','p':result:=true;
end;

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var a,b,c,wstp:integer;
begin
//if TypeGame=net then begin;NetKey(key);end;




for a:=1 to NumberOfPlayers do
begin
Inherited;
//--------------------------------------------
case way[a] of
'r','d':wstp:=0;
'u','l':wstp:=8;
end;
//-------------------------------------------

if key=27 then main.show;
if key=fire[a] then
begin
if ((matrix[round(x[a]+wstp)div 10,round(y[a]+wstp)div 10].tip='g')or(matrix[round(x[a]+wstp)div 10,round(y[a]+wstp)div 10].tip='K'))and(Weapons[a,1].kol>0) then begin
  NumberOfBombs:=NumberOfBombs+1;
  SetLength(bombs,NumberOfBombs+1);  //??????????
  if (Weapons[a,1].kind='smbomb')or(Weapons[a,1].kind='bomb')or(Weapons[a,1].kind='dinamite') then begin;
      bombs[numberOfbombs].kind:=Weapons[a,1].kind;
      bombs[numberOfbombs].x:=(round(x[a]+wstp)div 10);
      bombs[numberOfbombs].y:=(round(y[a]+wstp)div 10);
      matrix[round(x[a]+wstp)div 10,round(y[a]+wstp)div 10].tip:='`';
      bombs[numberOfbombs].time:=0;
      bombs[numberOfbombs].owner:=a;

      weapons[a,1].kol:=weapons[a,1].kol-1;
      if weapons[a,1].kol<=0 then begin;messageBeep(0);weapons[a,1].kol:=0;end;

      end;
  if Weapons[a,1].kind='det_sm' then begin;
      bombs[numberOfbombs].kind:=Weapons[a,1].kind;
      bombs[numberOfbombs].x:=(round(x[a]+wstp)div 10);
      bombs[numberOfbombs].y:=(round(y[a]+wstp)div 10);
      bombs[numberOfbombs].time:=a;
       case a of
       1:matrix[bombs[numberOfbombs].x,bombs[numberOfbombs].y].tip:='d';
       2:matrix[bombs[numberOfbombs].x,bombs[numberOfbombs].y].tip:='f';
       3:matrix[bombs[numberOfbombs].x,bombs[numberOfbombs].y].tip:='h';
       end;

      weapons[a,1].kol:=weapons[a,1].kol-1;
      if weapons[a,1].kol<=0 then begin;messageBeep(0);weapons[a,1].kol:=0;end;

      end;
  if Weapons[a,1].kind='det_lg' then begin;
      bombs[numberOfbombs].kind:=Weapons[a,1].kind;
      bombs[numberOfbombs].x:=(round(x[a]+wstp)div 10);
      bombs[numberOfbombs].y:=(round(y[a]+wstp)div 10);
      bombs[numberOfbombs].time:=a;
      case a of
       1:matrix[bombs[numberOfbombs].x,bombs[numberOfbombs].y].tip:='D';
       2:matrix[bombs[numberOfbombs].x,bombs[numberOfbombs].y].tip:='F';
       3:matrix[bombs[numberOfbombs].x,bombs[numberOfbombs].y].tip:='H';
       end;

      weapons[a,1].kol:=weapons[a,1].kol-1;
      if weapons[a,1].kol<=0 then begin;messageBeep(0);weapons[a,1].kol:=0;end;

      end;
   if Weapons[a,1].kind='laz' then begin
         playsound('c:\CLOSETXT.WAV',0,snd_fileName or snd_application and snd_memory or snd_async);
         lazer[1].bx:=round(x[a])div 10;lazer[1].by:=round(y[a])div 10;
         lazer[1].step:=0;
         if way[a]<>'s' then lazer[1].lw:=way[a] else lazer[1].lw:=way_for_stop[a];

         weapons[a,1].kol:=weapons[a,1].kol-1;
         if weapons[a,1].kol<=0 then begin;messageBeep(0);weapons[a,1].kol:=0;end;
         end;{lazer}
   if Weapons[a,1].kind='test' then begin
         zalivka((round(x[a]+wstp)div 10),(round(y[a]+wstp)div 10),40,'l');
         weapons[a,1].kol:=weapons[a,1].kol-1;
         if weapons[a,1].kol<=0 then begin;messageBeep(0);weapons[a,1].kol:=0;end;
         end;{lazer}
  end;
end; {if}
canvas.TextOut(3+160*(a-1),451,inttostr(weapons[a,1].kol));
canvas.Font.color:=clwhite;
Canvas.Brush.Color :=8388736;//10485760;
//      backgroun
if key=detonate[a] then for b:=1 to NumberOfBombs do
      if ((bombs[b].kind='det_sm')or(bombs[b].kind='det_lg'))and(bombs[b].time=a) then begin;matrix[bombs[b].x,bombs[b].y].tip:='g';bombs[b].time:=0;bombs[b].TimeToDie:=true;end;//Explr(bombs[b].x,bombs[b].y,bomb,-1);
if key=select[a] then begin;weapons[a,21]:=weapons[a,1];for c:=1 to numweapons[a]-1 do begin;if weapons[a,c+1].kol>0 then weapons[a,c]:=weapons[a,c+1];end;{for}if weapons[a,21].kol>0 then weapons[a,numweapons[a]]:=weapons[a,21] else numweapons[a]:=numweapons[a]-1;
                       case a of
                       1:begin;pb1.Picture.LoadFromFile('Images\Menu\'+weapons[a,1].kind+'.bmp');pb1.Refresh;end;
                       2:begin;pb2.Picture.LoadFromFile('Images\Menu\'+weapons[a,1].kind+'.bmp');pb2.Refresh;end;
                       3:begin;pb3.Picture.LoadFromFile('Images\Menu\'+weapons[a,1].kind+'.bmp');pb3.Refresh;end;
                       end;
                      end;
canvas.TextOut(3+160*(a-1),451,inttostr(weapons[a,1].kol));
if (key=Up[a]) then begin way_for_stop[a]:='0';Way[a]:='u';end;
if (key=Down[a])then begin way_for_stop[a]:='0';Way[a]:='d';end;
if (key=Lft[a])then begin way_for_stop[a]:='0';Way[a]:='l';end;
if (key=right[a])then begin way_for_stop[a]:='0';Way[a]:='r';end;
if key=stoy[a] then if way_for_stop[a]='0' then begin way_for_stop[a]:=way[a];Way[a]:='s';end;

end;
end;

procedure TFOrm1.bomb_explore;

var a,activeBombs:integer;
begin
activeBombs:=0;
for a:=1 to NumberOfBombs do
begin
if bombs[a].kind='' then activeBombs:=activeBombs+1;
//  case bombs[a].kind of
if bombs[a].kind='smbomb' then begin;if bombs[a].TimeToDie=true then begin;bombs[a].time:=30*tb+1;bombs[a].TimeToDie:=false;end;
      case bombs[a].time of
      0*tb..10*tb:canvas.Draw(bombs[a].x*10,bombs[a].y*10,smbomb_[0]);
      10*tb+1..20*tb:canvas.Draw(bombs[a].x*10,bombs[a].y*10,smbomb_[1]);
      20*tb+1..30*tb:begin;canvas.Draw(bombs[a].x*10,bombs[a].y*10,smbomb_[2]);
                     if (bombs[a].time=30*tb)and(random(ver_zrv)>deadmans[bombs[a].owner].ver_zrv) then bombs[a].time:=-1;
                     end;

      30*tb+1:begin;playsound('c:\ALERT.WAV',0,snd_fileName or snd_application and snd_memory or snd_async);
      matrix[bombs[a].x,bombs[a].y].tip:='g';explr(bombs[a].x,bombs[a].y,'smbomb',-1);end;
      30*tb+2..33*tb:begin;explr(bombs[a].x,bombs[a].y,'smbomb',0);end;

      33*tb+1..35*tb:begin;explr(bombs[a].x,bombs[a].y,'smbomb',1);end;
      35*tb+1..37*tb:begin;explr(bombs[a].x,bombs[a].y,'smbomb',2);end;
      37*tb+1:begin;explr(bombs[a].x,bombs[a].y,'smbomb',3);bombs[a].kind:='';bombs[a].TimeToDie:=false;end;
     end;if bombs[a].time<>-1 then bombs[a].time:=bombs[a].time+1 else canvas.Draw(bombs[a].x*10,bombs[a].y*10,smbomb_[3]);
    end;
if bombs[a].kind='bomb' then begin;if bombs[a].TimeToDie=true then begin;bombs[a].time:=30*tb+1;bombs[a].TimeToDie:=false;end;
      case bombs[a].time of
      0*tb..10*tb:canvas.Draw(bombs[a].x*10,bombs[a].y*10,bomb_[0]);
      10*tb+1..20*tb:canvas.Draw(bombs[a].x*10,bombs[a].y*10,bomb_[1]);
      20*tb+1..30*tb:begin;canvas.Draw(bombs[a].x*10,bombs[a].y*10,bomb_[2]);
                     if (bombs[a].time=30*tb)and(random(ver_zrv)>deadmans[bombs[a].owner].ver_zrv) then bombs[a].time:=-1;
                     end;

      30*tb+1:begin;matrix[bombs[a].x,bombs[a].y].tip:='g';explr(bombs[a].x,bombs[a].y,'bomb',-1);end;
      30*tb+2..33*tb:begin;explr(bombs[a].x,bombs[a].y,'bomb',0);end;

      33*tb+1..35*tb:begin;explr(bombs[a].x,bombs[a].y,'bomb',1);end;
      35*tb+1..37*tb:begin;explr(bombs[a].x,bombs[a].y,'bomb',2);end;
      37*tb+1:begin;explr(bombs[a].x,bombs[a].y,'bomb',3);bombs[a].kind:='';bombs[a].TimeToDie:=false;end;
      end;if bombs[a].time<>-1 then bombs[a].time:=bombs[a].time+1 else canvas.Draw(bombs[a].x*10,bombs[a].y*10,bomb_[3]);
    end;
if bombs[a].kind='dinamite' then begin;if bombs[a].TimeToDie=true then begin;bombs[a].time:=30*tb+1;bombs[a].TimeToDie:=false;end;
      case bombs[a].time of
      0*tb..10*tb:canvas.Draw(bombs[a].x*10,bombs[a].y*10,dinamit_[0]);
      10*tb+1..20*tb:canvas.Draw(bombs[a].x*10,bombs[a].y*10,dinamit_[1]);
      20*tb+1..30*tb:begin;canvas.Draw(bombs[a].x*10,bombs[a].y*10,dinamit_[2]);
                     if (bombs[a].time=30*tb)and(random(ver_zrv)>deadmans[bombs[a].owner].ver_zrv) then bombs[a].time:=-1;
                     end;

      30*tb+1:begin;playsound('c:\HIT3.WAV',0,snd_fileName or snd_application and snd_memory or snd_async {or snd_loop});
      matrix[bombs[a].x,bombs[a].y].tip:='g';explr(bombs[a].x,bombs[a].y,'dinamite',-1);end;
      30*tb+2..33*tb:begin;explr(bombs[a].x,bombs[a].y,'dinamite',0);end;

      33*tb+1..35*tb:begin;explr(bombs[a].x,bombs[a].y,'dinamite',1);end;
      35*tb+1..37*tb:begin;explr(bombs[a].x,bombs[a].y,'dinamite',2);end;
      37*tb+1:begin;explr(bombs[a].x,bombs[a].y,'dinamite',3);bombs[a].kind:='';bombs[a].TimeToDie:=false;end;
      end;if bombs[a].time<>-1 then bombs[a].time:=bombs[a].time+1 else canvas.Draw(bombs[a].x*10,bombs[a].y*10,dinamit_[3]);
    end;
if bombs[a].kind='det_sm' then if bombs[a].TimeToDie=true then begin;
            case bombs[a].time of
            0:begin;matrix[bombs[a].x,bombs[a].y].tip:='g';explr(bombs[a].x,bombs[a].y,'bomb',-1);end;
            0+1..1*tb:begin;explr(bombs[a].x,bombs[a].y,'bomb',0);end;
            1*tb+1..2*tb:begin;explr(bombs[a].x,bombs[a].y,'bomb',1);end;
            2*tb+1..3*tb:begin;explr(bombs[a].x,bombs[a].y,'bomb',2);end;
            3*tb+1:begin;explr(bombs[a].x,bombs[a].y,'bomb',3);bombs[a].kind:='';bombs[a].TimeToDie:=false;end;
            end;bombs[a].time:=bombs[a].time+1;
           end{det_sm}else case bombs[a].time of
            1:canvas.Draw(bombs[a].x*10,bombs[a].y*10,dit_sm_1);
            2:canvas.Draw(bombs[a].x*10,bombs[a].y*10,dit_sm_2);
            3:canvas.Draw(bombs[a].x*10,bombs[a].y*10,dit_sm_3);
            end;
if bombs[a].kind='det_lg' then if bombs[a].TimeToDie=true then begin;
            case bombs[a].time of
            0:begin;playsound('c:\HIT3.WAV',0,snd_fileName or snd_application and snd_memory or snd_async);
            matrix[bombs[a].x,bombs[a].y].tip:='g';explr(bombs[a].x,bombs[a].y,'dinamite',-1);end;
            0+1..1*tb:begin;explr(bombs[a].x,bombs[a].y,'dinamite',0);end;
            1*tb+1..2*tb:begin;explr(bombs[a].x,bombs[a].y,'dinamite',1);end;
            2*tb+1..3*tb:begin;explr(bombs[a].x,bombs[a].y,'dinamite',2);end;
            3*tb+1:begin;explr(bombs[a].x,bombs[a].y,'dinamite',3);bombs[a].kind:='';bombs[a].TimeToDie:=false;end;
            end;bombs[a].time:=bombs[a].time+1;
           end {det_sm} else case bombs[a].time of
            1:canvas.Draw(bombs[a].x*10,bombs[a].y*10,dit_lg_1);
            2:canvas.Draw(bombs[a].x*10,bombs[a].y*10,dit_lg_2);
            3:canvas.Draw(bombs[a].x*10,bombs[a].y*10,dit_lg_3);
            end;//if not((bombs[a].time<1)and(bombs[a].time>4)) then begin


//  end;{case}
end;{for}canvas.TextOut(1,1,inttostr(NumberOfBombs));
if activeBombs>=NumberOfBombs then begin;NumberOfBombs:=0;end;
end;{procedure}


procedure TForm1.ReDraw(x1,y1:integer);
begin
case matrix[x1,y1].tip of
'g':canvas.Draw(x1*10,y1*10,MGrd);
'b':canvas.Draw(x1*10,y1*10,beton);
'0'..'9':canvas.Draw(x1*10,y1*10,dveri);
'!'..'*':canvas.Draw(x1*10,y1*10,vikl1);
'k':begin;if matrix[x1,y1].zizn>(kirpich_zizn div 3)*2 then begin;matrix[x1,y1].tip:='k';canvas.Draw(x1*10,y1*10,kirpich);end;
          if matrix[x1,y1].zizn<=(kirpich_zizn div 3)*1 then canvas.Draw(x1*10,y1*10,mkirpich);
          if (matrix[x1,y1].zizn>(kirpich_zizn div 3)*1)and(matrix[x1,y1].zizn<=(kirpich_zizn div 3)*2) then canvas.Draw(x1*10,y1*10,hkirpich);end;

'w':canvas.Draw(x1*10,y1*10,weapon);
'p':canvas.Draw(x1*10,y1*10,pesok);
'K':canvas.Draw(x1*10,y1*10,krov);
'm':canvas.Draw(x1*10,y1*10,mine);
'L':canvas.Draw(x1*10,y1*10,block);
'l':canvas.Draw(x1*10,y1*10,kley);

{'d':canvas.Draw(x1*10,y1*10,dit_sm_1);
'f':canvas.Draw(x1*10,y1*10,dit_sm_2);
'h':canvas.Draw(x1*10,y1*10,dit_sm_3);

{'D':canvas.Draw(x1*10,y1*10,dit_lg_1);
'F':canvas.Draw(x1*10,y1*10,dit_lg_2);
'H':canvas.Draw(x1*10,y1*10,dit_lg_3);}


'[':canvas.Draw(x1*10,y1*10,pesok2);
']':canvas.Draw(x1*10,y1*10,pesok3);
's':begin;if matrix[x1,y1].zizn>=(skala_zizn div 3)*2 then canvas.Draw(x1*10,y1*10,skala);
          if matrix[x1,y1].zizn<(skala_zizn div 3)*1 then canvas.Draw(x1*10,y1*10,mskala);
          if (matrix[x1,y1].zizn>=(skala_zizn div 3)*1)and(matrix[x1,y1].zizn<(skala_zizn div 3)*2) then canvas.Draw(x1*10,y1*10,hskala);
   end;

'q':begin;if matrix[x1,y1].zizn>=(skala_zizn div 3)*2 then canvas.Draw(x1*10,y1*10,skala2);
          if matrix[x1,y1].zizn<(skala_zizn div 3)*1 then canvas.Draw(x1*10,y1*10,mskala);
          if (matrix[x1,y1].zizn>=(skala_zizn div 3)*1)and(matrix[x1,y1].zizn<(skala_zizn div 3)*2) then canvas.Draw(x1*10,y1*10,hskala);end;
'e':begin;if matrix[x1,y1].zizn>=(skala_zizn div 3)*2 then canvas.Draw(x1*10,y1*10,skala3);
          if matrix[x1,y1].zizn<(skala_zizn div 3)*1 then canvas.Draw(x1*10,y1*10,mskala);
          if (matrix[x1,y1].zizn>=(skala_zizn div 3)*1)and(matrix[x1,y1].zizn<(skala_zizn div 3)*2) then canvas.Draw(x1*10,y1*10,hskala);end;


end;{case}

end;{procedure}

procedure TForm1.Explr(x1,y1:integer;kind:string;frm:shortint);
var a,b:integer;
begin

//case kind of
if kind='smbomb' then for a:=0 to 2 do for b:=0 to 2 do if (exp_smbomb[b,a]='1') then begin;//MessageBeep(0);
         if frm=-1 then begin;bomb_check(x1-1+b,y1-1+a,smb_exp);end;
         if (frm<>-1)and(frm<>3) then canvas.Draw(x1*10-10+b*10,y1*10-10+a*10,explore[frm]) else redraw(x1-1+b,y1-1+a);
  end;

if (kind='bomb')or(kind='det_sm') then for a:=0 to 4 do for b:=0 to 4 do if (exp_bomb[b,a]='1') then begin;//MessageBeep(0);
         if frm=-1 then begin;bomb_check(x1-2+b,y1-2+a,b_exp);end;
         if (frm<>-1)and(frm<>3) then canvas.Draw(x1*10-20+b*10,y1*10-20+a*10,explore[frm]) else redraw(x1-2+b,y1-2+a);
  end;
if kind='dinamite' then for a:=0 to 6 do for b:=0 to 6 do if (exp_din[b,a]='1') then begin;//MessageBeep(0);
         if frm=-1 then begin;bomb_check(x1-3+b,y1-3+a,b_exp);end;
         if (frm<>-1)and(frm<>3) then canvas.Draw(x1*10-30+b*10,y1*10-30+a*10,explore[frm]) else redraw(x1-3+b,y1-3+a);
  end;

//end;{case}
end;{procedure}

procedure TForm1.Bomb_check(x1,y1:integer;bomb_exp:integer);
var i:1..200;
    a:0..4;
begin
         if (matrix[x1,y1].tip='`')or(matrix[x1,y1].tip='d')or(matrix[x1,y1].tip='f')or(matrix[x1,y1].tip='h')or(matrix[x1,y1].tip='D')or(matrix[x1,y1].tip='F')or(matrix[x1,y1].tip='H')
            then for i:=1 to NumberOfBombs do
             if (bombs[i].x=x1)and(bombs[i].y=y1)then begin;bombs[i].time:=0;matrix[x1,y1].tip:='g';bombs[i].TimeToDie:=true;{messageBeep(0);}end;

         if (matrix[x1,y1].tip='m')then mine_exp(x1,y1);
         if (matrix[x1,y1].tip='l')then matrix[x1,y1].tip:='g';
         if (matrix[x1,y1].tip='L')then begin;matrix[x1,y1].zizn:=skala_zizn;matrix[x1,y1].tip:='s'end;
         if (matrix[x1,y1].zizn-bomb_exp<=0)and(matrix[x1,y1].tip<>'b')and(matrix[x1,y1].tip<>'K')and(matrix[x1,y1].tip<>'g')and(matrix[x1,y1].tip>'9')
         then begin;matrix[x1,y1].tip:='g';matrix[x1,y1].zizn:=0;end else begin
           matrix[x1,y1].zizn:=matrix[x1,y1].zizn-bomb_exp;
         end;{else}

         for a:=0 to 4 do if (x1=round(x[a])div 10)and(y1=round(y[a])div 10) then  begin;deadmans[a].zizn:=deadmans[a].zizn-bomb_exp;if (deadmans[a].zizn<=0)and(Matrix[x1,y1].tip='g') then begin;Matrix[x1,y1].tip:='K' end;end


end;{procedure}

procedure TForm1.NetKey(key:char);
var a:word;
begin
//messageBeep(0);
if typeGame=Net then for a:=1 to NumberOfPlayers do begin;
case key of
'U':begin;//Main.Msg1.Host:=DeadMans[a].IP;
         {Main.Msg1.PostIt(inttostr(key));}end;

'D':begin;end;
'L':begin;end;
'R':begin;end;
'f':begin;end;
's':begin;end;
end;{case}

end;end;

procedure TForm1.Zriv(a:integer);
var i:integer;
begin;
for i:=0 to 10 do
 case i of
  0:begin;matrix[bombs[a].x,bombs[a].y].tip:='g';explr(bombs[a].x,bombs[a].y,bombs[a].kind,-1);end;
  0+1..2*tb:begin;explr(bombs[a].x,bombs[a].y,bombs[a].kind,0);end;
  2*tb+1..4*tb:begin;explr(bombs[a].x,bombs[a].y,bombs[a].kind,1);end;
  4*tb+1..6*tb:begin;explr(bombs[a].x,bombs[a].y,bombs[a].kind,2);end;
  6*tb+1:begin;explr(bombs[a].x,bombs[a].y,bombs[a].kind,3);bombs[a].kind:='';bombs[a].TimeToDie:=false;end;
 end;{case}


end;
//--------------------------&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.Move_Bombs(kind:string;a:shortint);
var c,step:smallint;
begin;

if kind='laz' then begin;//playsound('c:\CLOSETXT.WAV',0,snd_fileName or snd_application and snd_memory or snd_async);
step:=lazer[a].step;
       case lazer[a].lw of

          'u':begin;
               while(lazer[a].step-step<70) do begin;lazer[a].step:=lazer[a].step+1;//bomb_check(lazer[a].bx,lazer[a].by-lazer[a].step,150);
                 if (matrix[lazer[a].bx,lazer[a].by-lazer[a].step].tip<>'g')and(matrix[lazer[a].bx,lazer[a].by-lazer[a].step].tip<>'`')and(matrix[lazer[a].bx,lazer[a].by-lazer[a].step].tip<>'K')
                    then begin;lazer[a].lw:='0';bomb_check(lazer[a].bx,lazer[a].by-lazer[a].step,150);Sleep(100);
                      for c:=0 to lazer[a].step do redraw(lazer[a].bx,lazer[a].by-c);Break;
                      end;{if}canvas.Draw(lazer[a].bx*10,lazer[a].by*10-(lazer[a].step)*10,lazer_[0]);bomb_check(lazer[a].bx,lazer[a].by-lazer[a].step,150);end;{while}
               end;{'u'}
           'd':begin;messagebeep(0);
               while(lazer[a].step-step<70) do begin;lazer[a].step:=lazer[a].step+1;
                 if (matrix[lazer[a].bx,lazer[a].by+lazer[a].step].tip<>'g')and(matrix[lazer[a].bx,lazer[a].by+lazer[a].step].tip<>'`')and(matrix[lazer[a].bx,lazer[a].by+lazer[a].step].tip<>'K')
                    then begin;lazer[a].lw:='0';bomb_check(lazer[a].bx,lazer[a].by+lazer[a].step,150);Sleep(100);
                      for c:=1 to lazer[a].step do redraw(lazer[a].bx,lazer[a].by+c);Break;
                      end;{if}canvas.Draw(lazer[a].bx*10,(lazer[a].by)*10+(lazer[a].step)*10,lazer_[0]);bomb_check(lazer[a].bx,lazer[a].by+lazer[a].step,150);end;{while}
               end;{'d'}
           'r':begin;messagebeep(0);
               while(lazer[a].step-step<70) do begin;lazer[a].step:=lazer[a].step+1;
                 if (matrix[lazer[a].bx+lazer[a].step,lazer[a].by].tip<>'g')and(matrix[lazer[a].bx+lazer[a].step,lazer[a].by].tip<>'`')and(matrix[lazer[a].bx+lazer[a].step,lazer[a].by].tip<>'K')
                    then begin;lazer[a].lw:='0';bomb_check(lazer[a].bx+lazer[a].step,lazer[a].by,150);Sleep(100);
                      for c:=1 to lazer[a].step do redraw(lazer[a].bx+c,lazer[a].by);Break;
                      end;{if}canvas.Draw(lazer[a].bx*10+(lazer[a].step)*10,lazer[a].by*10,lazer_[1]);bomb_check(lazer[a].bx+lazer[a].step,lazer[a].by,150);end;{while}
               end;{'r'}
           'l':begin;messagebeep(0);
               while(lazer[a].step-step<70) do begin;lazer[a].step:=lazer[a].step+1;
                 if (matrix[lazer[a].bx-lazer[a].step,lazer[a].by].tip<>'g')and(matrix[lazer[a].bx-lazer[a].step,lazer[a].by].tip<>'`')and(matrix[lazer[a].bx-lazer[a].step,lazer[a].by].tip<>'K')
                    then begin;lazer[a].lw:='0';bomb_check(lazer[a].bx-lazer[a].step,lazer[a].by,150);Sleep(100);
                      for c:=1 to lazer[a].step do redraw(lazer[a].bx-c,lazer[a].by);Break;
                      end;{if}canvas.Draw(lazer[a].bx*10-(lazer[a].step)*10,lazer[a].by*10,lazer_[1]);bomb_check(lazer[a].bx-lazer[a].step,lazer[a].by,150);end;{while}
               end;{'r'}


          end;
      end;{lazer}
end;

procedure TForm1.mine_exp(x1,y1:integer);
begin;
NumberOfBombs:=NumberOfBombs+1;
      SetLength(bombs,NumberOfBombs+1);
      bombs[numberOfbombs].kind:='bomb';
      bombs[numberOfbombs].x:=x1;
      bombs[numberOfbombs].y:=y1;
      matrix[x1,y1].tip:='g';
      bombs[numberOfbombs].time:=0;
      bombs[numberOfbombs].TimeToDie:=true;
end;

procedure TForm1.zalivka(x,y,num:integer;kind:char);
var a,x1,y1,vsego_toch:integer;
    pixels:array[0..50]of record
                           x,y:integer;
                           end;
begin;
pixels[0].x:=x;pixels[0].y:=y;
matrix[x,y].tip:=kind;
vsego_toch:=0;
for a:=0 to num do begin;

 for y1:=pixels[a].y-1 to pixels[a].y+1 do for x1:=pixels[a].x-1 to pixels[a].x+1 do
   begin;
   if ((y1=pixels[a].y)or(x1=pixels[a].x))then
if matrix[x1,y1].tip='g' then      begin;
      inc(vsego_toch);if (vsego_toch)>num then exit;
      pixels[vsego_toch].x:=x1;pixels[vsego_toch].y:=y1;
      matrix[x1,y1].tip:=kind;
      Redraw(x1,y1);
//      canvas.Pixels[x1,y1]:=0;
//      canvas.Rectangle(x1*10,y1*10,(x1+1)*10,(y1+1)*10);
      end;

   end;


end;
end;

end.
