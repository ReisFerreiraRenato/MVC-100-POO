object dmPrincipal: TdmPrincipal
  OldCreateOrder = False
  Height = 446
  Width = 456
  object ConexaoPrincipal: TFDConnection
    Params.Strings = (
      'Database=teste'
      'User_Name=root'
      'DriverID=MySQL')
    Connected = True
    LoginPrompt = False
    Left = 48
    Top = 96
  end
  object qrVenda: TFDQuery
    Connection = ConexaoPrincipal
    SQL.Strings = (
      'Select * from venda where ID=:prmID')
    Left = 48
    Top = 152
    ParamData = <
      item
        Name = 'PRMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = -1
      end>
  end
  object dsVenda: TDataSource
    DataSet = qrVenda
    Left = 112
    Top = 152
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'D:\Testes\ProjetoInfotec\libmysql.dll'
    Left = 248
    Top = 40
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 248
    Top = 96
  end
  object qrItemVenda: TFDQuery
    Connection = ConexaoPrincipal
    SQL.Strings = (
      'SELECT * FROM ItemVenda IV'
      'INNER JOIN produto P ON IV.CodigoProduto = P.CodigoProduto'
      ' WHERE IV.NumeroPedido = :NumeroPedido'
      'ORDER BY IV.NumeroPedido')
    Left = 48
    Top = 216
    ParamData = <
      item
        Name = 'NUMEROPEDIDO'
        DataType = ftInteger
        ParamType = ptInput
        Value = -1
      end>
  end
  object dsItemVenda: TDataSource
    DataSet = qrItemVenda
    Left = 128
    Top = 216
  end
  object qrCliente: TFDQuery
    Connection = ConexaoPrincipal
    SQL.Strings = (
      'SELECT * FROM CLIENTE')
    Left = 48
    Top = 272
  end
  object dsCliente: TDataSource
    DataSet = qrCliente
    Left = 128
    Top = 272
  end
  object qrProduto: TFDQuery
    Connection = ConexaoPrincipal
    SQL.Strings = (
      'SELECT * FROM PRODUTO ORDER BY Descricao')
    Left = 48
    Top = 328
  end
  object dsProduto: TDataSource
    DataSet = qrProduto
    Left = 120
    Top = 328
  end
  object qrUtilidade: TFDQuery
    Connection = ConexaoPrincipal
    SQL.Strings = (
      'SELECT * FROM VENDA')
    Left = 232
    Top = 320
  end
  object udqrVenda: TFDUpdateSQL
    Connection = ConexaoPrincipal
    InsertSQL.Strings = (
      
        'INSERT INTO `venda`(`ID`, `DataVenda`, `ValorTotal`, `IDCliente`' +
        ', `DataEntrega`, `QuantidadeItens`, `StatusVenda`) VALUES ('#39'[val' +
        'ue-1]'#39','#39'[value-2]'#39','#39'[value-3]'#39','#39'[value-4]'#39','#39'[value-5]'#39','#39'[value-6' +
        ']'#39','#39'[value-7]'#39')')
    ModifySQL.Strings = (
      
        'UPDATE `venda` SET `ID`='#39'[value-1]'#39',`DataVenda`='#39'[value-2]'#39',`Val' +
        'orTotal`='#39'[value-3]'#39',`IDCliente`='#39'[value-4]'#39',`DataEntrega`='#39'[val' +
        'ue-5]'#39',`QuantidadeItens`='#39'[value-6]'#39',`StatusVenda`='#39'[value-7]'#39' W' +
        'HERE 1')
    DeleteSQL.Strings = (
      'DELETE FROM VENDA WHERE ID=:prmID')
    Left = 232
    Top = 160
  end
  object dsConsultarVenda: TDataSource
    DataSet = qrConsultarVenda
    Left = 144
    Top = 392
  end
  object qrConsultarVenda: TFDQuery
    Connection = ConexaoPrincipal
    SQL.Strings = (
      
        'SELECT V.NumeroPedido, V.DataEmissao, V.ValorTotal, C.Nome FROM ' +
        '`Venda` V'
      'LEFT JOIN `Cliente` C ON V.CodigoCliente = C.CodigoCliente'
      'WHERE V.DataEmissao = :prmData')
    Left = 48
    Top = 392
    ParamData = <
      item
        Name = 'PRMDATA'
        DataType = ftDate
        ParamType = ptInput
        Value = 44500d
      end>
  end
end
