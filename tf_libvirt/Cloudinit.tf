resource "random_id" "id" {
  for_each   = {for idx, vm in local.VMs: "${idx}-${vm.os}" => vm}

  byte_length = 4
}

data "template_file" "user_data" {
  for_each   = {for idx, vm in local.VMs: "${idx}-${vm.os}" => vm}
 

  template = file(format("templates/user-data-%s.yml", each.value.os))
  vars = {
    hostname           = format("%s-%s-%d", local.vm_spec[each.value.type].prefix, each.value.os, each.value.idx)
    sshdport           = local.ssh_port
    timezone           = local.timezone
    ssh_pub_key        = data.local_file.ssh_pub_key_data.content
    user               = each.value.os
    k8s_kubeadm_script_path = local.k8s_kubeadm_script_path
    k8s_kubeadm_script = filebase64("${path.module}/../scripts/${each.value.type}-${each.value.os}.sh")
    etc_hosts_extra_script_path = local.etc_hosts_extra_script_path
  }
}

resource "libvirt_cloudinit_disk" "cloud-init" {
   for_each   = {for idx, vm in local.VMs: "${idx}-${vm.os}" => vm}

  name      = "${random_id.id[each.key].id}_cloud-init.iso"
  user_data = data.template_file.user_data[each.key].rendered

  depends_on = [data.template_file.user_data]
}

resource "time_sleep" "wait_for_cloud_init" {
  create_duration = "20s"

  depends_on = [libvirt_cloudinit_disk.cloud-init]
}


data "local_file" "ssh_pub_key_data" {
  filename = "${local.ssh_pub_key}"
}

