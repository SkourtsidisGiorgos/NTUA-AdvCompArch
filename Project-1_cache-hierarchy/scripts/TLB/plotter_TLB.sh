#!/bin/bash

ACA_PATH="${ACA_PATH:-/home/giorgosskourtsidis}" &>/dev/null
HLP_PATH="${HLP_PATH:-${ACA_PATH}/ex1-helpcode}" &>/dev/null
PAR_PATH="${PAR_PATH:-${ACA_PATH}/parsec-3.0}" &>/dev/null

# Main directories
PAR_PATH="${PAR_PATH:-${ACA_PATH}/parsec-3.0}" &>/dev/null

# Workspace paths
WRK_PATH=${PAR_PATH}/parsec_workspace
OUT_PATH=${WRK_PATH}/outputs/TLB

# Benchmark array
declare -a BenchArray=(
    "blackscholes"
    "bodytrack"
    "canneal"
    "facesim"
    "ferret"
    "fluidanimate"
    "freqmine"
    "rtview"
    "streamcluster"
    "swaptions"
)

# Loop through the available benchmarks
for bench in "${BenchArray[@]}"; do
    python graph_TLB.py "false" ${bench} ${OUT_PATH}/${bench}_TLB*
    mv TLB.png TLB_${bench}.png
done

# Create the graphs for the second question
for bench in "${BenchArray[@]}"; do
    python graph_TLB.py "true" "${bench}, IPC Reduction" ${OUT_PATH}/${bench}_TLB*
    mv TLB.png TLB_${bench}_Red.png
done
