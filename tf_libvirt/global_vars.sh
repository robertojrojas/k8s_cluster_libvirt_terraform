#!/bin/bash

function get_distro() {
    if [[ -f /etc/os-release ]]
    then
        # On Linux systems
        source /etc/os-release
        echo $ID
    else
        # On systems other than Linux (e.g. Mac or FreeBSD)
        uname
    fi
}
export VAR_RUNTIME_LINUX_OS=`get_distro`
echo "OS ID: ${VAR_RUNTIME_LINUX_OS}"
