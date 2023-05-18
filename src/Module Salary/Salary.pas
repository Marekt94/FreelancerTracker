unit Salary;

interface

uses
  dorm.mappings;

type
  [Entity('SALARIES')]
  TSalary = class
  strict private
    FId: Integer;
    FMiesiac: Integer;
    FRok: Integer;
    FStawka : Single;
    FDniRoboczych : Integer;
    FDniPrzepracowanych : Integer;
    FSkladkaZdrowotna : Single;
    FZUS : Single;
    FNetto : Single;
    FPelneNetto : Single;
    FDoWyplaty : Single;
    FDoRozdysponowania : Single;
  public
    [Id]
    property Id: Integer read FId write FId;
    property Miesiac: Integer read FMiesiac write FMiesiac;
    property Rok: Integer read FRok write FRok;
    property Stawka             : Single  read FStawka             write FStawka;
    [Column('DNI_ROBOCZYCH')]
    property DniRoboczych       : Integer read FDniRoboczych       write FDniRoboczych;
    [Column('DNI_PRZEPRACOWANYCH')]
    property DniPrzepracowanych : Integer read FDniPrzepracowanych write FDniPrzepracowanych;
    [Column('SKLADKA_ZDROWOTNA')]
    property SkladkaZdrowotna   : Single  read FSkladkaZdrowotna   write FSkladkaZdrowotna;
    property ZUS                : Single  read FZUS                write FZUS;
    [Transient]
    property Netto              : Single  read FNetto              write FNetto;
    [Transient]
    property PelneNetto         : Single  read FPelneNetto         write FPelneNetto;
    [Transient]
    property DoWyplaty          : Single  read FDoWyplaty          write FDoWyplaty;
    [Transient]
    property DoRozdysponowania  : Single  read FDoRozdysponowania  write FDoRozdysponowania;
  end;

implementation

end.
