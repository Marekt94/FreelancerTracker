unit FormaOpodatkowaniaRepository;

interface

uses
 InterfaceFormaOpodatkowaniaRepository, SalaryEntities, System.Generics.Collections;

type
  TFormaOpodatkowaniaRepository = class(TInterfacedObject, IFormaOpodatkowaniaRepository)
  strict private
    FFormaOpodatkowania : TFormaOpodatkowania;
    FFormyOpodatkowania : TObjectList<TFormaOpodatkowania>;
  public
    destructor Destroy; override;
    function FormaOpodatkowania(const p_ID : Integer) : TFormaOpodatkowania; overload;
    function FormaOpodatkowania : TObjectList<TFormaOpodatkowania>; overload;
  end;

implementation

uses
  dorm, System.Classes, dorm.Commons, System.SysUtils;

{ TFormaOpodatkowaniaRepository }

function TFormaOpodatkowaniaRepository.FormaOpodatkowania(
  const p_ID: Integer): TFormaOpodatkowania;
var
  pomSession : TSession;
begin
  FreeAndNil(FFormaOpodatkowania);
  pomSession := TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  try
    FFormaOpodatkowania := pomSession.Load<TFormaOpodatkowania>(p_ID);
    Result := FFormaOpodatkowania;
  finally
    pomSession.Free;
  end;
end;

destructor TFormaOpodatkowaniaRepository.Destroy;
begin
  FFormaOpodatkowania.Free;
  FFormyOpodatkowania.Free;
  inherited;
end;

function TFormaOpodatkowaniaRepository.FormaOpodatkowania: TObjectList<TFormaOpodatkowania>;
var
  pomSession : TSession;
  pomIDs : TObjectList<TFormaOpodatkowaniaID>;
begin
  FreeAndNil(FFormyOpodatkowania);
  //gdy wczytuje liste to nie wczytuj¹ sie relacje
  pomSession := TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  pomIDs := nil;
  try
    pomIDs := pomSession.LoadList<TFormaOpodatkowaniaID>;
    FFormyOpodatkowania := TObjectList<TFormaOpodatkowania>.Create;
    for var pomID in pomIDs do
      FFormyOpodatkowania.Add(pomSession.Load<TFormaOpodatkowania>(pomID.IdFormy));
    Result := FFormyOpodatkowania;
  finally
    pomIDs.Free;
    pomSession.Free;
  end;
end;

end.
