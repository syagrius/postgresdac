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
    procedure TestAsInteger;
    procedure TestAsFloat;
    procedure TestAsString;
    procedure TestAsBoolean;
    procedure TestEmptyCharAsNullOption;
  end;

var
  QryDB: TPSQLDatabase;

implementation

uses TestHelper;

procedure TestTPSQLQuery.SetUp;
begin
  FPSQLQuery := TPSQLQuery.Create(nil);
  FPSQLQuery.Database := QryDB;
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
 FPSQLQuery.SQL.Text := 'SELECT cast(''foo'' as varchar(30))';
 FPSQLQuery.Open;
 Check(FPSQLQuery.Fields[0].AsString = 'foo', 'Field value AsString is incorrect');
 FPSQLQuery.Close;
end;

procedure TestTPSQLQuery.TestEmptyCharAsNullOption;
begin
  FPSQLQuery.Options := [];
  FPSQLQuery.SQL.Text := 'SELECT Cast('''' AS varchar(30)), Cast(''text'' AS varchar(30)) as col1';
  FPSQLQuery.Open;
  Check(not FPSQLQuery.Fields[0].IsNull, 'Field must be NOT NULL due to normal options');
  FPSQLQuery.Close;

  FPSQLQuery.Options := [dsoEmptyCharAsNull];
  FPSQLQuery.SQL.Text := 'SELECT Cast('''' AS varchar(30)), Cast(''text'' AS varchar(30)) as col1';
  FPSQLQuery.Open;
  Check(FPSQLQuery.Fields[0].IsNull, 'IsNULL must be true due to dsoEmptyCharAsNull used');
  Check(FPSQLQuery.Fields.FieldByName('col1').AsWideString = 'text', 'Field must be not empty if dsoEmptyCharAsNull enabled');
  FPSQLQuery.Close;
end;

{ TDbSetup }

procedure TDbSetup.SetUp;
begin
  inherited;
  SetUpTestDatabase(QryDB, 'PSQLQueryTest.conf');
end;

procedure TDbSetup.TearDown;
begin
  inherited;
  QryDB.Close;
  ComponentToFile(QryDB, 'PSQLQueryTest.conf');
  QryDB.Free;
end;

initialization
  //PaGo: Register any test cases with setup decorator
  RegisterTest(TDbSetup.Create(TestTPSQLQuery.Suite, 'Database Setup'));

end.

