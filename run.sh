#!/bin/bash

source shared.sh

mkdir -p $SPEC_OUTPUT
mkdir -p $SPEC_CORE_OUTPUT
mkdir -p $BACKGROUND_OUTPUT
mkdir -p $ANTAGONIST_OUTPUT


echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

#build_all
#run_all_spec_with_antagonist
launch_antagonist_threads
sleep 2500
kill_antagonist
cp antagonist_output/antagonist_log.txt 4td_antagonist_baseline

#mkdir -p antagonist_lbm_s_9x
#cp -r $SPEC_OUTPUT antagonist_lbm_s_9x
