#!/bin/bash

source shared.sh

rm -rf $SPEC_OUTPUT/result
rm -rf $BACKGROUND_OUTPUT/result

mkdir -p $SPEC_OUTPUT
mkdir -p $BACKGROUND_OUTPUT
mkdir -p $ANTAGONIST_OUTPUT

run_all
