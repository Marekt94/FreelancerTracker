unit InterfaceSessionsRepository;

interface

uses
  SessionsEntities;

type
  ISessionsRepository = interface(IInterface)
    ['{680A59C6-275D-4F6B-97D2-C546C09309DB}']
    procedure SaveOrUpate(const p_Obj : TSession);
    function GetSessionByUserId(const p_UserId : Integer) : TSession;
  end;

implementation

end.
