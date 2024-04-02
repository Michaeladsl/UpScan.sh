#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <scope_file>"
    exit 1
fi

SCOPE_FILE="$1"

if [ ! -f "$SCOPE_FILE" ]; then
    echo "Error: File '$SCOPE_FILE' not found!"
    exit 1
fi

UP_SCOPE_FILE="upscope.txt"
> "$UP_SCOPE_FILE"

TMP_FILE=$(mktemp)
trap 'rm -f "$TMP_FILE"' EXIT

TOTAL_UP_HOSTS=0

while IFS= read -r line; do
    if [[ -z "$line" || $line == \#* ]]; then
        continue
    fi

    nmap -sn -n "$line" > "$TMP_FILE"
    grep "Nmap scan report for" "$TMP_FILE" | awk '{print $5}' >> "$UP_SCOPE_FILE"
    TOTAL_UP_HOSTS=$((TOTAL_UP_HOSTS + $(grep "Nmap scan report for" "$TMP_FILE" | wc -l)))
done < "$SCOPE_FILE"

if [ "$TOTAL_UP_HOSTS" -gt 0 ]; then
    echo -e "\033[31mTotal hosts up: $TOTAL_UP_HOSTS\033[0m"
    echo "Up hosts saved to $UP_SCOPE_FILE"
else
    echo "No hosts were found to be up."
    rm -f "$UP_SCOPE_FILE"
fi
