unit InterfaceFormaOpodatkowaniaRepository;

interface

uses
  SalaryEntities;

type
  IFormaOpodatkowaniaRepository = interface
  ['{D86F9793-C303-439C-B371-8FBE8EF9C398}']
    function FormaOpodatkowania(const p_ID : Integer) : TFormaOpodatkowania;
  end;

implementation

end.
