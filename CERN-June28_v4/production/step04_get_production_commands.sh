source config.sh
source $PYTHON_ENV

if [ $# -lt 2 ]; 
then 
   printf "Usage: $0 BLEU_OF_THIS_SYSTEM ID_OF_OLD_SYSTEM\n" $# 
   exit 0 
fi 

src_code=$SOURCE_LANG_SUFFIX
tgt_code=$TARGET_LANG_SUFFIX
sourcen=$(python3 production/get_language_name_from_iso.py $SOURCE_LANG_SUFFIX production/iso_to_name.csv)
targetn=$(python3 production/get_language_name_from_iso.py $TARGET_LANG_SUFFIX production/iso_to_name.csv)
short_date=$(date +'%b%y')
long_date=$(date +'%Y-%m-%d')
system_name=$RUN
module=mt/modules.tl.mt.$src_code-$tgt_code.$system_name.py
bleu=$1
OLD_ID=$2


echo "###########################"
echo "Run the following commands inside the database:"

echo "insert INTO systems (lang1,lang2,type,name,description,module_path,public,as_default,enabled,features_tadapt,const_time,eval_value) values ('$src_code','$tgt_code','mt','$sourcen-$targetn MT system ($short_date)','$system_name $sourcen-$targetn MT system [$long_date]','$module',true,true,true,false,600,$bleu) returning id;"

echo " "
echo "UPDATE systems SET as_default=false,public=false,enabled=false WHERE id=$OLD_ID;"

echo " "

echo "Please enter the id returned by psql when you ran the previous instructions"

read id

echo "###########################"
echo "Now exit the db and run the following command to test your new system"
echo "python2 ~/git/tlp/misc/client-tools/python/scr/ws-client.py speech ingest new -l $src_code -t \"test_mt_$src_code-$tgt_code-$system_name-1\" -p $tgt_code:$id -M /home/ttpuser/git/ttp-scripts/ttp-tests/asr/$src_code/$src_code.mp4 \"test_mt_$src_code-$tgt_code-$system_name-1\""

echo "###########################"
echo "These logs might be helpful for debugging"
echo "/home/ttpuser/ttp/logs/ingest/is.speech.log"

echo "/home/ttpuser/ttp/data/speech/uploads/[ttp-process]/tmp/tl/[src-tgt]/translate.log"

echo "/home/ttpuser/ttp/data/speech/uploads/[ttp-process]/outputs"

e
