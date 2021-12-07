unit frmDataModulo;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Comp.UI, FireDAC.Phys.MySQL, Datasnap.DBClient, Datasnap.Provider;

type
  TdmPrincipal = class(TDataModule)
    ConexaoPrincipal: TFDConnection;
    qrVenda: TFDQuery;
    dsVenda: TDataSource;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    qrItemVenda: TFDQuery;
    dsItemVenda: TDataSource;
    qrCliente: TFDQuery;
    dsCliente: TDataSource;
    qrProduto: TFDQuery;
    dsProduto: TDataSource;
    qrProdutoID: TFDAutoIncField;
    qrProdutoNomeProduto: TStringField;
    qrProdutoDataCadastro: TDateField;
    qrProdutoPrecoUnitario: TFloatField;
    qrProdutoDataAtualizacao: TDateField;
    qrProdutoValCompra: TFloatField;
    qrProdutoCodBarras: TLargeintField;
    qrUtilidade: TFDQuery;
    udqrVenda: TFDUpdateSQL;
    dsConsultarVenda: TDataSource;
    qrConsultarVenda: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmPrincipal: TdmPrincipal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
