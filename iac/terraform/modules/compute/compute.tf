resource "google_compute_address" "static_ip" {
  name    = "rev-proxy-yip"
  region  = var.region
}


resource "google_compute_instance" "proxy_instance" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.network_tags 


  labels = {
    environment = "dev"
  }


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  scheduling {
    preemptible         = var.preemptible
    automatic_restart   = ! var.preemptible  //Scheduling must have preemptible be false when AutomaticRestart is true.
  }

}

/*

# Prepare local machine to ssh into VM created.

resource "local_file" "ansible_inv" {
  depends_on = [google_compute_instance.proxy_instance]

  content     = "${google_compute_address.static_ip.address}"
  filename = "inv.txt"
}
 


resource "null_resource" "ssh-set" {

      depends_on = [google_compute_instance.proxy_instance, local_file.ansible_inv]

      provisioner "local-exec" { 
      interpreter = ["/bin/bash" ,"-c"]
      command = <<-EOT
        #if [ -f ~/.ssh/id_ed25519.pub ]
        #then
        #    echo "Using existing key for gcloud auth"
        #    [ -f ~/.ssh/google_compute_engine ] || echo "link id_ed25519 to google_compute_engine";  ln -s ~/.ssh/id_ed25519 google_compute_engine
        #    [ -f ~/.ssh/google_compute_engine.pub ] || echo "link id_ed25519.pub to google_compute_engine.pub"; ln -s ~/.ssh/id_ed25519.pub google_compute_engine.pub
        #else
        #    echo "Generationg keys for GCloud auth"
        #    ssh-keygen -q -t ed25519 -N '' -f ~/.ssh/id_ed25519 -C "cicd@deleted.key"
        #    mv id_ed25519 google_compute_engine
        #    mv id_ed25519.pub google_compute_engine.pub
        #fi
          
        PAUSE_SECS=1
        echo 'Waiting VM to be ready for ssh'
        echo Paused $PAUSE_SECS secs
        sleep $PAUSE_SECS
        echo "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inv.txt --private-key ${var.private_key_path} ../ansible/haproxy.yaml"
        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inv.txt --private-key ${var.private_key_path} ../ansible/haproxy.yaml
        rm inv.txt
      EOT
    }
}

*/