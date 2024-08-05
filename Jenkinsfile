pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'my-ubuntu-webserver'
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone the repository from GitHub
                git branch: 'main', credentialsId: 'sainadh30-GitHub', url: 'https://github.com/sainadh30/dockerpipeline.git'
            }
        }

        stage('Docker Build') {
            steps {
                // Build the Docker image
                sh "docker build -t ${env.DOCKER_IMAGE_NAME} ."
            }
        }

        stage('Run Docker Container') {
            steps {
                // Run the Docker container
                sh "docker run -d -p 80:80 --name ${env.DOCKER_IMAGE_NAME} ${env.DOCKER_IMAGE_NAME}"
            }
        }

        stage('List Docker Images') {
            steps {
                // List all Docker images
                sh "docker images"
            }
        }

        stage('List Running Containers') {
            steps {
                // List all running Docker containers
                sh "docker ps"
            }
        }
    }
}
