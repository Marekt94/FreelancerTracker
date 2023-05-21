unit SalaryRESTObjects;

interface

uses
  SalaryEntities, REST.Json, SalaryDTOs;

type
  TWysokoscPodatkuRESTObject = class(TWysokoscPodatku)
  private
    FDTO : TWysokoscPodatkuDTO;
    procedure CreateFromDTO(const p_WysokoscPodatkuDTO : TWysokoscPodatkuDTO);
    function GetDTO: TWysokoscPodatkuDTO;
    function GetJSONString: string;
  public
    constructor Create(const p_JSON : string); overload;
    constructor Create(const p_WysokoscPodatkuDTO : TWysokoscPodatkuDTO); overload;
    destructor Destroy; override;
    property DTO : TWysokoscPodatkuDTO read GetDTO;
    property DTOJSONString : string read GetJSONString;
  end;

  TFormaOpodatkowaniaRESTObject = class(TFormaOpodatkowania)
  private
    FDTO : TFormaOpodatkowaniaDTO;
    procedure CreateFromDTO(const p_FormaOpodatkowaniaDTO : TFormaOpodatkowaniaDTO);
    function GetDTO: TFormaOpodatkowaniaDTO;
    function GetJSONString: string;
  public
    constructor Create(const p_Json: string); overload;
    constructor Create(const p_FormaOpodatkowaniaDTO : TFormaOpodatkowaniaDTO); overload;
    destructor Destroy; override;
    property DTO : TFormaOpodatkowaniaDTO read GetDTO;
    property DTOJSONString : string read GetJSONString;
  end;

  TSalaryRESTObject = class
  strict private
    FEntity : TSalary;
    FDTO : TSalaryDTO;
    procedure CreateFromDTO(const p_SalaryDTO : TSalaryDTO);
    function GetDTO: TSalaryDTO;
    function GetJSONString: string;
  public
    constructor Create; overload;
    constructor Create(const p_Json : string); overload;
    constructor Create(const p_SalaryDTO : TSalaryDTO); overload;
    destructor Destroy; override;
    property DTO : TSalaryDTO read GetDTO;
    property Entity : TSalary read FEntity;
    property DTOJSONString : string read GetJSONString;
  end;

implementation

uses
  System.SysUtils;

{ TFormaOpodatkowaniaDTO }

constructor TWysokoscPodatkuRESTObject.Create(const p_JSON : string);
begin
  Create;
  CreateFromDTO(TJson.JsonToObject<TWysokoscPodatkuDTO>(p_Json));
end;

constructor TWysokoscPodatkuRESTObject.Create(
  const p_WysokoscPodatkuDTO: TWysokoscPodatkuDTO);
begin
  Create;
  CreateFromDTO(p_WysokoscPodatkuDTO);
end;

procedure TWysokoscPodatkuRESTObject.CreateFromDTO(const p_WysokoscPodatkuDTO: TWysokoscPodatkuDTO);
begin
  Self.FId                  := p_WysokoscPodatkuDTO.Id;
  Self.FStawka              := p_WysokoscPodatkuDTO.Stawka;
  Self.FFormaOpodatkowniaId := p_WysokoscPodatkuDTO.FormaOpodatkowaniaId;
end;

destructor TWysokoscPodatkuRESTObject.Destroy;
begin
  FDTO.Free;
  inherited;
end;

function TWysokoscPodatkuRESTObject.GetDTO: TWysokoscPodatkuDTO;
begin
  if Assigned(FDTO) then
    FreeAndNil(FDTO);

  FDTO := TWysokoscPodatkuDTO.Create(self);
  Result := FDTO;
end;

function TWysokoscPodatkuRESTObject.GetJSONString: string;
begin
  if Assigned(FDTO) then
    FreeAndNil(FDTO);

  FDTO := TWysokoscPodatkuDTO.Create(self);
  Result := TJson.ObjectToJsonString(FDTO);
end;

constructor TFormaOpodatkowaniaRESTObject.Create(const p_Json: string);
begin
  Create;
  CreateFromDTO(TJson.JsonToObject<TFormaOpodatkowaniaDTO>(p_Json))
end;

constructor TFormaOpodatkowaniaRESTObject.Create(
  const p_FormaOpodatkowaniaDTO: TFormaOpodatkowaniaDTO);
begin
  Create;
  CreateFromDTO(p_FormaOpodatkowaniaDTO);
end;

procedure TFormaOpodatkowaniaRESTObject.CreateFromDTO(
  const p_FormaOpodatkowaniaDTO: TFormaOpodatkowaniaDTO);
begin
  FIdFormy    := p_FormaOpodatkowaniaDTO.Id;
  FNazwa := p_FormaOpodatkowaniaDTO.Nazwa;
  for var i := 0 to p_FormaOpodatkowaniaDTO.GetWysokoscPodatkuCount -1 do
  begin
    var pomWysokoscPodatku := p_FormaOpodatkowaniaDTO.WysokoscPodatku[i];
    FWysokoscPodatkuList.Add(TWysokoscPodatkuRESTObject.Create(pomWysokoscPodatku));
  end;
end;

destructor TFormaOpodatkowaniaRESTObject.Destroy;
begin
  FDTO.Free;
  inherited;
end;

function TFormaOpodatkowaniaRESTObject.GetDTO: TFormaOpodatkowaniaDTO;
begin
  if Assigned(FDTO) then
    FreeAndNil(FDTO);

  FDTO := TFormaOpodatkowaniaDTO.Create(self);
  Result := FDTO;
end;

function TFormaOpodatkowaniaRESTObject.GetJSONString: string;
begin
  if Assigned(FDTO) then
    FreeAndNil(FDTO);

  FDTO:= TFormaOpodatkowaniaDTO.Create(self);
  Result := TJson.ObjectToJsonString(FDTO);
end;

constructor TSalaryRESTObject.Create(const p_Json: string);
begin
  Create;
  CreateFromDTO(TJson.JsonToObject<TSalaryDTO>(p_JSon));
end;

constructor TSalaryRESTObject.Create(const p_SalaryDTO: TSalaryDTO);
begin
  Create;
  CreateFromDTO(p_SalaryDTO);
end;

constructor TSalaryRESTObject.Create;
begin
  inherited;
  FEntity := TSalary.Create;
end;

procedure TSalaryRESTObject.CreateFromDTO(const p_SalaryDTO: TSalaryDTO);
var
  pomFormaPodatkowa : TFormaOpodatkowaniaDTO;
begin
  FEntity.Id := p_SalaryDTO.Id;
  FEntity.Miesiac := p_SalaryDTO.Miesiac;
  FEntity.Rok := p_SalaryDTO.Rok;
  FEntity.IdFormyOpodatkowania := p_SalaryDTO.IdFormyOpodatkowania;
  pomFormaPodatkowa := p_SalaryDTO.FormaOpodatkowania;
  if Assigned(pomFormaPodatkowa) then
    FEntity.FormaOpodatkowania := TFormaOpodatkowaniaRESTObject.Create(p_SalaryDTO.FormaOpodatkowania)
  else
    FEntity.FormaOpodatkowania := nil;;
  FEntity.Stawka := p_SalaryDTO.Stawka;
  FEntity.DniRoboczych := p_SalaryDTO.DniRoboczych;
  FEntity.DniPrzepracowanych := p_SalaryDTO.DniPrzepracowanych;
  FEntity.SkladkaZdrowotna := p_SalaryDTO.SkladkaZdrowotna;
  FEntity.ZUS := p_SalaryDTO.ZUS;
  FEntity.Netto := p_SalaryDTO.Netto;
  FEntity.PelneNetto := p_SalaryDTO.PelneNetto;
  FEntity.DoWyplaty := p_SalaryDTO.DoWyplaty;
  FEntity.DoRozdysponowania := p_SalaryDTO.DoRozdysponowania;
  FEntity.Zablokowane := p_SalaryDTO.Zablokowane;
end;

destructor TSalaryRESTObject.Destroy;
begin
  FDTO.Free;
  FEntity.Free;
  inherited;
end;

function TSalaryRESTObject.GetDTO: TSalaryDTO;
begin
  if Assigned(FDTO) then
    FreeAndNil(FDTO);

  FDTO:= TSalaryDTO.Create(FEntity);
  Result := FDTO;
end;

function TSalaryRESTObject.GetJSONString: string;
begin
  if Assigned(FDTO) then
    FreeAndNil(FDTO);

  FDTO:= TSalaryDTO.Create(FEntity);
  Result := TJson.ObjectToJsonString(FDTO);
end;

end.
