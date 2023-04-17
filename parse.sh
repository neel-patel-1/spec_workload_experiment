#!/bin/bash

source shared.sh
dir=$TEST/spec_out/result
#dir=$TEST/8x_fotonik_antagonist_4td
echo "Benchmarks      Threads  Run Time     Ratio"
uniq_benchs=( `printf "%s\n"  "${BENCHS[@]}" | sort | uniq` )

for bench in "${uniq_benchs[@]}"; do
	ls $dir/*.txt | xargs -I {} sh -c "grep -e '$bench' {}| awk 'NF>3{print \$0}' | grep -v -e 'enough runs' -e'invalid' -e 'not valid' -e 'return' -e '-march' -e'No flags' | sort -d -t. -k2 | uniq " 
done
