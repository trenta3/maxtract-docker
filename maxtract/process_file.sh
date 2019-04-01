#!/bin/bash -e

BFILE=$1
DRIVER=${2:-latex2}
LAYOUT=${3:-latex}
TYPE=${4:-LINES}
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
    ./anderson_post.opt --driver "$DRIVER" --layout "$LAYOUT" --type "$TYPE" -auto "$file";
done
echo "Removing unnecessary files"
find /tmp/$TEMPDIR -type f -iname "*.json" -delete
find /tmp/$TEMPDIR -type f -iname "*.jsonf" -delete
find /tmp/$TEMPDIR -type f -iname "*.bb" -delete
find /tmp/$TEMPDIR -type f -iname "*.lin" -delete
rm /tmp/$TEMPDIR/*.pdf /tmp/$TEMPDIR/*.tif
echo "Now outputting those files"
ls /tmp/$TEMPDIR/*
EXTENSION=$(ls -1 /tmp/$TEMPDIR/* | grep -oP "[0-9]+\.\K[a-zA-Z0-9]+" | head -n 1)
echo "Computed file extension: $EXTENSION"
ORIGBASENAME=$(basename "$BFILE" .pdf);
find /tmp/$TEMPDIR -type f -print | sort | xargs -n1 cat > "$FILEDIR/$ORIGBASENAME.$EXTENSION"
original_owner=$(ls -l "$FILEDIR/$BFILE" | cut -d' ' -f3,4 | sed -e 's/ /:/g')
chown "$original_owner" "$FILEDIR/$ORIGBASENAME.$EXTENSION"
chmod ug+rw "$FILEDIR/$ORIGBASENAME.$EXTENSION"
rm -rf /tmp/$TEMPDIR
echo "Everything went well. Your output is in $ORIGBASENAME.$EXTENSION"

