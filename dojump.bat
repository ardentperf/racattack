REM
REM Copyright 2011 Jeremy Schneider
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

call setupenv.bat

REM ====================== Cleanup Current Files ======================
time /t

call %VMRUNBIN% -T server -h https://localhost:8333/sdk -u %MYUSER% -p %MYPASS% stop "[RAC11g] collabn1\collabn1.vmx" hard
call %VMRUNBIN% -T server -h https://localhost:8333/sdk -u %MYUSER% -p %MYPASS% unregister "[RAC11g] collabn1\collabn1.vmx"
call %VMRUNBIN% -T server -h https://localhost:8333/sdk -u %MYUSER% -p %MYPASS% stop "[RAC11g] collabn2\collabn1.vmx" hard
call %VMRUNBIN% -T server -h https://localhost:8333/sdk -u %MYUSER% -p %MYPASS% unregister "[RAC11g] collabn2\collabn1.vmx"
time /t

if %SOURCEDRIVE%\%SOURCEDIR%==%DESTDRIVESHARED%\RAC-DEMO-INPLACE goto fixup

mkdir %DESTDRIVESHARED%\%DESTDIRSHARED%
mkdir %DESTDRIVESHARED%\%DESTDIRSHARED%.prev
del /q %DESTDRIVESHARED%\%DESTDIRSHARED%.prev\*
move /y %DESTDRIVESHARED%\%DESTDIRSHARED%\* %DESTDRIVESHARED%\%DESTDIRSHARED%.prev
time /t

if %SOURCEDIR%==RAC-DEMO-INPLACE goto fixup

mkdir %DESTDRIVE%\%DESTDIR%
mkdir %DESTDRIVE%\%DESTDIR%\collabn1
mkdir %DESTDRIVE%\%DESTDIR%\collabn2
mkdir %DESTDRIVE%\%DESTDIR%.prev
mkdir %DESTDRIVE%\%DESTDIR%.prev\collabn1
mkdir %DESTDRIVE%\%DESTDIR%.prev\collabn2
del /q %DESTDRIVE%\%DESTDIR%.prev\collabn1\*
del /q %DESTDRIVE%\%DESTDIR%.prev\collabn2\*
del /q %DESTDRIVE%\%DESTDIR%.prev\source.txt
move /y %DESTDRIVE%\%DESTDIR%\collabn1\* %DESTDRIVE%\%DESTDIR%.prev\collabn1
move /y %DESTDRIVE%\%DESTDIR%\collabn2\* %DESTDRIVE%\%DESTDIR%.prev\collabn2
move /y %DESTDRIVE%\%DESTDIR%\source.txt %DESTDRIVE%\%DESTDIR%.prev
time /t

:fixup
REM ====================== Create Fixup Script =======================
echo s/fileName.*RAC11g-iso/fileName = ^"%DESTDRIVEISO%\\%DESTDIRISO%/         >%TEMP%\fixup.sed
echo s/fileName.*RAC11g-shared/fileName = ^"%DESTDRIVESHARED%\\%DESTDIRSHARED%/  >>%TEMP%\fixup.sed
echo s/memsize =.*/memsize = ^"%MEMSIZE%^"/                                      >>%TEMP%\fixup.sed
type %TEMP%\fixup.sed

REM ====================== Decompress New Files ======================

%DESTDRIVE%
cd \%DESTDIR%\collabn1
rem type %SOURCEDRIVE%\%SOURCEDIR%\collabn1.lzo | %LZOPBIN% -vdNp
rem *** Windows TYPE command is fastest but can't handle >4GB files
if not %SOURCEDIR%==RAC-DEMO-INPLACE %LZOPBIN% -vdNp %SOURCEDRIVE%\%SOURCEDIR%\collabn1.lzo
if exist collabn1.vmx.orig (
  %SEDBIN% -f %TEMP%\fixup.sed collabn1.vmx.orig >collabn1.vmx
)
time /t

cd \%DESTDIR%\collabn2
rem type %SOURCEDRIVE%\%SOURCEDIR%\collabn2.lzo | %LZOPBIN% -vdNp
rem *** Windows TYPE command is fastest but can't handle >4GB files
if not %SOURCEDIR%==RAC-DEMO-INPLACE %LZOPBIN% -vdNp %SOURCEDRIVE%\%SOURCEDIR%\collabn2.lzo
if exist collabn1.vmx.orig (
  %SEDBIN% -f %TEMP%\fixup.sed collabn1.vmx.orig >collabn1.vmx
)
time /t

cd \%DESTDIR%
echo %SOURCEDRIVE%\%SOURCEDIR% >>source.txt
date /t >>source.txt
time /t >>source.txt


%DESTDRIVESHARED%
cd \%DESTDIRSHARED%

rem type %SOURCEDRIVE%\%SOURCEDIR%\shared.lzo | %LZOPBIN% -vdNp
rem *** Windows TYPE command is fastest but can't handle >4GB files
if %SOURCEDIR%==RAC-DEMO-INPLACE (
  if not %SOURCEDRIVE%==%DESTDRIVESHARED% copy /Y %SOURCEDRIVE%\%DESTDIRSHARED%\* .
) else (
  %LZOPBIN% -vdNp %SOURCEDRIVE%\%SOURCEDIR%\shared.lzo
)
time /t

del source.txt
echo %SOURCEDRIVE%\%SOURCEDIR% >>source.txt
date /t >>source.txt
time /t >>source.txt

call %VMRUNBIN% -T server -h https://localhost:8333/sdk -u %MYUSER% -p %MYPASS% register "[RAC11g] collabn1\collabn1.vmx"
call %VMRUNBIN% -T server -h https://localhost:8333/sdk -u %MYUSER% -p %MYPASS% register "[RAC11g] collabn2\collabn1.vmx"

del %TEMP%\fixup.sed
time /t
if %SOURCEDIR%==RAC-DEMO-INPLACE goto end

REM ====================== Check New Files ======================
%DESTDRIVE%

cd \%DESTDIR%\collabn1
%MD5BIN% --check checksum.md5
time /t

cd \%DESTDIR%\collabn2
%MD5BIN% --check checksum.md5
time /t

%DESTDRIVESHARED%

cd \%DESTDIRSHARED%
%MD5BIN% --check checksum.md5
time /t

:end
pause

