unit SessionsRepository;

interface

uses
  dorm, InterfaceSessionsRepository, SessionsEntities;

type
  TSessionsRepository = class(TInterfacedObject, ISessionsRepository)
    procedure SaveOrUpate(const p_Obj : SessionsEntities.TSession);
    function GetSessionByUserId(const p_UserId : Integer) : SessionsEntities.TSession;
    function GetValidSession(const p_SessionId : string) : boolean;
  end;

implementation

uses
  System.Classes, dorm.Commons, dorm.Query, System.SysUtils, System.DateUtils;

{ TSessionsRepository }

function TSessionsRepository.GetSessionByUserId(
  const p_UserId: Integer): SessionsEntities.TSession;
var
  pomSession : dorm.TSession;
begin
  pomSession := dorm.TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  try
    Result := pomSession.Load<SessionsEntities.TSession>(
      Select
      .From(SessionsEntities.TSession)
      .Where('USER_ID = ?', [p_UserId])
      );
  finally
    pomSession.Free;
  end;
end;

procedure TSessionsRepository.SaveOrUpate(const p_Obj: TSession);
var
  pomSession : dorm.TSession;
begin
  pomSession := dorm.TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  try
    pomSession.Persist(p_Obj);
  finally
    pomSession.Free;
  end;

end;

function TSessionsRepository.GetValidSession(const p_SessionId: string): boolean;
const
  cSQLTimestampFormat = 'yyyy-mm-dd hh:nn:ss';
var
  pomSession : dorm.TSession;
  pomRes : SessionsEntities.TSession;
begin
  pomRes := nil;
  var pomDateTime := FormatDateTime(cSQLTimestampFormat, Now);
  pomSession := dorm.TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  try
    pomRes := pomSession.Load<SessionsEntities.TSession>(
      Select
      .From(SessionsEntities.TSession)
      .Where('(SESSION = ?) AND (EXPIRATION_DATE > ?)', [p_SessionId, pomDateTime])
      );

    Result := Assigned(pomRes);
  finally
    pomRes.Free;
    pomSession.Free;
  end;
end;

end.
