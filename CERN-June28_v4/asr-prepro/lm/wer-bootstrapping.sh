#!/bin/bash

# 2013. Created by Jorge Civera (jcivera@dsic.upv.es) and modified by Jesús Andés Ferrer (jandres@dsic.upv.es)
# and modified by Miguel Ángel del Agua Teba (mdelagua@dsic.upv.es)
#
# Change log:
# - 2013-07-16: Adapted to WER bootstrapping

USAGE="Usage: `basename $0` [options] \n\n
\t\t --help|-h\t Print this help\n
\t\t --ref\t\t Path to the file containing the references\n
\t\t --hyp\t\t Path to the file containing the hypothesis\n
\t\t --hyp2\t\t Path to the file containing the references of the 2nd system\n
\t\t\t\t (Only needed if two systems are being to be compared)
\t\t --block|-b\t Number of randomly selected segments for each iteration\n
\t\t --iter|-i\t Number of iterations to compute the bootstrapping\n
\t\t --werTool|-w\t Path to wer++.py (if necessary)\n"

SCR=${0##*/};
ref=""; test=""; N=""; hyp2="";
WERTOOL=`which wer++.py`
COMPARE=0;

while [ "${1:0:1}" = "-" ]; do
  case $1 in
    --help|-h)    echo -e $USAGE; exit 0;;
    --ref)        ref=$2; shift 2;;
    --hyp)        test=$2; shift 2;;
    --hyp2)       test2=$2; shift 2;;
    --block|-b)   block=$2; shift 2;;
    --iter|-i)    iter=$2; shift 2;;
    --werTool|-w) WERTOOL=$2; shift 2;;
    *)
      echo "`basename $0`: Unkown option $1." 1>&2;
      echo -e $USAGE 1>&2;
      exit 1;
      ;;
  esac;
done;

[ -z "$test" ] && echo -e $USAGE 1>&2 && echo "[EE] --hyp is required" 2>&1 && exit 1;
[ -z "$ref" ] && echo -e $USAGE 1>&2 && echo "[EE] --ref is required" 2>&1 && exit 1;
[ -z "$block" ] && echo -e $USAGE 1>&2 && echo "[EE] --block is required" 2>&1 && exit 1;
[ -z "$iter" ] && echo -e $USAGE 1>&2 && echo "[EE] --iter is required" 2>&1 && exit 1;

[ `cat $test | wc -l` -ne `cat $ref | wc -l` ] && echo "[EE] Input files are not of the same length" 2>&1 && exit 1;
[ $block -gt `cat $ref | wc -l` ] && echo "[EE] The size of the block is greater than the length of the files" 2>&1 && exit 1;
[ $block -le 0 ] && echo "[EE] The size of the block must be positive" 2>&1 && exit 1;
[ $iter -le 0 ] && echo "[EE] The number of iterations must be positive" 2>&1 && exit 1;
[ -z "$WERTOOL" ] && echo -e $USAGE 1>&2 && echo "[EE] Could not find wer++.py tool, please specify its location (-w)" 2>&1 && exit 1;

if [ ! -z "$test2" ]; then
  [ `cat $ref | wc -l` -ne `cat $test2 | wc -l` ] && echo "[EE] Input files are not of the same length" 2>&1 && exit 1;
  COMPARE=1;
fi

export LC_ALL=C;

TMP=${TMPDIR:-/tmp}/$SCR.$$
trap "rm -rf $TMP* 2>/dev/null" EXIT
mkdir $TMP

echo "[II] Estimating word error rate for each random set..."

if [ $COMPARE -eq 0 ]; then
  for ((n=1;n<=iter;n++)); do
    cat $test | \
    awk -v seed=$RANDOM -v ref=$ref -v tmp=$TMP -v blockSize=$block \
    'BEGIN{ while(getline<ref) refh[++nr]=$0; }
    { testh[NR]=$0; }
    END{ srand(seed); for(i=1;i<=blockSize;i++){ 
    id=1+int(NR*rand());
    printf "%s\n",testh[id] > tmp"/test";
    printf "%s\n",refh[id] > tmp"/ref";}
    }'
    $WERTOOL $TMP/test $TMP/ref >> $TMP/results
  done

  INTERVAL=`awk -v i=$iter '{print int(i*0.025)}' <( echo "" )`
  sort -n -k 2 $TMP/results > $TMP/results.sorted;
  average=`awk '{sum+=$2}END{print sum/NR}' $TMP/results.sorted`;
  lb=`cat $TMP/results.sorted | head -n $[INTERVAL+1]  | tail -1 | awk '{print $2}'`;
  mb=`cat $TMP/results.sorted | head -n $[iter/2]  | tail -1 | awk '{print $2}'`;
  ub=`cat $TMP/results.sorted | head -n $[iter-INTERVAL] | tail -1 | awk '{print $2}'`;
  echo "[II] Confidence Interval = [ $lb, $ub ]"
  echo "[II] Confidence Interval Median = $mb +/- `awk -v u=$ub -v l=$lb '{print sqrt((l-u)^2)}' <(echo "")`"
  echo "[II] Average over the entire set = $average"
else
  for ((n=1;n<=iter;n++)); do
    cat $test | \
    awk -v seed=$RANDOM -v ref=$ref -v test2=$test2 -v tmp=$TMP -v blockSize=$block \
    'BEGIN{ while(getline<ref) refh[++nr]=$0; nr=0; while(getline<test2) test2h[++nr]=$0; }
    { testh[NR]=$0; }
    END{ srand(seed); for(i=1;i<=blockSize;i++){ 
    id=1+int(NR*rand());
    printf "%s\n",testh[id] > tmp"/test";
    printf "%s\n",test2h[id] > tmp"/test2";
    printf "%s\n",refh[id] > tmp"/ref";}
    }'
    $WERTOOL $TMP/test $TMP/ref >> $TMP/results
    $WERTOOL $TMP/test2 $TMP/ref >> $TMP/results2
  done

  INTERVAL=`awk -v i=$iter '{print int(i*0.025)}' <( echo "" )`
  #### System A ####
  echo "[II] System which hypothesis is: $test (A)"
  echo "[II] ----------------------------------------------------------------"
  sort -n -k 2 $TMP/results > $TMP/results.sorted;
  average=`awk '{sum+=$2}END{print sum/NR}' $TMP/results.sorted`;
  lb=`cat $TMP/results.sorted | head -n $[INTERVAL+1]  | tail -1 | awk '{print $2}'`;
  mb=`cat $TMP/results.sorted | head -n $[iter/2]  | tail -1 | awk '{print $2}'`;
  ub=`cat $TMP/results.sorted | head -n $[iter-INTERVAL] | tail -1 | awk '{print $2}'`;
  echo "[II] Confidence Interval = [ $lb, $ub ]"
  echo "[II] Confidence Interval Median = $mb +/- `awk -v u=$ub -v l=$lb '{print sqrt((l-u)^2)}' <(echo "")`"
  echo "[II] Average over the entire set = $average"
  echo "";
  echo "[II] System which hypothesis is: $test2 (B)"
  echo "[II] --------------------------------------------------------------- "
  sort -n -k 2 $TMP/results2 > $TMP/results2.sorted;
  average=`awk '{sum+=$2}END{print sum/NR}' $TMP/results2.sorted`;
  lb=`cat $TMP/results2.sorted | head -n $[INTERVAL+1]  | tail -1 | awk '{print $2}'`;
  mb=`cat $TMP/results2.sorted | head -n $[iter/2]  | tail -1 | awk '{print $2}'`;
  ub=`cat $TMP/results2.sorted | head -n $[iter-INTERVAL] | tail -1 | awk '{print $2}'`;
  echo "[II] Confidence Interval = [ $lb, $ub ]"
  echo "[II] Confidence Interval Median = $mb +/- `awk -v u=$ub -v l=$lb '{print sqrt((l-u)^2)}' <(echo "")`"
  echo "[II] Average over the entire set = $average"
  echo "";
  echo "[II] Systems comparison (A vs B): "
  paste <( awk '{print $2 }' $TMP/results ) <( awk '{print $2}' $TMP/results2 ) | awk '{ print $1-$2 }' > $TMP/wer-diffs; cat $TMP/wer-diffs | sort -n > $TMP/comparison.sorted 
  average=`awk '{sum+=$1}END{print sum/NR}' $TMP/comparison.sorted`;
  lb=`cat $TMP/comparison.sorted | head -n $[INTERVAL+1] | tail -1`;
  mb=`cat $TMP/comparison.sorted | head -n $[iter/2] | tail -1`;
  ub=`cat $TMP/comparison.sorted | head -n $[iter-INTERVAL] | tail -1`;
  echo "[II] Confidence Interval = [ $lb, $ub ]"
  echo "[II] Confidence Interval Median = $mb +/- `awk -v u=$ub -v l=$lb '{print sqrt((l-u)^2)}' <(echo "")`"
  echo "[II] Average over the entire set = $average"
fi
