resource "aws_rds_cluster" "default" {
  cluster_identifier              = "${var.app_name}"
  master_username                 = "${var.db_username}"
  master_password                 = "${var.db_password}"
  backup_retention_period         = 5
  preferred_backup_window         = "19:30-20:00"
  preferred_maintenance_window    = "wed:20:15-wed:20:45"
  port                            = 3306
  vpc_security_group_ids          = ["${aws_security_group.db_security_group.id}"]
  db_subnet_group_name            = "${aws_db_subnet_group.vpc_main_db_subnet_group.name}"
  storage_encrypted               = true
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.default.name}"
  skip_final_snapshot             = true
  final_snapshot_identifier       = "finalsnapshot"

  tags {
    Name = "${var.app_name}"
  }
}

resource "aws_rds_cluster_instance" "default" {
  count = "${var.db_cluster_instance_count}"

  identifier              = "${var.app_name}-${count.index}"
  cluster_identifier      = "${aws_rds_cluster.default.id}"
  instance_class          = "${var.db_instance_type}"
  db_subnet_group_name    = "${aws_db_subnet_group.vpc_main_db_subnet_group.name}"
  db_parameter_group_name = "${aws_db_parameter_group.default.name}"
  monitoring_role_arn     = "${aws_iam_role.aws_aurora_monitoring.arn}"
  monitoring_interval     = 60
  depends_on              = ["aws_iam_role_policy_attachment.aws_aurora_monitoring_policy"]

  tags {
    Name = "${var.app_name}"
  }
}
