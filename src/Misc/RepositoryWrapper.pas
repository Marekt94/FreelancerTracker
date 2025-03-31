unit RepositoryWrapper;

interface

uses
  System.Generics.Collections, dorm.Commons;

const
  VALIDATE_ERROR = 'Validate error';

type
  TSteeringObj = class
  private
    FColumnsName: array of string;
    FCompare: array of string;
    FValues: TArray<TVarRec>;
  public
    constructor Create(const p_ColumnsName : array of string;
      const p_Compare : array of string; const p_Values : array of const);
  end;

  TRepositoryWrapper = class(TInterfacedObject, IInterface)
  strict private
    FConfPath : string;
    FEnvironment : TdormEnvironment;
    function ColumnsNameToString(const p_ColumnsName : array of string; const p_Compare : array of string) : string;
    function Validate(p_SteeringObj: TSteeringObj): boolean;
  public
    constructor Create;

    function Get<TObjClass: class>(const p_Id : Integer) : TObjClass; overload;
    function GetWhere<TObjClass: class>(const p_ColumnsName : array of string;
                                        const p_Compare : array of string;
                                        const p_Values : array of const) : TObjClass;
    function GetListWhere<TObjClass: class>(const p_ColumnsName : array of string;
                                        const p_Compare : array of string;
                                        const p_Values : array of const) : TList<TObjClass>;
    function SaveOrUpdate(const p_Obj : TObject) : boolean;
    function Delete(const p_Obj : TObject) : boolean;

    procedure SetEnvironment(const p_Env : Integer);
    property ConfPath: String write FConfPath;
    property Environment: Integer write SetEnvironment;
  end;

implementation

uses
  dorm.Query, dorm, System.Classes, System.SysUtils;

{ TRepositoryWrapper }

function TRepositoryWrapper.ColumnsNameToString(const p_ColumnsName : array of string; const p_Compare : array of string) : string;
const
  cPattern = '(%s %s ?) AND ';
begin
  for var i := 0 to Length(p_ColumnsName) - 1 do
    Result := Result + Format(cPattern, [p_ColumnsName[i], p_Compare[i]]);
  Result := Copy(Result, 0, Length(Result) - 5)
end;

constructor TRepositoryWrapper.Create;
begin
  FConfPath := '..\..\dorm.conf';
  FEnvironment := deDevelopment;
end;

function TRepositoryWrapper.Delete(const p_Obj : TObject) : boolean;
var
  pomSession : TSession;
begin
  pomSession := TSession.CreateConfigured(
    TStreamReader.Create(FConfPath), FEnvironment);
  try
    pomSession.Delete(p_Obj);
  finally
    pomSession.Free;
  end;

  Result := true;
end;

function TRepositoryWrapper.Get<TObjClass>(const p_Id : Integer) : TObjClass;
begin
  Result := GetWhere<TObjClass>(['ID'], ['='], [p_Id]);
end;

function TRepositoryWrapper.GetListWhere<TObjClass>(const p_ColumnsName : array of string;
                                        const p_Compare : array of string;
                                        const p_Values : array of const) : TList<TObjClass>;
var
  pomSession : TSession;
  pomSteeringObj: TSteeringObj;
  pomRes: boolean;
begin
  pomSteeringObj := TSteeringObj.Create(p_ColumnsName, p_Compare, p_Values);
  try
    pomRes := Validate(pomSteeringObj);
    if not pomRes then
      raise Exception.Create(VALIDATE_ERROR);
  finally
    FreeAndNil(pomSteeringObj);
  end;

  pomSession := TSession.CreateConfigured(
    TStreamReader.Create(FConfPath), FEnvironment);
  try
    Result := pomSession.LoadListSQL<TObjClass>(
      Select
      .From(TObjClass)
      .Where(ColumnsNameToString(p_ColumnsName, p_Compare), p_Values)
      );
  finally
    pomSession.Free;
  end;
end;

function TRepositoryWrapper.GetWhere<TObjClass>(const p_ColumnsName : array of string;
                                        const p_Compare : array of string;
                                        const p_Values : array of const) : TObjClass;
var
  pomSession : dorm.TSession;
  pomSteeringObj: TSteeringObj;
  pomRes: boolean;
begin
  pomSteeringObj := TSteeringObj.Create(p_ColumnsName, p_Compare, p_Values);
  try
    pomRes := Validate(pomSteeringObj);
    if not pomRes then
      raise Exception.Create(VALIDATE_ERROR);
  finally
    FreeAndNil(pomSteeringObj);
  end;

  pomSession := dorm.TSession.CreateConfigured(
    TStreamReader.Create(FConfPath), FEnvironment);
  try
    Result := pomSession.Load<TObjClass>(
      Select
      .From(TObjClass)
      .Where(ColumnsNameToString(p_ColumnsName, p_Compare), p_Values)
      );
  finally
    pomSession.Free;
  end;
end;

function TRepositoryWrapper.SaveOrUpdate(const p_Obj : TObject) : boolean;
var
  pomSession : dorm.TSession;
begin
  pomSession := dorm.TSession.CreateConfigured(
    TStreamReader.Create(FConfPath), FEnvironment);
  try
    Result := Assigned(pomSession.Persist(p_Obj));
  finally
    pomSession.Free;
  end;
end;

procedure TRepositoryWrapper.SetEnvironment(const p_Env: Integer);
begin
  FEnvironment := TdormEnvironment(p_Env);
end;

function TRepositoryWrapper.Validate(p_SteeringObj: TSteeringObj): boolean;
begin
  Result := (Length(p_SteeringObj.FColumnsName) = Length(p_SteeringObj.FCompare))
     and (Length(p_SteeringObj.FCompare) = Length(p_SteeringObj. FValues))
end;

{ TSteeringObj }

constructor TSteeringObj.Create(const p_ColumnsName, p_Compare: array of string;
  const p_Values: array of const);
var
  i: Integer;
begin
  SetLength(FColumnsName, Length(p_ColumnsName));
  SetLength(FCompare, Length(p_Compare));
  SetLength(FValues, Length(p_Values));

  for i := 0 to Length(p_ColumnsName) -1 do
    FColumnsName[i] := p_ColumnsName[i];

  for i := 0 to Length(p_Compare) - 1 do
    FCompare[i] := p_Compare[i];

  for i := 0 to Length(p_Values) - 1 do
    FValues[i] := p_Values[i];
end;

end.
