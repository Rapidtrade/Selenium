pipeline {
  agent any
  stages {
    stage('initialize') {
      parallel {
        stage('initialize') {
          steps {
            sh '''npm install
mocha bishop/rapidtrade/test-admin-core.js --timeout 600000'''
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