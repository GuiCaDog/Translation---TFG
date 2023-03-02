#Setup run-specifig config
source config.sh
source $PYTHON_ENV

export SACREBLEU_FORMAT=text

#hyp=wmt13.prod.hyp.fr
hyp=CERNnews21.prod.hyp.fr
ref=CERNnews/CERNnews21.fr
#ref=/scratch/jiranzotmp/trabajo/mt_systems/enfr/CERN-Feb22_data/wmt13.enfr.fr
echo "Computing BLEU for dev set"
cat $hyp | $moses_scripts/recaser/detruecase.perl | sacrebleu $ref -l $SOURCE_LANG_SUFFIX-$TARGET_LANG_SUFFIX

#hyp=wmt14.prod.hyp.fr
hyp=CERNnews22.prod.hyp.fr
#ref=/scratch/jiranzotmp/trabajo/mt_systems/enfr/CERN-Feb22_data/wmt14.enfr.fr
ref=CERNnews/CERNnews22.fr

echo "Computing BLEU for test set"
cat $hyp | $moses_scripts/recaser/detruecase.perl | sacrebleu $ref -l $SOURCE_LANG_SUFFIX-$TARGET_LANG_SUFFIX

deactivate
