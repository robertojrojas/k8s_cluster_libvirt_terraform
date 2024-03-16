#!/bin/bash

domains=$(terraform output -json | jq .VMs.value | grep -i k8 | tr '"' " " | awk '{print $2}')
terraform destroy -auto-approve

for d in ${domains}
do 
   echo "removing $d"
   virsh -c qemu:///system dominfo --domain $d &> /dev/null
   [ $? -eq 0 ] && virsh -c qemu:///system undefine --domain $d
   [ $? -eq 0 ] || echo "$d already removed"
done
