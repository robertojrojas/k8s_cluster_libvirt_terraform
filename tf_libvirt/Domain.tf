locals {
  rocky_host = strcontains(var.runtime_linux_os, "rocky")
  rocky_guest_os = "rocky9"
  default_machine = "pc"
  host_qemu = {
    "rocky-rocky9": {
       "machine": "pc-q35-rhel9.6.0",
       xlst_fname: "xslt/rocky-host-rocky9-guest.xsl",
    },
    "ubuntu-rocky9": {
       "machine": "q35",
       xlst_fname: "xslt/ubuntu-host-rocky9-guest.xsl",
    },
     "linuxmint-rocky9": {
       "machine": "q35",
       xlst_fname: "xslt/ubuntu-host-rocky9-guest.xsl",
    },
     "linuxmint-ubuntu-noble": {
       "machine": "pc-q35-noble",
       xlst_fname: "xslt/ubuntu-host-rocky9-guest.xsl",
    },
    "linuxmint-ubuntu-jammy": {
       "machine": "pc-q35-jammy",
       xlst_fname: "xslt/ubuntu-host-rocky9-guest.xsl",
    },
    "linuxmint-fedora": {
       "machine": local.default_machine,
       xlst_fname: "xslt/ubuntu-host-rocky9-guest.xsl",
    },
  }
}
resource "libvirt_domain" "domain-os" {
  for_each = { for idx, vm in local.VMs : "${idx}-${vm.os}" => vm }

  name      = each.value.hostname
  memory    = local.vm_spec[each.value.type].vmem
  vcpu      = local.vm_spec[each.value.type].vcpu
  cloudinit = libvirt_cloudinit_disk.cloud-init[each.key].id

  // Needed for Rocky 9.6
  //machine = "pc-q35-rhel9.6.0"
  machine = each.value.os == local.rocky_guest_os ? local.host_qemu["${var.runtime_linux_os}-${each.value.os}"].machine : local.default_machine
  dynamic "xml" {
    for_each = each.value.os == local.rocky_guest_os ? [{}] : []
    content {
      xslt = file(local.host_qemu["${var.runtime_linux_os}-${each.value.os}"].xlst_fname)
    }
  }

  # filesystem {
  #   source     = var.fs_share
  #   target     = "shared"
  #   readonly   = false
  #   accessmode = "passthrough"
  # }

  network_interface {
    network_name   = "default"
    addresses      = [each.value.ip]
    mac            = each.value.mac
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }

  disk {
    volume_id = libvirt_volume.os-base[each.key].id
  }

  depends_on = [libvirt_cloudinit_disk.cloud-init]
}

# locals {
#   etc_hosts =  format("#/bin/bash \n\ncat << EOF | sudo tee -a /etc/hosts\n%s\nEOF", 
#     join("\n",
#       [ for idx, vm in {
#           for idx, vm in local.VMs: "${idx}-${vm.os}" => vm
#       }: format("%s %s", libvirt_domain.domain-os[idx].network_interface.0.addresses[0], libvirt_domain.domain-os[idx].name) 
#       ]
#     )
#   )
# }

# resource "null_resource" "ssh_etc_hosts" {
#   for_each = {for idx, vm in local.VMs: "${idx}-${vm.os}" => vm}

#   provisioner "file" {
#     content = local.etc_hosts
#     destination = local.etc_hosts_extra_script_path
#   }

#   connection {
#      type     = "ssh"
#     host = libvirt_domain.domain-os[each.key].network_interface.0.addresses[0]
#     private_key = file(local.ssh_prv_key)
#     user = each.value.os
#   }

#   depends_on = [libvirt_domain.domain-os]
# }