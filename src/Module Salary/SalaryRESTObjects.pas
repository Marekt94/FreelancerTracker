unit SalaryRESTObjects;

interface

uses
  SalaryEntities, REST.Json, SalaryDTOs, System.Generics.Collections, InterfaceFormaOpodatkowaniaRepository, InterfaceSalaryRepository;

type
  TWysokoscPodatkuRESTObject = class
  strict private
    FEntity : TWysokoscPodatku;
    FDTO : TWysokoscPodatkuDTO;
    procedure CreateFromDTO(const p_WysokoscPodatkuDTO : TWysokoscPodatkuDTO);
    function GetDTO: TWysokoscPodatkuDTO;
    function GetJSONString: string;
  public
    constructor Create; overload;
    constructor Create(const p_JSON : string); overload;
    constructor Create(const p_WysokoscPodatkuDTO : TWysokoscPodatkuDTO); overload;
    destructor Destroy; override;
    property DTO : TWysokoscPodatkuDTO read GetDTO;
    property DTOJSONString : string read GetJSONString;
    property Entity : TWysokoscPodatku read FEntity write FEntity;
  end;

  TFormaOpodatkowaniaRESTObject = class
  strict private
    FEntity : TFormaOpodatkowania;
    FDTO : TFormaOpodatkowaniaDTO;
    FWysokoscPodatkuList : TObjectList<TWysokoscPodatkuRESTObject>;
    procedure CreateFromDTO(const p_FormaOpodatkowaniaDTO : TFormaOpodatkowaniaDTO);
    function GetDTO: TFormaOpodatkowaniaDTO;
    function GetJSONString: string;
  public
    constructor Create; overload;
    constructor Create(const p_Json: string); overload;
    constructor Create(const p_FormaOpodatkowaniaDTO : TFormaOpodatkowaniaDTO); overload;
    destructor Destroy; override;
    property DTO : TFormaOpodatkowaniaDTO read GetDTO;
    property DTOJSONString : string read GetJSONString;
    property Entity: TFormaOpodatkowania read FEntity write FEntity;
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

  TDataForNewSalaryRestObject = class
  strict private
    FUserId: integer;
    FFormaOpodatkowaniaRepository : IFormaOpodatkowaniaRepository;
    FSalaryRepository : ISalaryRepository;
    FDTORequest : Integer;
    FDTORespone : TDataForNewDTOResponse;
    function GetDTO : TDataForNewDTOResponse;
    function GetJSONString: string;
  public
    destructor Destroy; override;
    constructor Create(const p_Year: integer; const UserID: Integer); overload;
    property DTO : TDataForNewDTOResponse read GetDTO;
    property DTOJSONString : string read GetJSONString;
  end;

implementation

uses
  System.SysUtils, InterfaceKernel;

{ TFormaOpodatkowaniaDTO }

constructor TWysokoscPodatkuRESTObject.Create(const p_JSON : string);
begin
  Create;
  FDTO := TJson.JsonToObject<TWysokoscPodatkuDTO>(p_Json);
  CreateFromDTO(FDTO);
end;

constructor TWysokoscPodatkuRESTObject.Create(
  const p_WysokoscPodatkuDTO: TWysokoscPodatkuDTO);
begin
  Create;
  CreateFromDTO(p_WysokoscPodatkuDTO);
end;

constructor TWysokoscPodatkuRESTObject.Create;
begin
  FEntity := TWysokoscPodatku.Create;
end;

procedure TWysokoscPodatkuRESTObject.CreateFromDTO(const p_WysokoscPodatkuDTO: TWysokoscPodatkuDTO);
begin
  FEntity.Id                  := p_WysokoscPodatkuDTO.Id;
  FEntity.Stawka              := p_WysokoscPodatkuDTO.Stawka;
  FEntity.FormaOpodatkowniaId := p_WysokoscPodatkuDTO.FormaOpodatkowaniaId;
end;

destructor TWysokoscPodatkuRESTObject.Destroy;
begin
  FEntity.Free;
  FDTO.Free;
  inherited;
end;

function TWysokoscPodatkuRESTObject.GetDTO: TWysokoscPodatkuDTO;
begin
  if Assigned(FDTO) then
    FreeAndNil(FDTO);

  FDTO := TWysokoscPodatkuDTO.Create(FEntity);
  Result := FDTO;
end;

function TWysokoscPodatkuRESTObject.GetJSONString: string;
begin
  if Assigned(FDTO) then
    FreeAndNil(FDTO);

  FDTO := TWysokoscPodatkuDTO.Create(FEntity);
  Result := TJson.ObjectToJsonString(FDTO);
end;

constructor TFormaOpodatkowaniaRESTObject.Create(const p_Json: string);
begin
  Create;
  FDTO := TJson.JsonToObject<TFormaOpodatkowaniaDTO>(p_Json);
  CreateFromDTO(FDTO);
end;

constructor TFormaOpodatkowaniaRESTObject.Create(
  const p_FormaOpodatkowaniaDTO: TFormaOpodatkowaniaDTO);
begin
  Create;
  CreateFromDTO(p_FormaOpodatkowaniaDTO);
end;

constructor TFormaOpodatkowaniaRESTObject.Create;
begin
  FEntity := TFormaOpodatkowania.Create;
  FWysokoscPodatkuList := TObjectList<TWysokoscPodatkuRESTObject>.Create;
end;

procedure TFormaOpodatkowaniaRESTObject.CreateFromDTO(
  const p_FormaOpodatkowaniaDTO: TFormaOpodatkowaniaDTO);
begin
  FEntity.IdFormy    := p_FormaOpodatkowaniaDTO.Id;
  FEntity.Nazwa := p_FormaOpodatkowaniaDTO.Nazwa;
  for var i := 0 to p_FormaOpodatkowaniaDTO.GetWysokoscPodatkuCount -1 do
  begin
    var pomWysokoscPodatku := p_FormaOpodatkowaniaDTO.WysokoscPodatku[i];
    FWysokoscPodatkuList.Add(TWysokoscPodatkuRESTObject.Create(pomWysokoscPodatku));
    FEntity.WysokoscPodatkuList.Add(FWysokoscPodatkuList[i].Entity);
    FWysokoscPodatkuList[i].Entity := nil;
  end;
end;

destructor TFormaOpodatkowaniaRESTObject.Destroy;
begin
  FEntity.Free;
  FWysokoscPodatkuList.Free;
  FDTO.Free;
  inherited;
end;

function TFormaOpodatkowaniaRESTObject.GetDTO: TFormaOpodatkowaniaDTO;
begin
  if Assigned(FDTO) then
    FreeAndNil(FDTO);

  FDTO := TFormaOpodatkowaniaDTO.Create(FEntity);
  Result := FDTO;
end;

function TFormaOpodatkowaniaRESTObject.GetJSONString: string;
begin
  if Assigned(FDTO) then
    FreeAndNil(FDTO);

  FDTO:= TFormaOpodatkowaniaDTO.Create(FEntity);
  Result := TJson.ObjectToJsonString(FDTO);
end;

constructor TSalaryRESTObject.Create(const p_Json: string);
begin
  Create;
  FDTO := TJson.JsonToObject<TSalaryDTO>(p_JSon);
  CreateFromDTO(FDTO);
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
  begin
    var pomFormaOpodREST := TFormaOpodatkowaniaRESTObject.Create(p_SalaryDTO.FormaOpodatkowania);
    FEntity.FormaOpodatkowania := pomFormaOpodREST.Entity;
    pomFormaOpodREST.Entity := nil;
    pomFormaOpodREST.Free;
  end;
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
  FEntity.Brutto := p_SalaryDTO.Brutto;
  FEntity.Vat := p_SalaryDTO.Vat;
  FEntity.Podatek := p_SalaryDTO.Podatek;
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

{ TDataForNewSalaryRestObject }

destructor TDataForNewSalaryRestObject.Destroy;
begin
  if Assigned(FDTORespone) then
    FDTORespone.Free;
  inherited;
end;

function TDataForNewSalaryRestObject.GetDTO: TDataForNewDTOResponse;
var
  pomFormyOpodatkowania : TList<TFormaOpodatkowania>;
  pomAvailableMonths    : TList<TMonth>;
begin
  if Assigned(FDTORespone) then
    FDTORespone.Free;

  pomFormyOpodatkowania := FFormaOpodatkowaniaRepository.FormaOpodatkowania;
  pomAvailableMonths    := FSalaryRepository.AvailableMonths(FDTORequest, FUserId);

  FDTORespone := TDataForNewDTOResponse.Create(pomAvailableMonths, pomFormyOpodatkowania);
  Result := FDTORespone;
end;

function TDataForNewSalaryRestObject.GetJSONString: string;
var
  pomDTO : TDataForNewDTOResponse;
begin
  pomDTO := GetDTO;
  Result := TJson.ObjectToJsonString(pomDTO);
end;

constructor TDataForNewSalaryRestObject.Create(const p_Year: integer; const UserID: Integer);
begin
  FUserId := UserID;
  FDTORequest := p_Year;
  FFormaOpodatkowaniaRepository := (MainKernel.GiveObjectByInterface(IFormaOpodatkowaniaRepository) as IFormaOpodatkowaniaRepository);
  FSalaryRepository := (MainKernel.GiveObjectByInterface(ISalaryRepository) as ISalaryRepository);
end;

end.
