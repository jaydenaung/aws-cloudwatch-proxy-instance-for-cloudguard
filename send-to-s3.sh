#!/bin/bash
# This script sends CloudGuard Logs from Management Server to CloudWatch Log proxy server.

#UPDATE THE FOLLOWING VARIABLES!
source_dir="/var/log/CPcme/cme.log"
dst_dir="s3://chkp-jayden-shiftleft-scan-artifacts/uploads/cme.log"

echo send CloudGuard logs to CloudWatch Log Proxy Server: $dsthost

aws s3 cp $source_dir $dst_dir

echo Logs sent on `date`