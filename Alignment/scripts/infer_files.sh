#Setup run-specifig config
source config.sh
RAW=~/tfg/cernArticles/align/raw_all_steps
#YEAR=2022
for YEAR in $(ls $RAW | grep 2022)
do
	for MONTH in $(ls $RAW/$YEAR)
	do
		for article in $(ls $RAW/$YEAR/$MONTH)
		do      
			INFER_FOLDER=$RAW/$YEAR/$MONTH/$article
			sourceFile=$(ls $INFER_FOLDER | grep ".$SOURCE_LANG_SUFFIX.txt")
			targetFile=$(ls $INFER_FOLDER | grep ".$TARGET_LANG_SUFFIX.txt")
	
			ORIG_FILE_PREFIX=$article
			FILE_PREFIX=$ORIG_FILE_PREFIX.prepro.$SUBWORD_SUFFIX
	
			#Supress email links
			sed -r 's/\S+@\S+.\S+//g' $INFER_FOLDER/$sourceFile > $INFER_FOLDER/$sourceFile.nomail
			sed -r 's/\S+@\S+.\S+//g' $INFER_FOLDER/$targetFile > $INFER_FOLDER/$targetFile.nomail
			mv $INFER_FOLDER/$sourceFile.nomail $INFER_FOLDER/$sourceFile
			mv $INFER_FOLDER/$targetFile.nomail $INFER_FOLDER/$targetFile
			#Supress http links
			sed -e 's!http[s]\?://\S*!!g' $INFER_FOLDER/$sourceFile > $INFER_FOLDER/$sourceFile.nurl
			sed -e 's!http[s]\?://\S*!!g' $INFER_FOLDER/$targetFile > $INFER_FOLDER/$targetFile.nurl
			mv $INFER_FOLDER/$sourceFile.nurl $INFER_FOLDER/$sourceFile
			mv $INFER_FOLDER/$targetFile.nurl $INFER_FOLDER/$targetFile
			#----------------------------------------------------------
	
			source split_text_into_lines_moses.sh
	
			source tokenize_truecase_files.sh
			#rm $INFER_FOLDER/$ORIG_FILE_PREFIX.lines.$SOURCE_LANG_SUFFIX
			source learn_and_apply_bpe.sh
			FILE_PREFIX=$ORIG_FILE_PREFIX.prepro.$SUBWORD_SUFFIX
			#rm $INFER_FOLDER/$ORIG_FILE_PREFIX.prepro.$SOURCE_LANG_SUFFIX
	
			source ./infer_$TOOLKIT.sh $FILE_PREFIX
			#rm $INFER_FOLDER/$FILE_PREFIX.$SOURCE_LANG_SUFFIX
			echo "inferred file $YEAR/$MONTH/$article"
			
			source detokenize_hyp.sh
			#rm $INFER_FOLDER/$FILE_PREFIX.hyp.$TARGET_LANG_SUFFIX
		done
	done
done

