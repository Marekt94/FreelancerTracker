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
    [RequestMapping('/forma_podatkowa')]
    procedure GetFormyPodatkowe;
    [RequestMapping('/evaluate', '', rmPost)]
    procedure Evaluate;
    [RequestMapping('/save_salary', '', rmPost)]
    procedure SaveSalary;
  end;

implementation

uses
  InterfaceKernel, InterfaceSalaryRepository, REST.JSON, System.JSON, SalaryRESTObjects,
  SalaryEntities, SalaryDTOs, System.Generics.Collections, System.SysUtils, InterfaceFormaOpodatkowaniaRepository,
  InterfaceSalaryEvaluatorController;

{ TSalaryRESTController }

procedure TSalaryRESTController.Evaluate;
var
  pomContoller : ISalaryEvaluatorController;
  pomSalary : TSalaryRESTObject;
begin
  var pom := GetActionContext.GetRequestContentAsString;
  pomSalary := TSalaryRESTObject.Create(pom);
  try
    pomContoller := (MainKernel.GiveObjectByInterface(ISalaryEvaluatorController) as ISalaryEvaluatorController);
    var pomSalaryTemp := pomSalary.Entity;
    pomContoller.Evaluate(pomSalaryTemp);
    ResponseJson(pomSalary.DTOJSONString);
  finally
    pomSalary.Free;
  end;
end;

procedure TSalaryRESTController.GetFormaPodatkowa;
var
  pomFormaOpodatkowania : TFormaOpodatkowania;
  pomFormaOpodatkowaniaDTO : TFormaOpodatkowaniaDTO;
begin
  pomFormaOpodatkowania := (MainKernel.GiveObjectByInterface(IFormaOpodatkowaniaRepository) as IFormaOpodatkowaniaRepository).FormaOpodatkowania(StrToInt(PathVariable('id')));
  try
    pomFormaOpodatkowaniaDTO := TFormaOpodatkowaniaDTO.Create(pomFormaOpodatkowania);
    try
      ResponseJson(TJson.ObjectToJsonString(pomFormaOpodatkowaniaDTO));
    finally
      pomFormaOpodatkowaniaDTO.Free;
    end;
  finally
    pomFormaOpodatkowania.Free;
  end;
end;

procedure TSalaryRESTController.GetFormyPodatkowe;
var
  pomFormaOpodatkowania : TList<TFormaOpodatkowania>;
  pomJsonArray : TJSONArray;
begin
  pomFormaOpodatkowania := (MainKernel.GiveObjectByInterface(IFormaOpodatkowaniaRepository) as IFormaOpodatkowaniaRepository).FormaOpodatkowania;
  pomJsonArray := TJSONArray.Create;
  try
    for var i := 0 to pomFormaOpodatkowania.Count - 1 do
    begin
      var pomDTO := TFormaOpodatkowaniaDTO.Create(pomFormaOpodatkowania[i]);
      try
        var pomJson := TJson.ObjectToJsonObject(pomDTO);
        pomJsonArray.Add(pomJson);
      finally
        pomDTO.Free;
      end;
    end;

    try
      ResponseJson(pomJsonArray.ToJSON);
    finally
      pomFormaOpodatkowania.Free;
    end;
  finally
    pomJsonArray.Free;
  end;

end;

procedure TSalaryRESTController.GetSalaries;
var
  pomObjectList : TList<TSalary>;
  pomJsonArray : TJSONArray;
begin
  pomObjectList := (MainKernel.GiveObjectByInterface(ISalaryRepository) as ISalaryRepository).Salaries;

  pomJsonArray := TJSONArray.Create;
  try
    for var i := 0 to pomObjectList.Count - 1 do
    begin
      var pomDTO := TSalaryDTO.Create(pomObjectList[i]);
      try
        var pomJson := TJson.ObjectToJsonObject(pomDTO);
        pomJsonArray.Add(pomJson);
      finally
        pomDTO.Free;
      end;
    end;

    try
      ResponseJson(pomJsonArray.ToJSON);
    finally
      pomObjectList.Free;
    end;
  finally
    pomJsonArray.Free;
  end;
end;

procedure TSalaryRESTController.GetSalary;
var
  pomSalary : TSalary;
begin
  pomSalary := (MainKernel.GiveObjectByInterface(ISalaryRepository) as ISalaryRepository).Salary(StrToInt(PathVariable('id')));
  try
    var pomSalaryDTO := TSalaryDTO.Create(pomSalary);
    try
      ResponseJson(TJson.ObjectToJsonString(pomSalaryDTO));
    finally
      pomSalaryDTO.Free;
    end;
  finally
    pomSalary.Free;
  end;
end;

procedure TSalaryRESTController.SaveSalary;
var
  pomSalary : TSalaryRESTObject;
  pomRepo : ISalaryRepository;
begin
  pomSalary := TSalaryRESTObject.Create(GetActionContext.GetRequestContentAsString);
  try
    pomRepo := (MainKernel.GiveObjectByInterface(ISalaryRepository) as ISalaryRepository);
    pomRepo.SaveOrUpdate(pomSalary.Entity);
  finally
    pomSalary.Free;
  end;
end;

end.
