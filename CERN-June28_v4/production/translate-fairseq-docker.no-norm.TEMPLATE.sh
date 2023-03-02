#!/bin/bash 

NARGS=2

set -u
[ $# != $NARGS ] && { print_help /dev/stderr 0; error "Wrong number of arguments, $# != $NARGS"; exit 1; }

TMP=/home/ttpuser/tmp
IO=/home/ttpuser/io
export LC_ALL=C.UTF-8

src=${TEMPLATE_SRC}
tgt=${TEMPLATE_TGT}
INLIST="$IO/$1"
OUTLIST="$IO/$2"


SYSTEM_DIRECTORY=$PWD
moses_scripts=/home/ttpuser/gits/mosesdecoder/scripts
SUBWORD_FOLDER=/home/ttpuser/gits/subword-nmt
BPE_FOLDER=bpe/

paste -d " " $INLIST $OUTLIST > $TMP/paste_file_list
while read in_f out_f
do 
    filename=$(basename $in_f)
    echo "Processing $filename"
    cat $in_f | $moses_scripts/tokenizer/tokenizer.perl -a -l $src -no-escape | $moses_scripts/recaser/truecase.perl -model $SYSTEM_DIRECTORY/truecase-model.$src | python3 $SUBWORD_FOLDER/apply_bpe.py -c $BPE_FOLDER/bpe.codes --vocabulary $BPE_FOLDER/bpe.vocab.$src --vocabulary-threshold 50 > $TMP/$filename.prepro
 
 
    MODEL=model/ 

#Meter los vocabs (dict) del prepared data dentro de la carpeta $MODEL
fairseq-interactive --path $MODEL/checkpoint_best.pt \
                       --beam 6 \
                       --batch-size 2 \
                       --log-format none \
                       --buffer-size 16 \
                       --quiet \
                       $MODEL \
                       --input $TMP/$filename.prepro --source-lang $src --target-lang $tgt | grep -P '^H' | cut -f3- | sed -r 's/\@\@ //g' | $moses_scripts/tokenizer/detokenizer.perl -l $tgt > $out_f

done < $TMP/paste_file_list
