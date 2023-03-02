cat 2021_news_ordered | while read line
do

   cat news_aligned_man_sed_split/2021/*/*/$line.en >> CERNnews/CERNnews21.en
   cat news_aligned_man_sed_split/2021/*/*/$line.fr >> CERNnews/CERNnews21.fr

done
