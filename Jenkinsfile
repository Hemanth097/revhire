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
                    withKubeConfig([credentialsId: KUBECONFIG]) {
                        sh 'kubectl apply -f services.yaml'
                    }
                }
            }
        }
    }
}
