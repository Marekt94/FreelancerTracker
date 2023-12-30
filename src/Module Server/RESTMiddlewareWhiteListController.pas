unit RESTMiddlewareWhiteListController;

interface

uses
  InterfaceRESTMiddlewareWhiteListController, MiniREST.Intf;

type
  TRESTMiddlewareWhiteListController = class(TInterfacedObject, IRESTMiddlewareWhiteListController, IMiniRESTMiddleware)
    function Process(AActionContext : IMiniRESTActionContext) : Boolean;

  end;

implementation

{ TRESTMiddlewareWhiteListController }

function TRESTMiddlewareWhiteListController.Process(
  AActionContext: IMiniRESTActionContext): Boolean;
begin
  Result := true
end;

end.
