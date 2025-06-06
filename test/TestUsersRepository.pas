unit TestUsersRepository;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, dorm, dorm.mappings, UsersRepository, InterfaceUsersRepository,
  UsersEntities, RepositoryWrapper, SessionsEntities, SessionsRepository, InterfaceSessionsRepository;

type
  // Test methods for class TUsersRepository

  TestTUsersRepository = class(TTestCase)
  strict private
    FUsersRepository: TUsersRepository;
    FSession: TSession;
    FSessionRep: ISessionsRepository;
    FUser: TUser;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestGetUserIdBySessionId;
    procedure TestGetMinusOneWhenNoUserToSessionId;
  end;

implementation

const
  cSessionNum = 'testSession123';

procedure TestTUsersRepository.SetUp;
begin
  FUser := TUser.Create;
  FUser.UserName := 'testName';
  FUser.Password := 'testPass';

  FUsersRepository := TUsersRepository.Create;
  FUsersRepository.SaveOrUpdate(FUser);
end;

procedure TestTUsersRepository.TearDown;
begin
  FUsersRepository.Delete(FUser);
  FUser.Free;
  FUsersRepository.Free;
  FUsersRepository := nil;
end;

procedure TestTUsersRepository.TestGetUserIdBySessionId;
var
  ReturnValue: Integer;
  pomUser: TUser;
begin
  FSession := TSession.Create;
  try
    pomUser := TUser.Create;
    pomUser.ID := FUser.ID;
    pomUser.UserName := FUser.UserName;
    pomUser.Password := FUser.Password;

    FSession.Id := 0;
    FSession.Session := cSessionNum;
    FSession.UserID := FUser.ID;
    FSession.SetUser(pomUser);
    FSession.ExpirationDate := 12-12-2030;

    FSessionRep := TSessionsRepository.Create;
    FSessionRep.SaveOrUpdate(FSession);

    ReturnValue := FUsersRepository.GetUserIdBySessionId(cSessionNum);

    CheckTrue(FSession.UserId = ReturnValue);

    FSessionRep.Delete(FSession);
  finally
    FSession.Free;
  end;
end;

procedure TestTUsersRepository.TestGetMinusOneWhenNoUserToSessionId;
const
  cMissingSessinNum = 'noSessionNum';
var
  ReturnValue: Integer;
  p_Session: string;
begin
  ReturnValue := FUsersRepository.GetUserIdBySessionId(cMissingSessinNum);
  CheckTrue(ReturnValue = EMPTY_USER_ID);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTUsersRepository.Suite);
end.

