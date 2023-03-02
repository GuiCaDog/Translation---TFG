#!/bin/bash 

# 2013. Jesus Andres Ferrer
# Change Log:
#  - 2013-07-08 Video lists retrieved from DB. 
#  - 2013-06-10 Added out_name 


if [ -z "$outdir" ]; then echo "Syntas: `basename $0` dir "; exit 1; fi;
outdir="$1"; mkdir -p "$outdir"

tldb=$repo/wp2/db_fuster/scr/tldb
repo=$HOME/sd/01-Proyectos/transLectures-UPV/
dir=$repo/wp6/t6.1/particio_polimedia/
release=releaseJan2013
out_name=pM-tL-SMT
train_en_trs=$repo/wp2/2012/polimedia/translations/trs
dev_test_en_trs=$repo/tL/pub/wp2/t2.2/poliMedia/translations/manual/trs
es_trs=$repo/tL/pub/wp2/t2.2/poliMedia/transcriptions/manual/releaseJan2013/es/trs

# Prepare lists
"$tldb" -c sets list 100 short > "$outdir/train.lst"
"$tldb" -c sets list 101 short > "$outdir/dev.lst"
"$tldb" -c sets list 102 short > "$outdir/test.lst"

# This code should be similar to 00-prepare-pM-ASR, but the translations are not changing
# and have already been processed, therefore, we use the ones provided by Guillem

trans=$repo/tL/pub/wp6/t6.1/poliMedia/translations/clean

mkdir -p "$outdir"/translations;
for st in dev test train; do

    lst="$outdir/$st.lst"
    en_trs="$dev_test_en_trs"; [ $st = "train" ] && en_trs="$train_en_trs"

    # JA: the code below this comment should change if we want to re-generate parallel data.
    # Required input data for doing that is available: $en_trs, $es_trs and $lst

    for lan in en es; do
	cp  $trans/$st/${st}All.$lan "$outdir"/translations/${out_name}.${st}.txt.$lan
	gzip "$outdir"/translations/${out_name}.${st}.txt.$lan
	if [ ! -z "`which translit_$lan.py`" ]; then
	    zcat "$outdir"/translations/${out_name}.${st}.txt.$lan.gz | translit_$lan.py > "$outdir"/translations/${out_name}.${st}.nn.$lan
	    gzip "$outdir"/translations/${out_name}.${st}.nn.$lan
	fi;
    done;
done;


for lan in  es en; do
    zcat "$outdir"/translations/${out_name}.{dev,test,train}.txt.$lan.gz | gzip - > "$outdir"/translations//$out_name.all.txt.$lan.gz
done;

rm "$outdir/train.lst" "$outdir/dev.lst" "$outdir/test.lst" # delete lists

exit 0
