unit SalaryDTOs;

interface

uses
  SalaryEntities, System.Generics.Collections;

type
  TWysokoscPodatkuDTO = class
  strict private
    FId: Integer;
    FStawka: Double;
    FFormaOpodatkowaniaId: Integer;
  public
    constructor Create(const p_WysokoscPodatku : TWysokoscPodatku); overload;
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
  public
    constructor Create(const p_FormaOpodatkowania: TFormaOpodatkowania); overload;
    destructor Destroy; override;
    function GetWysokoscPodatku(Index: Integer): TWysokoscPodatkuDTO;
    procedure SetWysokoscPodatku(Index: Integer; const Value: TWysokoscPodatkuDTO);
    function GetWysokoscPodatkuCount: Integer;
    property Id: Integer read FId write FId;
    property WysokoscPodatku[Index : Integer]: TWysokoscPodatkuDTO read GetWysokoscPodatku write SetWysokoscPodatku;
    property WysokoscPodatkuCount: Integer read GetWysokoscPodatkuCount;
    property Nazwa: string read FNazwa write FNazwa;
  end;

  TSalaryDTO = class
  strict private
    FId: Integer;
    FMiesiac: Integer;
    FRok: Integer;
    FIdFormyOpodatkowania : Integer;
    FFormaOpodatkowania: TFormaOpodatkowaniaDTO;
    FStawka : Single;
    FDniRoboczych : Integer;
    FDniPrzepracowanych : Integer;
    FSkladkaZdrowotna : Single;
    FZUS : Single;
    FNetto : Single;
    FPelneNetto : Single;
    FDoWyplaty : Single;
    FDoRozdysponowania : Single;
    FZablokowane : boolean;
    FNaUrlopowoChorobowe : single;
  private
    FBrutto: Single;
    FVat: Single;
    FPodatek: Single;
    procedure SetFormaOpodatkowania(const Value: TFormaOpodatkowaniaDTO);
  public
    constructor Create(const p_Salary : TSalary); overload;
    destructor Destroy; override;
    property Id: Integer read FId write FId;
    property Miesiac: Integer read FMiesiac write FMiesiac;
    property Rok: Integer read FRok write FRok;
    property IdFormyOpodatkowania : Integer read FIdFormyOpodatkowania;
    property FormaOpodatkowania : TFormaOpodatkowaniaDTO read FFormaOpodatkowania write SetFormaOpodatkowania;
    property Stawka             : Single  read FStawka             write FStawka;
    property DniRoboczych       : Integer read FDniRoboczych       write FDniRoboczych;
    property DniPrzepracowanych : Integer read FDniPrzepracowanych write FDniPrzepracowanych;
    property SkladkaZdrowotna   : Single  read FSkladkaZdrowotna   write FSkladkaZdrowotna;
    property ZUS                : Single  read FZUS                write FZUS;
    property Netto              : Single  read FNetto              write FNetto;
    property PelneNetto         : Single  read FPelneNetto         write FPelneNetto;
    property DoWyplaty          : Single  read FDoWyplaty          write FDoWyplaty;
    property DoRozdysponowania  : Single  read FDoRozdysponowania  write FDoRozdysponowania;
    property NaUrlopowoChorobowe: Single  read FNaUrlopowoChorobowe write FNaUrlopowoChorobowe;
    property Zablokowane        : boolean read FZablokowane        write FZablokowane;
    property Brutto             : Single  read FBrutto             write FBrutto;
    property Vat                : Single  read FVat                write FVat;
    property Podatek            : Single  read FPodatek            write FPodatek;
  end;

  TDataForNewDTOResponse = class
  strict private
    FMiesiace : array of TMonth;
    FFormaOpodatkowania : array of TFormaOpodatkowaniaDTO;
  public
    constructor Create(const p_Months : TList<TMonth>; const p_FormaOpodatkowania : TList<TFormaOpodatkowania>);
    destructor Destroy; override;
  end;
implementation

uses
  System.SysUtils;

{ TFormaOpodatkowaniaDTO }

constructor TFormaOpodatkowaniaDTO.Create(const p_FormaOpodatkowania: TFormaOpodatkowania);
begin
  Create;
  FId    := p_FormaOpodatkowania.IdFormy;
  FNazwa := p_FormaOpodatkowania.Nazwa;
  SetLength(FWysokoscPodatkuList, p_FormaOpodatkowania.WysokoscPodatkuList.Count);
  for var i := 0 to p_FormaOpodatkowania.WysokoscPodatkuList.Count - 1 do
    FWysokoscPodatkuList[i] := TWysokoscPodatkuDTO.Create(p_FormaOpodatkowania.WysokoscPodatkuList[i]);
end;

destructor TFormaOpodatkowaniaDTO.Destroy;
begin
  for var i := Length(FWysokoscPodatkuList) - 1 downto 0 do
    FWysokoscPodatkuList[i].Free;
  inherited;
end;

function TFormaOpodatkowaniaDTO.GetWysokoscPodatku(
  Index: Integer): TWysokoscPodatkuDTO;
begin
  Result := FWysokoscPodatkuList[index];
end;

function TFormaOpodatkowaniaDTO.GetWysokoscPodatkuCount: Integer;
begin
  Result := Length(FWysokoscPodatkuList);
end;

procedure TFormaOpodatkowaniaDTO.SetWysokoscPodatku(Index: Integer;
  const Value: TWysokoscPodatkuDTO);
begin
  if Index = Length(FWysokoscPodatkuList) then
    SetLength(FWysokoscPodatkuList, Length(FWysokoscPodatkuList) + 1);
  FWysokoscPodatkuList[Index] := Value
end;

{ TWysokoscPodatkuDTO }

constructor TWysokoscPodatkuDTO.Create(const p_WysokoscPodatku: TWysokoscPodatku);
begin
  Create;
  Self.FId                   := p_WysokoscPodatku.Id;
  Self.FStawka               := p_WysokoscPodatku.Stawka;
  Self.FFormaOpodatkowaniaId := p_WysokoscPodatku.FormaOpodatkowniaId;
end;

{ TSalaryDTO }

constructor TSalaryDTO.Create(const p_Salary: TSalary);
begin
  Create;
  FId := p_Salary.Id;
  FMiesiac := p_Salary.Miesiac;
  FRok := p_Salary.Rok;
  FIdFormyOpodatkowania := p_Salary.IdFormyOpodatkowania;
  FFormaOpodatkowania := TFormaOpodatkowaniaDTO.Create(p_Salary.FormaOpodatkowania);
  FStawka := p_Salary.Stawka;
  FDniRoboczych := p_Salary.DniRoboczych;
  FDniPrzepracowanych := p_Salary.DniPrzepracowanych;
  FSkladkaZdrowotna := p_Salary.SkladkaZdrowotna;
  FZUS := p_Salary.ZUS;
  FNetto := p_Salary.Netto;
  FPelneNetto := p_Salary.PelneNetto;
  FDoWyplaty := p_Salary.DoWyplaty;
  FDoRozdysponowania := p_Salary.DoRozdysponowania;
  FZablokowane := p_Salary.Zablokowane;
  FNaUrlopowoChorobowe := FDoWyplaty - FDoRozdysponowania;
  FBrutto := p_Salary.Brutto;
  FPodatek := p_Salary.Podatek;
  FZUS := p_Salary.ZUS;
  FVat := p_Salary.Vat;
end;

destructor TSalaryDTO.Destroy;
begin
  FFormaOpodatkowania.Free;
  inherited;
end;

procedure TSalaryDTO.SetFormaOpodatkowania(const Value: TFormaOpodatkowaniaDTO);
begin
  FreeAndNil(FFormaOpodatkowania);
  FFormaOpodatkowania := Value;
end;

{ TDataForNewDTOResponse }

constructor TDataForNewDTOResponse.Create(const p_Months: TList<TMonth>;
  const p_FormaOpodatkowania: TList<TFormaOpodatkowania>);
begin
  SetLength(FMiesiace, p_Months.Count);
  for var i := 0 to p_Months.Count - 1 do
    FMiesiace[i] := p_Months[i];

  SetLength(FFormaOpodatkowania, p_FormaOpodatkowania.Count);
  for var i := 0 to p_FormaOpodatkowania.Count - 1 do
    FFormaOpodatkowania[i] := TFormaOpodatkowaniaDTO.Create(p_FormaOpodatkowania[i]);
end;

destructor TDataForNewDTOResponse.Destroy;
begin
  for var i := Length(FFormaOpodatkowania) - 1 downto 0 do
    FFormaOpodatkowania[i].Free;
end;

end.
