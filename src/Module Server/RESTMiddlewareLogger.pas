unit RESTMiddlewareLogger;

interface

uses
  InterfaceRESTMiddlewareLogger, MiniREST.Intf;

type
  TRESTMiddlewareLogger = class(TInterfacedObject, IRESTMiddlewareLogger, IMiniRESTMiddleware)
  private
    FLogger : IMiniRESTLogger;
  public
  //TODO przerobiæ, jak kernel bedzie wspiera³ interfejsy w konstruktorach
//    constructor Create(const ALogger : IMiniRESTLogger);
    function Process(AActionContext : IMiniRESTActionContext) : Boolean;
    procedure SetLogger(ALogger : IMiniRESTLogger);
    property Logger: IMiniRESTLogger write SetLogger;
  end;

implementation

uses
  MiniREST.Common;

{ TRESTMiddlewareLogger }

//constructor TRESTMiddlewareLogger.Create(const ALogger : IMiniRESTLogger);
//begin
//  FLogger := ALogger;
//end;

function TRESTMiddlewareLogger.Process(
  AActionContext: IMiniRESTActionContext): Boolean;
const
  cCookie = 'sessionId';
begin
  FLogger.Debug(AActionContext.GetURI);
  FLogger.Debug(cCookie + ': ' + AActionContext.GetCookieValue(cCookie));
  if AActionContext.GetCommandType = rmPost then
    FLogger.Debug(AActionContext.GetRequestContentAsString);
  Result := true;
end;

procedure TRESTMiddlewareLogger.SetLogger(ALogger: IMiniRESTLogger);
begin
  FLogger := ALogger;
end;

end.
