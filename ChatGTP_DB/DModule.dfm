object MyDModule: TMyDModule
  Height = 480
  Width = 640
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 472
    Top = 128
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    FetchOptions.AssignedValues = [evMode, evRowsetSize]
    SQL.Strings = (
      '')
    Left = 368
    Top = 128
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=mydb'
      'DriverID=MySQL'
      'Password=1234'
      'Server=127.0.0.1'
      'User_Name=user_id'
      'CharacterSet=utf8')
    FetchOptions.AssignedValues = [evMode]
    LoginPrompt = False
    Left = 264
    Top = 128
  end
end
