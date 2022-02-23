resource "google_container_cluster" "gke-cluster" {
  name     = var.cluster_name
  location   = var.region

  remove_default_node_pool = true
  initial_node_count       = 1


  //network = "projects/toptal-screening-1/global/networks/private-network"
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = var.node_pool_name
  location     = var.region
  cluster    = google_container_cluster.gke-cluster.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = var.machine_type

  }
}