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
    function GetModuleName : string; override;
  end;

implementation

uses
  System.SysUtils, MiniREST.Indy, MiniREST.Indy.WithSSL, InterfaceKernel, InterfaceRESTMiddlewareWhiteListController,
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

function TModuleServer.GetModuleName: string;
begin
  Result := 'Module Server';
end;

function TModuleServer.GetSelfInterface: TGUID;
begin
  Result := IModuleServer;
end;

function TModuleServer.OpenModule: boolean;
var
  pomSSL : ISSL;
  pomSecured : boolean;
begin
  Result := inherited;
  if Result then
  begin
    FServer := GiveObjectByInterface(IMiniRESTServer) as IMiniRESTServer;

    pomSecured := StrToBool(GetPreference('secured', '0'));
    var pomLogger := GiveObjectByInterface(IMiniRESTLogger) as IMiniRESTLogger;

    AddMiddleware([IRESTMiddlewareWhiteListController]);
    var pomMidLogger := GiveObjectByInterface(IRESTMiddlewareLogger) as IRESTMiddlewareLogger;
    pomMidLogger.Logger := pomLogger;
    AddMiddleware(pomMidLogger);
    var pomMidHeader := GiveObjectByInterface(IRESTMiddlewareCustomHeaderController) as IRESTMiddlewareCustomHeaderController;
    pomMidHeader.Protocol := TRESTProtocol(pomSecured);
    AddMiddleware(pomMidHeader);

    if pomSecured and Supports(FServer, ISSL, pomSSL) then
    begin
      pomSSL.Secured  := pomSecured;
      pomSSL.CertPath := GetPreference('cert');
      pomSSL.KeyPath  := GetPreference('key');
    end;

    FServer.SetPort(StrToInt(GetPreference('port', '8080')));
    FServer.SetLogger(pomLogger);
    FServer.GetLogger.Info('Start serwera');
    FServer.Start;
  end;
end;

procedure TModuleServer.RegisterClasses;
begin
  RegisterClassForSigleton(IMiniRESTServer, TMiniRESTServerIndyWithSSL, []);
  RegisterClassForSigleton(IMiniRESTLogger, TRESTLoggger, []);
  RegisterClass(IRESTMiddlewareWhiteListController, TRESTMiddlewareWhiteListController, []);
  RegisterClass(IRESTMiddlewareCustomHeaderController, TRESTMiddlewareCustomHeaderController, []);
  RegisterClass(IRESTMiddlewareLogger, TRESTMiddlewareLogger, []);
end;

end.
