pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'

        FRONTEND_REPO = '449386169443.dkr.ecr.us-east-2.amazonaws.com/devops-challenge-frontend'
        BACKEND_REPO  = '449386169443.dkr.ecr.us-east-2.amazonaws.com/devops-challenge-backend'
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    sh 'docker build -t frontend:latest ./frontend'
                    sh 'docker build -t backend:latest ./backend'
                }
            }
        }

        stage('Authenticate to Amazon ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {
                    sh '''
                        aws --version

                        aws ecr get-login-password --region $AWS_REGION | docker login \
                            --username AWS \
                            --password-stdin 449386169443.dkr.ecr.us-east-2.amazonaws.com
                    '''
                }
            }
        }

        stage('Tag and Push Images') {
            steps {
                sh '''
                    docker tag frontend:latest $FRONTEND_REPO:latest
                    docker tag backend:latest $BACKEND_REPO:latest

                    docker push $FRONTEND_REPO:latest
                    docker push $BACKEND_REPO:latest
                '''
            }
        }

        stage('Update ECS Services') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {
                    sh '''
                        aws ecs update-service \
                            --cluster devops-challenge-cluster \
                            --service devops-challenge-frontend-service \
                            --force-new-deployment \
                            --region $AWS_REGION

                        aws ecs update-service \
                            --cluster devops-challenge-cluster \
                            --service devops-challenge-backend-service \
                            --force-new-deployment \
                            --region $AWS_REGION
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }

        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}