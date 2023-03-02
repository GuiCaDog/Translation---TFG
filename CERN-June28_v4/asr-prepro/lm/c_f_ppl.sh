#!/bin/bash
# Merge and calculate final ppl
#  for single video ppl files
# Adrià A. Martínez Villaronga, 2012

scdir=$(dirname $(which $0))


if [ $# -lt 2 ]; then
    echo "Usage: `basename $0` dir out"
    exit
fi

dir=$1
out=$2

rm -f $out
rm -f aux2
nSent2=0
for f in $dir/*.ppl; do
    nL=$(cat $f| wc -l) # Nombre de linies (+2)
    nL=`expr $nL - 2`   # Nombre de linies
    cat $f | grep 'OOVs\|zeroprobs' > aux # Recuperar les línies del final de cada frase
    nSent=$(cat aux| wc -l) # Nombre de frases (+2)
    nSent=`expr $nSent - 2` # Nombre de frases
    nSent2=`expr $nSent2 + $nSent` # Nombre total de frases
    cat $f | head -n $nL >> $out 
    cat aux | head -n $nSent | awk '
    {
        if ($NF == "OOVs") {
            print $3
            print $5
        } else {
            print $1
            print $4
            print $6
            print $8
        }
    }' >> aux2
done

cat aux2 | $scdir/calc_final_ppl.py $nSent2 >> $out

rm -f aux2 aux