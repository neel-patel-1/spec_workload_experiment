#!/bin/bash

source shared.sh

warn_freq=60

uniq_pids=( $( uniq_spec_pids ) )

echo "waiting on: ${uniq_pids[*]} before terminating" | tee -a $MON_LOG

itr=0
for i in "${uniq_pids[@]}"; do
	while [ -e /proc/$i ]; do
		sleep 3;
		itr=$(( $itr + 1 ))
		[ "$REPORTABLE" = "1" ] && [ "$(( itr % 20 ))" = "0" ] && wall "*** Experiment in Progress ***"
	done
done

echo "all reportable spec procs ended, terminating experiment..." | tee -a $MON_LOG

kill_experiment
