unit RESTObjects;

interface

type
  TExecute<TDTORequest, TDTOResponse> = reference to procedure (const p_Request  : TDTORequest;
                                                                var   p_Response : TDTOResponse;
                                                                out   p_ErrorMessage : string);

  TRESTObject<TDTORequest : class, constructor; TDTOResponse : class, constructor> = class
  strict private
    FFreeDTORequest : boolean;
    FDTORequest : TDTORequest;
    FDTORespone : TDTOResponse;
    FExecute : TExecute<TDTORequest, TDTOResponse>;
    FErrorMessage : string;
    function GetDTO : TDTOResponse;
    function GetJSONString: string;
  public
    destructor Destroy; override;
    constructor Create(const p_DTORequest : TDTORequest; p_Execute : TExecute<TDTORequest, TDTOResponse>); overload;
    constructor Create(const p_DTORequestJson : string; p_Execute : TExecute<TDTORequest, TDTOResponse>); overload;
    property DTOResponse : TDTOResponse read GetDTO;
    property DTOResponseJSONString : string read GetJSONString;
    property ErrorMessage: string read FErrorMessage;
  end;

implementation

uses
  REST.Json;

{ TRESTObject<TDTORequest, TDTOResponse> }

constructor TRESTObject<TDTORequest, TDTOResponse>.Create(
  const p_DTORequest: TDTORequest;
  p_Execute: TExecute<TDTORequest, TDTOResponse>);
begin
  FDTORequest := p_DTORequest;
  FExecute := p_Execute;
end;

constructor TRESTObject<TDTORequest, TDTOResponse>.Create(
  const p_DTORequestJson: string;
  p_Execute: TExecute<TDTORequest, TDTOResponse>);
var
  pomTemp : TDTORequest;
begin
  FFreeDTORequest := true;
  pomTemp := TJson.JsonToObject<TDTORequest>(p_DTORequestJson);
  Create(pomTemp, p_Execute);
end;

destructor TRESTObject<TDTORequest, TDTOResponse>.Destroy;
begin
  if FFreeDTORequest then
    FDTORequest.Free;
  FDTORespone.Free;
  inherited;
end;

function TRESTObject<TDTORequest, TDTOResponse>.GetDTO: TDTOResponse;
begin
  if not Assigned(FDTORespone) then
  begin
    FDTORespone := TDTOResponse.Create;
    FExecute(FDTORequest, FDTORespone, FErrorMessage);
  end;

  Result := FDTORespone;
end;

function TRESTObject<TDTORequest, TDTOResponse>.GetJSONString: string;
begin
  if not Assigned(FDTORespone) then
  begin
    FDTORespone := TDTOResponse.Create;
    FExecute(FDTORequest, FDTORespone, FErrorMessage);
  end;

  Result := TJson.ObjectToJsonString(FDTORespone);
end;

end.
