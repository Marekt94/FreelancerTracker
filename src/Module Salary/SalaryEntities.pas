unit SalaryEntities;

interface

uses
  dorm.mappings, System.Generics.Collections;

type
  [Entity('WYSOKOSC_PODATKU')]
  TWysokoscPodatku = class
  protected
    FId: Integer;
    FStawka: Double;
    FFormaOpodatkowniaId: Integer;
  public
    [Id]
    property Id: Integer read FId write FId;
    property Stawka: Double read FStawka write FStawka;
    [Column('ID_FORMA_OPODATKOWANIA')]
    property FormaOpodatkowniaId: Integer read FFormaOpodatkowniaId write FFormaOpodatkowniaId;
  end;

  [ListOf('SalaryEntities.TWysokoscPodatku')]
  TWysokoscPodatkuList = class (TObjectList<TWysokoscPodatku>)
  end;

  [Entity('FORMA_OPODATKOWANIA')]
  TFormaOpodatkowania = class
  protected
    FIdFormy: Integer;
    FWysokoscPodatkuList: TWysokoscPodatkuList;
    FNazwa: string;
  public
    constructor Create;
    destructor Destroy; override;
    [Id]
    [Column('ID')]
    property IdFormy: Integer read FIdFormy write FIdFormy;
    [HasMany('FormaOpodatkowniaId')]
    property WysokoscPodatkuList: TWysokoscPodatkuList read FWysokoscPodatkuList write FWysokoscPodatkuList;
    property Nazwa: string read FNazwa write FNazwa;
  end;

  [Entity('SALARIES')]
  TSalary = class
  protected
    FId: Integer;
    FMiesiac: Integer;
    FRok: Integer;
    FIdFormyOpodatkowania : Integer;
    FFormaOpodatkowania: TFormaOpodatkowania;
    FStawka : Single;
    FDniRoboczych : Integer;
    FDniPrzepracowanych : Integer;
    FSkladkaZdrowotna : Single;
    FZUS : Single;
    FNetto : Single;
    FPelneNetto : Single;
    FDoWyplaty : Single;
    FDoRozdysponowania : Single;
    FZablokowane : Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    [Id]
    property Id: Integer read FId write FId;
    property Miesiac: Integer read FMiesiac write FMiesiac;
    property Rok: Integer read FRok write FRok;
    [Column('ID_FORMA_OPODATKOWANIA')]
    property IdFormyOpodatkowania : Integer read FIdFormyOpodatkowania write FIdFormyopodatkowania;
    [BelongsTo('IdFormyOpodatkowania')]
    property FormaOpodatkowania : TFormaOpodatkowania read FFormaOpodatkowania write FFormaOpodatkowania;
    property Stawka             : Single  read FStawka             write FStawka;
    [Column('DNI_ROBOCZYCH')]
    property DniRoboczych       : Integer read FDniRoboczych       write FDniRoboczych;
    [Column('DNI_PRZEPRACOWANYCH')]
    property DniPrzepracowanych : Integer read FDniPrzepracowanych write FDniPrzepracowanych;
    [Column('SKLADKA_ZDROWOTNA')]
    property SkladkaZdrowotna   : Single  read FSkladkaZdrowotna   write FSkladkaZdrowotna;
    property ZUS                : Single  read FZUS                write FZUS;
    property Netto              : Single  read FNetto              write FNetto;
    [Column('PELNE_NETTO')]
    property PelneNetto         : Single  read FPelneNetto         write FPelneNetto;
    [Column('DO_WYPLATY')]
    property DoWyplaty          : Single  read FDoWyplaty          write FDoWyplaty;
    [Column('DO_ROZDYSPONOWANIA')]
    property DoRozdysponowania  : Single  read FDoRozdysponowania  write FDoRozdysponowania;
    property Zablokowane        : Boolean read FZablokowane        write FZablokowane;
  end;

implementation

{ TSalary }

constructor TSalary.Create;
begin
  FFormaOpodatkowania := TFormaOpodatkowania.Create;
end;

destructor TSalary.Destroy;
begin
  FFormaOpodatkowania.Free;
end;

{ TFormaOpodatkowania }

constructor TFormaOpodatkowania.Create;
begin
  FWysokoscPodatkuList := TWysokoscPodatkuList.Create;
end;

destructor TFormaOpodatkowania.Destroy;
begin
  FWysokoscPodatkuList.Free;
end;

end.
