#!/bin/bash

source shared.sh
dir=$TEST/no_antagonist

uniq_benchs=( `printf "%s\n"  "${BENCHS[@]}" | sort | uniq` )

echo "Benchmarks      Threads  Run Time     Ratio" | tee no_antagonist.txt
for bench in "${uniq_benchs[@]}"; do
	ls $dir/*.txt | xargs -I {} sh -c "grep -e '$bench' {}| awk 'NF>3{print \$0}' | grep -v -e 'enough runs' -e'invalid' -e 'not valid' -e 'return' -e '-march' -e'No flags' | sort -d -t. -k2 | uniq " 
done | tee no_antagonist.txt

n_val=$(awk '$4~/RE/{count--} { sum += $3;count++ } END{ print sum/(count-1)}' no_antagonist.txt)

dir=$TEST/with_antagonist
echo "Benchmarks      Threads  Run Time     Ratio" | tee with_antagonist.txt
for bench in "${uniq_benchs[@]}"; do
	ls $dir/*.txt | xargs -I {} sh -c "grep -e '$bench' {}| awk 'NF>3{print \$0}' | grep -v -e 'enough runs' -e'invalid' -e 'not valid' -e 'return' -e '-march' -e'No flags' | sort -d -t. -k2 | uniq " 
done | tee with_antagonist.txt

a_val=$(awk '$4~/RE/{count--} { sum += $3;count++ } END{ print sum/(count-1)}' with_antagonist.txt)
echo "Degradation(%):"
n_val=2300
echo "(($a_val-$n_val)/$n_val) * 100 " 
echo "scale=4; (($a_val- $n_val)/$n_val) * 100 " | bc
