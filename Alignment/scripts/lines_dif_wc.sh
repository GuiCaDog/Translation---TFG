#wc -w raw_aligned/2022/*/*/*.sed.en | awk '{ print NR " " $1;}' > df1
wc -w news_aligned_raw_split/2021/*/*/*.en | awk '{print NR " " $1}' > df1
wc -w raw/2021/*/*/*.lines.en | awk '{ print NR " " $1;}' > df2
echo "English news with different word count:"
diff df1 df2

#wc -w raw_aligned/2022/*/*/*.sed.fr | awk '{ print NR " " $1;}' > df1
wc -w news_aligned_raw_split/2021/*/*/*.fr | awk '{print NR " " $1}' > df1
wc -w raw/2021/*/*/*.lines.fr | awk '{ print NR " " $1;}' > df2
echo "French news with different word count:"
diff df1 df2
rm df1 df2

ls raw/2021/*/*/*.lines.en | awk '{ print NR " " $1;}' > newsIndexed.en
ls raw/2021/*/*/*.lines.fr | awk '{ print NR " " $1;}' > newsIndexed.fr

