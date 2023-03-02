source /home/gicado/trabajo/env/venv_py3.7_proba/bin/activate

SL=en
TL=fr

RAW=news_aligned_sed
for YEAR in $(ls $RAW)
do
	for MONTH in $(ls $RAW/$YEAR)
	do
	        for article in $(ls $RAW/$YEAR/$MONTH)
	        do
			out_folder=$RAW\_split/$YEAR/$MONTH/$article
	    		mkdir -p $out_folder
			cut -f1 $RAW/$YEAR/$MONTH/$article/$article.csv > $out_folder/$article.$SL
			cut -f2 $RAW/$YEAR/$MONTH/$article/$article.csv > $out_folder/$article.$TL
		done
	done
done

deactivate


