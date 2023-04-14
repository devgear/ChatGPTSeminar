unit MainCGPT;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.JSON,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types, FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Memo,  FMX.Layouts, System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TMForm = class(TForm)
    Memo_Ans: TMemo;
    Memo_HanQ: TMemo;
    BT_Question: TButton;
    NetHTTPClient1: TNetHTTPClient;
    Label1: TLabel;
    Label3: TLabel;
    Layout1: TLayout;
    Layout3: TLayout;
    SpeedButton1: TSpeedButton;
    BT_TEST: TButton;
    procedure BT_QuestionClick(Sender: TObject);
    procedure NetHTTPClient1RequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
    procedure Memo_HanQDblClick(Sender: TObject);
    procedure BT_TESTClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MForm: TMForm;

  // ChatGPT 개인키 받는곳 :  https://beta.openai.com/account/api-keys
  Const MyGPTKey = 'MY_KEY_12345';

  // https://platform.openai.com/docs/api-reference/introduction

implementation


{$R *.fmx}


procedure TMForm.BT_TESTClick(Sender: TObject);
var
  LPostdata: string;
  LPostDataStream: TStringStream;
begin
  LPostData := '{' +
    '"prompt": "' + Memo_HanQ.Text + '",'+
    '"n": 2,'+
    '"size": "1024x1024"'+
    '}';
  LPostDataStream := TStringStream.Create( LPostData, TEncoding.UTF8);

  NetHTTPClient1.CustomHeaders['Authorization'] := 'Bearer ' + MyGPTKey;
  NetHTTPClient1.CustomHeaders['Content-Type'] := 'application/json';

  LPostDataStream.Position := 0;
  NetHTTPClient1.Post('https://api.openai.com/v1/images/generations', LPostDataStream );
end;

//*******************************************************************
procedure TMForm.Memo_HanQDblClick(Sender: TObject);
begin
  Memo_HanQ.Lines.Clear;
end;


//*******************************************************************
procedure TMForm.BT_QuestionClick(Sender: TObject);
var
  LPostdata: string;
  LPostDataStream: TStringStream;
begin
  LPostData := '{' +
    '"model": "text-davinci-003",'+
    '"prompt": "' + Memo_HanQ.Text + '",'+
    '"max_tokens": 2048,'+
    '"temperature": 0'+
    '}';

  LPostDataStream := TStringStream.Create( LPostData, TEncoding.UTF8);

  NetHTTPClient1.CustomHeaders['Authorization'] := 'Bearer ' + MyGPTKey;
  NetHTTPClient1.CustomHeaders['Content-Type'] := 'application/json';

  LPostDataStream.Position := 0;
  NetHTTPClient1.Post('https://api.openai.com/v1/completions', LPostDataStream );
end;

//********************************************************************************************************
procedure TMForm.NetHTTPClient1RequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
var
  LString, ansStr : string;
  LJson: TJsonObject;
begin
//  Memo_Ans.Lines.Clear;
//  Memo_Ans.Lines.Add( AResponse.ContentAsString );

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
    ansStr := 'HTTP response code: ' + AResponse.StatusCode.ToString;
  Memo_Ans.Lines.Clear;
  Memo_Ans.Lines.Add( ansStr );

end;


end.
