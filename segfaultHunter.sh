#!/bin/bash

# $1 file of the strace output
# 

epoch=$(date +%s)
pidofMysqld=$(pidof mysqld)
coreDumpDir=/var/spool/abrt/
logMessages=/var/log/messages
tempMessages=.tempMessages
hashStamp=."$(basename $0 | sed 's/.sh//g')".hash
traceLog=$(basename $0 | sed 's/.sh/.log/g')
lockFile=$(basename $0 | sed 's/.sh/.lock/g')
delayCheck=20
tokenFile=."$(basename $0 | sed 's/.sh//g')".token


trap "{ killStrace ; rm -f $lockFile ; rm -f $tempMessages ; exit 255; }" SIGINT SIGTERM

source $tokenFile

function HCNotif() {
	curl -d '{"color":"red","message":"Segfault found at Rock You at '"$hostname - hash $1"'","notify":false,"message_format":"text"}' -H 'Content-Type: application/json' https://blackbirdit.hipchat.com/v2/room/2160170/notification?auth_token=$token
}

function rotateLogOnTrigger() {
	mv $traceLog ${traceLog}-SEGFAULT-${epoch}
        gzip ${traceLog}-SEGFAULT-${epoch}
}

function killStrace() {
	pkill -9 strace
}

touch $lockFile
[[ -e $traceLog ]] && { mv $traceLog $traceLog$epoch ; gzip $traceLog$epoch ; echo "Rotated log to ${traceLog}${epoch}.gz" ; } 

strace -e trace=all -e signal=all -C -i -v -p $pidofMysqld -f -t  &> $traceLog &
pidStrace=$!

while(true) ; do
        sleep $delayCheck
        touch $tempMessages
        touch $hashStamp
	tail -n100 $logMessages | grep -A1 segfault | tail -n2 > $tempMessages
	[[ ! -s $tempMessages ]] && { kill -STOP $pidStrace ; truncate -s '<200KB' $traceLog ; kill -CONT $pidStrace  ; continue ; } 
	currentHash=$(md5sum $tempMessages | cut -f1 -d' ')
        lastHash=$(cat $hashStamp | cut -f1 -d' ')
        [[ "$lastHash" == "$currentHash" ]] && { truncate -s '<200KB' $traceLog ; continue ; } 
	md5sum $tempMessages  | cut -d' ' -f1 > $hashStamp
	#Notify me on the Hipchat
	HCNotif $currentHash
        killStrace
	rotateLogOnTrigger
	#countLines=$(wc -l $traceLog)
        break #TODO set a number of rounds to be executed
done

# Remove the lock file
rm -f $lockFile
rm -f $tempMessages

exit 0
