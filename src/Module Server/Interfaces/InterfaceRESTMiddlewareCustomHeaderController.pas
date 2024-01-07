unit InterfaceRESTMiddlewareCustomHeaderController;

interface

type
  TRESTProtocol = (rpHTTP, rpHTTPS);

  IRESTMiddlewareCustomHeaderController = interface(IInterface)
    ['{4C82809A-1C52-4A64-A0BE-C3AF5DB44D77}']
    procedure SetProtocol(const AProtocol : TRESTProtocol);
    function GetProtocol : TRESTProtocol;
    property Protocol: TRESTProtocol read GetProtocol write SetProtocol;
  end;

implementation

end.
