unit SalaryRepository;

interface

uses
  InterfaceSalaryRepository, System.Generics.Collections, Salary;

type
  TSalaryRepository = class(TInterfacedObject, ISalaryRepository)
    function Salaries : TObjectList<TSalary>;
    function Salary(const p_ID : Integer) : TSalary;
  end;

implementation

uses
  dorm, System.Classes, dorm.Commons;

{ TSalaryRepository }

function TSalaryRepository.Salaries: TObjectList<TSalary>;
var
  pomSession : TSession;
begin
  pomSession := TSession.CreateConfigured(
    TStreamReader.Create('..\..\dorm.conf'), TdormEnvironment.deDevelopment);
  try
    Result := pomSession.LoadList<TSalary>;
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

end.
