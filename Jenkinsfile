node {

  git 'https://github.com/ghassencherni/wordpress_k8s.git'
  withCredentials([usernamePassword(credentialsId: 'aws_credentials', usernameVariable: 'ACCESS_KEY', passwordVariable: 'SECRET_ACCESS')]) 
{

  if(action == 'Deploy Wordpress') {
    

    stage('Getting "config" and "rds_conn_configmap.yaml"') {
      copyArtifacts filter: 'service_wordpress.yaml, rds_conn_configmap.yaml, config', fingerprintArtifacts: true, projectName: 'terraform_aws_eks', selector: upstream(fallbackToLastSuccessful: true)
    }
    stage('Create Persistent Volume') {
      sh """
          export AWS_ACCESS_KEY_ID='$ACCESS_KEY'
          export AWS_SECRET_ACCESS_KEY='$SECRET_ACCESS'
          export KUBECONFIG=config
          kubectl apply -f persistentVolume.yaml
         """
      }
    stage('Create the ConfigMap') {
      sh """
          export AWS_ACCESS_KEY_ID='$ACCESS_KEY'
          export AWS_SECRET_ACCESS_KEY='$SECRET_ACCESS'
          export KUBECONFIG=config
          kubectl apply -f rds_conn_configmap.yaml
         """
      }
    stage('Create/update the Deployment') {
      sh """
          export IMAGE_VERSION='$wordpress_image_version'
          export AWS_ACCESS_KEY_ID='$ACCESS_KEY'
          export AWS_SECRET_ACCESS_KEY='$SECRET_ACCESS'
          export KUBECONFIG=config
          envsubst < deployment-wordpress.yaml | kubectl apply -f -
         """
      }
    stage('Create the LB Service') {
      sh """
          export AWS_ACCESS_KEY_ID='$ACCESS_KEY'
          export AWS_SECRET_ACCESS_KEY='$SECRET_ACCESS'    
          sleep 20
          export KUBECONFIG=config
          kubectl apply -f service_wordpress.yaml
         """
      }
    stage('Get the LB wordpress URL') {
      sh """
          export AWS_ACCESS_KEY_ID='$ACCESS_KEY'
          export AWS_SECRET_ACCESS_KEY='$SECRET_ACCESS'
          sleep 20
          export KUBECONFIG=config
          kubectl get service/wordpress-service
         """
      }
    }


if(action == 'Destroy Wordpress') {

    stage('Delete the LB Service') {
      sh """
          export AWS_ACCESS_KEY_ID='$ACCESS_KEY'
          export AWS_SECRET_ACCESS_KEY='$SECRET_ACCESS'
          export KUBECONFIG=config
          kubectl delete service/wordpress-service
         """
      }
    stage('Delete the Deployment') {
      sh """
          export AWS_ACCESS_KEY_ID='$ACCESS_KEY'
          export AWS_SECRET_ACCESS_KEY='$SECRET_ACCESS'
          export KUBECONFIG=config
          kubectl delete deployment/wordpress-deployment
         """
      }
    stage('Delete the ConfigMap') {
      sh """
          export AWS_ACCESS_KEY_ID='$ACCESS_KEY'
          export AWS_SECRET_ACCESS_KEY='$SECRET_ACCESS'
          export KUBECONFIG=config
          kubectl delete configmap/rds-conn
         """
      }
    stage('Delete the Persistent Volume') {
      sh """
          export AWS_ACCESS_KEY_ID='$ACCESS_KEY'
          export AWS_SECRET_ACCESS_KEY='$SECRET_ACCESS'
          export KUBECONFIG=config
          kubectl delete persistentvolumeclaim/wp-pv-claim
         """
      }
   }
 }
}
