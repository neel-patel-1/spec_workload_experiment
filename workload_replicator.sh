#!/bin/bash

source shared.sh

while [ -e /proc/$3 ];
do
	sleep 5
	echo "$2 (pid: $3) still running" | tee -a $MON_LOG
done
echo "$2 finished -- starting background" | tee -a $MON_LOG
taskset -c $1 runcpu --nobuild --action onlyrun --output-root $SPEC_OUTPUT $2
