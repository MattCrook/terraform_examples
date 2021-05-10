#!/bin/bash

echo "Hello Terraform, V2" > index.html
nohup busybox httpd -f -p ${server_port} &
