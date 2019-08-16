data "openstack_images_image_v2" "workshop_image_master" {
  name = "${var.workshop-image["master"]}"
  most_recent = true
}

data "openstack_images_image_v2" "workshop_image_compute" {
  name = "${var.workshop-image["compute"]}"
  most_recent = true
}

resource "openstack_blockstorage_volume_v2" "cinder_volume_master" {
  name		= "${var.volume-name["master"]}"
  size 		= "${var.cinder-disc-size}"
  volume_type 	= "${var.cinder-storage-backend}"
}

resource "openstack_blockstorage_volume_v2" "cinder_volume_compute" {
  count         = "${var.compute-node-count}"
  name          = "${var.volume-name["compute"]}-${count.index}"
  size          = "${var.cinder-disc-size}"
  volume_type   = "${var.cinder-storage-backend}"
}

resource "openstack_compute_instance_v2" "workshop_vm_master" {
  name		  = "${var.vm-name["master"]}"
  flavor_name     = "${var.flavors["master"]}"
  image_id        = "${data.openstack_images_image_v2.workshop_image_master.id}"
  key_pair        = "${var.openstack-key-name}"
  security_groups = "${var.security-groups}"

  network {
    name = "${var.network}"
  }

block_device {
    uuid                  = "${data.openstack_images_image_v2.workshop_image_master.id}"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

block_device {
    uuid                  = "${openstack_blockstorage_volume_v2.cinder_volume_master.id}"
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = true
  }
}

resource "openstack_compute_instance_v2" "compute" {
  count           = "${var.compute-node-count}"
  name            = "${var.vm-name["compute"]}-${count.index}"
  flavor_name     = "${var.flavors["compute"]}"
  image_id        = "${data.openstack_images_image_v2.workshop_image_compute.id}"
  key_pair        = "${var.openstack-key-name}"
  security_groups = "${var.security-groups}"
  network {
    name = "${var.network}"
  }

block_device {
    uuid                  = "${data.openstack_images_image_v2.workshop_image_compute.id}"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

block_device {
    uuid                  = "${element(openstack_blockstorage_volume_v2.cinder_volume_compute.*.id, count.index)}"
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = true
  }
}
