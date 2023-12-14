data "yandex_compute_image" "web" {
  family = var.web_vm.image_id
}

resource "yandex_compute_instance" "web" {
  count       = var.web_vm.count
  name        = "${var.web_vm.name}-${count.index + 1}"
  platform_id = var.web_vm.platform_id

  resources {
    cores         = var.web_vm.resources.cores
    memory        = var.web_vm.resources.memory
    core_fraction = var.web_vm.resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.web.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.web_vm.nat
    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }
  scheduling_policy {
    preemptible = var.web_vm.preemptible
  }

  metadata = merge(var.web_vm.metadata, local.metadata)
}