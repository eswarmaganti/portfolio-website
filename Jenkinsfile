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
          echo "🔵 Performing Dockerfile Link Check "
          docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" --check .
          echo "🟢 Dockerfile Link Check successful "
        '''
      }
    }
    stage("Build Image") {
      steps {
        sh '''
          echo "🔵 Building the Docker Image "
          docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .
        '''
      }
    }
    stage("Local Container Test") {
      steps {
        sh '''
          # Generate an SSL cert pair
          echo "🔵 Generating a local self-signed SSL certs to test the image locally"
          mkdir -p ssl
          openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./ssl/tls.key -out ./ssl/tls.crt -subj "/CN=portfolio.eswarmaganti.local"

          echo "🔵 Running the container locally"

          docker run -d -p 8000:443 \
          --mount type=bind,src=$(pwd)/ssl,target=/etc/nginx/ssl \
          --name ${CONTAINER_NAME} ${IMAGE_NAME}:${IMAGE_TAG}

          curl -fk https://localhost:8000

          echo "🟢 Local Image Testing is successful"
          
          echo "🔵 Cleaning up the local container"
          docker container stop ${CONTAINER_NAME}
          docker container rm ${CONTAINER_NAME}

        '''
      }
    }
    stage("Docker CLI Login") {
      steps {
        withCredentials([string(credentialsId: "dockerhub_pat", variable: "DOCKERHUB_PAT")]){
          sh '''
            echo "🔵 Login to Docker Hub Artifactory"
            echo ${DOCKERHUB_PAT} | docker login -u eswarmaganti --password-stdin
          '''
        }
      }
    }

    stage("Push Image to Artifactory") {
      steps {
        sh '''
          echo "🔵 Publishing the image to Docker Hub Artifactory"
          docker image push ${IMAGE_NAME}:${IMAGE_TAG}
          echo "🟢 Successfully Published the Image to Docker Hub Artifactory"
        '''
      }
    }

  }
  post {
    success {
      echo "🚀 Successfully pushed the image top Docker Hub ${IMAGE_NAME}:${IMAGE_TAG}"
    }
    failure {
      echo "❌ Failed to push the image: Runtime exception occurred"
    }
  }
}