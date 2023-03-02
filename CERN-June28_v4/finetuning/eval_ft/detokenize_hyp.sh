#Setup run-specifig config
#source config.sh
source $PYTHON_ENV

hyp=$INFER_FOLDER/$FILE_PREFIX.hyp.$TARGET_LANG_SUFFIX

cat $hyp | sed -r 's/\@\@ //g' | $moses_scripts/recaser/detruecase.perl | $moses_scripts/tokenizer/detokenizer.perl -l $TARGET_LANG_SUFFIX > $INFER_FOLDER/$ORIG_FILE_PREFIX-trans

deactivate
