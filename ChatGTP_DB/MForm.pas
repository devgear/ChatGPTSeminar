unit MForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.JSON,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, Vcl.ComCtrls, Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    BT_QueryExe: TButton;
    NetHTTPClient1: TNetHTTPClient;
    BT_ChatGPTAsk: TButton;
    Memo_Ans: TMemo;
    Memo_Def: TMemo;
    ET_Ask: TEdit;
    ListView1: TListView;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure BT_QueryExeClick(Sender: TObject);
    procedure BT_ChatGPTAskClick(Sender: TObject);
    procedure NetHTTPClient1RequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
    procedure ListView1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  Const MyGPTKey = 'My_Key_1234';

implementation

Uses
  DModule;

{$R *.dfm}

procedure TForm1.BT_QueryExeClick(Sender: TObject);
begin
  MyDModule.FDQuery1.SQL.Clear;
  MyDModule.FDQuery1.SQL.Add( Memo_Ans.Lines.Text );
  MyDModule.FDQuery1.Active := TRUE;
end;


procedure TForm1.ListView1Click(Sender: TObject);
begin
  if ListView1.SelCount > 0 then
     ET_Ask.Text :=  ListView1.Items[ ListView1.Selected.Index ].Caption;
end;

procedure TForm1.BT_ChatGPTAskClick(Sender: TObject);
var
  i : integer;
  qStr : string;

  LPostdata: string;
  LPostDataStream: TStringStream;
begin
  qStr := '';
  for i := 0 to Memo_Def.Lines.Count - 1 do
      qStr := qStr + Memo_Def.Lines [ i ] ;

  qStr := qStr + ET_Ask.Text;


  LPostData := '{' +
    '"model": "text-davinci-003",'+
    '"prompt": "' +  qStr + '",'+
    '"max_tokens": 2048,'+
    '"temperature": 0'+
    '}';
  LPostDataStream := TStringStream.Create( LPostData, TEncoding.UTF8);
  NetHTTPClient1.CustomHeaders['Authorization'] := 'Bearer ' + MyGPTKey;
  NetHTTPClient1.CustomHeaders['Content-Type'] := 'application/json';
  LPostDataStream.Position := 0;
  NetHTTPClient1.Post('https://api.openai.com/v1/completions', LPostDataStream );
end;


procedure TForm1.NetHTTPClient1RequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
var
  LString, ansStr : string;
  LJson: TJsonObject;

begin
  PageControl1.TabIndex := 2;

  if AResponse.StatusCode = 200 then
  begin
     LString := AResponse.ContentAsString;
     LJson := TJSONObject.ParseJSONValue(LString) as TJSONObject;
     try
       ansStr := LJson.GetValue('choices').A[0].FindValue('text').Value;
     finally
       LJson.Free;
     end;
  end
  else
  begin
    ansStr := 'HTTP response code: ' + AResponse.StatusCode.ToString;
    Exit;
  end;

  Memo_Ans.Lines.Clear;
  Memo_Ans.Lines.Add( ansStr );

  BT_QueryExeClick( Sender );
end;


end.
