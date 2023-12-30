unit RESTControllerWithLogging;

interface

uses
  MiniREST.Controller.Base, MiniREST.Common;

type
  TRESTControllerWithLogging = class(TMiniRESTControllerBase)
  public
    procedure ResponseJson(AJson: string; AStatusCode : Integer = 200); reintroduce;
    procedure ResponseStatus(p_StatusText : string);
  end;

implementation

uses
  System.SysUtils;

{ TRESTControllerWithLogging }

procedure TRESTControllerWithLogging.ResponseJson(AJson: string;
  AStatusCode: Integer);
begin
  {$IFDEF DEBUG}
  GetLogger.Debug(GetActionContext.GetURI);
  if GetActionContext.GetCommandType = rmPost then
    GetLogger.Debug(GetActionContext.GetRequestContentAsString);
  {$ENDIF}
  GetActionContext.AppendHeader('Access-Control-Allow-Origin', 'http://localhost:*');
  GetActionContext.AppendHeader('Access-Control-Allow-Credentials', 'true');
  GetActionContext.AppendHeader('Access-Control-Allow-Methods','POST, GET, DELETE');
  GetActionContext.AppendHeader('Access-Control-Allow-Headers','Content-Type, Accept');
  inherited ResponseJson(AJson, AStatusCode);
end;


procedure TRESTControllerWithLogging.ResponseStatus(p_StatusText : string);
const
  cStatusJSON = '{"status": "%s"}';
begin
  ResponseJson(Format(cStatusJSON, [p_StatusText]));
end;

end.
