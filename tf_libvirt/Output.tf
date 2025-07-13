# output "VMs" {
#   value = [ for vms in libvirt_domain.domain-os : format("ssh fedora@%s # %s", vms.network_interface.0.addresses[0], vms.name) ]

#   depends_on = [libvirt_domain.domain-os]
# }

# output "VMs" {
#   value = [ for idx, vm in {
#     for index, vm in local.VMs:
#     vm.hostname => vm
#   }: format("ssh %s@%s # %s", vm.user, libvirt_domain.domain-os[idx].network_interface.0.addresses[0], vm.hostname) ]

#   depends_on = [libvirt_domain.domain-os]
# }

# output "etcHosts" {
#   value = format("cat << EOF | sudo tee -a /etc/hosts\n%s\nEOF", 
#     join("\n",
#       [ for idx, vm in {
#           for idx, vm in local.VMs: "${idx}-${vm.os}" => vm
#       }: format("%s %s", libvirt_domain.domain-os[idx].network_interface.0.addresses[0], vm.hostname) 
#       ]
#     )
#   )
#   depends_on = [libvirt_domain.domain-os]
# }


output "VMs" {
  value = [ for idx, vm in {
          for idx, vm in local.VMs: "${idx}-${vm.os}" => vm
      }: format("ssh %s@%s %s", vm.os, libvirt_domain.domain-os[idx].network_interface.0.addresses[0], libvirt_domain.domain-os[idx].name) 
  ]
  
  depends_on = [libvirt_domain.domain-os]
}

output "etcHosts" {
  value = format("cat << EOF | sudo tee -a /etc/hosts\n%s\nEOF", 
    join("\n",
      [ for idx, vm in {
          for idx, vm in local.VMs: "${idx}-${vm.os}" => vm
      }: format("%s %s", libvirt_domain.domain-os[idx].network_interface.0.addresses[0], libvirt_domain.domain-os[idx].name) 
      ]
    )
  )
  depends_on = [libvirt_domain.domain-os]
}