locals {
  allowed_ip = ["24.150.66.6", "34.132.80.13", "0.0.0.0/0"]
}


resource "google_sql_database_instance" "postgres" {

  name = var.instance_name
  database_version = "POSTGRES_14"
  region = var.region
  deletion_protection = false
  
  settings {
    tier = var.machine_type
    disk_type = "PD_HDD"
    availability_type = "ZONAL"
    backup_configuration {
      enabled  = true
      point_in_time_recovery_enabled = false
      start_time = "2:00"
      backup_retention_settings {
        retained_backups = 7

      }
    }
    
    ip_configuration {
      ipv4_enabled    = true
      require_ssl     = false

      dynamic "authorized_networks" {
        for_each = local.allowed_ip
        iterator = allowed_ip

        content {
          name  = "allowed_ip-${allowed_ip.key}"
          value = allowed_ip.value
        }
      }
      
      //private_network = google_compute_network.private_network.id
    }
  }

}

/*
resource "random_uuid" "randpwd" {
}

resource "google_sql_user" "user" {
  name     = var.db_username
  instance = "${google_sql_database_instance.postgres.name}"
  host     = "*"
  password = random_uuid.randpwd.result #random password with output
}
*/