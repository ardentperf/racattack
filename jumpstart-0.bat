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

set SOURCEDIR=RAC-0-delete
call setupenv.bat

REM ====================== Cleanup Current Files ======================

call %VMRUNBIN% -T server -h https://127.0.0.1:8333/sdk -u %MYUSER% -p %MYPASS% stop "[RAC11g] collabn1\collabn1.vmx" hard
call %VMRUNBIN% -T server -h https://127.0.0.1:8333/sdk -u %MYUSER% -p %MYPASS% unregister "[RAC11g] collabn1\collabn1.vmx"
call %VMRUNBIN% -T server -h https://127.0.0.1:8333/sdk -u %MYUSER% -p %MYPASS% stop "[RAC11g] collabn2\collabn1.vmx" hard
call %VMRUNBIN% -T server -h https://127.0.0.1:8333/sdk -u %MYUSER% -p %MYPASS% unregister "[RAC11g] collabn2\collabn1.vmx"

mkdir %DESTDRIVE%\%DESTDIR%
mkdir %DESTDRIVE%\%DESTDIR%\collabn1
mkdir %DESTDRIVE%\%DESTDIR%\collabn2
mkdir %DESTDRIVE%\%DESTDIR%.prev
mkdir %DESTDRIVE%\%DESTDIR%.prev\collabn1
mkdir %DESTDRIVE%\%DESTDIR%.prev\collabn2
mkdir %DESTDRIVESHARED%\%DESTDIRSHARED%
mkdir %DESTDRIVESHARED%\%DESTDIRSHARED%.prev

del /q %DESTDRIVE%\%DESTDIR%.prev\collabn1\*
del /q %DESTDRIVE%\%DESTDIR%.prev\collabn2\*
del /q %DESTDRIVESHARED%\%DESTDIRSHARED%.prev\*

move /y %DESTDRIVE%\%DESTDIR%\collabn1\* %DESTDRIVE%\%DESTDIR%.prev\collabn1
move /y %DESTDRIVE%\%DESTDIR%\collabn2\* %DESTDRIVE%\%DESTDIR%.prev\collabn2
move /y %DESTDRIVE%\%DESTDIR%\source.txt %DESTDRIVE%\%DESTDIR%.prev
move /y %DESTDRIVESHARED%\%DESTDIRSHARED%\*   %DESTDRIVESHARED%\%DESTDIRSHARED%.prev

%DESTDRIVE%
cd \%DESTDIR%
echo JUMPSTART-0 >source.txt
date /t >>source.txt
time /t >>source.txt

%DESTDRIVESHARED%
cd \%DESTDIRSHARED%
echo JUMPSTART-0 >source.txt
date /t >>source.txt
time /t >>source.txt

rmdir %DESTDRIVE%\%DESTDIR%\collabn1
rmdir %DESTDRIVE%\%DESTDIR%\collabn2

pause
