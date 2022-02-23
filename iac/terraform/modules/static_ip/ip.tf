
resource "google_compute_address" "static_ip" {
  name    = "${var.name}"
  region  = var.region
}