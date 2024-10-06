pipeline {
    agent any
    
    environment {
        TF_WORKSPACE = 'dev'                             // Terraform workspace
        S3_BUCKET = 'your-s3-bucket-name'                // Replace with your S3 bucket name
        AWS_REGION = 'us-east-1'                         // Replace with your AWS region
        TF_PLAN_FILE = 'tfplan.out'                      // File to store the Terraform plan output
        TF_PLAN_TEXT_FILE = 'tfplan.txt'                 // Human-readable plan file
        TFSTATE_BUCKET = 'your-tfstate-s3-bucket'        // S3 bucket for storing tfstate
        TFSTATE_KEY = 'terraform/state/terraform.tfstate' // S3 key for the tfstate file
    }

    stages {
        stage('Checkout Repository') {
            steps {
                // Checkout your repository containing the Terraform configuration
                git branch: 'main', url: 'git@github.com:your-repo/your-terraform-repo.git'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh """
                    terraform init \
                      -backend-config="bucket=${TFSTATE_BUCKET}" \
                      -backend-config="key=${TFSTATE_KEY}" \
                      -backend-config="region=${AWS_REGION}"
                    """
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Generate the Terraform plan and save it to a file (binary plan for apply)
                    sh """
                    terraform plan -out=${TF_PLAN_FILE} | tee ${TF_PLAN_TEXT_FILE}
                    """
                    // The `tee` command displays the plan in the logs and saves it to a human-readable file (tfplan.txt)
                }
            }
        }

        stage('Save Plan Output to S3') {
            steps {
                script {
                    // Copy the human-readable Terraform plan file (tfplan.txt) to S3
                    sh """
                    aws s3 cp ${TF_PLAN_TEXT_FILE} s3://${S3_BUCKET}/plans/${TF_PLAN_TEXT_FILE} --region ${AWS_REGION}
                    """
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
                script {
                    // Apply the Terraform plan from the saved binary plan file (tfplan.out)
                    sh """
                    terraform apply ${TF_PLAN_FILE}
                    """
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
