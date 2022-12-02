#!/bin/bash

#ssl_dir=/etc/kubernetes/ssl
ssl_dir=./sample_dir
expiration_threshold_seconds=2592000 # 30days

#for key file
find $ssl_dir -type f -name \*.key | while read file; do
    if [ $? != 0 ]; then
        echo "can not find key file"
        exit 1
    fi
    cat $file | openssl rsa -noout
    if [ $? != 0 ]; then
        echo "can not read key file: $file"
        exit 1
    fi
done

# for request file
find $ssl_dir -type f -name \*.pem | while read file; do
    cat $file | openssl req -noout
    if [ $? != 0 ]; then
        echo "can not read request file: $file"
        exit 1
    fi
done

# for request file
find $ssl_dir -type f -name \*.csr | while read file; do
    cat $file | openssl req -noout
    if [ $? != 0 ]; then
        echo "can not read request file: $file"
        exit 1
    fi
done

# for cert file
find $ssl_dir -type f -name \*.crt | while read file; do
    expiration_date=$(cat $file | openssl x509 -dates -noout)
    if [ $? != 0 ]; then
        echo "can not read cert file: $file"
        exit 1
    fi
    cat $file | openssl x509 -checkend $expiration_threshold_seconds
    if [ $? != 0 ]; then
        echo "file : $file"
        echo "$expiration_date"
        exit 1
    fi
done