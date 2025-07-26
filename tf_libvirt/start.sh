#!/bin/bash
terraform plan -out terraform.out && terraform apply -no-color terraform.out
