#!/bin/bash

TEST="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SPEC_ROOT=~/spec
SPEC_OUTPUT=~/spec_out
BACKGROUND_OUTPUT=~/spec_background
BENCHS=( "cactuBSSN_s" "lbm_s" "xz_s" "mcf_s"  ) #memory intensive workloads
CORES=( "0" "3" )
export fin_spec=0

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
launch_bench_onlyrun(){
	taskset -c $1 runcpu --nobuild --action onlyrun --output-root $BACKGROUND_OUTPUT $2
}
spec_proc(){
	launch_bench $1 $2
	# check for any reportable spec processes remaining
	export fin_spec=$(( $finspec + 1 ))
	echo "$2 finished in exported ${fin_spec}'d" | tee -a core_log
	if [ ! "$fin_spec" -lt "${#CORES[@]}" ]; then
		echo "$2 bench complete ..." | tee -a core_log
		kill_all
	else
		launch_bench_onlyrun $1 $2
	fi

}

run_all(){
	echo > core_log
	for ((i=0;i<${#CORES[@]};++i)); do
		bench=${BENCHS[i]}
		core=${CORES[i]}
		spec_proc $core $bench &
	done
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
