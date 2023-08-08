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
	* For MICRO 2023 Artifact Evaluators we have provided a genilib script and instructions for regenerating results on a cloudlab instance:


#### Artifact Evaluation Instructions:
To ease reproducibility for our artifact evaluators we have created a cloudlab environment and setup closely matching the server configuration used in the MICRO 2023 paper `XFM:Accelerating Far Memory using Near Memory Processing`

Following the instructions below will provision a cloudlab instance in which the SPEC 2017 and (de)compression workloads
from the paper will be executed. For more information, refer to [`XFM:Accelerating Far Memory using Near Memory Processing`](https://www.micro56.org/)

* allocate a cloudlab instance using the genilib script provided in this repo
	* Create a cloudlab account if needed
	* Navigate to `Experiments`, then `Create Experiment Profile`, and upload `spec_eval.profile`

* we have provided a SPEC 2017 Image which can be used for building an official SPEC 2017 benchmark set for the duration of the evaluation process
	* it can be fetched via ``
* prepare SPEC 2017 for workload evaluation

```sh
mkdir spec_mnt
sudo mount -t iso9660 -o ro,exec,loop cpu2017-1_0_5.iso ./spec_mnt
cd spec_mnt
./install.sh -d ../spec 

# change SPEC_ROOT to /users/<username>/spec in shared.sh

cp config/default.cfg  /users/<username>/spec/config/

cd lzbench
make
```

* install dependencies
```sh
sudo apt update
sudo apt install gfortran

# change config/default.cfg gccdir to /usr
```

* run jobmix1 configuration with and without (de)compression antagonists

```sh
./fetch_corpus.sh # fetches and prepares the corpus files for testing
./run.sh # run both spec jobmix1 configurations
./parse.sh # parse results and print SPEC Runtimes and Rates
```

* Note: As SPEC 2017 is a licensed software, we ask reviewers and reproducers to consider gaining access to a SPEC 2017 distribution (e.g., in the form of a disk image `cpu2017-1_0_5.iso`) and attempt reproduction of the results above. Please reach out if this is infeasible and we will work to add freely accessible benchmarks to the set of corunning applications
	* License: https://www.spec.org/cpu2017/Docs/licenses/SPEC-License.pdf

* execute ./run.sh
* Change SPEC\_CORES and BENCHS in `shared.sh` to the cores and workloads to corun with the (De)compression threads
* Change COMP\_CORES to a non-overlapping set of cores on which to run the (de)compressor threads
### Parsing Results
* execute `./parse.sh` to view the runtimes of the executed SPEC workloads generated during the previous step
