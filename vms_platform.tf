variable "vm_resources" {
  type        = map(map(number))
  description = "Resources map for VMs"
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}

variable "vm_metadata" {
  type        = map(string)
  description = "Metadata map for VMs"
  default = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKWdwZ3ITR9ceNI5R/BcOHUf9H3G/i/u2MkOGk945cUI nedorezov@GARRO"
  }
}

###vm platform-web vars

#variable "vm_web_name" {
#  type        = string
#  default     = "netology-develop-platform-web"
#  description = "instance name"
#}

variable "vm_web_platform" {
  type        = string
  default     = "standard-v1"
  description = "platform id"
}

#variable "vm_web_resource_cores" {
#  type        = number
#  default     = 2
#  description = "number of vCPU cores"
#}

#variable "vm_web_resource_memory" {
#  type        = number
#  default     = 1
#  description = "VM memory"
#}
#
#variable "vm_web_resource_core_fraction" {
#  type        = number
#  default     = 5
#  description = "baseline performance for a core as a percent"
#}

variable "vm_web_policy_preemptible" {
  type        = bool
  default     = true
  description = "if the instance is preemptible"
}

variable "vm_web_network_nat" {
  type        = bool
  default     = true
  description = "Provide a public address, for instance, to access the internet over NAT"
}

#variable "vm_web_serial_port_enable" {
#  type        = number
#  default     = 1
#  description = "Access to serial console"
#}

#variable "vm_web_user" {
#  type        = string
#  default     = "ubuntu"
#  description = "default user"
#}

###vm platform-db vars

#variable "vm_db_name" {
#  type        = string
#  default     = "netology-develop-platform-db"
#  description = "instance name"
#}

variable "vm_db_platform" {
  type        = string
  default     = "standard-v1"
  description = "platform id"
}

#variable "vm_db_resource_cores" {
#  type        = number
#  default     = 2
#  description = "number of vCPU cores"
#}

#variable "vm_db_resource_memory" {
#  type        = number
#  default     = 2
#  description = "VM memory"
#}

#variable "vm_db_resource_core_fraction" {
#  type        = number
#  default     = 20
#  description = "baseline performance for a core as a percent"
#}

variable "vm_db_policy_preemptible" {
  type        = bool
  default     = true
  description = "if the instance is preemptible"
}

variable "vm_db_network_nat" {
  type        = bool
  default     = true
  description = "Provide a public address, for instance, to access the internet over NAT"
}

#variable "vm_db_serial_port_enable" {
#  type        = number
#  default     = 1
#  description = "Access to serial console"
#}

#variable "vm_db_user" {
#  type        = string
#  default     = "ubuntu"
#  description = "default user"
#}