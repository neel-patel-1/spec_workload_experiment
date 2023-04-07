#!/bin/bash

source shared.sh

uniq_pids=( $( uniq_spec_pids ) )

echo "waiting on: ${uniq_pids[*]} before terminating" | tee -a $MON_LOG

for i in "${uniq_pids[@]}"; do
	while [ -e /proc/$i ]; do
		sleep 3;
	done
done

echo "all reportable spec procs ended, terminating experiment..." | tee -a $MON_LOG

kill_experiment
