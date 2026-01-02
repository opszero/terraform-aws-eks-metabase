# Password auto generate
resource "random_password" "password" {
  count   = var.password == "" ? 1 : 0
  length  = 16
  special = true
}

module "postgresql" {
  source = "git::https://github.com/opszero/terraform-aws-rds.git?ref=update/tags"

  name = var.name

  # networking
  allowed_ip          = var.allowed_ip
  allowed_ports       = var.allowed_ports
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  publicly_accessible = var.publicly_accessible

  # storage
  allocated_storage = var.allocated_storage
  storage_encrypted = true

  # backups
  backup_retention_period = 7
  backup_window           = "03:00-06:00"
  maintenance_window      = "Mon:00:00-Mon:03:00"

  # logs
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  # database
  db_name        = var.db_name
  db_username    = var.username
  password       = var.password == "" ? random_password.password[0].result : var.password
  port           = "5432"
  instance_class = var.instance_class

  # engine
  engine               = "postgres"
  engine_name          = "postgres"
  engine_version       = "15.5"
  family               = "postgres15"
  major_engine_version = "15"

  # other
  multi_az                       = false
  ssm_parameter_endpoint_enabled = false
  deletion_protection            = false
  apply_immediately              = true
}

resource "helm_release" "metabase" {
  depends_on       = [module.postgresql]
  chart            = "metabase"
  name             = var.name
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://pmint93.github.io/helm-charts"
  version          = var.metabase_version
  values           = [file("metabase.yaml")]

  set = [
    {
      name  = "database.host"
      value = module.postgresql.db_instance_address
    },
    {
      name  = "database.password"
      value = var.password == "" ? random_password.password[0].result : var.password
    }
  ]
}
