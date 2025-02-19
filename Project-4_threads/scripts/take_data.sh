# ~/sniper-7.3/tools/advcomparch_mcpat.py -d ~/out/hmmer/hmmer.DW_01-WS_016.out -t total -o ~/out/hmmer/hmmer.DW_01-WS_016.out/power >~/out/hmmer/hmmer.DW_01-WS_016.out/power.total.out

#!/bin/bash

MCPAT=/home/giorgosskourtsidis/sniper-7.3/tools/advcomparch_mcpat.py

declare -a LOCKS=("DMUTEX" "DTAS_TS" "DTAS_CAS" "DTTAS_TS" "DTTAS_CAS")
declare -a names=("out" "out/erot2/share_all" "out/erot2/share_nothing" "out/erot2/share_L3")
for name in "${names[@]}"; do 
OUTPUT_DIR_BASE=/home/giorgosskourtsidis/advanced-ca-Spring-2020-ask4-helpcode/$name

for LOCK in "${LOCKS[@]}"; do
    LOCKOutDir=${OUTPUT_DIR_BASE}/$LOCK

    for thread in 1 2 4 8 16; do
        for gs in 1 10 100; do
            outDir=$(printf "%s.THR_%02d-GS_%03d.out" $LOCK $thread $gs)
            outDir="${LOCKOutDir}/${outDir}"
            power="${outDir}/power"

            sniper_cmd="${MCPAT} -d ${outDir} -t total -o ${power} > ${power}.total.out"
            echo \"$sniper_cmd\"
            /bin/bash -c "$sniper_cmd"
        done
    done
done
done
