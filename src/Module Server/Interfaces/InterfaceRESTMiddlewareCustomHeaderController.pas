unit InterfaceRESTMiddlewareCustomHeaderController;

interface

uses
    MiniREST.Intf;

type
  TRESTProtocol = (rpHTTP, rpHTTPS);

  IRESTMiddlewareCustomHeaderController = interface(IInterface)
    ['{4C82809A-1C52-4A64-A0BE-C3AF5DB44D77}']
    procedure SetProtocol(const AProtocol : TRESTProtocol);
    function GetProtocol : TRESTProtocol;
    function GetAllowedOrigin : string;
    procedure SetAllowedOrigin(const AObj : string);
    property Protocol: TRESTProtocol read GetProtocol write SetProtocol;
    property AllowedOrigin: string read GetAllowedOrigin write SetAllowedOrigin;
    procedure SetLogger(ALogger : IMiniRESTLogger);
    property Logger: IMiniRESTLogger write SetLogger;
  end;

implementation

end.
