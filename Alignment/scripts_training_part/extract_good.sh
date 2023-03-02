source /home/gicado/trabajo/env/venv_py3.7_proba/bin/activate

SL=en
TL=fr

keep90=0.128571
keep80=0.233333
keep70=0.282857
keep60=0.366807
keep50=0.440353

RAW=~/tfg/cernArticles/halign/raw_training_aligned
for YEAR in $(ls $RAW)
do
	for MONTH in $(ls $RAW/$YEAR)
	do
	        for article in $(ls $RAW/$YEAR/$MONTH)
	        do	
			articlePath=$RAW/$YEAR/$MONTH/$article/$article.csv 
			articlePathOut=$RAW\_keep50/$YEAR/$MONTH/$article
			mkdir -p $articlePathOut	
			python extract_good_sentences.py $articlePath $keep50 $articlePathOut/$article.csv
		done
	done
done

deactivate


