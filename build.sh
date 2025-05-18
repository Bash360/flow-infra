#!/bin/bash
set -e 

set -x

STACK="main"
PULUMI_DIR="./pulumi"
ANSIBLE_DIR="./ansible"

export PUB_KEY_LOCATION="$HOME/.ssh/ec2-key.pub"
export PRIV_KEY_LOCATION="$HOME/.ssh/ec2-key"
export USER=ubuntu

function createServer(){
echo $PULUMI_ACCESS_TOKEN
echo "Pulumi stack $STACK"
echo "Provisioning infrastructure..."


cd $PULUMI_DIR
pulumi stack select $STACK
pulumi up --yes
export FLOW_IP=$(pulumi stack output publicIp)
echo "Pulumi public IP: $FLOW_IP"
cd ..
}

function setUpServer(){
echo "Setting up virtual server"
cd "$ANSIBLE_DIR"
ansible-playbook -i inventory.yml playbook.yml
echo "Server setup done"
}


createServer
setUpServer



