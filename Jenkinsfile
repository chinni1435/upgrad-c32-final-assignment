pipeline {
  agent any
  environment {
        REGISTRY = "374590584164.dkr.ecr.us-east-1.amazonaws.com/upgrad-assignment"
        NAME = "nodeapp"
    }
    
  stages {
    stage ('Git checkout') {
      steps {
          git branch: 'main', url: 'https://github.com/chinni1435/upgrad-c32-final-assignment' 
      }
    }
    stage ('Docker build and Push') {
      steps {
            sh 'pwd'
            sh 'ls'
            sh 'cd ./$NAME'
            sh 'sudo docker build . -t ${registry}:${env.BUILD_NUMBER}'
            sh 'sudo aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 374590584164.dkr.ecr.us-east-1.amazonaws.com'
            sh 'sudo docker push ${REGISTRY}:${env.BUILD_NUMBER}'
      }
    
    }
    stage ('Docker Deployment') {
      steps {
        script {
              sh ''' 
               ssh -i $SSH_KEY_FILE -o StrictHostKeyChecking=no ubuntu@10.0.1.59 
               '
                  sh 'cd /home/ubuntu/ && sh pull_n_deploy.sh ${REGISTRY} ${env.BUILD_NUMBER} ${NAME}'
                  
               '
              
              '''       
        }
      
      }
    
    }
  
  }
}
