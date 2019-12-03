#####################################
# Terraform State Settings
#####################################

terraform {
  backend "s3" {
    bucket = "lupin-terraform"
    key    = "terraform.tfstate.aws"
    region = "ap-northeast-1"
  }
}
