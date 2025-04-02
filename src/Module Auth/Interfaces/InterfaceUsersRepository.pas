unit InterfaceUsersRepository;

interface

uses
  UsersEntities;

const
  EMPTY_USER_ID = -1;

type
  IUsersRepository = interface(IInterface)
    ['{2B722188-F6C8-47DE-926C-FD53EA06D350}']
    function IsUserExists(const p_UserName : string; const p_Password : string) : boolean;
    function User(const p_Login : string; const p_Password : string) : TUser;
    function GetUserIdBySessionId(const p_SessionId: string) : Integer;
  end;

implementation

end.
