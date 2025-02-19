# NATIONAL TECHNICAL UNIVERSITY OF ATHENS
SCHOOL OF ELECTRICAL AND COMPUTER ENGINEERING
COMPUTER SYSTEMS LABORATORY
www.cslab.ece.ntua.gr

# 3rd ASSIGNMENT - ADVANCED COMPUTER ARCHITECTURE TOPICS
Academic Year 2019-2020, 8th Semester, School of ECE
Final Submission Date: 7/6/2020

## 1. Introduction
In this assignment, you will use the "Sniper Multicore Simulator", which utilizes the "PIN" tool that you used in previous assignments. The goal of the assignment is to study the characteristics of modern superscalar, out-of-order processors and how they affect system performance, energy consumption, and processor chip size. Details and materials (presentations, code, manual, etc.) about the simulator can be found here:
http://snipersim.org/w/The_Sniper_Multi-Core_Simulator

## 2. Downloading and Installing Sniper
You can find version 7.3 of Sniper on the course website:
```bash
$ wget http://www.cslab.ece.ntua.gr/courses/advcomparch/files/askiseis/sniper7.3.tgz
$ tar xvfz sniper-7.3.tgz
$ cd sniper-7.3
```

To use the benchmark pinballs, as we explain below, you need to use Sniper with the version of Pin that includes the pinplay tool, which is provided on the course website:
```bash
$ wget http://software.intel.com/content/dam/develop/external/us/en/protected/pinplay-dcfg-3.11-pin-3.11-97998-g7ecce2dac-gcc-linux.tar.bz2
$ tar xvfj pinplay-dcfg-3.11-pin-3.11-97998-g7ecce2dac-gcc-linux.tar.bz2
```

After downloading Sniper and Pin, proceed with compiling Sniper using the following commands:
```bash
$ sudo apt-get update
$ sudo apt-get install python make g++ zlib1g-dev libbz2-dev libboost-dev libsqlite3-dev
$ export PIN_HOME=/path/to/pinplay-dcfg-3.11-pin-3.11-97998-g7ecce2dac-gcc-linux
$ make
```

Where /path/to/pin/pinplay-dcfg-3.11-pin-3.11-97998-g7ecce2dac-gcc-linux/ is the path where the PIN files are located.

The above compilation instructions have been successfully tested on:
- Ubuntu 18.04 with gcc-7
- Ubuntu 16.04 with gcc-5.4

On Ubuntu 20.04, the default gcc version is 9, with which Sniper compilation fails. In this case, you can use gcc version 7 which is available in the distribution repositories:
```bash
$ sudo apt-get install gcc-7 g++-7
$ CC=gcc-7 CXX=g++-7 make
```

## 3. Using Sniper
After compilation is complete, you can run Sniper through the run-sniper file:
```bash
$ ./run-sniper
```

Run program under the Sniper simulator
Usage:
```bash
./run-sniper [-n <ncores (1)>] [-d <outputdir (.)>] [-c <sniper-config>] [-c [objname:]<name[.cfg]>,<name2[.cfg]>,...] [-c <sniper-options: section/key=value>] [-s <script>] [--roi] [--roi-script] [--viz] [--viz-aso] [--profile] [--memory-profile] [--cheetah] [--perf] [--gdb] [--gdb-wait] [--gdb-quit] [--appdebug] [--appdebug-manual] [--appdebug-enable] [--follow-execv=1] [--power] [--cache-only] [--fast-forward] [--no-cache-warming] [--save-output] [--save-patch] [--pin-stats] [--wrap-sim=] [--mpi [--mpi-ranks=<ranks>] [--mpi-exec="<mpiexec -mpiarg...>"] ] {--traces=<trace0>,<trace1>,... [--sim-end=<first|last|last-restart (default: first)>] | --pinballs=<pinball-basename>,* | --pid=<process-pid> | [--sift] -- <cmdline> }
```

Example: 
```bash
$ ./run-sniper -- /bin/ls
```

From the parameters this script accepts, we are mainly interested in the following:
- `-d <outputdir>`: the folder where simulation statistics will be stored
- `-c <config-file>`: the file with the parameters of the system we are simulating
- `-g <options>`: setting simulation parameters
- `--viz`: enables visualizations for simulation results

## 5. Configuring Sniper
The configuration of simulated systems is done using config files, which are located in the sniper-7.3/config folder. There you can find configurations for various processors. For the purposes of this assignment, you will use the configuration for the gainestown processor, gainestown.cfg. Within the config file, various processor parameters are defined such as frequency, issue width, branch predictor, and memory hierarchy. For example, the following section defines the L1 data cache:

```
[perf_model/l1_dcache]
perfect = false
cache_block_size = 64
cache_size = 32
associativity = 8
replacement_policy = lru
...
```

Parameters not defined in this file are defined either in base.cfg, which is used in every simulation by run-sniper, or in nehalem.cfg, which is included from gainestown.cfg. You can also set simulation parameters through the command line using the -g option of run-sniper.

The parameters you are asked to experiment with in this assignment are dispatch_width and window_size. The first is the number of instructions that can be issued simultaneously (i.e., "how" superscalar our processor is), while the second is the size of the ROB. These parameters are located in the [perf_model/core/interval_timer] section of the config file. So, for example, with the following command you set dispatch_width and window_size equal to 8 and 256 respectively:

```bash
./run-sniper <other options> -g --perf_model/core/interval_timer/dispatch_width=8 -g --perf_model/core/interval_timer/window_size=256
```

In each simulation execution, the sim.cfg file is created in the results folder, which contains in detail all parameters with the values that were used.

## 6. McPAT
McPAT (Multi-core Power, Area, Timing) models processor characteristics such as energy consumption and the size occupied by different structural units of the processor on the chip. Sniper includes McPAT, which is used to extract statistics from a completed simulation folder. In the assignment's helper code, the advcomparch_mcpat.py script is additionally provided, which is a modified version of the mcpat.py contained in Sniper. The advcomparch_mcpat.py uses the gnuplot tool to display results in graph form. If gnuplot is not already installed on your computer, you can install it with the following command:

```bash
$ sudo apt-get install gnuplot
```

After copying advcomparch_mcpat.py to the sniper-7.3/tools folder, you can use it as follows:

```bash
$ /path/to/sniper-7.3/tools/advcomparch_mcpat.py -h
Usage: /home/user/advcomparch/sniper/tools/advcomparch_mcpat.py [-h (help)] [-j <jobid> | -d <resultsdir (default: .)>] [-t <type: total|dynamic|static|peak|peakdynamic|area>] [-c <override-config>] [-o <output-file (power{.png,.txt,.py})>]
```

From the parameters this script accepts, we are mainly interested in the following:
- `-d <resultsdir>`: the simulation folder
- `-t <type>`: the type of statistics we want to extract
- `-o <output-file>`: the name that the generated files will have

The script execution produces 4 files: power.png, power.py, power.txt, and power.xml. The first contains the graphical representation of various statistics. The second includes all statistics that have been generated in a format suitable for direct use in a python script, while the third includes the same statistics in text form. The .xml file is the file generated by Sniper and given as input to McPAT. advcomparch_mcpat.py also prints to the screen (or wherever you redirect the output) a summary of the statistics you specified with the -t argument. An example of its use is given below:

```bash
$ advcomparch_mcpat.py -d bench_dir -t total -o bench_dir/power > bench_dir/power.total.out
```

In some cases when you run advcomparch_mcpat.py it will return an error message of the form:
"ValueError: No valid McPAT output found"

This happens specifically in cases where the window size is quite small (<= 8). The problem is not related to the advcomparch_mcpat.py provided but with the operation of mcpat and the minimum specifications it sets for the processor it models. You can skip simulations with window size <= 8 in cases where you study the processor's energy consumption.

## 7. Energy-Delay Product
Traditionally, total energy consumption in Joules is used to evaluate a processor's consumption. However, many times it is required to study the effect of various processor characteristics not only on consumption but simultaneously on its performance. For this purpose, the energy-delay product (EDP) has been proposed as a metric. The EDP for the execution of a benchmark is defined as the product of energy times the execution time of the benchmark:

EDP = Energy(J) * runtime(sec)

Similarly, if we want to give more weight to execution time, we can raise runtime to the square, cube, etc. This gives us ED²P, ED³P and so on:

ED²P = Energy(J) * runtime²(sec)
ED³P = Energy(J) * runtime³(sec)

## 8. Benchmarks
Sniper can be used to run any application. In this assignment, you will use the SPEC_CPU2006 benchmarks, as in the previous assignment. Specifically, you will use the following 12 benchmarks:

1. 403.gcc
2. 429.mcf
3. 434.zeusmp
4. 436.cactusADM
5. 445.gobmk
6. 450.soplex
7. 456.hmmer
8. 458.sjeng
9. 459.GemsFDTD
10. 471.omnetpp
11. 473.astar
12. 483.xalancbmk

However, because execution using Sniper is very slow, you won't run entire benchmarks but will use the pinballs (simpoints we had discussed in class for simulations) provided on the Sniper website:

```bash
$ wget http://snipersim.org/documents/pinballs/cpu2006-pinpoints-w0-d1B-m1.tar
$ tar xvf cpu2006-pinpoints-w0-d1B-m1.tar
$ ls cpu2006_pinballs
```

To run a benchmark using the appropriate pinball, enter:

```bash
$ ./run-sniper -c gainestown -d sim.out --pinballs=/path/to/cpu2006_pinballs/gcc/pinball_short.pp/pinball_t0r1_warmup3000_prolog0_region1000000002_epilog0_001_1-00000.0.address
```

## 9. Experimental Evaluation
Run all benchmarks for each different processor resulting from the combination of the following values for the parameters dispatch_width and window_size:

| dispatch_width | 1 | 2 | 4 | 8 | 16 | 32 |
|---------------|---|---|---|---|----|----| 
| window_size   | 1 | 2 | 4 | 8 | 16 | 32 | 64 | 96 | 128 | 192 | 256 | 384 |

i) Do you really need to simulate all 72 different processors that result from the above values? If not, explain which cases you can skip and why. Justify your answer not only theoretically but also by proving for a small number of these cases that you were right to skip them.

ii) How does each parameter affect processor performance? What conclusions can you draw regarding the design of a superscalar, out-of-order processor?

iii) How does each parameter affect energy consumption and chip size?

iv) Find the corresponding characteristics (dispatch_width, window_size) for your personal computer's processor or for one of the modern processors (e.g., Broadwell, Skylake, Kabylake). Are the values chosen in these systems by the architects justified based on the simulations you ran and the conclusions you reached? Would it make sense for them to be different (e.g., larger window_size)? Why do you think they didn't make a different choice?

The assignment deliverable will be an electronic document (pdf, docx, or odt). In the electronic document, state your details (Name, Surname, Student ID) at the beginning.

The assignment will be submitted electronically at the website:
http://www.cslab.ece.ntua.gr/courses/advcomparch/submit

Work individually. It has particular value for understanding the course to do the assignment on your own. Don't try to copy it from other fellow students.

Don't leave the assignment for the last weekend, it requires considerable time to execute all simulations, start immediately!
