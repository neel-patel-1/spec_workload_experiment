#!/bin/bash

source shared.sh

mkdir -p $SPEC_OUTPUT
mkdir -p $SPEC_CORE_OUTPUT
mkdir -p $BACKGROUND_OUTPUT
mkdir -p $ANTAGONIST_OUTPUT


echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

build_all
run_all_spec_no_antagonist

mkdir -p roms_4x_perlbench_4x_
cp -r $SPEC_OUTPUT/result/* roms_4x_perlbench_4x_
cp antagonist_output/antagonist_log.txt roms_4x_perlbench_4x_
