unit PSQLQueryTest;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, Db, Windows, PSQLAccess, ExtCtrls, Controls, Classes, PSQLDbTables,
  PSQLTypes, SysUtils, DbCommon, Variants, Graphics, StdVCL, TestExtensions,
  Forms, PSQLConnFrm;

type
  //Setup decorator
  TDbSetup = class(TTestSetup)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  end;

  // Test methods for class TPSQLQuery
  TestTPSQLQuery = class(TTestCase)
  strict private
    FPSQLQuery: TPSQLQuery;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
  //dataset options
    procedure TestEmptyCharAsNullOption;
  //TField.AsXXX
    procedure TestAsInteger;
    procedure TestAsFloat;
    procedure TestAsString;
    procedure TestAsBoolean;
    procedure TestAsTime;
    procedure TestAsDate;
    procedure TestAsTimestamp;
  //RequestLive modifications
    procedure TestInsert;
    procedure TestUpdate;
    procedure TestDelete;
  //bookmarks
    procedure TestBookmarks;
  //locate
    procedure TestLocateStr;
    procedure TestLocateInt;
  end;

var
  QryDB: TPSQLDatabase;

implementation

uses TestHelper, DateUtils;

procedure TestTPSQLQuery.SetUp;
begin
  FPSQLQuery := TPSQLQuery.Create(nil);
  FPSQLQuery.Database := QryDB;
  FPSQLQuery.ParamCheck := False;
end;

procedure TestTPSQLQuery.TearDown;
begin
  FPSQLQuery.Free;
  FPSQLQuery := nil;
end;

procedure TestTPSQLQuery.TestAsBoolean;
begin
 FPSQLQuery.SQL.Text := 'SELECT True, False';
 FPSQLQuery.Open;
 Check(FPSQLQuery.Fields[0].AsBoolean and not FPSQLQuery.Fields[1].AsBoolean, 'Field value AsBoolean is incorrect');
 FPSQLQuery.Close;
end;

procedure TestTPSQLQuery.TestAsDate;
begin
 FPSQLQuery.SQL.Text := 'SELECT current_date';
 FPSQLQuery.Open;
 Check(IsToday(FPSQLQuery.Fields[0].AsDateTime), 'Field value AsDate is incorrect');
 FPSQLQuery.Close
end;

procedure TestTPSQLQuery.TestAsFloat;
const D: Double = 12.8;
begin
 FPSQLQuery.SQL.Text := 'SELECT 12.8';
 FPSQLQuery.Open;
 Check(FPSQLQuery.Fields[0].AsFloat = D, 'Field value AsFloat is incorrect');
 FPSQLQuery.Close;
end;

procedure TestTPSQLQuery.TestAsInteger;
begin
 FPSQLQuery.SQL.Text := 'SELECT 12345';
 FPSQLQuery.Open;
 Check(FPSQLQuery.Fields[0].AsInteger = 12345, 'Field value AsInteger is incorrect');
 FPSQLQuery.Close;
end;

procedure TestTPSQLQuery.TestAsString;
begin
 FPSQLQuery.SQL.Text := 'SELECT ''foo''::varchar(30)';
 FPSQLQuery.Open;
 Check(FPSQLQuery.Fields[0].AsString = 'foo', 'Field value AsString is incorrect');
 FPSQLQuery.Close;
end;

procedure TestTPSQLQuery.TestAsTime;
var ClientTime, ServerTime: TTime;
begin
 FPSQLQuery.SQL.Text := 'SELECT LOCALTIME';
 FPSQLQuery.Open;
 ClientTime := Time();
 ServerTime := TimeOf(FPSQLQuery.Fields[0].AsDateTime);
 Check(MinutesBetween(ClientTime, ServerTime) < 1, 'Field value AsTime is incorrect');
 FPSQLQuery.Close
end;

procedure TestTPSQLQuery.TestAsTimestamp;
begin
 FPSQLQuery.SQL.Text := 'SELECT LOCALTIMESTAMP';
 FPSQLQuery.Open;
 Check(MinutesBetween(Now(), FPSQLQuery.Fields[0].AsDateTime) < 1, 'Field value AsTimestamp is incorrect');
 FPSQLQuery.Close
end;

procedure TestTPSQLQuery.TestBookmarks;
var
   B: TBookmark;
   BookmarkedPos: longint;
begin
  FPSQLQuery.SQL.Text := 'SELECT * FROM generate_series(1, 10)';
  FPSQLQuery.Open;
  FPSQLQuery.MoveBy(5);
  B := FPSQLQuery.GetBookmark;
  BookmarkedPos := FPSQLQuery.RecNo;
  FPSQLQuery.First;
  FPSQLQuery.GotoBookmark(B);
  Check(FPSQLQuery.RecNo = BookmarkedPos, 'GotoBookmark failed');
  Check(FPSQLQuery.BookmarkValid(B), 'BookmarkValid failed');
end;

procedure TestTPSQLQuery.TestDelete;
begin
  FPSQLQuery.SQL.Text := 'SELECT * FROM requestlive_test';
  FPSQLQuery.RequestLive := True;
  FPSQLQuery.Open;
  FPSQLQuery.Delete;
  Check(FPSQLQuery.RecordCount = 0, 'TPSQLQuery.Delete failed');
end;

procedure TestTPSQLQuery.TestEmptyCharAsNullOption;
begin
  FPSQLQuery.Options := [];
  FPSQLQuery.SQL.Text := 'SELECT ''''::varchar(30), ''text''::varchar(30) as col1';
  FPSQLQuery.Open;
  Check(not FPSQLQuery.Fields[0].IsNull, 'Field must be NOT NULL due to normal options');
  FPSQLQuery.Close;

  FPSQLQuery.Options := [dsoEmptyCharAsNull];
  FPSQLQuery.SQL.Text := 'SELECT ''''::varchar(30), ''text''::varchar(30) as col1';
  FPSQLQuery.Open;
  Check(FPSQLQuery.Fields[0].IsNull, 'IsNULL must be true due to dsoEmptyCharAsNull used');
  Check(FPSQLQuery.Fields.FieldByName('col1').AsWideString = 'text', 'Field must be not empty if dsoEmptyCharAsNull enabled');
  FPSQLQuery.Close;
end;

procedure TestTPSQLQuery.TestInsert;
begin
  FPSQLQuery.SQL.Text := 'SELECT * FROM requestlive_test';
  FPSQLQuery.RequestLive := True;
  FPSQLQuery.Open;
  FPSQLQuery.Insert;
  FPSQLQuery.FieldByName('intf').AsInteger := Random(MaxInt);
  FPSQLQuery.FieldByName('string').AsString := 'test test';
  FPSQLQuery.FieldByName('datum').AsDateTime := Now();
  FPSQLQuery.FieldByName('b').AsBoolean := Boolean(Random(1));
  FPSQLQuery.FieldByName('floatf').AsFloat := Random();
  FPSQLQuery.Post;
  Check(FPSQLQuery.RecordCount = 1, 'TPSQLQuery.Insert failed');
end;

procedure TestTPSQLQuery.TestLocateInt;
begin
  FPSQLQuery.SQL.Text := 'SELECT col1 FROM generate_series(11, 16) AS c(col1)';
  FPSQLQuery.Open;
  Check(FPSQLQuery.Locate('col1', '12', []), 'Locate failed with default options');
  Check(FPSQLQuery.RecNo = 2, 'Locate positioning failed with default options');

  Check(FPSQLQuery.Locate('col1', '13', [loPartialKey]), 'Locate failed with loPartialKey option');
  Check(FPSQLQuery.RecNo = 3, 'Locate positioning failed with loPartialKey option');

  Check(FPSQLQuery.Locate('col1', '14', [loCaseInsensitive]), 'Locate failed with loCaseInsensitive option');
  Check(FPSQLQuery.RecNo = 4, 'Locate positioning failed with loCaseInsensitive option');

  Check(FPSQLQuery.Locate('col1', '15', [loCaseInsensitive, loPartialKey]), 'Locate failed with full options');
  Check(FPSQLQuery.RecNo = 5, 'Locate positioning failed with full options');
end;

procedure TestTPSQLQuery.TestLocateStr;
begin
  FPSQLQuery.SQL.Text := 'SELECT col1, cash_words(col1::money)::varchar(50) AS col2 FROM generate_series(1, 6) AS g(col1)';
  FPSQLQuery.Open;
//single column
  Check(FPSQLQuery.Locate('col2', 'Two dollars and zero cents', []) and (FPSQLQuery.RecNo = 2),
          'Locate failed with default options');
  Check(FPSQLQuery.Locate('col2', 'Thr', [loPartialKey]) and (FPSQLQuery.RecNo = 3),
          'Locate failed with loPartialKey option');
  Check(FPSQLQuery.Locate('col2', 'FiV', [loCaseInsensitive, loPartialKey]) and (FPSQLQuery.RecNo = 5),
          'Locate failed with full options');
//multicolumn
  Check(FPSQLQuery.Locate('col1;col2', VarArrayOf([2, 'Two dollars and zero cents']), []) and (FPSQLQuery.RecNo = 2),
          'Multicolumn Locate failed with default options');
  Check(FPSQLQuery.Locate('col1;col2', VarArrayOf([3, 'Thr']), [loPartialKey]) and (FPSQLQuery.RecNo = 3),
          'Multicolumn Locate failed with loPartialKey option');
  Check(FPSQLQuery.Locate('col1;col2', VarArrayOf([5, 'FiV']), [loCaseInsensitive, loPartialKey]) and (FPSQLQuery.RecNo = 5),
          'Multicolumn Locate failed with full options');
end;

procedure TestTPSQLQuery.TestUpdate;
begin
  FPSQLQuery.SQL.Text := 'SELECT * FROM requestlive_test';
  FPSQLQuery.RequestLive := True;
  FPSQLQuery.Open;
  FPSQLQuery.Edit;
  FPSQLQuery.FieldByName('intf').AsInteger := Random(MaxInt);
  FPSQLQuery.FieldByName('string').AsString := 'test test updated';
  FPSQLQuery.FieldByName('datum').AsDateTime := Now();
  FPSQLQuery.FieldByName('b').AsBoolean := Boolean(Random(1));
  FPSQLQuery.FieldByName('floatf').AsFloat := Random();
  FPSQLQuery.Post;
  Check(FPSQLQuery.FieldByName('string').AsString = 'test test updated', 'TPSQLQuery.Edit failed');
end;

{ TDbSetup }

procedure TDbSetup.SetUp;
begin
  inherited;
  SetUpTestDatabase(QryDB, 'PSQLQueryTest.conf');
  QryDB.Execute('CREATE TABLE IF NOT EXISTS requestlive_test ' +
                '(' +
                '  id serial NOT NULL PRIMARY KEY,' +
                '  intf integer,' +
                '  string character varying(100),' +
                '  datum timestamp without time zone,' +
                '  notes text,' +
                '  graphic oid,' +
                '  b_graphic bytea,' +
                '  b boolean,' +
                '  floatf real' +
                ')');
end;

procedure TDbSetup.TearDown;
begin
  inherited;
  QryDB.Execute('DROP TABLE requestlive_test');
  QryDB.Close;
  ComponentToFile(QryDB, 'PSQLQueryTest.conf');
  QryDB.Free;
end;

initialization
  //PaGo: Register any test cases with setup decorator
  RegisterTest(TDbSetup.Create(TestTPSQLQuery.Suite, 'Database Setup'));

end.

