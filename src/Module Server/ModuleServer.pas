unit ModuleServer;

interface

uses
  Module, InterfaceModuleServer;

type
  TModuleServer = class(TBaseModule, IModuleServer)
  public
    function GetSelfInterface : TGUID; override;
    function OpenMainWindow : Integer; override;
    procedure RegisterClasses; override;
  end;

implementation

uses
  MiniREST.Indy, MiniREST.Server.Intf;

{ TModuleServer }

function TModuleServer.GetSelfInterface: TGUID;
begin
  Result := IModuleServer;
end;

function TModuleServer.OpenMainWindow: Integer;
begin
  Result := inherited;
end;

procedure TModuleServer.RegisterClasses;
begin
  RegisterClass(IMiniRESTServer, TMiniRESTServerIndy);
end;

end.
