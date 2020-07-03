data "openstack_images_image_v2" "workshop_image" {
  name = var.workshop-image
  most_recent = true
}

resource "openstack_blockstorage_volume_v2" "cinder_volume" {
  name		= var.volume-name
  size 		= var.cinder-disc-size
  volume_type 	= var.cinder-storage-backend
}

resource "openstack_compute_instance_v2" "workshop_vm" {
  name		  = var.vm-name
  flavor_name     = var.flavors["workshop-vm"]
  image_id        = data.openstack_images_image_v2.workshop_image.id
  key_pair        = openstack_compute_keypair_v2.workshop_keypair.name
  security_groups = var.security-groups

  network {
    name = var.network
  }

block_device {
    uuid                  = data.openstack_images_image_v2.workshop_image.id
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

block_device {
    uuid                  = openstack_blockstorage_volume_v2.cinder_volume.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = true
  }
}

