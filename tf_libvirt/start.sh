#!/bin/bash

source global_vars.sh

terraform plan -var "runtime_linux_os=${VAR_RUNTIME_LINUX_OS}" -out terraform.out && terraform apply -var "runtime_linux_os=${VAR_RUNTIME_LINUX_OS}" -no-color terraform.out
#terraform plan -var "runtime_linux_os=${VAR_RUNTIME_LINUX_OS}" -out terraform.out && TF_LOG=debug terraform apply -var "runtime_linux_os=${VAR_RUNTIME_LINUX_OS}" -no-color terraform.out |& tee apply.txt
