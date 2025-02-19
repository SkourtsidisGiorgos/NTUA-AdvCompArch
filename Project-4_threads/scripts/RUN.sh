#!/bin/bash

YOUR_PATH=/home/giorgosskourtsidis
FOLDER=${YOUR_PATH}/advanced-ca-Spring-2020-ask4-helpcode
SNIPER_EXE=/sniper-7.3/run-sniper
SPEC_PINBALLS_DIR=${YOUR_PATH}/cpu2006_pinballs

CONFIG_SCRIPT=${FOLDER}/ask4.cfg
OUTPUT_DIR_BASE="out"

declare -a StringArray=("DMUTEX" "DTAS_TS" "DTAS_CAS" "DTTAS_TS" "DTTAS_CAS")

for lock in "${StringArray[@]}"; do

    LockOutDir="${OUTPUT_DIR_BASE}/$lock"
    mkdir -p $LockOutDir

    for thread in 1 2 4 8 16; do
        for grain_size in 1 10 100; do

            outDir=$(printf "%s.THR_%02d-GS_%03d.out" $lock $thread $grain_size)
            outDir="${LockOutDir}/${outDir}"

            sniper_cmd="${SNIPER_EXE} -c ${CONFIG_SCRIPT} -n \
                        $thread --roi -d ${outDir} -g \
                        --perf_model/l2_cache/shared_cores=4 \
                        -g --perf_model/l3_cache/shared_cores=8 \
                        -- ${FOLDER}/$lock \
                         $thread 1000 $grain_size"
            echo \"$sniper_cmd\"
            /bin/bash -c "$sniper_cmd"

        done
    done

done
