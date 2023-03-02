#!/bin/bash

# 2013. Jesus Andres Ferrer
# Change Log:
#  - 2013-06-10 Added out_name

repo=$HOME/sd/01-Proyectos/transLectures-UPV/
dir=$repo/wp6/t6.1/particio_videolectures/
trs=$repo/tL/pub/wp6/t6.1/Videolectures.NET/translations/clean/
out_name=vL-tL-SMT
# DDS actual translations are at:\
#   trs=$repo/tL/pub/wp2/t2.2/DDS\ Deliveries/English\ audio/Spanish\ Translations/
# We are working with Guillems processing

out=$1;
if [ $# -lt 1 ]; then echo `basename $0` out_dir; exit; fi;
if [ ! -e "$trs" -o ! -e "$dir" ]; then
    echo "Either  $trs  or $dir does not exist" 
    echo `basename $0` out_dir; exit; i
fi;

## ----
for st in "train" "dev" "test"; do
    if [ ! -e "$out" ]; then 
        mkdir -p "$out";
    fi;
    for lan in "en" "es" "fr" "de"; do 
         cp $trs/$st/${st}.all.$lan "$out"/${out_name}.${st}.txt.$lan
	 gzip "$out"/${out_name}.${st}.txt.$lan
    done;
done; # st

for lan in "en" "es" "fr" "de"; do 
    zcat "$out"/${out_name}.{dev,test,train}.txt.$lan.gz | gzip - > "$out"/$out_name.all.txt.$lan.gz
    for file in "$out"/*.{all,train,dev,test}.txt.$lan.gz; do
        if [ ! -z "`which translit_$lan.py`" ]; then
            zcat $file | translit_$lan.py | gzip - > ${file%.all.$lan}.nn.$lan.gz
        else
            echo " Not found transli_$lan.py, skipping ";
        fi;
        done;
    generate_vocab.sh  <( zcat "$out"/${out_name}.train.txt.$lan.gz ) > "$out"/${out_name}.train.$lan.voc_num
    cat "$out"/${out_name}.train.$lan.voc_num | cut -d' ' -f1 | sort -u > "$out"/${out_name}.train.$lan.voc
    gzip -f "$out"/${out_name}.train.$lan.voc
done;


