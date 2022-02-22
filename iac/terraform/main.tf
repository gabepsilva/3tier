terraform { 
  backend "gcs" {
      bucket = "gabriel-screening1"
      credentials = "~/toptal-screening-1-7b90d8bd1253.json"
  }
}

provider "google" {
    credentials = file("~/toptal-screening-1-7b90d8bd1253.json")
    project = var.gcp_project_id
    region  = var.region
}

provider "google-beta" {
    credentials = file("~/toptal-screening-1-7b90d8bd1253.json")
    project = var.gcp_project_id
    region  = var.region
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

  instance_name = "toptalpg-${random_pet.dbname.id}"
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
