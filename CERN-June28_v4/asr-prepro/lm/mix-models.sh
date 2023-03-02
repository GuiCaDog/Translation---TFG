#!/bin/bash
# Adrià A. Martínez Villaronga, 2014
# Mix up to 10 LMs


USAGE="Usage: `basename $0` [options]   \n
\tMix language models\n\n
\t\t-h\t\t Print this help\n
\tLM options:
\t\t-o\t<order>\t order (optional, default 4)\n
\t\t-v\t<vocab>\t vocabulary\n
\t\t-l\t<lm_dir>\t lm dir\n
\t\t-lambda\t<lfile>\t lambdas file\n
\t\t-out\t<out_lm>\t out lm\n
\t\t-p\t<threshold>\t prunnig threshold\n
\t\t-vid\t<video_id>\t Video id for slides and docs\n
\tFormat options:
\t\t-c\t\t convert to tL lm format\n
\t\t-x\t\t compress resulting tL lm\n
\tLaunching and cluster options:
\t\t--local\t\t launch local instead of cluster\n
\t\t--print-order\t\t print the command instead of launching it\n
\t\t-m\t<mem>\t cluster memory (default 26)\n
\t\t-n\t<name>\t cluster name\n
\t\t-ld\t<log_dir>\t log directory\n
\t\t--qopts\t<qopts>\t add extra options to cluster\n
";

order=4
mem=26
ID=""
while [ "${1:0:1}" = "-" ]; do
    case $1 in
        --help|-h) echo -e $USAGE; exit 0;;
        --vocab|-v) vocab=$2; shift 2;;
        --order|-o) order=$2; order_opt=1; shift 2;;
        --lm-dir|-l) lms_dir=$2; shift 2;;
        --out-lm|-out) out_lm=$2; shift 2;;
        --prune|-p) prune="-prune $2"; shift 2;;
        --local)  local_mach=1; shift 1;;
	-lambda) lfile=$2; shift 2;;
	--memory|-m) mem=$2; shift 2;;
	--convert|-c) convert=1; shift 1;;
	--compress| -x) xc=1; shift 1;;
	--video-id|-vid) vid=$2; shift 2;;
	--print-order) printo=1; shift 1;;
	--name|-n) clsname=$2; shift 2;;
	--log-dir|-ld) logdir="-o $2"; shift 2;;
	--wp2) WP2DIR=$2; shift 2;;
	-id) ID="-id"; shift 1;;
	--qopts) QOPT+=" $2 "; shift 2;;
        *)
            echo "`basename $0`: Unknown option $1." 1>&2;
            echo -e $USAGE 1>&2;
            exit
            ;;
    esac;
done;


[ -z $vocab ] && echo -e "[EE] Missing vocab" 1>&2 && echo -e $USAGE 1>&2 && exit 1;
[ -z $lms_dir ] && echo -e "[EE] Missing lms dir" 1>&2 && echo -e $USAGE 1>&2 && exit 1;
[ -z $out_lm ] && echo -e "[EE] Missing out lm" 1>&2 && echo -e $USAGE 1>&2 && exit 1;
[ -z $lfile ] && echo -e "[EE] Missing lambdas file" 1>&2 && echo -e $USAGE 1>&2 && exit 1;
[ -z $order ] && echo -e "[WW] Missing order\nUsing 4 as default";


i=0


if [ -e $lms_dir/ocr ]; then
    vdir=ocr;
else
    vdir=sld;
fi



#for var in $lms_dir/*.lm.gz; do
for v in $(head -n 1 $lfile); do
    var="$lms_dir/$v.*lm.gz"
    if [ ! -e $var ]; then var="$lms_dir/$v.*arpa.gz"; fi
    if [ $i -eq 0 ]; then
	lm="-lm $var"
	[ ! -e $var ] && echo -e  "[EE] $var file not found" 1>&2 && exit 1;
    elif [ $i -eq 1 ]; then
	lm="$lm -mix-lm $var"
	[ ! -e $var ] && echo -e  "[EE] $var file not found" 1>&2 && exit 1;
    elif [ "$v" == "video" ]; then
	kk="$lms_dir/$vdir/$vid.lm.gz"
	if [ ! -z $WP2DIR ]; then kk="$WP2DIR/ocr.lm.gz"; fi
	lm="$lm -mix-lm$i $kk"
	[ ! -e   $kk ] && echo -e  "[EE]  $kk file not found" 1>&2 && exit 1;
    elif [ "$v" == "vdocs"  ]; then
	kk="$lms_dir/docs/$vid.*.gz"
	if [ ! -z $WP2DIR ]; then kk="$WP2DIR/docs.lm.gz"; fi
	lm="$lm -mix-lm$i $kk"
	[ ! -e   $kk ] && echo -e  "[EE]  $kk file not found" 1>&2 && exit 1;
    else
	lm="$lm -mix-lm$i $var"
	[ ! -e $var ] && echo -e  "[EE] $var file not found" 1>&2 && exit 1;
    fi
    i=`expr $i + 1`
done

mkdir -p $(dirname $out_lm)

out=$(cat $lfile)
out2=${out/*(/}
out3=${out2/)/}



i=0
for var in $out3
do
    if [ $i -eq 0 ]; then
        lambdas="-lambda $var"
    elif [ $i -ne 1 ]; then
        lambdas="$lambdas -mix-lambda$i $var"
    fi
    i=`expr $i + 1`
done




command="ngram -order $order $lm $lambdas -unk -vocab $vocab -write-lm $out_lm $prune"
if [ $convert ]; then
    if [ $xc ]; then
	command="$command; tLlmformat arpa -i $out_lm -o ${out_lm/.lm.gz/.tLlm}; gzip ${out_lm/.lm.gz/.tLlm}"
    else
	command="$command; tLlmformat arpa -i $out_lm -o ${out_lm/.lm.gz/.tLlm}"
    fi
fi



    
if [ $printo ]; then
    echo "$command"
elif [ $local_mach ]; then
    echo "$command" | bash
else

    if [ -z $clsname ]; then
	clsname=mix$(basename $lms_dir)
    fi
    if [ -z "$QOPT" ]; then
	QOPT="-p translectures -a estelles,raimon,fuster,gozer1,gozer2,herbero,merigold,penguin,riddler,sephiroth"
    fi
    qsubmit $ID $logdir $QOPT -m $mem -t 06:00:00  -n $clsname "$command"
fi


exit
