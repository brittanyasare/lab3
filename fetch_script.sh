#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 <URL>"
	exit 1
fi

URL=$1
FILENAME=$(basename "$URL")
DIRNAME="${FILENAME%.tar.gz}"


wget "$URL" -O "$FILENAME"


if [ ! -f "$FILENAME" ]; then
    echo "Error: File download failed."
    exit 1
fi

mkdir -p "$DIRNAME"
tar -xzvf "$FILENAME" -C "$DIRNAME"

for file in "$DIRNAME"/*.tsv; do
    [ -e "$file" ] || continue
    csv_file="${file%.tsv}.csv"
    awk -F'\t' 'BEGIN {OFS=","} {print $0}' "$file" > "$csv_file"
    echo "Converted $file to $csv_file"
done

echo "Process completed."
