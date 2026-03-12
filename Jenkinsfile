pipeline{
  agent any

  environment {
    IMAGE_NAME = "eswarmaganti/portfolio"
    IMAGE_TAG = "${BUILD_NUMBER}"
  }

  stages{
    stage("Git Checkout") {
      steps {
        git branch: "main",
        url: "https://github.com/eswarmaganti/portfolio-website.git"
      }
    }
    stage("Dockerfile Linting") {
      steps {
        sh '''
          docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" --check .
        '''
      }
    }
    stage("Build Image") {
      steps {
        sh '''
          docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .
        '''
      }
    }
    // stage("Local Container Test") {

    // }
    // stage("Docker CLI Login") {

    // }

    // stage("Push Image to Artifactory") {

    // }

  }
}