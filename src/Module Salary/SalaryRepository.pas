unit SalaryRepository;

interface

uses
  InterfaceSalaryRepository, System.Generics.Collections, SalaryEntities, dorm.Filters,
  RepositoryWrapper;

type
  TSalaryRepository = class(TRepositoryWrapper, ISalaryRepository)
  strict private
    FMonthsAvailableMock: TObjectList<TMonth>;
  public
    destructor Destroy; override;
    function Salaries(const UserID: Integer; const p_Year: Integer): TObjectList<TSalary>;
    function Salary(const p_ID: Integer; const UserID: Integer): TSalary;
    function AvailableMonths(const AYear: Integer; const UserID: Integer): TObjectList<TMonth>;
    procedure SaveOrUpdate(p_Obj: TSalary; const UserID: Integer);
    function Delete(p_ID: Integer; const UserID: Integer): boolean;

    function Get(const p_Id : Integer) : TSalary;
    function GetWhere(const p_ColumnsName : array of string;
                      const p_Compare : array of string;
                      const p_Values : array of const) : TSalary;
  end;

implementation

uses
  dorm.Query, System.SysUtils, dorm, Dictionaries;

{ TSalaryRepository }

destructor TSalaryRepository.Destroy;
begin
  FMonthsAvailableMock.Free;
  inherited;
end;

function TSalaryRepository.Get(const p_Id: Integer): TSalary;
begin
  Result := inherited Get<TSalary>(p_id);
end;

function TSalaryRepository.GetWhere(const p_ColumnsName,
  p_Compare: array of string; const p_Values: array of const): TSalary;
begin
  Result := inherited GetWhere<TSalary>(p_ColumnsName, p_Compare, p_Values);
end;

function TSalaryRepository.Salaries(const UserID: Integer; const p_Year: Integer): TObjectList<TSalary>;
begin
  if p_Year = -1 then
    Result := GetListWhere<TSalary>(['USER_ID'], ['='], [UserID]) as TObjectList<TSalary>
  else
    Result := GetListWhere<TSalary>(['ROK', 'USER_ID'], ['='], [p_Year, UserID]) as TObjectList<TSalary>;
end;

function TSalaryRepository.Salary(const p_ID: Integer; const UserID: Integer): TSalary;
begin
  Result := GetWhere(['ID', 'USER_ID'], ['=','='], [p_id, UserID]);
end;

function TSalaryRepository.AvailableMonths(const AYear: Integer; const UserID: Integer): TObjectList<TMonth>;
var
  pomMiesiace: TObjectList<TMonth>;
begin
  FMonthsAvailableMock.Free;
  FMonthsAvailableMock := TObjectList<TMonth>.Create;

  for var i := 0 to Length(MonthRecArray) - 1 do
    FMonthsAvailableMock.Add(TMonth.Create(MonthRecArray[i].ID, MonthRecArray[i].MonthName));

  if AYear <> -1 then
  begin
    pomMiesiace := GetListWhere<TMonth>(['ROK', 'USER_ID'], ['=', '='], [AYear, UserId]) as TObjectList<TMonth>;
    try
      for var pomMiesiac in pomMiesiace do
        for var i := FMonthsAvailableMock.Count - 1 downto 0 do // Iteracja od koñca dla bezpieczeñstwa usuwania elementów.
          if FMonthsAvailableMock[i].ID = pomMiesiac.ID then
          begin
            FMonthsAvailableMock.Delete(i);
            Break;
          end;
    finally
      pomMiesiace.Free;
    end;
  end;

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
  pomSalary := Salary(p_Id, UserID);

  Result := Assigned(pomSalary);
  if Result then
    Result := inherited Delete(pomSalary);
end;

end.

