unit InterfaceRepositoryWrapper;

interface

type
  IRepositoryWrapper = interface(IInterface)
    ['{295DF4F8-8B9C-4945-9BB3-FAC3D9B97B29}']
    function Get(const p_Id : Integer) : TObject;
    function GetWhere(const p_ColumnsName : array of string;
                      const p_Compare : array of string;
                      const p_Values : array of const) : TObject;
    function SaveOrUpdate(const p_Obj : TObject) : boolean;
    function Delete(const p_Obj : TObject) : boolean;
  end;

implementation

end.
