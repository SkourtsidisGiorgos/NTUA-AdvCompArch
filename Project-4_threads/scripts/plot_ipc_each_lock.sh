#############################################################################################
#                                       USAGE                                               #
#############################################################################################
#
# u need this script in the same folder with 'plot_ipc_original.py', 'python plot_power.py' scripts
# u also need the ouput folder in the same location (hmmer,gcc,zeump etc).
# Then u just write ./plotter.sh LOCK1 LOCK2 etc
#   example : ./plotter.sh gcc sjeng zeusmp
#
#############################################################################################

#!/bin/bash

# IPC plotting
mkdir -p virtual_IPC_Per_GS

# Declare an array of string with type
declare -a LOCKS=("DMUTEX" "DTAS_TS" "DTAS_CAS" "DTTAS_TS" "DTTAS_CAS")

for LOCK in "${LOCKS[@]}"; do

    python ipc_per_gs.py \
        "${LOCK}/${LOCK}.THR_01-GS_001.out" "${LOCK}/${LOCK}.THR_01-GS_010.out" \
        "${LOCK}/${LOCK}.THR_01-GS_100.out" \
        \
        "${LOCK}/${LOCK}.THR_02-GS_001.out" "${LOCK}/${LOCK}.THR_02-GS_010.out" \
        "${LOCK}/${LOCK}.THR_02-GS_100.out" \
        \
        "${LOCK}/${LOCK}.THR_04-GS_001.out" "${LOCK}/${LOCK}.THR_04-GS_010.out" \
        "${LOCK}/${LOCK}.THR_04-GS_100.out" \
        \
        "${LOCK}/${LOCK}.THR_08-GS_001.out" "${LOCK}/${LOCK}.THR_08-GS_010.out" \
        "${LOCK}/${LOCK}.THR_08-GS_100.out" \
        \
        "${LOCK}/${LOCK}.THR_16-GS_001.out" "${LOCK}/${LOCK}.THR_16-GS_010.out" \
        "${LOCK}/${LOCK}.THR_16-GS_100.out"

    mv "${LOCK}-ref.ipc.png" "virtual_IPC_Per_GS/${LOCK}-ref.ipc.png"
done
