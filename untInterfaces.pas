unit untInterfaces;

interface

uses frmDataModulo, untClasseItemProduto, System.Generics.Collections;

  //INICIO DAS INTERFACES

  //Interface de Cliente

  type
    ICliente = Interface

      function BuscarCliente(prmNome: String; prmCriarDM: Boolean = false): Boolean;
      function Clear():Boolean;
      function SalvarCliente(prmNome, prmCidade, prmUF: String; prmCriarDM: Boolean = False): Boolean;

    End;
  //Interface Item Pedido
  type
    IItemProduto = Interface
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

    End;

  //Inteface de Produto
  type
    IProduto = Interface

      function getCodigoProduto(): Integer;
      function getDescricao(): String;
      function getPrecoVenda(): Double;

      procedure setCodigoProduto(prmCodigoProduto: Integer);
      procedure setDescricao(prmDescricao: String);
      procedure setPrecoVenda(prmPrecoVenda: Double);

      function Clear(): Boolean;
      function CodigoBarrasExiste(prmCodigoProduto: String;
                prmCriarDM: Boolean = false): Boolean;
      function SalvarProduto(prmNomeProduto, prmPrecoUnitario: String;
                prmCriarDM: Boolean = False): Boolean;
    End;

  //Inteface de Venda
  type
    IVenda = interface
    ['{165CE3E4-56DE-4A66-B9D4-3836A467569B}']
      function getCodigoCliente(): Integer;
      function getDataEmissao(): TDateTime;
      function getNumeroPedido(): Integer;
      function getQuantidadeItens(): Double;
      function getValorTotal(): Double;
      function getProdutos(): TList<TItemPedido>;

      procedure setCodigoCliente(prmCodigoCliente: Integer);
      procedure setDataEmissao(prmDataEmissao: TDateTime);
      procedure setNumeroPedido(prmNumeroPedido: Integer);
      procedure setQuantidadeItens(prmQuantidadeItens: Double);
      procedure setValorTotal(prmValorTotal: Double);

      //Funções
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




end.
