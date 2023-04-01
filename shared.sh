#!/bin/bash

TEST="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SPEC_ROOT=~/spec
SPEC_OUTPUT=~/spec_out
BACKGROUND_OUTPUT=~/spec_background
#BENCHS=( "cactuBSSN_s" "lbm_s" "xz_s" "mcf_s"  ) #memory intensive workloads
BENCHS=(  "lbm_s" "xz_s" "mcf_s"  ) #memory intensive workloads
#CORES=( "0" "1" "2" "3" )
CORES=(  "1" "2" "3" )

build_bench(){
	runcpu --action runsetup --output-root $SPEC_OUTPUT $1
	runcpu --action runsetup --output-root $BACKGROUND_OUTPUT $1
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


launch_bench(){
	taskset -c $1 runcpu --nobuild --action run --output-root $SPEC_OUTPUT $2
}
launch_workload_replicator(){
	while [ -e /proc/$3 ];
	do
		sleep 5
	done
	taskset -c $1 runcpu --nobuild --action onlyrun --output-root $BACKGROUND_OUTPUT $2
}

spec_proc(){
	echo $$
	wait

	launch_bench_onlyrun $1 $2
}

run_all(){
	RUNNING_SPECS=()
	echo > og_pids.txt
	for ((i=0;i<${#CORES[@]};++i)); do
		bench=${BENCHS[i]}
		core=${CORES[i]}
		2>1 >/dev/null launch_bench $core $bench & 
		pid=$!
		echo "$bench pid: $pid" | tee -a og_pids.txt
		RUNNING_SPECS+=( "$pid" )
		2>1 >/dev/null launch_workload_replicator $core $bench $pid &
	done

	echo ${RUNNING_SPECS[*]} | tee -a og_pids.txt
}

function kill_bench {
    pid=`pgrep $1`
    if [ -n "$pid" ]; then
	{ sudo kill $pid && sudo wait $pid; } 2>/dev/null
    fi
}

function kill_all {
	for ((i=0;i<${#BENCHS[@]};++i)); do
		bench=${BENCHS[i]}
		kill_bench $bench
	done
}

cd $SPEC_ROOT
source shrc
cd $TEST
