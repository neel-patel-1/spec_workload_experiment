#!/bin/bash

source shared.sh

rs=()
for i in ${BENCHS[@]}; do 
	[ ! -z "$(pgrep $i)" ] && rs+=( $(pgrep $i) ) 
done
uniq_pids=( `printf "%s\n"  "${rs[@]}" | sort | uniq` )

echo "waiting on: ${uniq_pids[*]} before terminating" | tee -a $MON_LOG

for i in "${uniq_pids[@]}"; do
	while [ -e /proc/$i ]; do
		sleep 3;
		sudo wall "*** Experiment in Progress ***"
	done
done

echo "all reportable spec procs ended, terminating experiment..." | tee -a $MON_LOG

sudo kill `pgrep workload_rep` #TODO: why does pgrep only return pids for truncated script name
sudo kill `pgrep antagonist`
sudo kill `pgrep "test"` 
kill_all_bench
