### Формирование Inventory
resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tftpl", {
    webservers = yandex_compute_instance.web
    databases  = yandex_compute_instance.backend
    storage    = [yandex_compute_instance.storage]
  })
  filename = "${abspath(path.module)}/hosts.cfg"
}


### Запуск provision для web-servers
resource "null_resource" "provision_web" {
  depends_on = [
    yandex_compute_instance.web,
    local_file.inventory
  ]

  #Добавление ПРИВАТНОГО ssh ключа в ssh-agent
  provisioner "local-exec" {
    command = "cat ~/.ssh/id_ed25519 | ssh-add -"
  }

  #Запуск ansible-playbook
  provisioner "local-exec" {
    command     = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/hosts.cfg ${abspath(path.module)}/playbook.yml"
    on_failure  = continue # Продолжить выполнение terraform pipeline в случае ошибок
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }  # срабатывание триггера при изменении переменных
  }
  triggers = {
    always_run        = timestamp()                         #всегда т.к. дата и время постоянно изменяются
    playbook_src_hash = file("${abspath(path.module)}/playbook.yml") # при изменении содержимого playbook файла
    ssh_public_key    = local.ssh-key                           # при изменении переменной
  }
}