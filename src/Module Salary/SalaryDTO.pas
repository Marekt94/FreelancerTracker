unit SalaryDTO;

interface

type
  TWysokoscPodatkuDTO = class
  strict private
    FId: Integer;
    FStawka: Double;
    FFormaOpodatkowaniaId: Integer;
  public
    property Id: Integer read FId write FId;
    property Stawka: Double read FStawka write FStawka;
    property FormaOpodatkowaniaId: Integer read FFormaOpodatkowaniaId write FFormaOpodatkowaniaId;
  end;

  TFormaOpodatkowaniaDTO = class
  strict private
    FId: Integer;
    FWysokoscPodatkuList: array of TWysokoscPodatkuDTO;
    FNazwa: string;
  private
    function GetWysokoscPodatku(Index: Integer): TWysokoscPodatkuDTO;
    procedure SetWysokoscPodatku(Index: Integer;
      const Value: TWysokoscPodatkuDTO);
  public
    constructor Create;
    destructor Destroy; override;
    property Id: Integer read FId write FId;
    property WysokoscPodatku[Index : Integer]: TWysokoscPodatkuDTO read GetWysokoscPodatku write SetWysokoscPodatku;
    property Nazwa: string read FNazwa write FNazwa;
  end;

implementation

{ TFormaOpodatkowaniaDTO }

constructor TFormaOpodatkowaniaDTO.Create;
begin

end;

destructor TFormaOpodatkowaniaDTO.Destroy;
begin

  inherited;
end;

function TFormaOpodatkowaniaDTO.GetWysokoscPodatku(
  Index: Integer): TWysokoscPodatkuDTO;
begin
  Result := FWysokoscPodatkuList[index];
end;

procedure TFormaOpodatkowaniaDTO.SetWysokoscPodatku(Index: Integer;
  const Value: TWysokoscPodatkuDTO);
begin
  if Index = Length(FWysokoscPodatkuList) then
    SetLength(FWysokoscPodatkuList, Length(FWysokoscPodatkuList) + 1);
  FWysokoscPodatkuList[Index] := Value
end;

end.
