Set Debug=Off
Echo %Debug%
Rem =============================================================
Rem backup101: Ultra simple backup utility
Rem
Rem Snapshot backup utility enabling a number max of 999 different
Rem snapshots of a directory and subdirectories.
Rem 999 versions of changes means...
Rem 999 levels of "undo" which should be more than enough in most projects.
Rem
Rem Can be used to track intermediate state of source files,
Rem html/css/js files, technical documentations, etc... 
Rem backup101 saves time and helps you to manage the risk of mistakes.
Rem
Rem © Fabrice Cathala - March 2009
Rem	Version: 2.0
Rem
Rem =============================================================

Cls
Echo.
Echo --------------------------------------------------------
Echo  backup101:  Ultra simple backup utility
Echo --------------------------------------------------------
Echo.

Rem Calculates Max value (last backup)
If Not Exist backup.101 Goto NoPriorBackup
	Goto PriorBackup
	:NoPriorBackup
		Set /A Max = "100"
		Goto EndPriorBackup
	:PriorBackup
		For /L %%I in (100,1,999) do (If Exist backup.%%I Set /A Max=%%I)
		Goto EndPriorBackup
	:EndPriorBackup

Rem Checks limit not reached
If "%Max%" LSS "999" Goto OkNumber
	Goto NotOkNumber
	:OkNumber
		Goto EndNumber
	:NotOkNumber
		Rem Delete older folder (shift)
		RmDir /S /Q backup.999
		Set /A Max = "998"
		Goto EndNumber
	:EndNumber

Rem Starts by the last folder
Set /A Source = %Max%

Rem Shift backup folders
:WhileMove
	If "%Source%" LSS "101" Goto CopySource

		If "%Debug%" NEQ "ON" Goto StartShift  
		Echo.
		Echo --------------------------------------------------------
		Echo  Move backup.%Source% to backup.%Target%
		Echo --------------------------------------------------------
		Echo.

	:StartShift
	Rem Shifts the backup folders
	Rem TimeOut /T 1 /NoBreak
	Set /A Target = %Source% + 1
	XCopy backup.%Source% backup.%Target% /E /V /I
	If %ErrorLevel% EQU 0 RmDir backup.%Source% /S /Q
	Echo.
	Set /A Source -= 1
	Goto WhileMove
Goto CopySource

Rem Copy source files into backup.101
:CopySource
	Echo ----------------------------------------------------------
	Echo  Copy source files into backup.101
	Echo ----------------------------------------------------------
	Echo.
	Rem List of source to copy to the destination folder:
	Rem 	..\*.* backup.101\ /V /I
	Rem 	..\Folder_1 backup.101\Folder_1 /V /I
	Rem 	etc...
	Rem ===========================================================
	Rem Please edit manually below what the source actually is...
	Rem ===========================================================

	Xcopy ..\*.* backup.101\ /V /I
	Xcopy ..\Folder_1 backup.101\Folder_1 /V /I
	Xcopy ..\Folder_2 backup.101\Folder_2 /V /I

  Echo.
  Echo ----------------------------------------------------------
  Echo.

  Pause
	Rem The source files can now be modified,
	Rem they have been saved in the sub-folder "backup.101"
