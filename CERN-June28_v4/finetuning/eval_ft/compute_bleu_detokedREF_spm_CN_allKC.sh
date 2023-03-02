#Setup run-specifig config
source config.sh
source $PYTHON_ENV
for keep in 100; do
		
	for checkp in 500 1000 1500 2000 2500 5000; do
		echo "----------------------------->" $checkp "<----------------------------- "
		INFER_OUTPUT_FOLDER=evaluation_files_hypK$keep\_C$checkp
		export SACREBLEU_FORMAT=text
		
		hyp=$INFER_OUTPUT_FOLDER/CERNnews21.hyp.$TARGET_LANG_SUFFIX
		ref=evaluation_files_tgt/CERNnews21.fr
		
		echo "Computing BLEU for dev set k$keep, c$checkp"
		cat $hyp |  spm_decode --model=$CORPUS_FOLDER/spm.model --input_format=id | $moses_scripts/recaser/detruecase.perl | $moses_scripts/tokenizer/detokenizer.perl -l $TARGET_LANG_SUFFIX | sacrebleu $ref -l $SOURCE_LANG_SUFFIX-$TARGET_LANG_SUFFIX
		
		hyp=$INFER_OUTPUT_FOLDER/CERNnews22.hyp.$TARGET_LANG_SUFFIX
		ref=evaluation_files_tgt/CERNnews22.fr
		
		echo "Computing BLEU for test set k$keep, c$checkp"
		cat $hyp | spm_decode --model=$CORPUS_FOLDER/spm.model --input_format=id | $moses_scripts/recaser/detruecase.perl | $moses_scripts/tokenizer/detokenizer.perl -l $TARGET_LANG_SUFFIX | sacrebleu $ref -l $SOURCE_LANG_SUFFIX-$TARGET_LANG_SUFFIX
	done
done

deactivate
