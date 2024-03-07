#!/bin/bash
terraform plan -out terraform.out && terraform apply terraform.out

for v in `terraform output -json | jq .VMs.value | grep 192 | tr '"' " " | awk '{print $1}'`
do
   echo "ssh -i ./private_key.pem -l ubuntu $v";
done

