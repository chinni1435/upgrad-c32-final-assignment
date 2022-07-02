pipeline {
  agent {label 'worker'}
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
        script {
            sh '''
                pwd
                ls
                cd nodeapp
                ls
                sudo docker build . -t ${REGISTRY}:${BUILD_NUMBER}
                sudo aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 374590584164.dkr.ecr.us-east-1.amazonaws.com
                sudo docker push ${REGISTRY}:${BUILD_NUMBER}
                
               '''  
        }
      }
    
    }
    stage ('Docker Deployment') {
      steps {
        script {
          
           script {
             sshagent(credentials : ['ssh key']){
               
               sh ' ssh -t -t -o StrictHostKeyChecking=no -l ubuntu 10.0.1.59 "ls && cd /home/ubuntu && sh pull_n_deploy.sh ${REGISTRY} ${BUILD_NUMBER} ${NAME}" '
             }
        
                
            }
          
          
        }
      
      }
    
    }
  
  }
}
