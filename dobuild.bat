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

echo "CAUTION: THIS WILL DELETE THE CURRENT IMAGES. ARE YOU SURE?  (CTRL-C to ABORT)"
pause
time /t

call %VMRUNBIN% -T server -h https://localhost:8333/sdk -u %USERNAME% -p %MYPASS% stop "[RAC11g] collabn1\collabn1.vmx" hard
call %VMRUNBIN% -T server -h https://localhost:8333/sdk -u %USERNAME% -p %MYPASS% unregister "[RAC11g] collabn1\collabn1.vmx"
call %VMRUNBIN% -T server -h https://localhost:8333/sdk -u %USERNAME% -p %MYPASS% stop "[RAC11g] collabn2\collabn1.vmx" hard
call %VMRUNBIN% -T server -h https://localhost:8333/sdk -u %USERNAME% -p %MYPASS% unregister "[RAC11g] collabn2\collabn1.vmx"
time /t

%DESTDRIVE%
cd \%DESTDIR%\collabn1
del /q vmware*.log
%MD5BIN% * >checksum.md5

type checksum.md5 | find /V "checksum" > c2.md5
move /Y c2.md5 checksum.md5
time /t

cd \%DESTDIR%\collabn2
del /q vmware*.log
%MD5BIN% * >checksum.md5

type checksum.md5 | find /V "checksum" > c2.md5
move /Y c2.md5 checksum.md5
time /t

%DESTDRIVESHARED%

cd \%DESTDIRSHARED%
del /q *.RESLCK
%MD5BIN% * >checksum.md5

type checksum.md5 | find /V "checksum" > c2.md5
move /Y c2.md5 checksum.md5
time /t


%SOURCEDRIVE%
mkdir \%SOURCEDIR%
mkdir \%SOURCEDIR%.prev

del /q  \%SOURCEDIR%.prev\*.lzo
move /y \%SOURCEDIR%\* \%SOURCEDIR%.prev

cd \%SOURCEDIR%
%LZOPBIN% -FPvo collabn1.lzo %DESTDRIVE%\%DESTDIR%\collabn1\*
time /t
%LZOPBIN% -FPvo collabn2.lzo %DESTDRIVE%\%DESTDIR%\collabn2\*
time /t
%LZOPBIN% -FPvo shared.lzo %DESTDRIVESHARED%\%DESTDIRSHARED%\*
time /t


call %VMRUNBIN% -T server -h https://localhost:8333/sdk -u %USERNAME% -p %MYPASS% register "[RAC11g] collabn1\collabn1.vmx"
call %VMRUNBIN% -T server -h https://localhost:8333/sdk -u %USERNAME% -p %MYPASS% register "[RAC11g] collabn2\collabn1.vmx"
time /t

pause
