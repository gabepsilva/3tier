
variable "node_pool_name" {
    type        = string
    default     = "top3tier-pool"
}

variable "cluster_name" {
    type        = string
    default     = "top3tier-cluster"
}

variable "region" {
    type        = string
    default     = "us-central1"
}

variable "machine_type" {
    type        = string
    description = "Compute instance size"
    default     = "g1-small"
}

variable "preemptible" {
    type        = string
    description = "Compute instance size"
    default     = true
}