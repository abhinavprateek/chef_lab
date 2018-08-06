#!/usr/bin/env bash

function configure() {
	echo -e "\033[32m Creating CentOS Chef Node.  \033[0m"
	echo -e "\033[32m ============================  \033[0m"
	yum install -y wget curl git
	localedef -v -c -i en_US -f UTF-8 en_US.UTF-8
}

configure

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL
# vagrant environment nodes
10.0.15.10  chef.server
10.0.15.15  lb
10.0.15.21  webserver1
10.0.15.22  webserver2
10.0.15.23  webserver3
10.0.15.24  webserver4
10.0.15.25  webserver3
EOL
