set -e 
#!/bin/bash



STACK="main"
PULUMI_DIR="./pulumi"

function destroyServer(){
read -p "About to destroy server on $STACK Enter Y/N: " ANSWER
case "$ANSWER"  in 
   ([yY] | [yY][eE][sE])
    echo "Pulumi stack $Stack"
    echo "Deleting ec2..."
    cd $PULUMI_DIR
    pulumi stack select $STACK
    pulumi destroy --yes
    exit 0
       ;;

    ([nN] | [nN][oO])

        exit 0
        ;;
    *)
        echo "Please enter y/yes or n/no"
        ;;

esac
   
}

echo "this program will destroy your ec2 instance"
 read -p "Type delete to proceed: " ANSWER

if [ "$ANSWER" == "delete" ]; then 

   destroyServer

else 
  echo "operation cancelled"
  exit 0 

fi


