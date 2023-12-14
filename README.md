# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»  
## Студент: Вдовин Вадим

------

### Цели задания

1. Отработать основные принципы и методы работы с управляющими конструкциями Terraform.
2. Освоить работу с шаблонизатором Terraform (Interpolation Syntax).

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Консоль управления Yandex Cloud](https://console.cloud.yandex.ru/folders/<cloud_id>/vpc/security-groups).
2. [Группы безопасности](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav).
3. [Datasource compute disk](https://terraform-eap.website.yandexcloud.net/docs/providers/yandex/d/datasource_compute_disk.html).

------

## Задание 1
1. Изучите проект.
2. Заполните файл personal.auto.tfvars.
3. Инициализируйте проект, выполните код. Он выполнится, даже если доступа к preview нет.

Примечание. Если у вас не активирован preview-доступ к функционалу «Группы безопасности» в Yandex Cloud, запросите доступ у поддержки облачного провайдера. Обычно его выдают в течение 24-х часов.

Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud или скриншот отказа в предоставлении доступа к preview-версии.


> ### Ответ:
> Изучил проект, заполнил `personal.auto.tfvars`, выполнил `terraform plan` + `apply`. В результате в YC создана группа сеть `develop` с подсетью `develop` и группой безопасности `example_dynamic`:
> ![01](https://github.com/V4d1M63/homework/assets/130470784/c983cb65-1959-4c47-aabb-89a524e809b5)
> ![02](https://github.com/V4d1M63/homework/assets/130470784/3113dd33-937d-4647-9292-e1a4b5c8b74f)


------

## Задача 2
1. Создайте файл count-vm.tf. Опишите в нём создание двух **одинаковых** ВМ web-1 и web-2 (не web-0 и web-1) с минимальными параметрами, 
используя мета-аргумент **count loop**. Назначьте ВМ созданную в первом задании группу безопасности.
(как это сделать узнайте в документации провайдера yandex/compute_instance )
2. Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ с именами "main" и "replica" **разных** по cpu/ram/disk , 
используя мета-аргумент **for_each loop**. Используйте для обеих ВМ одну общую переменную типа 
list(object({ vm_name=string, cpu=number, ram=number, disk=number  })). При желании внесите в переменную все возможные параметры.
3. ВМ из пункта 2.2 должны создаваться после создания ВМ из пункта 2.1.
4. Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2.
5. Инициализируйте проект, выполните код.

> ### Ответ:
> В файле variables.tf добавил переменные `web_vm` и `backend_vm` с дефолтными параметрами для создания ВМ. Все параметры вынесены в переменные, без хардкода.
> 
> В файле count-vm.tf описал создание двух одинаковых ВМ web-1 и web-2, в файле for_each-vm.tf описал создание main и replica (допустил, что это backend).
> 
> С помощью `depends_on` обозначил, что `backend`-ВМ создается только после `web`-ВМ. 
> 
> В файле locals.tf происходит считывание открытой части ключа из файла и составление local-метаданных, которые затем с помощью `merge` соединяем с metadata из variables ВМ.
> 
> Выполнил `terraform plan` + `terraform apply`, дополнительные ресурсы успешно созданы:
> ![03](https://github.com/V4d1M63/homework/assets/130470784/3f0cc334-c76a-4f00-bbff-9a0e59cf0a94)
> ![04](https://github.com/V4d1M63/homework/assets/130470784/d0433b99-79dc-482c-a0f8-94aa64ece4dd)

------

## Задача 3
1. Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле **disk_vm.tf**.
2. Создайте в том же файле **одиночную**(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage" . Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

> ### Ответ:
> В файле disk_vm.tf создал ресурс с дисками и ВМ `storage`, используя параметры из переменной `storage_vm` в variables.rf.
> 
> Выполнил `terraform plan` + `terraform apply`, дополнительные ресурсы успешно созданы:
> ![05](https://github.com/V4d1M63/homework/assets/130470784/3b4d56fb-fbe4-43aa-b8b2-6dc32d107e23)
> ![06](https://github.com/V4d1M63/homework/assets/130470784/68794a11-060e-4587-ac56-7c62abfc5187)


------

## Задача 4
1. В файле ansible.tf создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demonstration2).
Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.
2. Инвентарь должен содержать 3 группы [webservers], [databases], [storage] и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.
3. Добавьте в инвентарь переменную fqdn. 


> ### Ответ:
> Создал ресурс `local_file` в ansible.tf для генерации inventory с помощью tepmplatefile, также сформировал template inventory.tftpl.
> В шаблоне три динамические группы, которые заполняются через цикл for.  
> 
> Сгенерированный файл:
> ![07](https://github.com/V4d1M63/homework/assets/130470784/4f45f2c6-adb5-4515-9063-5e752cec6aa8)
