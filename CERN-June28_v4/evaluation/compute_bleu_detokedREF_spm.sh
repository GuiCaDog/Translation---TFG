#Setup run-specifig config
source config.sh
source $PYTHON_ENV

INFER_OUTPUT_FOLDER=evaluation_files_hyp
export SACREBLEU_FORMAT=text

#hyp=$INFER_OUTPUT_FOLDER/CERNnews21.hyp.$TARGET_LANG_SUFFIX
#ref=CERNnews/CERNnews21.$TARGET_LANG_SUFFIX
#hyp=$INFER_OUTPUT_FOLDER/wmt13.enfr.hyp.$TARGET_LANG_SUFFIX
#ref=evaluation_files_tgt/wmt13.enfr.$TARGET_LANG_SUFFIX
hyp=$INFER_OUTPUT_FOLDER/CERN.enfr.dev.hyp.$TARGET_LANG_SUFFIX
ref=evaluation_files_tgt/CERN.enfr.dev.$TARGET_LANG_SUFFIX

echo "Computing BLEU for dev set"
cat $hyp |  spm_decode --model=$CORPUS_FOLDER/spm.model --input_format=id | $moses_scripts/recaser/detruecase.perl | $moses_scripts/tokenizer/detokenizer.perl -l $TARGET_LANG_SUFFIX | sacrebleu $ref -l $SOURCE_LANG_SUFFIX-$TARGET_LANG_SUFFIX

#hyp=$INFER_OUTPUT_FOLDER/CERNnews22.hyp.$TARGET_LANG_SUFFIX
#ref=CERNnews/CERNnews22.fr
#hyp=$INFER_OUTPUT_FOLDER/wmt14.enfr.hyp.$TARGET_LANG_SUFFIX
#ref=evaluation_files_tgt/wmt14.enfr.fr
hyp=$INFER_OUTPUT_FOLDER/CERN.enfr.test.hyp.$TARGET_LANG_SUFFIX
ref=evaluation_files_tgt/CERN.enfr.test.$TARGET_LANG_SUFFIX

echo "Computing BLEU for test set"
cat $hyp | spm_decode --model=$CORPUS_FOLDER/spm.model --input_format=id | $moses_scripts/recaser/detruecase.perl | $moses_scripts/tokenizer/detokenizer.perl -l $TARGET_LANG_SUFFIX | sacrebleu $ref -l $SOURCE_LANG_SUFFIX-$TARGET_LANG_SUFFIX

deactivate
