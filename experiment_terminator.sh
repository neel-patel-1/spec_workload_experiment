#!/bin/bash

source shared.sh

warn_freq=60

if [ ! -z "${BENCH_ALIASES[0]}" ]; then
	uniq_pids=( $(uniq_spec_pids_aliases) )
else
	uniq_pids=( $( uniq_spec_pids ) )
fi

if [ -z "${uniq_pids[0]}" ]; then
	echo "Failed to detect workload PIDs..." | tee -a $MON_LOG
	echo "Please attempt waiting for application startup and run \"taskset -c 0 ./experiment_terminator.sh\" manually..." | tee -a $MON_LOG
	exit 1
fi

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

echo "EXPERIMENT ENDED" | tee -a $MON_LOG
