unit RESTMiddlewareCustomHeaderController;

interface

uses
  InterfaceRESTMiddlewareCustomHeaderController, MiniREST.Intf;

type
  TRESTMiddlewareCustomHeaderController = class(TInterfacedObject, IRESTMiddlewareCustomHeaderController, IMiniRESTMiddleware)
  strict private
    FProtocol : string;
    FAllowedOrigin : string;
    FLogger: IMiniRESTLogger;
  public
    constructor Create;
    procedure SetProtocol(const AProtocol : TRESTProtocol);
    function GetProtocol : TRESTProtocol;
    function Process(AActionContext : IMiniRESTActionContext) : Boolean;
    function GetAllowedOrigin : string;
    procedure SetAllowedOrigin(const AObj : string);
    procedure SetLogger(ALogger : IMiniRESTLogger);
  end;

implementation

uses
  System.StrUtils, System.SysUtils;

const
  cHTTP  = 'http://';
  cHTTPS = 'https://';

{ TRESTMiddlewareCustomHeaderController }

constructor TRESTMiddlewareCustomHeaderController.Create;
begin
  FProtocol := 'http://';
  FAllowedOrigin := '*';
end;

function TRESTMiddlewareCustomHeaderController.GetAllowedOrigin: string;
begin
  Result := FAllowedOrigin;
end;

function TRESTMiddlewareCustomHeaderController.GetProtocol: TRESTProtocol;
begin
  case IndexStr(FProtocol, [cHttp, cHttps]) of
    0: Result := rpHTTP;
    1: Result := rpHTTPS;
  else
    raise Exception.Create('Protokó³ nieobs³ugiwany');
  end;
end;

function TRESTMiddlewareCustomHeaderController.Process(
  AActionContext: IMiniRESTActionContext): Boolean;
begin
  AActionContext.AppendHeader('Access-Control-Allow-Origin', FAllowedOrigin);
  AActionContext.AppendHeader('Access-Control-Allow-Credentials', 'true');
  AActionContext.AppendHeader('Access-Control-Allow-Methods','POST, GET, DELETE');
  AActionContext.AppendHeader('Access-Control-Allow-Headers','Content-Type, Accept');
  AActionContext.AppendHeader('Access-Control-Allow-Private-Network','true');
  Result := true;
end;

procedure TRESTMiddlewareCustomHeaderController.SetAllowedOrigin(
  const AObj: string);
begin
  if Trim(AObj) = '*' then
    FAllowedOrigin := AObj
  else
    if     not AObj.StartsWith(cHTTP)
       and not AObj.StartsWith(cHTTPS)
    then
      FAllowedOrigin := FProtocol + AObj
    else
      FAllowedOrigin := AObj;

  if Assigned(FLogger) then
    FLogger.Info('Allow-origin: ' + FAllowedOrigin);
end;

procedure TRESTMiddlewareCustomHeaderController.SetLogger(
  ALogger: IMiniRESTLogger);
begin
  FLogger := ALogger;
end;

procedure TRESTMiddlewareCustomHeaderController.SetProtocol(
  const AProtocol: TRESTProtocol);
begin
  case AProtocol of
    rpHTTP:  FProtocol := cHTTP;
    rpHTTPS: FProtocol := cHTTPS;
  end;
end;

end.
