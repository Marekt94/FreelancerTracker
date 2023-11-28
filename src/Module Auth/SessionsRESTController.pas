unit SessionsRESTController;

interface
uses
  MiniREST.Attribute, MiniREST.Common, MiniREST.Controller.Base, MiniREST.Intf;

type
  TSessionsRESTController = class(TMiniRESTControllerBase)
    [RequestMapping('/login')]
    procedure CreateSession;
  end;

implementation

uses
  UsersEntities, SessionsRESTObjects, InterfaceSessionsController, InterfaceKernel,
  InterfaceUsersRepository, SessionsEntities;

{ TSessionsRESTController }

procedure TSessionsRESTController.CreateSession;
var
  pomContoller : ISessionsController;
  pomUsersRepo : IUsersRepository;
  pomSession   : TSession;
begin
  var pom := GetActionContext.GetRequestContentAsString;
  var pomUser := TUsersRESTObject.Create(pom);
  try
    pomUsersRepo := (MainKernel.GiveObjectByInterface(IUsersRepository) as IUsersRepository);
    if pomUsersRepo.IsUserExists(pomUser.Entity.UserName, pomUser.Entity.Password) then
    begin
      pomContoller := (MainKernel.GiveObjectByInterface(ISessionsController) as ISessionsController);
      pomSession := TSession.Create;
      try
        pomSession.User := pomUser.Entity;
        pomSession.Session := pomContoller.CreateSession;
      finally
        pomSession.Free;
      end;
    end
    else
      ResponseErro('Unauthorized', 401)
  finally
    pomUser.Free;
  end;
end;

end.
