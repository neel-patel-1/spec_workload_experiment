#!/bin/bash

source shared.sh

mkdir -p $SPEC_OUTPUT
mkdir -p $SPEC_CORE_OUTPUT
mkdir -p $BACKGROUND_OUTPUT
mkdir -p $ANTAGONIST_OUTPUT


build_all
run_all_spec_no_replacement

mkdir -p no_replacement_run
cp -r $SPEC_OUTPUT no_replacement_run
