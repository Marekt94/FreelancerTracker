unit SecurityController;

interface

uses
  MiniREST.Controller.Security.Intf, MiniREST.Intf;

type
  TSecurityController = class(TInterfacedObject, IMiniRESTSecurityController)
    function HasPermission(AContext : IMiniRESTActionContext) : IMiniRESTSecurityResponse;
  end;

implementation

uses
  InterfaceSessionsRepository, InterfaceKernel, MiniREST.Security.Base;

{ TSecurityController }

function TSecurityController.HasPermission(
  AContext: IMiniRESTActionContext): IMiniRESTSecurityResponse;
begin
  var pomRepo := (MainKernel.GiveObjectByInterface(ISessionsRepository) as ISessionsRepository);
  var pomSessionId := AContext.GetCookieValue('sessionId');
  var pomRes := pomRepo.GetValidSession(pomSessionId);
  if pomRes then
    Result := TMiniRESTSecurityResponse.Create(true, '')
  else
    Result := TMiniRESTSecurityResponse.Create(false, 'Unauthorized');
end;

end.
