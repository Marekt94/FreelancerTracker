unit Dictionaries;

interface

type
  TMonthsRec = record
    ID : Integer;
    MonthName : String;
  end;

const
  MonthRecArray : array [0..11] of TMonthsRec = (
    (ID : 1;  MonthName : 'stycze�'),
    (ID : 2;  MonthName : 'luty'),
    (ID : 3;  MonthName : 'marzec'),
    (ID : 4;  MonthName : 'kwiecie�'),
    (ID : 5;  MonthName : 'maj'),
    (ID : 6;  MonthName : 'czerwiec'),
    (ID : 7;  MonthName : 'lipiec'),
    (ID : 8;  MonthName : 'sierpie�'),
    (ID : 9;  MonthName : 'wrzesie�'),
    (ID : 10; MonthName : 'pa�dziernik'),
    (ID : 11; MonthName : 'listopad'),
    (ID : 12; MonthName : 'grudzie�')
  );

implementation

end.
