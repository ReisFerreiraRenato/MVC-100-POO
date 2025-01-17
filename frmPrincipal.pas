unit frmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  System.Actions, Vcl.ActnList, untInterfaces, Datasnap.DBClient, Provider,
  untClasses, System.Generics.Collections, System.Rtti, Midas, MidasLib;

type
  Tfrm_Principal = class(TForm)
    Panel1: TPanel;
    GridItemVenda: TDBGrid;
    Panel2: TPanel;
    Panel3: TPanel;
    Label5: TLabel;
    Label3: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    lbVendaIniciada: TLabel;
    edProduto: TEdit;
    edQuantidade: TEdit;
    edNomeCliente: TEdit;
    Panel7: TPanel;
    imgSair: TImage;
    imgFinalizarVenda: TImage;
    imgConsultarVenda: TImage;
    imgCliente: TImage;
    imgProduto: TImage;
    imgFecharVenda: TImage;
    p: TImage;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    lbSair: TLabel;
    lbFinalizarVenda: TLabel;
    Panel11: TPanel;
    lbConsultarVenda: TLabel;
    Panel12: TPanel;
    lbCliente: TLabel;
    Panel13: TPanel;
    lbProdutos: TLabel;
    Panel14: TPanel;
    lbCancelarVenda: TLabel;
    Panel15: TPanel;
    lbNovaVenda: TLabel;
    lbNumeroVenda: TLabel;
    ActionList1: TActionList;
    ActionNovaVenda: TAction;
    ActionCancelaVenda: TAction;
    ActionBuscarProdutos: TAction;
    ActionBuscarClientes: TAction;
    ActionConsultarVendas: TAction;
    ActionFinalizarVenda: TAction;
    ActionSair: TAction;
    Label4: TLabel;
    tbQuantidadeItens: TEdit;
    tbDataVenda: TEdit;
    tbValorTotal: TEdit;
    tbNumeroVenda: TEdit;
    DsProdutos: TDataSource;
    cdsProdutos: TClientDataSet;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edQuantidadeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ActionNovaVendaExecute(Sender: TObject);
    procedure ActionCancelaVendaExecute(Sender: TObject);
    procedure ActionBuscarProdutosExecute(Sender: TObject);
    procedure ActionBuscarClientesExecute(Sender: TObject);
    procedure ActionConsultarVendasExecute(Sender: TObject);
    procedure ActionFinalizarVendaExecute(Sender: TObject);
    procedure ActionSairExecute(Sender: TObject);
    procedure AtualizarEditsTela();
    procedure LimparEditsTela();
    procedure PreencherDataset();
    function CriarDataSet(): Boolean;
  private
    { Private declarations }
    pvtIDNovaVenda, //ID da venda
    pvtIDCliente: Integer; //ID Cliente
    pvtNovaVenda: IVenda;
  public
    { Public declarations }
  end;

var
  frm_Principal: Tfrm_Principal;

implementation

{$R *.dfm}

uses Funcoes, frmDataModulo, untClasseItemProduto;

procedure Tfrm_Principal.ActionBuscarClientesExecute(Sender: TObject);
var
    LocString: String;
begin
  LocString := '';
  pvtIDCliente := AbrirClientes(pvtIDNovaVenda, LocString);
  if pvtIDCliente <> 0 then
  begin
    edNomeCliente.Text := LocString;
  end;
end;

procedure Tfrm_Principal.ActionBuscarProdutosExecute(Sender: TObject);
begin
  AbrirBuscarProdutos(pvtIDNovaVenda, pvtNovaVenda);
end;

procedure Tfrm_Principal.ActionCancelaVendaExecute(Sender: TObject);
begin
  if pvtIDNovaVenda = 0 then
  begin
    MessageDlg('Sem venda Iniciada',mtConfirmation,[mbOK], 0);
    Exit;
  end;

  if MessageDlg('Deseja Cancelar a venda?',mtConfirmation,[mbYes, mbNO], 0) = 6 then
  begin
    if not pvtNovaVenda.Clear() then
    begin
      MessageDlg('Erro ao Cancelar Venda',mtConfirmation,[mbOK], 0);
      Exit;
    end;
    pvtIDNovaVenda := pvtNovaVenda.getNumeroPedido();
    LimparEditsTela();
    cdsProdutos.Close();
  end;

  edProduto.SetFocus();
end;

procedure Tfrm_Principal.ActionConsultarVendasExecute(Sender: TObject);
begin
  if pvtIDNovaVenda <> 0 then
  begin
    MessageDlg('Favor finalizar a venda!',mtConfirmation,[mbOK], 0);
    Exit;
  end;

  GridItemVenda.DataSource := nil;
  IniciarConsultarVendas();
  dmPrincipal.qrItemVenda.close();
  GridItemVenda.DataSource := dmPrincipal.dsItemVenda;
end;

procedure Tfrm_Principal.ActionFinalizarVendaExecute(Sender: TObject);
begin
  if pvtIDNovaVenda = 0 then
  begin
    MessageDlg('Venda n�o iniciada',mtConfirmation,[mbOK], 0);
    edProduto.SetFocus();
    Exit;
  end;

  if (pvtNovaVenda.getValorTotal = 0) then
  begin
    MessageDlg('Favor adicionar itens a venda',mtConfirmation,[mbOK], 0);
    edProduto.SetFocus();
    Exit;
  end;

  if pvtNovaVenda.Gravar() then
  begin
    MessageDlg('Erro ao Fnalizar Venda',mtConfirmation,[mbOK], 0);
    Exit();
  end;
  LimparEditsTela();
  pvtIDNovaVenda := 0;

  edProduto.SetFocus();
end;


procedure Tfrm_Principal.ActionNovaVendaExecute(Sender: TObject);
begin
  if pvtIDNovaVenda = 0 then
  begin
    pvtNovaVenda.Iniciar();
    pvtIDNovaVenda := pvtNovaVenda.getNumeroPedido;
    AtualizarEditsTela();
    lbVendaIniciada.Visible := true;
  end
  else
    MessageDlg('Venda j� iniciada',mtConfirmation,[mbOK], 0);
  edProduto.SetFocus();
end;

procedure Tfrm_Principal.ActionSairExecute(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_Principal.AtualizarEditsTela();
begin
  tbNumeroVenda.Text     := IntToStr(pvtNovaVenda.getNumeroPedido());
  tbDataVenda.Text       := DateToStr(pvtNovaVenda.getDataEmissao());
  tbValorTotal.Text      := FormatFloat('#0.00',pvtNovaVenda.getValorTotal());
  tbQuantidadeItens.Text := FormatFloat('#0.000',pvtNovaVenda.getQuantidadeItens());
end;

function Tfrm_Principal.CriarDataSet: Boolean;
var
  FProv: TProvider;
begin
  cdsProdutos := TClientDataSet.Create(nil);
  FProv := TProvider.Create(nil);
  FProv.Options:=[poAllowCommandText];
  cdsProdutos.SetProvider(FProv);
  cdsProdutos.FieldDefs.Clear();
  //cdsProdutos.FieldDefs.Add()
end;

procedure Tfrm_Principal.edProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  //Passando para a quantidade com enter
  if (key = 13) and (edProduto.Text = '') then
  begin
    edQuantidade.SetFocus();
    Exit;
  end;

  if edQuantidade.Text = '' then
  begin
    MessageDlg('Favor digitar a quantidade!',mtConfirmation,[mbOK], 0);
    edQuantidade.SetFocus();
    Exit;
  end;

  if not IsDouble(edQuantidade.Text) then
  begin
    MessageDlg('Favor digitar uma quantidade v�lida!',mtConfirmation,[mbOK], 0);
    edQuantidade.SetFocus();
    Exit();
  end;

  if (key = 13) and (edProduto.Text <> '') then
  begin
    if pvtIDNovaVenda = 0 then
      ActionNovaVendaExecute(nil);

    if pvtNovaVenda.ADDProdutoVenda(edProduto.Text, pvtIDNovaVenda, StrToFloat(edQuantidade.Text)) then
    begin
      AtualizarEditsTela();
      PreencherDataset();
      edProduto.Clear();
      edQuantidade.Text := '1';
    end;
    edProduto.SetFocus();
  end;
end;

procedure Tfrm_Principal.edQuantidadeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Passando para a quantidade
  if (key = 13) then
  begin
    if (edProduto.Text = '') then
    begin
      edProduto.SetFocus();
    end
    else
    begin
      edProdutoKeyDown(Self, key, Shift);
    end;
  end;
end;

procedure Tfrm_Principal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if pvtIDNovaVenda > 0 then
  begin
    MessageDlg('Venda iniciada, favor cancelar antes de sair!',mtConfirmation,[mbOK], 0);
    Action := caNone;
    Exit;
  end;

  if MessageDlg('Deseja Sair?',mtConfirmation,[mbYes,mbNo], 0) = 7 then
  begin
    Action := caNone;
  end;
end;

procedure Tfrm_Principal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    113: ActionNovaVendaExecute(nil); //F2
    114: ActionCancelaVendaExecute(nil); //F3
    115: ActionBuscarProdutosExecute(nil); //F4
    116: ActionBuscarClientesExecute(nil); //F5
    117: ActionConsultarVendasExecute(nil); //F6
    121: ActionFinalizarVendaExecute(nil); //F10
    123: ActionSairExecute(nil); //F12
  end;
end;

procedure Tfrm_Principal.FormResize(Sender: TObject);
begin
  //DimensionarGrid(GridItemVenda);
end;

procedure Tfrm_Principal.FormShow(Sender: TObject);
begin
  ConfigurarFrmPrincipal();
  pvtIDNovaVenda := 0;
  pvtNovaVenda := TVenda.Create();
  edQuantidade.Text := '1';
  edProduto.SetFocus();
end;

procedure Tfrm_Principal.LimparEditsTela;
var i: Integer;
begin
  //Contador que verifica todos os componentes do Form
  for i := 0 to ComponentCount -1 do
  begin
      //Verifica se o objeto � do tipo TEdit
      if (Components[i] is TEdit) then
          (Components[i] as TEdit).Clear;
  end;
  edQuantidade.Text := '1';
  lbVendaIniciada.Visible := false;
end;

procedure Tfrm_Principal.PreencherDataset();
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  PropriedadeNome, ProppriedadeCodigoProduto, PropriedadeQuantidade,
  PropriedadePrecoVenda, PropriedadeValorTotalItem: TRttiProperty;
  ItemPedido: TItemPedido;
begin
  // Cria o contexto do RTTI
  Contexto := TRttiContext.Create;
  try
    //cdsProdutos := TClientDataSet.Create(nil);
    if cdsProdutos.Active then
       cdsProdutos.Close();

    cdsProdutos.FieldDefs.Clear();
    cdsProdutos.FieldDefs.Add('CodigoProduto', ftString, 100);
    cdsProdutos.FieldDefs.Add('Descricao', ftString, 200);
    cdsProdutos.FieldDefs.Add('PrecoVenda', ftString, 200);
    cdsProdutos.FieldDefs.Add('Quantidade', ftString, 200);
    cdsProdutos.FieldDefs.Add('ValorTotalItem', ftString, 200);
    cdsProdutos.CreateDataSet;

    cdsProdutos.Active := true;

    // Obt�m as informa��es de RTTI da classe TItemPedido
    Tipo := Contexto.GetType(TItemPedido.ClassInfo);

    // Obt�m um objeto referente � propriedade "Nome" da classe TFuncionario
    PropriedadeNome := Tipo.GetProperty('Nome');
    ProppriedadeCodigoProduto := Tipo.GetProperty('CodigoProduto');
    PropriedadePrecoVenda := Tipo.GetProperty('PrecoVenda');
    PropriedadeQuantidade := Tipo.GetProperty('Quantidade');
    PropriedadeValorTotalItem := Tipo.GetProperty('ValorTotalItem');


    // Percorre a lista de objetos, inserindo o valor da propriedade "Nome" do ClientDataSet
    for ItemPedido in pvtNovaVenda.getProdutos() do
    begin
      cdsProdutos.AppendRecord([
                   ProppriedadeCodigoProduto.GetValue(ItemPedido).AsInteger,
                   PropriedadeNome.GetValue(ItemPedido).AsString,
                   PropriedadePrecoVenda.GetValue(ItemPedido).AsCurrency,
                   PropriedadeQuantidade.GetValue(ItemPedido).AsCurrency,
                   PropriedadeValorTotalItem.GetValue(ItemPedido).AsCurrency
                   ]);
    end;

    cdsProdutos.Last;
  finally
    Contexto.Free;
  end;
end;

end.
