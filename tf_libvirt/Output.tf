output "VMs" {
  value = [for idx, vm in {
    for idx, vm in local.VMs : "${idx}-${vm.os}" => vm
    } : format("ssh %s@%s %s", vm.os, libvirt_domain.domain-os[idx].network_interface.0.addresses[0], libvirt_domain.domain-os[idx].name)
  ]

  depends_on = [libvirt_domain.domain-os]
}

output "etcHosts" {
  value = format("cat << EOF | sudo tee -a /etc/hosts\n%s\nEOF",
    join("\n",
      [for idx, vm in {
        for idx, vm in local.VMs : "${idx}-${vm.os}" => vm
        } : format("%s %s", libvirt_domain.domain-os[idx].network_interface.0.addresses[0], libvirt_domain.domain-os[idx].name)
      ]
    )
  )
  depends_on = [libvirt_domain.domain-os]
}