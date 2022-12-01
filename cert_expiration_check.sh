#!/bin/bash

# check opessl
which openssl
if [ $? != 0 ]; then
    echo "no openssl"
    exit 1
fi

#ssl_dir=/etc/kubernetes/ssl
ssl_dir=./sample_dir
expiration_threshold_seconds=3600

# check if the ssl files exists
ls $ssl_dir

#for key file
find $ssl_dir -type f -name \*.key | while read file; do
    if [ $? != 0 ]; then
        echo "can not find key file"
        exit 1
    fi
    cat $file | openssl rsa -noout -text
    if [ $? != 0 ]; then
        echo "can not read key file: $file"
        exit 1
    fi
done

# for request file
find $ssl_dir -type f -name \*.pem | while read file; do
    cat $file | openssl req -noout -text
    if [ $? != 0 ]; then
        echo "can not read request file: $file"
        exit 1
    fi
done

# for request file
find $ssl_dir -type f -name \*.csr | while read file; do
    cat $file | openssl req -noout -text
    if [ $? != 0 ]; then
        echo "can not read request file: $file"
        exit 1
    fi
done

# for cert file
find $ssl_dir -type f -name \*.crt | while read file; do
    cat $file | openssl x509 -text -enddate
    if [ $? != 0 ]; then
        echo "can not read cert file: $file"
        exit 1
    fi
    cat $file | openssl x509 -text -checkend $expiration_threshold_seconds
    if [ $? != 0 ]; then
        echo "cert will expire in $expiration_threshold_seconds seconds: $file"
        exit 1
    fi
done