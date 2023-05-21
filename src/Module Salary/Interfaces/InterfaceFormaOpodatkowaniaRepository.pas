unit InterfaceFormaOpodatkowaniaRepository;

interface

uses
  SalaryEntities, System.Generics.Collections;

type
  IFormaOpodatkowaniaRepository = interface
  ['{D86F9793-C303-439C-B371-8FBE8EF9C398}']
    function FormaOpodatkowania(const p_ID : Integer) : TFormaOpodatkowania; overload;
    function FormaOpodatkowania : TList<TFormaOpodatkowania>; overload;
  end;

implementation

end.
