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
    stage("Local Container Test") {
      steps {
        sh '''
          # Generate an SSL cert pair
          mkdir ssl
          openssl req -x509 -nodes -days 365 --type -newkey rsa:2048 -keyout ./ssl/tls.key -out ./ssl/tls.crt -subj "/CN=portfolio.eswarmaganti.local"

          docker run -d -p 8000:443 \
          -v type=bind,$(pwd)/ssl:/etc/nginx/ssl \
          ${IMAGE_NAME}:${IMAGE_TAG}
        '''
      }
    }
    // stage("Docker CLI Login") {

    // }

    // stage("Push Image to Artifactory") {

    // }

  }
}