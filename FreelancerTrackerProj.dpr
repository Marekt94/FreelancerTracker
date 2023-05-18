program FreelancerTrackerProj;



uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Vcl.Forms,
  System.SysUtils,
  InterfaceKernel in '..\Kernel\src\Interfaces\InterfaceKernel.pas',
  VCLKernel in '..\Kernel\src\VCL\VCLKernel.pas',
  InterfaceVCLKernel in '..\Kernel\src\VCL\Interfaces\InterfaceVCLKernel.pas',
  FreelancerTrackerKernel in 'src\FreelancerTrackerKernel.pas',
  Main in 'src\Frames\Main.pas' {frmMain: TFrame},
  ModuleServer in 'src\Module Server\ModuleServer.pas',
  InterfaceModuleServer in 'src\Module Server\Interfaces\InterfaceModuleServer.pas',
  ModuleSalary in 'src\Module Salary\ModuleSalary.pas',
  InterfaceModuleSalary in 'src\Module Salary\Interfaces\InterfaceModuleSalary.pas',
  SalaryRESTController in 'src\Module Salary\SalaryRESTController.pas',
  InterfaceSalaryRepository in 'src\Module Salary\Interfaces\InterfaceSalaryRepository.pas',
  Salary in 'src\Module Salary\Salary.pas',
  SalaryRepository in 'src\Module Salary\SalaryRepository.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  MainKernel := TVCLKernel.Create (TFreelancerTrackerKernel.Create);
  if Supports(MainKernel, IVCLKernel) then
  begin
    (MainKernel as IVCLKernel).Open (TfrmMain, 'Freelancer Tracker');
    MainKernel.Close;
  end
end.
