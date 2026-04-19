program TnT;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Intro},
  Unit3 in 'Unit3.pas' {Main};

{$R *.RES}


begin
  Application.Initialize;

//Intro:=TIntro.create(application);
//Intro.show;
//Intro.Update; //����������� �� ���������

//While Intro.Timer1.enabled do application.processMessages;

//Intro.Hide;
//Intro.free;

  Application.Title := 'TnT';
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
