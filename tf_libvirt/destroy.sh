#!/bin/bash

source global_vars.sh
terraform destroy -var "runtime_linux_os=${VAR_RUNTIME_LINUX_OS}" -auto-approve
