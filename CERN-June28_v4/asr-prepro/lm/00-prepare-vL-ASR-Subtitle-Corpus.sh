#!/bin/bash
# 2013. Jesus Andres Ferrer
# Change Log:
#  - 2013-06-10 Added iconv to convert everything to UTF-9
#  - 2013-06-10 Erased Prof: LEMAN: Student: etc tags
#  - 2013-06-10 Added processinf of rt
#  - 2013-06-10 Added out_name
#  - 2013-06-17 fixed problems with cat


repo=$HOME/sd/01-Proyectos/transLectures-UPV/
index=$repo/tL/pub/wp2/t2.1/All\ lectures\ with\ subtitles.csv
vL=/home/translectures/vl/data/current/
out_name=vL-subtitles

out=$1;
if [ $# -lt 1 ]; then echo `basename $0` out_dir; exit; fi;
if [ ! -e "$index" -o ! -e "$vL" ]; then
    echo "Either  $index  or $vL does not exist" 
    echo `basename $0` out_dir; exit; i
fi;
TMP=$(mktemp `basename $0`.$$.XXXX );
trap "\rm -f $TMP " EXIT

cat "$index" | gawk 'BEGIN{FS=";"} { if($8=="en")print $2;}'>$TMP
## ----
declare -A formats=( ["ASCII"]="ASCII" ["UTF-8"]="UTF-8" ["ISO-8859"]="ISO-8859-1" \
		     ["Non-ISO"]="ISO-8859-1" ["FORTRAN"]="ISO-8859-1" ["OS/2"]="US-ASCII"]);
mkdir -p $out/srt
mkdir -p $out/rt
mkdir -p $out/seg
mkdir -p $out/txt
while read video; do
    echo -e "\t Processing $video ... "
    dir="${video:0:1}/$video"
    if [ ! -e  $vL/$dir/video_01 ]; then
	echo " $vL/$dir/video_01 does not exists, skipping ">/dev/stderr;
    fi;
    # process srt files
    ls $vL/$dir/video_01/*.srt &>/dev/null;
    if [ $? -eq 0 ]; then
	for f in $vL/$dir/video_01/*.srt; do
	    cp $f $out/srt;
	    name=${f##*/}
	    echo -e "\t\t hashed to  $name "
	    cat $out/srt/$name \
		|sed -e 's/\n\r/\n/g' \
		|   gawk '{if (s<3) ++s;} /^[[:space:]]*$/ {s=0} {if(s==3)  print $0;}' \
		> $out/seg/${name%.*}.seg
	    dos2unix $out/seg/${name%.*}.seg &>/dev/null
	    format=`file $out/seg/${name%.*}.seg| cut -d ' ' -f 2`
	    if [ ! -z "${formats[$format]}" ];  then
		rformat=${formats[$format]};
	    else
		echo -e "\t\t\t format : `file $out/seg/${name%.*}.seg` not analysed, changing to US-ASCII";
		rformat="US-ASCII";
	    fi;
	    #echo "format: $format rformat: $rformat  to UTF-8"
	    iconv  --from-code ${rformat} --to-code UTF-8 $out/seg/${name%.*}.seg \
		|  sed -n '/^[[:space:]]*$/!p' \
		|  sed -e 's/<[^>]*>//g' -e 's/{[^>]*}//g'   \
		|  sed -e 's/\[[^]]\]//g'   \
		|  sed -e 's/^[[:space:]]*[A-Za-z]*://g'   \
		|  sed -e 's/~[^[:space:]]\+//g' -e 's/[^[:space:]]~//g' -e 's/\/[^[:space:]]\+[:space:]/ /g' \
		|  sed -n '
		/^.*[^.]\.[[:space:][:cntrl:]]*$/! {
			     H 
			 }  
		/^.*[^.]\.[[:space:][:cntrl:]]*$/{
				     H
				     x 
				     s/\n\r/ /g
				     s/\n/ /g
				     p
				     s/.//g
				     x
		 }'>$out/txt/${name%.*}.txt 
#/\(.[^.][[:space:]]*\|.[^.]\)$/
	done;
    else
	ls $vL/$dir/video_01/*.rt &>/dev/null;
	if [ $? -eq 0 ]; then
# process rt files
 	    for f in $vL/$dir/video_01/*.rt; do
		cp $f $out/rt;
		name=${f##*/}
		echo -e "\t\t hashed to  $name "
		cat $out/rt/$name \
		    |sed -e 's/\n\r/\n/g' \
		    |sed -e 's/<[^>]*>//g' \
		    |  sed -e 's/^[[:space:]]*[A-Z]*://g'   \
		    | sed   -e 's/&[^;]*;//g ' \
		    -e '/^[[:space:]]*$/d' \
		    >  $out/seg/${name%.*}.seg
		dos2unix $out/seg/${name%.*}.seg &>/dev/null
		format=`file $out/seg/${name%.*}.seg| cut -d ' ' -f 2`
		if [ ! -z "${formats[$format]}" ];  then
		    rformat=${formats[$format]};
		else
		    echo -e "\t\t\t format : `file $out/seg/${name%.*}.seg` not analysed, changing to US-ASCII";
		    rformat="US-ASCII";
		fi;
		#echo "format: $format rformat: $rformat  to UTF-8"
		iconv  --from-code ${rformat} --to-code UTF-8 $out/seg/${name%.*}.seg \
		    | sed -n '
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
		 }' >$out/txt/${name%.*}.txt
	    done;
	else
	    echo "$video doesn't have either rt or srt in   $vL/$dir/video_01/, skipping !";
	fi;
    fi;
done <$TMP

cat "$out"/txt/*.txt |gzip - > "$out"/$out_name.txt.gz
zcat "$out"/$out_name.txt.gz | translit_en.py | gzip - > "$out"/$out_name.nn.txt.gz

generate_vocab.sh  <( zcat "$out"/$out_name.txt.gz) > "$out"/$out_name.voc_num
cat "$out"/$out_name.voc_num | cut -d' ' -f1 | sort -u > "$out"/$out_name.voc
gzip -f "$out"/$out_name.voc

generate_vocab.sh  <( zcat "$out"/$out_name.nn.txt) > "$out"/$out_name.nn.voc_num
cat "$out"/$out_name.nn.voc_num | cut -d' ' -f1 | sort -u > "$out"/$out_name.nn.voc
gzip -f "$out"/$out_name.nn.voc

