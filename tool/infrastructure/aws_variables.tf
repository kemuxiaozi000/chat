#####################################
# General Settings
#####################################

variable "access_key" {}
variable "secret_key" {}
variable "account_id" {}

variable "az1" {
  default = "ap-northeast-1a"
}

variable "az2" {
  default = "ap-northeast-1c"
}

variable "ec2_key_name" {}

#####################################
# VPC Settings
#####################################

variable "vpc_main_cidr" {
  default = "172.16.0.0/16"
}

variable "vpc_main_cidr_public1" {
  default = "172.16.1.0/24"
}

variable "vpc_main_cidr_public2" {
  default = "172.16.2.0/24"
}

variable "vpc_main_cidr_private1" {
  default = "172.16.21.0/24"
}

variable "vpc_main_cidr_private2" {
  default = "172.16.22.0/24"
}

variable "vpc_main_cidr_db1" {
  default = "172.16.11.0/24"
}

variable "vpc_main_cidr_db2" {
  default = "172.16.12.0/24"
}

#####################################
# Database Settings
#####################################

variable "db_cluster_instance_count" {}

variable "db_username" {}
variable "db_password" {}

variable "db_instance_type" {
  default = "db.t2.small"
}

#####################################
# Application Settings
#####################################

variable "environment" {}

variable "solution_stack_name" {
  default = "64bit Amazon Linux 2018.03 v2.10.0 running Docker 17.12.1-ce"
}

variable "rails_env" {
  default = "production"
}

variable "app_name" {}

variable "region" {}

variable "web_healthcheck_path" {
  default = "/robots.txt"
}

variable "secret_key_base" {}

variable "review_web_instance_type" {}
variable "staging_web_instance_type" {}

variable "loadbalancer_certificate_arn_review" {}
variable "loadbalancer_certificate_arn_staging" {}

variable "repair_case_path" {}

variable "diagnosis_path" {}

#####################################
# Network Settings
#####################################

variable "ip_whitelist" {
  default = [
    {
      # MM
      value = "211.18.249.212/32"

      type = "IPV4"
    },
    {
      # MM
      value = "211.18.249.211/32"

      type = "IPV4"
    },
    {
      # MM
      value = "210.169.191.218/32"

      type = "IPV4"
    },
    {
      # DN
      value = "60.32.117.171/32"

      type = "IPV4"
    },
    {
      # DN
      value = "60.32.117.172/32"

      type = "IPV4"
    },
    {
      # DN
      value = "114.179.29.68/32"

      type = "IPV4"
    },
    {
      # DN
      value = "114.179.29.67/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.24.80/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.24.82/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.24.107/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.24.119/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.1/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.2/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.3/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.4/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.5/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.6/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.7/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.8/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.9/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.10/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.11/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.12/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.9/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.37/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.38/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.45/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.46/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.47/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.48/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.49/32"

      type = "IPV4"
    },
    {
      # DN
      value = "133.192.188.50/32"

      type = "IPV4"
    },
    {
      # DN
      value = "203.129.123.19/32"

      type = "IPV4"
    },
    {
      # DN
      value = "203.129.123.20/32"

      type = "IPV4"
    },
    {
      # DN
      value = "210.227.116.164/32"

      type = "IPV4"
    },
    {
      # DN
      value = "210.227.116.163/32"

      type = "IPV4"
    },
    {
      # DN
      value = "218.216.187.218"

      type = "IPV4"
    },
    {
      # DN
      value = "218.216.187.219"

      type = "IPV4"
    },
    {
      # DN
      value = "219.121.148.66"

      type = "IPV4"
    },
    {
      # DN
      value = "219.121.148.67"

      type = "IPV4"
    },
    {
      # DICH
      value = "119.254.195.69/32"

      type = "IPV4"
    },
    {
      # ryuzee office
      value = "61.213.118.125/32"

      type = "IPV4"
    },
    {
      # JB office
      value = "122.220.222.136/32"

      type = "IPV4"
    },
    {
      # aws-dn-vpn
      value = "52.196.237.145/32"

      type = "IPV4"
    },
  ]
}

variable "ip_whitelist_for_sg" {
  default = [
    "211.18.249.212/32",  # MM
    "211.18.249.211/32",  # MM
    "210.169.191.218/32", # MM
    "60.32.117.171/32",   # DN
    "60.32.117.172/32",   # DN
    "114.179.29.67/32",   # DN
    "114.179.29.68/32",   # DN
    "133.192.24.80/32",   # DN
    "133.192.24.82/32",   # DN
    "133.192.24.107/32",  # DN
    "133.192.24.119/32",  # DN
    "133.192.188.1/32",   # DN
    "133.192.188.2/32",   # DN
    "133.192.188.3/32",   # DN
    "133.192.188.4/32",   # DN
    "133.192.188.5/32",   # DN
    "133.192.188.6/32",   # DN
    "133.192.188.7/32",   # DN
    "133.192.188.8/32",   # DN
    "133.192.188.9/32",   # DN
    "133.192.188.10/32",  # DN
    "133.192.188.11/32",  # DN
    "133.192.188.12/32",  # DN
    "133.192.188.37/32",  # DN
    "133.192.188.38/32",  # DN
    "133.192.188.45/32",  # DN
    "133.192.188.46/32",  # DN
    "133.192.188.47/32",  # DN
    "133.192.188.48/32",  # DN
    "133.192.188.49/32",  # DN
    "133.192.188.50/32",  # DN
    "203.129.123.19/32",  # DN
    "203.129.123.20/32",  # DN
    "210.227.116.164/32", # DN
    "210.227.116.163/32", # DN
    "119.254.195.69/32",  # DICH
    "61.213.118.125/32",  # ryuzee office
    "122.220.222.136/32", # JB office2
    "52.196.237.145/32",  # aws-dn-vpn
  ]
}

#####################################
# ElasticBeanstalk Application Settings
#####################################
variable "eb_environment_variables" {
  type = "list"

  default = [
    {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = "TZ"
      value     = "Asia/Shanghai"
    },
    {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = "RAILS_LOG_TO_STDOUT"
      value     = "1"
    },
    {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = "DB_PORT"
      value     = "3306"
    },
  ]
}
