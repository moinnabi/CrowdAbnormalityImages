#!/bin/bash
[ $# = 0 ] && { prog=`basename "$0"`;
echo >&2 "usage: $prog query count parallel safe opts timeout tries agent1 agent2
e.g. : $prog ostrich
       $prog nipl 100 20 on isz:l,itp:clipart 5 10"; exit 2; }
query=$1 count=${2:-20} parallel=${3:-10} safe=$4 opts=$5 timeout=${6:-10} tries=${7:-2}
agent1=${8:-Mozilla/5.0} agent2=${9:-Googlebot-Image/1.0}
query_esc=`perl -e 'use URI::Escape; print uri_escape($ARGV[0]);' "$query"`
dir=`echo "$query_esc" | sed 's/%20/-/g'`-`date +%s`; mkdir "$dir" || exit 2; cd "$dir"
url="http://www.google.com/search?tbm=isch&safe=$safe&tbs=$opts&q=$query_esc" procs=0
echo >.URL "$url" ; for A; do echo >>.args "$A"; done
htmlsplit() { tr '\n\r \t' ' ' | sed 's/</\n</g; s/>/>\n/g; s/\n *\n/\n/g; s/^ *\n//; s/ $//;'; }
for start in `seq 0 20 $[$count-1]`; do
wget -U"$agent1" -T"$timeout" --tries="$tries" -O- "$url&start=$start" | htmlsplit
done | perl -ne 'use HTML::Entities; /^<a .*?href="(.*?)"/ and print decode_entities($1), "\n";' | grep '/imgres?' |
perl -ne 'use URI::Escape; ($img, $ref) = map { uri_unescape($_) } /imgurl=(.*?)&imgrefurl=(.*?)&/;
$ext = $img; for ($ext) { s,.*[/.],,; s/[^a-z0-9].*//i; $_ ||= "img"; }
$save = sprintf("%04d.$ext", ++$i); print join("\t", $save, $img, $ref), "\n";' |
tee -a .images.tsv |
while IFS=$'\t' read -r save img ref; do
wget -U"$agent2" -T"$timeout" --tries="$tries" --referer="$ref" -O "$save" "$img" || rm "$save" &
procs=$[$procs + 1]; [ $procs = $parallel ] && { wait; procs=0; }
done ; wait

