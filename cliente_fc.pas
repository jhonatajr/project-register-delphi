unit cliente_fc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, DBTables, ExtCtrls, Menus, Mask,
  Buttons, jpeg,DBGrids;

type
TModoAbertura = (maInserir, maAlterar, maConsultar, maExcluir);

type
  TFC_Cliente = class(TForm)
    Ed_Nome: TEdit;
    Lb_Nome: TLabel;
    Lb_Sexo: TLabel;
    Lb_Telefone: TLabel;
    MEd_Telefone: TMaskEdit;
    Lb_Bairro: TLabel;
    LB_CEP: TLabel;
    RB_Masc: TRadioButton;
    RB_Feminino: TRadioButton;
    LB_Numero: TLabel;
    LB_Municipio: TLabel;
    LB_UF: TLabel;
    Ed_Logradouro: TEdit;
    Ed_Num: TEdit;
    LB_Logradouro: TLabel;
    Ed_Bairro: TEdit;
    PN_Topo: TPanel;
    Lb_Topo: TLabel;
    DB_Cliente: TTable;
    DS_Cliente: TDataSource;
    Ed_Municipio: TEdit;
    MEd_CEP: TMaskEdit;
    CB_Uf: TComboBox;
    Bt_Ok: TBitBtn;
    Bt_Cancelar: TBitBtn;
    Ed_Email: TEdit;
    Image1: TImage;
    Lb_Email: TLabel;
    Lb_Cpf: TLabel;
    Ed_CPF: TEdit;
    Lb_CPFAviso: TLabel;

    procedure FormShow(Sender: TObject);
    procedure Bt_OkClick(Sender: TObject);
    procedure Bt_CancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Ed_CPFExit(Sender: TObject);
    function ValidarCPF(cpf: string): boolean;
    function ValidarEmail (email: string):boolean;
    procedure Ed_EmailExit(Sender: TObject);



  private
    { Private declarations }

  public
  ModoAbertura: TModoAbertura;
  end;

var
  FC_Cliente: TFC_Cliente;

implementation
uses cliente_fm;

{$R *.dfm}


// APERTAR BOTÃO CANCELAR.
procedure TFC_Cliente.Bt_CancelarClick(Sender: TObject);
begin
FC_Cliente.Close;
end;


procedure TFC_Cliente.Bt_OkClick(Sender: TObject); // APERTAR BOTAO OK.
begin
// ALTERAÇÃO
 If ModoAbertura = maAlterar then   // enumeradores declarado em types e em public
 Begin
 DB_Cliente.Edit;  // edita a alteração, entra em modo de edição.
 DB_Cliente.FieldByName('Cli_codigo').Value;
   DB_Cliente.FieldByName('Cli_nome').AsString := Ed_Nome.Text;
   DB_Cliente.FieldByName('Cli_telefone').AsString := MEd_Telefone.Text;
   DB_Cliente.FieldByName('Cli_logradouro').AsString := Ed_Logradouro.Text;
   DB_Cliente.FieldByName('Cli_numero').AsString := Ed_Num.Text;
   DB_Cliente.FieldByName('Cli_bairro').AsString := Ed_Bairro.Text;
   DB_Cliente.FieldByName('Cli_municipio').AsString := Ed_Municipio.Text;
   DB_Cliente.FieldByName('Cli_cep').AsString := MEd_CEP.Text;
   DB_Cliente.FieldByName('Cli_uf').AsString := CB_UF.Text;
   DB_Cliente.FieldByName('Cli_email').AsString := Ed_Email.Text;
   DB_Cliente.FieldByName('Cli_cpf').AsString := Ed_CPF.Text;
      If     RB_Masc.Checked then DB_Cliente.FieldByName('Cli_sexo').AsString := RB_Masc.Caption
      Else   DB_Cliente.FieldByName('Cli_sexo').AsString := RB_Feminino.Caption;
   FM_Cliente.DBG_Clientes.Refresh;
   DB_Cliente.Post; // grava todas as linhas e coluna da tabela.
   ShowMessage('Alterado com sucesso!');
   FC_Cliente.Close;
 End

// INCLUSÃO
 Else If (ModoAbertura = maInserir) then  // enumeradores, declarado em TYPES e em public
 Begin
 DB_Cliente.Append; // cria uma linha ou registro em branco na ultima linha
   DB_Cliente.FieldByName('Cli_nome').AsString := Ed_Nome.Text;
   DB_Cliente.FieldByName('Cli_telefone').AsString := MEd_Telefone.Text;
   DB_Cliente.FieldByName('Cli_logradouro').AsString := Ed_Logradouro.Text;
   DB_Cliente.FieldByName('Cli_numero').AsString := Ed_Num.Text;
   DB_Cliente.FieldByName('Cli_bairro').AsString := Ed_Bairro.Text;
   DB_Cliente.FieldByName('Cli_municipio').AsString := Ed_Municipio.Text;
   DB_Cliente.FieldByName('Cli_cep').AsString := MEd_CEP.Text;
   DB_Cliente.FieldByName('Cli_uf').AsString := CB_UF.Text;
   DB_Cliente.FieldByName('Cli_email').AsString := Ed_Email.Text;
   DB_Cliente.FieldByName('Cli_cpf').AsString := Ed_CPF.Text;
      If     RB_Masc.Checked then DB_Cliente.FieldByName('Cli_sexo').AsString := RB_Masc.Caption
      Else If RB_Feminino.Checked Then  DB_Cliente.FieldByName('Cli_sexo').AsString := RB_Feminino.Caption
      Else DB_Cliente.FieldByName('Cli_sexo').AsString := '';
   ShowMessage('Salvo com sucesso!');  // grava alteração realizada no registro.
  DB_Cliente.ApplyUpdates;
  DB_Cliente.Close;
  DB_Cliente.Open;
  DB_Cliente.Refresh;
   FC_Cliente.Close;  // fecha a tela
 End

// CONSULTA, se apertar ok, irá fechar o painel
 Else If ModoAbertura = maConsultar then
 Begin
 FC_Cliente.Close;
  {Ed_Nome.Enabled := True;
  MEd_Telefone.Enabled := True;
  Ed_Logradouro.Enabled := True;
  Ed_Num.Enabled := True;
  Ed_Bairro.Enabled := True;
  Ed_Municipio.Enabled := True;
  MEd_CEP.Enabled := True;
  CB_UF.Enabled := True;
  Ed_Email.Enabled := True;
  Ed_CPF.Enabled := True;
  RB_Masc.Visible := True;
  RB_Feminino.Visible:= True;}

 End
end;


procedure TFC_Cliente.FormShow(Sender: TObject);  // Validação pela caption
begin
    // Alterar
 If ModoAbertura = maAlterar then // SE O Modoabertura for correspondente com o que está atribuido, executará a seguinte condição, como se fosse com o caption.
 Begin
  Lb_Topo.Caption := 'Alteração de Cliente';
  DB_cliente.FindKey([FM_Cliente.DBG_Clientes.Columns[0].Field.Value]);
  Ed_Nome.Text :=  DB_Cliente.FieldByName('Cli_nome').AsString; //OS CAMPOS IRÃO RECEBER O QUE ESTÁ NO BANCO DE DADOS E ESTARÁ ABERTO COMO MODO DE EDIÇÃO
  MEd_Telefone.Text :=  DB_Cliente.FieldByName('Cli_telefone').AsString;
  Ed_Logradouro.Text :=  DB_Cliente.FieldByName('Cli_logradouro').AsString ;
  Ed_Num.Text :=  DB_Cliente.FieldByName('Cli_numero').AsString  ;
  Ed_Bairro.Text :=  DB_Cliente.FieldByName('Cli_bairro').AsString  ;
  Ed_Municipio.Text :=  DB_Cliente.FieldByName('Cli_municipio').AsString;
  MEd_CEP.Text :=  DB_Cliente.FieldByName('Cli_cep').AsString   ;
  CB_UF.Text :=  DB_Cliente.FieldByName('Cli_uf').AsString ;
  Ed_Email.Text := DB_Cliente.FieldByName('Cli_email').AsString;
  Ed_CPF.Text := DB_Cliente.FieldByName('Cli_cpf').AsString;
    If DB_Cliente.FieldByName('Cli_sexo').AsString = 'M' then RB_Masc.Checked := Enabled//CONDICIONAL DO SEXO
    Else  RB_Feminino.Checked := Enabled;
    DB_Cliente.Refresh;
  End

    // Consulta
 Else If ModoAbertura = maConsultar then
 Begin
  DB_Cliente.FindKey([FM_Cliente.DBG_Clientes.Columns[0].Field.Value]); // Irá procurar pela coluna 0, ou seja, coluna do codigo, o valor selecionado. (Importado da Unit cliente_fm).
  Ed_Nome.Text :=  DB_Cliente.FieldByName('Cli_nome').AsString;
  MEd_Telefone.Text :=  DB_Cliente.FieldByName('Cli_telefone').AsString;
  Ed_Logradouro.Text :=  DB_Cliente.FieldByName('Cli_logradouro').AsString ;
  Ed_Num.Text :=  DB_Cliente.FieldByName('Cli_numero').AsString  ;
  Ed_Bairro.Text :=  DB_Cliente.FieldByName('Cli_bairro').AsString  ;
  Ed_Municipio.Text :=  DB_Cliente.FieldByName('Cli_municipio').AsString;
  MEd_CEP.Text :=  DB_Cliente.FieldByName('Cli_cep').AsString   ;
  CB_UF.Text :=  DB_Cliente.FieldByName('Cli_uf').AsString ;
  Ed_Email.Text := DB_Cliente.FieldByName('Cli_email').AsString;
  Ed_CPF.Text := DB_Cliente.FieldByName('Cli_cpf').AsString;
    If DB_Cliente.FieldByName('Cli_sexo').AsString = 'M' then RB_Masc.Checked := Enabled
    Else RB_Feminino.Checked := Enabled;

      // Deixando os campos bloqueados para edição.
  Ed_Nome.Enabled := False;
  MEd_Telefone.Enabled := False;
  Ed_Logradouro.Enabled := False;
  Ed_Num.Enabled := False;
  Ed_Bairro.Enabled := False;
  Ed_Municipio.Enabled := False;
  MEd_CEP.Enabled := False;
  CB_UF.Enabled := False;
  Ed_Email.Enabled := False;
  Ed_CPF.Enabled := False;

    If   RB_Masc.Checked then
    Begin
     RB_Masc.Enabled := False;
     RB_Feminino.Visible := False;
    End
    Else If RB_Feminino.Checked Then
    Begin
     RB_Feminino.Enabled := False;
     RB_Masc.Visible := False;
    End

 End

     // Inclusão, por valor padrão recebem ASPAS, COMO VALOR default.
 Else If ModoAbertura = maInserir then
 Begin
  DB_Cliente.Edit; 
  Ed_Nome.Text := '';
  MEd_Telefone.Text := '';
  Ed_Logradouro.Text := '';
  Ed_Num.Text := '';
  Ed_Bairro.Text := '';
  Ed_Municipio.Text := '';
  MEd_CEP.Text := '';
  CB_UF.Text := '';
  Ed_Email.Text := '';
  Ed_CPF.Text := '';
 End
end;



procedure TFC_Cliente.FormCreate(Sender: TObject); // POSIÇÃO QUE IRÁ ABRIR O FORM
begin
FC_Cliente.Top := 250;
FC_Cliente.Left:= 450;
end;



procedure TFC_Cliente.Ed_CPFExit(Sender: TObject);
begin
 If not ValidarCPF(Ed_CPF.Text) then
 Begin
  ShowMessage('CPF Invalido');
  Ed_CPF.Clear;
 End
end;


function TFC_Cliente.ValidarCPF(cpf: string): boolean;
var
n: array [1..9] of integer; // vetor
s, d2, d1, i: integer;     // auxiliares
calculado, digitado: string;  // comparação dos ultimos digitos
begin

 For i := 1 to 9 do
 Begin
   n[i] := StrToInt(cpf[i]);   // atribuindo o que foi digitado para a variavel N
 End;
   s := n[1]*10 + n[2]*9 + n[3]*8 + n[4]*7 + n[5]*6 + n[6]*5 + n[7]*4 + n[8]*3 + n[9]*2;   // fazendo a soma fatorial dos 9 primeiros números.
   d1 := (s*10) mod 11; // a soma VEZES 10, e o resto da divisao atribui a d1.
 If d1 = 10 then d1 := 0;  // se o resto for igual a 10, automaticamente vira 0.
   // fazendo a soma fatorial e atribuindo o ultimo digito VEZES 2.
  s := n[1]*11 + n[2]*10 + n[3]*9 + n[4]*8 + n[5]*7 + n[6]*6 + n[7]*5 + n[8]*4 + n[9]*3 + d1*2;
  d2 := (s*10) mod 11;
  // concatenando os valores inteiros como string, tanto d1 e tanto d2, (digito 1 & digito 2)
  calculado := inttostr(d1) + inttostr (d2);
  digitado := cpf[10] + cpf [11];  // pegando o valor de string (os dois ultimos)
 // comparando se os digitados e informados são os mesmos, se for será válido o CPF, se não for, será falso.
 If calculado = digitado then Result := True
 Else
  Result := False;
end;


function TFC_Cliente.ValidarEmail(email: string): boolean;
begin
email := Trim(UpperCase(email)); // trim retira espaços se houver e uppercase para se for maiuscula também valerá.
 If Pos('@', email) > 1 then   // se o arroba da string email for maior que 1 irá executar:
 Begin
  Delete(email,1,Pos('@',email)); // a string email da posição 1 será deletada, exemplo: 'jhonata98@hotmail.com ' ficará: 'hotmail.com'
  Result := (Length(email) > 0) AND (Pos('.', email) > 2); // se a quantidade do resto do email for igual a zero E a posição do ponto for maior que 2, será verdadeiro e retornará na procedure
 End
 Else
  Result := False;    // se for falso retornará na procedure como falso.
end;

procedure TFC_Cliente.Ed_EmailExit(Sender: TObject);
begin
If not ValidarEmail(Ed_Email.Text) then   // se NÃO, se der falso, o inverso.
Begin
  ShowMessage('E-mail inválido');
  Ed_Email.Clear;
End;
end;

end.
















