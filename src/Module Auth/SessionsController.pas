unit SessionsController;

interface

uses
  InterfaceSessionsController, RESTObjects, SessionsRESTObjects, SessionsEntities;

type
  TSessionsController = class(TInterfacedObject, ISessionsController)
  private
    FSessionTimeInSec : Integer;
  public
    constructor Create;
    procedure Execute(const p_Request  : TUsersDTORequest; var p_Response : TSessionDTOResponse; out p_ErrorMessage : string);
    function CreateSession : string;
    property SessionTimeInSec: Integer read FSessionTimeInSec write FSessionTimeInSec;
  end;

implementation

uses
  System.SysUtils, System.NetEncoding, InterfaceKernel, InterfaceUsersRepository,
  InterfaceSessionsRepository;

{ TSessionsController }

constructor TSessionsController.Create;
begin
  FSessionTimeInSec := 3600;
end;

function TSessionsController.CreateSession: string;
var
  pomGUID : TGUID;
begin
  if CreateGUID(pomGUID) = 0 then
  begin
    Result := GUIDToString(pomGUID);
    Result := TBase64Encoding.Base64.Encode(Result);
  end
  else
    Result := '';
end;

procedure TSessionsController.Execute(const p_Request: TUsersDTORequest;
  var p_Response: TSessionDTOResponse; out p_ErrorMessage : string);
resourcestring
  sUserDoesNotExist = 'User does not exist';
var
  pomUsersRepo : IUsersRepository;
  pomSessionRepo : ISessionsRepository;
  pomSession   : TSession;
begin
  pomUsersRepo := (MainKernel.GiveObjectByInterface(IUsersRepository) as IUsersRepository);
  if pomUsersRepo.IsUserExists(p_Request.UserName, p_Request.Password) then
  begin
    var pomUser := pomUsersRepo.User(p_Request.UserName, p_Request.Password);
    try
      pomSessionRepo := (MainKernel.GiveObjectByInterface(ISessionsRepository) as ISessionsRepository);
      pomSession := pomSessionRepo.GetSessionByUserId(pomUser.ID);
      try
        if not Assigned(pomSession) then
          pomSession := TSession.Create;

        pomSession.User := pomUser;
        pomUser := nil;
        pomSession.Session := CreateSession;
        pomSession.ExpirationDate := Now + FSessionTimeInSec/SecsPerDay;
        p_Response.SessionID := pomSession.Session;

        pomSessionRepo.SaveOrUpate(pomSession);
      finally
        pomSession.Free;
      end
    finally
      pomUser.Free;
    end;
  end
  else
    p_ErrorMessage := sUserDoesNotExist;
end;

end.
