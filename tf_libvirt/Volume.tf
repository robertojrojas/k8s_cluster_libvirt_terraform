resource "libvirt_volume" "os-vol" {
  for_each   = {for idx, vm in local.VMs: "${idx}-${vm.os}" => vm}

  name = "${random_id.id[each.key].id}_os-vol"
  pool = "default"
  source = local.cloud_images[each.value.os]
  format = "qcow2"
}

resource "libvirt_volume" "os-base" {
  for_each   = {for idx, vm in local.VMs: "${idx}-${vm.os}" => vm}  


  name           = "${random_id.id[each.key].id}_os-base"
  pool           = "default"
  base_volume_id = libvirt_volume.os-vol[each.key].id
  size           = local.vm_spec[each.value.type].vol_size
  format         = "qcow2"
}
