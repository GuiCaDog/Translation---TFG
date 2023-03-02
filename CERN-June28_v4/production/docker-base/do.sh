docker build -f Dockerfile.fairseq-base.ubuntu18.04-cuda10.0-fairseq0.8 -t fairseq-base.ubuntu18.04-cuda10.0-fairseq0.8 .
#docker images | less
#jiranzo@mikoto:/scratch/jiranzotmp/trabajo/mt_systems/prod/docker$ docker tag 86d71b3370d3 mllp.upv.es:5000/fairseq-base.ubuntu18.04-cuda10.0-fairseq0.8
#jiranzo@mikoto:/scratch/jiranzotmp/trabajo/mt_systems/prod/docker$ docker push mllp.upv.es:5000/fairseq-base.ubuntu18.04-cuda10.0-fairseq0.8
