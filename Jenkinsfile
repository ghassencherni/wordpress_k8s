node {
  git 'https://github.com/ghassencherni/wordpress_k8s.git'

  if(action == 'Deploy Wordpress') {
    stage('Getting "config" and "rds_conn_configmap.yaml"') {
        copyArtifacts filter: 'rds_conn_configmap.yaml, config', fingerprintArtifacts: true, projectName: 'terraform_aws_eks', selector: lastSuccessful()
    }
    stage('Create Persistent Volume') {
      sh """
          export AWS_ACCESS_KEY_ID=${aws_access_key_id}
          export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
          export KUBECONFIG=config
          kubectl create -f persistentVolume.yaml
         """
      }
    stage('Create the ConfigMap') {
      sh """
          export AWS_ACCESS_KEY_ID=${aws_access_key_id}
          export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
          export KUBECONFIG=config
          kubectl create -f rds_conn_configmap.yaml
         """
      }
    stage('Create the Deployment') {
      sh """
          export AWS_ACCESS_KEY_ID=${aws_access_key_id}
          export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
          export KUBECONFIG=config
          kubectl create -f deployment-wordpress.yaml
         """
      }
    stage('Create the LB Service') {
      sh """
          export AWS_ACCESS_KEY_ID=${aws_access_key_id}
          export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
          export KUBECONFIG=config
          kubectl create -f service_wordpress.yaml
         """
      }
    stage('Get the LB wordpress URL') {
      sh """
          export AWS_ACCESS_KEY_ID=${aws_access_key_id}
          export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
          export KUBECONFIG=config
          kubectl get service/wordpress-service |  awk {'print $1" " $2 " " $4 " " $5'} | column -t
         """
      }
    }

  if(action == 'Destroy Wordpress') {
   
    stage('Delete the LB Service') {
      sh """
          export AWS_ACCESS_KEY_ID=${aws_access_key_id}
          export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
          export KUBECONFIG=config
          kubectl delete service/wordpress-service
         """
      }
    stage('Delete the Deployment') {
      sh """
          export AWS_ACCESS_KEY_ID=${aws_access_key_id}
          export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
          export KUBECONFIG=config
          kubectl delete deployment/wordpress-deployment
         """
      }
    stage('Delete the ConfigMap') {
      sh """
          export AWS_ACCESS_KEY_ID=${aws_access_key_id}
          export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
          export KUBECONFIG=config
          kubectl delete configmap/rds-conn
         """
      }
    stage('Delete the Persistent Volume') {
      sh """
          export AWS_ACCESS_KEY_ID=${aws_access_key_id}
          export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
          export KUBECONFIG=config
          kubectl delete persistentvolumeclaim/wp-pv-claim
         """
      }
   }

}

