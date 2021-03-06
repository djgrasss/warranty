#!/bin/bash

# Written by Rusty Myers
# 2013-11-12

# Check Seagate repair program
# Credit to brunerd for curl: http://www.brunerd.com/blog/2012/10/16/check-multiple-imacs-for-1tb-seagate-repair-program/
#curl  "https://supportform.apple.com/201107/SerialNumberEligibilityAction.do?cb=iMacHDCheck.response&sn=$(ioreg -c "IOPlatformExpertDevice" | awk -F '"' '/IOPlatformSerialNumber/ {print $4}')" 2>/dev/null

# Expects csv with headers "ComputerName,SerialNumber". Also requires Unix (LF) formatting.

VERBOSE=   #Set to 1 to see verbose

# Pass list of serials as first argument
for i in $(cat "${1}"); do

COMPNAME=$(echo ${i} | awk -F, '{print $1}')
COMPSERIAL=$(echo ${i} | awk -F, '{print $2}')

if [ "${VERBOSE}" ]; then 
	echo "Checking: $COMPNAME  -  Serial: $COMPSERIAL"
fi

COMPSTATUS=`curl "https://supportform.apple.com/201107/SerialNumberEligibilityAction.do?cb=iMacHDCheck.response&sn=${COMPSERIAL}" 2>/dev/null | awk -F: '{print $3}' | tr -d \"}\)`

echo "$COMPNAME,$COMPSTATUS" >> output.csv

done

exit 0
