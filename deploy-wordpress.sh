#/bin/bash

# Loads the needed parms to connect to our EKS (kubeconfig file) and to allow wordpress to reach our DB (RDS AWS) 
export KUBECONFIG=config

# Create the configmap that contains the RDS connexion params
echo "Creating ConfigMap .."
kubectl create -f rds_conn_configmap.yaml

# Create a persisant volume to be shared between PODS
echo "Creating Persistent Volume .."
kubectl create -f persistentVolume.yaml
sleep 5

# Create the deployement ( by default it runs two PODS )
echo "Creating the wordpress deployment .." 
kubectl create -f deployment-wordpress.yaml
sleep 20
echo "Wordpress deployment created"

# Create the loadbalance service, AWS will automatically build an ELB 
echo "Creating the wordpress ELB .."
kubectl create -f service_wordpress.yaml
sleep 10
echo "Wordpress ELB created"
