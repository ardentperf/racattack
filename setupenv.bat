REM
REM Copyright 2010 Jeremy Schneider
REM
REM This file is part of RAC-ATTACK.
REM
REM RAC-ATTACK is free software: you can redistribute it and/or modify
REM it under the terms of the GNU General Public License as published by
REM the Free Software Foundation, either version 3 of the License, or
REM (at your option) any later version.
REM
REM RAC-ATTACK is distributed in the hope that it will be useful,
REM but WITHOUT ANY WARRANTY; without even the implied warranty of
REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
REM GNU General Public License for more details.
REM
REM You should have received a copy of the GNU General Public License
REM along with RAC-ATTACK. If not, see <http://www.gnu.org/licenses/>.
REM
REM

set PROMPTENV=YES

set SOURCEDRIVE=D:

set DESTDRIVE=C:
set DESTDIR=RAC11g

set DESTDRIVESHARED=C:
set DESTDIRSHARED=RAC11g-shared
set DESTDIRISO=RAC11g-iso

set MYUSER=%USERNAME%
set MYPASS=%YOUR_WINDOWS_PASSWORD%

set VMWAREDIR="C:\Program Files\VMware\VMware Server"


REM ===============================================================
REM Begin prompting section

if /i %PROMPTENV% neq YES goto endprompt

cd|sed "s/\\.*//;s/^/set SOURCEDRIVE=/"   >%TEMP%\DetectVars.bat
call %TEMP%\DetectVars.bat
if "%SOURCEDIR%"=="RAC-DEMO-INPLACE" set DESTDRIVE=%SOURCEDRIVE%

echo s/DEFAULT-SOURCEDRIVE/%SOURCEDRIVE%/          >%TEMP%\UserIn.sed
echo s/DEFAULT-DESTDRIVESHARED/%DESTDRIVESHARED%/ >>%TEMP%\UserIn.sed
echo s/DEFAULT-DESTDRIVE/%DESTDRIVE%/             >>%TEMP%\UserIn.sed
echo s/DEFAULT-VMWAREDIR/%VMWAREDIR%/             >>%TEMP%\UserIn.sed
echo s/DEFAULT-MYUSER/%MYUSER%/                   >>%TEMP%\UserIn.sed
echo s/DEFAULT-MYPASS/%MYPASS%/                   >>%TEMP%\UserIn.sed
echo s/DEFAULT-SOURCEDIR/%SOURCEDIR%/             >>%TEMP%\UserIn.sed

sed "s/\\/\\\\/g" %TEMP%\UserIn.sed >%TEMP%\UserIn2.sed
sed -f %TEMP%\UserIn2.sed input.hta >%TEMP%\UserIn.hta
start /w %TEMP%\UserIn.hta
if not exist %TEMP%\UserIn.bat (
  echo ERROR: user canceled input dialog!
  pause
  del %TEMP%\DetectVars.bat
  del %TEMP%\UserIn.sed
  del %TEMP%\UserIn2.sed
  del %TEMP%\UserIn.hta
  exit 1
)
call %TEMP%\UserIn.bat

del %TEMP%\DetectVars.bat
del %TEMP%\UserIn.sed
del %TEMP%\UserIn2.sed
del %TEMP%\UserIn.hta
del %TEMP%\UserIn.bat

@echo off
echo. 
echo SOURCEDRIVE=%SOURCEDRIVE%
echo DESTDRIVE=%DESTDRIVE%
echo DESTDRIVESHARED=%DESTDRIVESHARED%
echo VMWAREDIR=%VMWAREDIR%
echo MYUSER=%MYUSER%
echo MYPASS=%MYPASS%
echo. 
@echo on

:endprompt


REM ===============================================================
REM Vars that are dependant on other vars

set VMRUNBIN="%VMWAREDIR:"=%\vmrun.exe"
set LZOPBIN=%SOURCEDRIVE%\lzop.exe
set MD5BIN=%SOURCEDRIVE%\md5sum
set SEDBIN=%SOURCEDRIVE%\sed
set DESTDRIVEISO=%DESTDRIVESHARED%
if "%SOURCEDIR%"=="RAC-DEMO-INPLACE" (
  set DESTDIR=%DESTDIR%.DEMO
  set DESTDIRSHARED=%DESTDIRSHARED%.DEMO
  set DESTDIRISO=%DESTDIRISO%.DEMO
  set DESTDRIVEISO=%SOURCEDRIVE%
)

if not exist %LZOPBIN% (
  echo ERROR: bad source drive!
  pause
  exit 1
)

if not exist %VMRUNBIN% (
  echo ERROR: bad VMware installation directory!
  pause
  exit 1
)
