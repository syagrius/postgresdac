unit PSQLTableTest;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  PSQLAccess, PSQLDbTables, PSQLTypes, Classes, Db,
  {$IFNDEF DUNITX}
  TestFramework, TestExtensions
  {$ELSE}
  DUnitX.TestFramework
  {$ENDIF};

type

  {$IFDEF DUNITX}[TestFixture]{$ENDIF}
  TestTPSQLTable = class({$IFNDEF DUNITX}TTestCase{$ELSE}TObject{$ENDIF})
  private
    FPSQLTable: TPSQLTable;
  public
    {$IFNDEF DUNITX}
    procedure SetUp; override;
    procedure TearDown; override;
    {$ELSE}
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
    {$ENDIF}
  published
    procedure TestAddIndex;
    procedure TestApplyRange;
    procedure TestCancelRange;
    procedure TestCreateTable;
    procedure TestDeleteIndex;
    procedure TestEditKey;
    procedure TestEditRangeEnd;
    procedure TestEditRangeStart;
    procedure TestEmptyTable;
    procedure TestFindKey;
    procedure TestFindNearest;
    procedure TestGetIndexNames;
    procedure TestGotoCurrent;
    procedure TestGotoKey;
    procedure TestGotoNearest;
    procedure TestSetKey;
    procedure TestSetRange;
    procedure TestSetRangeEnd;
    procedure TestSetRangeStart;
    {$IFDEF DUNITX}
    [SetupFixture]
    procedure SetupFixture;
    {$ENDIF}
  end;

implementation

uses TestHelper{$IFDEF DUNITX}, MainF{$ENDIF};

procedure InternalSetUp;
begin
end;

procedure TestTPSQLTable.SetUp;
begin
  FPSQLTable := TPSQLTable.Create(nil);
  FPSQLTable.Database := TestDBSetup.Database;
end;

{$IFDEF DUNITX}
procedure TestTPSQLTable.SetupFixture;
begin
  InternalSetUp;
end;
{$ENDIF}

procedure TestTPSQLTable.TearDown;
begin
  FPSQLTable.Free;
  FPSQLTable := nil;
end;

procedure TestTPSQLTable.TestAddIndex;
var
  DescFields: string;
  Options: TIndexOptions;
  Fields: string;
  Name: string;
begin
  // TODO: Setup method call parameters
  FPSQLTable.AddIndex(Name, Fields, Options, DescFields);
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestApplyRange;
begin
  FPSQLTable.ApplyRange;
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestCancelRange;
begin
  FPSQLTable.CancelRange;
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestCreateTable;
begin
  FPSQLTable.CreateTable;
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestDeleteIndex;
var
  Name: string;
begin
  // TODO: Setup method call parameters
  FPSQLTable.DeleteIndex(Name);
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestEditKey;
begin
  FPSQLTable.EditKey;
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestEditRangeEnd;
begin
  FPSQLTable.EditRangeEnd;
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestEditRangeStart;
begin
  FPSQLTable.EditRangeStart;
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestEmptyTable;
begin
  FPSQLTable.EmptyTable;
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestFindKey;
var
  ReturnValue: Boolean;
  KeyValues: array of TVarRec;
begin
  FPSQLTable.TableName := 'testtable';
  FPSQLTable.Open;
  FPSQLTable.IndexName := 'pk_testtable';
  DACCheck(FPSQLTable.FindKey(['11', '21']), 'FindKey failed for two-column index');
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestFindNearest;
var
  KeyValues: array of TVarRec;
begin
  // TODO: Setup method call parameters
  FPSQLTable.FindNearest(KeyValues);
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestGetIndexNames;
var
  List: TStrings;
begin
  List := TStringList.Create;
  // TODO: Setup method call parameters
  FPSQLTable.GetIndexNames(List);
  // TODO: Validate method results
  List.Free;
end;

procedure TestTPSQLTable.TestGotoCurrent;
var
  Table: TPSQLTable;
begin
  Table := TPSQLTable.Create(nil);
  // TODO: Setup method call parameters
  FPSQLTable.GotoCurrent(Table);
  // TODO: Validate method results
  Table.Free;
end;

procedure TestTPSQLTable.TestGotoKey;
begin
  CheckTrue(FPSQLTable.GotoKey);
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestGotoNearest;
begin
  FPSQLTable.GotoNearest;
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestSetKey;
begin
  FPSQLTable.SetKey;
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestSetRange;
var
  EndValues:  array of TVarRec;
  StartValues:  array of TVarRec;
begin
  // TODO: Setup method call parameters
  FPSQLTable.SetRange(StartValues, EndValues);
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestSetRangeEnd;
begin
  FPSQLTable.SetRangeEnd;
  // TODO: Validate method results
end;

procedure TestTPSQLTable.TestSetRangeStart;
begin
  FPSQLTable.SetRangeStart;
  // TODO: Validate method results
end;

initialization
{$IFDEF DUNITX}
  TDUnitX.RegisterTestFixture(TestTPSQLTable);
{$ENDIF}
end.

