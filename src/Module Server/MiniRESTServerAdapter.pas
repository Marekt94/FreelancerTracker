unit MiniRESTServerAdapter;

interface

uses
  MiniREST.Server.Intf, SysUtils, MiniREST.Controller.Intf,
  MiniREST.Controller.Security.Intf, MiniREST.Intf;

type
  TMiniRESTServerAdapter = class(TInterfacedObject, IMiniRESTServer)
  public
    constructor Create; overload;
    procedure AddController(AController : TClass); overload;
    procedure AddController(AControllerFactory : IMiniRESTControllerFactory); overload;
    procedure SetControllerOtherwise(AController : TClass);
    procedure SetSecurityController(AController : TFunc<IMiniRESTSecurityController>);
    function GetLogger : IMiniRESTLogger;
    procedure SetLogger(ALogger : IMiniRESTLogger);
    procedure AddMiddleware(AMiddleware : IMiniRESTMiddleware);
    function GetPort : Integer;
    procedure SetPort(APort : Integer);
    function Start : Boolean;
    function Stop : Boolean;
  end;

implementation

{ TMiniRESTServerAdapter }

procedure TMiniRESTServerAdapter.AddController(AController: TClass);
begin

end;

procedure TMiniRESTServerAdapter.AddController(
  AControllerFactory: IMiniRESTControllerFactory);
begin

end;

procedure TMiniRESTServerAdapter.AddMiddleware(
  AMiddleware: IMiniRESTMiddleware);
begin

end;

constructor TMiniRESTServerAdapter.Create;
begin
  inherited;

end;

function TMiniRESTServerAdapter.GetLogger: IMiniRESTLogger;
begin

end;

function TMiniRESTServerAdapter.GetPort: Integer;
begin

end;

procedure TMiniRESTServerAdapter.SetControllerOtherwise(AController: TClass);
begin

end;

procedure TMiniRESTServerAdapter.SetLogger(ALogger: IMiniRESTLogger);
begin

end;

procedure TMiniRESTServerAdapter.SetPort(APort: Integer);
begin

end;

procedure TMiniRESTServerAdapter.SetSecurityController(
  AController: TFunc<IMiniRESTSecurityController>);
begin

end;

function TMiniRESTServerAdapter.Start: Boolean;
begin

end;

function TMiniRESTServerAdapter.Stop: Boolean;
begin

end;

end.
