#!/bin/bash 

# 2013. Jesus Andres Ferrer
# 2013. Adria Martinez
# Change Log:
#  - 2013-11-06 Preprocess for OCR correction
#  - 2013-07-08 Video lists retrieved from DB. 
#  - 2013-06-10 Added out_name 


if [ -z "$1" ]; then echo "Syntas: `basename $0` dir "; exit 1; fi;
outdir="$1"; mkdir -p "$outdir"

repo=$HOME/feina/translectures-upv
tldb=$repo/wp2/db_fuster/scr/tldb
trs=$repo/tL/pub/wp2/t2.2/poliMedia/transcriptions/manual/
release=releaseJan2013
out_name=pM-tL

# Prepare lists
"$tldb" -c sets list 0 short > "$outdir/train.lst"
"$tldb" -c sets list 1 short > "$outdir/dev.lst"
"$tldb" -c sets list 2 short > "$outdir/test.lst"

for st in dev test train; do 
    for lan in  es; do
	mkdir -p $outdir/transcriptions/$lan/txt/$st;
	mkdir -p $outdir/transcriptions/$lan/trs/$st;
	while read line; do 
		file=${line#*/};
	    f="$trs/$release/$lan/trs/${file}.trs";
	    if  [ -e $f ]; then
		cp $f "$outdir"/transcriptions/$lan/trs/$st/
		cat "$outdir"/transcriptions/$lan/trs/$st/${file}.trs  \
		    | grep -v "^<"| grep -v "^\[" | parse_tr.sh  txt  -conv -sub lm    \
		    | sed -e 's/~[^[:space:]]\+//g' -e 's/[^[:space:]]~//g' -e 's/\/[^[:space:]]\+[:space:]/ /g' -e 's/\[HESITATION\]//g' > "$outdir"/transcriptions/$lan/txt/$st/${file}.txt
	    else
		echo "[EE] Error file $f not found but listed in $outdir/$st.lstj"
	    fi;
	done <"$outdir/$st.lst"
	cat "$outdir"/transcriptions/$lan/txt/$st/*.txt | gzip - > "$outdir"/transcriptions/${out_name}.${st}.$lan.txt.gz
    done;
done;

#for lan in  es; do
#    for file in "$outdir"/transcriptions/*.$lan.txt.gz; do
#	zcat $file | translit_$lan.py > ${file%.$lan.txt}.$lan.nn.txt
#    done;
#done;
#for file in "$outdir"/transcriptions/*.$lan.nn.txt; do    gzip $file; done;
#for lan in  es; do
#    zcat "$outdir"/transcriptions/${out_name}.{dev,test,train}.$lan.txt.gz | gzip - > "$outdir"/transcriptions/$out_name.$lan.all.txt.gz
#done;

rm "$outdir/train.lst" "$outdir/dev.lst" "$outdir/test.lst" # delete lists

exit 0;
