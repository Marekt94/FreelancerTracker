unit ModuleAuth;

interface

uses
  Module, InterfaceModuleAuth, MiniREST.Controller.Security.Intf;

type
  TModuleAuth = class(TBaseModule, IModuleAuth)
  private
    FSecurityController : IMiniRESTSecurityController;
  public
    function GetSelfInterface : TGUID; override;
    procedure RegisterClasses; override;
    function OpenModule : boolean; override;
  end;

implementation

uses
  InterfaceKernel, MiniREST.Server.Intf, SessionsRepository, SessionsRESTController,
  UsersRepository, SessionsController, InterfaceUsersRepository, InterfaceSessionsRepository,
  InterfaceSessionsController, SecurityController;

{ TModuleAuth }

function TModuleAuth.GetSelfInterface: TGUID;
begin
  Result := IModuleAuth;
end;

function TModuleAuth.OpenModule: boolean;
begin
  Result := inherited;
  if Result then
  begin
    var pomServer := (MainKernel.GiveObjectByInterface(IMiniRESTServer) as IMiniRESTServer);
    FSecurityController := TSecurityController.Create;
    pomServer.SetControllerOtherwise(TSessionsRESTController);
    pomServer.SetSecurityController(
      function () : IMiniRESTSecurityController
      begin
        Result := FSecurityController;
      end);
  end;
end;

procedure TModuleAuth.RegisterClasses;
begin
  inherited;
  RegisterClass(ISessionsController, TSessionsController);
  RegisterClass(IUsersRepository, TUsersRepository);
  RegisterClass(ISessionsRepository, TSessionsRepository);
end;

end.
