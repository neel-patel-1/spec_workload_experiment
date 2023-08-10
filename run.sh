#!/bin/bash

source shared.sh

mkdir -p $SPEC_OUTPUT
mkdir -p $SPEC_CORE_OUTPUT
mkdir -p $BACKGROUND_OUTPUT
mkdir -p $ANTAGONIST_OUTPUT


echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

build_all

run_all_spec_no_antagonist
mkdir -p no_antagonist
mv spec_out/result/* no_antagonist
mv antagonist_output/antagonist_log.txt no_antagonist/antagonist.log
kill_all_bench


run_all_spec_with_antagonist
mkdir -p with_antagonist
mv spec_out/result/* with_antagonist
mv antagonist_output/antagonist_log.txt with_antagonist/antagonist.log
kill_all_bench

./parse_results.sh
