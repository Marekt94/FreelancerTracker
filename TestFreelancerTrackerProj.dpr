program TestFreelancerTrackerProj;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner, TextTestRunner,
  TestFlatTaxEvaluatorController in 'test\TestFlatTaxEvaluatorController.pas',
  FlatTaxEvaluatorController in 'src\Module Salary\FlatTaxEvaluatorController.pas',
  InterfaceSalaryEvaluatorController in 'src\Module Salary\Interfaces\InterfaceSalaryEvaluatorController.pas',
  SalaryEntities in 'src\Module Salary\SalaryEntities.pas';

{$R *.RES}

begin
//  DUnitTestRunner.RunRegisteredTests;
  with TextTestRunner.RunRegisteredTests(rxbPause) do
    Free;
end.

