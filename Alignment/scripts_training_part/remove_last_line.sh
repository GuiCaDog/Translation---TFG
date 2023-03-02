RAW=raw_training_aligned
for YEAR in $(ls $RAW)
do
	for MONTH in $(ls $RAW/$YEAR)
	do
	        for article in $(ls $RAW/$YEAR/$MONTH)
	        do
			head -n -1 $RAW/$YEAR/$MONTH/$article/$article.aligned.csv > $RAW/$YEAR/$MONTH/$article/$article.csv
			rm $RAW/$YEAR/$MONTH/$article/$article.aligned.csv 

		done
	done
done

