unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, jpeg;

type
  TIntro = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Image1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure FinishIntro;
  public
    { Public declarations }
  end;

var
  Intro: TIntro;

implementation

{$R *.DFM}

procedure TIntro.FinishIntro;
begin
  Timer1.Enabled := False;
end;

procedure TIntro.Timer1Timer(Sender: TObject);
begin
  FinishIntro;
end;

procedure TIntro.FormKeyPress(Sender: TObject; var Key: Char);
begin
  FinishIntro;
end;

procedure TIntro.Image1Click(Sender: TObject);
begin
  FinishIntro;
end;

procedure TIntro.FormCreate(Sender: TObject);
begin
  Image1.Picture.LoadFromFile('Images\Bomber.JPG');
end;

end.
