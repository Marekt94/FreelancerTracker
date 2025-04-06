unit DatabaseSessionManager;

interface

uses
  dorm, System.Classes, dorm.Commons;

type
  TDatabaseSessionManager = class
  public
    class function CreateSession: TSession;
  end;

implementation

class function TDatabaseSessionManager.CreateSession: TSession;
begin
  Result := TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
end;

end.

