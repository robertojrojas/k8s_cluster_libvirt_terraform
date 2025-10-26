#!/bin/bash
terraform plan -out terraform.out && terraform apply -no-color terraform.out
#terraform plan -out terraform.out && TF_LOG=debug terraform apply -no-color terraform.out |& tee apply.txt
