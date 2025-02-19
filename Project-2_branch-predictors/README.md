# NATIONAL TECHNICAL UNIVERSITY OF ATHENS
SCHOOL OF ELECTRICAL AND COMPUTER ENGINEERING  
DEPARTMENT OF COMPUTER SCIENCE AND ENGINEERING  
COMPUTER SYSTEMS LABORATORY  
www.cslab.ece.ntua.gr

# EXERCISE 2 - ADVANCED COMPUTER ARCHITECTURE
Academic Year 2019-2020, 8th Semester, School of ECE  
Final Submission Date: 10/05/2020

## 1. Introduction
In this exercise, you will use the "PIN" tool to study the effect of different branch prediction systems and evaluate them based on the available chip space.

## 2. PINTOOL
In the exercise's helper code, you will find the pintools cslab_branch_stats.cpp and cslab_branch.cpp. After modifying the PIN_ROOT path in the makefile, compile them using:
```bash
$ cd advcomparch-2019-2-ex2-helpcode/pintool
$ make clean; make
```

The cslab_branch_stats.cpp is used to extract statistics about branch instructions executed by the application. Here's an example usage:
```bash
$ cd /path/to/advcomparch-2019-20-ex2-helpcode/spec_execs_train_inputs/434.zeusmp
$ /path/to/pin-3.6-97554-g31f0a167d-gcc-linux/pin \
-t/path/to/advcomparch-2017-18-ex2-helpcode/pintool/objintel64/cslab_branch_stats.so \
-o my_output.out -- \
./zeusmp_base.amd64-m64-gcc42-nn 1> zeusmp.out 2> zeusmp.err
```

Sample output:
```
Total Instructions: 103056416223
Branch statistics:
 Total-Branches: 7550195084
 Conditional-Taken-Branches: 3286815852
 Conditional-NotTaken-Branches: 3570524450
 Unconditional-Branches: 692782516
 Calls: 36135
 Returns: 36131
```

The cslab_branch.cpp is used to evaluate branch prediction techniques while simulating different Return Address Stack (RAS) sizes for return instructions. Here's an example usage:
```bash
$ /path/to/pin-3.6-97554-g31f0a167d-gcc-linux/pin \
-t /path/to/advcomparch-2017-18-ex2-helpcode/pintool/objintel64/cslab_branch.so \
-o my_output.out -- \
./zeusmp_base.amd64-m64-gcc42-nn 1> zeusmp.out 2> zeusmp.err
```

In the file branch_predictor.h, we define different branch predictors. To add a branch predictor, you need to create a new subclass of the BranchPredictor class and define three methods: predict(), update(), and getName(). The first function takes the instruction PC and target address as parameters and predicts whether the branch will be taken or not (Taken / Not Taken). The second method stores information required for future predictions. Its parameters are the predictor's prediction, the actual branch outcome, the instruction PC, and the target address. Finally, the getName() method is used to print the branch predictor's results in the pintool's output file.

## 3. Benchmarks
PIN can be used to execute any application. In this exercise, you will use SPEC_CPU2006 benchmarks. Specifically, you will use the following 12 benchmarks:

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

In the exercise's helper code, you are provided with the spec_execs_train_inputs folder which contains the executables and necessary input files for the above benchmarks.

## 4. Experimental Evaluation

### 4.1 Branch Instruction Study
In the first part of the experimental evaluation, the goal is to collect statistics about branch instructions executed by the benchmarks. Use cslab_branch_stats.cpp and for each benchmark, provide a diagram showing the number of executed branch instructions and the percentage belonging to each category (conditional-taken, conditional-nottaken, etc.).

### 4.2 Study of N-bit Predictors
Study the performance of n-bits predictors using their implementation in cslab_branch.cpp.

(i) Keeping the number of BHT entries constant at 16K, simulate n-bit predictors for N=1, 2, 3, 4. The n-bits implement a saturating up-down counter as seen in lectures. For N=2, additionally implement the following alternative FSM (as 2β). Compare the 5 predictors using the direction Mispredictions Per Thousand Instructions (direction MPKI) metric.

[FSM Diagram included in original document]

(ii) In the previous question, increasing the number of bits is equivalent to increasing the required hardware, since the number of BHT entries remains constant. Now, keeping the hardware constant at 32K bits, run the simulations again for the 12 benchmarks, setting N=1, 2, 2β, 4 and the appropriate number of entries. Provide the appropriate diagram and explain the changes you observe. Which predictor would you choose as the optimal choice?

### 4.3 BTB Study
Implement a BTB and study its prediction accuracy for the following cases:

| btb entries | btb associativity |
|-------------|-------------------|
| 512         | 1, 2             |
| 256         | 2, 4             |
| 128         | 4                |
| 64          | 8                |

Simulate for the provided benchmarks and provide appropriate diagrams. Remember that for the BTB there are 2 types of misses: direction misprediction and target misprediction in the case of a direction hit. How would you explain the performance difference between the different cases? Choose the best organization for the BTB.

### 4.4 RAS Study
Using the RAS implementation (ras.h) provided, study the miss rate for the following cases:

Number of RAS entries:
- 4
- 8
- 16
- 24
- 32
- 48
- 64

Simulate for the provided benchmarks and provide appropriate diagrams explaining the changes you observe. Select the appropriate size for the RAS.

### 4.5 Comparison of Different Predictors
In this section, you will compare the following predictors (predictors in bold are not provided and must be implemented by you):

- Static AlwaysTaken
- Static BTFNT (BackwardTaken-ForwardNotTaken)
- The n-bit predictor you selected in 4.2 (ii)
- Pentium-M predictor (given that the hardware overhead is approximately 30K)
- Local-History two-level predictors (see course slides) with the following characteristics:
  - PHT entries = 8192
  - PHT n-bit counter length = 2
  - BHT entries = X
  - BHT entry length = Z
  Calculate Z so that the required hardware is constant and equal to 32K, when X=2048 and X=4096

- Global History two-level predictors with the following characteristics:
  - PHT entries = Z
  - PHT n-bit counter length = X
  - BHR length = 5, 10
  Calculate Z so that the required hardware is constant and equal to 32K when X=2 and X=4. The cost of the Branch History Register (5 and 10 bits) is considered negligible

- Alpha 21264 predictor (see course slides - hardware overhead 29K)
- Tournament Hybrid predictors (see course slides) with the following characteristics:
  - The meta-predictor M is a 2-bit predictor with 1024 or 2048 entries (you can ignore its overhead in your analysis)
  - P0, P1 can be n-bit, local-history, or global-history predictors
  - P0, P1 have 16K overhead each
  - Implement at least 4 different tournament predictors

Simulate for the provided benchmarks and compare the above (at least 15) predictors. Provide appropriate diagrams. Which predictor would you finally choose to implement in your system?

The deliverable for this exercise will be an electronic document (pdf, docx, or odt). In the electronic document, state your details (Name, Surname, Student ID) at the beginning.

The exercise will be submitted electronically at:
http://www.cslab.ece.ntua.gr/courses/advcomparch/submit

Work individually. It has particular value for understanding the course to do the work on your own. Don't try to copy it from other fellow students.

Don't leave the work for the last weekend, it requires considerable time to run all simulations, start immediately!