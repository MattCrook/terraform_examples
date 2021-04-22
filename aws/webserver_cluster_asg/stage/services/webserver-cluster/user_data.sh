#!/bin/bash

cat > index.html <<EOF
<h1>Hello, World</h1>
<p>DB address: ${db_address}</p>
<p>DB port: ${db_port}</p>
EOF

nohup busybox httpd -f -p ${server_port} &

# Updated script with using the template_file data source.
# Notice, uing TF's standard interpolation syntax, but only the vars available are the ones in vars map.
# Don't need prefix to access those vars; i.e var.server_port.
# Script now includes html syntax to make more readable.
# One advantage of extracting the user_data script on its own is that you can write a unit test for it. 
# Test code can even fill env variables because Bash syntax for looking up env vars is the same as TF's interpolation syntax.
# Test is done in user_data_test.sh




#####  Original #######
# This is messy on its own, and not best practice to have one language (Bash) embedded in another (TF).
# To solve this, using built-in function file(<PATH>) to read this file, and the template_file data source
# In stage/services/webserver-cluster/data.tf

# user_data = <<EOF
# #!/bin/bash
# echo "Hello, World" >> index.html
# echo "${data.terraform_remote_state.db.outputs.address}" >> index.html
# echo "${data.terraform_remote_state.db.outputs.port}" >> index.html
# nohup busybox http -f -p ${var.server_port} &
# EOF
