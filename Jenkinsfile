pipeline {
    agent any

    environment {
        S3_BUCKET = 'tracerresources'            // Your S3 bucket name
        AWS_REGION = 'eu-north-1'                // Your AWS region
        TF_PLAN_FILE = 'tfplan.out'              // Binary plan file name
        TF_PLAN_TEXT_FILE = 'tfplan.txt'         // Human-readable plan output
        TF_VAR_FILE = 'dev.tfvars'               // Path to your vars.tf file (assuming it's in the 'terraform' folder)
        TF_MAIN_FILE = 'main.tf'                 // Path to your main.tf file (assuming it's in the 'terraform' folder)
        TERRAFORM_DIR = 'terraform'              // Directory where Terraform files are located
    }

    stages {
        stage('Checkout') {
            steps { 
                git branch: "${env.BRANCH_NAME}", credentialsId: '2159dd14-bf38-4ba6-8766-f73495d80fac', url: 'https://github.com/reachvigneshmohan/dockerimages.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'terraform-aws-credentials' // The credentials ID you set in Jenkins
                ]]) {
                    dir("${TERRAFORM_DIR}") {   // Ensure you're in the correct directory
                        script {
                            // Initialize Terraform
                            sh 'terraform init'
                        }
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'terraform-aws-credentials' // The credentials ID you set in Jenkins
                ]]) {
                    dir("${TERRAFORM_DIR}") {   // Ensure you're in the correct directory
                        script {
                            // Generate the Terraform plan and save it
                            sh """
                            terraform plan -out=${TF_PLAN_FILE} -var-file=${TF_VAR_FILE} | tee ${TF_PLAN_TEXT_FILE}
                            """
                        }
                    }
                }
            }
        }

        stage('Save Plan to S3') {
            steps {
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'terraform-aws-credentials' // The credentials ID you set in Jenkins
                ]]) {
                    script {
                        // Upload the human-readable plan to S3
                        sh """
                        aws s3 cp ${TERRAFORM_DIR}/${TF_PLAN_TEXT_FILE} s3://${S3_BUCKET}/plans/${TF_PLAN_TEXT_FILE} --region ${AWS_REGION}
                        """
                    }
                }
            }
        }

        stage('Manual Approval') {
            steps {
                // Wait for manual input from a user to approve or reject the plan
                input message: 'Do you approve the Terraform plan?', ok: 'Approve'
            }
        }

        stage('Terraform Apply') {
            steps {
                // terraform apply ${TF_PLAN_FILE}
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'terraform-aws-credentials' // The credentials ID you set in Jenkins
                ]]) {
                    dir("${TERRAFORM_DIR}") {   // Ensure you're in the correct directory
                        script {
                            // Apply the Terraform plan using the binary plan file
                            sh """
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace after the build
            cleanWs()
        }
    }
}
