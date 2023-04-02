#!/bin/bash

source shared.sh

mkdir -p $SPEC_OUTPUT
mkdir -p $BACKGROUND_OUTPUT
mkdir -p $ANTAGONIST_OUTPUT

build_all
run_all_spec_no_antagonist

mkdir -p no_antagonist_spec_output
cp -r $SPEC_OUTPUT no_antagonist_spec_output
mkdir -p no_antagonist_background_output
cp -r $BACKGROUND_OUTPUT no_antagonist_background_output
mkdir -p no_antagonist_antagonist_output
cp -r $ANTAGONIST_OUTPUT no_antagonist_antagonist_output

build_all
run_all_spec_with_antagonist

mkdir -p antagonist_spec_output
cp -r $SPEC_OUTPUT antagonist_spec_output
mkdir -p antagonist_background_output
cp -r $BACKGROUND_OUTPUT antagonist_background_output
mkdir -p antagonist_antagonist_output
cp -r $ANTAGONIST_OUTPUT antagonist_antagonist_output
