#!/bin/bash 

# 2013. Jesus Andres Ferrer (jandres@dsic.upv.es)
#
# Change log:
# - 2013-06-17: initiallised from background (from tL perspective) scripts 
# - 2013-06-18: fixed problems erasing some punc marks
# - 2013-06-18: fixed problem for smt, GhesitationsG were not erased
# - 2013-06-20: added options: --erase-int-chars, --erase-parenthesis, --erase-brackets, --erase-curl
# - 2013-06-20: added options: --erase-punc-strict
# - 2013-06-21: fixed some characters for catalan, english and other languages

# ToDo List (as identified by Jesús Andrés Ferrer):
# - 2013-06-20: added options: --erase-int-chars should be improved to a transliterated version

USAGE="Usage: `basename $0` [options]   \n\n
\t\t--help|-h\t\t Print this help\n
\t\t--mail|-m\t\t mailme at the end of the script\n
\t\t--tokenizer\t<path_to_exec>\t where is the tokenizer\n
\t\t--norm-punct\t<path_to_exec>\t where is the puntuation normalizer\n
\t\t--corpus\t<path_to_file>\t the corpups to process\n
\t\t--out\t<path_to_dir>\t output directory\n
\t\t--name\t<filename>\t  the name of the processesed corpus in the output directory\n
\t\t--lowercase\t\t if provided lowercase the corpus\n
\t\t--tokenize\t\t if provided tokenize the input\n
\t\t--smt\t\t if provided preprocess for smt\n
\t\t--smt\t\t if provided preprocess for smt, but when the input comes from an ASR system\n
\t\t--voc\t\t if provided filters the input substituting OOV by <unk>\n
\t\t--en\t\t special preprocessing for English \n
\t\t--es\t\t special preprocessing for Spanish \n
\t\t--fr\t\t special preprocessing for French  \n
\t\t--ca\t\t special preprocessing for Val/Ca \n
\t\t--nl\t\t special preprocessing for Dutch \n
\t\t--pt\t\t special preprocessing for Portuguese \n
\t\t--it\t\t special preprocessing for Italian \n
\t\t--et\t\t special preprocessing for Estonian \n
\t\t--de\t\t special preprocessing for German \n
\t\t--translit-num\t\t transliterate numbers\n
\t\t--split-numwords\t\t split words like B22 into B 22\n
\t\t--join-accents\t\t joint english accents like I 'm into I'm\n
\t\t--recompose-accents\t\t recompose accents camio'n to camion\n
\t\t--erase-rept\t\t if provided erase repeated continous lines \n
\t\t--erase-punc\t\t if provided erase punctuation (isolated punct)\n
\t\t--erase-punc-strict\t\t if provided erase punctuation (both isolated and within words, this option can override --erase-int-chars)\n
\t\t--erase-loc-tags\t\t erases the locutor tags: \n
\t\t--erase-int-chars\t\t erases all word which do not contain spoken chars whithin a word, such as numbers, or punct marks (except for ')\n
\t\t--erase-parenthesis\t\t erases parenthesis which typically is a property of written text\n
\t\t--erase-empty-lines\t\t erases empty lines (not recommended for smt tasks)\n
\t\t--no-hesitation\t\t do not replace hesitation by [hesitation]\n"
#GMSG="Sub-creatures!\n GOZER the Gozerian, \n GOZER the Destructor, Volguus Zildrohar, the Traveller has come!\n Choose and perish!"
USAGE+="\t\t--erase-brackets\t\t erases brakets which typically is a property of written text\n
\t\t--erase-curly\t\t erases curly brackets which typically is a property of written text\n
\t\t--keep-comments\t\t text inside curly brackets or paranthesis or -, which typically is a property of written text, is not erased\n
"

PATH=$PATH:`dirname $0`
common="abcdefghijklmnopqrstuvwyxzABCDEFGHIJKLMNOPQRSTUVWYXZ"
accents="àÀáÁèÈéÉìÌíÍòÒóÓùÙúÚäÄëËïÏöÖüÜ"
accents_it="àÀáÁèÈéÉìíÍòÒóÓùÙúÚ"
accents_nl="áÁéÉíÍóÓúÚäÄëËïÏöÖüÜ"
accents_de="áÁéÉíÍóÓúÚäÄëËïÏöÖüÜ"
accents_pt="ãáàâêéíóôõúüÃÁÀÂÊÉÍÓÔÕÚÜ"
accents_et="ŠŽÕÄÖÜšžõäöü"
accents_fr="àÀâÂäÄéÉèÈêÊëËîÎïÏôÔöÖùÙûÛüÜÿŸæÆœŒ"
declare -A chars=( ["es"]="$common${accents}ñÑ" ["it"]="${common}${accents_it}'" ["en"]="'${common}-" ["ca"]="${common}${accents}çÇ'-·" ["fr"]="${common}${accents}${accents_fr}çÇ'-" ["pt"]="${common}${accents_pt}çÇ'-"  ["nl"]="${common}${accents_nl}ßÆæŒœ'" ["de"]="${common}${accents_de}ß-" ["et"]="${common}${accents_et}" ); 
MAIL=0;   smt="";  lowercase="";  erasePunct=""; tokenize="";
name=""; out=""; corpus=""; en=""; es=""; fr=""; lan="en"; nl=""; pt=""; it=""; de="";
eraseLocutorTags="";   transNum="";
eraseParenthesis=""; eraseBrackets=""; eraseCurly=""; eraseIntChars=""; erasePunctStrict=""; noHes=""; splNumWords="";
keepComments="";
tok=tokenizer.perl;
normPunc=normalize-punctuation.perl;

while [ "${1:0:1}" = "-" ]; do
    case $1 in
        --help|-h)    echo -e $USAGE; exit 0;; #
        --mail|-m)    MAIL=1; shift 1;; #
	--tokenizer)  tok=$2; shift 2;; #
	--norm-punct) normPunc=$2; shift 2;; #
	--corpus)     corpus=$2; shift 2;; #
	--out)        out=$2; shift 2;; #
	--name)       name=$2; shift 2;; #
	--lowercase)  lowercase="1"; shift 1;; #
	--tokenize)   tokenize="1";  shift 1;; #
	--erase-parenthesis) eraseParenthesis="1"; shift 1;;
	--erase-brackets) eraseBrackets="1"; shift 1;;
	--erase-curly) eraseCurly="1"; shift 1;;
	--erase-int-chars) eraseIntChars="1"; shift 1;;
	--keep-comments) keepComments="1"; shift 1;;
	--smt)         smt=1; eraseBrackets="1"; shift 1;;  #
	--asr-smt)     smt=2; shift 1;;  #
	--erase-rept) eraseRept=1; shift 1;;
	--erase-punc) erasePunct=1; shift 1;; #
	--erase-punc-strict) erasePunct=1; erasePunctStrict=1; shift 1;; #
	--voc)        voc=$2; shift 2;;       #
	--translit-num) transNum=1; shift 1;; #
	--join-accents) joinAccents=1; shift 1;;
	--recompose-accents) recompAccents=1; shift 1;;
	--erase-loc-tags) eraseLocutorTags=1; shift 1;; 
	--erase-empty-lines) noEmptyLines=1; shift 1;;
	--no-hesitation) noHes=1; shift 1;;
        --split-numwords) splNumWords=1; shift 1;;
	--en)         en=1; lan=en; shift 1;;
	--es)         es=1; lan=es; shift 1;;
	--fr)         fr=1; lan=fr; shift 1;;
	--ca)        ca=1; lan=ca; shift 1;;
	--nl)        nl=1; lan=nl; shift 1;;
	--et)        et=1; lan=et; shift 1;;
	--de)        de=1; lan=de; shift 1;;
        --pt)        pt=1; lan=pt; shift 1;;
        --it)        it=1; lan=it; shift 1;;
        *) 
            echo "`basename $0`: Unknown option $1." 1>&2;
            echo -e $USAGE 1>&2;
            exit 1;
            ;;
    esac;
done;

[ -z "$name" ] && name=${corpus##*/} && name=${name%.*}
[ -z "$corpus" ] && echo -e $USAGE 1>&2 && echo "[EE] --corpus is required " 2>&1 && exit 1;
[ -z "$out" ] && echo -e $USAGE 1>&2 && echo "[EE] --out is required " 2>&1 && exit 1;
[ ! -e "$corpus" ] && echo -e $USAGE 1>&2 && echo "[EE] The specified corpus: $corpus, does not exist." 2>&1 && exit 1;
[ ! -x "$tok" -a ! -x "`which $tok`" ] && echo -e $USAGE 1>&2 && echo "[EE] The specified tok: $tok, does not exist." 2>&1 && exit 1;
[ ! -x "$normPunc" -a ! -x "`which $normPunc`" ] && echo -e $USAGE 1>&2 && echo "[EE] The specified punctuation normalizer: $normPunc, does not exist." 2>&1 && exit 1;
[ ! -e "$out"    ] && mkdir -p "$out";
[  -z "$lan"     ] && echo -e $USAGE 1>&2  && echo "[EE] either --en or --es or --ca or --fr or --nl or --pt or --it or --et is required " 2>&1 && exit 1;
#
if [ "${name##*.}" == "gz" ]; then tmp=${name##*/}; oname=${tmp%.*}; else oname=$name; fi;

# Process the files 
suffix="asr"
if [ ! -z "$smt" ]; then 
    if [ "$smt" == "1" ]; then suffix="smt"; else suffix="asr-smt"; fi;
fi;
oname="$out"/"$name".$suffix


#echo oname: $oname  name: $name  out: $out
#echo lan: $lan tok: $tok

[ ! -e "$out" ] && mkdir "$out";

if [ ! -e "$oname".tok.gz ]; then
    wcat $corpus |
    sed -e 's+\xef\xbb\xbf++' | #delete BOM mark <feff>
    sed -e 's/&quote;/"/g'   -e 's/&amp;/\&/g' -e 's/&lt;/</g' -e 's/&gt;/>/g' |
    sed -e 's:\([[:punct:]]\)\(\[^]]*\):\1 \2:g' | # cope with the tokenization problems because of Gs
    sed -e 's:\(\[^]]*\)\([[:punct:]]\):\1 \2:g' | # cope with the tokenization problems because of Gs
    if [ -z "$keepComments" ]; then
	sed -e 's/--[^-]\+--/ /g' | sed -e 's/([^)]\+)/ /g' |
	if [ "$lan" != "fr" ] && [ "$lan" != "et" ]; then
	    sed -e 's/-[^-]\+-/ /g'
	else
	    cat -
	fi
    else
	cat -
    fi |
    if [ ! -z "$recompAccents" ]; then  
	sed -e 's/a´/á/g' -e 's/e´/é/g' -e 's/´ı/í/g' -e 's/o´/ó/g' -e 's/n˜/ñ/g' -e 's/u´/ú/g' -e 's|u¨|ü|g' \
	    -e 's/a´/á/g' -e 's/e´/é/g' -e 's/´ı/í/g' -e 's/o´/ó/g' -e 's/n˜/ñ/g' -e 's/u´/ú/g' -e 's|u¨|ü|g' \
	    -e 's/a'"'"'/á/g' -e 's/e'"'"'/é/g' -e 's/'"'"'ı/í/g' -e 's/o'"'"'/ó/g' -e 's/n˜/ñ/g' -e 's/u'"'"'/ú/g' -e 's|u¨|ü|g' ;
    else cat -; fi |
    if [ ! -z "$eraseLocutorTags" ]; then  sed -e 's/^\s*\w\+\s*://g' | sed -e 's/^\s*\([A-Z]\w*\s\+\)\{1,\}\([A-Z]\w*\)\s*://'; else cat -; fi |
    if [ ! -z "$smt" ]; then  # this is done in case of smt(=1) and asr-smt (=2)
        sed -e 's/\[HESITATION_\([^[:space:]]\{1,\}\)\]//gi'|
        sed -e 's/\[HESITATION\]//gi' |
        sed -e 's/\<HESITATION\>//gi' |
        sed -e 's/\<HESITATION_\([^[:space:]]\{1,\}\)\>//gi' | 
        sed -e 's/\<\(mmm\|uhm\|uh\|um\|eh\|oh\|hoo\|huh\|ah\|hey\)\>//gi' | 
	if [ "$lan" != "nl" ]; then  #er is there in dutch
            sed -e 's/\<\(er\)\>//gi'
	else
	    cat -
	fi |
	sed -e 's/\<\(breath\|cough\|noise\|smack\)\>//ig' | 
        sed -e 's/{\(mmm\|uhm\|uh\|um\|eh\|oh\|hoo\|huh\|ah\|hey\)}//gi'|
        if [ "$lan" != "nl" ]; then  
            sed -e 's/{\(er\)}//gi'
        else
            cat -
        fi |
	sed -e 's/{\(breath\|cough\|noise\|smack\)}//ig' ;  # Erase HESITATIONS 
    else 
	if [ -z "$noHes" ]; then
	    sed -e 's/{\(breath\|cough\|noise\|smack\)}/[HESITATION]/ig'| # HESITATIONS
            sed -e 's/{\(mmm\|uhm\|uh\|um\|eh\|oh\|hoo\|huh\|ah\|hey\)}/[HESITATION]/gi'|
            sed -e 's/\<\(mmm\|uhm\|uh\|um\|eh\|oh\|hoo\|huh\|ah\|hey\)\>/[HESITATION]/gi'|
            if [ "$lan" != "nl" ]; then 
		sed -e 's/{\(er\)}/[HESITATION]/gi' |
		sed -e 's/\<\(er\)\>/[HESITATION]/gi'
            else
		cat -
            fi |
            sed -e 's/\<HESITATION_\([^[:space:]]\{1,\}\)\>/HESITATION/gi' |
            sed -e 's/[^][:space:]]HESITATION_\([^[:space:]]\{1,\}\)[^][:space:]]/[HESITATION]/gi' | 
            sed -e 's/\[\(HESITATION\|SILENCE\)\]/G\1G/gi';
	else
	    cat -
	fi
    fi |
    if [ ! -z "$splNumWords" ]; then
      sed -e "s|\([[:alpha:]-]\+\)\([[:digit:]]\+\)|\1 \2|g" |
      sed -e "s|\([[:digit:]]\+\)\([[:alpha:]-]\+\)|\1 \2|g"; else cat -; fi |
    if [ ! -z "$eraseParenthesis" ]; then sed -e 's/([^)]*)/ /g'; else cat -; fi|
    if [ ! -z "$eraseBrackets" ]; then sed -e 's/\[[^]]*\]/ /g'; else cat -; fi|
    if [ ! -z "$eraseCurly" ]; then sed -e 's/{[^}]*}/ /g'; else cat -; fi|
    if [ "$lan" == "nl" ]; then  #translate some antique symbols to modern dutch
	sed -e 's+ß+ss+g' |
	sed -e 's+æ+ae+g' |
	sed -e 's+Æ+AE+g' |
	sed -e 's+œ+oe+g' |
	sed -e 's+Œ+OE+g' |
	sed -e 's+ſ+s+g'
    else
	cat -
    fi |
    if [ "$lan" == "de" ]; then  #translate some antique symbols to modern german
	sed -e 's+ß+ss+g' |
	sed -e 's+æ+ae+g' |
	sed -e 's+Æ+AE+g' |
	sed -e 's+œ+oe+g' |
	sed -e 's+Œ+OE+g' |
	sed -e 's+ſ+s+g'
    else
	cat -
    fi |
    sed -e 's/<br>/\n/ig' |
    sed -e 's/<[^>]>//ig' |
    sed -s 's/<\/s>//g' |
    $normPunc $lan |
    if [ ! -z "$tokenize" ]; then $tok -l $lan ; else  cat -;  fi |
    if [ ! -z "$eraseRept" ]; then
        gawk '{if ($0!=prev) print; prev=$0;}';
    else
        cat - ; 
    fi | 
    gzip - > "$oname".tok.gz
else
    echo -e "\t\t $oname.tok.gz exist, skipping ";
fi;


if [ ! -e "$oname".clean.gz ]; then
    wcat "$oname".tok.gz | 
    sed -e 's/&amp;/ and /g' -e "s/&apos;/'/g" |
    sed -e 's/&\w\+;/ /gi' |
    sed -e 's/\s'"'"'\s\(\w\+\)/ '"'"'\1/g' |
    if [ "$lan" == "en" ]; then
        gawk 'BEGIN{h["s"]=h["ll"]=h["re"]=h["d"]=h["ve"]=h["m"]=h["t"]=1;} 
            { for (i=1;i<NF;++i)
                { 
                    if ( ($i=="'"'"'")   && ( h[$(i+1)]==1 ) ) 
                        {$i=$i""$(i+1);$(i+1)="";}
                } 
                if($NF=="'"'"'")  $NF=""; 
                    print $0;
                }' |  sed -e 's/\s\+'"'"'\s\+/ /g';
    else 
        sed -e 's/\s\(\w\+\)'"'"'\s/ \1'"'"'/g' ;
    fi |
    if [ ! -z "$voc" ]; then
	TMP=$(mktemp `basename $0`.$$.XXXX );
	trap "\rm -f $TMP " EXIT;
	wcat $voc > $TMP;
	echo "[HESITATION]" >>$TMP
	filter-corpora-by-voc.sh --voc $TMP  
    else 	    cat -; 	fi |
    if [ ! -z "$transNum" ]; then
	if [ -x "`which translit_$lan.py`" ]; then 
	    translit_$lan.py 
	else	cat -;	    fi;
    else    cat -;	fi |
    if [ ! -z "$lowercase" ]; then  gawk '{print tolower($0);}'; else cat -; fi |
    if [ ! -z "$erasePunctStrict" ]; then 
        #sed -e 's/[^'"${chars[$lan]}"'[:blank:]]/ /g';
	sed -e 's/[^[:blank:]]'"${chars[$lan]}"'/ /g';
    else
        cat -;
    fi | 
    if [ -z "$smt" -o "$smt" == "2" ]; then  
	if [ ! -z "$eraseIntChars" ]; then
            sed -e 's/\(^\|\s*\)\s*\(['"${chars[$lan]}"']*[^[:blank:]'"${chars[$lan]}"']['"${chars[$lan]}"']*\)\+\s*\($\|\s\+\)/ /g'|
            sed -e 's/\(^\|\s\+\)\s*[^[:blank:]'"${chars[$lan]}"']\+\(['"${chars[$lan]}"']\+\)\+\s*\($\|\s*\)/ \2 /g'|
            sed -e 's/\(^\|\s*\)\s*\(['"${chars[$lan]}"']\+\)[^[:blank:]'"${chars[$lan]}"']\+\s*\($\|\s\+\)/ \2 /g' |  
            sed -e 's/--\+/ /g' | 
            sed -e 's/\(\s\+\|^\)\(['"${chars[$lan]}"']\+\)-\+\(\s\+\|$\)/ \2 /g' |
            sed -e 's/\(\s\+\|^\)-\+\(['"${chars[$lan]}"']\+\)\(\s\+\|$\)/ \2 /g';
	    cat -
	else # do not erase cho.mo.wor or h2o words, then erase the symbols
	    sed -e 's/[^[:blank:]'"${chars[$lan]}"']/ /g';
	fi;
    else cat -; fi | 
    if [ ! -z "$erasePunct" ]; then 
	sed -e 's/--\+/ /g' |
	sed -e 's/\(\s\+\|^\)\s*[^]'"'"'0-9a-zA-ZàÀáÁèÈéÉìíÍòÒóÓùÙúÚäÄëËïÏöÖüÜñÑ[{}]\+\s*\(\s\+\|$\)/ /g' |
	sed -e 's/\(\s\+\|^\)\s*[^]'"'"'0-9a-zA-ZàÀáÁèÈéÉìíÍòÒóÓùÙúÚäÄëËïÏöÖüÜñÑ[{}]\+/ /g' |
	sed -e 's/[^]'"'"'0-9a-zA-ZàÀáÁèÈéÉìíÍòÒóÓùÙúÚäÄëËïÏöÖüÜñÑ[{}]\+\s*\(\s\+\|$\)/ /g';
    else cat -; fi | 
         # if [ ! -z "$joinAccents" -a "$lan" == "en" -a -z "$smt" ]; then    joinEnglishAccentsASR.py; else cat -; fi |
    if [ ! -z "$joinAccents" -a "$lan" == "en" -a -z "$smt" ]; then  
        sed -e 's/ghesitationg-[^[:space:]]\+/ghesitationg /ig' |
        sed -e 's/ghesitationg-[^[:space:]]\+/ghesitationg /ig' |
        sed -e 's/ghesitationg\s*\('"'[${chars[$lan]}"']\+\)/ \1 /ig' |
        sed -e 's/\s*\('"'[${chars[$lan]}"']*\)ghesitationg/ \1 /ig'  |
        02-preprocess-join-english-tilde.py;
    else cat -; fi | 
    if [ ! -z "$joinAccents" -a "$lan" == "nl" -a -z "$smt" ]; then  
        sed -e 's/ghesitationg-[^[:space:]]\+/ghesitationg /ig' |
        sed -e 's/ghesitationg-[^[:space:]]\+/ghesitationg /ig' |
        sed -e 's/ghesitationg\s*\('"'[${chars[$lan]}"']\+\)/ \1 /ig' |
        sed -e 's/\s*\('"'[${chars[$lan]}"']*\)ghesitationg/ \1 /ig'  |
        sed -e "s/\s*'/'/g";	
    else cat -; fi |
    if [ ! -z "$joinAccents" -a "$lan" == "fr" -a -z "$smt" ]; then  
        sed -e 's/ghesitationg-[^[:space:]]\+/ghesitationg /ig' |
        sed -e 's/ghesitationg-[^[:space:]]\+/ghesitationg /ig' |
        sed -e 's/ghesitationg\s*\('"'[${chars[$lan]}"']\+\)/ \1 /ig' |
        sed -e 's/\s*\('"'[${chars[$lan]}"']*\)ghesitationg/ \1 /ig'  |
	sed -e "s/'\s*/'/g" |
        sed -e "s/\s*'/'/g";	
    else cat -; fi |
#   grep -v "^\W*$" | tee intermediate2 |
#   grep -v -E "^[[:space:][:digit:].]*$" | tee intermediate3 |
    if [ -z "$smt" ]; then sed -e 's/ghesitationg/[HESITATION]/gi'; else  sed -e 's/ghesitationg//gi'; fi |
    if [ ! -z "$noEmptyLines" ]; then sed '/^\s*$/d'; else cat -; fi |
    if [ "$lan" != "en" ]; then sed -e 's/\[HESITATION\]/[hesitation]/gi'; else cat -; fi |
    gzip - > "$oname".clean.gz
else
    echo -e "\t\t $oname.clean.gz exist, skipping ";
fi;

if [ ! -z "$MAIL" -a "$MAIL" -ge "1" ]; then 
    mailme.sh "`basename $0` "  " preprocessed corpora $corpus into $oname.clean.gz ";
fi;
