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
cp -r spec_out/result/* no_antagonist

run_all_spec_with_antagonist
mkdir -p with_antagonist
cp -r spec_out/result/* with_antagonist

./parse_results.sh
