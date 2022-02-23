terraform { 
  backend "gcs" {
      bucket = "3tier-tfstate"
  }
}

provider "google" {
    project = var.gcp_project_id
    region  = var.region
}

provider "google-beta" {
    project = var.gcp_project_id
    region  = var.region
}

// RECOMMENDATION:
// Move the IPs provisioning to another folder so we can be free to 
// destroy everything without losing the static IPs reserved
// Downside is, Static IPs are charged when not in use.


// Static IP for BE services
// Reserved but to be manually attached in the BE deployment.yml
module "be_ip" {
  source = "./modules/static_ip"
  
  name = "be-services"
  region  = var.region
}

# Static IP for FE services
// Reserved but to be manually attached in the FE deployment.yml
module "fe_ip" {
  source = "./modules/static_ip"
  
  name = "fe-services"
  region  = var.region
}

resource "google_compute_firewall" "rules" {
  project     = var.gcp_project_id
  name        = "all-open"
  network     = "default"
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "all"
    //ports     = ["1-65535"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["all"]
}


module "ha_reverse_proxy" {
    source = "./modules/compute"

    name = "top-ha-proxy1"
    region = "us-central1"
    private_key_path = "~/.ssh/id_ed25519"
}


resource "random_pet" "dbname" {
}

module "database" {
  source = "./modules/database"

  instance_name = "top3tier-${random_pet.dbname.id}"
  db_username = "postgres"
  machine_type = "db-f1-micro"
  region = "us-central1"
}
  

module "k8_cluster" {
    source = "./modules/k8s/"

    node_pool_name = "kube-learning"
    region = "us-central1"
    machine_type = "g1-small"
    preemptible  = true
}
