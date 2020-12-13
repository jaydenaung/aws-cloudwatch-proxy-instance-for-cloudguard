#!/bin/bash
# FILE TO UPLOAD
#Update the source log file name
source_file="/var/log/CPcme/cme.log"
bucket="my-destination-bucket"
destination_path="/${bucket}/${source_file}"

# metadata
contentType="application/x-compressed-tar"
dateValue=`date -R`
signature_string="PUT\n\n${contentType}\n${dateValue}\n${destination_path}"

#AWS Keys 
#[WARNING] HARDCODING CREDENTIALS IS NOT SECURE, AND ONLY MEANT FOR DEVELOPMENT PURPOSES.
# USE AWS ROLES WHENEVER POSSIBLE. (JAYDEN)
aws_access_key="AWS ACCESS KEY"
aws_secret_key="SECRET"

#Signature (hash) for Authorization header
signature_hash=`echo -en ${signature_string} | openssl sha1 -hmac ${aws_secret_key} -binary | base64`

echo Uploading files to S3 bucket on `date`

curl -X PUT -T "${source_file}" \
  -H "Host: ${bucket}.s3-ap-southeast-1.amazonaws.com" \
  -H "Date: ${dateValue}" \
  -H "Content-Type: ${contentType}" \
  -H "Authorization: AWS ${aws_access_key}:${signature_hash}" \
  https://${bucket}.s3-ap-southeast-1.amazonaws.com/${source_file}

  echo Files successfully uploaded on 'date'