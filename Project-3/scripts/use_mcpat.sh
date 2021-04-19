MCPAT=/home/giorgosskourtsidis/sniper-7.3/tools/advcomparch_mcpat.py
OUTPUT_DIR_BASE=/home/giorgosskourtsidis/out/

#!/bin/bash

MCPAT=/home/giorgosskourtsidis/sniper-7.3/tools/advcomparch_mcpat.py
OUTPUT_DIR_BASE=/home/giorgosskourtsidis/out

for BENCH in $@; do
    benchOutDir=${OUTPUT_DIR_BASE}/$BENCH
    # mkdir -p $benchOutDir

    for dw in 1 2 4 8 16 32; do
        for ws in 8 16 32 64 96 128 192 256 384; do
            outDir=$(printf "%s.DW_%02d-WS_%03d.out" $BENCH $dw $ws)
            outDir="${benchOutDir}/${outDir}"
            power="${outDir}/power"

            sniper_cmd="${MCPAT} -d ${outDir} -t total -o ${power} > ${power}.total.out"
            echo \"$sniper_cmd\"
            /bin/bash -c "$sniper_cmd"
        done
    done
done
