
shared.sh - functions for starting/stopping SPEC processes ( modify spec workloads/core assignment here )

workload\_replicator.sh - starts passed in workload on the provided core after waiting for the provided PID to terminate

experiment\_terminator.sh - terminates all running antagonists and background spec jobs after all reportable spec runs have completed

compression\_antagonist.sh - compresses pages on assigned cores

run.sh - executes spec workloads on spec\_cores and (de)compression workloads on comp\_cores assigned in shared.sh 

parse.sh - print spec runtimes for results in spec\_out/result
