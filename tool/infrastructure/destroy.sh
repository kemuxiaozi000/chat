#!/bin/bash
# Script used to cleanup and destroy applications on AWS Elastic Beanstalk and terraform infrastructure
#
# THIS IS A DEVELOPMENT PURPOSE SCRIPT AND SHOULD NOT BE USED IN PRODUCTION
#
# Does three things:
# 1. Empties S3 buckets
# 2. Deletes deployed Beanstalk application
# 3. Runs `terraform destroy` command
#
# REQUIREMENTS!
# - APPLICATION_NAME env variable
# - AWS_ACCOUNT_ID env variable
# - AWS_ACCESS_KEY_ID env variable
# - AWS_SECRET_ACCESS_KEY env variable
# - APPLICATION_NAME env variable
# - ENVIRONMENT env variable
# - REGION env variable
#
# usage: ./destroy.sh

set -e
start=`date +%s`

# Filepath
current_directory=`pwd`

script_dir=$(cd $(dirname $0); pwd)
cd $script_dir

echo "Load Environmental Variables for Overwrite"
if [ -e .env ]; then
  for f in `cat .env`
  do
    export $f
  done
fi

if [ -z "${APPLICATION_NAME}" ]; then
  echo "Application APPLICATION_NAME was not provided, aborting deploy!"
  exit 1
fi

if [ -z "${REGION}" ]; then
  echo "Application REGION was not provided, aborting deploy!"
  exit 1
fi

if [ -z "${AWS_ACCOUNT_ID}" ]; then
  echo "AWS_ACCOUNT_ID was not provided, aborting deploy!"
  exit 1
fi

if [ -z "${AWS_ACCESS_KEY_ID}" ]; then
  echo "AWS_ACCESS_KEY_ID was not provided, aborting deploy!"
  exit 1
fi

if [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then
  echo "AWS_SECRET_ACCESS_KEY was not provided, aborting deploy!"
  exit 1
fi

if [ -z "${ENVIRONMENT}" ]; then
  echo "ENVIRONMENT was not provided, aborting deploy!"
  exit 1
fi

if [ "$(uname)" = 'Darwin' ]; then
  AWS_ACCOUNT_HASH=$(echo ${AWS_ACCOUNT_ID} | md5)
else
  AWS_ACCOUNT_HASH=$(echo ${AWS_ACCOUNT_ID} | md5sum | awk '{ print $1 }')
fi

echo Destroy ${APPLICATION_NAME}, region: ${REGION}

aws configure set default.region ${REGION}
aws configure set default.output json

echo "Remove the deployed application"
aws elasticbeanstalk delete-application --application-name ${APPLICATION_NAME} --terminate-env-by-force

echo "Empty S3 buckets"
EB_BUCKET=${APPLICATION_NAME}-app-deployments-review-${AWS_ACCOUNT_HASH}
aws s3 rm s3://${EB_BUCKET:0:63} --recursive || echo "Bucket does not exist, skipping."
EB_BUCKET=${APPLICATION_NAME}-app-deployments-staging-${AWS_ACCOUNT_HASH}
aws s3 rm s3://${EB_BUCKET:0:63} --recursive || echo "Bucket does not exist, skipping."

echo "Destroy the environment"
# init
terraform init

# terraform destroy -auto-approve .
terraform destroy .

end=`date +%s`
echo Destroyed with success! Time elapsed: $((end-start)) seconds

cd $current_directory
