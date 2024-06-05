pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "hemanth097/revhire:latest"
        KUBECONFIG = credentials('kubeconfig-credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Hemanth097/revhire.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                     // Use withCredentials to handle the kubeconfig file
                    withCredentials([file(credentialsId: 'kubeconfig-credentials', variable: 'KUBECONFIG_PATH')]) {
                        // Set the KUBECONFIG environment variable to the path of the kubeconfig file
                        withEnv(["KUBECONFIG=${KUBECONFIG_PATH}"]) {
                            if (isUnix()) {
                                // Run kubectl commands for Unix-based systems
                                sh 'kubectl version'
                                sh 'kubectl config current-context'
                                sh 'kubectl get nodes'
                                sh 'kubectl apply -f services.yaml'
                                sh 'kubectl rollout status deployment/revhire-deployment'
                                sh 'kubectl get pods'
                            } else {
                                // Run kubectl commands for Windows-based systems
                                bat 'kubectl version'
                                bat 'kubectl config current-context'
                                bat 'kubectl get nodes'
                                bat 'kubectl apply -f services.yaml'
                                bat 'kubectl rollout status deployment/revhire-deployment'
                                bat 'kubectl get pods'
                            }
                        }
                    }
                }
            }
        }
    }
}
