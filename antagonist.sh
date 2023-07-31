#!/bin/bash
EXTRA_MEM_PAGES=$(( 2 ** 27 )) #EXTRAMEM_BYTES / (2 ** 12)
PAGE_PROM_RATE=$( echo "($EXTRA_MEM_PAGES * 1) / 1" | bc )
echo "./lzbench/lzbench -ezstd,1 -v7 -r -w${PAGE_PROM_RATE} compress_tgts"
./lzbench/lzbench -ezstd,1 -v7 -r -w${PAGE_PROM_RATE} compress_tgts
