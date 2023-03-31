#!/bin/bash

SPEC_ROOT=~/spec
SPEC_OUTPUT=~/spec_out
BACKGROUND_OUTPUT=~/spec_background
BENCHS=( "cactuBSSN_s" "lbm_s" "xz_s" "mcf_s"  ) #memory intensive workloads
CORES=( "0" "3" )

build_bench(){
	runcpu --action runsetup --output-root $SPEC_OUTPUT $1
}

build_all(){
	for ((i=0;i<${#BENCHS[@]};++i)); do
		bench=${BENCHS[i]}
		build_bench $bench
	done
}


launch_bench(){
	taskset -c $1 runcpu --action run --output-root $SPEC_OUTPUT $2
}
launch_bench_onlyrun(){
	taskset -c $1 runcpu --action onlyrun --output-root $BACKGROUND_OUTPUT $2
}
spec_proc(){
	launch_bench $1 $2
	# check for any reportable spec processes remaining
	if [ ! "$fin_spec" -lt "${#CORES[@]}" ]; then
		kill_all
	else
		launch_bench_onlyrun $1 $2
	fi

}

run_all(){
	for ((i=0;i<${#CORES[@]};++i)); do
		bench=${BENCHS[i]}
		core=${CORES[i]}
		launch_bench $core $bench &
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
