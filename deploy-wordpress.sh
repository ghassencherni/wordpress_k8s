#/bin/bash

# Loads the needed parms to connect to our EKS (kubeconfig file) and to allow wordpress to reach our DB (RDS AWS) 
source ../terraform_aws_eks/rds_kubeconfig.env


# Create a persisant volume to be shared between PODS
kubectl create -f persistentVolume.yml

# Create the deployement ( by default it runs two PODS )
kubectl create -f deployment-wordpress.yaml

# Create the loadbalance service, AWS will automatically build an ELB 
kubectl create -f service_wordpress.yml
