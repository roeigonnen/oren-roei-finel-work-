pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('my-aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('my-aws-secret-access-key')
        AWS_REGION = "us-east-1"
        VPC_ID = "vpc-099fdde38f98eac3d"
        PRIVATE_SUBNET_IDS = '["subnet-082a99bcc991ec7b3","subnet-08590b68248b1367d"]'
        PUBLIC_SUBNET_IDS = '["subnet-0e67fc294a37cf45d","subnet-071011b991f7704aa"]'
    }
    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/roeigonnen/oren-roei-finel-work-.git', branch: 'main'
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Validate') {
            steps {
                script {
                    sh 'terraform validate'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    sh "terraform plan -out=tfplan -var aws_access_key=${AWS_ACCESS_KEY_ID} -var aws_secret_key=${AWS_SECRET_ACCESS_KEY} -var region=${AWS_REGION} -var vpc_id=${VPC_ID} -var private_subnet_ids=${PRIVATE_SUBNET_IDS} -var public_subnet_ids=${PUBLIC_SUBNET_IDS}"
                }
            }
        }
        // שלב ההפעלה של Terraform Apply יכול להיות כאן אם תרצה
    }
    post {
        always {
            echo 'Cleaning up resources...'
        }
    }
}