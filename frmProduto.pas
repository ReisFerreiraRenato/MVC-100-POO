unit frmProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Data.DB,
  Vcl.Grids, Vcl.DBGrids, untInterfaces;

type
  TfrmProdutos = class(TForm)
    tbNome: TEdit;
    btnAdicionar: TBitBtn;
    Label1: TLabel;
    GridProdutos: TDBGrid;
    tbQuantidade: TEdit;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    btnSair: TBitBtn;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSairClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure tbNomeChange(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure tbNomeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tbQuantidadeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    //pbcIDVenda: Integer;
    pbcNovaVenda: IVenda;
  end;

var
  frmProdutos: TfrmProdutos;

implementation

{$R *.dfm}

uses Funcoes, frmDataModulo, frmCadastrarProduto;

procedure TfrmProdutos.BitBtn1Click(Sender: TObject);
begin
  AbrirCadastroProdutos();
  dmPrincipal.qrProduto.Close();
  dmPrincipal.qrProduto.Open();
end;

procedure TfrmProdutos.btnAdicionarClick(Sender: TObject);   //OK Interface
begin

  if pbcNovaVenda.getNumeroPedido = 0 then
  begin
    pbcNovaVenda.Iniciar();
    //pbcIDVenda := pbcNovaVenda.getNumeroPedido;
  end;

  if dmPrincipal.qrProduto.RecordCount = 0 then
  begin
    MessageDlg('Favor pesquisar e selecionar o produto!',mtConfirmation,[mbOK], 0);
    tbNome.SetFocus();
    Exit();
  end;

  if not IsDouble(tbQuantidade.Text) then
  begin
    MessageDlg('Favor digitar a quantidade v�lida!',mtConfirmation,[mbOK], 0);
    tbQuantidade.SetFocus();
    Exit();
  end;

  if not pbcNovaVenda.VendaGravada() then
     pbcNovaVenda.Gravar();

  if not pbcNovaVenda.AdicionarProdutoVendaPorID(
                  dmPrincipal.qrProduto.FieldByName('CodigoProduto').AsInteger,
                  pbcNovaVenda.getNumeroPedido, StrToFloat(tbQuantidade.Text),
                  dmPrincipal.qrProduto.FieldByName('PrecoVenda').AsFloat,
                  dmPrincipal.qrProduto.FieldByName('Descricao').AsString) then
  begin
    MessageDlg('Erro ao Adicionar Produto!',mtConfirmation,[mbOK], 0);
    btnAdicionar.SetFocus();
    Exit();
  end;

  Close();
end;

procedure TfrmProdutos.btnSairClick(Sender: TObject);
begin
  Close();
end;

procedure TfrmProdutos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dmPrincipal.qrProduto.Close();
end;

procedure TfrmProdutos.FormCreate(Sender: TObject);
begin
  dmPrincipal.qrProduto.Close();
  dmPrincipal.qrProduto.Open();
end;

procedure TfrmProdutos.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 27 then
    Close;
end;

procedure TfrmProdutos.tbNomeChange(Sender: TObject);
begin
  if tbNome.Text <> '' then
    BuscarProdutoNome(tbNome.Text);
end;

procedure TfrmProdutos.tbNomeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 13) and (tbNome.Text <> '') then
  begin
    tbQuantidade.SetFocus();
    Exit;
  end;
end;

procedure TfrmProdutos.tbQuantidadeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 13) and (tbQuantidade.Text <> '') then
  begin
    btnAdicionarClick(nil);
    Exit;
  end;
end;

end.
