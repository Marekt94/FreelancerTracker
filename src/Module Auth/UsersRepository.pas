unit UsersRepository;

interface

uses
  InterfaceUsersRepository, dorm.mappings, dorm, UsersEntities;

type
  TUsersRepository = class(TInterfacedObject, IUsersRepository)
  public
    function IsUserExists(const p_UserName : string; const p_Password : string) : boolean;
    function User(const p_Login : string; const p_Password : string) : TUser;
  end;

implementation

uses
  System.Classes, dorm.Commons, dorm.Query;

{ TUsersSalary }

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
var
  pomSession : dorm.TSession;
begin
  pomSession := dorm.TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  try
    Result := pomSession.Load<TUser>(
      Select
      .From(TUser)
      .Where('(USER_NAME = ?) AND (PASSWORD = ?)', [p_Login, p_Password])
      );
  finally
    pomSession.Free;
  end;
end;

end.
