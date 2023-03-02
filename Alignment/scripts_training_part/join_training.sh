cat training_inverse_cronological_news_ids | while read line
do
   cat ../raw_training_aligned/*/*/*/$line.en >> ../CN_training_keep100/CNcorpus.en
   cat ../raw_training_aligned/*/*/*/$line.fr >> ../CN_training_keep100/CNcorpus.fr
   #cat ../raw_training_aligned_keep90/*/*/*/$line.en >> ../CN_training_keep90/CNcorpus.en
   #cat ../raw_training_aligned_keep90/*/*/*/$line.fr >> ../CN_training_keep90/CNcorpus.fr
   #cat ../raw_training_aligned_keep80/*/*/*/$line.en >> ../CN_training_keep80/CNcorpus.en
   #cat ../raw_training_aligned_keep80/*/*/*/$line.fr >> ../CN_training_keep80/CNcorpus.fr
   #cat ../raw_training_aligned_keep70/*/*/*/$line.en >> ../CN_training_keep70/CNcorpus.en
   #cat ../raw_training_aligned_keep70/*/*/*/$line.fr >> ../CN_training_keep70/CNcorpus.fr
   #cat ../raw_training_aligned_keep60/*/*/*/$line.en >> ../CN_training_keep60/CNcorpus.en
   #cat ../raw_training_aligned_keep60/*/*/*/$line.fr >> ../CN_training_keep60/CNcorpus.fr
   #cat ../raw_training_aligned_keep50/*/*/*/$line.en >> ../CN_training_keep50/CNcorpus.en
   #cat ../raw_training_aligned_keep50/*/*/*/$line.fr >> ../CN_training_keep50/CNcorpus.fr
done
