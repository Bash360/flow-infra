package main

import (
	"log"
	"os"

	"github.com/joho/godotenv"
	"github.com/pulumi/pulumi-aws/sdk/v6/go/aws/ec2"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
	err:=godotenv.Load()
	if err !=nil{
		log.Fatal(err)
	}
	pulumi.Run(func(ctx *pulumi.Context) error {
	
		accessKey:=os.Getenv("AWS_ACCESS_KEY_ID")
		accessSecret:=os.Getenv("AWS_SECRET_ACCESS_KEY")
		region:=os.Getenv("AWS_REGION")

		if accessKey == "" || accessSecret=="" || region =="" {
			log.Fatal("missing environment variables")
		}
		ami, err := ec2.LookupAmi(ctx, &ec2.LookupAmiArgs{
			Filters: []ec2.GetAmiFilter{
				{
					Name:   "name",
					Values: []string{"ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"},
				},
			},
			Owners:     []string{"099720109477"}, 
			MostRecent: pulumi.BoolRef(true),
		})
		if err != nil {
			return err
		}

	
		sg, err := ec2.NewSecurityGroup(ctx, "ssh-secgroup", &ec2.SecurityGroupArgs{
			Ingress: ec2.SecurityGroupIngressArray{
				&ec2.SecurityGroupIngressArgs{
					Protocol:   pulumi.String("tcp"),
					FromPort:   pulumi.Int(22),
					ToPort:     pulumi.Int(22),
					CidrBlocks: pulumi.StringArray{pulumi.String("0.0.0.0/0")},
				},
			},
		})
		if err != nil {
			return err
		}

	
		instance, err := ec2.NewInstance(ctx, "flow-server", &ec2.InstanceArgs{
			InstanceType:          pulumi.String("t3.micro"),
			Ami:                   pulumi.String(ami.Id),
			VpcSecurityGroupIds:   pulumi.StringArray{sg.ID()},
			AssociatePublicIpAddress: pulumi.Bool(true),
		})
		if err != nil {
			return err
		}

		ctx.Export("instanceId", instance.ID())
		ctx.Export("publicIp", instance.PublicIp)
		return nil
	})
}
