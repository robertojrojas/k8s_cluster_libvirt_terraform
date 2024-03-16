locals {
    # Virtual Machines
    VMs = {
        k8scpnode = {
            # The host name of the VM
            hostname = "k8scpnode"

            # The image source of the VM
            #cloud_image = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
            cloud_image = "/home/rrojas/dev/practice/k8s/samples/kvm/k8s_cluster/images/jammy-server-cloudimg-amd64.img"

            # TimeZone of the VM: /usr/share/zoneinfo/
            timezone    = "America/New_York"

            # The sshd port of the VM
            ssh_port    = 22

            # The default ssh key for user ubuntu
            # https://github.com/<username>.keys
            gh_user = "robertojrojas"

            # The disk volume size of the VM
            # eg. 20G
            vol_size = 20 * 1024 * 1024 * 1024

            # How many virtual CPUs the VM
            vcpu = 8 

            # How RAM will VM have will have
            vmem = 8 * 1024

        },

        k8wrknode1 = {
            # The host name of the VM
            hostname = "k8wrknode1"

            # The image source of the VM
            # cloud_image = "https://cloud-images.ubuntu.com/jammy/current/focal-server-cloudimg-amd64.img"
            cloud_image = "/home/rrojas/dev/practice/k8s/samples/kvm/k8s_cluster/images/jammy-server-cloudimg-amd64.img"

            # TimeZone of the VM: /usr/share/zoneinfo/
            timezone    = "America/New_York"

            # The sshd port of the VM
            ssh_port    = 22

            # The default ssh key for user ubuntu
            # https://github.com/<username>.keys
            gh_user = "robertojrojas"

            # The disk volume size of the VM
            # eg. 40G
            vol_size = 40 * 1024 * 1024 * 1024

            # How many virtual CPUs the VM
            vcpu = 8 

            # How RAM will VM have will have
            vmem = 8 * 1024

        },

        k8wrknode2 = {
            # The host name of the VM
            hostname = "k8wrknode2"

            # The image source of the VM
            # cloud_image = "../jammy-server-cloudimg-amd64.img"
            cloud_image = "/home/rrojas/dev/practice/k8s/samples/kvm/k8s_cluster/images/jammy-server-cloudimg-amd64.img"

            # TimeZone of the VM: /usr/share/zoneinfo/
            timezone    = "America/New_York"

            # The sshd port of the VM
            ssh_port    = 22

            # The default ssh key for user ubuntu
            # https://github.com/<username>.keys
            gh_user = "robertojrojas"

            # The disk volume size of the VM
            # eg. 40G
            vol_size = 40 * 1024 * 1024 * 1024

            # How many virtual CPUs the VM
            vcpu = 8 

            # How RAM will VM have will have
            vmem = 8 * 1024

        }

        k8wrknode3 = {
            # The host name of the VM
            hostname = "k8wrknode3"

            # The image source of the VM
            # cloud_image = "../jammy-server-cloudimg-amd64.img"
            cloud_image = "/home/rrojas/dev/practice/k8s/samples/kvm/k8s_cluster/images/jammy-server-cloudimg-amd64.img"

            # TimeZone of the VM: /usr/share/zoneinfo/
            timezone    = "America/New_York"

            # The sshd port of the VM
            ssh_port    = 22

            # The default ssh key for user ubuntu
            # https://github.com/<username>.keys
            gh_user = "robertojrojas"

            # The disk volume size of the VM
            # eg. 40G
            vol_size = 40 * 1024 * 1024 * 1024

            # How many virtual CPUs the VM
            vcpu = 8

            # How RAM will VM have will have
            vmem = 8 * 1024

        }

    }
}
