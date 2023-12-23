unit RESTLogger;

interface

uses
  TLoggerUnit, MiniREST.Intf, System.SysUtils;

type
  TRESTLoggger = class (TInterfacedObject, IMiniRESTLogger)
  strict private
    FLogger : TLogger;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Info(AInfo : string);
    procedure Debug(ADebug : string);
    procedure Warn(AWarn : string);
    procedure Exception(AMsg : string; AException : Exception);
  end;

implementation

uses
  TLevelUnit, TFileAppenderUnit, TPatternLayoutUnit;

{ TRESTLoggger }

var
  gLogger : IMiniRESTLogger;

constructor TRESTLoggger.Create;
begin
  TLoggerUnit.initialize;
  FLogger := TLogger.GetInstance('Freelancer Tracker REST logger');
  if FLogger.GetAllAppenders.Count = 0 then
    FLogger.AddAppender(TFileAppender.Create('Freelancer Tracker REST logger.log', TPatternLayout.Create('%d [%5p] %m%n')));
end;

procedure TRESTLoggger.Debug(ADebug: string);
begin
  FLogger.Debug(ADebug);
end;

destructor TRESTLoggger.Destroy;
begin
  TLogger.FreeInstances;
  inherited;
end;

procedure TRESTLoggger.Exception(AMsg: string; AException: Exception);
begin
  FLogger.Log(OFF, AMsg, AException);
end;

procedure TRESTLoggger.Info(AInfo: string);
begin
  FLogger.Info(AInfo);
end;

procedure TRESTLoggger.Warn(AWarn: string);
begin
  FLogger.Warn(AWarn);
end;

end.
