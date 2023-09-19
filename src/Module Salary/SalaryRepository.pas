unit SalaryRepository;

interface

uses
  InterfaceSalaryRepository, System.Generics.Collections, SalaryEntities, dorm.Filters,
  System.TypInfo;

type
  TSalaryRepository = class(TInterfacedObject, ISalaryRepository)
  strict private
    FMonthsAvailableMock : TObjectList<TMonth>;
  public
    destructor Destroy; override;
    function Salaries(const p_Year : Integer = -1) : TObjectList<TSalary>;
    function Salary(const p_ID : Integer) : TSalary;
    function AvailableMonths(const AYear : Integer) : TObjectList<TMonth>;
    procedure SaveOrUpdate(p_Obj : TSalary);
    function Delete(p_ID : Integer) : boolean;
  end;

implementation

uses
  dorm, System.Classes, dorm.Commons, Dictionaries, dorm.Query, System.SysUtils;

{ TSalaryRepository }

function TSalaryRepository.Delete(p_ID: Integer): boolean;
var
  pomSession : TSession;
  pomSalary  : TSalary;
begin
  pomSession := TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  try
    pomSalary := pomSession.Load<TSalary>(p_ID);
    Result := Assigned(pomSalary);
    if Result then
      pomSession.Delete(pomSalary)
  finally
    pomSession.Free;
  end;
end;

destructor TSalaryRepository.Destroy;
begin
  FMonthsAvailableMock.Free;
  inherited;
end;

function TSalaryRepository.AvailableMonths(const AYear : Integer) : TObjectList<TMonth>;
var
  pomSession : TSession;
  pomMiesiace : TObjectList<TMonth>;
begin
  FMonthsAvailableMock.Free;
  FMonthsAvailableMock := TObjectList<TMonth>.Create;

  for var i := 0 to Length(MonthRecArray) - 1 do
    FMonthsAvailableMock.Add(TMonth.Create(MonthRecArray[i].ID, MonthRecArray[i].MonthName));

  if (AYear <> -1) then
  begin
    pomSession := TSession.CreateConfigured(
      TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
    try
      pomMiesiace := pomSession.LoadListSQL<TMonth>(
        Select
        .From(TMonth)
        .Where('ROK = ?', [AYear])
        );
      try
        for var pomMiesiac in pomMiesiace do
          for var i := 0 to FMonthsAvailableMock.Count - 1 do
            if FMonthsAvailableMock[i].ID = pomMiesiac.ID then
            begin
              FMonthsAvailableMock.Delete(i);
              break
            end;
      finally
        pomMiesiace.Free;
      end;
    finally
      pomSession.Free;
    end;
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
