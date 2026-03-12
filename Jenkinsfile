pipeline{
  agent any

  environment {
    IMAGE_NAME = "eswarmaganti/portfolio"
    IMAGE_TAG = "${BUILD_NUMBER}"
    CONTAINER_NAME = "portfolio_local_test"
    DOCKERHUB_USER = "eswarmaganti"
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
          mkdir -p ssl
          openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./ssl/tls.key -out ./ssl/tls.crt -subj "/CN=portfolio.eswarmaganti.local"

          docker run -d -p 8000:443 \
          --mount type=bind,src=$(pwd)/ssl,target=/etc/nginx/ssl \
          --name ${CONTAINER_NAME} ${IMAGE_NAME}:${IMAGE_TAG}

          curl -fk https://localhost:8000

          docker container stop ${CONTAINER_NAME}
          docker container rm ${CONTAINER_NAME}
        '''
      }
    }
    stage("Docker CLI Login") {
      steps {
        withCredentials([string(credentialsId: "dockerhub_pat", variable: "DOCKERHUB_PAT")]){
          sh '''
            echo ${DOCKERHUB_PAT} | docker login -u eswarmaganti
          '''
        }
      }
    }

    stage("Push Image to Artifactory") {
      steps {
        sh '''
          docker image push ${IMAGE_NAME}:${IMAGE_TAG}
        '''
      }
    }

  }
}