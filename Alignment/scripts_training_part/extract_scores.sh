RAW=raw_training_aligned
for YEAR in $(ls $RAW)
do
	for MONTH in $(ls $RAW/$YEAR)
	do
	        for article in $(ls $RAW/$YEAR/$MONTH)
	        do
			cut -f3 $RAW/$YEAR/$MONTH/$article/$article.csv >> all_sentences_scores

		done
	done
done

