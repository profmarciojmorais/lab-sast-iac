resource "google_compute_instance" "lab-sast" {
  provider                  = google
  name                      = "lab-sast"
  machine_type              = var.google_instance_type
  allow_stopping_for_update = true
  zone                      = var.google_zone
  metadata = {
    ssh-keys = "ansible:${file(var.ssh_key_pub)}"
  }

  network_interface {
    network = var.google_network
    access_config {}
  }

  tags = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = var.google_instance_image
    }
  }

  provisioner "local-exec" {
    command = "echo 'lab-sast ansible_port=22 ansible_host=${self.network_interface.0.access_config.0.nat_ip} ansible_user=ansible ansible_ssh_private_key_file=${var.ssh_key_priv}' >> ../ansible/inventory.yml"
  }

}

# resource "github_actions_variable" "lab_sast_nat_ip" {
#   repository       = "LAB_SAST_NAT_IP"
#   variable_name    = "LAB_SAST_NAT_IP"
#   value            = "${google_compute_instance.lab-sast.network_interface.0.access_config.0.nat_ip}"
# }