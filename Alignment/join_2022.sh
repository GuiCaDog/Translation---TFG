cat 2022_news_ordered | while read line
do

   cat news_aligned_man_sed_split/2022/*/*/$line.en >> CERNnews/CERNnews22.en
   cat news_aligned_man_sed_split/2022/*/*/$line.fr >> CERNnews/CERNnews22.fr

done
