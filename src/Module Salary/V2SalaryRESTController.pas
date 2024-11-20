unit V2SalaryRESTController;

interface

uses
  MiniREST.Attribute, MiniREST.Common, MiniREST.Intf, RESTControllerBase;

type
  TV2SalaryRESTController = class(TRESTControllerBase)
  public
    [RequestMapping('v2/salaries')]
    procedure GetSalaries;
    [RequestMapping('v2/salaries/{id}')]
    procedure GetSalary;
    [RequestMapping('v2/forma_podatkowa/{id}')]
    procedure GetFormaPodatkowa;
    [RequestMapping('v2/forma_podatkowa')]
    procedure GetFormyPodatkowe;
    [RequestMapping('v2/evaluate', '', rmPost)]
    procedure Evaluate;
    [RequestMapping('v2/salaries', '', rmPost)]
    procedure SaveSalary;
    [RequestMapping('v2/get_data_for_new_salary/{year}')]
    procedure GetDataForNewSalary;
    [RequestMapping('v2/delete_salary/{id}'), '', rmPost]
    procedure DeleteSalary;
  end;

implementation

uses
  InterfaceKernel, InterfaceSalaryRepository, REST.JSON, System.JSON, SalaryRESTObjects,
  SalaryEntities, SalaryDTOs, System.Generics.Collections, System.SysUtils, InterfaceFormaOpodatkowaniaRepository,
  InterfaceSalaryEvaluatorController;

{ TV2SalaryRESTController }

procedure TV2SalaryRESTController.DeleteSalary;
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

procedure TV2SalaryRESTController.Evaluate;
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

procedure TV2SalaryRESTController.GetDataForNewSalary;
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

procedure TV2SalaryRESTController.GetFormaPodatkowa;
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

procedure TV2SalaryRESTController.GetFormyPodatkowe;
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

procedure TV2SalaryRESTController.GetSalaries;
var
  pomObjectList : TList<TSalary>;
  pomJsonArray : TJSONArray;
  pomQueryParamYear: IMiniRESTQueryParam;
  pomYear: Integer;
begin
  try
    pomQueryParamYear := GetActionContext.GetQueryParam('year');
    if Assigned(pomQueryParamYear) then
      pomYear := StrToInt(pomQueryParamYear.GetValue)
    else
      pomYear := DEF_YEAR;
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

procedure TV2SalaryRESTController.GetSalary;
var
  pomSalary : TSalary;
  pomSalaryDTO : TSalaryDTO;
begin
  try
    pomSalary := (MainKernel.GiveObjectByInterface(ISalaryRepository) as ISalaryRepository).Salary(StrToInt(PathVariable('id')));
    try
      if Assigned(pomSalary) then
        pomSalaryDTO := TSalaryDTO.Create(pomSalary)
      else
        pomSalaryDTO := nil;
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

procedure TV2SalaryRESTController.SaveSalary;
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
