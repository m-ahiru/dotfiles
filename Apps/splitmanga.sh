#!/usr/bin/env bash
infile="$1"
outprefix="$2"
pages_per_split=200

mkdir tmp
unzip "$infile" -d tmp/

i=1
part=1
for img in $(ls tmp | sort); do
    mkdir -p part$part
    mv "tmp/$img" part$part/
    if (( i % pages_per_split == 0 )); then
        zip -r "${outprefix}_part${part}.cbz" part$part/
        rm -r part$part
        ((part++))
    fi
    ((i++))
done

# letzter Rest
if [ -d "part$part" ]; then
    zip -r "${outprefix}_part${part}.cbz" part$part/
    rm -r part$part
fi

rm -r tmp

