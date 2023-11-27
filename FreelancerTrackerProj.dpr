program FreelancerTrackerProj;


uses
  Vcl.Forms,
  System.SysUtils,
  InterfaceKernel in '..\Kernel\src\Interfaces\InterfaceKernel.pas',
  VCLKernel in '..\Kernel\src\VCL\VCLKernel.pas',
  InterfaceVCLKernel in '..\Kernel\src\VCL\Interfaces\InterfaceVCLKernel.pas',
  FreelancerTrackerKernel in 'src\FreelancerTrackerKernel.pas',
  Main in 'src\Frames\Main.pas' {frmMain: TFrame},
  ModuleServer in 'src\Module Server\ModuleServer.pas',
  InterfaceModuleServer in 'src\Module Server\Interfaces\InterfaceModuleServer.pas',
  InterfaceModuleSalary in 'src\Module Salary\Interfaces\InterfaceModuleSalary.pas',
  SalaryRESTController in 'src\Module Salary\SalaryRESTController.pas',
  SalaryEntities in 'src\Module Salary\SalaryEntities.pas',
  SalaryRepository in 'src\Module Salary\SalaryRepository.pas',
  ModuleSalary in 'src\Module Salary\ModuleSalary.pas',
  InterfaceFormaOpodatkowaniaRepository in 'src\Module Salary\Interfaces\InterfaceFormaOpodatkowaniaRepository.pas',
  FormaOpodatkowaniaRepository in 'src\Module Salary\FormaOpodatkowaniaRepository.pas',
  SalaryEvaluatorController in 'src\Module Salary\SalaryEvaluatorController.pas',
  InterfaceSalaryEvaluatorController in 'src\Module Salary\Interfaces\InterfaceSalaryEvaluatorController.pas',
  SalaryRESTObjects in 'src\Module Salary\SalaryRESTObjects.pas',
  SalaryDTOs in 'src\Module Salary\SalaryDTOs.pas',
  RESTLogger in 'src\Module Server\RESTLogger.pas',
  Dictionaries in 'src\Module Salary\Dictionaries.pas',
  InterfaceUsersRepository in 'InterfaceUsersRepository.pas',
  UsersRepository in 'src\Module Auth\UsersRepository.pas',
  InterfaceSalaryRepository in 'src\Module Auth\Interfaces\InterfaceSalaryRepository.pas',
  UsersEntities in 'src\Module Auth\UsersEntities.pas',
  InterfaceSessionsRepository in 'src\Module Auth\Interfaces\InterfaceSessionsRepository.pas',
  SessionsEntities in 'src\Module Auth\SessionsEntities.pas',
  SessionsRepository in 'src\Module Auth\SessionsRepository.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  MainKernel := TVCLKernel.Create (TFreelancerTrackerKernel.Create);
  if Supports(MainKernel, IVCLKernel) then
  begin
    (MainKernel as IVCLKernel).Open (TfrmMain, 'Freelancer Tracker Server');
    MainKernel.Close;
  end
end.
