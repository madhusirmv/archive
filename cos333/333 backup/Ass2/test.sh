#!/bin/bash


clear
for (( i=1; i <= 15; i++))
do

#big file
dd if=/dev/urandom of=random.txt bs=$RANDOM count=1000 2> /dev/null

./encode.py < random.txt > mencode.txt #my encoder
./decode.py < mencode.txt > mmdecode.txt #my encoder my decoder
cmp -l -b random.txt mmdecode.txt

openssl enc -e -base64 <random.txt > tencode.txt #their encoder
cmp -l -b mencode.txt tencode.txt

openssl enc -d -base64 < mencode.txt > mtdecode.txt #my encoder their decoder

cmp -l -b mtdecode.txt random.txt

./decode.py < tencode.txt > tmdecode.txt #their encoder my decoder
cmp -l -b tmdecode.txt random.txt


#med file
dd if=/dev/urandom of=random.txt bs=$RANDOM count=100 2> /dev/null

./encode.py < random.txt > mencode.txt #my encoder
./decode.py < mencode.txt > mmdecode.txt #my encoder my decoder
cmp -l -b random.txt mmdecode.txt

openssl enc -e -base64 <random.txt > tencode.txt #their encoder
cmp -l -b mencode.txt tencode.txt

openssl enc -d -base64 < mencode.txt > mtdecode.txt #my encoder their decoder

cmp -l -b mtdecode.txt random.txt

./decode.py < tencode.txt > tmdecode.txt #their encoder my decoder
cmp -l -b tmdecode.txt random.txt


#small file
dd if=/dev/urandom of=random.txt bs=$RANDOM count=10 2> /dev/null

./encode.py < random.txt > mencode.txt #my encoder
./decode.py < mencode.txt > mmdecode.txt #my encoder my decoder
cmp -l -b random.txt mmdecode.txt

openssl enc -e -base64 <random.txt > tencode.txt #their encoder
cmp -l -b mencode.txt tencode.txt

openssl enc -d -base64 < mencode.txt > mtdecode.txt #my encoder their decoder

cmp -l -b mtdecode.txt random.txt

./decode.py < tencode.txt > tmdecode.txt #their encoder my decoder
cmp -l -b tmdecode.txt random.txt


#tiny file
dd if=/dev/urandom of=random.txt bs=$RANDOM count=1 2> /dev/null

./encode.py < random.txt > mencode.txt #my encoder
./decode.py < mencode.txt > mmdecode.txt #my encoder my decoder
cmp -l -b random.txt mmdecode.txt

openssl enc -e -base64 <random.txt > tencode.txt #their encoder
cmp -l -b mencode.txt tencode.txt

openssl enc -d -base64 < mencode.txt > mtdecode.txt #my encoder their decoder

cmp -l -b mtdecode.txt random.txt

./decode.py < tencode.txt > tmdecode.txt #their encoder my decoder
cmp -l -b tmdecode.txt random.txt

done

