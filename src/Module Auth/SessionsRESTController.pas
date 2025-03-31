unit SessionsRESTController;

interface
uses
  MiniREST.Attribute, MiniREST.Common, MiniREST.Intf,
  SessionsRESTObjects, SessionsEntities, MiniREST.ControllerOtherwise.Intf, RESTControllerBase;

const
  cMappingLogin = '/login';
  cMappingLogout = '/logout';

  SESSION_COOKIE_NAME = 'sessionId';

type
  TMappingIndex = (miLogin, miLogout);

  TSessionsRESTController = class(TRESTControllerBase, IMiniRESTControllerOtherwise)
  private
    procedure CreateSession;
    procedure Logout;
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
  try
    InitController;
  //  if AContext.ActionInfo.RequestMethod = rmPost then
      SetActionContext(AContext);
    SetLogger(MainKernel.GiveObjectByInterface(IMiniRESTLogger) as IMiniRESTLogger);

    case IndexStr(AContext.GetURI, [cMappingLogin, cMappingLogout]) of
      Integer(miLogin):
        CreateSession;
      Integer(miLogout):
        Logout;
    else
      exit;
    end;
  except
    on E : Exception do
    begin
      ResponseErro(E.Message);
      GetLogger.Exception('[TSessionsRESTController.Action]', E);
    end;
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
      var pomCookie := TMiniRESTCookie.Create(SESSION_COOKIE_NAME, pomDTOResponse.SessionID);
      try
        GetActionContext.SetCookie(pomCookie);
        ResponseStatus('Authorized');
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

procedure TSessionsRESTController.Logout;
begin
  var pomController := (MainKernel.GiveObjectByInterface(ISessionsController) as ISessionsController);
  pomController.Logout(GetActionContext.GetCookieValue(SESSION_COOKIE_NAME));
  var pomCookie := GetActionContext.GetCookie(SESSION_COOKIE_NAME);
  try
    if Assigned(pomCookie) then
    begin
      pomCookie.Expires := Now - 1;
      GetActionContext.SetCookie(pomCookie);
    end;
  finally
    pomCookie.Free;
  end;
  ResponseStatus('Logout');
end;

end.
