unit FreelancerTrackerKernel;

interface

uses
  InterfaceKernel, BaseKernel, InterfaceModule, System.Generics.Collections;

type
  TFreelancerTrackerKernel = class(TContainer, IContainer)
    procedure RegisterModules (p_ModuleList : TList<IModule>); override;
  end;

implementation

uses
  ModuleServer, ModuleSalary, ModuleAuth;

{ TFreelancerTrackerKernel }

procedure TFreelancerTrackerKernel.RegisterModules(
  p_ModuleList: TList<IModule>);
begin
  inherited;
  p_ModuleList.Add(TModuleSalary.Create);
  p_ModuleList.Add(TModuleServer.Create);
  p_ModuleList.Add(TModuleAuth.Create);
end;

end.
