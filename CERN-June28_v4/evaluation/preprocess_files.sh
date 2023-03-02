#Setup run-specifig config

EVAL_FILES=evaluation_files_src
for file in $(ls $EVAL_FILES | grep news)
do     
       	FILE=$EVAL_FILES/$file
	FILE=${FILE##*/}
	INFER_FILE_PREFIX=${FILE%.*}
	
	source preprocess_file_and_apply_spm.sh $INFER_FILE_PREFIX 'en'

done

