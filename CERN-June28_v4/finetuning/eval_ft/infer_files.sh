#Setup run-specifig config

EVAL_FILES=evaluation_files_src
for file in $(ls $EVAL_FILES)
do     
       	FILE=$EVAL_FILES/$file
	FILE=${FILE##*/}
	INFER_FILE_PREFIX=${FILE%.*}
	
	source ./infer_fairseq.sh $INFER_FILE_PREFIX
	source ./infer_fairseq100.sh $INFER_FILE_PREFIX
	echo "inferred $file"
		
done

