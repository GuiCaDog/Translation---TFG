source config.sh

SYSTEM_NAME=$RUN
VERSION=1

N_TL=/scratch/translectures/systems/mt/"$SOURCE_LANG_SUFFIX"-"$TARGET_LANG_SUFFIX"/$SYSTEM_NAME

cd $N_TL;

export src=$SOURCE_LANG_SUFFIX
export tgt=$TARGET_LANG_SUFFIX
export TAG=$RUN

# You might need to run docker login mllp.upv.es:5000
docker build -t mt-"$src"-"$tgt":$TAG.v$VERSION .;
IMAGE_ID=$(docker images mt-"$src"-"$tgt":$TAG.v$VERSION --format "{{.ID}}"); echo $IMAGE_ID;
docker tag $IMAGE_ID mllp.upv.es:5000/mt-"$src"-"$tgt":$TAG.v$VERSION;
docker push mllp.upv.es:5000/mt-"$src"-"$tgt":$TAG.v$VERSION;
