pipeline {
    agent any
    environment {
        AWS_REGION = "us-east-1"  // הגדר את האזור המתאים
        VPC_ID = "vpc-099fdde38f98eac3d"  // VPC ID שלך
        PRIVATE_SUBNET_IDS = "subnet-082a99bcc991ec7b3,subnet-08590b68248b1367d"  // Private subnets
        PUBLIC_SUBNET_IDS = "subnet-0e67fc294a37cf45d,subnet-071011b991f7704aa"  // Public subnets
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
                // הוספת קרדנשיאלס של AWS
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding', 
                     accessKeyVariable: 'my-aws-access-key-id', 
                     secretKeyVariable: 'my-aws-secret-access-key']
                ]) {
                    script {
                        sh "terraform plan -out=tfplan -var aws_access_key=${my-aws-access-key-id} -var aws_secret_key=${my-aws-secret-access-key} -var region=${AWS_REGION} -var vpc_id=${VPC_ID} -var private_subnet_ids=[${PRIVATE_SUBNET_IDS}] -var public_subnet_ids=[${PUBLIC_SUBNET_IDS}]"
                    }
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                // הוספת שלב ההפעלה של Terraform
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding', 
                     accessKeyVariable: 'my-aws-access-key-id', 
                     secretKeyVariable: 'my-aws-secret-access-key']
                ]) {
                    script {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Cleaning up resources...'
        }
    }
}