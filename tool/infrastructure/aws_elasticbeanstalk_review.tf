#####################################
# ElasticBeanstalk Settings
#####################################
# S3 Bucket for storing Elastic Beanstalk task definitions

locals {
  review_environment         = "review"
  review_rails_env           = "production"
  review_eb_bucket_name_full = "${format("%s-app-deployments-%s-%s", var.app_name, local.review_environment, var.account_id)}"
  review_eb_bucket_name      = "${substr(local.review_eb_bucket_name_full, 0 , min(63, length(local.review_eb_bucket_name_full)))}"
}

resource "aws_s3_bucket" "aws_eb_s3" {
  bucket = "${local.review_eb_bucket_name}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

#####################################
# ElasticBeanstalk Web Application
#####################################

resource "aws_elastic_beanstalk_application" "aws_eb_lupin_app" {
  name        = "${var.app_name}"
  description = "${var.app_name} of beanstalk deployment"
}

resource "aws_elastic_beanstalk_environment" "aws_eb_lupin_app_env" {
  name         = "${var.app_name}-${local.review_environment}"
  application  = "${aws_elastic_beanstalk_application.aws_eb_lupin_app.name}"
  cname_prefix = "${var.app_name}-${var.account_id}"
  tier         = "WebServer"

  # the next line IS NOT RANDOM, see "final notes" at the bottom
  solution_stack_name = "${var.solution_stack_name}"

  ## Load Application Settings
  setting = ["${var.eb_environment_variables}"]

  # There are a LOT of settings, see here for the basic list:
  # https://is.gd/vfB51g
  # This should be the minimally required set for Docker.

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${aws_vpc.vpc_main.id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.vpc_main_public_subnet1.id},${aws_subnet.vpc_main_public_subnet2.id}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.iam_profile.id}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "${var.review_web_instance_type}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "${var.ec2_key_name}"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "${var.web_healthcheck_path}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "false"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = "60"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${aws_security_group.sg_eb_instance.id}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SSHSourceRestriction"
    value     = "tcp, 22, 22, ${aws_security_group.sg_eb_instance.id}"
  }
  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "ListenerEnabled"
    value     = "false"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "ListenerEnabled"
    value     = "true"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = "${var.loadbalancer_certificate_arn_review}"
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = "${aws_security_group.sg_https_eb.id}"
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "ManagedSecurityGroup"
    value     = "${aws_security_group.sg_https_eb.id}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "Systemtype"
    value     = "enhanced"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "Rolling"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType"
    value     = "Percentage"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize"
    value     = "50"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "${var.web_healthcheck_path}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RAILS_ENV"
    value     = "${local.review_rails_env}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SECRET_KEY_BASE"
    value     = "${var.secret_key_base}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RACK_ENV"
    value     = "${local.review_rails_env}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_HOST"
    value     = "${aws_rds_cluster.default.endpoint}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_USER"
    value     = "${var.db_username}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_PASSWORD"
    value     = "${var.db_password}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_NAME"
    value     = "${var.app_name}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RUNNING_MODE"
    value     = "web"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RAILS_SERVE_STATIC_FILES"
    value     = "1"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DEPLOYMENT_TARGET"
    value     = "${local.review_environment}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REGION"
    value     = "${var.region}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REPAIR_CASE_PATH"
    value     = "${var.repair_case_path}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DIAGNOSIS_PATH"
    value     = "${var.diagnosis_path}"
  }
}
