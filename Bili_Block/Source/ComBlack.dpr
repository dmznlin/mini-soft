program ComBlack;

uses
  Forms,
  UFormCombine in 'UFormCombine.pas' {fFormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
