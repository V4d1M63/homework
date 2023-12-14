resource "yandex_compute_disk" "storage_disks" {
  count = var.storage_vm.disks.count

  name = "${var.storage_vm.disks.prefix}-${count.index}"
  type = var.storage_vm.disks.type
  size = var.storage_vm.disks.size
}

data "yandex_compute_image" "storage" {
  family = var.storage_vm.image_id
}

resource "yandex_compute_instance" "storage" {
  name = var.storage_vm.name
  platform_id = var.storage_vm.platform_id

  resources {
    cores         = var.storage_vm.resources.cores
    memory        = var.storage_vm.resources.memory
    core_fraction = var.storage_vm.resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.storage.image_id
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disks.*.id
    content {
      disk_id = secondary_disk.value
  }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.storage_vm.nat
    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }
  scheduling_policy {
    preemptible = var.storage_vm.preemptible
  }

  metadata = merge(var.storage_vm.metadata, local.metadata)
}