source config.sh
source $PYTHON_ENV

FT_NAME=CERNnews #$1
LR=1e-05 #$2
#You could use 0.00005, but ideal is to get the actual value when training finished

FAIRSEQ=/home/jiranzo/trabajo/git/fairseq/fairseq-0.9.0-efficient-simultaneous/
FT_CORPUS_FOLDER=~/tfg/mt_systems/enfr/CERN-June28_v4_1M_backtranslations/finetuning/CN_training_keep$1
MODEL_OUTPUT_FOLDER=/scratch/gicado/nmt-scripts-output/experiments/mt/CERN/fairseq_out/CERN-June28_v4_1M_backtranslations

fairseq-train $FT_CORPUS_FOLDER/fairseq_prepared_data_finetuning_CNdev_"$FT_NAME"/ \
  -s $SOURCE_LANG_SUFFIX \
  -t $TARGET_LANG_SUFFIX \
  --arch transformer_vaswani_wmt_en_fr_big \
  --share-all-embeddings \
  --task translation \
  --criterion label_smoothed_cross_entropy \
  --optimizer adam \
  --adam-betas '(0.9, 0.98)' \
  --lr-scheduler fixed \
  --clip-norm 0.0 \
  --lr $LR \
  --dropout 0.1 \
  --weight-decay 0.0 \
  --label-smoothing 0.1 \
  --max-tokens 1900 \
  --update-freq 8 \
  --restore-file $MODEL_OUTPUT_FOLDER/checkpoint_best.pt \
  --reset-optimizer \
  --save-dir $MODEL_OUTPUT_FOLDER.finetuned_K$1"$FT_NAME" \
  --max-update 5000 \
  --save-interval-updates 100 \
  --keep-interval-updates 50 \
  --save-interval 100 \
  --no-progress-bar \
  --log-interval 10 \
  --ddp-backend=no_c10d

