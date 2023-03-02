export LC_ALL=C.UTF-8

in_file=$1

[ -z "$in_file" ] && echo "[EE] Input file is required" 2>&1 && exit 1;

cat $in_file | /home/jiranzo/trabajo/git/asr-scripts/lm/prepro/prepro_keep_lines.sh en
