unit TaxEvaluatorStrategyController;

interface

uses
  InterfaceSalaryEvaluatorController, SalaryEntities;

type
  TTaxEvaluatorStrategyController = class(TInterfacedObject, ISalaryEvaluatorController)
  strict private
    FTaxEvaluator : ISalaryEvaluatorController;
    function GetTaxEvaluator (const p_FormaOpodatkownia : TFormaOpodatkowania): ISalaryEvaluatorController;
  public
    function Evaluate(var p_Salary : TSalary) : Boolean;
  end;

implementation

uses
  FlatTaxEvaluatorController, LumpSumEvaluatorController, SysUtils;

{ TFlatTaxEvaluatorController }

function TTaxEvaluatorStrategyController.Evaluate(var p_Salary: TSalary): Boolean;
var
  v_FormaOpodatkowania : TFormaOpodatkowania;
begin
  v_FormaOpodatkowania := p_Salary.FormaOpodatkowania;
  FTaxEvaluator := GetTaxEvaluator(v_FormaOpodatkowania);
  Result := FTaxEvaluator.Evaluate(p_Salary);
end;

function TTaxEvaluatorStrategyController.GetTaxEvaluator(const p_FormaOpodatkownia : TFormaOpodatkowania): ISalaryEvaluatorController;
begin
  case p_FormaOpodatkownia.IdFormy of
    FORMAOPODATKOWANIA_RYCZALT_INDEX:
      Result := TLumpSumEvaluatorController.Create;
    FORMAOPODATKOWANIA_SKALA_PODATKOWA_INDEX:
      ;
    FORMAOPODATKOWANIA_LINIOWY_INDEX:
      Result := TFlatTaxEvaluatorController.Create;
  else
    raise Exception.Create('No such forma opodatkowania');
  end;
end;

end.
