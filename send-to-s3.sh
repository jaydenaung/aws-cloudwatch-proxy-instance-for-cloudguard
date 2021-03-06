#!/bin/bash
# This script sends CloudGuard Logs from Check Point Management Server to CloudWatch proxy instance.
# Author: Jayden Kyaw Htet Aung - Check Point Software Technologies

#UPDATE THE FOLLOWING VARIABLES!
#SET YOUR SOURCE DIRECTORY FROM WHICH LOGS WILL BE SENT
source_dir="/opt/aws/amazon-cloudwatch-agent/logs/cme.log"

#YOUR S3 BUCKET NAME TO PIPE THE LOGS
dst_dir="s3://your-s3-bucket/uploads/cme.log"

echo send CloudGuard logs to CloudWatch Log Proxy Server: $dsthost

aws s3 cp $source_dir $dst_dir

echo Logs sent on `date`