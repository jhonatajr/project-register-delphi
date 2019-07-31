program Project2;

uses
  Forms,
  cliente_fm in 'cliente_fm.pas' {FM_Cliente},
  cliente_fc in 'cliente_fc.pas' {FC_Cliente};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFM_Cliente, FM_Cliente);
  Application.CreateForm(TFC_Cliente, FC_Cliente);
  Application.Run;
end.
