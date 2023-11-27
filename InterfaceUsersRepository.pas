unit InterfaceUsersRepository;

interface

type
  IUsersRepository = interface(IInterface)
    ['{2B722188-F6C8-47DE-926C-FD53EA06D350}']
    function IsUserExists(const p_UserName : string; const p_Password : string) : boolean;
  end;

implementation

end.
