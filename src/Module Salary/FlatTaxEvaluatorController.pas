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

uses
  Math, SalaryConst;

{ TFlatTaxEvaluatorController }

function TFlatTaxEvaluatorController.Evaluate(var p_Salary: TSalary): Boolean;
var
  p_DoWydania: Single;
  p_DniWolneNaMiesiac: Single;
  p_WyplataNaDzien: Single;
begin
  Result := True;
  if p_Salary.DniPrzepracowanych = 0 then
    exit;

  if p_Salary.Brutto = 0 then
    p_Salary.Brutto := (p_Salary.DniRoboczych * p_Salary.Stawka * WORK_HOURS) * (1 + VAT_RATE/100);

  // pieni¹dze po op³aceniu wszystkich op³at
  p_DoWydania := p_Salary.Brutto - p_Salary.Vat - p_Salary.Podatek - p_Salary.ZUS - p_Salary.SkladkaZdrowotna;

  //ekstrapolacja - pieni¹dze, gdyby miesi¹c by³ pe³ny
  p_WyplataNaDzien := p_DoWydania / p_Salary.DniPrzepracowanych;

  //po odliczeniu pieniedzy na urlop i chorobowe
  p_DniWolneNaMiesiac := (HOLIDAY_DAYS_PER_YEAR + SICK_LEAVE_DAYS_PER_YEAR) / MONTH_PER_YEAR;
  p_Salary.DoRozdysponowania := p_WyplataNaDzien * (p_Salary.DniRoboczych - p_DniWolneNaMiesiac);

  p_Salary.DoRozdysponowania := RoundTo(p_Salary.DoRozdysponowania, -2);
  p_Salary.DoWyplaty := RoundTo(p_DoWydania, -2);
end;

end.
