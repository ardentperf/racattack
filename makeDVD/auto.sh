#!/bin/bash
#
# Copyright 2010 Jeremy Schneider
#
# This file is part of RAC-ATTACK
#
# RAC-ATTACK is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# RAC-ATTACK is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with RAC-ATTACK  If not, see <http://www.gnu.org/licenses/>.
#
#

DOWNLOADS=(
    'http://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.4-1.el5.i386.rpm'
    'http://download.oracle.com/otn/linux/oracle11g/R2/linux_11gR2_database_1of2.zip'
    'http://download.oracle.com/otn/linux/oracle11g/R2/linux_11gR2_database_2of2.zip'
    'http://download.oracle.com/otn/linux/oracle11g/R2/linux_11gR2_grid.zip'
)

[ -n "$DEBUG" ] && set -x
[ -z "$1" ] && { echo "Usage: auto.sh <dest-path>" && exit 1; }
perl -MHTML::Parser -e 1 || { echo "ERROR: Perl Module HTML::Parser is not installed." && exit 1; }

function getFormFields {
perl <<EOF
use HTML::Parser ();
sub handle_start {
  return if shift ne "input"; my \$attr=shift;
  return if \$attr->{name} eq "ssousername";
  return if \$attr->{name} eq "password";
  print \$attr->{name}."=".\$attr->{value}."&";
}
my \$p=HTML::Parser->new(api_version=>3,start_h=>[\&handle_start,"tagname,attr"]);
\$p->attr_encoded(true); \$p->parse_file("$1") || die \$!;
print "ignorenonsense=nothing\n";
EOF
}


mkdir -p $1

cd $(dirname $0)
cp -v oracle-profile $1/
tar cvf $1/fix_cssd.tar root

read -p "Oracle SSO Username: " ORACLE_USERNAME
stty -echo
read -p "Oracle SSO Password: " ORACLE_PASSWORD; echo
stty echo

# login to oracle website first
echo "LOGGING IN TO ORACLE SSO"
curl --location-trusted -c /tmp/cookies -A "Mozilla/5.0" http://www.oracle.com/webapps/redirect/signon >/tmp/formfields
getFormFields /tmp/formfields >/tmp/formx
curl -vd @/tmp/formx -d ssousername="$ORACLE_USERNAME" -d password="$ORACLE_PASSWORD" --location-trusted -b /tmp/cookies -c /tmp/cookies -A "Mozilla/5.0" https://login.oracle.com/oam/server/sso/auth_cred_submit >/tmp/form_login_debug 2>&1

# download files from list
cd $1
for URL in "${DOWNLOADS[@]}"; do
  FILE="$(basename $URL)"
  echo "DOWNLOADING: /tmp/$FILE"
  if [ ! -f /tmp/$FILE ]; then
    curl --location-trusted -b /tmp/cookies -c /tmp/cookies -A "Mozilla/5.0" -o /tmp/$FILE "$URL"
  fi
  if [ $(echo $FILE|awk -F. '{print$NF}') == zip ]; then
    unzip /tmp/$FILE
    rm -v /tmp/$FILE
  else
    mv -v /tmp/$FILE .
  fi
done

if [ ! -n "$DEBUG" ]; then
  rm -v /tmp/cookies
  rm -v /tmp/formx
  rm -v /tmp/formfields
  rm -v /tmp/form_login_debug
fi

echo "FINISHED BUILDING RAC ATTACK DVD"

