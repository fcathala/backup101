@Echo OFF
Rem backup101 - (c) 2009 Fabrice Cathala
Set Version=2.0
Set Color_Std=E0
Set Color_Err=47
Set Color_Inf=17

Rem Snapshot backup utility enabling a number max of 998 different snapshots of a directory and subdirectories.
Rem 998 versions of changes means 998 levels of "undo" which should be more than enough in most projects.
Rem Can be used to track intermediate state of source files, html/css files, technical documentations, ... 

:---------------------------------------------------
: AUTO RUN
:---------------------------------------------------
Rem GOTO Snapshot_BEG
:---------------------------------------------------

:---------------------------------------------------
: PREREQUISITES CHECK
:---------------------------------------------------
: backup101 requires to be able in its parent folder
:---------------------------------------------------
: Should NOT be stored at root level:
IF "%__cd__:~3%"=="" GOTO Err_Root_BEG

: Should have R/W permission on the parent folder:
MD ..\Boom
IF EXIST ..\Boom GOTO Answer2
:Answer1
	Echo Root
	Goto AnswerEnd
:Answer2
	Echo Folder
	Goto AnswerEnd
:AnswerEnd
PAUSE
:---------------------------------------------------


:---------------------------------------------------
:Intro_BEG
	Title backup101 - Snapshots backup utility with versioning - Version %Version%
	Mode con: cols=85 lines=42
	Color %Color_Std%
	Cls
	Echo.
	Echo ---------------------------------------------------------
	Echo         backup101 - Snapshots backup utility
	Echo ---------------------------------------------------------
	Echo.
	Echo.
	
	Echo To take a snapshot press............................. S (or ENTER)
	Echo.
	Echo To access the HELP section press..................... H
	Echo To display the current LIST of folders press......... L
	Echo To EXIT press........................................ X
	Echo.

	Set Selection=
	Set /P Selection=Type your selection AND PRESS ENTER:
	If NOT '%Selection%'=='' SET Selection=%Selection:~0,1%
	If /I '%Selection%'=='' GOTO Snapshot_BEG
	If /I '%Selection%'=='S' GOTO Snapshot_BEG
	If /I '%Selection%'=='H' GOTO Help_BEG
	If /I '%Selection%'=='?' GOTO Help_BEG
	If /I '%Selection%'=='L' GOTO List_BEG
	If /I '%Selection%'=='X' GOTO Exit
	Goto Intro_BEG
:Intro_END



:---------------------------------------------------
:Help_BEG
	Cls
	Color %Color_Inf%
	Echo.
	Echo ---------------------------------------------------------
	Echo         backup101 - Snapshots backup utility
	Echo ---------------------------------------------------------
	Echo.
	Echo.
	Echo backup101 takes up to 998 snapshots copies of all content stored in the original
	Echo folder named "backup101" and located in the same directory.
	Echo.
	Echo.
	Echo FOLDER STRUCTURE:
	Echo.-----------------
	Echo    backup101: Your working directory. If you are editing text files like HTML/CSS,
	Echo                this is the place where your text editor must load its files...
	Echo.
	Echo    backup.102: It's the previous version of your backup. Restore(*) this backup or
	Echo                edit any single file in it to retrieve some data in the state they
	Echo                were before the last backup101 was run.
	Echo.
	Echo    backup.103: Older version than 102...
	Echo    backup.104: Older version than 103...
	Echo    backup.105: Older version than 104...
	Echo.
	Echo    backup.999: Current limit of backup101 (998 backups max).
	Echo.
	Echo.
	Echo BACKUP:
	Echo.-------
	Echo Before any major change in your working files (stored in the folder "backup101"):
	Echo    1) Save all your files to disk.
	Echo    2) Run this utility and select "S" at the welcome screen.
	Echo.
	Echo.
	Echo RESTORE:
	Echo.--------
	Echo To restore any data, you can use one of the following options:
	Echo    1) Edit an old version of a document and copy the needed extract.
	Echo    2) Copy files and/or folders from the list of versions available (102 to 999).
	Echo.

	Echo Press any key to return to home screen...
	Pause > NUL
	Goto Intro_BEG
:Help_END


:---------------------------------------------------
:List_BEG
	Cls
	Color %Color_Std%
	Echo.
	Echo ---------------------------------------------------------
	Echo         backup101 - Snapshots backup utility
	Echo ---------------------------------------------------------
	Echo.
	Echo.
	
	Echo List of snapshots:
	Echo ---------------------------------------------------------
	dir backup.* /b /ad
	Echo ---------------------------------------------------------
	Echo.

	Echo Press any key to return to home screen...
	Pause > NUL
	Goto Intro_BEG
:List_END


:Snapshot_BEG
	If NOT Exist backup101 Goto Err_No_Original_BEG	

	Cls
	Color %Color_Std%
	Echo.
	Echo ---------------------------------------------------------
	Echo         backup101 - Snapshots backup utility
	Echo ---------------------------------------------------------
	Echo.
	Echo.

	Rem : Calculate version max
	For /L %%I in (100,1,999) do (If Exist backup.%%I Set /A Max=%%I)
	Rem : Check limit not reached
	If "%Max%"=="999" Goto Err_Max_Reached_BEG

	Echo ---------------------------------------------------------

	Rem : Rename all folders to their next version, starting by the last one
	Set /A Source = %Max%

:While_Move_BEG
		If "%Source%"=="101" Goto While_Move_END
		Set /A Target = %Source% + 1
		
		Echo ---------------------------------------------------------
		Echo Move backup.%Source% to backup.%Target%
		Echo ---------------------------------------------------------
		Echo.
		Ren backup.%Source% backup.%Target%

		Set /A Source -= 1
		Goto While_Move_BEG
:While_Move_END

	Rem : Copy backup101 into backup.102
	Echo ---------------------------------------------------------
	Echo Copy files in backup101 into backup.102
	Echo ---------------------------------------------------------
	Xcopy backup101 backup.102 /S /V /I
	Echo ---------------------------------------------------------
	Echo.
	Rem : The source files can now be modified, they are saved in the folder "backup.102"

	Echo Press any key to return to home screen...
	Pause > NUL
	Goto Intro_BEG
:Snapshot_END

:Err_Root_BEG
	Cls
	Color %Color_Err%
	Echo.
	Echo ---------------------------------------------------------
	Echo         backup101 - Snapshots backup utility
	Echo ---------------------------------------------------------
	Echo.
	Echo.
	Echo ERROR: backup101.cmd cannot be stored at the root of a drive!
	Echo Your working directory must be a subfolder of a drive, not its root.
	Echo.
	Echo Press any key to exit...
	Pause > NUL
	Goto Exit
:Err_Root_END


:Err_No_Original_BEG
	Cls
	Color %Color_Err%
	Echo.
	Echo ---------------------------------------------------------
	Echo         backup101 - Snapshots backup utility
	Echo ---------------------------------------------------------
	Echo.
	Echo.

	Echo ERROR: The original folder "backup101" does not exit!
	Echo.

	Md backup101
	Echo It has been created but is empty.
	Echo Use it as your permanent working directory:
	Echo.
	Echo ALL ITS CONTENT will be backed-up next time you run "backup101.cmd"!
	Echo.

	Echo Press any key to return to home screen...
	Pause > NUL
	Goto Intro_BEG
:Err_No_Original_END


:Err_Max_Reached_BEG
	Cls
	Color %Color_Err%
	Echo.
	Echo ---------------------------------------------------------
	Echo         backup101 - Snapshots backup utility
	Echo ---------------------------------------------------------
	Echo.
	Echo.

	Echo ERROR: You have reached the limit of 998 snapshots copies!
	Echo.
	Echo You need to delete the oldest backup first (from backup.999 downward).
	Echo.

	Echo Press any key to return to home screen...
	Pause > NUL
	Goto Intro_BEG
:Err_Max_Reached_END

:Exit
