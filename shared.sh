#!/bin/bash

export TEST="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export SPEC_ROOT=~/spec
export SPEC_OUTPUT=$TEST/spec_out
export BACKGROUND_OUTPUT=$TEST/spec_background

SPEC_CORES=( `seq 1 3` )
BENCHS=( "lbm_s" "xz_s" "mcf_s"  ) #memory intensive workloads
SPEC_CORES+=( `seq 11 13` )
BENCHS+=( "lbm_s" "xz_s" "mcf_s"  ) #memory intensive workloads

export SPEC_LOG=spec_log.txt
export MON_LOG=mon_log.txt

export QZ_ROOT=$TEST/../QATzip
export ANTAGONIST=$TEST/../antagonist.sh
export ANTAGONIST_OUTPUT=$TEST/antagonist
export COMP_CORES=(  "9" "19"  )

export MON_CORE="0" #only check for workload completion and handle experiment termination

build_bench(){
	runcpu --action runsetup --output-root $SPEC_OUTPUT $1
}
clear_build(){
	go $1
	rm -rf build
}

build_all(){
	for ((i=0;i<${#BENCHS[@]};++i)); do
		bench=${BENCHS[i]}
		build_bench $bench
	done
}



run_all(){
	RUNNING_SPECS=()
	echo > $SPEC_LOG
	echo > $MON_LOG

	for ((i=0;i<${#COMP_CORES[@]};++i)); do
		core=${COMP_CORES[i]}
		taskset -c $core $TEST/../antagonist.sh 2>&1 1>$ANTAGONIST_OUTPUT/antagonist_stats_core_$core &
	done

	for ((i=0;i<${#SPEC_CORES[@]};++i)); do
		bench=${BENCHS[i]}
		core=${SPEC_CORES[i]}
		#2>1 >/dev/null taskset -c $core runcpu --nobuild --action run --output-root $SPEC_OUTPUT $bench &
		taskset -c $core runcpu --nobuild --action run --output-root $SPEC_OUTPUT $bench 2>&1 | tee -a $SPEC_OUTPUT/spec_reportable_core_$core &
		echo "run-cpu-initial-$bench: pid-$!" | tee -a $SPEC_LOG
	done

	#sleep 10
	for ((i=0;i<${#SPEC_CORES[@]};++i)); do
		bench=${BENCHS[i]}
		core=${SPEC_CORES[i]}
		while [ -z "$(pgrep $bench)" ]; do echo "waiting to find running $bench" | tee -a $MON_LOG ; done
		echo "taskset -c $MON_CORE ./workload_replicator.sh $core $bench $(pgrep $bench) &" | tee -a $MON_LOG
		taskset -c $MON_CORE ./workload_replicator.sh $core $bench $(pgrep $bench) 2>&1 1>$SPEC_OUTPUT/workload_rep_core_$core &
		echo "$bench: workload-replicator-pid-$!" | tee -a $MON_LOG
	done
	taskset -c $MON_CORE ./experiment_terminator.sh

}

function kill_bench {
    pid=`pgrep $1`
	echo "killing $1: $pid" | tee -a $MON_LOG
    if [ -n "$pid" ]; then
	{ sudo kill $pid && sudo wait $pid; } 2>/dev/null
    fi
}
function kill_all_bench {
	for ((i=0;i<${#BENCHS[@]};++i)); do
		bench=${BENCHS[i]}
		kill_bench $bench
	done
}

cd $SPEC_ROOT
source shrc
cd $TEST
