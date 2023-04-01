
shared.sh - functions for starting/stopping SPEC processes ( modify spec workloads/core assignment here )

workload\_replicator.sh - starts passed in workload on the provided core after waiting for the provided PID to terminate

experiment\_terminator.sh - terminates all running antagonists and background spec jobs after all reportable spec runs have completed

run.sh - executes spec workloads on cores assigned in shared.sh 
