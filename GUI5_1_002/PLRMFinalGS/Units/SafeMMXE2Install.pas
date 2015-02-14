unit SafeMMXE2Install;

interface

{$MESSAGE warn 'SafeMM on'}

implementation

uses
  SafeMMXE2;

var
  FOldManager: TMemoryManagerEx;

procedure InstallSafeMemoryManager;
begin
 Assert(GetHeapStatus.TotalAllocated=0);
 GetMemoryManager(FOldManager);

 SetMemoryManager(SafeMemoryManager);

 SafeMMPrepare;
end;

procedure UninstallSafeMemoryManager;
begin
 SetMemoryManager(FOldManager);
end;

initialization

  InstallSafeMemoryManager;

finalization

  UninstallSafeMemoryManager;

end.
