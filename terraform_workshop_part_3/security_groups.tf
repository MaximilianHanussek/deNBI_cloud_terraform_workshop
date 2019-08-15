resource "openstack_networking_secgroup_v2" "terraform_workshop_sec_group" {
  name                 = "terraform-workshop-access-group"
  description          = "Allow SSH access and ping request"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "ingress-public-4-ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.terraform_workshop_sec_group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "ingress-public-4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.terraform_workshop_sec_group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "egress-public-4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = "${openstack_networking_secgroup_v2.terraform_workshop_sec_group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "egress-public-6" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = "${openstack_networking_secgroup_v2.terraform_workshop_sec_group.id}"
}
