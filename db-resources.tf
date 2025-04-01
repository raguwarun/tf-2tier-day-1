  resource "aws_db_instance" "two-tier-db-1" {
    instance_class = "db.t3.micro"
    allocated_storage = 10
    storage_type = "gp2"
    engine = "mysql"
    engine_version = "8.0"
    db_subnet_group_name = aws_db_subnet_group.two-tier-db-sub
    vpc_security_group_ids = [aws_security_group.two-tier-db-sg.id]
    db_name = "two_tier_db1"
    username = "admin"
    password = "mysql"
    multi_az = false
    skip_final_snapshot = true
  }
