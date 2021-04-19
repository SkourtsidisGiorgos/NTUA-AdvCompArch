#!/bin/bash

# Project directory
ACA_PATH="${ACA_PATH:-/home/uphill/Projects/advcomparch}" &>/dev/null

# Main directories
PAR_PATH="${PAR_PATH:-${ACA_PATH}/parsec-3.0}" &>/dev/null

# Workspace paths
WRK_PATH=${PAR_PATH}/parsec_workspace
OUT_PATH=${WRK_PATH}/outputs/L1

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

# Loop through the available benchmarks & create the graphs
for bench in "${BenchArray[@]}"; do
    python graph_L1.py "false" "${bench}" ${OUT_PATH}/${bench}_L1*
    mv L1.png L1_${bench}.png
done

# Create the graphs for the second question
for bench in "${BenchArray[@]}"; do
    python graph_L1.py "true" "${bench}, IPC Reduction" ${OUT_PATH}/${bench}_L1*
    mv L1.png L1_${bench}_Red.png
done
