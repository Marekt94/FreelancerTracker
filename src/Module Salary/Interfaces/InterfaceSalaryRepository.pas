unit InterfaceSalaryRepository;

interface

uses
  System.Generics.Collections, Salary;

type
  ISalaryRepository = interface
    ['{19CFF87E-5B3E-4A14-A893-9C9D45F3AC96}']
    function Salaries : TObjectList<TSalary>;
  end;

implementation

end.
