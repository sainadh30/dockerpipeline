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

        stage('Prepare Remote Host') {
            steps {
                script {
                    sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
                        // Ensure the repository is cloned on the remote host
                        sh """
                            ssh -o StrictHostKeyChecking=no ${env.HOST} "
                                if [ ! -d /home/ubuntu/dockerpipeline ]; then
                                    mkdir -p /home/ubuntu/dockerpipeline &&
                                    cd /home/ubuntu/dockerpipeline &&
                                    git clone https://github.com/sainadh30/dockerpipeline.git . &&
                                    git checkout main
                                fi
                            "
                        """
                    }
                }
            }
        }

        stage('Clean Up Existing Docker Resources') {
            steps {
                script {
                    sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
                        // Remove any existing Docker container and image on the remote host
                        sh """
                            ssh -o StrictHostKeyChecking=no ${env.HOST} "
                                docker rm -f ${env.DOCKER_IMAGE_NAME} || true &&
                                docker rmi ${env.DOCKER_IMAGE_NAME} || true
                            "
                        """
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
                        // Build the Docker image on the remote host without using cache
                        sh """
                            ssh -o StrictHostKeyChecking=no ${env.HOST} "
                                cd /home/ubuntu/dockerpipeline &&
                                docker build --no-cache -t ${env.DOCKER_IMAGE_NAME} .
                            "
                        """
                    }
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
                        // Run the Docker container on the remote host
                        sh """
                            ssh -o StrictHostKeyChecking=no ${env.HOST} "
                                docker run -d -p 80:80 --name ${env.DOCKER_IMAGE_NAME} ${env.DOCKER_IMAGE_NAME}
                            "
                        """
                    }
                }
            }
        }

        stage('List Docker Images') {
            steps {
                script {
                    sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
                        // List all Docker images on the remote host
                        sh """
                            ssh -o StrictHostKeyChecking=no ${env.HOST} "
                                docker images
                            "
                        """
                    }
                }
            }
        }

        stage('List Running Containers') {
            steps {
                script {
                    sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
                        // List all running Docker containers on the remote host
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
