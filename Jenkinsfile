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
                        // Clone the repository on the remote host
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
                        // Clean up existing Docker containers and images
                        sh """
                            ssh -o StrictHostKeyChecking=no ${env.HOST} "
                                docker ps -a -q -f name=${env.DOCKER_IMAGE_NAME} | xargs -r docker rm &&
                                docker images -q ${env.DOCKER_IMAGE_NAME} | xargs -r docker rmi
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
