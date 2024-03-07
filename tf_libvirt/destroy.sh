#!/bin/bash
terraform destroy -auto-approve

for d in `echo k8scpnode k8wrknode1 k8wrknode2`
do 
   virsh -c qemu:///system undefine --domain $d
done
