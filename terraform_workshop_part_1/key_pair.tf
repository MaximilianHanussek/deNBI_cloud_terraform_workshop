resource "openstack_compute_keypair_v2" "workshop_keypair" {
  name 	     = var.workshop-key-name
  public_key = var.public-key
}
