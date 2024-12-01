#!/bin/bash

proxy_name="k8s-haproxy"
(docker kill ${proxy_name} && docker rm ${proxy_name}) >& /dev/null
