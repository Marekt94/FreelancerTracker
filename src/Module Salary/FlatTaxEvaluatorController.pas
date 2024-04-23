unit FlatTaxEvaluatorController;

interface

uses
  InterfaceSalaryEvaluatorController, SalaryEntities;

type
  TFlatTaxEvaluatorController = class(TInterfacedObject, ISalaryEvaluatorController)
  public
    function Evaluate(var p_Salary : TSalary) : Boolean;
  end;

implementation

{ TFlatTaxEvaluatorController }

function TFlatTaxEvaluatorController.Evaluate(var p_Salary: TSalary): Boolean;
begin

end;

end.
