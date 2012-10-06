#!/bin/bash
# Cleanup, version 3

clear
while read line; do
./refgrep "$line" file.txt > a.txt
./regtest "$line" file.txt > b.txt
echo "******** regexp is $line *******"
diff a.txt b.txt 
rm a.txt
rm b.txt
done < reg.txt
