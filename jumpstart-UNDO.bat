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

set SOURCEDIR=RAC-UNDO
call setupenv.bat

REM ====================== Swap Current and Prev Files ======================
time /t

call %VMRUNBIN% -T server -h https://127.0.0.1:8333/sdk -u %MYUSER% -p %MYPASS% stop "[RAC11g] collabn1\collabn1.vmx" hard
call %VMRUNBIN% -T server -h https://127.0.0.1:8333/sdk -u %MYUSER% -p %MYPASS% unregister "[RAC11g] collabn1\collabn1.vmx"
call %VMRUNBIN% -T server -h https://127.0.0.1:8333/sdk -u %MYUSER% -p %MYPASS% stop "[RAC11g] collabn2\collabn1.vmx" hard
call %VMRUNBIN% -T server -h https://127.0.0.1:8333/sdk -u %MYUSER% -p %MYPASS% unregister "[RAC11g] collabn2\collabn1.vmx"
time /t

mkdir %DESTDRIVE%\%DESTDIR%
mkdir %DESTDRIVE%\%DESTDIR%\collabn1
mkdir %DESTDRIVE%\%DESTDIR%\collabn2
mkdir %DESTDRIVE%\%DESTDIR%.prev
mkdir %DESTDRIVE%\%DESTDIR%.prev\collabn1
mkdir %DESTDRIVE%\%DESTDIR%.prev\collabn2
mkdir %DESTDRIVESHARED%\%DESTDIRSHARED%
mkdir %DESTDRIVESHARED%\%DESTDIRSHARED%.prev

mkdir %DESTDRIVE%\%DESTDIR%.swap
mkdir %DESTDRIVE%\%DESTDIR%.swap\collabn1
mkdir %DESTDRIVE%\%DESTDIR%.swap\collabn2
mkdir %DESTDRIVESHARED%\%DESTDIRSHARED%.swap

del /q %DESTDRIVE%\%DESTDIR%.swap\collabn1\*
del /q %DESTDRIVE%\%DESTDIR%.swap\collabn2\*
del /q %DESTDRIVE%\%DESTDIR%.swap\source.txt
del /q %DESTDRIVESHARED%\%DESTDIRSHARED%.swap\*
time /t

move /y %DESTDRIVE%\%DESTDIR%.prev\collabn1\* %DESTDRIVE%\%DESTDIR%.swap\collabn1
move /y %DESTDRIVE%\%DESTDIR%.prev\collabn2\* %DESTDRIVE%\%DESTDIR%.swap\collabn2
move /y %DESTDRIVE%\%DESTDIR%.prev\source.txt %DESTDRIVE%\%DESTDIR%.swap
move /y %DESTDRIVESHARED%\%DESTDIRSHARED%.prev\*   %DESTDRIVESHARED%\%DESTDIRSHARED%.swap
time /t

move /y %DESTDRIVE%\%DESTDIR%\collabn1\* %DESTDRIVE%\%DESTDIR%.prev\collabn1
move /y %DESTDRIVE%\%DESTDIR%\collabn2\* %DESTDRIVE%\%DESTDIR%.prev\collabn2
move /y %DESTDRIVE%\%DESTDIR%\source.txt %DESTDRIVE%\%DESTDIR%.prev
move /y %DESTDRIVESHARED%\%DESTDIRSHARED%\*   %DESTDRIVESHARED%\%DESTDIRSHARED%.prev
time /t

move /y %DESTDRIVE%\%DESTDIR%.swap\collabn1\* %DESTDRIVE%\%DESTDIR%\collabn1
move /y %DESTDRIVE%\%DESTDIR%.swap\collabn2\* %DESTDRIVE%\%DESTDIR%\collabn2
move /y %DESTDRIVE%\%DESTDIR%.swap\source.txt %DESTDRIVE%\%DESTDIR%
move /y %DESTDRIVESHARED%\%DESTDIRSHARED%.swap\*   %DESTDRIVESHARED%\%DESTDIRSHARED%

rmdir %DESTDRIVE%\%DESTDIR%.swap\collabn1
rmdir %DESTDRIVE%\%DESTDIR%.swap\collabn2
rmdir %DESTDRIVE%\%DESTDIR%.swap
rmdir %DESTDRIVESHARED%\%DESTDIRSHARED%.swap
time /t

call %VMRUNBIN% -T server -h https://127.0.0.1:8333/sdk -u %MYUSER% -p %MYPASS% register "[RAC11g] collabn1\collabn1.vmx"
call %VMRUNBIN% -T server -h https://127.0.0.1:8333/sdk -u %MYUSER% -p %MYPASS% register "[RAC11g] collabn2\collabn1.vmx"
time /t

pause
