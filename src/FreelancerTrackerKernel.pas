unit FreelancerTrackerKernel;

interface

uses
  InterfaceKernel, BaseKernel, InterfaceModule, System.Generics.Collections;

const
  VERSION = 2.0;

type
  TFreelancerTrackerKernel = class(TContainer, IContainer)
    procedure RegisterModules (p_ModuleList : TList<IModule>); override;
    function GetVersion : Double;
  end;

implementation

uses
  ModuleServer, ModuleSalary, ModuleAuth;

{ TFreelancerTrackerKernel }

function TFreelancerTrackerKernel.GetVersion: Double;
begin
  Result := VERSION;
end;

procedure TFreelancerTrackerKernel.RegisterModules(
  p_ModuleList: TList<IModule>);
begin
  inherited;
  p_ModuleList.Add(TModuleSalary.Create);
  p_ModuleList.Add(TModuleServer.Create);
  p_ModuleList.Add(TModuleAuth.Create);
end;

end.
