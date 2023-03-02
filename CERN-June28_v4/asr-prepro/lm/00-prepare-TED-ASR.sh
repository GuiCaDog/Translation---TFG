#!/bin/bash
# 2013. Jesus Andres Ferrer (jandres@dsic.upv.es)
# Change Log:
#  - 2013-06-10: First implementation
#  - 2013-06-17: Fixed some errors and files are compressed now.

repo=/home/corpora/
tedweben=$repo/ASR/TED.En/TEDtalks_web
tedwebes=$repo/ASR/TED.Es/TEDtalks_web
tedlium=$repo/ASR/TED.En/TEDLIUM/TEDLIUM.txt
declare -A wit3=( ["es"]="$repo/Translation/bilingual/TED/en-es/wit3.en-es.es.gz" \
                  ["en"]="$repo/Translation/bilingual/TED/en-fr/wit3.en-fr.en.gz" \
                  ["fr"]="$repo/Translation/bilingual/TED/en-fr/wit3.en-fr.fr.gz" );
                  
wit3fr=$repo/Translation/bilingual/TED/en-fr

declare -A tedweb=( ["en"]="$tedweben" ["es"]="$tedwebes" );

out=$1;
if [ $# -lt 1 ]; then echo `basename $0` out_dir; exit; fi;
if [ ! -e "$tedweben" -o ! -e "$tedlium" -o ! -e "$tedwebes" ]; then
    echo "Either  $tedweben or $tedwebes or $tedlium does not exist" ;
    echo `basename $0` out_dir; exit; i
fi;
TMP=$(mktemp `basename $0`.$$.XXXX );
trap "\rm -f $TMP " EXIT

## ----

echo "generating wit3 ..."
for lan in en es fr; do 
    [ ! -e $out/$lan ] && mkdir -p $out/$lan;
    if [ ! -e "${wit3[$lan]}" ]; then
	echo "${wit3[$lan]} Does not exists\!\!"
    else
	cp ${wit3[$lan]} "$out"/$lan;
    fi;
done;

echo "Generating TED Talks web ... ";
for lan in en es; do 
    mkdir -p $out/$lan/captions
    mkdir $out/$lan/seg
    mkdir $out/$lan/txt
    for video in ${tedweb[$lan]}/*; do
	name=${video##*/};
	echo -e "\t processing $name ";
	cp $video "$out"/$lan/captions
	cat  "$out"/$lan/captions/$name \
	    | gawk '{$1=$2=""; print $0;}' \
	    > "$out"/$lan/seg/${name%.*}.seg 
	cat "$out"/$lan/seg/${name%.*}.seg  \
	    |  sed -e 's/([^)]*)//g' -e 's/^[[:space:]]*$//' \
	    |  sed -n '
		/^.*[^.]\.[[:space:][:cntrl:]]*$/! {
			     H 
			 }  
		/^.*[^.]\.[[:space:][:cntrl:]]*$/  {
				     H
				     x 
				     s/\n\r/ /g
				     s/\n/ /g
				     p
				     s/.//g
				     x
		 }' \
     		     > "$out"/$lan/txt/${name%.*}.txt
    done;
done;
for lan in en es; do 
    cat "$out"/$lan/txt/*.txt | gzip - > "$out"/$lan/tedweb.$lan.txt.gz
done;



echo "generating TEDLIUM ..."

cat $tedlium \
    |  awk '{print tolower($0)}' \
    | sed -e 's:/[^/]*/[^/]*/::g' \
    | sed -e 's/{\(breath\|cough\|noise\|smack\)}/[HESITATION_]\1/ig' \
    | sed -e 's/{\(uh\|um\|eh\|er\|oh\|hoo\|huh\|ah\|hey\)}/[HESITATION_\1]/gi' \
    | sed -e 's:~::g' -e 's:\\'"'"':'"'"':g' \
    | gzip - >  $out/en/tedlium.clean.txt.gz
    #| sed -e 's:{\(u[h,m]\)}:\1:g' \

