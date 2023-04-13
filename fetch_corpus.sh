#!/bin/bash
files=( "http://www.data-compression.info/files/corpora/largecalgarycorpus.zip" \
	"http://www.data-compression.info/files/corpora/largecanterburycorpus.zip" \
	"http://www.data-compression.info/files/corpora/lukas_3d_dicom.zip" \
	"http://www.data-compression.info/files/corpora/proteincorpus.zip" \
	"http://sun.aei.polsl.pl/~sdeor/corpus/silesia.zip" \
)

mkdir -p compress_tgts
cd compress_tgts
for file in ${files[@]};
do
	[ ! -f "$(basename $file)" ] && wget $file
	[ ! -d "$(basename ${file%.*})" ] && mkdir -p $(basename ${file%.*}) && unzip -d $(basename ${file%.*}) $(basename $file)
done
