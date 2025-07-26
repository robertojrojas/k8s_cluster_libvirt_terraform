variable "fs_share" {
  type = string
  default = "/data/k8s_cluster/fs_shared"
}

variable "fs_share_disk_size" {
  type = number
  default = 20 * 1024 * 1024 * 1024
}

locals {

    ssh_prv_key = "${pathexpand("~/.ssh/id_rsa")}"
    ssh_pub_key = "${pathexpand("~/.ssh/id_rsa.pub")}"
   
    etc_hosts_extra_script_path = "/usr/local/bin/etc_hosts_extra.sh"
    k8s_kubeadm_script_path     = "/usr/local/bin/kubeadm_script.sh"

     # Run k8s_cluster_libvirt_terraform/images/download_cloud_images.sh
    cloud_images_dir = "../images"
    cloud_images = {
        ubuntu       = "${local.cloud_images_dir}/oracular-server-cloudimg-amd64.img",
        fedora       = "${local.cloud_images_dir}/Fedora-Cloud-Base-Generic-42-1.1.x86_64.qcow2"
        rocky9       = "${local.cloud_images_dir}/Rocky-9-GenericCloud-Base-9.6-20250531.0.x86_64.qcow2"
        ubuntu-focal = "${local.cloud_images_dir}/focal-server-cloudimg-amd64.img"
    }

    k8scpnode   = "k8scpnode"
    k8swrknode  = "k8swrknode"
    storagenode = "storagenode"
    
    VMs = [
        {os="ubuntu", type=local.k8scpnode, idx=1, hostname="k8scp-ubuntu-1", ip="192.168.122.238", mac="52:54:00:b6:5b:ff"},
        {os="ubuntu", type=local.k8swrknode, idx=1, hostname="k8swr-ubuntu-1", ip="192.168.122.39", mac="52:54:00:3a:07:33"}, 
        {os="fedora", type=local.k8swrknode, idx=2, hostname="k8swr-fedora-2", ip="192.168.122.126", mac="52:54:00:42:ce:8c"},
        {os="rocky9", type=local.k8swrknode, virtiofs="1", idx=3, hostname="k8swr-rocky9-3", ip="192.168.122.17", mac="52:54:00:6e:d1:c8"},
        {os="ubuntu-focal", type=local.storagenode, idx=4, hostname="storage-ubuntu-focal-4", ip="192.168.122.159", mac="52:54:00:d6:f6:25"},
    ]
    
    vm_spec = {
        k8scpnode = {
            prefix = "k8scp",
            vol_size = 80 * 1024 * 1024 * 1024,
            vcpu = 8,
            vmem = 8096,
        },
        k8swrknode = {
            prefix = "k8swr",
            vol_size = 80 * 1024 * 1024 * 1024,
            vcpu = 8,
            vmem = 8096,
        },
        storagenode = {
            prefix = "storage",
            vol_size = 80 * 1024 * 1024 * 1024,
            vcpu = 8,
            vmem = 8096,
        }
    }

    # TimeZone of the VM: /usr/share/zoneinfo/
    #timezone    = "Europe/Athens"
    timezone    = "US/Eastern"

    # The sshd port of the VM"
    ssh_port    = 22
   
}
