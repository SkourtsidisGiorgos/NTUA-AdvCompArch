#!/bin/bash

## SHARE  ALL

SNIPER_EXE=/home/giorgosskourtsidis/sniper-7.3/run-sniper
SPEC_PINBALLS_DIR=/home/giorgosskourtsidis/cpu2006_pinballs
# SNIPER_CONFIG=gainestown

CONFIG_SCRIPT=/home/giorgosskourtsidis/advanced-ca-Spring-2020-ask4-helpcode/ask4.cfg
OUTPUT_DIR_BASE="out/erot2/share_L3"
mkdir -p ${OUTPUT_DIR_BASE}

# Declare an array of string with type
declare -a StringArray=("DMUTEX" "DTAS_TS" "DTAS_CAS" "DTTAS_TS" "DTTAS_CAS")

for lock in "${StringArray[@]}"; do
    for thread in 1 2 4 8 16; do
        for grain_size in 1 10 100; do

            mkdir -p "${OUTPUT_DIR_BASE}/$lock"

            outDir=$(printf "%s.THR_%02d-GS_%03d.out" $lock $thread $grain_size)
            outDir="${OUTPUT_DIR_BASE}/$lock/${outDir}"
            # pinball="$(ls $SPEC_PINBALLS_DIR/$NAME/pinball_short.pp/*.address)"

            sniper_cmd="${SNIPER_EXE} -c ${CONFIG_SCRIPT} -n $thread --roi -d ${outDir} \
                        -g --perf_model/l1_icache/shared_cores=1 \
                        -g --perf_model/l1_dcache/shared_cores=1 \
                        -g --perf_model/l2_cache/shared_cores=1  \
                        -g --perf_model/l3_cache/shared_cores=4  \
                        -- /home/giorgosskourtsidis/advanced-ca-Spring-2020-ask4-helpcode/${lock} \
                        $thread 1000 $grain_size"
            echo \"$sniper_cmd\"
            /bin/bash -c "$sniper_cmd"

        done
    done
done
