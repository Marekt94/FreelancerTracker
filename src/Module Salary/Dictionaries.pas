unit Dictionaries;

interface

type
  TMonthsRec = record
    ID : Integer;
    MonthName : String;
  end;

const
  MonthRecArray : array [0..11] of TMonthsRec = (
    (ID : 1;  MonthName : 'styczeñ'),
    (ID : 2;  MonthName : 'luty'),
    (ID : 3;  MonthName : 'marzec'),
    (ID : 4;  MonthName : 'kwiecieñ'),
    (ID : 5;  MonthName : 'maj'),
    (ID : 6;  MonthName : 'czerwiec'),
    (ID : 7;  MonthName : 'lipiec'),
    (ID : 8;  MonthName : 'sierpieñ'),
    (ID : 9;  MonthName : 'wrzesieñ'),
    (ID : 10; MonthName : 'paŸdziernik'),
    (ID : 11; MonthName : 'listopad'),
    (ID : 12; MonthName : 'grudzieñ')
  );

implementation

end.
