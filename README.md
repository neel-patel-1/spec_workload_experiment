# Spec Workload (De)Compression Corunning Experiment

* Corresponds to figure 10 in [XFM:Accelerating Far Memory using Near Memory Processing](https://www.micro56.org/)<br>

## Directory Hierarchy
```
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

* we have provided a SPEC 2017 Image which can be used during the duration of the Artifact Evaluation process only for reproducing the results in [`XFM:Accelerating Far Memory using Near Memory Processing`](https://www.micro56.org/). 
* An official SPEC 2017 benchmark set for the duration of the evaluation process can be fetched via `wget https://ae_private_resources.amazonaws.com/cpu2017-1_0_5.iso`
* Next prepare SPEC 2017 for workload evaluation:

```sh
mkdir spec_mnt
mkdir spec
sudo mount -t iso9660 -o ro,exec,loop /path/to/cpu2017-1_0_5.iso ./spec_mnt
cd spec_mnt
./install.sh -d ../spec 

# respond with yes when prompted

# change SPEC_ROOT to /path/to/spec in shared.sh

# change config/default.cfg gcc_dir to /usr

cp config/default.cfg  /path/to/spec/config/
```

* install dependencies
```sh
sudo apt update
sudo apt install gfortran
```

* Build Compression/Decompression Antagonist thread workload and fetch sample files
```sh
./fetch_corpus.sh
cd lzbench
make -j BUILD_STATIC=1
```

* run jobmix1 configuration with and without (de)compression antagonists
```sh
cd $spec_workload_experiment_root
./run.sh # run both spec jobmix1 configurations and print job degradation between antagonist and baseline configurations
```

* Note: As SPEC 2017 is a licensed software, we ask reviewers only utilize the provided SPEC 2017 distribution (e.g., in the form of a disk image `cpu2017-1_0_5.iso`) for the use of reproducing the results presented in [`XFM:Accelerating Far Memory using Near Memory Processing`](https://www.micro56.org/).
	* License: https://www.spec.org/cpu2017/Docs/licenses/SPEC-License.pdf

#### Testing other corunning workloads and configurations
* Change SPEC\_CORES and BENCHS in `shared.sh` to the cores and workloads to corun with the (De)compression threads
* Change COMP\_CORES to a non-overlapping set of cores on which to run the (de)compressor threads

#### Parsing Results
* execute `./parse.sh` to view the runtimes of the executed SPEC workloads generated during the previous step
