unit SalaryRepository;

interface

uses
  InterfaceSalaryRepository, System.Generics.Collections, SalaryEntities;

type
  TSalaryRepository = class(TInterfacedObject, ISalaryRepository)
    function Salaries : TObjectList<TSalary>;
    function Salary(const p_ID : Integer) : TSalary;
    procedure SaveOrUpdate(p_Obj : TSalary);
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
