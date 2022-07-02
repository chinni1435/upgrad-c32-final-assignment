pipeline {
  agent any
  environment {
        registry = "374590584164.dkr.ecr.us-east-1.amazonaws.com/upgrad-assignment"
    }
    
  stages {
    stage ('Git checkout') {
      steps {
          git branch: 'main', url: 'https://github.com/chinni1435/upgrad-c32-final-assignment' 
      }
    }
    stage ('Docker build and Push') {
      steps {
            sh 'cd /home/ubuntu/upgrad-c32-final-assignment'
            sh 'sudo docker build . -t ${registry}:${env.BUILD_NUMBER}'
            sh 'sudo aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 374590584164.dkr.ecr.us-east-1.amazonaws.com'
            sh 'sudo docker push ${registry}:${env.BUILD_NUMBER}'
      }
    
    }
    stage ('Docker Deployment') {
      steps {
        script {
              sh ''' 
               ssh -i $SSH_KEY_FILE -o StrictHostKeyChecking=no ubuntu@10.0.1.59 
               '
                  
               '
              
              '''       
        }
      
      }
    
    }
  
  }
}
