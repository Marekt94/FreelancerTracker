unit ModuleSalary;

interface

uses
  Module, InterfaceModuleSalary;

type
  TModuleSalary = class(TBaseModule, IModuleSalary)
  public
    function GetSelfInterface : TGUID; override;
    function OpenMainWindow : Integer; override;
    procedure RegisterClasses; override;
    function OpenModule : boolean; override;
  end;

implementation

uses
  MiniREST.Server.Intf, SalaryRESTController, InterfaceKernel, InterfaceSalaryRepository, SalaryRepository;

{ TModuleSalary }

function TModuleSalary.GetSelfInterface: TGUID;
begin
  Result := IModuleSalary;
end;

function TModuleSalary.OpenMainWindow: Integer;
begin
  Result := inherited;
end;

function TModuleSalary.OpenModule: boolean;
begin
  Result := inherited;
  if Result then
    (MainKernel.GiveObjectByInterface(IMiniRESTServer) as IMiniRESTServer).AddController(TSalaryRESTController);
  (MainKernel.GiveObjectByInterface(ISalaryRepository) as ISalaryRepository).Salaries;
end;

procedure TModuleSalary.RegisterClasses;
begin
  inherited;
  RegisterClass(ISalaryRepository, TSalaryRepository);
end;

end.
