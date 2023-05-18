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
  ModuleServer;

{ TFreelancerTrackerKernel }

procedure TFreelancerTrackerKernel.RegisterModules(
  p_ModuleList: TList<IModule>);
begin
  inherited;
  p_ModuleList.Add(TModuleServer.Create);
end;

end.
