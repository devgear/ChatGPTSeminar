
// Get your API Key:
// https://beta.openai.com/account/api-keys

unit DelphiChatGPT;

interface

function AskChatGPT(const aApiKey, aQuestion: string): string;

implementation

uses
  System.Generics.Collections,
  System.SysUtils,
  System.Classes,
  System.Net.HttpClient,
  System.Net.Mime,
  System.JSON,
  FMX.Dialogs;

function AskChatGPT(const aApiKey, aQuestion: string): string;
var
  LHttpClient: THTTPClient;
  LString: string;
  LJson: TJsonObject;
  LResponse: IHTTPResponse;
  LPostdata: string;
  LPostDataStream: TStringStream;
begin

  Result := '';

  LPostData := '{' +
    '"model": "text-davinci-003",'+
    '"prompt": "' + aQuestion + '",'+
    '"max_tokens": 2048,'+
    '"temperature": 0'+
    '}';

  LPostDataStream := TStringStream.Create(LPostData, TEncoding.UTF8);
  try
    LHttpClient := THTTPClient.Create;
    try
      LHttpClient.CustomHeaders['Authorization'] := 'Bearer ' + aApiKey;
      LHttpClient.CustomHeaders['Content-Type'] := 'application/json';

      LPostDataStream.Position := 0;
      LResponse := LHttpClient.Post('https://api.openai.com/v1/completions', LPostDataStream);

      if LResponse.StatusCode = 200 then
        begin
          LString := LResponse.ContentAsString;
          LJson := TJSONObject.ParseJSONValue(LString) as TJSONObject;
          try
            ShowMessage( 'success');
            Result := LJson.GetValue('choices').A[0].FindValue('text').Value;
          finally
            LJson.Free;
          end;
        end
      else
        begin
          Result := 'HTTP response code: ' + LResponse.StatusCode.ToString
        end;
    finally
      LHttpClient.Free;
    end;
  finally
    LPostDataStream.Free;
  end;
end;

end.