pipeline {
    agent any 

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY') 
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY') 
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/roeigonnen/oren-roei-finel-work-.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh '''
                cd ${WORKSPACE}
                terraform init
                terraform validate
                terraform plan -out=tfplan
                terraform apply -auto-approve tfplan
                '''
            }
        }
    }
}