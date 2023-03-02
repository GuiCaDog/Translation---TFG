
in_file=$1

[ -z "$in_file" ] && echo "[EE] Input file is required" 2>&1 && exit 1;

export LC_ALL=C.UTF-8
NORM_PUNCT=/home/jiranzo/trabajo/git/nmt-scripts/asr-prepro/lm/normalize-punctuation.perl
TOKENIZER=/home/jiranzo/trabajo/git/nmt-scripts/asr-prepro/lm/tokenizer.perl

src=fr

DIR=$(dirname $in_file)
OUT_NAME=`basename -a $in_file`.tmp-02-preprocess

/home/jiranzo/trabajo/git/nmt-scripts/asr-prepro/lm/02-preprocess.sh \
        --corpus $in_file \
        --out $DIR --name $OUT_NAME \
        --tokenizer $TOKENIZER \
        --tokenize \
        --norm-punct ${NORM_PUNCT} \
        --lowercase --$src --erase-punc \
        --join-accents --translit-num \
        --no-hesitation
        
gunzip -d $DIR/$OUT_NAME.asr.clean.gz

cat $DIR/$OUT_NAME.asr.clean

rm $DIR/$OUT_NAME.asr.clean  $DIR/$OUT_NAME.asr.tok.gz

