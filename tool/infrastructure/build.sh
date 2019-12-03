#!/bin/bash
# Script used to provision infrastructures including AWS Elastic Beanstalk
#
# THIS IS A DEVELOPMENT PURPOSE SCRIPT AND SHOULD NOT BE USED IN PRODUCTION
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
# usage: ./build.sh

set -e
start=`date +%s`

# Filepath
current_directory=`pwd`

script_dir=$(cd $(dirname $0); pwd)
cd $script_dir

# Load Environment Variables
echo "Loading '.env' environment variables"
if [ -e .env ]; then
  for f in `cat .env`
  do
    export $f
  done
fi

if [ -z "${APPLICATION_NAME}" ]; then
  echo "APPLICATION_NAME was not provided, aborting deploy!"
  exit 1
fi

if [ -z "${ENVIRONMENT}" ]; then
  echo "ENVIRONMENT was not provided, aborting deploy!"
  exit 1
fi

if [ -z "${REGION}" ]; then
  echo "REGION was not provided, aborting deploy!"
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

if [ -z "${SECRET_KEY_BASE}" ]; then
  echo "SECRET_KEY_BASE was not provided, aborting deploy!"
  exit 1
fi

if [ -z "${LOADBALANCER_CERTIFICATE_ARN_REVIEW}" ]; then
  echo "LOADBALANCER_CERTIFICATE_ARN_REVIEW was not provided, aborting deploy!"
  exit 1
fi

if [ -z "${LOADBALANCER_CERTIFICATE_ARN_STAGING}" ]; then
  echo "LOADBALANCER_CERTIFICATE_ARN_STAGING was not provided, aborting deploy!"
  exit 1
fi

if [ -z "${REVIEW_WEB_INSTANCE_TYPE}" ]; then
  echo "REVIEW_WEB_INSTANCE_TYPE was not provided, aborting deploy!"
  exit 1
fi

if [ -z "${STAGING_WEB_INSTANCE_TYPE}" ]; then
  echo "STAGING_WEB_INSTANCE_TYPE was not provided, aborting deploy!"
  exit 1
fi

if [ -z "${REPAIR_CASE_PATH}" ]; then
  echo "v was not provided, aborting deploy!"
  exit 1
fi

if [ -z "${DIAGNOSIS_PATH}" ]; then
  echo "DIAGNOSIS_PATH was not provided, aborting deploy!"
  exit 1
fi

# Generate terraform.tfvars file
echo "Generate terraform.tfvars file from environment variables"
if [ "$(uname)" = 'Darwin' ]; then
  AWS_ACCOUNT_HASH=$(echo ${AWS_ACCOUNT_ID} | md5)
else
  AWS_ACCOUNT_HASH=$(echo ${AWS_ACCOUNT_ID} | md5sum | awk '{ print $1 }')
fi

# Replace the <VARIABLE> with your environement variables
cp terraform.tfvars.template terraform.tfvars
sed -i -e "s#<ACCESS_KEY>#${AWS_ACCESS_KEY_ID}#g" terraform.tfvars
sed -i -e "s#<SECRET_KEY>#${AWS_SECRET_ACCESS_KEY}#g" terraform.tfvars
sed -i -e "s#<ENVIRONMENT>#${ENVIRONMENT}#g" terraform.tfvars
sed -i -e "s#<APP_NAME>#${APPLICATION_NAME}#g" terraform.tfvars
sed -i -e "s#<AWS_ACCOUNT_ID>#${AWS_ACCOUNT_HASH}#g" terraform.tfvars
sed -i -e "s#<LOADBALANCER_CERTIFICATE_ARN_REVIEW>#${LOADBALANCER_CERTIFICATE_ARN_REVIEW}#g" terraform.tfvars
sed -i -e "s#<LOADBALANCER_CERTIFICATE_ARN_STAGING>#${LOADBALANCER_CERTIFICATE_ARN_STAGING}#g" terraform.tfvars
sed -i -e "s#<REGION>#${REGION}#g" terraform.tfvars
sed -i -e "s#<REVIEW_WEB_INSTANCE_TYPE>#${REVIEW_WEB_INSTANCE_TYPE}#g" terraform.tfvars
sed -i -e "s#<STAGING_WEB_INSTANCE_TYPE>#${STAGING_WEB_INSTANCE_TYPE}#g" terraform.tfvars
sed -i -e "s#<SECRET_KEY_BASE>#${SECRET_KEY_BASE}#g" terraform.tfvars
sed -i -e "s#<REPAIR_CASE_PATH>#${REPAIR_CASE_PATH}#g" terraform.tfvars
sed -i -e "s#<DIAGNOSIS_PATH>#${DIAGNOSIS_PATH}#g" terraform.tfvars

terraform init
# terraform apply -auto-approve .
terraform apply .

cd $current_directory
