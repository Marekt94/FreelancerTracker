unit SessionsRESTObjects;

interface

uses
  UsersEntities;

type
  TUsersDTO = class
  strict private
    FUserName : string;
    FPassword : string;
  public
    constructor Create(const p_User : TUser); overload;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
  end;

  TUsersRESTObject = class
  strict private
    FEntity : TUser;
    FDTO : TUsersDTO;
    procedure CreateFromDTO(const p_User : TUsersDTO);
    function GetDTO: TUsersDTO;
    function GetJSONString: string;
  public
    constructor Create; overload;
    constructor Create(const p_JSON : string); overload;
    constructor Create(const p_User : TUsersDTO); overload;
    destructor Destroy; override;
    property DTO : TUsersDTO read GetDTO;
    property DTOJSONString : string read GetJSONString;
    property Entity : TUser read FEntity write FEntity;
  end;

implementation

uses
  REST.Json;

{ TUsersRESTObject }

constructor TUsersRESTObject.Create;
begin
  inherited;
  FEntity := TUser.Create;
end;

constructor TUsersRESTObject.Create(const p_JSON: string);
begin
  Create;
  FDTO := TJson.JsonToObject<TUsersDTO>(p_JSON);
  CreateFromDTO(FDTO);
end;

constructor TUsersRESTObject.Create(const p_User: TUsersDTO);
begin
  Create;
  CreateFromDTO(p_User);
end;

procedure TUsersRESTObject.CreateFromDTO(const p_User: TUsersDTO);
begin
  FEntity.UserName := p_User.UserName;
  FEntity.Password := p_User.Password;
end;

destructor TUsersRESTObject.Destroy;
begin
  FEntity.Free;
  FDTO.Free;
  inherited;
end;

function TUsersRESTObject.GetDTO: TUsersDTO;
begin
  FDTO.Free;
  FDTO := TUsersDTO.Create(FEntity);
  Result := FDTO;
end;

function TUsersRESTObject.GetJSONString: string;
begin
  FDTO.Free;
  FDTO := TUsersDTO.Create(FEntity);
  Result := TJson.ObjectToJsonString(FDTO);
end;

{ TUsersDTO }

constructor TUsersDTO.Create(const p_User: TUser);
begin
  inherited Create;
  Self.FUserName := p_User.UserName;
  Self.FPassword := p_User.Password;
end;

end.
