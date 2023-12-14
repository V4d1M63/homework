data "yandex_compute_image" "backend" {
  family = var.backend_image_id
}

resource "yandex_compute_instance" "backend" {
  depends_on  = [yandex_compute_instance.web]
  for_each    = { for i in var.backend_vm : i.name => i }
  name        = each.value.name
  platform_id = each.value.platform_id

  resources {
    cores         = each.value.resources.cores
    memory        = each.value.resources.memory
    core_fraction = each.value.resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.backend.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = each.value.nat
    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }
  scheduling_policy {
    preemptible = each.value.preemptible
  }

  metadata = merge(each.value.metadata, local.metadata)
}