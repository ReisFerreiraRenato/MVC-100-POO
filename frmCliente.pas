unit frmCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Mask, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, Vcl.Grids, Vcl.DBGrids, untInterfaces;

type
  TfrmClientes = class(TForm)
    btnNovo: TBitBtn;
    btnSalvar: TBitBtn;
    btnCancelar: TBitBtn;
    btnLimpar: TBitBtn;
    btnSair: TBitBtn;
    Cliente: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    tbNomeCliente: TEdit;
    tbEndereco: TEdit;
    DBGrid1: TDBGrid;
    btnAdicionarClienteVenda: TBitBtn;
    tbUF: TEdit;
    procedure btnSairClick(Sender: TObject);
    procedure tbNomeClienteChange(Sender: TObject);
    procedure LimparEdits();
    procedure btnLimparClick(Sender: TObject);
    procedure ControlaBotoes(prmEnable: Boolean);
    procedure ControlaEdits(prmEnable: Boolean);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAdicionarClienteVendaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    pbcIDCliente, pbcIDVenda: Integer;
    pbcCliente: ICliente;
  end;

var
  frmClientes: TfrmClientes;

implementation

{$R *.dfm}

uses frmDataModulo, Funcoes, untClasses;

procedure TfrmClientes.btnAdicionarClienteVendaClick(Sender: TObject);
begin

  if not dmPrincipal.qrCliente.Active then
  begin
    MessageDlg('Favor buscar cliente!',mtConfirmation,[mbOK], 0);
    tbNomeCliente.SetFocus;
    Exit();
  end;

  if dmPrincipal.qrCliente.RecordCount = 0 then
  begin
    MessageDlg('Cliente inexistente ou n�o selecionado!',mtConfirmation,[mbOK], 0);
    tbNomeCliente.SetFocus;
    Exit();
  end;

  if pbcIDVenda = 0 then
  begin
    MessageDlg('Venda n�o iniciada, imposs�vel adicionar cliente!',mtConfirmation,[mbOK], 0);
    Exit();
  end;

  pbcIDCliente := dmPrincipal.qrCliente.FieldByName('CodigoCliente').AsInteger;
  Close();
end;

procedure TfrmClientes.btnCancelarClick(Sender: TObject);
begin
  LimparEdits();
  ControlaBotoes(true);
  ControlaEdits(false);
  tbNomeCliente.SetFocus();
end;

procedure TfrmClientes.btnLimparClick(Sender: TObject);
begin
  ControlaBotoes(true);
  ControlaEdits(false);
  LimparEdits();
  tbNomeCliente.SetFocus();
  dmPrincipal.qrCliente.Close();
end;

procedure TfrmClientes.btnNovoClick(Sender: TObject);
begin
  //Iniciando o objeto
  if not Assigned(pbcCliente) then
    pbcCliente := TCliente.Create();

  ControlaBotoes(false);
  ControlaEdits(true);
  dmPrincipal.qrCliente.Close();
  tbNomeCliente.SetFocus();
end;

procedure TfrmClientes.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmClientes.btnSalvarClick(Sender: TObject);
begin
  try
    if tbNomeCliente.Text = '' then //Testando nome vazio
    begin
      MessageDlg('Favor digitar o nome do cliente!',mtConfirmation,[mbOK], 0);
      tbNomeCliente.SetFocus;
      Exit();
    end;

    if tbEndereco.Text = '' then //Testando endere�o vazio
    begin
      MessageDlg('Favor digitar o endere�o do cliente!',mtConfirmation,[mbOK], 0);
      tbEndereco.SetFocus;
      Exit();
    end;

    if tbUF.Text = '' then //Testando endere�o vazio
    begin
      MessageDlg('Favor digitar a UF do cliente!',mtConfirmation,[mbOK], 0);
      tbUF.SetFocus;
      Exit();
    end;

    if not pbcCliente.SalvarCliente(tbNomeCliente.Text, tbEndereco.Text, tbUF.Text) then
    begin
      MessageDlg('Erro ao salvar Cliente!',mtConfirmation,[mbOK], 0);
      Exit();
    end;

    if MessageDlg('Cliente '+tbNomeCliente.Text+' salvo com sucesso!'+#13+
              'Deseja adicionar o cliente na venda?', mtConfirmation,[mbYes, mbNO], 0) = 6 then
    begin
      if pbcIDVenda = 0 then
      begin
        MessageDlg('Venda n�o iniciada!',mtConfirmation,[mbOK], 0);
      end
      else
        pbcIDCliente := dmPrincipal.qrCliente.FieldByName('ID').AsInteger;
    end;
  finally
    dmPrincipal.qrCliente.Close();
    LimparEdits();
    tbNomeCliente.SetFocus;
    ControlaEdits(false);
    ControlaBotoes(true);
  end;
end;

//Fun��o para contorlar os bot�es
procedure TfrmClientes.ControlaBotoes(prmEnable: Boolean);
begin
  btnNovo.Enabled     := prmEnable;
  btnSalvar.Enabled   := not prmEnable;
  btnCancelar.Enabled := not prmEnable;
end;

procedure TfrmClientes.ControlaEdits(prmEnable: Boolean);
begin
  tbEndereco.Enabled := prmEnable;
  tbUF.Enabled       := prmEnable;
end;

//Fun��o para limpar os edits do formul�rio
procedure TfrmClientes.LimparEdits;
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

procedure TfrmClientes.tbNomeClienteChange(Sender: TObject);
begin
  if (tbNomeCliente.Text <> '') and btnNovo.Enabled then
  begin
    if not BuscarCliente(tbNomeCliente.Text) then
      MessageDlg('Erro ao buscar Cliente!',mtConfirmation,[mbOK], 0);
  end;
end;

end.
