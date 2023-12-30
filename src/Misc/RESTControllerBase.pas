unit RESTControllerBase;

interface

uses
  MiniREST.Controller.Base, MiniREST.Common;

type
  TRESTControllerBase = class(TMiniRESTControllerBase)
  public
    procedure ResponseStatus(p_StatusText : string);
  end;

implementation

uses
  System.SysUtils;

{ TRESTControllerWithLogging }

procedure TRESTControllerBase.ResponseStatus(p_StatusText : string);
const
  cStatusJSON = '{"status": "%s"}';
begin
  ResponseJson(Format(cStatusJSON, [p_StatusText]));
end;

end.
