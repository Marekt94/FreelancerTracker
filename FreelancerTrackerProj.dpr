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
  LumpSumEvaluatorController in 'src\Module Salary\LumpSumEvaluatorController.pas',
  InterfaceSalaryEvaluatorController in 'src\Module Salary\Interfaces\InterfaceSalaryEvaluatorController.pas',
  SalaryRESTObjects in 'src\Module Salary\SalaryRESTObjects.pas',
  SalaryDTOs in 'src\Module Salary\SalaryDTOs.pas',
  RESTLogger in 'src\Module Server\RESTLogger.pas',
  Dictionaries in 'src\Module Salary\Dictionaries.pas',
  UsersRepository in 'src\Module Auth\UsersRepository.pas',
  UsersEntities in 'src\Module Auth\UsersEntities.pas',
  InterfaceSessionsRepository in 'src\Module Auth\Interfaces\InterfaceSessionsRepository.pas',
  SessionsEntities in 'src\Module Auth\SessionsEntities.pas',
  SessionsRepository in 'src\Module Auth\SessionsRepository.pas',
  SessionsRESTController in 'src\Module Auth\SessionsRESTController.pas',
  SessionsRESTObjects in 'src\Module Auth\SessionsRESTObjects.pas',
  SessionsController in 'src\Module Auth\SessionsController.pas',
  InterfaceSessionsController in 'src\Module Auth\Interfaces\InterfaceSessionsController.pas',
  RESTObjects in 'src\Misc\RESTObjects.pas',
  ModuleAuth in 'src\Module Auth\ModuleAuth.pas',
  InterfaceModuleAuth in 'src\Module Auth\Interfaces\InterfaceModuleAuth.pas',
  InterfaceSalaryRepository in 'src\Module Salary\Interfaces\InterfaceSalaryRepository.pas',
  InterfaceUsersRepository in 'src\Module Auth\Interfaces\InterfaceUsersRepository.pas',
  SecurityController in 'src\Module Auth\SecurityController.pas',
  INIPreferenceRepository in '..\Kernel\src\Base classes\INIPreferenceRepository.pas',
  RESTControllerBase in 'src\Misc\RESTControllerBase.pas',
  InterfaceRESTMiddlewareCustomHeaderController in 'src\Module Server\Interfaces\InterfaceRESTMiddlewareCustomHeaderController.pas',
  InterfaceRESTMiddlewareLogger in 'src\Module Server\Interfaces\InterfaceRESTMiddlewareLogger.pas',
  InterfaceRESTMiddlewareWhiteListController in 'src\Module Server\Interfaces\InterfaceRESTMiddlewareWhiteListController.pas',
  RESTMiddlewareCustomHeaderController in 'src\Module Server\RESTMiddlewareCustomHeaderController.pas',
  RESTMiddlewareLogger in 'src\Module Server\RESTMiddlewareLogger.pas',
  RESTMiddlewareWhiteListController in 'src\Module Server\RESTMiddlewareWhiteListController.pas',
  RepositoryWrapper in 'src\Misc\RepositoryWrapper.pas',
  InterfaceRepositoryWrapper in 'src\Misc\Interfaces\InterfaceRepositoryWrapper.pas',
  FlatTaxEvaluatorController in 'src\Module Salary\FlatTaxEvaluatorController.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  MainKernel := TVCLKernel.Create (TFreelancerTrackerKernel.Create);
  MainKernel.PreferenceRepository := TPreferenceRepository.Create;
  if Supports(MainKernel, IVCLKernel) then
  begin
    (MainKernel as IVCLKernel).Open (TfrmMain, 'Freelancer Tracker Server');
    MainKernel.Close;
  end
end.
