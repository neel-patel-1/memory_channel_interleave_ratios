#!/bin/bash

files=( compress_tgts/largecalgarycorpus/bib \
"compress_tgts/largecalgarycorpus/book2" \
"compress_tgts/largecalgarycorpus/obj2" \
"compress_tgts/largecalgarycorpus/paper1" \
"compress_tgts/largecalgarycorpus/paper2" \
"compress_tgts/largecalgarycorpus/paper4" \
"compress_tgts/largecalgarycorpus/paper5" \
"compress_tgts/silesia/dickens" \
)

rm -rf *.gz

echo > results.csv
for file in ${files[@]}; do
    echo > ${file}_avgs
    NDIMMS=1
    block_size=256
    dd if=$file ibs=512 of=`basename $file`_$NDIMMS skip=0 count=8 seek=0
    ./gzip-1.10/gzip -k -f `basename $file`_$NDIMMS
    split -b 4096 -d `basename $file`_$NDIMMS `basename $file`_${NDIMMS}_
    for i in `basename $file`_${NDIMMS}_*; do ./gzip-1.10/gzip -k -f ${i} ; done
    D1_RATIO=$( for i in `basename $file`_${NDIMMS}_*.gz; do ./gzip-1.10/gzip -l ${i} ; done | awk '{avg+=$3} END{avg/=(NR/2); print avg/100}' )


    rm -rf *.gz

    NDIMMS=2
    block_size=256
    for i in `seq 0 7`; do
        dd if=$file ibs=$block_size of=`basename $file`_$NDIMMS obs=$block_size skip=$(( 1 + $i )) count=1 seek=$(( $i * 2 ))
        dd if=$file ibs=$block_size of=`basename $file`_$NDIMMS obs=$block_size skip=$(( 8 + $i )) count=1 seek=$(( ($i * 2) + 1 ))
    done
    ./gzip-1.10/gzip -k -f `basename $file`_$NDIMMS
    split -b 2048 -d `basename $file`_$NDIMMS `basename $file`_${NDIMMS}_
    for i in `basename $file`_${NDIMMS}_*; do ./gzip-1.10/gzip -k -f ${i} ; done
    D2_RATIO=$( for i in `basename $file`_${NDIMMS}_*.gz; do ./gzip-1.10/gzip -l ${i} ; done | awk '{avg+=$3} END{avg/=(NR/2); print avg/100}' )

    rm -rf *.gz

    NDIMMS=4
    block_size=256
    for i in `seq 0 3`; do
        dd if=$file ibs=$block_size of=`basename $file`_$NDIMMS obs=$block_size skip=$(( 1 + $i )) count=1 seek=$(( $i * 4 ))
        dd if=$file ibs=$block_size of=`basename $file`_$NDIMMS obs=$block_size skip=$(( 4 + $i )) count=1 seek=$(( $i * 4 + 1 ))
        dd if=$file ibs=$block_size of=`basename $file`_$NDIMMS obs=$block_size skip=$(( 8 + $i )) count=1 seek=$(( $i * 4 + 2 ))
        dd if=$file ibs=$block_size of=`basename $file`_$NDIMMS obs=$block_size skip=$(( 12 + $i )) count=1 seek=$(( $i * 4 + 3 ))
    done
    ./gzip-1.10/gzip -k -f `basename $file`_$NDIMMS
    split -b 1024 -d `basename $file`_$NDIMMS `basename $file`_$NDIMMS_
    for i in `basename $file`_$NDIMMS_*; do ./gzip-1.10/gzip -k -f ${i} ; done
    D4_RATIO=$( for i in `basename $file`_$NDIMMS_*.gz; do ./gzip-1.10/gzip -l ${i} ; done | awk '{avg+=$3} END{avg/=(NR/2); print avg/100}' )

    echo `basename $file`,$D1_RATIO,$D2_RATIO,$D4_RATIO | tee -a results.csv
done
