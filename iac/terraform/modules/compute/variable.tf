variable "region" {
    type        = string
    default = "us-central1"
}

variable "zone" {
    type        = string
    default     =  "us-central1-c"
}


variable "name" {
    type        = string
    default     = "vm1"
}


variable "machine_type" {
    type        = string
    description = "Compute instance size"
    default     = "f1-micro"
}

variable "preemptible" {
    type        = bool
    description = "Compute instance preemptible"
    default     = true
}

variable "network_tags"{
    type = list
    default = ["all"]
}

variable "private_key_path" {
    type        = string
    default     = "/Users/u/.ssh/google_compute_engine"
}