#!/usr/bin/env bash

mkdir /home/vagrant/certs

CHEF_USER="ravish"
CHEF_USER_FNAME="Ravish"
CHEF_USER_LNAME="Tiwari"
CHEF_USER_EMAIL="ravishktiwari@hotmail.com"
CHEF_PASSWD="!@#xyz45"
CHEF_KEY_FILE="/home/vagrant/certs/${CHEF_USER}-key.pem"
ORG_SHORT="morg"
ORG_NAME="my organization"
ORG_USER=$CHEF_USER
ORG_KEY="/home/vagrant/certs/${ORG_SHORT}-validator-key.pem"

function install() {
	apt-get update -y -qq > /dev/null
	apt-get upgrade -y -qq > /dev/null
	apt-get -y -q install linux-headers-$(uname -r) build-essential > /dev/null

	echo -e "\033[32m Downloading Chef.  \033[0m"
	echo -e "\033[32m ============================  \033[0m"
	wget -P /tmp https://packages.chef.io/files/stable/chef-server/12.17.33/ubuntu/16.04/chef-server-core_12.17.33-1_amd64.deb > /dev/null
	dpkg -i /tmp/chef-server-core_12.17.33-1_amd64.deb

	chown -R vagrant:vagrant /home/vagrant

	chef-server-ctl reconfigure
	printf "\033c"
}

function create_user() {
	echo -e "\033[32m Creating Chef admin user.  \033[0m"
	echo -e "\033[32m ============================  \033[0m"
	sudo chef-server-ctl user-create \
	$CHEF_USER \
	$CHEF_USER_FNAME \
	$CHEF_USER_LNAME \
	$CHEF_USER_EMAIL \
	$CHEF_PASSWD \
	--filename "${CHEF_KEY_FILE}.pem"
}

function create_org() {
	echo -e "\033[32m Creating Chef Organization.  \033[0m"
	echo -e "\033[32m ============================  \033[0m"
	sudo chef-server-ctl org-create $ORG_SHORT $ORG_NAME \
	--association_user $CHEF_USER --filename $ORG_KEY
}


# chef-server-ctl install chef-manage
# chef-server-ctl reconfigure
# chef-manage-ctl reconfigure --accept-license

function install_manage() {
	echo -e "\033[32m Chef install additional tools.  \033[0m"
	echo -e "\033[32m ============================  \033[0m"
	sudo chef-server-ctl  install chef-manage --accept-license
	sudo chef-server-ctl reconfigure
	sudo chef-manage-ctl reconfigure
}

install
echo "\n\n"
create_user
echo "\n\n"
create_org
echo "\n\n"
install_manage
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

printf "\033c"
echo -e "\033[32m Chef Console is ready: \n\t\t http://chef.server with \n\t\tlogin: $CHEF_USER \n\t\tpassword: $CHEF_PASSWD"
