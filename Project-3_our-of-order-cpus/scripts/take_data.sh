~/sniper-7.3/tools/advcomparch_mcpat.py -d ~/out/hmmer/hmmer.DW_01-WS_016.out -t total -o ~/out/hmmer/hmmer.DW_01-WS_016.out/power >~/out/hmmer/hmmer.DW_01-WS_016.out/power.total.out

MCPAT=/home/giorgosskourtsidis/sniper-7.3/tools/advcomparch_mcpat.py
OUTPUT_DIR_BASE=/home/giorgosskourtsidis/out/

# for BENCH in $@; do

#     /home/giorgosskourtsidis/sniper-7.3/tools/advcomparch_mcpat.py -d
#     ~/out/hmmer/hmmer.DW_01-WS_016.out -t total
#     -o ~/out/hmmer/hmmer.DW_01-WS_016.out/power >~/out/hmmer/hmmer.DW_01-WS_016.out/power.total.out

#     benchOutDir=${OUTPUT_DIR_BASE}/$BENCH
#     # mkdir -p "$benchOutDir/power"
#     outDir=$(printf "%s.DW_%02d-WS_%03d.out" $BENCH $dw $ws)
#     outDir="${benchOutDir}/${outDir}"

#     pinball="$(ls $SPEC_PINBALLS_DIR/$BENCH/pinball_short.pp/*.address)"
#     sniper_cmd="${MCPAT} -d ~/out/$BENCH/$BENCH. -d ${outDir} -g --perf_model/core/interval_timer/dispatch_width=$dw -g --perf_model/core/interval_timer/window_size=$ws --pinballs=${pinball}"
#     echo \"$sniper_cmd\"
#     /bin/bash -c "$sniper_cmd"
# done

#!/bin/bash

MCPAT=/home/giorgosskourtsidis/sniper-7.3/tools/advcomparch_mcpat.py
OUTPUT_DIR_BASE=/home/giorgosskourtsidis/out

for BENCH in $@; do
    benchOutDir=${OUTPUT_DIR_BASE}/$BENCH
    # mkdir -p $benchOutDir

    for dw in 1 2 4 8 16 32; do
        for ws in 16 32 64 96 128 192 256 384; do
            outDir=$(printf "%s.DW_%02d-WS_%03d.out" $BENCH $dw $ws)
            outDir="${benchOutDir}/${outDir}"
            power="${outDir}/power"

            sniper_cmd="${MCPAT} -d ${outDir} -t total -o ${power} > ${power}.total.out"
            echo \"$sniper_cmd\"
            /bin/bash -c "$sniper_cmd"
        done
    done
done
