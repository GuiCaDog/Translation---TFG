#!/bin/bash

SCR=/home/jiranzo/trabajo/git/asr-scripts/lm/en/2018/
export LC_ALL=C.UTF-8

source ~amartinez/feina/venvs/tf14_cudnn7_cuda8_python34_estelles/bin/activate

cat - |
    sed "s|[ ]\?'s\>|---s|gI" |
    sed "s|s'$|s---|gI" |
    sed "s|s'\([ .,!?'\"]\)|s---\1|gI" |
    sed "s|[ ]\?'re\>|---re|gI" |
    sed "s|[ ]\?'t\>|---t|gI" |
    sed "s|[ ]\?'ll\>|---ll|gI" |
    sed "s|[ ]\?'m\>|---m|gI" |
    sed "s|[ ]\?'ve\>|---ve|gI" |
    sed "s|\<o'|o---|gI" |
    sed "s|[ ]\?'em\>| ---em|gI" |
    sed "s|[ ]\?'d\>|---d|gI" |
    $SCR/tokenizer.perl -l en |
    $SCR/expand.sh |
    sed -e 's/\(.*\)/\L\1/g' |
    sed 's|\([0-9]\+\)-\([0-9]\+\)-\([0-9]\+\)|\1 \2 \3|g' | # years
    sed 's|\([0-9]\+\)-\([0-9]\+\)|\1 \2|g' |
    sed -e "s/\([0-9]\)-\([a-z]\)/\1 \2/g" |   # 25-N -> 25 N
    sed -e "s/\([a-z]\)-\([0-9]\)/\1 \2/g" |   # A-3 -> A 3
    python3 $SCR/numbers2words.py | # translit numbers
    sed -e 's/\([a-z]\),/\1 ,/g' |
    awk '{ret="";for(i=1;i<=NF;++i)if($i!~/^[[:punct:]]+$/)ret=ret" "$i;print ret}' | # remove words only composed by punct
    awk '{ret="";for(i=1;i<=NF;++i)if($i~/[^a-zñáàéèíìóòúùäëïöçü·Þßâãåæêîðôõøûýþžčšÿłń -]/)ret=ret" <unk>";else ret=ret" "$i;print ret}' | # map to <unk> words with non latin symbols
    sed "s|---|'|g" |
    sed "s|--\+| |g" |
    awk '{ret=$1;for(i=2;i<=NF;++i)ret=ret" "$i;print ret}'

deactivate
