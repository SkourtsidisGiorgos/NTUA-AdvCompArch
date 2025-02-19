#!/bin/bash

# Project directory
ACA_PATH="${ACA_PATH:-/home/giorgosskourtsidis}" &>/dev/null

# Main directories
PAR_PATH="${PAR_PATH:-${ACA_PATH}/parsec-3.0}" &>/dev/null

# ------------------------------------------------
# You should only have to change things above here
# ------------------------------------------------

# Workspace paths
WRK_PATH=${PAR_PATH}/parsec_workspace
OUT_PATH=${WRK_PATH}/outputs/PRF

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
    python graph_PRF.py ${bench} ${OUT_PATH}/${bench}_PRF*
    mv PRF.png PRF_${bench}.png
done
