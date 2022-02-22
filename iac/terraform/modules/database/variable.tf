variable "instance_name" {
    type        = string
    default = "postgres-db"
}

variable "db_username" {
    type        = string
    default = "postgres-user"
}

variable "region" {
    type        = string
    default = "us-central1"
}

variable "machine_type" {
    type        = string
    default     = "g1-small"
}
