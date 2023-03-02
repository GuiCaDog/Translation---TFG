source /home/gicado/trabajo/env/venv_py3.7_proba/bin/activate

SL=en
TL=fr

RAW=raw_training
for YEAR in $(ls $RAW | grep 2020)
do
	for MONTH in $(ls $RAW/$YEAR)
	do
	        for article in $(ls $RAW/$YEAR/$MONTH)
	        do
			out_folder=raw_training_aligned/$YEAR/$MONTH/$article
	    		mkdir -p $out_folder
			hunalign-1.1/src/hunalign/hunalign -utf null.dic $RAW/$YEAR/$MONTH/$article/$article.lines.$SL $RAW/$YEAR/$MONTH/$article/$article.lines.$TL -text > $out_folder/$article.aligned.csv
		done
	done
done

deactivate


