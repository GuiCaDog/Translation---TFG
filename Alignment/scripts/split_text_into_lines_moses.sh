#source config.sh

source /home/gicado/trabajo/env/venv_py3.7_proba/bin/activate
export LC_ALL=C.UTF-8

cat $INFER_FOLDER/$sourceFile | $moses_scripts/ems/support/split-sentences.perl -n -l $SOURCE_LANG_SUFFIX > $INFER_FOLDER/$article.lines.$SOURCE_LANG_SUFFIX
cat $INFER_FOLDER/$targetFile | $moses_scripts/ems/support/split-sentences.perl -n -l $TARGET_LANG_SUFFIX > $INFER_FOLDER/$article.lines.$TARGET_LANG_SUFFIX

deactivate
