#!/bin/bash
sudo yum update -y
sudo yum install -y python35-devel python35-libs python35-pip
sudo yum install -y mysql57-devel
sudo yum install -y ruby
sudo yum install -y wget
sudo yum groupinstall "Development Tools"
sudo echo "/usr/lib64/mysql57" >> /etc/ld.so.conf.d/mysql57-x86_64.conf
sudo /sbin/ldconfig
sudo mkdir -p /app/log
sudo chown -R ec2-user /app
sudo update-alternatives --set python /usr/bin/python3.5
cd /home/ec2-user
wget https://aws-codedeploy-ap-northeast-1.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
