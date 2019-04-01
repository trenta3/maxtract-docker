#!/bin/bash -e

BFILE=$1
FILEDIR=data
TEMPDIR=process

# ./extractElements.opt -u -f gaal.pdf -d /tmp/process
echo "Creating temporary directory"
mkdir /tmp/$TEMPDIR
echo "Uncompressing the file stream"
pdftk "$FILEDIR/$BFILE" output "/tmp/$TEMPDIR/$BFILE" uncompress
echo "Extracting elements"
LANG=/usr/lib/locale/en_US ./extractElements.opt -u -f "$BFILE" -d "/tmp/$TEMPDIR" # -u se è gia uncompresso
echo "Linearizing streams"
IFS=$'\n';
for file in $(find /tmp/$TEMPDIR -type f -iname "*.jsonf"); do
    ./linearizer.opt -f "$file";
done
echo "Computing LaTeX"
for file in $(find /tmp/$TEMPDIR -type f -iname "*.lin"); do
    ./anderson_post.opt --driver latex2 --layout latex --type LINES "$file";
done
find /tmp/$TEMPDIR -type f -iname "*.tex" -print | sort | xargs -n1 cat > "$FILEDIR/$BFILE.tex"
rm -rf /tmp/$TEMPDIR
echo "Everything went well. Your output is in $BFILE.tex"

