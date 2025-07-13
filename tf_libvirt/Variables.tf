locals {

    ssh_prv_key = "${pathexpand("~/.ssh/id_rsa")}"
    ssh_pub_key = "${pathexpand("~/.ssh/id_rsa.pub")}"

    # Run own/k8s_cluster_libvirt_terraform/images/download_cloud_images.sh
    etc_hosts_extra_script_path = "/usr/local/bin/etc_hosts_extra.sh"
    k8s_kubeadm_script_path     = "/usr/local/bin/kubeadm_script.sh"

    cloud_images = {
        ubuntu = "../images/oracular-server-cloudimg-amd64.img",
        fedora = "../images/Fedora-Cloud-Base-Generic-42-1.1.x86_64.qcow2"
        rocky9 = "../images/Rocky-9-GenericCloud-Base-9.6-20250531.0.x86_64.qcow2"
    }

    VMs = [
        {os="ubuntu", type="k8scpnode", idx=1},
        {os="ubuntu", type="k8swrknode", idx=1}, 
        {os="fedora", type="k8swrknode", idx=2},
        {os="rocky9", type="k8swrknode", idx=3},
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
        }
    }

    # TimeZone of the VM: /usr/share/zoneinfo/
    #timezone    = "Europe/Athens"
    timezone    = "US/Eastern"

    # The sshd port of the VM"
    ssh_port    = 22
   
}
