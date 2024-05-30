unit SessionsEntities;

interface

uses
  dorm.Mappings, UsersEntities;

type
  [Entity('SESSION')]
  TSession = class(TObject)
  strict private
    FId : integer;
    FUserId : Integer;
    FUser : TUser;
    FSession : string;
    FExpirationDate : TDateTime;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetUser(const AUser : TUser);
    [Id]
    property Id: integer read FId write FId;
    [BelongsTo('UserId')]
    property User: TUser read FUser write SetUser;
    property Session: string read FSession write FSession;
    [Column('USER_ID')]
    property UserID: Integer read FUserID write FUserID;
    [Column('EXPIRATION_DATE')]
    property ExpirationDate: TDateTime read FExpirationDate write FExpirationDate;
  end;

implementation

{ TSession }

constructor TSession.Create;
begin
  FUser := TUser.Create;
end;

destructor TSession.Destroy;
begin
  FUser.Free;
  inherited;
end;

procedure TSession.SetUser(const AUser: TUser);
begin
  FUser.Free;
  FUser := AUser;
end;

end.
