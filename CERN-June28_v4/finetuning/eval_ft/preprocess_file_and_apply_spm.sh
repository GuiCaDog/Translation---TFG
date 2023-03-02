LC_ALL=C.UTF-8

PYTHON_ENV=/scratch/gicado/trabajo/env/venv_py3.6_PyTorch1.4_fairseq-0.9.0-firstModel_CUDA10.0/bin/activate

source $PYTHON_ENV
CORPUS_FOLDER=/scratch/arsar/tfg/mt_systems/data/fr-en/CERN-May13_data
EVAL_FOLDER_IN=evaluation_files_src
EVAL_FOLDER_OUT=$PWD
file_prefix=$1
lang=$2
moses_scripts=/scratch/jiranzo/trabajo/git/mosesdecoder/scripts


$moses_scripts/recaser/truecase.perl < $EVAL_FOLDER_IN/$file_prefix.$lang > $EVAL_FOLDER_OUT/$file_prefix.prepro.$lang -model $CORPUS_FOLDER/truecase-model.$lang

spm_encode --model=$CORPUS_FOLDER/spm.model --vocabulary $CORPUS_FOLDER/spm.vocab.$lang --vocabulary_threshold=50 --output_format=id < $EVAL_FOLDER_OUT/$file_prefix.prepro.$lang > $EVAL_FOLDER_OUT/$file_prefix.prepro.spm.$lang
deactivate

