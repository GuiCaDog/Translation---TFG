source config.sh

cat $CORPUS_FOLDER/corpus.f3.en | $moses_scripts/tokenizer/deescape-special-chars.perl > $CORPUS_FOLDER/corpus.deesc.en
cat $CORPUS_FOLDER/corpus.f3.fr | $moses_scripts/tokenizer/deescape-special-chars.perl > $CORPUS_FOLDER/corpus.deesc.fr
