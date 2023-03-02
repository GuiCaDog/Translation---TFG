#!/bin/bash

# 2013. Jesus Andres Ferrer
# Change Log:
#  - 2013-06-10 Added out_name

repo=$HOME/sd/01-Proyectos/transLectures-UPV/
dir=$repo/wp6/t6.1/particio_videolectures/
trs=$repo/tL/pub/wp2/t2.2/DDS\ Deliveries/English\ audio/
out_name=vL-tL

out=$1;
if [ $# -lt 1 ]; then echo `basename $0` out_dir; exit; fi;
if [ ! -e "$trs" -o ! -e "$dir" ]; then
    echo "Either  $trs  or $dir does not exist" 
    echo `basename $0` out_dir; exit; i
fi;

## ----
for st in "train" "dev" "test"; do
    if [ ! -e "$out"/$st/trs ]; then 
        mkdir -p "$out"/$st/trs; mkdir -p "$out"/$st/txt; 
    fi;
    while read line; do 
        f="$trs/$line.trs";
        if [ -e "$f" ]; then
            cat "$f" | prepro_trs.py > "$out/$st/trs/${line}_prepro.trs" ;
            cat "$out/$st/trs/${line}_prepro.trs" | \
                grep -v "^<"| grep -v "^\[" | parse_tr.sh  txt  -conv -sub am  -lc \
		|  sed -e 's/&quot;/"/g'   -e 's/&amp;/\&/g' -e 's/&lt;/</g' -e 's/&gt;/>/g' \
                | sed -e 's/~[^[:space:]]\+//g' -e 's/[^[:space:]]~//g' -e 's/\/[^[:space:]]\+[:space:]/ /g' > "$out"/$st/txt/${line}.txt
#                | sed -e 's/[^[:alpha:]][[:punct:]][^[:alpha:]]/ /g' |   sed -e 's/[[:punct:]]\([[:space:]]\|$\)/ /g' \
        else
            echo "NOT FOUND: $line"; 
        fi;
    done < "$dir/$st.lst"
    cat "$out"/$st/txt/* |gzip -  >"$out"/${out_name}.${st}.txt.gz
done; # st

zcat "$out"/$out_name.{dev,test,train}.txt.gz | gzip - > "$out"/$out_name.all.txt.gz

for file in "$out"/*.{all,train,dev,test}.txt.gz; do
    zcat $file | translit_en.py |gzip - > ${file%.txt}.nn.txt.gz
done;


generate_vocab.sh  <(zcat "$out"/${out_name}.train.txt.gz) > "$out"/${out_name}.train.voc_num
cat "$out"/${out_name}.train.voc_num | cut -d' ' -f1 | sort -u > "$out"/${out_name}.train.voc
gzip -f "$out"/${out_name}.train.voc

