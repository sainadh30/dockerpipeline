pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'my-ubuntu-webserver'
    }

    stages {
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
