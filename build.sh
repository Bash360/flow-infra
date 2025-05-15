#!/bin/bash
set -e 

STACK="main"
PULUMI_DIR="./pulumi"
ANSIBLE_DIR="./ansible"


function createServer(){
echo "Pulumi stack $Stack"
echo "Provisioning infrastructure..."


cd $PULUMI_DIR
pulumi stack select $STACK
pulumi up --yes
}

createServer



