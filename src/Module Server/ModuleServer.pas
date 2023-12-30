unit ModuleServer;

interface

uses
  Module, InterfaceModuleServer, MiniREST.Server.Intf, RESTLogger, MiniREST.Intf;

type
  TModuleServer = class(TBaseModule, IModuleServer)
  strict private
    FServer : IMiniRESTServer;
    procedure AddMiddleware(const AMiddleware : array of TGUID); overload;
    function AddMiddleware(const AMiddleware : IInterface) : boolean; overload;
  public
    function GetSelfInterface : TGUID; override;
    procedure RegisterClasses; override;
    function OpenModule : boolean; override;
    function CloseModule : boolean; override;
  end;

implementation

uses
  System.SysUtils, MiniREST.Indy, InterfaceKernel, InterfaceRESTMiddlewareWhiteListController,
  InterfaceRESTMiddlewareLogger, InterfaceRESTMiddlewareCustomHeaderController,
  RESTMiddlewareWhiteListController, RESTMiddlewareLogger, RESTMiddlewareCustomHeaderController;

{ TModuleServer }

procedure TModuleServer.AddMiddleware(const AMiddleware : array of TGUID);
begin
  for var pomMiddlewareIntf in AMiddleware do
  begin
    var pomMiddleware := GiveObjectByInterface(pomMiddlewareIntf);
    AddMiddleware(pomMiddleware);
  end;
end;

function TModuleServer.AddMiddleware(const AMiddleware: IInterface): boolean;
var
  pomObj : IMiniRESTMiddleware;
begin
  result := Supports(AMiddleware, IMiniRESTMiddleware, pomObj);
  if Result then
    FServer.AddMiddleware(pomObj)
  else
    raise Exception.Create('Middleware does not support server middleware interface');
end;

function TModuleServer.CloseModule: boolean;
begin
  Result := FServer.Stop and inherited CloseModule;
end;

function TModuleServer.GetSelfInterface: TGUID;
begin
  Result := IModuleServer;
end;

function TModuleServer.OpenModule: boolean;
begin
  Result := inherited;
  if Result then
  begin
    var pomLogger := GiveObjectByInterface(IMiniRESTLogger) as IMiniRESTLogger;
    FServer := GiveObjectByInterface(IMiniRESTServer) as IMiniRESTServer;
    FServer.SetPort(8080);
    FServer.Start;
    FServer.SetLogger(pomLogger);
    FServer.GetLogger.Info('Start serwera');
    AddMiddleware([IRESTMiddlewareWhiteListController, IRESTMiddlewareCustomHeaderController]);
    var pomObj := GiveObjectByInterface(IRESTMiddlewareLogger) as IRESTMiddlewareLogger;
    pomObj.Logger := pomLogger;
    AddMiddleware(pomObj);
  end;
end;

procedure TModuleServer.RegisterClasses;
begin
  RegisterClassForSigleton(IMiniRESTServer, TMiniRESTServerIndy, []);
  RegisterClassForSigleton(IMiniRESTLogger, TRESTLoggger, []);
  RegisterClass(IRESTMiddlewareWhiteListController, TRESTMiddlewareWhiteListController, []);
  RegisterClass(IRESTMiddlewareCustomHeaderController, TRESTMiddlewareCustomHeaderController, []);
  RegisterClass(IRESTMiddlewareLogger, TRESTMiddlewareLogger, []);
end;

end.
