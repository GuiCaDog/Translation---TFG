#!/bin/bash
#

# 2013. Jesus Andres Ferrer (jandres@dsic.upv.es)
#
# Change log:
# - 2013-06-22: Initiallised from background (from tL perspective) scripts developed by JAF
# - 2013-06-22: changed variable names, added step, ...
# - 2013-06-22: fixed options problems


USAGE="Usage: `basename $0` [options]   \n\n
\t\t--help|-h\t\t Print this help\n
\t\t--voc\t<voc>\t the voc file {word \\n}*\n
\t\t--dev\t<file>\t the development file to optimize weights {sentence \\n}*\n
\t\t--tst\t<file>\t the test file to check ppl not used in opt {sentence \\n}*\n
\t\t--tst2\t<file>\t the a second test of your choice file to check ppl not used in opt {sentence \\n}*\n
\t\t--out\t<out>\t the output dir \n
\t\t--name\t<string>\t the name of the final lm\n
\t\t--lms\t<space_list_lms>\t the lms to mix \n
\t\t--unk\t\t add -unk to ngram-ppl executions \n
\t\t--prune\t<prob>\t add -prune prob to ngram executions \n
\t\t--prune-mix|-pm\t<prob>\t add -prune prob to the interpolated model \n
";

STATE=0;
step=6;
declare -a lms=();
while [ ! -z "$1" ]; do 
    if [ "${1:0:1}" = "-" ]; then
	case $1 in
	    --help|-h) echo -e $USAGE; exit 0;;
	    --voc|-v) 	    VOCAB=$2; shift 2;;
	    --dev|-d) 	    DEV=$2; shift 2;;
	    --tst|-t) 	    TST=$2; shift 2;;
	    --tst2|-t) 	    TST2=$2; shift 2;;
	    --out|-o) 	    OUT=$2; shift 2;;
	    --name|-m) 	    NAME=$2; shift 2;;
	    --lms|-l)       STATE=1; shift 1;;
            --prune|-p)     PRUNE=" -prune $2 "; PRUNE_MIX=$PRUNE; shift 2;;
            --prune-mix|-pm)     PRUNE_MIX=" -prune $2 "; shift 2;;
            --unk|-k)       unk=" -unk "; shift 1;;
            --step|-s)      step=$2; shift 2;;
	    *) 
		echo "`basename $0`: Unknown option $1." 1>&2;
		echo -e $USAGE 1>&2;
		exit
		;;
	esac;
    elif [ $STATE -eq 1 ]; then
	lms+=( $1 ); 
	shift 1;
    else
	echo "`basename $0`: something went wrong $1." 1>&2;
	echo -e $USAGE 1>&2;
	exit
    fi;
done;

echo "[GG:$step] VOCAB: $VOCAB DEV: $DEV TST: $TST OUT: $OUT NAME: $NAME PRUNE: $PRUNE unk : $unk step: $step"
echo "[GG:$step] lms: ${lms[@]} "

[ -z "$VOCAB" ] && echo -e $USAGE 1>&2 && echo "[EE:$step] --voc is mandatory" && exit 1
[ ! -e "$VOCAB" ] && echo -e $USAGE 1>&2 && echo "[EE:$step] --voc does not exist: $VOCAB" && exit 1
[ -z "$DEV" ] && echo -e $USAGE 1>&2 && echo "[EE:$step] --dev is mandatory" && exit 1
[ ! -e "$DEV" ] && echo -e $USAGE 1>&2 && echo "[EE:$step] --dev does not exist: $VOCAB" && exit 1
[ -z "$OUT" ] && echo -e $USAGE 1>&2 && echo "[EE:$step] --out is mandatory" && exit 1
[ -z "$NAME" ] && echo -e $USAGE 1>&2 && echo "[EE:$step] --name is mandatory" && exit 1

[ ! -d $OUT ] && ( mkdir -p $OUT && echo " created $OUT ")

echo "[II:$step] read ${#lms[@]} lms ";
ns=(); i=0; N=0; cbm_params="";
for lm in "${lms[@]}"; do 
    n=`get-arpa-max-order.sh $lm `
    ns=( "${ns[@]}" "$n");
    echo "[II:$step]" order: $n lm: $lm
    if [ ! -z "$PRUNE" ]; then
        if [  ! -e $OUT/lm${i}.arpa.gz ]; then
            ngram -limit-vocab $VOCAB -vocab $VOCAB $unk -order $n -lm $lm -write-lm $OUT/lm${i}.arpa.gz  $PRUNE
        fi;
    else
        pwd=$PWD;
        ( cd  $OUT ; ln -s  $pwd/$lm lm${i}.arpa.gz );
    fi;
    if [  ! -e $OUT/lm${i}.out ]; then 
        ngram -order $n -lm $OUT/lm${i}.arpa.gz -ppl $DEV -vocab $VOCAB -debug 2 $unk > $OUT/lm${i}.out 
    fi;
    cbm_params+=" $OUT/lm${i}.out ";
    if [ $n -gt $N ]; then N=$n; fi;
        i=$[ $i + 1 ];
    done;
    n=$N;
    echo "[II:$step] ++ Maximum ORDER ++ $n"
    echo "[II:$step] Computing int weights "
    if [ ! -e $OUT/lambdas.out ]; then
        CMD="compute-best-mix $cbm_params "
        echo $CMD
        $CMD >$OUT/lambdas.out
    fi;
    if [ ! -e $OUT/lambdas.out ]; then
        echo "Error $OUT/lambdas.out not computed";
        exit;
    fi;
    lambdas=()
    for ((i=1;i<=${#lms[@]};++i)); do
        l=`cat $OUT/lambdas.out | awk -v pos=$i 'BEGIN{FS="[( )]"}{print $(NF-pos)}'`
        lambdas=($l ${lambdas[@]})
    done;
    echo "[II:$step] lambdas: ${lambdas[@]}"
    echo "[II:$step] lms:     ${lms[@]}"
    for j in "${!lambdas[@]}"; do echo "[II:$step] ${lms[$j]} ${lambdas[$j]}"; done
    ng_params="-lm $OUT/lm0.arpa.gz -lambda ${lambdas[0]} -mix-lm $OUT/lm1.arpa.gz"
    for ((i=2;i<${#lms[@]};++i)); do
        ng_params="$ng_params -mix-lm${i} $OUT/lm${i}.arpa.gz -mix-lambda${i} ${lambdas[$i]} "
    done;
    if [ ! -e $OUT/$NAME.int.arpa.gz ]; then
        CMD="ngram -order $n $ng_params -write-lm $OUT/$NAME.int.arpa.gz -limit-vocab $VOCAB -vocab $VOCAB $PRUNE_MIX $unk ";
        echo $CMD
        $CMD
    fi;

    echo "[II:$step] Dev ppl:"
 #dev
 CMD="ngram  -order $n -vocab $VOCAB -lm $OUT/$NAME.int.arpa.gz  -ppl $DEV -unk           ";
 CMD2="ngram -order $n -vocab $VOCAB -lm $OUT/$NAME.int.arpa.gz  -ppl $DEV -unk -skipoovs ";
 echo $CMD;
 line1=`$CMD  | tail -1 | gawk '{print $6,$8}'`;
 line2=`$CMD2 | tail -1 | gawk '{print $6,$8}'`;
 echo "[DEV] ORDER: $n ppl: $line1 ppl_sk: $line2  opt: $opt  "
#TST
if [ ! -z "$TST" ]; then
    echo "[II:$step] Test ppl:"
    CMD="ngram  -order $n -vocab $VOCAB -lm $OUT/$NAME.int.arpa.gz -ppl $TST -unk           ";
    CMD2="ngram -order $n -vocab $VOCAB -lm $OUT/$NAME.int.arpa.gz -ppl $TST -unk -skipoovs ";
    echo $CMD;
    line1=`$CMD  |tail -1 | gawk '{print $6,$8}'`;
    line2=`$CMD2 |tail -1 | gawk '{print $6,$8}'`;
    echo "[TEST] ORDER: $n  ppl: $line1 ppl_sk: $line2  opt: $opt  "
fi;
    
if [ ! -z "$TST2" ]; then
    echo "[II:$step] Test ppl:"
    CMD="ngram  -order $n -vocab $VOCAB -lm $OUT/$NAME.int.arpa.gz -ppl $TST2 -unk           ";
    CMD2="ngram -order $n -vocab $VOCAB -lm $OUT/$NAME.int.arpa.gz -ppl $TST2 -unk -skipoovs ";
    echo $CMD;
    line1=`$CMD  |tail -1 | gawk '{print $6,$8}'`;
    line2=`$CMD2 |tail -1 | gawk '{print $6,$8}'`;
    echo "[TEST_2] ORDER: $n  ppl: $line1 ppl_sk: $line2  opt: $opt  "
fi;
    
