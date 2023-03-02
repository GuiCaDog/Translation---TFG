source /home/gicado/trabajo/env/venv_py3.7_proba/bin/activate

SL=en
TL=fr

RAW=raw_training_aligned
for YEAR in $(ls $RAW)
do
	for MONTH in $(ls $RAW/$YEAR)
	do
	        for article in $(ls $RAW/$YEAR/$MONTH)
	        do	
			sed -i 's/~~~//g' $RAW/$YEAR/$MONTH/$article/$article.csv
		done
	done
done

deactivate


