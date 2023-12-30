unit RESTMiddlewareCustomHeaderController;

interface

uses
  InterfaceRESTMiddlewareCustomHeaderController, MiniREST.Intf;

type
  TRESTMiddlewareCustomHeaderController = class(TInterfacedObject, IRESTMiddlewareCustomHeaderController, IMiniRESTMiddleware)
    function Process(AActionContext : IMiniRESTActionContext) : Boolean;

  end;

implementation

{ TRESTMiddlewareCustomHeaderController }

function TRESTMiddlewareCustomHeaderController.Process(
  AActionContext: IMiniRESTActionContext): Boolean;
begin
  AActionContext.AppendHeader('Access-Control-Allow-Origin', 'http://localhost:3000');
  AActionContext.AppendHeader('Access-Control-Allow-Credentials', 'true');
  AActionContext.AppendHeader('Access-Control-Allow-Methods','POST, GET, DELETE');
  AActionContext.AppendHeader('Access-Control-Allow-Headers','Content-Type, Accept');
  Result := true;
end;

end.
