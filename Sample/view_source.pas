begin
  SessionDTM := TSessionDTM.Create(nil);
  ReportMemoryLeaksOnShutdown := true;
  DUnitTestRunner.RunRegisteredTests;

  {$IFDEF CONSOLE_TESTRUNNER}
  WriteLn('Pressione Enter para encerrar...');
  ReadLn;
  {$ENDIF}

  SessionDTM.Free;
end.
