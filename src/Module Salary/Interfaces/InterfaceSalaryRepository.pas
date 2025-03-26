unit InterfaceSalaryRepository;

interface

uses
  System.Generics.Collections, SalaryEntities;

const
  DEF_YEAR = -1;

type
  ISalaryRepository = interface
    ['{19CFF87E-5B3E-4A14-A893-9C9D45F3AC96}']
    function Salaries(const UserID: Integer; const p_Year : integer = DEF_YEAR) : TObjectList<TSalary>;
    function Salary(const p_ID : Integer; const UserID: Integer) : TSalary;
    function AvailableMonths(const p_Year : Integer; const UserID: Integer) : TObjectList<TMonth>;
    procedure SaveOrUpdate(p_Obj : TSalary; const UserID: Integer);
    function Delete(p_ID : Integer; const UserID: Integer) : boolean;
  end;

implementation

end.
