#!/bin/bash

source shared.sh

rm -rf $SPEC_OUTPUT/result
rm -rf $BACKGROUND_OUTPUT/result

build_all
run_all
