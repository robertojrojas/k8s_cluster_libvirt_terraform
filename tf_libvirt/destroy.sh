#!/bin/bash

domains=$(terraform output -json | jq .VMs.value | grep -i k8 | tr '"' " " | awk '{print $2}')
terraform destroy -auto-approve

echo "Destroying based on TF"
for d in ${domains}
do 
   echo "removing $d"
   virsh -c qemu:///system dominfo --domain $d &> /dev/null
   [ $? -eq 0 ] && virsh -c qemu:///system undefine --domain $d
   [ $? -eq 0 ] || echo "$d already removed"
done

echo "Destroying based on Libvirsh"
domains=$(virsh -c qemu:///system -q list --all | awk '{print $2}')
for d in ${domains}
do
   echo "removing $d"
   virsh -c qemu:///system dominfo --domain $d &> /dev/null
   [ $? -eq 0 ] && virsh -c qemu:///system undefine --domain $d
   [ $? -eq 0 ] || echo "$d already removed"
done

virsh -c qemu:///system -q list --all
