unit InterfaceSalaryEvaluatorController;

interface

uses
  SalaryEntities;

type
  ISalaryEvaluatorController = interface
    ['{B89BCCA0-F18C-41C3-84B1-7D0FB533EE66}']
    function Evaluate(var p_Salary : TSalary) : Boolean;
  end;

implementation

end.
