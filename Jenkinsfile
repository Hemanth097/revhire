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
                    withKubeConfig([credentialsId: env.KUBECONFIG]) {
                        // Print the kubectl version
                        sh 'kubectl version'
                        
                        // Print the current context to verify kubeconfig
                        sh 'kubectl config current-context'
                        
                        // List the nodes to check cluster connectivity
                        sh 'kubectl get nodes'
                        
                        // Apply the Kubernetes configuration
                        sh 'kubectl apply -f services.yaml'
                        
                        // Check the status of the deployment
                        sh 'kubectl rollout status deployment/revhire-deployment'
                        
                        // Get the list of pods to ensure the deployment was successful
                        sh 'kubectl get pods'
                }
            }
        }
    }
}
