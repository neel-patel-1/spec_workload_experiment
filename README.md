# Spec Workload (De)Compression Corunning Experiment

* Corresponds to figure 10 in [XFM:Accelerating Far Memory using Near Memory Processing](https://www.micro56.org/)<br>

## Directory Hierarchy
```sh
Experiment Repo Root (This Repo)
 |---- shared.sh - functions for starting/stopping SPEC processes ( modify spec workloads/core assignment here )

 |---- workload\_replicator.sh - starts passed in workload on the provided core after waiting for the provided PID to terminate

 |---- experiment\_terminator.sh - terminates all running antagonists and background spec jobs after all reportable spec runs have completed

 |---- compression\_antagonist.sh - compresses pages on assigned cores

 |---- run.sh - executes spec workloads on spec\_cores and (de)compression workloads on comp\_cores assigned in shared.sh 

 |---- parse.sh - print spec runtimes for results in spec\_out/result
```

## Reproducing experimental results (fig. 10)
### Generating Results
* Change SPEC\_ROOT in `shared.sh` to the root directory of a SPEC 2017 installation
	* Follow instructions here to build spec: [SPEC\_2017 Quick Start Guide](https://www.spec.org/cpu2017/Docs/quick-start.html)
* execute ./run.sh
* Change SPEC\_CORES and BENCHS in `shared.sh` to the cores and workloads to corun with the (De)compression threads
* Change COMP\_CORES to a non-overlapping set of cores on which to run the (de)compressor threads
### Parsing Results
* execute `./parse.sh` to view the runtimes of the executed SPEC workloads generated during the previous step
