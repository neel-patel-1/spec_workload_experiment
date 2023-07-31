#!/bin/bash

source shared.sh

mkdir -p $SPEC_OUTPUT
mkdir -p $SPEC_CORE_OUTPUT
mkdir -p $BACKGROUND_OUTPUT
mkdir -p $ANTAGONIST_OUTPUT


echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

build_all
run_all_spec_no_replacement_no_antagonist

#mkdir -p perlbench8x_r2
#cp -r $SPEC_OUTPUT/result/* perlbench8x_r2
#cp antagonist_output/antagonist_log.txt perlbench8x_r2
