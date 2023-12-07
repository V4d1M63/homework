locals {
  project = "netology-develop-platform"
  vm_1 = "web"
  vm_2 = "db"
  web_name = "${local.project}-${local.vm_1}"
  db_name = "${local.project}-${local.vm_2}"
}