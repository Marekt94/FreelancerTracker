unit ModuleSalary;

interface

uses
  Module, InterfaceModuleSalary;

type
  TModuleSalary = class(TBaseModule, IModuleSalary)
  public
    function GetSelfInterface : TGUID; override;
    procedure RegisterClasses; override;
    function OpenModule : boolean; override;
  end;

implementation

uses
  MiniREST.Server.Intf, InterfaceKernel,
  InterfaceSalaryRepository, SalaryRepository, InterfaceFormaOpodatkowaniaRepository,
  FormaOpodatkowaniaRepository, InterfaceSalaryEvaluatorController, TaxEvaluatorStrategyController,
  V2SalaryRESTController;

{ TModuleSalary }

function TModuleSalary.GetSelfInterface: TGUID;
begin
  Result := IModuleSalary;
end;

function TModuleSalary.OpenModule: boolean;
begin
  Result := inherited;
  if Result then
    (MainKernel.GiveObjectByInterface(IMiniRESTServer) as IMiniRESTServer).AddController(TV2SalaryRESTController);
end;

procedure TModuleSalary.RegisterClasses;
begin
  inherited;
  RegisterClass(ISalaryRepository, TSalaryRepository, []);
  RegisterClass(IFormaOpodatkowaniaRepository, TFormaOpodatkowaniaRepository, []);
  RegisterClass(ISalaryEvaluatorController, TTaxEvaluatorStrategyController, []);
end;

end.
