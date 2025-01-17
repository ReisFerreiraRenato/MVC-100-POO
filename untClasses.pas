unit untClasses;

//Classes baseadas em micro servi�os
interface

uses untInterfaces, frmDataModulo, SysUtils, vcl.Dialogs, FireDAC.Comp.Client,
    System.Generics.Collections, untClasseItemProduto;

type

  //Classe Cliente
  TCliente = class(TInterfacedObject, ICliente)
    private
       FCodigoCliente: Integer;
       FNome: String;
       FCidade: String;
       FUF: String;
    public
      //Gets
      function getCodigoCliente(): Integer;
      function getNome(): String;
      function getCidade(): String;
      function getUF(): String;

      //Sets
      procedure setCodigoCliente(prmCodigoCliente: Integer);
      procedure setNome(prmNome: String);
      procedure setCidade(prmCidade: String);
      procedure setUF(prmUF: String);

      //Fun��es
      function BuscarCliente(prmNome: String; prmCriarDM: Boolean = false): Boolean;
      function Clear():Boolean;
      function SalvarCliente(prmNome, prmCidade, prmUF: String; prmCriarDM: Boolean = False): Boolean;
  end;
  {
  //Classe ItemPedido
  TItemPedido = class(TInterfacedObject, IItemProduto)
    private
      FCodigoProduto  : Integer;
      FDescricao      : String;
      FPrecoVenda     : Double;
      FQuantidade     : Double;
      FValorTotalItem : Double;
    public
      //Gets
      function getCodigoProduto(): Integer;
      function getDescricao(): String;
      function getPrecoVenda(): Double;
      function getQuantidade(): Double;
      function getValorTotalItem(): Double;
      //Sets
      procedure setCodigoProduto(prmCodigoProduto: Integer);
      procedure setDescricao(prmDescricao: String);
      procedure setPrecoVenda(prmPrecoVenda: Double);
      procedure setQuantidade(prmQuantidade: Double);
      procedure setValorTotalItem(prmValorTotalItem: Double);
  end;
  }
  //Classe Produto
  TProduto = class(TInterfacedObject, IProduto)
    private
      FCodigoProduto : Integer;
      FDescricao     : String;
      FPrecoVenda    : Double;

    public
      //Gets
      function getCodigoProduto(): Integer;
      function getDescricao(): String;
      function getPrecoVenda(): Double;
      //Sets
      procedure setCodigoProduto(prmCodigoProduto: Integer);
      procedure setDescricao(prmDescricao: String);
      procedure setPrecoVenda(prmPrecoVenda: Double);

      function Clear(): Boolean;
      function CodigoBarrasExiste(prmCodigoProduto: String; prmCriarDM: Boolean = false): Boolean;
      function SalvarProduto(prmNomeProduto, prmPrecoUnitario: String;
                prmCriarDM: Boolean = False): Boolean;
  end;

  //Classe Venda
  TVenda = class(TInterfacedObject, IVenda)
    private
     FCodigoCliente: Integer;
     FDataEmissao: TDateTime;
     FNumeroPedido: Integer;
     FValorTotal: Double;
     FQuantidadeItens: Double;
     FProdutos: TList<TItemPedido>;

    public

      //Gets
      function getCodigoCliente(): Integer;
      function getDataEmissao(): TDateTime;
      function getNumeroPedido(): Integer;
      function getValorTotal(): Double;
      function getQuantidadeItens(): Double;
      function getProdutos(): Tlist<TItemPedido>;

      //Sets
      procedure setCodigoCliente(prmCodigoCliente: Integer);
      procedure setDataEmissao(prmDataEmissao: TDateTime);
      procedure setNumeroPedido(prmNumeroPedido: Integer);
      procedure setQuantidadeItens(prmQuantidadeItens: Double);
      procedure setValorTotal(prmValorTotal: Double);

      Constructor Create(prmCriarDM: Boolean = False);

      //Fun��es
      function ADDProdutoVenda(prmProduto: String; prmIDVenda: Integer;
                  prmQuantidade: Double; prmCriarDM: Boolean = False): Boolean;
      function AdicionarProdutoVendaPorID(prmIDProduto, prmIDVenda: Integer;
                prmQuantidade, prmValorUnitario: Double; prmDescricao: String;
                prmCriarDM: Boolean = False): Boolean;
      function AdicionarProdutoVendaPorCodBarras(prmCodBarras: String;
                prmIDVenda: Integer; prmQuantidade: Double;
                prmCriarDM: Boolean = False): Boolean;
      function Clear(): Boolean;
      function Gravar(prmCriarDM: Boolean = False): Boolean;
      function Iniciar(prmCriarDM: Boolean = False): Boolean;
      function VendaGravada(prmCriarDM: Boolean = False): Boolean;
  end;

implementation

uses Funcoes, frmProduto;

{ TVenda }

function TVenda.ADDProdutoVenda(prmProduto: String; prmIDVenda: Integer;
  prmQuantidade: Double; prmCriarDM: Boolean): Boolean;
begin
  Result := False;
  if IsDouble(prmProduto) then
  begin
    Result := AdicionarProdutoVendaPorCodBarras(prmProduto, prmIDVenda, prmQuantidade, prmCriarDM);
    if not result then
      MessageDlg('Produto n�o encontrado!',mtConfirmation,[mbOK], 0);
  end
  else
  begin
    try
      frmProdutos                   := TfrmProdutos.Create(nil);
      frmProdutos.pbcNovaVenda      := self;
      frmProdutos.tbNome.Text       := prmProduto;
      frmProdutos.tbQuantidade.Text := FloatToStr(prmQuantidade);
      frmProdutos.ShowModal();
      Result := true;
    finally
      FreeAndNil(frmProdutos);
    end;
  end;
end;

function TVenda.AdicionarProdutoVendaPorCodBarras(prmCodBarras: String;
  prmIDVenda: Integer; prmQuantidade: Double; prmCriarDM: Boolean): Boolean;
var
  LocScript: String;
begin
  Result := False;
  try
    if prmCriarDM then
      dmPrincipal := TdmPrincipal.Create(nil);
    //Buscando o produto pelo codigo de barras
    LocScript := 'SELECT * FROM Produto WHERE CodigoProduto = ' + prmCodBarras;
    dmPrincipal.qrProduto.Close();
    dmPrincipal.qrProduto.SQL.Clear();
    dmPrincipal.qrProduto.SQL.Text := LocScript;
    dmPrincipal.qrProduto.Open();

    //Se o produto n�o foi encontrado, sai da fun��o
    if dmPrincipal.qrProduto.FieldByName('CodigoProduto').AsInteger = 0 then
      Exit();

    Result := AdicionarProdutoVendaPorID(
        dmPrincipal.qrProduto.FieldByName('CodigoProduto').AsInteger,
        prmIDVenda,prmQuantidade,
        dmPrincipal.qrProduto.FieldByName('PrecoVenda').AsFloat,
        dmPrincipal.qrProduto.FieldByName('Descricao').AsString,
        prmCriarDM);

    if prmCriarDM then
      FreeAndNil(dmPrincipal);

  Except on Exception do
    raise Exception.Create('Erro ao adicionar Produto por c�digo de barras');
  end;
end;

function TVenda.AdicionarProdutoVendaPorID(prmIDProduto, prmIDVenda: Integer;
  prmQuantidade, prmValorUnitario: Double; prmDescricao: String; prmCriarDM: Boolean): Boolean;
var
  LocProduto: TItemPedido;
begin
  Result := False;
  try
    if prmCriarDM then
      dmPrincipal := TdmPrincipal.Create(nil);

    //Criando o produto e atribu�ndo os valores
    LocProduto := TItemPedido.Create();
    LocProduto.setCodigoProduto(prmIDProduto);
    LocProduto.setDescricao(prmDescricao);
    LocProduto.setPrecoVenda(prmValorUnitario);
    LocProduto.setQuantidade(prmQuantidade);
    LocProduto.setValorTotalItem(prmValorUnitario * prmQuantidade);

    //Adicionando a lista de produtos
    Self.FProdutos.Add(LocProduto);

    //Atualizando a Qtd de itens e Valor Total da venda
    Self.setValorTotal(Self.getValorTotal+LocProduto.getValorTotalItem);
    Self.setQuantidadeItens(Self.getQuantidadeItens+1);

    Result := true;

    if prmCriarDM then
      FreeAndNil(dmPrincipal);

  except on Exception do
    begin
      if prmCriarDM then
        FreeAndNil(dmPrincipal);
      raise Exception.Create('Erro ao adicionar produto por ID');
    end;
  end;
end;

function TVenda.Clear: Boolean;
begin
  Self.FNumeroPedido    := 0;
  Self.FCodigoCliente   := 0;
  Self.FDataEmissao     := 0;
  Self.FValorTotal      := 0;
  Self.FQuantidadeItens := 0;
  Self.FProdutos.Clear();
  Result := True;
end;

constructor TVenda.Create(prmCriarDM: Boolean = False);
begin
  Self.FNumeroPedido    := 0;
  Self.FCodigoCliente   := 0;
  Self.FDataEmissao     := 0;
  Self.FValorTotal      := 0;
  Self.FQuantidadeItens := 0;
  Self.FProdutos := TList<TItemPedido>.Create();
end;

function TVenda.Iniciar(prmCriarDM: Boolean): Boolean;
var
  LocQuery : TFDQuery;
begin
  try
    //Criando DataModulo para testes
    if prmCriarDM then
      dmPrincipal := TdmPrincipal.Create(nil);

    LocQuery := TFDQuery.Create(nil);
    LocQuery.Connection := dmPrincipal.ConexaoPrincipal;
    LocQuery.SQL.Text := 'SELECT MAX(NumeroPedido) Dado FROM VENDA';
    LocQuery.Open();

    Self.setNumeroPedido(LocQuery.FieldByName('Dado').AsInteger+1);
    Self.setCodigoCliente(0);
    Self.setDataEmissao(date);
    Self.setValorTotal(0);
    Self.setQuantidadeItens(0);
    Self.FProdutos.Clear();

    //Destru�ndo Objetos Criados
    FreeAndNil(LocQuery);
    //Destrunido DataModulo para testes
    if prmCriarDM then
      FreeAndNil(dmPrincipal);
  Except on Exception do
    begin
      //Destru�ndo Objetos Criados
      FreeAndNil(LocQuery);
      //Destrunido DataModulo para testes
      if prmCriarDM then
        FreeAndNil(dmPrincipal);
      raise Exception.Create('Erro ao criar venda');
    end;
  end;
end;

function TVenda.getCodigoCliente: Integer;
begin
  result:= Self.FCodigoCliente;
end;

function TVenda.getDataEmissao: TDateTime;
begin
  result := Self.FDataEmissao;
end;

function TVenda.getNumeroPedido: Integer;
begin
  result := Self.FNumeroPedido;
end;

function TVenda.getProdutos: Tlist<TItemPedido>;
begin
  result := Self.FProdutos;
end;

function TVenda.getQuantidadeItens: Double;
begin
  result := Self.FQuantidadeItens;
end;

function TVenda.getValorTotal: Double;
begin
  result := Self.FValorTotal;
end;

function TVenda.Gravar(prmCriarDM: Boolean = False): Boolean;
var
  LocQuery: TFDQuery;
  LocCodigoCliente: String;
begin
  Result := False;
  try
    //Criando DataModulo para testes
    if prmCriarDM then
      dmPrincipal := TdmPrincipal.Create(nil);

    //Criando a query
    LocQuery := TFDQuery.Create(nil);
    //Conectando
    LocQuery.Connection := dmPrincipal.ConexaoPrincipal;
    //SQL da query
    LocQuery.SQL.Clear();

    if Self.getCodigoCliente = 0 then
      LocCodigoCliente := 'Null'
    else
      LocCodigoCliente := IntToStr(Self.getCodigoCliente);

    LocQuery.SQL.Text := 'INSERT INTO VENDA (NumeroPedido, DataEmissao, CodigoCliente, ValorTotal) '+
                         ' VALUES( '+IntToStr(Self.getNumeroPedido) + ', ' +
                         QuotedStr(DateTimeToStr(Self.getDataEmissao)) + ', ' +
                         LocCodigoCliente + ', ' +
                         FloatToStr(Self.getValorTotal) + ')';
    LocQuery.ExecSQL();
    result := LocQuery.RowsAffected > 0;


    //Destru�ndo Objetos Criados
    FreeAndNil(LocQuery);
    //Destrunido DataModulo para testes
    if prmCriarDM then
      FreeAndNil(dmPrincipal);
  Except on Exception do
    begin
      //Destru�ndo Objetos Criados
        FreeAndNil(LocQuery);
      //Destrunido DataModulo para testes
      if prmCriarDM then
        FreeAndNil(dmPrincipal);
      raise Exception.Create('Erro ao gravar venda');
    end;
  end;
end;

procedure TVenda.setCodigoCliente(prmCodigoCliente: Integer);
begin
  FCodigoCliente := prmCodigoCliente;
end;

procedure TVenda.setDataEmissao(prmDataEmissao: TDateTime);
begin
  FDataEmissao := prmDataEmissao;
end;

procedure TVenda.setNumeroPedido(prmNumeroPedido: Integer);
begin
  FNumeroPedido := prmNumeroPedido;
end;

procedure TVenda.setQuantidadeItens(prmQuantidadeItens: Double);
begin
  FQuantidadeItens := prmQuantidadeItens;
end;

procedure TVenda.setValorTotal(prmValorTotal: Double);
begin
  FValorTotal := prmValorTotal;
end;

function TVenda.VendaGravada(prmCriarDM: Boolean = False): Boolean;
var
  LocQuery: TFDQuery;
begin
  try
    if prmCriarDM then
      dmPrincipal := TdmPrincipal.Create(nil);
    LocQuery := TFDQuery.Create(nil);
    LocQuery.Connection := dmPrincipal.ConexaoPrincipal;
    LocQuery.SQL.Text := 'SELECT NumeroPedido FROM Venda WHERE NumeroPedido = '
                                  + IntToStr(self.getNumeroPedido);
    LocQuery.Open();

    Result := LocQuery.FieldByName('NumeroPedido').AsInteger = Self.getNumeroPedido;

    FreeAndNil(LocQuery);
    if prmCriarDM then
      FreeAndNil(dmPrincipal);
  except on Exception do
    begin
      FreeAndNil(LocQuery);
      if prmCriarDM then
        FreeAndNil(dmPrincipal);
      raise Exception.Create('Erro ao consultar c�digo de barras!');
    end;
  end;
end;

{ TProduto }

function TProduto.Clear: Boolean;
begin
  FCodigoProduto := 0;
  FDescricao     := '';
  FPrecoVenda    := 0;
end;

function TProduto.CodigoBarrasExiste(prmCodigoProduto: String;
  prmCriarDM: Boolean = false): Boolean;
var
  LocQuery: TFDQuery;
begin
  try
    if prmCriarDM then
      dmPrincipal := TdmPrincipal.Create(nil);
    LocQuery := TFDQuery.Create(nil);
    LocQuery.Connection := dmPrincipal.ConexaoPrincipal;

    LocQuery.SQL.Text := 'SELECT Descricao FROM Produto WHERE CodigoProduto = ' + prmCodigoProduto;

    LocQuery.Open();

    result := LocQuery.FieldByName('Descricao').AsString = '';

    FreeAndNil(LocQuery);
    if prmCriarDM then
      FreeAndNil(dmPrincipal);
  except on Exception do
    begin
      FreeAndNil(LocQuery);
      if prmCriarDM then
        FreeAndNil(dmPrincipal);
      raise Exception.Create('Erro ao consultar c�digo de barras!');
    end;
  end;
end;

function TProduto.getCodigoProduto: Integer;
begin
  result := Self.FCodigoProduto;
end;

function TProduto.getDescricao: String;
begin
  result := Self.FDescricao;
end;

function TProduto.getPrecoVenda: Double;
begin
  result := Self.FPrecoVenda;
end;

function TProduto.SalvarProduto(prmNomeProduto, prmPrecoUnitario: String;
  prmCriarDM: Boolean): Boolean;
begin
  Result := False;
  try
    if prmCriarDM then
      dmPrincipal := TdmPrincipal.Create(nil);

    dmPrincipal.qrProduto.Close();
    dmPrincipal.qrProduto.Open();
    dmPrincipal.qrProduto.Insert();
    dmPrincipal.qrProduto.FieldByName('Descricao').AsString := prmNomeProduto;
    dmPrincipal.qrProduto.FieldByName('PrecoVenda').AsFloat := StrToFloat(prmPrecoUnitario);
    dmPrincipal.qrProduto.Post();
    Result := True;
    if prmCriarDM then
      FreeAndNil(dmPrincipal);
  except on Exception do
    raise Exception.Create('Error Ao Cadastrar Produto!');
  end;
end;

procedure TProduto.setCodigoProduto(prmCodigoProduto: Integer);
begin
  Self.FCodigoProduto := prmCodigoProduto;
end;

procedure TProduto.setDescricao(prmDescricao: String);
begin
  Self.FDescricao := prmDescricao;
end;

procedure TProduto.setPrecoVenda(prmPrecoVenda: Double);
begin
  Self.FPrecoVenda := prmPrecoVenda;
end;

{ TCliente }

function TCliente.BuscarCliente(prmNome: String; prmCriarDM: Boolean): Boolean;
var
  LocScript: String;
begin
  Result := False;
  try
    if prmCriarDM then
      dmPrincipal := TdmPrincipal.Create(nil);

    dmPrincipal.qrCliente.Close;

    LocScript := 'SELECT * FROM `Cliente` WHERE `Nome` LIKE '+ QuotedStr(prmNome+'%') +'ORDER BY Nome' ;

    dmPrincipal.qrCliente.Sql.Clear();
    dmPrincipal.qrCliente.SQL.Text := LocScript;
    dmPrincipal.qrCliente.Open();

    Self.FCodigoCliente := dmPrincipal.qrCliente.FieldByName('CodigoCliente').AsInteger;
    Self.FNome          := dmPrincipal.qrCliente.FieldByName('Nome').AsString;
    Self.FCidade        := dmPrincipal.qrCliente.FieldByName('Cidade').AsString;
    Self.FUF            := dmPrincipal.qrCliente.FieldByName('UF').AsString;

    Result := True;

    if prmCriarDM then
      FreeAndNil(dmPrincipal);

  Except on Exception do
    begin
      if prmCriarDM then
        FreeAndNil(dmPrincipal);
      raise Exception.Create('Erro ao buscar cliente por nome');
    end;
  end;
end;

function TCliente.Clear: Boolean;
begin
  Self.FCodigoCliente := 0;
  Self.FNome := '';
  Self.FCidade := '';
  Self.FUF := '';
end;

function TCliente.getCidade: String;
begin
  result := Self.FCidade;
end;

function TCliente.getCodigoCliente: Integer;
begin
  result := Self.FCodigoCliente;
end;

function TCliente.getNome: String;
begin
  result := Self.FNome;
end;

function TCliente.getUF: String;
begin
  result := Self.FUF;
end;

function TCliente.SalvarCliente(prmNome, prmCidade, prmUF: String; prmCriarDM: Boolean): Boolean;
begin
  Result := False;
  try
    //Atribuindo os valores a classe
    Self.setNome(prmNome);
    Self.setCidade(prmCidade);
    Self.setUF(prmUF);

    if prmCriarDM then
      dmPrincipal := TdmPrincipal.Create(nil);

    //Granvando no banco de dados
    dmPrincipal.qrCliente.Close();
    dmPrincipal.qrCliente.Open();
    dmPrincipal.qrCliente.Insert();
    dmPrincipal.qrCliente.FieldByName('Nome').AsString := Self.getNome;
    dmPrincipal.qrCliente.FieldByName('Cidade').AsString := Self.getCidade;
    dmPrincipal.qrCliente.FieldByName('UF').AsString := Self.getUF;
    dmPrincipal.qrCliente.Post();
    if prmCriarDM then
      FreeAndNil(dmPrincipal);
    Result := True;
  except on Exception do
    begin
      if prmCriarDM then
        FreeAndNil(dmPrincipal);
      raise Exception.Create('Erro ao adicionar Cliente');
    end;
  end;
end;

procedure TCliente.setCidade(prmCidade: String);
begin
  Self.FCidade := prmCidade;
end;

procedure TCliente.setCodigoCliente(prmCodigoCliente: Integer);
begin
  Self.FCodigoCliente := prmCodigoCliente;
end;

procedure TCliente.setNome(prmNome: String);
begin
  Self.FNome := prmNome;
end;

procedure TCliente.setUF(prmUF: String);
begin
  Self.FUF := prmUF;
end;


(*
{ TItemPedido }

function TItemPedido.getCodigoProduto: Integer;
begin
  Result := Self.FCodigoProduto;
end;

function TItemPedido.getDescricao: String;
begin
  Result := Self.FDescricao
end;

function TItemPedido.getPrecoVenda: Double;
begin
  Result := Self.FPrecoVenda;
end;

function TItemPedido.getQuantidade: Double;
begin
  Result := Self.FQuantidade;
end;

function TItemPedido.getValorTotalItem: Double;
begin
  Result := Self.FValorTotalItem
end;

procedure TItemPedido.setCodigoProduto(prmCodigoProduto: Integer);
begin
  Self.FCodigoProduto := prmCodigoProduto;
end;

procedure TItemPedido.setDescricao(prmDescricao: String);
begin
  Self.FDescricao := prmDescricao;
end;

procedure TItemPedido.setPrecoVenda(prmPrecoVenda: Double);
begin
  Self.FPrecoVenda := prmPrecoVenda;
end;

procedure TItemPedido.setQuantidade(prmQuantidade: Double);
begin
  Self.FQuantidade := prmQuantidade;
end;

procedure TItemPedido.setValorTotalItem(prmValorTotalItem: Double);
begin
  Self.FValorTotalItem := prmValorTotalItem;
end;
 *)
end.
