#!/bin/sh

mkdir /data
cd /data

aws s3 cp s3://mike-learning-jobsite/repo/sample-app/4/sample-app.tar sample-app.tar
tar xvf sample-app.tar

sudo curl --silent --location https://rpm.nodesource.com/setup_6.x | sudo bash -
sudo yum -y install nodejs

./start.sh