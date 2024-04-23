unit LumpSumEvaluatorController;

interface

uses
  InterfaceSalaryEvaluatorController, SalaryEntities;

type
  TLumpSumEvaluatorController = class(TInterfacedObject, ISalaryEvaluatorController)
  strict private
    function EvaluateNetto(const p_Rate : Double; const p_WorkingHours : Integer; const p_WorkingDays : Integer) : Double;
    function EvaluatePayCheck(const p_Netto : Double; const p_Tax : TWysokoscPodatku; const p_Zus : Double; const p_HealthTax : Double) : Double;
    function EvaluateRealPayCheck(const p_Rate : Double;
                                  const p_WorkingHours : Integer;
                                  const p_WorkingDays : Integer;
                                  const p_MonthsOnB2BInYear : Integer;
                                  const p_VacationDays : Integer;
                                  const p_IllDays : Integer;
                                  const p_Tax : TWysokoscPodatku;
                                  const p_Zus : Double;
                                  const p_HealthTax : Double) : DOuble;
  public
     function Evaluate(var p_Salary : TSalary) : Boolean;
  end;

implementation

{ TSalaryEvaluatorController }

function TLumpSumEvaluatorController.Evaluate(var p_Salary: TSalary): Boolean;
begin
  p_Salary.PelneNetto := EvaluateNetto(p_Salary.Stawka, 8, p_Salary.DniRoboczych);
  p_Salary.Netto      := EvaluateNetto(p_Salary.Stawka, 8, p_Salary.DniPrzepracowanych);
  p_Salary.DoWyplaty  := EvaluatePayCheck(p_Salary.Netto, p_Salary.FormaOpodatkowania.WysokoscPodatkuList[0], p_Salary.ZUS, p_Salary.SkladkaZdrowotna);
  p_Salary.DoRozdysponowania
    := EvaluateRealPayCheck(p_Salary.Stawka,
                            8,
                            p_Salary.DniRoboczych,
                            12,
                            26,
                            12,
                            p_Salary.FormaOpodatkowania.WysokoscPodatkuList[0],
                            p_Salary.ZUS,
                            p_Salary.SkladkaZdrowotna);
  Result := True;
end;

function TLumpSumEvaluatorController.EvaluateNetto(const p_Rate : Double; const p_WorkingHours : Integer; const p_WorkingDays : Integer) : Double;
begin
  Result := p_Rate * p_WorkingHours * p_WorkingDays;
end;

function TLumpSumEvaluatorController.EvaluatePayCheck(const p_Netto : Double; const p_Tax : TWysokoscPodatku; const p_Zus : Double; const p_HealthTax : Double) : Double;
begin
  Result := p_Netto * (1 - (p_Tax.Stawka/100)) - p_Zus - p_HealthTax;
end;

function TLumpSumEvaluatorController.EvaluateRealPayCheck(const p_Rate : Double;
                                  const p_WorkingHours : Integer;
                                  const p_WorkingDays : Integer;
                                  const p_MonthsOnB2BInYear : Integer;
                                  const p_VacationDays : Integer;
                                  const p_IllDays : Integer;
                                  const p_Tax : TWysokoscPodatku;
                                  const p_Zus : Double;
                                  const p_HealthTax : Double) : DOuble;
var
  pomFreeDaysPerMonthOnB2B : Double;
begin
  pomFreeDaysPerMonthOnB2B := (p_VacationDays + p_IllDays)/p_MonthsOnB2BInYear * 1.0;
  Result := EvaluatePayCheck(p_Rate * p_WorkingHours * (p_WorkingDays - pomFreeDaysPerMonthOnB2B),
                             p_Tax,
                             p_Zus,
                             p_HealthTax);
end;

end.
