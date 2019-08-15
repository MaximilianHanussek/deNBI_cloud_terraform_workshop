variable "cinder-disc-size" {
  default = 10
}

variable "cinder-storage-backend" {
  default = "quobyte_hdd"
}

variable "volume-name" {
  default = "maxhanussek-workshop-volume"
}

variable "flavors" {
  type = "map"
  default = {
    "workshop-vm" = "de.NBI default"
  }
}

variable "vm-name" {
  default = "maxhanussek-workshop-vm"
}

variable "workshop-image" {
  default = "CentOS"
}

variable "openstack-key-name" {
  default = "workshop"
}

variable "security-groups" {
  default = [
    "terraform-workshop-access-group"
  ]
}

variable "network" {
  default = "deNBI_user_meeting_internal" 
}
