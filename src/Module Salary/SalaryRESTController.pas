unit SalaryRESTController;

interface

uses
  MiniREST.Controller.Base, MiniREST.Attribute;

type
  TSalaryRESTController = class(TMiniRESTControllerBase)
  public
    [RequestMapping('/salary')]
    procedure GetSalary;
  end;

implementation

uses
  InterfaceKernel, InterfaceSalaryRepository, REST.JSON, System.JSON;

{ TSalaryRESTController }

procedure TSalaryRESTController.GetSalary;
var
  pomString : TJSONObject;
begin
  pomString := TJson.ObjectToJsonObject ((MainKernel.GiveObjectByInterface(ISalaryRepository) as ISalaryRepository).Salaries);
  pomString.RemovePair('ownsObjects');
  Response(pomString.ToString);
end;

end.
