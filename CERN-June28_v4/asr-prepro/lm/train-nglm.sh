#!/bin/bash
# Train Ngram Language Model Using SRILM toolkit
# Adria A. Martinez Villaronga, 2014

TC=t

USAGE="Usage: `basename $0` [options]   \n
\tTrain language model\n\n
\t\t--help|-h\t\t Print this help\n
\t\t-t\t<text>\t text\n
\t\t-c\t<counts>\t counts id\n
\t\t-o\t<order>\t order\n
\t\t-v\t<vocab>\t vocabulary\n
\t\t-l\t<lm>\t language model\n
\t\t-x\t<tmp_dir>\t temporal dir\n
\t\t-p\t<threshold>\t prunning threshold\n
\t\t-k\t<kns_dir>\t discounts directory\n
\t\t--no-unk\t closed vocabulary LM\n
";

tmp_tlm=tmp_tlm;
UNK="-unk"
vocab=""

while [ "${1:0:1}" = "-" ]; do
    case $1 in
        --help|-h) echo -e $USAGE; exit 0;;
        --vocab|-v) vocab="-vocab $2"; shift 2;;
	--text|-t) text=$2; TC=t; shift 2;;
	--order|-o) ordre=$2; shift 2;;
	--counts|-c) counts=$2; TC=c; shift 2;;
	--lm|-l) lm=$2; shift 2;;
	--tmp|-x) tmp_tlm=$2; shift 2;;
	--kns|-k) kns_dir=$2; shift 2;;
	--prune|-p) prune="-prune $2"; shift 2;;
	--no-unk) UNK=""; shift 1;;
        *) 
            echo "`basename $0`: Unknown option $1." 1>&2;
            echo -e $USAGE 1>&2;
            exit
            ;;
    esac;
done;

[ -z $(which ngram-count) ] && echo -e "[EE] ngram-count not found. Please add to path.\n" 1>&2 && exit;


[ -z "$ordre" ] && echo -e "[EE] Missing ngram order\n\n" $USAGE 1>&2 && exit;
[ -z "$lm" ] && echo -e "[EE] Missing language model\n\n" $USAGE 1>&2 && exit
[ -z "$vocab" ] && echo  -e "[WW] Missing vocab\n\n"; # $USAGE 1>&2 && exit;
#[ ! -e $vocab ] && echo  -e "[EE] Vocab does not exist\n" 1>&2 && exit;
[ -z "$text" ] && [ -z "$counts" ] && echo -e "[EE] Missing training corpus (text or counts)\n\n" $USAGE 1>&2 && exit;
[ ! -z "$text" ] && [ ! -z "$counts" ] && echo -e "[WW] Both text and counts provided. Using counts." && TC=c;

if [ "$TC" = "t" ]; then
    corp="-text $text";
    [ ! -e $text ]  && echo  -e "[EE] Text file does not exist\n" 1>&2 && exit;
else
    corp="-read $counts";
    [ ! -e $text ]  && echo  -e "[EE] Counts file does not exist\n" 1>&2 && exit;
fi

mkdir -p $(dirname $lm)


if [ ! -z $kns_dir ]; then
    cname=$(basename ${counts%.counts.*.gz})
    kn=$cname.$ordre.kn
    knp=""; for i in $(seq 1 $ordre); do knp="$knp -kn$i $kns_dir/$kn.$i"; done
else
    mkdir -p $tmp_tlm
    knp=""; for i in $(seq 1 $ordre); do knp="$knp -kn$i $tmp_tlm/$(basename $lm)$i.kn"; done
fi
gtmin=""; for i in $(seq 1 $ordre); do gtmin="$gtmin -gt${i}min 0"; done

if [ -z "$kns_dir" ]; then
    ngram-count -order $ordre $corp $gtmin $knp -kndiscount -interpolate 2>&1 > /dev/null
fi
e=$(ngram-count -order $ordre $corp $gtmin $knp -kndiscount -interpolate $UNK $vocab -lm $lm $prune 2>&1 )

if [ ! -z "$e" ]; then
    if [ -z $kns_dir ]; then
        ngram-count -order $ordre $corp $gtmin $knp -ukndiscount -interpolate 2&>1 > /dev/null
    fi
    e=$(ngram-count -order $ordre $corp $gtmin $knp -ukndiscount -interpolate $UNK $vocab -lm $lm $prune 2>&1 )
fi
if [ ! -z "$e" ]; then
    e=$(ngram-count -order $ordre $corp $gtmin -cdiscount 0.8 -interpolate $UNK  $vocab -lm $lm $prune 2>&1 )
fi
if [ ! -z "$e" ]; then
    echo "[EE] Error while creating $lm" > /dev/stderr;
    exit 1;
fi



if [ -z $kns_dir ]; then
    rm -rf $tmp_tlm
fi
