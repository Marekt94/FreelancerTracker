unit InterfaceSalaryRepository;

interface

uses
  System.Generics.Collections, SalaryEntities;

type
  ISalaryRepository = interface
    ['{19CFF87E-5B3E-4A14-A893-9C9D45F3AC96}']
    function Salaries : TObjectList<TSalary>;
    function Salary(const p_ID : Integer) : TSalary;
    function AvailableMonths(const p_Year : Integer) : TObjectList<TMonth>;
    procedure SaveOrUpdate(p_Obj : TSalary);
  end;

implementation

end.
