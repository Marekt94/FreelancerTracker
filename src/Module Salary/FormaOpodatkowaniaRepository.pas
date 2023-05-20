unit FormaOpodatkowaniaRepository;

interface

uses
 InterfaceFormaOpodatkowaniaRepository, Salary;

type
  TFormaOpodatkowaniaRepository = class(TInterfacedObject, IFormaOpodatkowaniaRepository)
    function FormaOpodatkowania(const p_ID : Integer) : TFormaOpodatkowania;
  end;

implementation

uses
  dorm, System.Classes, dorm.Commons;

{ TFormaOpodatkowaniaRepository }

function TFormaOpodatkowaniaRepository.FormaOpodatkowania(
  const p_ID: Integer): TFormaOpodatkowania;
var
  pomSession : TSession;
begin
  pomSession := TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  try
    Result := pomSession.Load<TFormaOpodatkowania>(p_ID);
  finally
    pomSession.Free;
  end;
end;

end.
