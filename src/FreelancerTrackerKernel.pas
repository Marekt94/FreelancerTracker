unit FreelancerTrackerKernel;

interface

uses
  InterfaceKernel, BaseKernel, InterfaceModule, System.Generics.Collections;

const
  VERSION = 5.0;

{
  VER 3.0:
  - v2 API,
  VER 4.0:
  - 64bit compatibility,
  - Delphi 12 compatibility,
  - TLS 1.3 not supported
  VER 4.1:
  - Allow-origin header changes
  VER 5.0:
  - mutiuser support,
  - mem leaks fix
  - v1 API deleted
}

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
