unit frmCadastrarProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, untInterfaces,
  Vcl.Buttons;

type
  TfrmCadastrarProdutos = class(TForm)
    Label2: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    edNomeProduto: TEdit;
    edCodBarras: TEdit;
    btnNovo: TBitBtn;
    btnCancelar: TBitBtn;
    btnSalvar: TBitBtn;
    btnSair: TBitBtn;
    edPrecoUnitario: TMaskEdit;
    procedure FormShow(Sender: TObject);
    procedure StatusEdits(prmStatus: Boolean);
    procedure btnSairClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edPrecoUnitarioExit(Sender: TObject);
    procedure edCodBarrasExit(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure LimparEdits();
    procedure EnableBotoes(prmEnable: Boolean);
  private
    { Private declarations }
    pvtProduto: IProduto;
  public
    { Public declarations }
  end;

var
  frmCadastrarProdutos: TfrmCadastrarProdutos;

implementation

{$R *.dfm}

uses frmDataModulo, Funcoes, untClasses;

procedure TfrmCadastrarProdutos.StatusEdits(prmStatus: Boolean);
begin
  edNomeProduto.Enabled := prmStatus;
  edPrecoUnitario.Enabled := prmStatus;
  edCodBarras.Enabled := prmStatus;
end;

procedure TfrmCadastrarProdutos.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadastrarProdutos.btnSalvarClick(Sender: TObject);
begin
  if not Assigned(pvtProduto) then
     Exit();

  //Testando Nome do Produto
  if edNomeProduto.Text = '' then
  begin
    MessageDlg('Favor digitar o nome do produto!',mtConfirmation,[mbOK], 0);
    edNomeProduto.SetFocus;
    Exit;
  end;

  //Testando Pre�o Unit�rio
  if edPrecoUnitario.Text = '' then
  begin
    MessageDlg('Favor digitar o pre�o!',mtConfirmation,[mbOK], 0);
    edPrecoUnitario.SetFocus;
    Exit;
  end;

  if not pvtProduto.SalvarProduto(edNomeProduto.Text, edPrecoUnitario.Text) then
  begin
    MessageDlg('Erro ao salvar novo produto!',mtConfirmation,[mbOK], 0);
    edPrecoUnitario.SetFocus;
    Exit;
  end;

  MessageDlg('Produto Salvo com Sucesso',mtConfirmation,[mbOK], 0);
  StatusEdits(False);
  LimparEdits();
  EnableBotoes(true);
  btnNovo.SetFocus();
end;

procedure TfrmCadastrarProdutos.btnCancelarClick(Sender: TObject);
begin
  StatusEdits(False);
  LimparEdits();
  btnCancelar.Enabled := False;
  btnSalvar.Enabled := False;
  btnNovo.Enabled := True;
  pvtProduto.Clear();
  btnNovo.SetFocus();
end;

procedure TfrmCadastrarProdutos.btnNovoClick(Sender: TObject);
begin
  if not Assigned(pvtProduto) then
    pvtProduto := TProduto.Create();

  StatusEdits(true);
  EnableBotoes(false);
  edNomeProduto.SetFocus();
end;

procedure TfrmCadastrarProdutos.edCodBarrasExit(Sender: TObject);
begin
  if not Assigned(pvtProduto) then
    pvtProduto := TProduto.Create();
  if pvtProduto.CodigoBarrasExiste(edCodBarras.Text) then
  begin
    MessageDlg('C�digo de barras cadastrado em outro produto!',mtConfirmation,[mbOK], 0);
    edCodBarras.SetFocus;
  end;
end;

procedure TfrmCadastrarProdutos.edPrecoUnitarioExit(Sender: TObject);
var
  LocValor: String;
begin
  if edPrecoUnitario.Text <> '' then
  begin
    if not IsDouble(edPrecoUnitario.Text) then
    begin
      MessageDlg('Favor digitar valor v�lido!',mtConfirmation,[mbOK], 0);
      edPrecoUnitario.SetFocus();
    end;
  end;
end;

procedure TfrmCadastrarProdutos.EnableBotoes(prmEnable: Boolean);
begin
  btnNovo.Enabled     := prmEnable;
  btnCancelar.Enabled := not prmEnable;
  btnSalvar.Enabled   := not prmEnable;
end;

procedure TfrmCadastrarProdutos.FormShow(Sender: TObject);
begin
  StatusEdits(False);
end;

procedure TfrmCadastrarProdutos.LimparEdits;
var
  i: Integer;
begin
  //Contador que verifica todos os componentes do Form
  for i := 0 to ComponentCount -1 do
  begin
      //Verifica se o objeto � do tipo TEdit
      if (Components[i] is TEdit) then
          (Components[i] as TEdit).Clear;
  end;
end;

end.


uses untInterfaces;
