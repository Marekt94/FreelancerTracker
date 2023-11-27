unit SessionsRepository;

interface

uses
  dorm, InterfaceSessionsRepository, SessionsEntities;

type
  TSessionsRepository = class(TInterfacedObject, ISessionsRepository)
    procedure SaveOrUpate(const p_Obj : SessionsEntities.TSession);
    function GetSessionByUserId(const p_UserId : Integer) : SessionsEntities.TSession;
  end;

implementation

uses
  System.Classes, dorm.Commons, dorm.Query;

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

end.
