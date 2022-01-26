pipeline {
  environment {
    dockerImagename_py = "nircitrixaws/demo_py"
    dockerImagename_mysql = "nircitrixaws/demo_mysql"
    dockerImage = ""
    DOCKERHUB_CREDENTIALS=credentials('dochub-cred')
  }
  agent any
    stages {
      stage('Checkout Source code') {
        steps {
          git 'https://github.com/nircitrixaws/demoproject.git'
        }
      }
      stage('python-current-dir') {
        steps{
          dir("${env.WORKSPACE}/flask"){
            sh "pwd"
          }
        }
      }
      stage('Build python image') {
        steps {
          dir("${env.WORKSPACE}/flask"){
            script {
              dockerImage= docker.build("dockerImagename_py + ":$BUILD_NUMBER"","-f ${WORKSPACE}/flask ./Dockerfile")
            }
          }
        }
      }
    stage('Push Image-py') {
      steps{
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
            dockerImage.push()
          }
        }
      }
    }
    stage('mysql-current-dir') {
      steps{
        dir("${env.WORKSPACE}/mysql"){
          sh "pwd"
        }
      }
    }
   stage('Build mysql image') {
     steps{
       dir("${env.WORKSPACE}/mysql"){
         script {
           dockerImage1= docker.build dockerImagename_py + ":$BUILD_NUMBER"
         }
       }
     }
   }
   stage('Push Image-mysql') {
      steps{      
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
            dockerImage1.push()
          }
        }
      }
    }
    stage('Deploy App') {
      steps {
        script {
          kubernetesDeploy(configs: "deploy.yaml", kubeconfigId: "kube")
        }
      }
    }
  }
}
