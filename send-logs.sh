#!/bin/bash
# This script sends CloudGuard Logs from Management Server to CloudWatch Log proxy server.

#UPDATE THE FOLLOWING VARIABLES!
sshkey_dir="ssh_keys/mgmt_ssh_key.prv"
source_dir="/var/log/CPcme/cme.log"
dst_user="root"
dsthost="10.5.0.8"
dst_dir="/opt/aws/amazon-cloudwatch-agent/logs"

echo send CloudGuard logs to CloudWatch Log Proxy Server: $dsthost

scp -i $sshkey_dir -r $source_dir $dst_user@$dsthost:/$dst_dir

echo Logs sent on `date`