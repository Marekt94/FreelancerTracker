unit InterfaceSessionsRepository;

interface

uses
  SessionsEntities, InterfaceRepositoryWrapper;

type
  ISessionsRepository = interface(IRepositoryWrapper)
    ['{680A59C6-275D-4F6B-97D2-C546C09309DB}']
    function GetSessionByUserId(const p_UserId : Integer) : TSession;
    function GetValidSession(const p_SessionId : string) : boolean;
  end;

implementation

end.
