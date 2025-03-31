unit RESTControllerBase;

interface

uses
  MiniREST.Controller.Base, MiniREST.Common;

const
  SESSION_ID_COOKIE = 'sessionId';

type
  TRESTControllerBase = class(TMiniRESTControllerBase)
  public
    procedure ResponseStatus(p_StatusText : string);
    function GetUserIdFromSession: Integer;
  end;

implementation

uses
  System.SysUtils, InterfaceKernel, InterfaceUsersRepository, dorm;

{ TRESTControllerWithLogging }

function TRESTControllerBase.GetUserIdFromSession: Integer;
var
  pomSession: string;
  pomCookie: TMiniRESTCookie;
begin
  Result := -1;
  GetLogger.Info('Getting user by session');
  try
    pomCookie := GetActionContext.GetCookie(SESSION_ID_COOKIE);
    try
      pomSession := pomCookie.Value;
      Result := (MainKernel.GiveObjectByInterface(IUsersRepository) as IUsersRepository).GetUserIdBySessionId(pomSession);
    finally
      pomCookie.Free;
    end;
  except
    on E : Exception do
      GetLogger.Exception('Error during getting user', E);
  end;
  GetLogger.Info('User found');
end;

procedure TRESTControllerBase.ResponseStatus(p_StatusText : string);
const
  cStatusJSON = '{"status": "%s"}';
begin
  ResponseJson(Format(cStatusJSON, [p_StatusText]));
end;

end.
