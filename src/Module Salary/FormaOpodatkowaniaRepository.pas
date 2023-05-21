unit FormaOpodatkowaniaRepository;

interface

uses
 InterfaceFormaOpodatkowaniaRepository, SalaryEntities, System.Generics.Collections;

type
  TFormaOpodatkowaniaRepository = class(TInterfacedObject, IFormaOpodatkowaniaRepository)
    function FormaOpodatkowania(const p_ID : Integer) : TFormaOpodatkowania; overload;
    function FormaOpodatkowania : TList<TFormaOpodatkowania>; overload;
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

function TFormaOpodatkowaniaRepository.FormaOpodatkowania: TList<TFormaOpodatkowania>;
var
  pomSession : TSession;
begin
  pomSession := TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  try
    Result := pomSession.LoadList<TFormaOpodatkowania>;
  finally
    pomSession.Free;
  end;
end;

end.
