unit SessionsRESTObjects;

interface

uses
  UsersEntities;

type
  TUsersDTORequest = class
  strict private
    FUserName : string;
    FPassword : string;
  public
    constructor Create(const p_User : TUser); overload;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
  end;

  TSessionDTOResponse = class
  private
    FSessionID : string;
  public
    property SessionID : string read FSessionID write FSessionID;
  end;

  TUsersRESTObject = class
  strict private
    FEntity : TUser;
    FDTO : TUsersDTORequest;
    procedure CreateFromDTO(const p_User : TUsersDTORequest);
    function GetDTO: TUsersDTORequest;
    function GetJSONString: string;
  public
    constructor Create; overload;
    constructor Create(const p_JSON : string); overload;
    constructor Create(const p_User : TUsersDTORequest); overload;
    destructor Destroy; override;
    property DTO : TUsersDTORequest read GetDTO;
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
  FDTO := TJson.JsonToObject<TUsersDTORequest>(p_JSON);
  CreateFromDTO(FDTO);
end;

constructor TUsersRESTObject.Create(const p_User: TUsersDTORequest);
begin
  Create;
  CreateFromDTO(p_User);
end;

procedure TUsersRESTObject.CreateFromDTO(const p_User: TUsersDTORequest);
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

function TUsersRESTObject.GetDTO: TUsersDTORequest;
begin
  FDTO.Free;
  FDTO := TUsersDTORequest.Create(FEntity);
  Result := FDTO;
end;

function TUsersRESTObject.GetJSONString: string;
begin
  FDTO.Free;
  FDTO := TUsersDTORequest.Create(FEntity);
  Result := TJson.ObjectToJsonString(FDTO);
end;

{ TUsersDTO }

constructor TUsersDTORequest.Create(const p_User: TUser);
begin
  inherited Create;
  Self.FUserName := p_User.UserName;
  Self.FPassword := p_User.Password;
end;

end.
