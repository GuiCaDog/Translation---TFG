source /home/gicado/trabajo/env/venv_py3.7_proba/bin/activate

SL=en
TL=fr

RAW=news_aligned_man
for YEAR in $(ls $RAW | grep 2021)
do
	for MONTH in $(ls $RAW/$YEAR | grep 09)
	do
	        for article in $(ls $RAW/$YEAR/$MONTH | grep -v .txt )
	        do	
			#echo $article
			out_folder=news_aligned_man_sed/$YEAR/$MONTH/$article
	    		mkdir -p $out_folder
			#2022 01
			#sed -e 's/(en anglais)//g' -e 's/(in French only)//g' $RAW/$YEAR/$MONTH/$article/$article.csv > $out_folder/$article.csv

			#2022 02
			#sed -e 's/(en anglais)//g' -e 's/(en anglais et accessible uniquement depuis le réseau du CERN)//g' $RAW/$YEAR/$MONTH/$article/$article.csv > $out_folder/$article.csv

			#2022 04
			#sed -e 's/(en anglais)//g' -e 's/(en anglais seulement)//g' $RAW/$YEAR/$MONTH/$article/$article.csv > $out_folder/$article.csv
			
			#2021 12
			#sed -e 's/(en anglais)//g' -e 's/(en anglais seulement)//g' $RAW/$YEAR/$MONTH/$article/$article.csv > $out_folder/$article.csv

			#2021 11	
			#sed -e 's/(French only)//g' $RAW/$YEAR/$MONTH/$article/$article.csv > $out_folder/$article.csv

			#2021 10	
			#sed -e 's/(en anglais)//g' $RAW/$YEAR/$MONTH/$article/$article.csv > $out_folder/$article.csv

			#2022 09
			sed -e 's/(en anglais)//g' -e 's/(in French only)//g' $RAW/$YEAR/$MONTH/$article/$article.csv > $out_folder/$article.csv
		done
	done
done

deactivate


