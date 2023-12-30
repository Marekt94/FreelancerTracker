unit ModuleServer;

interface

uses
  Module, InterfaceModuleServer, MiniREST.Server.Intf, RESTLogger, MiniREST.Intf;

type
  TModuleServer = class(TBaseModule, IModuleServer)
  strict private
    FServer : IMiniRESTServer;
  public
    function GetSelfInterface : TGUID; override;
    function OpenMainWindow : Integer; override;
    procedure RegisterClasses; override;
    function OpenModule : boolean; override;
    function CloseModule : boolean; override;
  end;

implementation

uses
  MiniREST.Indy, InterfaceKernel;

{ TModuleServer }

function TModuleServer.CloseModule: boolean;
begin
  Result := FServer.Stop and inherited CloseModule;
end;

function TModuleServer.GetSelfInterface: TGUID;
begin
  Result := IModuleServer;
end;

function TModuleServer.OpenMainWindow: Integer;
begin
  Result := inherited;
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
  end;
end;

procedure TModuleServer.RegisterClasses;
begin
  RegisterClassForSigleton(IMiniRESTServer, TMiniRESTServerIndy, []);
  RegisterClassForSigleton(IMiniRESTLogger, TRESTLoggger, []);
end;

end.
