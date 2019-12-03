resource "aws_db_parameter_group" "default" {
  name   = "${var.app_name}"
  family = "aurora5.6"

  tags {
    Name = "${var.app_name} db-parameter-group"
  }

  parameter {
    name         = "wait_timeout"
    value        = 10
    apply_method = "immediate"
  }
}

resource "aws_rds_cluster_parameter_group" "default" {
  name        = "${var.app_name}"
  family      = "aurora5.6"
  description = "Cluster parameter group for ${var.app_name}"

  tags {
    Name = "${var.app_name} db-cluster-parameter-group"
  }

  parameter {
    name         = "character_set_client"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_filesystem"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_results"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = "utf8mb4_general_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_server"
    value        = "utf8mb4_general_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "time_zone"
    value        = "Asia/Shanghai"
    apply_method = "immediate"
  }
}
