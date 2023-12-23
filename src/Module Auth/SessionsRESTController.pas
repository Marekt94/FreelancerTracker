unit SessionsRESTController;

interface
uses
  MiniREST.Attribute, MiniREST.Common, MiniREST.Controller.Base, MiniREST.Intf,
  SessionsRESTObjects, SessionsEntities, MiniREST.ControllerOtherwise.Intf;

const
  cMappingLogin = '/login';

type
  TMappingIndex = (miLogin);

  TSessionsRESTController = class(TMiniRESTControllerBase, IMiniRESTControllerOtherwise)
  private
    procedure CreateSession;
  public
    procedure Action(AContext : IMiniRESTActionContext);
  end;

implementation

uses
  UsersEntities, InterfaceSessionsController, InterfaceKernel,
  InterfaceUsersRepository, InterfaceSessionsRepository, RESTObjects, System.SysUtils,
  System.StrUtils;

{ TSessionsRESTController }

procedure TSessionsRESTController.Action(AContext: IMiniRESTActionContext);
begin
  case IndexStr(AContext.GetURI, [cMappingLogin]) of
    Integer(miLogin):
    begin
      InitController;
      SetActionContext(AContext);
      SetLogger(MainKernel.GiveObjectByInterface(IMiniRESTLogger) as IMiniRESTLogger);
      CreateSession;
    end
  else
    exit;
  end;
end;

procedure TSessionsRESTController.CreateSession;
var
  pomController : ISessionsController;
begin
  pomController := (MainKernel.GiveObjectByInterface(ISessionsController) as ISessionsController);
  var pomSessionRESTObjects := TRESTObject<TUsersDTORequest, TSessionDTOResponse>.Create(GetActionContext.GetRequestContentAsString,
    procedure (const p_Request : TUsersDTORequest; var p_Response : TSessionDTOResponse; out p_ErrorMessage : string)
    begin
      pomController.Execute(p_Request, p_Response, p_ErrorMessage);
    end);
  try
    var pomDTOResponse := pomSessionRESTObjects.DTOResponse;

    if Trim(pomSessionRESTObjects.ErrorMessage) = '' then
    begin
      var pomCookie := TMiniRESTCookie.Create('sessionId', pomDTOResponse.SessionID);
      try
        GetActionContext.SetCookie(pomCookie);
        ResponseJson('Authorized');
      finally
        pomCookie.Free;
      end;
    end
    else
      ResponseErro(pomSessionRESTObjects.ErrorMessage, 401);
  finally
    pomSessionRESTObjects.Free;
  end;
end;

end.
