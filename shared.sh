#!/bin/bash

TEST="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SPEC_ROOT=~/spec
SPEC_OUTPUT=~/spec_out
BACKGROUND_OUTPUT=~/spec_background
#BENCHS=( "cactuBSSN_s" "lbm_s" "xz_s" "mcf_s"  ) #memory intensive workloads
BENCHS=(  "lbm_s" "xz_s" "mcf_s"  ) #memory intensive workloads
#SPEC_CORES=( "0" "1" "2" "3" )
SPEC_CORES=(  "1" "2" "3" )
SPEC_LOG=spec_log.txt
MON_LOG=mon_log.txt

MON_CORE="0" #only check for workload completion and handle experiment termination

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
	for ((i=0;i<${#SPEC_CORES[@]};++i)); do
		bench=${BENCHS[i]}
		core=${SPEC_CORES[i]}
		#2>1 >/dev/null taskset -c $core runcpu --nobuild --action run --output-root $SPEC_OUTPUT $bench &
		taskset -c $core runcpu --nobuild --action run --output-root $SPEC_OUTPUT $bench &
		echo "run-cpu-initial-$bench: pid-$!" | tee -a $SPEC_LOG
	done

	sleep 3
	for ((i=0;i<${#SPEC_CORES[@]};++i)); do
		bench=${BENCHS[i]}
		core=${SPEC_CORES[i]}
		while [ -z "$(pgrep $bench)" ]; do echo "waiting to find running $bench" | tee -a $MON_LOG ; done
		echo "taskset -c $MON_CORE ./workload_replicator.sh $core $bench $(pgrep $bench) &" | tee -a $MON_LOG
		taskset -c $MON_CORE ./workload_replicator.sh $core $bench $(pgrep $bench) &
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
