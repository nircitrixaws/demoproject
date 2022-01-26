pipeline {
  environment {
    dockerImagename_py = "nircitrixaws/demo_py"
    dockerImagename_mysql = "nircitrixaws/demo_mysql"
    dockerImage = ""
    dockerImage-new = ""
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
              dockerImage= docker.build dockerImagename_py + ":$BUILD_NUMBER"
            }
          }
        }
      }
    stage('Push Image') {
      steps{
        environment {
          DOCKERHUB_CREDENTIALS=credentials('dochub-cred')
        }
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
       script {
         dockerImage = docker.build dockerImagename_mysql + ":$BUILD_NUMBER" "$WORKSPACE"/mysql
       }
     }
   }
   stage('Push Image') {
      steps{
        environment {
          dockerImage = ""
        }
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
            dockerImage.push()
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
