pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'my-ubuntu-webserver'
        SSH_CREDENTIALS_ID = 'DockerHost'
        HOST = 'ubuntu@54.90.117.217'
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone the repository from GitHub on the Jenkins server
                git branch: 'main', credentialsId: 'sainadh30-GitHub', url: 'https://github.com/sainadh30/dockerpipeline.git'
            }
        }

        stage('Clean Up Docker Resources') {
            steps {
                script {
                    sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
                        // Remove any existing Docker container with the same name and any existing Docker image with the same name
                        sh """
                            ssh -o StrictHostKeyChecking=no ${env.HOST} "
                                docker rm -f ${env.DOCKER_IMAGE_NAME} || true
                                docker rmi ${env.DOCKER_IMAGE_NAME} || true
                            "
                        """
                    }
                }
            }
        }

        stage('Perform Remote Operations') {
            steps {
                script {
                    sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
                        // Build the Docker image
                        sh """
                            ssh -o StrictHostKeyChecking=no ${env.HOST} "
                                cd /home/ubuntu/dockerpipeline && 
                                docker build -t ${env.DOCKER_IMAGE_NAME} .
                            "
                        """

                        // Run the Docker container
                        sh """
                            ssh -o StrictHostKeyChecking=no ${env.HOST} "
                                docker run -d -p 80:80 --name ${env.DOCKER_IMAGE_NAME} ${env.DOCKER_IMAGE_NAME}
                            "
                        """

                        // List all Docker images
                        sh """
                            ssh -o StrictHostKeyChecking=no ${env.HOST} "
                                docker images
                            "
                        """

                        // List all running Docker containers
                        sh """
                            ssh -o StrictHostKeyChecking=no ${env.HOST} "
                                docker ps
                            "
                        """
                    }
                }
            }
        }
    }
}
