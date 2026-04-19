unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TForm1 = class(TForm)
  procedure zalivka(x,y,num:integer);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  matrix:array[0..1000,0..1000] of record
                                 tip:char;
                                 end;

implementation

{$R *.DFM}
procedure TForm1.zalivka(x,y,num:integer);
var a,x1,y1,vsego_toch:integer;
    pixels:array[0..50]of record
                           x,y:integer;
                           end;
begin;
pixels[0].x:=x;pixels[0].y:=y;
matrix[x,y].tip:='1';
vsego_toch:=0;
for a:=0 to num do begin;

 for y1:=pixels[a].y-1 to pixels[a].y+1 do for x1:=pixels[a].x-1 to pixels[a].x+1 do
   begin;
   if ((y1=pixels[a].y)or(x1=pixels[a].x))then
if matrix[x1,y1].tip='g' then      begin;
      inc(vsego_toch);if (vsego_toch)>num then exit;
      pixels[vsego_toch].x:=x1;pixels[vsego_toch].y:=y1;
      matrix[x1,y1].tip:='1';
//      canvas.Pixels[x1,y1]:=0;
      canvas.Rectangle(x1*10,y1*10,(x1+1)*10,(y1+1)*10);
      end;

   end;


end;


end;

procedure TForm1.FormCreate(Sender: TObject);
var a,b:integer;
begin
for a:=0 to 100 do for b:=0 to 100 do matrix[a,b].tip:='g';
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if Button=mbLeft then zalivka(x div 10,y div 10,40);
//if Button=mbRight then
end;

end.
