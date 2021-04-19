#!/bin/bash

## Example of usage: ____
## Modify the following paths appropriately
## CAUTION: use only absolute paths below!!!

SNIPER_EXE=/home/giorgosskourtsidis/sniper-7.3/run-sniper
SPEC_PINBALLS_DIR=/home/giorgosskourtsidis/cpu2006_pinballs
# SNIPER_CONFIG=gainestown

CONFIG_SCRIPT=/home/giorgosskourtsidis/advanced-ca-Spring-2020-ask4-helpcode/ask4.cfg
OUTPUT_DIR_BASE="out"
NAME=DTTAS_CAS

LockOutDir="${OUTPUT_DIR_BASE}/$NAME"
mkdir -p $LockOutDir

# for smt in $(seq 1 1000); do

for thread in 1 2 4 8 16; do
    for grain_size in 1 10 100; do

        outDir=$(printf "%s.THR_%02d-GS_%03d.out" $NAME $thread $grain_size)
        outDir="${LockOutDir}/${outDir}"
        # pinball="$(ls $SPEC_PINBALLS_DIR/$NAME/pinball_short.pp/*.address)"

        sniper_cmd="${SNIPER_EXE} -c ${CONFIG_SCRIPT} -n $thread --roi -d ${outDir} -g --perf_model/l2_cache/shared_cores=4 -g --perf_model/l3_cache/shared_cores=8 -- /home/giorgosskourtsidis/advanced-ca-Spring-2020-ask4-helpcode/${NAME} $thread 1000 $grain_size"
        echo \"$sniper_cmd\"
        /bin/bash -c "$sniper_cmd"

    done
done

