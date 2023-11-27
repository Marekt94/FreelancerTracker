unit UsersRepository;

interface

uses
  InterfaceUsersRepository, dorm.mappings, dorm;

type
  TUsersSalary = class(TInterfacedObject, IUsersRepository)
  public
    function IsUserExists(const p_UserName : string; const p_Password : string) : boolean;
  end;

implementation

uses
  System.Classes, dorm.Commons, dorm.Query, UsersEntities;

{ TUsersSalary }

function TUsersSalary.IsUserExists(const p_UserName,
  p_Password: string): boolean;
var
  pomSession : dorm.TSession;
  pomUser    : TUser;
begin
  pomSession := dorm.TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  try
    pomUser := pomSession.Load<TUser>(
      Select
      .From(TUser)
      .Where('(USER_NAME = ?) AND (PASSWORD = ?)', [p_UserName, p_Password])
      );
  finally
    pomSession.Free;
  end;

  Result := Assigned(pomUser);
end;

end.
