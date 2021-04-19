#############################################################################################
#                                       USAGE                                               #
#############################################################################################
#
# u need this script in the same folder with 'plot_ipc_original.py', 'python plot_edp.py' scripts
# u also need the ouput folder in the same location (hmmer,gcc,zeump etc).
# Then u just write ./plotter.sh bench1 bench2 etc
#   example : ./plotter.sh gcc sjeng zeusmp
#
#############################################################################################

#!/bin/bash

# EDP plotting
mkdir -p EDP_graphs

for BENCH in $@; do
    python plot_edp.py \
        "${BENCH}/${BENCH}.DW_01-WS_016.out" "${BENCH}/${BENCH}.DW_01-WS_032.out" \
        "${BENCH}/${BENCH}.DW_01-WS_064.out" "${BENCH}/${BENCH}.DW_01-WS_096.out" \
        "${BENCH}/${BENCH}.DW_01-WS_128.out" "${BENCH}/${BENCH}.DW_01-WS_192.out" \
        "${BENCH}/${BENCH}.DW_01-WS_256.out" "${BENCH}/${BENCH}.DW_01-WS_384.out" \
        \
        "${BENCH}/${BENCH}.DW_02-WS_016.out" "${BENCH}/${BENCH}.DW_02-WS_032.out" \
        "${BENCH}/${BENCH}.DW_02-WS_064.out" "${BENCH}/${BENCH}.DW_02-WS_096.out" \
        "${BENCH}/${BENCH}.DW_02-WS_128.out" "${BENCH}/${BENCH}.DW_02-WS_192.out" \
        "${BENCH}/${BENCH}.DW_02-WS_256.out" "${BENCH}/${BENCH}.DW_02-WS_384.out" \
        \
        "${BENCH}/${BENCH}.DW_04-WS_016.out" "${BENCH}/${BENCH}.DW_04-WS_032.out" \
        "${BENCH}/${BENCH}.DW_04-WS_064.out" "${BENCH}/${BENCH}.DW_04-WS_096.out" \
        "${BENCH}/${BENCH}.DW_04-WS_128.out" "${BENCH}/${BENCH}.DW_04-WS_192.out" \
        "${BENCH}/${BENCH}.DW_04-WS_256.out" "${BENCH}/${BENCH}.DW_04-WS_384.out" \
        \
        "${BENCH}/${BENCH}.DW_08-WS_016.out" "${BENCH}/${BENCH}.DW_08-WS_032.out" \
        "${BENCH}/${BENCH}.DW_08-WS_064.out" "${BENCH}/${BENCH}.DW_08-WS_096.out" \
        "${BENCH}/${BENCH}.DW_08-WS_128.out" "${BENCH}/${BENCH}.DW_08-WS_192.out" \
        "${BENCH}/${BENCH}.DW_08-WS_256.out" "${BENCH}/${BENCH}.DW_08-WS_384.out" \
        \
        "${BENCH}/${BENCH}.DW_16-WS_016.out" "${BENCH}/${BENCH}.DW_16-WS_032.out" \
        "${BENCH}/${BENCH}.DW_16-WS_064.out" "${BENCH}/${BENCH}.DW_16-WS_096.out" \
        "${BENCH}/${BENCH}.DW_16-WS_128.out" "${BENCH}/${BENCH}.DW_16-WS_192.out" \
        "${BENCH}/${BENCH}.DW_16-WS_256.out" "${BENCH}/${BENCH}.DW_16-WS_384.out" \
        \
        "${BENCH}/${BENCH}.DW_32-WS_016.out" "${BENCH}/${BENCH}.DW_32-WS_032.out" \
        "${BENCH}/${BENCH}.DW_32-WS_064.out" "${BENCH}/${BENCH}.DW_32-WS_096.out" \
        "${BENCH}/${BENCH}.DW_32-WS_128.out" "${BENCH}/${BENCH}.DW_32-WS_192.out" \
        "${BENCH}/${BENCH}.DW_32-WS_256.out" "${BENCH}/${BENCH}.DW_32-WS_384.out"

    mv "${BENCH}-ref.edp.png" "EDP_graphs/${BENCH}-ref.edp.png"

done
