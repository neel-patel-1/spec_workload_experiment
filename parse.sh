#!/bin/bash

source shared.sh
dir=spec_out/no_antagonist_run_1
echo "Benchmarks      Threads  Run Time     Ratio"
for bench in "${BENCHS[@]}"; do
	ls $dir/*.txt | xargs -I {} sh -c "grep -e '$bench' {}| awk 'NF==5{print \$0}' | head -n1 " 
done
