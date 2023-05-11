Домашнее задание к занятию 10.1 "`Keepalived/vrrp` - Вдовин Вадим
### Задание 1

Разверните топологию из лекции и выполните установку и настройку сервиса Keepalived. 

### ОТВЕТ:
1. Нода № 1:
```
vrrp_instance failover_test {
state MASTER
interface enp0s8
virtual_router_id 10
priority 110
advert_int 4
authentication {
auth_type AH
auth_pass 1111
}
unicast_peer {
192.168.1.10
}
    virtual_ipaddress {
    192.168.1.50 dev enp0s8 label enp0s8:vip
}
}
```
![1](https://github.com/V4d1M63/homework/assets/130470784/1bcad09d-7520-486b-be83-b40863bde511)
![2](https://github.com/V4d1M63/homework/assets/130470784/86c7a632-08d5-4f08-b514-edf32e2903c8)

2. Нода № 2:
```
vrrp_instance failover_test {
state BACKUP
interface enp0s8
virtual_router_id 10
priority 10
advert_int 4
authentication {
auth_type AH
auth_pass 1111
}
unicast_peer {
192.168.1.20
}
    virtual_ipaddress {
    192.168.1.50 dev enp0s8 label enp0s8:vip
}
}
```
![3](https://github.com/V4d1M63/homework/assets/130470784/0ceb96e6-918e-4156-bc3c-44a5378bc409)
![4](https://github.com/V4d1M63/homework/assets/130470784/4013b139-59c3-45d5-91e5-4667070e45fe)

