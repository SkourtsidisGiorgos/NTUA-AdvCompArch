#!/bin/bash

# EDP plotting
mkdir -p usage

for BENCH in $@; do
    python plot_usage.py \
        "${BENCH}/${BENCH}.DW_01-WS_001.out" "${BENCH}/${BENCH}.DW_01-WS_002.out" \
        "${BENCH}/${BENCH}.DW_01-WS_004.out" "${BENCH}/${BENCH}.DW_01-WS_008.out" \
        "${BENCH}/${BENCH}.DW_01-WS_016.out" "${BENCH}/${BENCH}.DW_01-WS_032.out" \
        "${BENCH}/${BENCH}.DW_01-WS_064.out" "${BENCH}/${BENCH}.DW_01-WS_096.out" \
        "${BENCH}/${BENCH}.DW_01-WS_128.out" "${BENCH}/${BENCH}.DW_01-WS_192.out" \
        "${BENCH}/${BENCH}.DW_01-WS_256.out" "${BENCH}/${BENCH}.DW_01-WS_384.out" \
        \
        "${BENCH}/${BENCH}.DW_02-WS_001.out" "${BENCH}/${BENCH}.DW_02-WS_002.out" \
        "${BENCH}/${BENCH}.DW_02-WS_004.out" "${BENCH}/${BENCH}.DW_02-WS_008.out" \
        "${BENCH}/${BENCH}.DW_02-WS_016.out" "${BENCH}/${BENCH}.DW_02-WS_032.out" \
        "${BENCH}/${BENCH}.DW_02-WS_064.out" "${BENCH}/${BENCH}.DW_02-WS_096.out" \
        "${BENCH}/${BENCH}.DW_02-WS_128.out" "${BENCH}/${BENCH}.DW_02-WS_192.out" \
        "${BENCH}/${BENCH}.DW_02-WS_256.out" "${BENCH}/${BENCH}.DW_02-WS_384.out" \
        \
        "${BENCH}/${BENCH}.DW_04-WS_001.out" "${BENCH}/${BENCH}.DW_04-WS_002.out" \
        "${BENCH}/${BENCH}.DW_04-WS_004.out" "${BENCH}/${BENCH}.DW_04-WS_008.out" \
        "${BENCH}/${BENCH}.DW_04-WS_016.out" "${BENCH}/${BENCH}.DW_04-WS_032.out" \
        "${BENCH}/${BENCH}.DW_04-WS_064.out" "${BENCH}/${BENCH}.DW_04-WS_096.out" \
        "${BENCH}/${BENCH}.DW_04-WS_128.out" "${BENCH}/${BENCH}.DW_04-WS_192.out" \
        "${BENCH}/${BENCH}.DW_04-WS_256.out" "${BENCH}/${BENCH}.DW_04-WS_384.out" \
        \
        "${BENCH}/${BENCH}.DW_08-WS_001.out" "${BENCH}/${BENCH}.DW_08-WS_002.out" \
        "${BENCH}/${BENCH}.DW_08-WS_004.out" "${BENCH}/${BENCH}.DW_08-WS_008.out" \
        "${BENCH}/${BENCH}.DW_08-WS_016.out" "${BENCH}/${BENCH}.DW_08-WS_032.out" \
        "${BENCH}/${BENCH}.DW_08-WS_064.out" "${BENCH}/${BENCH}.DW_08-WS_096.out" \
        "${BENCH}/${BENCH}.DW_08-WS_128.out" "${BENCH}/${BENCH}.DW_08-WS_192.out" \
        "${BENCH}/${BENCH}.DW_08-WS_256.out" "${BENCH}/${BENCH}.DW_08-WS_384.out" \
        \
        "${BENCH}/${BENCH}.DW_16-WS_001.out" "${BENCH}/${BENCH}.DW_16-WS_002.out" \
        "${BENCH}/${BENCH}.DW_16-WS_004.out" "${BENCH}/${BENCH}.DW_16-WS_008.out" \
        "${BENCH}/${BENCH}.DW_16-WS_016.out" "${BENCH}/${BENCH}.DW_16-WS_032.out" \
        "${BENCH}/${BENCH}.DW_16-WS_064.out" "${BENCH}/${BENCH}.DW_16-WS_096.out" \
        "${BENCH}/${BENCH}.DW_16-WS_128.out" "${BENCH}/${BENCH}.DW_16-WS_192.out" \
        "${BENCH}/${BENCH}.DW_16-WS_256.out" "${BENCH}/${BENCH}.DW_16-WS_384.out" \
        \
        "${BENCH}/${BENCH}.DW_32-WS_001.out" "${BENCH}/${BENCH}.DW_32-WS_002.out" \
        "${BENCH}/${BENCH}.DW_32-WS_004.out" "${BENCH}/${BENCH}.DW_32-WS_008.out" \
        "${BENCH}/${BENCH}.DW_32-WS_016.out" "${BENCH}/${BENCH}.DW_32-WS_032.out" \
        "${BENCH}/${BENCH}.DW_32-WS_064.out" "${BENCH}/${BENCH}.DW_32-WS_096.out" \
        "${BENCH}/${BENCH}.DW_32-WS_128.out" "${BENCH}/${BENCH}.DW_32-WS_192.out" \
        "${BENCH}/${BENCH}.DW_32-WS_256.out" "${BENCH}/${BENCH}.DW_32-WS_384.out"

    mv "${BENCH}-ref.usage.png" "usage/${BENCH}-ref.usage.png"

done
