#Setup run-specifig config
PYTHON_ENV=/scratch/gicado/trabajo/env/venv_py3.6_PyTorch1.4_fairseq-0.9.0-firstModel_CUDA10.0/bin/activate
moses_scripts=/scratch/gicado/trabajo/git/mosesdecoder/scripts
SOURCE_LANG_SUFFIX=en
TARGET_LANG_SUFFIX=fr

RAW=~/tfg/cernArticles/halign/raw_training
for YEAR in $(ls $RAW | grep 2017)
do
	for MONTH in $(ls $RAW/$YEAR)
	do
		for article in $(ls $RAW/$YEAR/$MONTH)
		do      
			echo $YEAR
			INFER_FOLDER=$RAW/$YEAR/$MONTH/$article
			sourceFile=$(ls $INFER_FOLDER | grep ".$SOURCE_LANG_SUFFIX.txt")
			targetFile=$(ls $INFER_FOLDER | grep ".$TARGET_LANG_SUFFIX.txt")
			
			echo $INFER_FOLDER 
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
		done
	done
done

