#Setup run-specifig config

EVAL_FILES=evaluation_files_src
for file in $(ls $EVAL_FILES | grep CERNnews)
do     
       	FILE=$EVAL_FILES/$file
	FILE=${FILE##*/}
	INFER_FILE_PREFIX=${FILE%.*}
	
	#for keep in 90 80 70 60; do
	for keep in 100; do

		#source ./infer_fairseq_allKbest.sh $INFER_FILE_PREFIX $keep
		
		#for checkp in 1000 2000 5000 10000; do
		#for checkp in 100 200 500 1000; do
		for checkp in 500 1000 1500 2000 2500 5000; do

			source ./infer_fairseq_allKC.sh $INFER_FILE_PREFIX $keep $checkp
			echo "inferred $file.$keep.$checkp"
		done

  	# do something like: echo $databaseName
	done

		
done

