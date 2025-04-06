unit SessionsRepository;

interface

uses
  dorm, InterfaceSessionsRepository, SessionsEntities, RepositoryWrapper,
  InterfaceRepositoryWrapper;

type
  TSessionsRepository = class(TRepositoryWrapper, ISessionsRepository)
    function GetSessionByUserId(const p_UserId : Integer) : SessionsEntities.TSession;
    function GetValidSession(const p_SessionId : string) : boolean;

    function Get(const p_Id : Integer) : TObject;
    function GetWhere(const p_ColumnsName : array of string;
                      const p_Compare : array of string;
                      const p_Values : array of const) : TObject;
  end;

implementation

uses
  System.Classes, dorm.Commons, dorm.Query, System.SysUtils, System.DateUtils, UsersEntities;

{ TSessionsRepository }

function TSessionsRepository.Get(const p_Id: Integer): TObject;
begin
  Result := inherited Get<SessionsEntities.TSession>(p_Id);
end;

function TSessionsRepository.GetSessionByUserId(
  const p_UserId: Integer): SessionsEntities.TSession;
begin
  Result := GetWhere(['USER_ID'], ['='], [p_UserId]) as SessionsEntities.TSession;
end;

function TSessionsRepository.GetValidSession(const p_SessionId: string): boolean;
const
  cSQLTimestampFormat = 'yyyy-mm-dd hh:nn:ss';
begin
  var pomDateTime := FormatDateTime(cSQLTimestampFormat, Now);
  var pomRes := GetWhere(['SESSION', 'EXPIRATION_DATE'], ['=', '>'], [p_SessionId, pomDateTime]);
  Result := Assigned(pomRes);
  pomRes.Free;
end;

function TSessionsRepository.GetWhere(const p_ColumnsName,
  p_Compare: array of string; const p_Values: array of const): TObject;
begin
  Result := inherited GetWhere<SessionsEntities.TSession>(p_ColumnsName, p_Compare, p_Values);
end;

end.
