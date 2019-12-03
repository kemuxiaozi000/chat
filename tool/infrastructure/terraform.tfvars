# AWS general settings
access_key = "AKIAIW5EWAZZRFNFRPLA"
secret_key = "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"
account_id = "e981e5ef521835d71bbdaa7fe4c6c5b3"
ec2_key_name = "dn-dev"

# Infra stack settings
region = "ap-northeast-1"
az1 = "ap-northeast-1a"
az2 = "ap-northeast-1c"
db_cluster_instance_count = 1
db_username = "admin"
db_password = "PasswordMustBeFrom8To41Characters!"
db_instance_type = "db.t2.small"
environment = "review"

review_web_instance_type = "t2.large"
staging_web_instance_type = "t2.large"

# Application settings
app_name = "lupin"
rails_env = "development"
repair_case_path = "repair_case"
diagnosis_path = "diagnosis"

# Certificate Arn
loadbalancer_certificate_arn_review = "arn:aws:acm:ap-northeast-1:527706441645:certificate/e2c5544c-7267-4743-8c74-8cb03d4fe91b"
loadbalancer_certificate_arn_staging = "arn:aws:acm:ap-northeast-1:527706441645:certificate/e2c5544c-7267-4743-8c74-8cb03d4fe91b"

secret_key_base = "bZt0ppotff1Vft5hcOa+mQA+uZrVeYv+/8vrkSld"

