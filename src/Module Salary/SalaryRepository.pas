unit SalaryRepository;

interface

uses
  InterfaceSalaryRepository, System.Generics.Collections, SalaryEntities, dorm.Filters,
  DatabaseSessionManager;

type
  TSalaryRepository = class(TInterfacedObject, ISalaryRepository)
  strict private
    FMonthsAvailableMock: TObjectList<TMonth>;
    function LoadFilteredList<T: class>(const SQLFilter: string; const Params: array of const): TObjectList<T>;
    function LoadSingle<T: class>(const SQLFilter: string; const Params: array of const): T;
  public
    destructor Destroy; override;
    function Salaries(const UserID: Integer; const p_Year: Integer): TObjectList<TSalary>;
    function Salary(const p_ID: Integer; const UserID: Integer): TSalary;
    function AvailableMonths(const AYear: Integer; const UserID: Integer): TObjectList<TMonth>;
    procedure SaveOrUpdate(p_Obj: TSalary; const UserID: Integer);
    function Delete(p_ID: Integer; const UserID: Integer): boolean;
  end;

implementation

uses
  dorm.Query, System.SysUtils, dorm;

{ TSalaryRepository }

destructor TSalaryRepository.Destroy;
begin
  FMonthsAvailableMock.Free;
  inherited;
end;

function TSalaryRepository.LoadFilteredList<T>(const SQLFilter: string; const Params: array of const): TObjectList<T>;
var
  Session: TSession;
begin
  Session := TDatabaseSessionManager.CreateSession;
  try
    Result := Session.LoadListSQL<T>(
      Select.From(T).Where(SQLFilter, Params)
    );
  finally
    Session.Free;
  end;
end;

function TSalaryRepository.LoadSingle<T>(const SQLFilter: string; const Params: array of const): T;
var
  Session: TSession;
begin
  Session := TDatabaseSessionManager.CreateSession;
  try
//    Result := Session.LoadSQL<T>(
//      Select.From(T).Where(SQLFilter, Params)
//    );
  finally
    Session.Free;
  end;
end;

function TSalaryRepository.Salaries(const UserID: Integer; const p_Year: Integer): TObjectList<TSalary>;
begin
  if p_Year = -1 then
    Result := LoadFilteredList<TSalary>('USER_ID = ?', [UserID])
  else
    Result := LoadFilteredList<TSalary>('ROK = ? AND USER_ID = ?', [p_Year, UserID]);
end;

function TSalaryRepository.Salary(const p_ID: Integer; const UserID: Integer): TSalary;
begin
  Result := LoadSingle<TSalary>('ID = ? AND USER_ID = ?', [p_ID, UserID]);
end;

function TSalaryRepository.AvailableMonths(const AYear: Integer; const UserID: Integer): TObjectList<TMonth>;
var
  pomMiesiace: TObjectList<TMonth>;
begin
  FMonthsAvailableMock.Free;
  FMonthsAvailableMock := TObjectList<TMonth>.Create;

//  for var i := 0 to Length(MonthRecArray) - 1 do
//    FMonthsAvailableMock.Add(TMonth.Create(MonthRecArray[i].ID, MonthRecArray[i].MonthName));
//
//  if AYear <> -1 then
//  begin
//    pomMiesiace := LoadFilteredList<TMonth>('ROK = ? AND USER_ID = ?', [AYear, UserID]);
//    try
//      for var pomMiesiac in pomMiesiace do
//        for var i := FMonthsAvailableMock.Count - 1 downto 0 do // Iteracja od koñca dla bezpieczeñstwa usuwania elementów.
//          if FMonthsAvailableMock[i].ID = pomMiesiac.ID then
//          begin
//            FMonthsAvailableMock.Delete(i);
//            Break;
//          end;
//    finally
//      pomMiesiace.Free;
//    end;
//  end;

  Result := FMonthsAvailableMock;
end;

procedure TSalaryRepository.SaveOrUpdate(p_Obj: TSalary; const UserID: Integer);
var
  Session : TSession;
begin
//  p_Obj.UserID := UserID; // Przypisanie identyfikatora u¿ytkownika
//
//  Session := TDatabaseSessionManager.CreateSession;
//  try
//    Session.Persist(p_Obj);
//  finally
//    Session.Free;
//  end;
end;

function TSalaryRepository.Delete(p_ID: Integer; const UserID: Integer): boolean;
var
  pomSalary : TSalary;
begin
  pomSalary := LoadSingle<TSalary>('ID = ? AND USER_ID = ?', [p_ID, UserID]);

  Result := Assigned(pomSalary);
  if Result then
  begin
    var Session := TDatabaseSessionManager.CreateSession;
    try
      Session.Delete(pomSalary);
    finally
      Session.Free;
    end;
  end;
end;

end.

