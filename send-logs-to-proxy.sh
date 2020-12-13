#!/bin/bash
# This script sends CloudGuard Logs from Check Point Management Server to CloudWatch proxy instance.
# Author: Jayden Kyaw Htet Aung - Check Point Software Technologies

#UPDATE THE FOLLOWING VARIABLES!
sshkey_dir="ssh_keys/mgmt_ssh_key.prv"

#SOURCE DIRECTORY
source_dir="/var/log/CPcme/cme.log"

#USER NAME ON CLOUDWATCH PROXY INSTANCE 
dst_user="not-root"

#CLOUDWATCH PROXY INSTANCE'S IP OR HOSTNAME 
dsthost="10.5.0.8"

#DESTINATION DIRECTORY ON THE CLOUDWATCH PROXY INSTNANCE
dst_dir="/opt/aws/amazon-cloudwatch-agent/logs"

echo send CloudGuard logs to CloudWatch Log Proxy Server: $dsthost

scp -i $sshkey_dir -r $source_dir $dst_user@$dsthost:/$dst_dir

echo Logs sent on `date`