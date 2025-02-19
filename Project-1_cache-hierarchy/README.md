# NATIONAL TECHNICAL UNIVERSITY OF ATHENS
## SCHOOL OF ELECTRICAL AND COMPUTER ENGINEERING
## COMPUTER SYSTEMS LABORATORY
www.cslab.ece.ntua.gr

# EXERCISE 1 - ADVANCED COMPUTER ARCHITECTURE
Academic year 2019-2020, 8th Semester, School of ECE  
Final Submission Date: 12/04/2020

## 1. Introduction
In this exercise, you will use the "PIN" tool to study the effect of various memory hierarchy parameters on the performance of a set of applications. The goal of the exercise is to become familiar with the PIN tool and with the process of conducting experimental measurements to draw useful conclusions.

## 2. The PIN Tool 
PIN is a tool developed and maintained by Intel used for application analysis. It is used for dynamic binary instrumentation, which means inserting code dynamically (during application execution) between application instructions to collect information about the execution (e.g. cache misses, total instructions etc.).

More information about PIN and user manuals can be found here:  
https://software.intel.com/en-us/articles/pin-a-dynamic-binary-instrumentation-tool

## 3. Downloading and Installing PIN
To install PIN on your system, download it from:  
https://software.intel.com/en-us/articles/pintool-downloads

PIN depends directly on the operating system kernel, so there is a possibility that some PIN versions may be incompatible with specific Linux kernel versions. The steps presented below for executing PIN have been tested successfully using its most recent version (3.13) on Ubuntu 18.04 (with kernel version 4.15).

After downloading the file, you should extract it by running the following command in a terminal:
```bash
$ tar xvfz pin-3.13-98189-g60a6ef199-gcc-linux.tar.gz
```

Now you can navigate through PIN's contents:
```bash
$ cd pin-3.13-98189-g60a6ef199-gcc-linux
$ ls -aF
./ ../ README doc/ extras/ ia32/ intel64/ licensing/ pin pin.sig source/
```

The pin executable is what you'll use to run applications in your experiments. To see how to use pin.sh you can run it without arguments:
```bash
$ ./pin

E: Missing application name
Pin: pin-3.13-98189-60a6ef199
Copyright 2002-2019 Intel Corporation.
Usage: pin [OPTION] [-t <tool> [<toolargs>]] -- <command line>
Use -help for a description of options
```

With the -t argument you tell PIN which pintool to use, while <command line> is the executable to be analyzed by PIN along with its arguments. Here's an example of running pin:

```bash
$ cd source/tools/ManualExamples/
$ make obj-intel64/inscount0.so
$ cd ../../../
$ ./pin -t ./source/tools/ManualExamples/obj-intel64/inscount0.so \
 -o ls.inscount0.output -- /bin/ls -aF
./ ../ README* doc/ extras/ ia32/ intel64/ licensing/
ls.inscount0.output pin* pin.log pin.sig* source/
$ cat ls.inscount0.output
Count 891593
```

In the above example, the pintool inscount0.so was used which counts the total number of executed instructions. Pintools are programs written in C++ that are used by PIN and communicate with it through its API to direct application analysis. You can write your own pintools but there are also several provided with PIN. You'll find them in the pin-3.13-98189-g60a6ef199-gcc-linux/source/tools/ folder. To compile them you can run the make command in the folder you're interested in.

## 4. Benchmarks
PIN can be used to execute any application. For this exercise, you will use the PARSEC benchmarks for which you can find more information here:  
http://parsec.cs.princeton.edu/

Download version 3.0 of the suite from:  
http://parsec.cs.princeton.edu/download/3.0/parsec-3.0-core.tar.gz

You will also need the input files for the benchmarks which you can download from:  
http://parsec.cs.princeton.edu/download/3.0/parsec-3.0-input-sim.tar.gz

Then extract the downloaded files:
```bash
$ tar xvfz parsec-3.0-core-tar.gz
$ tar xvfz parsec-3.0-input-sim.tar.gz
```

The suite includes 13 benchmarks and various input files. For the purposes of this exercise you will use the following 10 benchmarks with simlarge input files:

1. blackscholes
2. bodytrack  
3. canneal
4. facesim
5. ferret
6. fluidanimate
7. freqmine
8. raytrace
9. swaptions
10. streamcluster

In each benchmark's code, the regions of code that present the greatest interest (Regions of Interest, ROI) have been defined. The ROIs are defined by calls to __parsec_roi_begin() and __parsec_roi_end() functions.

For managing (compiling, executing etc.) the PARSEC benchmarks, the bin/parsecmgmt script is provided whose most important parameters are:

-a action: the action to be performed, e.g. build, run, status  
-p benchmark: the name of the benchmark to compile or execute   
-c config-file: the configuration file to be used for compilation.  
                The following are provided among others:  
                - gcc-serial: compilation of serial benchmarks  
                - gcc-pthreads: compilation of parallel benchmarks using pthreads  
                - gcc-hooks: compilation of parallel benchmarks using pthreads and ROI hooks  

Since no config file is provided that compiles the serial version of benchmarks while using ROI hooks, the gcc-serial config files will need to be modified. The cslab_process_parsec_benchmarks.sh script provided with the exercise helper code makes all the appropriate modifications and should be executed inside the parsec-3.0 folder.

To compile the benchmarks that will be used in the experimental part of the exercise, run the following commands:

```bash
$ ~/advcomparch-2019-20-ex1-helpcode/cslab_process_parsec_benchmarks.sh
$ sudo apt-get update
$ sudo apt-get install make g++ libx11-dev libxext-dev libxaw7 \
x11proto-xext-dev libglu1-mesa-dev libxi-dev libxmu-dev
$ ./bin/parsecmgmt -a build -c gcc-serial -p blackscholes bodytrack \
canneal facesim ferret fluidanimate freqmine raytrace streamcluster \
swaptions
```

Depending on your compiler version, you may encounter problems compiling facesim and ferret. The solution for both cases is described in the course mailing list archives:  
http://lists.cslab.ece.ntua.gr/pipermail/advcomparch/2017-March/001432.html  
http://lists.cslab.ece.ntua.gr/pipermail/advcomparch/2019-March/001606.html

Next, run the cslab_create_parsec_workspace.sh script which will create a parsec_workspace folder containing all the executables you'll need as well as all input files for the benchmarks. Finally, in the helper code you are given the cmds_simlarge.txt file which contains the commands for executing each benchmark. We have chosen not to use the parsecgmt script for executing the benchmarks, as using it creates additional processes during benchmark execution, which could affect your measurements.

```bash
$ ~/advcomparch-2019-20-ex1-helpcode/cslab_create_parsec_workspace.sh
$ cd parsec_workspace
$ cp ~/advcomparch-2019-20-ex1-helpcode/cmds_simlarge.txt .
$ cat cmds_simlarge.txt
./executables/blackscholes 1 inputs/in_64K.txt prices.txt
./executables/bodytrack inputs/sequenceB_4 4 4 4000 5 0 1
./executables/canneal 1 15000 2000 inputs/400000.nets 128
./executables/facesim -timing -threads 1
./executables/ferret inputs/corel lsh inputs/queries 10 20 1 output.txt
./executables/fluidanimate 1 5 inputs/in_300K.fluid out.fluid
./executables/freqmine inputs/kosarak_990k.dat 790
./executables/rtview inputs/happy_buddha.obj -automove -nthreads 1 -frames 3 -res 1920 1080
./executables/streamcluster 10 20 128 16384 16384 1000 none output.txt 1
./executables/swaptions -ns 64 -sm 40000 -nt 1
```

Before executing any benchmark, you must set the LD_LIBRARY_PATH environment variable to point to the PATH containing the hooks library:

```bash
$ export LD_LIBRARY_PATH=~/parsec-3.0/pkgs/libs/hooks/inst/amd64-linux.gcc-serial/lib
```

## 5. PINTOOL: simulator
In the exercise helper code you will find the simulator.cpp pintool, which you will use to simulate application execution in an environment with an in-order processor, two-level cache hierarchy (L1-Data + L2 caches) and address translation memory (TLB). The simulator.cpp is written to be activated only during PARSEC ROIs.

Memory Hierarchy Simulation:  
For all cases examined in this experiment, the parameters of the L2 cache and TLB will be kept constant and specifically equal to:
- L2 size = 1024 KB
- L2 associativity = 8  
- L2 block size = 128 B
- TLB size = 64 entries
- TLB associativity = 4
- TLB page size = 4096 B

The simulator pintool accepts the following arguments:  
-o <filename>: output file where simulation parameters and statistics will be stored  
-L1c: L1 size (KB)  
-L1a: L1 associativity    
-L1b: L1 block size (bytes)  
-L2c: L2 size (KB)  
-L2a: L2 associativity  
-L2b: L2 block size (bytes)   
-L2prf: number of blocks prefetched to L2 (default value 0 disables prefetching)  
-TLBe: TLB size in entries  
-TLBa: TLB associativity  
-TLBp: memory page size used by TLB (bytes)  

With appropriate modifications, the simulator pintool can also simulate different strategies regarding write allocation or different replacement policies in caches and TLB.

Example usage of simulator pintool:
```bash
$ /path/to/pin -t /path/to/simulator.so -o output.txt -L1c 64 -L1a 8 -L1b 64 -L2c 256 -L2a 8 -L2b 64 -TLBe 64 -TLBa 4 -TLBp 4096 -- ./blackscholes 1 in_64K.txt prices.txt
```

The cache hierarchy that will be used in this exercise is depicted in the diagram. Specifically, the simulator pintool simulates an in-order processor with the inclusive memory hierarchy and address translation shown in the diagram.

For calculating the performance of applications used in simulations, a simple model is used where we consider that each instruction requires 1 cycle for execution (IPC=1).

Additionally, instructions that access memory (either load or store) cause additional delays depending on whether address translations are found in the TLB and where their data is located. We consider that L1 is implemented as a Virtually indexed, Physically tagged (VIPT) cache, meaning that TLB and L1 cache accesses overlap and are performed in parallel. If the requested translation is not found in the TLB (TLB miss), then a 100-cycle delay is introduced that simulates the delay of retrieving the address translation from memory (page walk), and then memory hierarchy access is performed through the L1 cache.

The TLB module of the simulator is used only to study the effect of address translation on program performance in terms of execution time, and not to provide actual address translation to physical space. That is, during simulation the cache module uses virtual addresses for accessing data memory and checking cache hits/misses.

Therefore, as you can see in the above diagram we have the following cases:
1. TLB hit: 0 cycles (access happens in parallel with L1 cache)
2. TLB miss: 100 cycles
3. L1 hit: 1 cycle
4. L2 hit: 15 cycles  
5. Main memory access: 250 cycles

The above cycle values can also be given as parameters during memory hierarchy initialization in the simulator pintool.

In total, the number of cycles is calculated as:  
Cycles = Inst + TLB_Misses*TLB_miss_cycles + L1_Accesses * L1_hit_cycles + L2_Accesses * L2_hit_cycles + Mem_Accesses * Mem_acc_cycles

## 7. Experimental Evaluation

### 7.1 L1 cache
Execute benchmarks for the following L1 caches:

| L1 size | L1 associativity | L1 cache block size |
|---------|------------------|---------------------|
| 32KB    | 4                | 64B                |
| 32KB    | 8                | 32B, 64B, 128B     |
| 64KB    | 4                | 64B                |
| 64KB    | 8                | 32B, 64B, 128B     |
| 128KB   | 8                | 32B, 64B, 128B     |

### 7.2 L2 cache 
Execute benchmarks for the following L2 caches:

| L2 size  | L2 associativity | L2 cache block size |
|----------|------------------|---------------------|
| 512 KB   | 8                | 64B, 128B, 256B    |
| 1024 KB  | 8, 16            | 64B, 128B, 256B    |
| 2048 KB  | 16               | 64B, 128B, 256B    |

### 7.3 TLB
Execute benchmarks for the following TLB configurations:

| TLB size | TLB associativity | TLB page size |
|----------|------------------|---------------|
| 8        | 4                | 4096B         |
| 16       | 4                | 4096B         |
| 32       | 4                | 4096B         |
| 64       | 1,2,4,8,16,32,64 | 4096B         |
| 128      | 4                | 4096B         |
| 256      | 4                | 4096B         |

### 7.4 Prefetching
In all previous simulations, prefetching is disabled. Appropriately extend the code so that the system simulates prefetching in the L2 cache. Specifically, for each L2 miss the cache should fetch, besides the requested block, the next n blocks, where n is defined by the L2prf parameter.

Execute benchmarks for n = 1, 2, 4, 8, 16, 32, 64.

### 7.5 Deliverables

1) As a basic performance metric you will use IPC (Instructions Per Cycle). Assuming that the machine cycle and executed number of instructions remain constant each time, higher IPC values indicate better performance.

For each of the above cases study the changes in IPC and cache performance whose parameters you vary. Present these changes in graphs for each case. Summarize the conclusions from the previous questions. What conclusions can you draw about the benchmarks you executed? Which of the parameters you examined have the greatest impact on performance?

2) In the previous analysis you assumed that the clock cycle remains constant. In practice however, various modifications to the processor's microarchitectural characteristics usually bring changes to the cycle duration as well.

Return to the previous questions, considering each time as initial reference point the first simulation you are called to execute in each of them. If each doubling of associativity or size causes a cycle increase of 5% or 10% respectively, how are the conclusions you draw affected?

The deliverable for this exercise will be an electronic document (pdf, docx or odt). In the electronic document, state your details (Name, Surname, Registration Number) at the beginning.

The exercise will be submitted electronically at:  
http://www.cslab.ece.ntua.gr/courses/advcomparch/submit

Work individually. It has particular value for understanding the course to do the work on your own. Don't try to copy it from other fellow students.

Don't leave the work for the last weekend, it requires considerable time for organization and execution of all simulations, so start immediately!