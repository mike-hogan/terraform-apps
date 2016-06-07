#!/bin/sh

# This is just a sample build script.  Important thing: there is an installable package somewhere at the end of running it

app_name=sample-app
build_number=$1

tar cvf $app_name.tar src start.sh package.json

aws s3 cp $app_name.tar s3://mike-learning-jobsite/repo/$app_name/$build_number/$app_name.tar

