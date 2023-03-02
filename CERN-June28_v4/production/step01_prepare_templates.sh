source config.sh

VERSION=1

sed -e "s/\${TEMPLATE_SRC}/$SOURCE_LANG_SUFFIX/g" -e "s/\${TEMPLATE_TGT}/$TARGET_LANG_SUFFIX/g" -e "s/\${TEMPLATE_RUN}/$RUN/g" -e "s/\${TEMPLATE_VERSION}/$VERSION/g" production/modules.tl.mt.src-tgt.RUN.TEMPLATE.py > modules.tl.mt."$SOURCE_LANG_SUFFIX"-"$TARGET_LANG_SUFFIX"."$RUN".py

#Custom fairseq version used for training both offline and simul systems
sed -e "s/\${TEMPLATE_SRC}/$SOURCE_LANG_SUFFIX/g" -e "s/\${TEMPLATE_TGT}/$TARGET_LANG_SUFFIX/g" production/Dockerfile.fairseq-simultaneous_99a84a834a.cuda10.0-fairseq-0.9.TEMPLATE > Dockerfile

#Remember to choose norm(default) or no-norm
sed -e "s/\${TEMPLATE_SRC}/$SOURCE_LANG_SUFFIX/g" -e "s/\${TEMPLATE_TGT}/$TARGET_LANG_SUFFIX/g" production/translate-fairseq-docker.no-norm.TEMPLATE.sh > translate-fairseq-docker.sh
chmod +x translate-fairseq-docker.sh

