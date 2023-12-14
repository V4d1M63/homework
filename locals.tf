locals {
  ssh-key = file("~/.ssh/id_ed25519.pub")
  metadata = {
    ssh-keys = "${var.admin}:${local.ssh-key}"
  }
}