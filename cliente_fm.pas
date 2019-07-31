unit cliente_fm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, DB, DBTables, Buttons,
  FMTBcd, SqlExpr;

type
  TFM_Cliente = class(TForm)
    LB_Titulo: TLabel;
    PN_Topo: TPanel;
    Ed_Consulta: TEdit;
    DS_Cliente: TDataSource;
    DB_Cliente: TTable;
    Bt_Incluir: TBitBtn;
    Bt_Alterar: TBitBtn;
    Bt_Consultar: TBitBtn;
    Bt_Excluir: TBitBtn;
    Bt_ConsultaNome: TBitBtn;
    Bt_Voltar: TBitBtn;
    DBG_Clientes: TDBGrid;
    procedure Ed_ConsultaChange(Sender: TObject);
    procedure Bt_IncluirClick(Sender: TObject);
    procedure Bt_AlterarClick(Sender: TObject);
    procedure Bt_ConsultarClick(Sender: TObject);
    procedure Bt_ExcluirClick(Sender: TObject);
    procedure Bt_ConsultaNomeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Bt_VoltarClick(Sender: TObject);
  
    




    
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FM_Cliente: TFM_Cliente;
  ConsultaName: String;
implementation

uses cliente_fc; // usar a unit do cliente_fc


{$R *.dfm}

procedure TFM_Cliente.Bt_IncluirClick(Sender: TObject); // INCLUIR
begin
FC_Cliente.ModoAbertura := maInserir;
  FC_Cliente.Caption := 'Inclusão de Cliente';
  FC_Cliente.Show;

end;

procedure TFM_Cliente.Bt_AlterarClick(Sender: TObject);  // ALTERAR
begin
  FC_Cliente.ModoAbertura := maAlterar;
  DB_Cliente.Open; 
   If  DB_Cliente.RecordCount <> 0  Then
   Begin
    DB_cliente.FindKey([DBG_Clientes.Columns[0].Field.Value]);   // IRÁ PROCURAR pela coluna do codigo o valor selecionado.
    FC_Cliente.Caption := 'Alteração de Cliente';
    FC_Cliente.Show;
   End
  Else If Application.MessageBox('Não há como alterar nenhum cliente, nenhum está disponível, deseja incluir algum?', 'No have cliente', mb_yesno + mb_iconquestion) = id_yes Then
  Begin
    FC_Cliente.ModoAbertura := maInserir;
    FC_Cliente.Caption := 'Inclusão de Cliente';
    FC_Cliente.Show;
  End
  Else

end;

procedure TFM_Cliente.Bt_ConsultarClick(Sender: TObject);  // CONSULTAR
begin
FC_Cliente.ModoAbertura := maConsultar;
  FC_Cliente.Caption := 'Consulta de Clientes';

  FC_Cliente.Show;
end;

procedure TFM_Cliente.Bt_ExcluirClick(Sender: TObject);   // APAGAR CLIENTE, SEM ABRIR A FORM
begin
  If Application.MessageBox('Deseja mesmo excluir?', 'Exclusão', mb_yesno + mb_iconquestion) = id_yes then  // irá abrir um messagebox com opões sim ou nao
  Begin
   DB_Cliente.Open;
   DB_Cliente.FindKey([DBG_Clientes.Columns[0].Field.Value]);
   DB_Cliente.Delete;
   DB_Cliente.Refresh;
   DB_Cliente.Close;
   DB_Cliente.Open;
  End
  Else
     // irá ficar vazio por que não irá fazer nada, apenas fechar a telinha do MessageBox
end;

procedure TFM_Cliente.Bt_ConsultaNomeClick(Sender: TObject); // CONSULTA POR NOME
begin

DB_Cliente.Filtered := False;  // FILTRO FALSO
DB_Cliente.Open;
DB_Cliente.Filter := 'Cli_nome = ' + QuotedStr(ConsultaName);// Consultando por nome, QuotedStr traz toda a string que foi digitada e se for igual ao parametro da variavel da Edit, irá filtrar, senao, irá ser nulo .
DB_Cliente.Filtered := True;    // FILTRO ATIVO, SE FOR NULO OU NÃO, ATIVARÁ DO MESMO JEITO.
DB_Cliente.IndexName := 'iNome'; // Indice secundário criado no Paradox
  if DB_Cliente.FindKey([ConsultaName]) = False then ShowMessage('Não existe'); // SE O VALOR DO INDICE SECUNDARIO FOR FALSO, OU SEJA NÃO EXISTIR, IRÁ APARECER A MENSAGEM QUE NÃO EXISTE.
DB_Cliente.Close;
DB_Cliente.Open;
end;

procedure TFM_Cliente.Ed_ConsultaChange(Sender: TObject); // VARIAVEL ATRIBUINDO O VALOR DA CONSULTA POR NOME .TEXT
begin
ConsultaName := Ed_Consulta.Text;
end;

procedure TFM_Cliente.FormCreate(Sender: TObject); // POSIÇÃO QUE IRÁ ABRIR O FORM
begin
FM_Cliente.Top := 250;
FM_Cliente.Left := 450;
DBG_Clientes.Refresh;
end;

procedure TFM_Cliente.Bt_VoltarClick(Sender: TObject); // voltar depois de filtrar
begin
DB_Cliente.Filtered := False;
DB_Cliente.Refresh;
end;

end.
