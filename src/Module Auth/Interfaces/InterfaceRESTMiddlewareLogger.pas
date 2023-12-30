unit InterfaceRESTMiddlewareLogger;

interface

uses
  MiniREST.Intf;

type
  IRESTMiddlewareLogger = interface(IInterface)
    ['{8999B33D-CEBF-4198-906A-19481F1F0091}']
    procedure SetLogger(ALogger : IMiniRESTLogger);
    function GetLogger : IMiniRESTLogger;
  end;

implementation

end.
