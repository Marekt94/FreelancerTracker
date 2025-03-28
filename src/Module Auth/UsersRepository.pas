unit UsersRepository;

interface

uses
  InterfaceUsersRepository, dorm.mappings, dorm, UsersEntities, RepositoryWrapper;

type
  TUsersRepository = class(TRepositoryWrapper, IUsersRepository)
  public
    function IsUserExists(const p_UserName : string; const p_Password : string) : boolean;
    function GetUserIdBySessionId(const p_Session: string) : Integer;
    function User(const p_Login : string; const p_Password : string) : TUser;

    function Get(const p_Id : Integer) : TObject;
    function GetWhere(const p_ColumnsName : array of string;
                      const p_Compare : array of string;
                      const p_Values : array of const) : TUser;
  end;

implementation

uses
  System.Classes, dorm.Commons, dorm.Query, SessionsEntities;

{ TUsersSalary }

function TUsersRepository.Get(const p_Id: Integer): TObject;
begin
  Result := inherited Get<TUser>(p_Id);
end;

function TUsersRepository.GetUserIdBySessionId(
  const p_Session: string): Integer;
begin
  Result := (inherited GetWhere<TSession>(['SESSION'], ['='], [p_Session]) as TSession).User.ID;
end;

function TUsersRepository.GetWhere(const p_ColumnsName,
  p_Compare: array of string; const p_Values: array of const): TUser;
begin
  Result := inherited GetWhere<TUser>(p_ColumnsName, p_Compare, p_Values);
end;

function TUsersRepository.IsUserExists(const p_UserName,
  p_Password: string): boolean;
begin
  var pomUser := User(p_UserName, p_Password);
  try
    Result := Assigned(pomUser);
  finally
    pomUser.Free;
  end;
end;

function TUsersRepository.User(const p_Login, p_Password: string): TUser;
begin
  Result := GetWhere(['USER_NAME', 'PASSWORD'], ['=', '='], [p_Login, p_Password]);
end;

end.

