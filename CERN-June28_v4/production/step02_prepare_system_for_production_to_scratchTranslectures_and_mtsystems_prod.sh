set -e

source config.sh

SYSTEM_NAME=$RUN
N_TL=/scratch/translectures/systems/mt/"$SOURCE_LANG_SUFFIX"-"$TARGET_LANG_SUFFIX"/$SYSTEM_NAME
N_PROD=/scratch/jiranzotmp/trabajo/mt_systems/prod/"$SOURCE_LANG_SUFFIX""$TARGET_LANG_SUFFIX"/$SYSTEM_NAME


for TARGET_DIR in $N_TL; #$N_PROD;
do
    if [ -d "$TARGET_DIR" ];
    then
        echo "Target folder $TARGET_DIR already exists"
        exit 1
    else
        mkdir -p $TARGET_DIR/bpe
        cp $CORPUS_FOLDER/bpe.codes $TARGET_DIR/bpe/bpe.codes
        cp $CORPUS_FOLDER/bpe.vocab.$SOURCE_LANG_SUFFIX $TARGET_DIR/bpe/bpe.vocab.$SOURCE_LANG_SUFFIX
        cp $CORPUS_FOLDER/bpe.vocab.$TARGET_LANG_SUFFIX $TARGET_DIR/bpe/bpe.vocab.$TARGET_LANG_SUFFIX

        mkdir -p $TARGET_DIR/model
        cp $MODEL_OUTPUT_FOLDER/checkpoint_best.pt $TARGET_DIR/model/checkpoint_best.pt
        cp $CORPUS_FOLDER/fairseq_prepared_data/dict.$SOURCE_LANG_SUFFIX.txt $TARGET_DIR/model/dict.$SOURCE_LANG_SUFFIX.txt
        cp $CORPUS_FOLDER/fairseq_prepared_data/dict.$TARGET_LANG_SUFFIX.txt $TARGET_DIR/model/dict.$TARGET_LANG_SUFFIX.txt

        mkdir -p $TARGET_DIR/scripts
        cp $PWD/*.sh $TARGET_DIR/scripts

        if [[ -f "$CORPUS_FOLDER/truecase-model.$SOURCE_LANG_SUFFIX" ]]; then
            cp $CORPUS_FOLDER/truecase-model.$SOURCE_LANG_SUFFIX $TARGET_DIR/truecase-model.$SOURCE_LANG_SUFFIX
        fi

        if [[ -f "$CORPUS_FOLDER/truecase-model.$TARGET_LANG_SUFFIX" ]]; then
            cp $CORPUS_FOLDER/truecase-model.$TARGET_LANG_SUFFIX $TARGET_DIR/truecase-model.$TARGET_LANG_SUFFIX
        fi

        if [[ -f "README" ]]; then
            cp README $TARGET_DIR/README
        fi

        if [[ -f "Dockerfile" ]]; then
            cp Dockerfile $TARGET_DIR/Dockerfile
        fi

        if [[ -f "translate-fairseq-docker.sh" ]]; then
            cp translate-fairseq-docker.sh $TARGET_DIR/translate-fairseq-docker.sh
        fi

    fi
done
