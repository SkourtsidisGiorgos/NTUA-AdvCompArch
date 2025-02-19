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

for BENCH in $@; do
    python erot1.py \
        "${BENCH}/${BENCH}.DW_01-WS_004.out" \
        "${BENCH}/${BENCH}.DW_02-WS_004.out" \
        "${BENCH}/${BENCH}.DW_04-WS_004.out" \
        "${BENCH}/${BENCH}.DW_08-WS_004.out" \
        "${BENCH}/${BENCH}.DW_16-WS_004.out" \
        "${BENCH}/${BENCH}.DW_32-WS_004.out"

done
