pipeline {
    agent any 

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY') 
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY') 
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    // Clone the repository from Git
                    git branch: 'main', url: 'https://github.com/roeigonnen/oren-roei-finel-work-.git'
                }
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    // Change to the workspace directory and run Terraform commands
                    dir("${WORKSPACE}") {
                        sh '''
                        terraform init
                        terraform validate
                        terraform plan -out=tfplan
                        terraform apply -auto-approve tfplan
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            // Actions to take on success, such as notifying the team or logging
            echo 'Pipeline completed successfully!'
        }
        failure {
            // Actions to take on failure, such as sending alerts
            echo 'Pipeline failed!'
        }
        cleanup {
            // Optional cleanup actions
            echo 'Cleaning up resources...'
        }
    }
}