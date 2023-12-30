unit SalaryRESTController;

interface

uses
  MiniREST.Attribute, MiniREST.Common, MiniREST.Intf, RESTControllerBase;

type
  TSalaryRESTController = class(TRESTControllerBase)
  public
    [RequestMapping('/salaries/{year}')]
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
    [RequestMapping('/get_data_for_new_salary/{year}')]
    procedure GetDataForNewSalary;
    [RequestMapping('/delete_salary/{id}'), rmDelete]
    procedure DeleteSalary;
  end;

implementation

uses
  InterfaceKernel, InterfaceSalaryRepository, REST.JSON, System.JSON, SalaryRESTObjects,
  SalaryEntities, SalaryDTOs, System.Generics.Collections, System.SysUtils, InterfaceFormaOpodatkowaniaRepository,
  InterfaceSalaryEvaluatorController;

{ TSalaryRESTController }

procedure TSalaryRESTController.DeleteSalary;
var
  pomRes : Boolean;
begin
  try
    pomRes := (MainKernel.GiveObjectByInterface(ISalaryRepository) as ISalaryRepository).Delete(StrToInt(PathVariable('id')));
    if pomRes then
      ResponseStatus('ok')
    else
      ResponseStatus('object does not exist');
  except
    on E : Exception do
    begin
      ResponseErro(E.Message);
      GetLogger.Exception('[TSalaryRESTController.DeleteSalary]', E);
    end;
  end;
end;

procedure TSalaryRESTController.Evaluate;
var
  pomContoller : ISalaryEvaluatorController;
  pomSalary : TSalaryRESTObject;
begin
  try
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
  except
    on E : Exception do
    begin
      ResponseErro(E.Message);
      GetLogger.Exception('[TSalaryRESTController.Evaluate]', E);
    end;
  end;
end;

procedure TSalaryRESTController.GetDataForNewSalary;
var
  pomObj : TDataForNewSalaryRestObject;
begin
  try
    pomObj := TDataForNewSalaryRestObject.Create(StrToInt(PathVariable('year')));
    try
      ResponseJson(pomObj.DTOJSONString);
    finally
      pomObj.Free;
    end;
  except
    on E : Exception do
    begin
      ResponseErro(E.Message);
      GetLogger.Exception('[TSalaryRESTController.GetDataForNewSalary]', E);
    end;
  end;
end;

procedure TSalaryRESTController.GetFormaPodatkowa;
var
  pomFormaOpodatkowania : TFormaOpodatkowania;
  pomFormaOpodatkowaniaDTO : TFormaOpodatkowaniaDTO;
begin
  try
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
  except
    on E : Exception do
    begin
      ResponseErro(E.Message);
      GetLogger.Exception('[TSalaryRESTController.GetFormaPodatkowa]', E);
    end;
  end;
end;

procedure TSalaryRESTController.GetFormyPodatkowe;
var
  pomFormaOpodatkowania : TList<TFormaOpodatkowania>;
  pomJsonArray : TJSONArray;
begin
  try
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
  except
    on E : Exception do
    begin
      ResponseErro(E.Message);
      GetLogger.Exception('[TSalaryRESTController.GetFormyPodatkowe]', E);
    end;
  end;
end;

procedure TSalaryRESTController.GetSalaries;
var
  pomObjectList : TList<TSalary>;
  pomJsonArray : TJSONArray;
begin
  try
    var pomYear := StrToInt(GetActionContext.GetPathVariable('year'));
    pomObjectList := (MainKernel.GiveObjectByInterface(ISalaryRepository) as ISalaryRepository).Salaries(pomYear);

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
  except
    on E : Exception do
    begin
      ResponseErro(E.Message);
      GetLogger.Exception('[TSalaryRESTController.GetSalaries]', E);
    end;
  end;
end;

procedure TSalaryRESTController.GetSalary;
var
  pomSalary : TSalary;
begin
  try
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
  except
    on E : Exception do
    begin
      ResponseErro(E.Message);
      GetLogger.Exception('[TSalaryRESTController.GetSalary]', E);
    end;
  end;
end;

procedure TSalaryRESTController.SaveSalary;
var
  pomSalary : TSalaryRESTObject;
  pomRepo : ISalaryRepository;
begin
  try
    pomSalary := TSalaryRESTObject.Create(GetActionContext.GetRequestContentAsString);
    try
      pomRepo := (MainKernel.GiveObjectByInterface(ISalaryRepository) as ISalaryRepository);
      pomRepo.SaveOrUpdate(pomSalary.Entity);
      var pomResponse := TJSONObject.Create;
      try
        pomResponse.AddPair('id', TJSONNumber.Create(pomSalary.Entity.Id));
        ResponseJson(pomResponse.ToString, 201);
      finally
        pomResponse.Free;
      end;
    finally
      pomSalary.Free;
    end;
  except
    on E : Exception do
    begin
      ResponseErro(E.Message);
      GetLogger.Exception('[TSalaryRESTController.SaveSalary]', E);
    end;
  end;
end;

end.
