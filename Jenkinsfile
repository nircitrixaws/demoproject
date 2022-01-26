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
          sh 'docker build -t dockerImagename_py+":$BUILD_NUMBER"  "$WORKSPACE"/flask'
        }
      }
    stage('Push Image-py') {
      steps{
        withCredentials([usernamePassword(credentialsId: 'dochub-cred', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
          sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
          sh 'docker push dockerImagename_py+":$BUILD_NUMBER"'
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
