resource "aws_iam_role" "aws_aurora_monitoring" {
  name = "${var.app_name}_rds_monitoring"
  path = "/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "aws_aurora_monitoring_policy" {
  role       = "${aws_iam_role.aws_aurora_monitoring.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  depends_on = ["aws_iam_role.aws_aurora_monitoring"]
}
