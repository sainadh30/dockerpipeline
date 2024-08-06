pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'my-ubuntu-webserver'
        SSH_CREDENTIALS_ID = 'DockerHost'
        HOST = 'ubuntu@54.90.117.217'
        REPO_PATH = '/home/ubuntu'
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone the repository from GitHub
                git branch: 'main', credentialsId: 'sainadh30-GitHub', url: 'https://github.com/sainadh30/dockerpipeline.git'
            }
        }

        stage('Perform Remote Operations') {
            steps {
                script {
                    sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
                        // Clean up existing Docker resources
                        sh """
                            ssh -o StrictHostKeyChecking=no ${env.HOST} "
                                docker rm -f ${env.DOCKER_IMAGE_NAME} || true && 
                                docker rmi ${env.DOCKER_IMAGE_NAME} || true
                            "
                        """

                        // Build the Docker image
                        sh """
                            ssh -o StrictHostKeyChecking=no ${env.HOST} "
                                cd ${env.REPO_PATH} && 
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
