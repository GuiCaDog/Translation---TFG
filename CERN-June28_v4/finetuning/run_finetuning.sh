source config.sh

qsubmit -n tv4FT100 -gmem $GPU_MEM -gcards 1 -m 16 -a punxo,pinxo,panxo.dsic.upv.es,gozer2,estelles ./finetune_CN.sh 100 

qsubmit -n tv4FTK90 -gmem $GPU_MEM -gcards 1 -m 16 -a punxo,pinxo,panxo.dsic.upv.es,gozer2,estelles ./finetune_CN.sh 90
