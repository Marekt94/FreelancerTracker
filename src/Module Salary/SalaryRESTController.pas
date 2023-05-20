unit SalaryRESTController;

interface

uses
  MiniREST.Controller.Base, MiniREST.Attribute, MiniREST.Common;

type
  TSalaryRESTController = class(TMiniRESTControllerBase)
  public
    [RequestMapping('/salary')]
    procedure GetSalaries;
    [RequestMapping('/salary/{id}')]
    procedure GetSalary;
    [RequestMapping('/forma_podatkowa/{id}')]
    procedure GetFormaPodatkowa;
    [RequestMapping('/evaluate', '', rmPost)]
    procedure Evaluate;
    [RequestMapping('/Test', '', rmPost)]
    procedure Test;
  end;

implementation

uses
  InterfaceKernel, InterfaceSalaryRepository, REST.JSON, System.JSON, Salary,
  System.Generics.Collections, System.SysUtils, InterfaceFormaOpodatkowaniaRepository,
  InterfaceSalaryEvaluatorController, SalaryDTO;

{ TSalaryRESTController }

procedure TSalaryRESTController.Evaluate;
var
  pomContoller : ISalaryEvaluatorController;
  pomSalary : TSalary;
begin
  pomContoller := (MainKernel.GiveObjectByInterface(ISalaryEvaluatorController) as ISalaryEvaluatorController);
  var pom := GetActionContext.GetRequestContentAsString;
  pomSalary := TJson.JsonToObject<TSalary>(pom);
  try
//  pomSalary.FormaOpodatkowania.WysokoscPodatkuList.Add(TWysokoscPodatku.Create);
//  pomSalary.FormaOpodatkowania.WysokoscPodatkuList[0].Stawka := 12;
//  pomContoller.Evaluate(pomSalary);
    ResponseJson(TJson.ObjectToJsonString(pomSalary));
  finally
    pomSalary.Free;
  end;
end;

procedure TSalaryRESTController.GetFormaPodatkowa;
var
  pomFormaOpodatkowania : TFormaOpodatkowania;
begin
  pomFormaOpodatkowania := (MainKernel.GiveObjectByInterface(IFormaOpodatkowaniaRepository) as IFormaOpodatkowaniaRepository).FormaOpodatkowania(StrToInt(PathVariable('id')));
  try
    ResponseJson(TJson.ObjectToJsonString(pomFormaOpodatkowania));
  finally
    pomFormaOpodatkowania.Free;
  end;
end;

procedure TSalaryRESTController.GetSalaries;
var
  pomObjectList : TList<TSalary>;
begin
  pomObjectList := (MainKernel.GiveObjectByInterface(ISalaryRepository) as ISalaryRepository).Salaries;
  try
    ResponseJson(TJson.ObjectToJsonString (pomObjectList));
  finally
    pomObjectList.Free;
  end;
end;

procedure TSalaryRESTController.GetSalary;
var
  pomSalary : TSalary;
begin
  pomSalary := (MainKernel.GiveObjectByInterface(ISalaryRepository) as ISalaryRepository).Salary(StrToInt(PathVariable('id')));
  try
    ResponseJson(TJson.ObjectToJsonString(pomSalary));
  finally
    pomSalary.Free;
  end;
end;

procedure TSalaryRESTController.Test;
var
  pomSalaryDTO : TFormaOpodatkowaniaDTO;
begin
  var pom := GetActionContext.GetRequestContentAsString;
  pomSalaryDTO := TJSon.JsonToObject<TFormaOpodatkowaniaDTO>(pom);
  try
    ResponseJson(TJson.ObjectToJsonString(pomSalaryDTO));
  finally
    pomSalaryDTO.Free;
  end;
end;

end.
