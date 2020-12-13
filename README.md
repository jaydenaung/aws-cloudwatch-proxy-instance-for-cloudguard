# AWS CloudWatch Log proxy EC2 instance for CloudGuard

This tutorial shows how to pipe system logs from Check Point CloudGuard Management server to AWS CloudWatch or AWS S3 bucket via a CloudWatch log server acting as a proxy. One example use case is if you want to pipe CloudGuard's cloud management extension logs (cme.log) to AWS CloudWatch for either log aggregation, troubleshooting or analysis purpose.

In this lab, we will, firstly, pipe CloudGuard logs (from Management Server) to another EC2 instance with CloudWatch agent installed - Let's call it CloudWatch proxy instance since we are using it as a proxy. You can use multiple ways to pipe logs to the instance. For example, you can use [Check Point Log Exporter](https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk122323), and use syslog to transfer to logs to an instance where rsyslog is installed. In this lab, however, we will just be using  SCP file transfer to simplicity's sake.
 
Secondly, we will then forward the logs from the CloudWatch proxy instance to other destinations such as AWS CloudWatch Log Group or S3 bucket.

In this lab, we will demonstrate piping CloudGuard Cloud Management Extension logs - ```cme.log``` from Management Server to CloudWatch Logs Group **and** S3 Bucket. 

## 1. Launch an EC2 Instance 

Firstly, we need to deploy an EC2 instance to act as "proxy" server. Le The server can be any linux server. In our lab, we will be using "AWS Linux". 

Please see [how to launch an EC2 instance.](https://docs.aws.amazon.com/quickstarts/latest/vmlaunch/step-1-launch-instance.html)

You should also set up the instance's networking so that it can communicate with the CloudGuard management server. By default, if it is deployed into a same VPC as Management Server, it can communicate with the management server. We'll also need to make sure that Security Groups of both Management Server and CloudWatch proxy instance allow SSH traffic to and from each other. 

## 2.  Download the CloudWatch Log agent

Secondly, download the CloudWatch Log agent and configure the CloudWatch Agent.

```bash 
sudo yum install amazon-cloudwatch-agent

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:cloudwatch-config.cfg -s 
```


## 3. CloudGuard Management Server

On CloudGuard Management server, 

### Create SSH Keys

```bash
ssh-keygen -t rsa
```
This key will be used when communicating with CloudWatch Log proxy server via SSH/SCP.


Make sure that the public key is stored on the CloudWatch Log proxy server under a user's directory ``` ./ssh/authorized_keys ```.



### Create SCP script

On the CloudGuard Management server, we will need to create a script to send CME logs

```bash
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

```

Create the script and store it at, for example, 
***/home/admin/cloudwatch/send-logs.sh*** 

Make it executable:

```bash
chomd +x /home/admin/cloudwatch/send-logs.sh
```

### CronTab

We'll need to create a cron job to send logs 

```bash
*/5 * * * * /home/admin/cloudwatch/send-logs.sh 
```


### cloudwatch-agent-config.cfg 

You will need to edit ```cloudwatch-agent-config.cfg```, and  

## 4. 