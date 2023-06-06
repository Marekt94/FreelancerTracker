unit SalaryRepository;

interface

uses
  InterfaceSalaryRepository, System.Generics.Collections, SalaryEntities;

type
  TSalaryRepository = class(TInterfacedObject, ISalaryRepository)
  strict private
    FMonthsAvailableMock : TObjectList<TMonth>;
  public
    destructor Destroy; override;
    function Salaries(const p_Year : Integer = -1) : TObjectList<TSalary>;
    function Salary(const p_ID : Integer) : TSalary;
    function AvailableMonths(const p_Year : Integer) : TObjectList<TMonth>;
    procedure SaveOrUpdate(p_Obj : TSalary);
  end;

implementation

uses
  dorm, System.Classes, dorm.Commons, Dictionaries, dorm.Query;

{ TSalaryRepository }

destructor TSalaryRepository.Destroy;
begin
  if Assigned(FMonthsAvailableMock) then
    FMonthsAvailableMock.Free;
  inherited;
end;

function TSalaryRepository.AvailableMonths(const p_Year : Integer) : TObjectList<TMonth>;
begin
  if not Assigned(FMonthsAvailableMock) then
  begin
    FMonthsAvailableMock := TObjectList<TMonth>.Create;
    for var i := 0 to Length(MonthRecArray) - 1 do
      FMonthsAvailableMock.Add(TMonth.Create(MonthRecArray[i].ID, MonthRecArray[i].MonthName));
  end;
  Result := FMonthsAvailableMock;
end;

function TSalaryRepository.Salaries(const p_Year : Integer = -1): TObjectList<TSalary>;
var
  pomSession : TSession;
begin
  pomSession := TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  try
    if (p_Year = -1) then
      Result := pomSession.LoadList<TSalary>
    else
      Result := pomSession.LoadListSQL<TSalary>(
        Select
        .From(TSalary)
        .Where('ROK = ?', [p_Year])
        );
  finally
    pomSession.Free;
  end;
end;

function TSalaryRepository.Salary(const p_ID: Integer): TSalary;
var
  pomSession : TSession;
begin
  pomSession := TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  try
    Result := pomSession.Load<TSalary>(p_Id);
  finally
    pomSession.Free;
  end;
end;

procedure TSalaryRepository.SaveOrUpdate(p_Obj: TSalary);
var
  pomSession : TSession;
begin
  pomSession := TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  try
    pomSession.Persist(p_Obj);
  finally
    pomSession.Free;
  end;
end;

end.
