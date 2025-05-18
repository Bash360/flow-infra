#!/bin/bash
set -e 




STACK="main"
PULUMI_DIR="./pulumi"

function destroyServer(){
local ATTEMPTS=0
local MAX_ATTEMPTS=2
while ((ATTEMPTS < MAX_ATTEMPTS)); do
read -p "About to destroy server on $STACK Enter Y/N: " ANSWER
case "$ANSWER"  in 
   [yY] | [yY][eE][sE])
    echo "Pulumi stack $STACK"
    echo "Deleting ec2..."
    cd "$PULUMI_DIR"
    pulumi stack select "$STACK"
    pulumi destroy --yes
    exit 0
       ;;

    [nN] | [nN][oO])
        echo "deleting cancelled"
        exit 0
        ;;
    *)
        ((ATTEMPTS++))
        ;;

esac

done

echo "Wrong input trials exceeded"
exit 1
   
}

echo "this program will destroy your ec2 instance"
 read -p "Type delete to proceed: " ANSWER

if [ "$ANSWER" == "delete" ]; then 

   destroyServer

else 
  echo "operation cancelled"
  exit 0 

fi


