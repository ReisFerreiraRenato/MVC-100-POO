unit Funcoes;

interface

uses SysUtils, Vcl.Forms, Data.DB, Vcl.Grids, Vcl.DBGrids, vcl.Dialogs,
    untInterfaces;

procedure AbrirCadastroProdutos();

procedure AbrirBuscarProdutos(prmIDVenda: Integer; prmVenda: IVenda);

procedure BuscarProdutoNome(prmNome: String);

procedure IniciarConsultarVendas();

procedure DimensionarGrid(dbg: TDBGrid);

function AbrirClientes(prmIDVenda: Integer; var prmNomeCliente: String):Integer;

function BuscarCliente(prmNome: String): Boolean;

function ConfigurarFrmPrincipal(): Boolean;

function ConsultarVenda(prmNumeroVenda, prmData: String): Boolean;

function FormatarDataSQL(prmData: TDateTime):String;

function IsDouble(prmValor: String): Boolean;

function IsDate(prmData: String): Boolean;

implementation

uses frmDataModulo, IniFiles, frmCadastrarProduto, frmCliente, frmProduto,
  frmConsultarVenda;

//Funcao para abrir cadastro de produtos
procedure AbrirCadastroProdutos();
begin
  try
    frmCadastrarProdutos := TfrmCadastrarProdutos.Create(nil);
    frmCadastrarProdutos.ShowModal();
  finally
    FreeAndNil(frmCadastrarProdutos);
  end;
end;

//Funcao para abrir a busca de produtos
procedure AbrirBuscarProdutos(prmIDVenda: Integer; prmVenda: IVenda);
begin
  try
    frmProdutos:= TfrmProdutos.Create(nil);
    frmProdutos.pbcNovaVenda := prmVenda;
    frmProdutos.ShowModal();
  finally
    FreeAndNil(frmProdutos);
  end;
end;

//Funcao para abrir o frmCliente
function AbrirClientes(prmIDVenda: Integer; var prmNomeCliente: String):Integer;
begin
  result := -1;
  try
    frmClientes:= TfrmClientes.Create(nil);
    frmClientes.pbcIDVenda := prmIDVenda;
    frmClientes.ShowModal();
    result := frmClientes.pbcIDCliente;
    if result <> 0 then
      prmNomeCliente := dmPrincipal.qrCliente.FieldByName('Nome').AsString;
  finally
    FreeAndNil(frmClientes);
  end;
end;

//Buscar o produto pelo nome
procedure BuscarProdutoNome(prmNome: String);
var
  LocScript: String;
begin
  try
    dmPrincipal.qrProduto.Close();

    LocScript := 'SELECT * FROM `Produto` WHERE UPPER(Descricao) LIKE '
                    + QuotedStr(UpperCase(prmNome)+'%') +' ORDER BY Descricao' ;

    dmPrincipal.qrProduto.Sql.Clear();
    dmPrincipal.qrProduto.SQL.Text := LocScript;
    dmPrincipal.qrProduto.Open();
  Except on Exception do
    raise Exception.Create('Erro ao buscar produto por nome');
  end;
end;

//Buscar Cliente pelo Nome
function BuscarCliente(prmNome: String): Boolean;
var
  LocScript: String;
begin
  Result := False;
  try

    dmPrincipal.qrCliente.Close;

    LocScript := 'SELECT * FROM `Cliente` WHERE `Nome` LIKE '+ QuotedStr(prmNome+'%') +'ORDER BY Nome' ;

    dmPrincipal.qrCliente.Sql.Clear();
    dmPrincipal.qrCliente.SQL.Text := LocScript;
    dmPrincipal.qrCliente.Open();

    Result := True;
  Except on Exception do
    raise Exception.Create('Erro ao buscar cliente por nome');
  end;
end;

//Configurar FrmPrincipal
function ConfigurarFrmPrincipal(): Boolean;
begin
  dmPrincipal.qrVenda.Close();
  dmPrincipal.qrCliente.Close();
  dmPrincipal.qrItemVenda.Close();
end;

//Cosnultar Vendas
function ConsultarVenda(prmNumeroVenda, prmData: String): Boolean;
var
  LocStringData, LocStringNumeroVenda, LocScript: String;
begin
  Result := False;
  try
    LocStringData        := '';
    LocStringNumeroVenda := '';

    if prmData <> '' then
      LocStringData := ' AND V.DataEmissao = ' + QuotedStr(FormatarDataSQL(StrToDate(prmData)));

    if prmNumeroVenda <> '' then
      LocStringNumeroVenda := ' AND V.NumeroVenda = '+prmNumeroVenda;

    LocScript :=
      'SELECT V.NumeroPedido, V.CodigoCliente, V.DataEmissao, V.ValorTotal, ' +
      ' C.Nome FROM `Venda` V ' +
      ' LEFT JOIN `Cliente` C ON V.CodigoCliente = C.CodigoCliente ' +
      ' WHERE 1 ' + LocStringData + LocStringNumeroVenda;

    dmPrincipal.qrConsultarVenda.Close();
    dmPrincipal.qrConsultarVenda.SQL.Text := LocScript;
    dmPrincipal.qrConsultarVenda.Open();

    result := dmPrincipal.qrConsultarVenda.RecordCount <> 0;
  Except on Exception do
    raise Exception.Create('Error ao Consultar Vendas!');
  end;
end;

//Abrir Consultar venda
procedure IniciarConsultarVendas();
begin
  try
    frmConsultarVendas:= TfrmConsultarVendas.Create(nil);
    frmConsultarVendas.ShowModal;
  finally
    FreeAndNil(frmConsultarVendas);
  end;
end;

function FormatarDataSQL(prmData: TDateTime):String;
begin
  Result := DateTimeToStr(prmData);
  Result := Result[7]+Result[8]+Result[9]+Result[10]+'-'+Result[4]+Result[5]+'-'+Result[1]+Result[2];
end;

//Dimensionar a grid
procedure DimensionarGrid(dbg: TDBGrid);
type
  TArray = Array of Integer;
  procedure AjustarColumns(Swidth, TSize: Integer; Asize: TArray);
  var
    idx: Integer;
  begin
    if TSize = 0 then
    begin
      TSize := dbg.Columns.count;
      for idx := 0 to dbg.Columns.count - 1 do
        dbg.Columns[idx].Width := (dbg.Width - dbg.Canvas.TextWidth('AAAAAA')
          ) div TSize
    end
    else
      for idx := 0 to dbg.Columns.count - 1 do
        dbg.Columns[idx].Width := dbg.Columns[idx].Width +
          (Swidth * Asize[idx] div TSize);
  end;

var
  idx, Twidth, TSize, Swidth: Integer;
  AWidth: TArray;
  Asize: TArray;
  NomeColuna: String;
begin
  SetLength(AWidth, dbg.Columns.count);
  SetLength(Asize, dbg.Columns.count);
  Twidth := 0;
  TSize := 0;
  for idx := 0 to dbg.Columns.count - 1 do
  begin
    NomeColuna := dbg.Columns[idx].Title.Caption;
    dbg.Columns[idx].Width := dbg.Canvas.TextWidth
      (dbg.Columns[idx].Title.Caption + 'A');
    AWidth[idx] := dbg.Columns[idx].Width;
    Twidth := Twidth + AWidth[idx];

    if Assigned(dbg.Columns[idx].Field) then
      Asize[idx] := dbg.Columns[idx].Field.Size
    else
      Asize[idx] := dbg.Columns[idx].Width;

    TSize := TSize + Asize[idx];
  end;
  if TDBGridOption.dgColLines in dbg.Options then
    Twidth := Twidth + dbg.Columns.count;

  // adiciona a largura da coluna indicada do cursor
  if TDBGridOption.dgIndicator in dbg.Options then
    Twidth := Twidth + IndicatorWidth;

  Swidth := dbg.ClientWidth - Twidth;
  AjustarColumns(Swidth, TSize, Asize);
end;

//Verifica se o valor passado � double
function IsDouble(prmValor: String): Boolean;
var
  locValor: String;
begin
  LocValor := prmValor;
  LocValor := LocValor.Replace('.','');
  try
    StrToFloat(LocValor);
    Result:= true;
  except
    Result:=false;
  end;
end;

function IsDate(prmData: String): Boolean;
var
  LocData: String;
begin
  LocData := prmData;
  //LocData := LocData.Replace('.','');
  try
    StrToDate(LocData);
    Result:= true;
  except
    Result:=false;
  end;
end;

end.
