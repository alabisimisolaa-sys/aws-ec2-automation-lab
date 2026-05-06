   ,     #_
   ~\_  ####_        Amazon Linux 2023
  ~~  \_#####\
  ~~     \###|
  ~~       \#/ ___   https://aws.amazon.com/linux/amazon-linux-2023
   ~~       V~' '->
    ~~~         /
      ~~._.   _/
         _/ _/
       _/m/'
[ec2-user@ip-10-0-0-78 ~]$ # Set the Region
AZ=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
export AWS_DEFAULT_REGION=${AZ::-1}

# Retrieve latest Linux AMI
AMI=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text)
echo "Your AMI ID is: $AMI"
-bash: -1: substring expression < 0
Your AMI ID is: ami-0f4e1ea09e6b8e18a
[ec2-user@ip-10-0-0-78 ~]$ SUBNET=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=Public Subnet' --query Subnets[].SubnetId --output text)
echo "Your Subnet ID is: $SUBNET"
Your Subnet ID is: subnet-0637825cdd2e77cf0
[ec2-user@ip-10-0-0-78 ~]$ SG=$(aws ec2 describe-security-groups --filters Name=group-name,Values=WebSecurityGroup --query SecurityGroups[].GroupId --output text)
echo "Your Security Group ID is: $SG"
Your Security Group ID is: sg-096a4f8846a5364eb
[ec2-user@ip-10-0-0-78 ~]$ # Download the script
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-RSJAWS-1-23732/171-lab-JAWS-create-ec2/s3/UserData.txt

# Read the script to see what it does
cat UserData.txt
--2026-05-06 19:11:45--  https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-RSJAWS-1-23732/171-lab-JAWS-create-ec2/s3/UserData.txt
Resolving aws-tc-largeobjects.s3.us-west-2.amazonaws.com (aws-tc-largeobjects.s3.us-west-2.amazonaws.com)... 52.92.229.58, 52.92.237.58, 3.5.78.156, ...
Connecting to aws-tc-largeobjects.s3.us-west-2.amazonaws.com (aws-tc-largeobjects.s3.us-west-2.amazonaws.com)|52.92.229.58|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 327 [text/plain]
Saving to: ‘UserData.txt’

UserData.txt                         100%[======================================================================>]     327  --.-KB/s    in 0s      

2026-05-06 19:11:45 (12.0 MB/s) - ‘UserData.txt’ saved [327/327]

#!/bin/bash
# Install Apache Web Server
yum install -y httpd

# Turn on web server
systemctl enable httpd.service
systemctl start  httpd.service

# Download App files
wget https://aws-tc-largeobjects.s3.amazonaws.com/CUR-TF-100-RESTRT-1/171-lab-%5BJAWS%5D-create-ec2/dashboard-app.zip
unzip dashboard-app.zip -d /var/www/html/
[ec2-user@ip-10-0-0-78 ~]$ INSTANCE=$(\
  aws ec2 run-instances \
  --image-id $AMI \
  --subnet-id $SUBNET \
  --security-group-ids $SG \
  --user-data file:///home/ec2-user/UserData.txt \
  --instance-type t3.micro \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Web Server}]' \
  --query 'Instances[*].InstanceId' \
  --output text \
)
echo "Your new Web Server Instance ID is: $INSTANCE"
Your new Web Server Instance ID is: i-0d1bec2c5c9741c81
[ec2-user@ip-10-0-0-78 ~]$ aws ec2 describe-instances --instance-ids $INSTANCE --query 'Reservations[].Instances[].State.Name' --output text
running
[ec2-user@ip-10-0-0-78 ~]$ aws ec2 describe-instances --instance-ids $INSTANCE --query Reservations[].Instances[].PublicDnsName --output text
ec2-44-243-118-238.us-west-2.compute.amazonaws.com
[ec2-user@ip-10-0-0-78 ~]$ ^C
[ec2-user@ip-10-0-0-78 ~]$ ^C
[ec2-user@ip-10-0-0-78 ~]$ aws ec2 describe-instances --instance-ids $INSTANCE --query Reservations[].Instances[].PublicDnsName --output text
ec2-44-243-118-238.us-west-2.compute.amazonaws.com
[ec2-user@ip-10-0-0-78 ~]$ 
