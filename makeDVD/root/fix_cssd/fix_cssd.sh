#!/bin/bash
#
# To install, add this line to rc.local:
#   nohup nice -n -20 ./fix_cssd.sh 2>&1 &
#
while true
do
  for CHECK in [o]cssd [c]ssdmonitor [c]ssdagent; do
    PROC=$(ps ax|grep $CHECK)
    if [[ -n "$PROC" ]]
    then
      if [[ -n "$(echo $PROC|awk '{print$3}'|grep L)" ]]
      then
        OPID=$(echo $PROC|awk '{print$1}')
        gdb -p $OPID <<"        EOF"
          call munlockall()
          quit
        EOF
      fi
    fi
  done
  sleep 60
done

