#!/bin/bash

source shared.sh

rs=()
for i in ${BENCHS[@]}; do 
	echo "exp_term pid enumeration: $i -- $(pgrep $i)" | tee -a $MON_LOG
	[ ! -z "$(pgrep $i)" ] && rs+=( "$(pgrep $i)" ) 
done

echo "waiting on: ${rs[@]} before terminating" | tee -a $MON_LOG

for i in "${rs[@]}"; do
	while [ -e /proc/$i ]; do
		sleep 3;
	done
done

echo "all reportable spec procs ended, terminating experiment..." | tee -a $MON_LOG

sudo kill `pgrep workload_rep` #TODO: why does pgrep only return pids for truncated script name
sudo kill `pgrep antagonist`
sudo kill `pgrep "test"` 
kill_all_bench
