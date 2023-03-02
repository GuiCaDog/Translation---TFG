#source config.sh
PYTHON_ENV=/home/jiranzo/trabajo/env/venv_py3.6_PyTorch1.2_fairseq-0.9.0-efficient-simultaneous_CUDA10.0_Ubuntu20.04/bin/activate
moses_scripts=/scratch/jiranzo/trabajo/git/mosesdecoder/scripts
#Load Python environment
source $PYTHON_ENV
export LC_ALL=C.UTF-8
SOURCE_LANG_SUFFIX=en
TARGET_LANG_SUFFIX=fr
CORPUS_FOLDER=/home/gicado/tfg/mt_systems/enfr/CERN-June28_v4_1M_backtranslations/data
FT_TRAIN_PREFIX=CNcorpus #$1
FT_DEV_PREFIX=CERNnews21 #$2
FT_TEST_PREFIX=CERNnews22 #$2
FT_NAME=CERNnews #$3
#FT_CORPUS=/home/gicado/tfg/cernArticles/halign/CN_training_keep100
FT_CORPUS_FOLDER=~/tfg/mt_systems/enfr/CERN-June28_v4_1M_backtranslations/finetuning/CN_training_keep$1


#$moses_scripts/recaser/truecase.perl < $FT_CORPUS_FOLDER/$FT_TRAIN_PREFIX.$SOURCE_LANG_SUFFIX > $FT_CORPUS_FOLDER/$FT_TRAIN_PREFIX.prepro.$SOURCE_LANG_SUFFIX -model $CORPUS_FOLDER/truecase-model.$SOURCE_LANG_SUFFIX    
#$moses_scripts/recaser/truecase.perl < $FT_CORPUS_FOLDER/$FT_TRAIN_PREFIX.$TARGET_LANG_SUFFIX > $FT_CORPUS_FOLDER/$FT_TRAIN_PREFIX.prepro.$TARGET_LANG_SUFFIX -model $CORPUS_FOLDER/truecase-model.$TARGET_LANG_SUFFIX    
##
##
#spm_encode --model=$CORPUS_FOLDER/spm.model --vocabulary $CORPUS_FOLDER/spm.vocab.$SOURCE_LANG_SUFFIX --vocabulary_threshold=50 --output_format=id < $FT_CORPUS_FOLDER/$FT_TRAIN_PREFIX.prepro.$SOURCE_LANG_SUFFIX > $FT_CORPUS_FOLDER/$FT_TRAIN_PREFIX.prepro.spm.$SOURCE_LANG_SUFFIX
#spm_encode --model=$CORPUS_FOLDER/spm.model --vocabulary $CORPUS_FOLDER/spm.vocab.$TARGET_LANG_SUFFIX --vocabulary_threshold=50 --output_format=id < $FT_CORPUS_FOLDER/$FT_TRAIN_PREFIX.prepro.$TARGET_LANG_SUFFIX > $FT_CORPUS_FOLDER/$FT_TRAIN_PREFIX.prepro.spm.$TARGET_LANG_SUFFIX


rm -r $FT_CORPUS_FOLDER/fairseq_prepared_data_finetuning_CNdev_"$FT_NAME"/

fairseq-preprocess --source-lang $SOURCE_LANG_SUFFIX \
	--target-lang $TARGET_LANG_SUFFIX \
	--trainpref $FT_CORPUS_FOLDER/$FT_TRAIN_PREFIX.prepro.spm \
	--validpref $CORPUS_FOLDER/$FT_DEV_PREFIX.prepro.spm \
	--testpref $CORPUS_FOLDER/$FT_TEST_PREFIX.prepro.spm \
	--destdir $FT_CORPUS_FOLDER/fairseq_prepared_data_finetuning_CNdev_"$FT_NAME" \
	--srcdict $CORPUS_FOLDER/fairseq_prepared_data/dict.$SOURCE_LANG_SUFFIX.txt \
	--joined-dictionary \
	--workers 1

deactivate
