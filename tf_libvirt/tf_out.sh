#!/bin/bash

terraform output -json | jq .VMs.value