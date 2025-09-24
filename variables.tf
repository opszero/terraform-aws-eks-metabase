#lables
variable "name" {
  type        = string
  default     = "metabase"
  description = "Name  (e.g. `app` or `cluster`)."
}

#networking
variable "allowed_ip" {
  type        = list(any)
  default     = []
  description = "List of allowed ip."
}

variable "allowed_ports" {
  type        = list(any)
  default     = [5432]
  description = "List of allowed ingress ports"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The ID of the VPC that the instance security group belongs to."
  sensitive   = true
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "A list of VPC Subnet IDs to launch in."
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Bool to control if instance is publicly accessible"
}
#storage
variable "allocated_storage" {
  type        = number
  default     = 50
  description = "The allocated storage in gigabytes"
}

#logs
variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  default     = ["postgresql", "upgrade"]
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)."
}
#database
variable "db_name" {
  type        = string
  default     = "metabase"
  description = "The DB name to create. If omitted, no database is created initially"
}

variable "username" {
  type        = string
  default     = "postgres"
  description = "Username for the master DB user"
}


variable "password" {
  type        = string
  default     = ""
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
}

variable "instance_class" {
  type        = string
  default     = ""
  description = "The instance type of the RDS instance"
}

#airbye
variable "namespace" {
  type        = string
  default     = "metabase"
  description = "namespace of metabase   (e.g. `tools` or `metabase`)."
}

variable "metabase_version" {
  type        = string
  default     = "2.10.4"
  description = "version of metabase hemm chart."
}
