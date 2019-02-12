pipeline {
  agent any
  stages {
    stage('initialize') {
      parallel {
        stage('initialize') {
          steps {
            sh '''npm install
ls'''
          }
        }
        stage('print message') {
          steps {
            echo 'finished'
          }
        }
      }
    }
  }
}