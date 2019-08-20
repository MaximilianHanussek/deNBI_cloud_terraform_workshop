variable "cinder-disc-size" {
  default = 10
}

variable "cinder-storage-backend" {
  default = "quobyte_hdd"
}

variable "volume-name" {
  type = "map" 
  default = {
    "master" = "mhanussek-workshop-volume-master"
    "compute" = "mhanussek-workshop-volume-compute"
  }
}

variable "flavors" {
  type = "map"
  default = {
    "master" = "de.NBI default"
    "compute" = "de.NBI default"
  }
}

variable "vm-name" {
  type = "map"
  default = {
    "master" = "mhanussek-workshop-vm-master"
    "compute" = "mhanussek-workshop-vm-compute"
  }
}

variable "workshop-image" {
  type = "map"
  default = {
    "master" = "unicore_master_centos_20190712"
    "compute" = "unicore_compute_centos_20190719"
  }
}

variable "openstack-key-name" {
  default = "workshop"
}

variable "security-groups" {
  default = [
    "cluster-nodes"
  ]
}

variable "network" {
  default = "deNBI_user_meeting_internal" 
}

variable "compute-node-count" {
  default = 2
}
