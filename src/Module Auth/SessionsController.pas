unit SessionsController;

interface

uses
  InterfaceSessionsController;

type
  TSessionsController = class(TInterfacedObject, ISessionsController)
    function CreateSession : string;
  end;

implementation

uses
  System.SysUtils, System.NetEncoding;

{ TSessionsController }

function TSessionsController.CreateSession: string;
var
  pomGUID : TGUID;
begin
  if CreateGUID(pomGUID) <> 0 then
  begin
    Result := GUIDToString(pomGUID);
    Result := TBase64Encoding.Base64.Encode(Result);
  end
  else
    Result := '';
end;

end.
