# resource "libvirt_network" "k8s-net" {
#   name      = var.network_name 
#   domain    = ""
#   mode      = "nat"
#   addresses = ["192.168.100.1/24"]
# }

data "template_file" "network_config" {
  template = file("${path.module}/templates/netplan.yml")
}
