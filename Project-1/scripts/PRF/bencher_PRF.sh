#!/bin/bash

ACA_PATH="${ACA_PATH:-/home/giorgosskourtsidis}" &>/dev/null
HLP_PATH="${HLP_PATH:-${ACA_PATH}/ex1-helpcode}" &>/dev/null
PAR_PATH="${PAR_PATH:-${ACA_PATH}/parsec-3.0}" &>/dev/null
PIN_PATH="${PIN_PATH:-${ACA_PATH}/pin-3.13}" &>/dev/null

# LD Library directory
export LD_LIBRARY_PATH=${PAR_PATH}/pkgs/libs/hooks/inst/amd64-linux.gcc-serial/lib

# Tool paths
PIN_EXE=${PIN_PATH}/pin
SIM_EXE=${HLP_PATH}/pintool/obj-intel64/simulator.so

# Workspace directories
WRK_PATH=${PAR_PATH}/parsec_workspace
INP_PATH=${WRK_PATH}/inputs
OUT_PATH=${WRK_PATH}/outputs/PRF
LOG_PATH=${WRK_PATH}/logs
EXE_PATH=${WRK_PATH}/executables

# Create the necessary paths
mkdir -p ${OUT_PATH} &>/dev/null
mkdir -p ${LOG_PATH} &>/dev/null

# Fix for facesim
ln -s ${INP_PATH}/Face_Data .

# L1, L2 & TLB configuration
L1size=32
L1assoc=8
L1bsize=64
L2size=1024
L2assoc=8
L2bsize=128
TLBe=64
TLBa=4
TLBp=4096

# Dynamic Prefetching configuration
CFGS="1 2 4 8 16 32 64"

# Benchmark array
declare -a BenchArray=(
    "${EXE_PATH}/blackscholes 1 ${INP_PATH}/in_64K.txt prices.txt"
    "${EXE_PATH}/bodytrack ${INP_PATH}/sequenceB_4 4 4 4000 5 0 1"
    "${EXE_PATH}/canneal 1 15000 2000 ${INP_PATH}/400000.nets 128"
    "${EXE_PATH}/facesim -timing -threads 1"
    "${EXE_PATH}/ferret ${INP_PATH}/corel lsh ${INP_PATH}/queries 10 20 1 output.txt"
    "${EXE_PATH}/fluidanimate 1 5 ${INP_PATH}/in_300K.fluid out.fluid"
    "${EXE_PATH}/freqmine ${INP_PATH}/kosarak_990k.dat 790"
    "${EXE_PATH}/rtview ${INP_PATH}/happy_buddha.obj -automove -nthreads 1 -frames 3 -res 1920 1080"
    "${EXE_PATH}/streamcluster 10 20 128 16384 16384 1000 none output.txt 1"
    "${EXE_PATH}/swaptions -ns 64 -sm 40000 -nt 1"
)

# Loop through the available benchmarks
for bench in "${BenchArray[@]}"; do

    # Extract the name of the benchmark
    benchName=$(echo "${bench}" | cut -d' ' -f 1)
    benchName=${benchName#"${EXE_PATH}/"}

    # Loop through the different cache configurations
    for cfg in $CFGS; do

        # Extract the TLB size, associativity and page size from the triplets
        L2prf=$(echo $cfg)

        # Format the output file
        OUT_FILE=$(printf "%s_PRF_%02d.out" ${benchName} ${L2prf})
        OUT_FILE="${OUT_PATH}/${OUT_FILE}"

        # Format the command string
        CMD="${PIN_EXE} -t ${SIM_EXE} -o ${OUT_FILE}                        \
            -L1c ${L1size} -L1a ${L1assoc} -L1b ${L1bsize}                  \
            -L2c ${L2size} -L2a ${L2assoc} -L2b ${L2bsize} -L2prf ${L2prf}  \
            -TLBe ${TLBe} -TLBa ${TLBa} -TLBp ${TLBp}                       \
            -- ${bench}"

        # Announce the benchmark
        echo
        echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
        echo " Running: ${benchName}"
        echo " Config : L2 Prefetching = ${L2prf}"
        echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
        echo

        # Check if benchmark has already been run
        if ls -d "${OUT_PATH}"/* | tail -1 | grep -q "${OUT_FILE}"; then
            # if it's the last benchmark run, rerun it
            echo "Found the last incomplete benchmark, rerunning"
            time ${CMD} 2>&1 | tee -a ${LOG_PATH}/${benchName}_PRF.log
        elif test -f "${OUT_FILE}"; then
            # if it's not the last benchmark run, and it already has been done, skip it
            echo "Benchmark already run"
            echo "skipping.."
        else
            # else, execute it, time it & log it
            time ${CMD} 2>&1 | tee -a ${LOG_PATH}/${benchName}_PRF.log
        fi

    done
done
