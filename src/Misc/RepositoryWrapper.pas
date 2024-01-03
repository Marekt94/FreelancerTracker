unit RepositoryWrapper;

interface

uses
  System.Generics.Collections, dorm.Commons;

type
  TRepositoryWrapper = class(TInterfacedObject, IInterface)
  strict private
    FConfPath : string;
    FEnvironment : TdormEnvironment;
    function ColumnsNameToString(const p_ColumnsName : array of string; const p_Compare : array of string) : string;
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
begin
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
begin
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
    pomSession.Persist(p_Obj);
  finally
    pomSession.Free;
  end;
end;

procedure TRepositoryWrapper.SetEnvironment(const p_Env: Integer);
begin
  FEnvironment := TdormEnvironment(p_Env);
end;

end.
