unit UsersEntities;

interface

uses
  dorm.Mappings;

type
  [Entity('USERS')]
  TUser = class
  strict private
    FID : Integer;
    FUserName: string;
    FPassword: string;
  public
    [Id]
    property ID: integer read FID write FID;
    [Column('USER_NAME')]
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
  end;

implementation

end.
