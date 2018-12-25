#!/bin/bash
yum -y install httpd
service httpd start
chkconfig httpd on
cd /var/www/html
AVAILABILITY_ZONE=$(curl --silent http://169.254.169.254/latest/meta-data/placement/availability-zone/)

if [ "$AVAILABILITY_ZONE" == "eu-west-2a" ];
then
echo "This is AZ 2A"
aws s3 cp s3://my-app-testing-bucket/AZ2A.html /var/www/html/index.html
elif [ "$AVAILABILITY_ZONE" == "eu-west-2b" ];
then
echo "This is AZ 2B"
aws s3 cp s3://my-app-testing-bucket/AZ2B.html /var/www/html/index.html
elif [ "$AVAILABILITY_ZONE" == "eu-west-2c" ];
then
echo "This is AZ 2C"
aws s3 cp s3://my-app-testing-bucket/AZ2C.html /var/www/html/index.html
else
aws s3 cp s3://my-app-testing-bucket/index.html /var/www/html/index.html
fi
