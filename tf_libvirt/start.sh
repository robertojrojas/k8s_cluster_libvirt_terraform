#!/bin/bash
terraform plan -out terraform.out && terraform apply terraform.out

./tf_out.sh
