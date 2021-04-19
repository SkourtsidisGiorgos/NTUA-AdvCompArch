#!/bin/bash

## Execute this script in the helpcode directory.
## Example of usage: ./run_branch_predictors.sh 403.gcc
## Modify the following paths appropriately
## CAUTION: use only absolute paths below!!!

## Modify the following paths appropriately
PARSEC_PATH=/home/gregth/workspace/advcomparch/parsec-3.0
PIN_EXE=/home/gregth/workspace/advcomparch/pin-3.13-98189-g60a6ef199-gcc-linux/pin

PIN_TOOL=/home/gregth/workspace/advcomparch/ex2/pintool/obj-intel64/cslab_branch_stats.so
export LD_LIBRARY_PATH=$PARSEC_PATH/pkgs/libs/hooks/inst/amd64-linux.gcc-serial/lib/
outDir="/home/giorgos/ex2/outputs/4_1"

BENCHMARKS="403.gcc 429.mcf 434.zeusmp 436.cactusADM 445.gobmk 450.soplex 456.hmmer 458.sjeng 459.GemsFDTD 471.omnetpp 473.astar 483.xalancbmk"

#for BENCH in $BENCHMARKS; do

for BENCH in $@; do
	cd ../spec_execs_train_inputs/$BENCH

	line=$(cat speccmds.cmd)
	stdout_file=$(echo $line | cut -d' ' -f2)
	stderr_file=$(echo $line | cut -d' ' -f4)
	cmd=$(echo $line | cut -d' ' -f5-)

	pinOutFile="$outDir/${BENCH}.cslab_branch_stats.out"
	pin_cmd="$PIN_EXE -t $PIN_TOOL -o $pinOutFile -- $cmd 1> $stdout_file 2> $stderr_file"
	echo "PIN_CMD: $pin_cmd"
	/bin/bash -c "time $pin_cmd"

	cd ../../scripts/
done
