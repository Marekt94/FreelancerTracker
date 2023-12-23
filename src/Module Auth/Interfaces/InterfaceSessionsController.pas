unit InterfaceSessionsController;

interface

uses
  SessionsRESTObjects;

type
  ISessionsController = interface(IInterface)
    ['{538E6EB0-8B53-4D6F-A712-3DCAB7974050}']
    function CreateSession : string;
    procedure Execute(const p_Request  : TUsersDTORequest; var p_Response : TSessionDTOResponse; out p_ErrorMessage : string);
  end;

implementation

end.
