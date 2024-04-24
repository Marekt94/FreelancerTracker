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
  Math;

{ TFlatTaxEvaluatorController }

function TFlatTaxEvaluatorController.Evaluate(var p_Salary: TSalary): Boolean;
const
  cDniuUrlopu = 26;
  cDniChorobowego = 12;
var
  p_DoWydania: Single;
  p_PelnyMiesiac: Single;
  p_DniWolneNaMiesiac: Single;
  p_WyplataNaDzien: Single;
begin
  if p_Salary.DniPrzepracowanych = 0 then
    exit;
  // pieni¹dze po op³aceniu wszystkich op³at
  p_DoWydania := p_Salary.Brutto - p_Salary.Vat - p_Salary.Podatek - p_Salary.ZUS - p_Salary.SkladkaZdrowotna;

  //ekstrapolacja - pieni¹dze, gdyby miesi¹c by³ pe³ny
  p_WyplataNaDzien := p_DoWydania / p_Salary.DniPrzepracowanych;
  p_PelnyMiesiac   := p_WyplataNaDzien * p_Salary.DniRoboczych;

  //po odliczeniu pieniedzy na urlop i chorobowe
  p_DniWolneNaMiesiac := (26 + 12) / 12;
  p_Salary.DoRozdysponowania := p_WyplataNaDzien * (p_Salary.DniRoboczych - p_DniWolneNaMiesiac);

  p_Salary.DoRozdysponowania := RoundTo(p_Salary.DoRozdysponowania, -2);
end;

end.
