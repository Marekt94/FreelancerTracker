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
  pomIDs : TList<TFormaOpodatkowaniaID>;
begin
  //gdy wczytuje liste to nie wczytuj¹ sie relacje
  pomSession := TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  try
    pomIDs := pomSession.LoadList<TFormaOpodatkowaniaID>;
    Result := TList<TFormaOpodatkowania>.Create;
    for var pomID in pomIDs do
      Result.Add(pomSession.Load<TFormaOpodatkowania>(pomID.IdFormy));
  finally
    pomIDs.Free;
    pomSession.Free;
  end;
end;

end.
