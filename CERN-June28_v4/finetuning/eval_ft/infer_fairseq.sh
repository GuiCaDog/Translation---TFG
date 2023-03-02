#!/bin/bash
source config.sh

#Load Python environment
source $PYTHON_ENV
INFER_OUTPUT_FOLDER=evaluation_files_hyp90
#INFER_OUTPUT_FOLDER=evaluation_files_hyp100
mkdir -p $INFER_OUTPUT_FOLDER
export LC_ALL=C.UTF-8
INFER_FILE_PREFIX=$1
MODEL_OUTPUT_FOLDER=/scratch/gicado/nmt-scripts-output/experiments/mt/CERN/fairseq_out/CERN-June28_v4_1M_backtranslations.finetuned_K90CERNnews/
#MODEL_OUTPUT_FOLDER=/scratch/gicado/nmt-scripts-output/experiments/mt/CERN/fairseq_out/CERN-June28_v4_1M_backtranslations.finetuned_K100CERNnews/
FT_CORPUS_FOLDER=/home/gicado/tfg/mt_systems/enfr/CERN-June28_v4_1M_backtranslations/finetuning/CN_training_keep90/
#FT_CORPUS_FOLDER=/home/gicado/tfg/mt_systems/enfr/CERN-June28_v4_1M_backtranslations/finetuning/CN_training_keep100/
fairseq-interactive --path $MODEL_OUTPUT_FOLDER/checkpoint_best.pt \
                       --beam 6 \
                       --batch-size 8 \
                       --log-format none \
                       --buffer-size 8 \
                       --quiet \
                       $FT_CORPUS_FOLDER/fairseq_prepared_data_finetuning_CNdev_CERNnews/ \
                       --input $CORPUS_FOLDER/$INFER_FILE_PREFIX.prepro.spm.$SOURCE_LANG_SUFFIX | grep -P '^H' | cut -f3- > $INFER_OUTPUT_FOLDER/$INFER_FILE_PREFIX.hyp.$TARGET_LANG_SUFFIX
deactivate

