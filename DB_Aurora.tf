#   module "aurora" {
#     source                          = "clouddrove/aurora/aws"
#     version                         = "0.12.0"
#     name                            = "backend"
#     application                     = ""
#     environment                     = "test"
#     label_order                     = []
#     username                        = "admin"
#     database_name                   = "dt"
#     engine                          = "aurora-mysql"
#     engine_version                  = "5.7.12"
#     subnets                         = [aws_subnet.private7.id, aws_subnet.private8.id]
#     aws_security_group              = [aws_security_group.db_sec_group,id]
#     replica_count                   = 1
#     instance_type                   = "db.t2.medium"
#     apply_immediately               = true
#     skip_final_snapshot             = true
#     publicly_accessible             = false
#   }

# data "aws_caller_identity" "current" {}

resource "aws_rds_cluster" "default" {
  cluster_identifier      = "aurora-cluster-demo"
  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.name
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.03.2"
  availability_zones      = ["us-west-2a", "us-west-2b"]
  database_name           = "mydb"
  master_username         = var.db_username
  master_password         = var.db_password
  backup_retention_period = 0
  preferred_backup_window = "07:00-09:00"
  vpc_security_group_ids  = [aws_security_group.db_sec_group.id]
  skip_final_snapshot     = true

  # s3_import {
  #   source_engine         = "aurora-mysql"
  #   source_engine_version = "5.7"
  #   bucket_name           = "go-green-02262021"
  #   bucket_prefix         = "backups"
  #   ingestion_role        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/role-xtrabackup-rds-restore"
  # }

}


resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "aurora-cluster-demo-${count.index}"
  cluster_identifier = aws_rds_cluster.default.id
  instance_class     = "db.r4.large"
  engine             = aws_rds_cluster.default.engine
  engine_version     = aws_rds_cluster.default.engine_version



}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-sn-group"
  subnet_ids = [aws_subnet.private5.id, aws_subnet.private6.id]

  tags = {
    Name = "GoGreenDB"
  }
}



resource "aws_security_group" "db_sec_group" {
  name   = "db_sec_group"
  vpc_id = aws_vpc.team2vpc.id

  ingress {
    from_port       = "3306"
    to_port         = "3306"
    protocol        = "tcp"
    security_groups = [aws_security_group.sec_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


