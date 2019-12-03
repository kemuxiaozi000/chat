#####################################
# Elastic Container Repository for Docker images
#####################################

resource "aws_ecr_repository" "aws_container_repository" {
  name = "${var.app_name}"
}

resource "aws_ecr_lifecycle_policy" "expiration_policy" {
  repository = "${aws_ecr_repository.aws_container_repository.name}"

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images for review older than 4 generations",
            "selection": {
                "tagStatus": "tagged",
                "countType": "imageCountMoreThan",
                "countNumber": 3,
                "tagPrefixList": [
                     "review"
                ]
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 10,
            "description": "Expire images for staging older than 4 generations",
            "selection": {
                "tagStatus": "tagged",
                "countType": "imageCountMoreThan",
                "countNumber": 3,
                "tagPrefixList": [
                     "staging"
                ]
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 20,
            "description": "Expire images for demo older than 4 generations",
            "selection": {
                "tagStatus": "tagged",
                "countType": "imageCountMoreThan",
                "countNumber": 3,
                "tagPrefixList": [
                     "demo"
                ]
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
