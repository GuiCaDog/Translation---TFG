#!/bin/bash
# Extract vocabulary from text
# Adria Martinez-Villaronga, 2014

export LC_ALL='C.UTF-8'

USAGE="Usage: `basename $0` [options] < text > vocab  \n\n
\tExtract vocabulary from stdin.\n
\tWords that appear less than N times will be filtered.\n\n
\t\t-h\tPrint this help\n
\t\t-n <N>\tMin freq. (default 1)\n
\t\t-x\tCompress output\n"


n=1

while [ "${1:0:1}" = "-" ]; do
    case $1 in
	-h) echo -e $USAGE; exit;;
	-n) n=$2; shift 2;;
	-x) ZIP=1; shift 1;;
	*)
            echo "`basename $0`: Unknown option $1." 1>&2;
            echo -e $USAGE 1>&2;
            exit 1
            ;;
    esac
done
	


if [ "$1" == "-n" ]; then
    n=$2;
fi

ngram-count -order 1 -text - -write - -no-eos -no-sos | 
awk -v n=$n '$2>=n{print $1}' | 
if [ ! -z $ZIP ]; then
    gzip -
else
    cat -
fi


