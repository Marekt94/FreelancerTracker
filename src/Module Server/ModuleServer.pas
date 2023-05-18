unit ModuleServer;

interface

uses
  Module, InterfaceModuleServer, MiniREST.Server.Intf;

type
  TModuleServer = class(TBaseModule, IModuleServer)
  strict private
    FServer : IMiniRESTServer;
  public
    function GetSelfInterface : TGUID; override;
    function OpenMainWindow : Integer; override;
    procedure RegisterClasses; override;
    function GiveObjectByInterface (p_GUID : TGUID) : IInterface; override;
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

function TModuleServer.GiveObjectByInterface(p_GUID: TGUID): IInterface;
begin
  if p_GUID = IMiniRESTServer then
  begin
    if not Assigned (FServer) then
      FServer := inherited GiveObjectByInterface(p_GUID) as IMiniRESTServer;

    Result := FServer;
  end
  else
    Result := inherited GiveObjectByInterface(p_GUID);
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
    FServer.SetPort(8080);
    FServer.Start;
  end;
end;

procedure TModuleServer.RegisterClasses;
begin
  RegisterClass(IMiniRESTServer, TMiniRESTServerIndy);
end;

end.
