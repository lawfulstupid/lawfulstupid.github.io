@echo off
setlocal EnableDelayedExpansion

set PROJECTS=%*
if "%PROJECTS%" == "" set PROJECTS=*.project.xml

for %%F in (%PROJECTS%) do (
	set name=
	for /f "tokens=3 delims=<>" %%A in ('find /i "<name>" ^< "%%F"') do set name=%%A
	
	set url=
	for /f "tokens=3 delims=<>" %%A in ('find /i "<url>" ^< "%%F"') do set url=%%A
	
	set build=
	for /f "tokens=3 delims=<>" %%A in ('find /i "<build>" ^< "%%F"') do set build=%%A
	
	set target=
	for /f "tokens=3 delims=<>" %%A in ('find /i "<target>" ^< "%%F"') do set target=%%A
	
	echo Cloning '!name!'...
	mkdir !name!
	cd !name!
	if not exist src (
		git clone "!url!" src
		cd src
	) else (
		cd src
		git fetch --all
		git reset --hard
	)
	
	echo Building '!name!'...
	!build!
	
	echo Copying compiled files...
	copy "!target!\*" ..
	
	echo Done.
	cd %~dp0
)

echo All done.