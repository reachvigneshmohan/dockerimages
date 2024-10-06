pipeline {
    agent any

    environment {
        S3_BUCKET = 'tracerresources'            // Replace with your S3 bucket name
        AWS_REGION = 'eu-north-1'                     // Replace with your AWS region
        TF_PLAN_FILE = 'tfplan.out'                  // Binary plan file name
        TF_PLAN_TEXT_FILE = 'tfplan.txt'             // Human-readable plan output
        TF_VAR_FILE = 'terraform/dev.tfvars'                      // Path to your vars.tf file
        TF_MAIN_FILE = 'terraform/main.tf'                     // Path to your main.tf file
    }
    stages {
        stage('Install Terraform') {
            steps {
                script {
                    // Check if Terraform is installed and install it if not
                    sh """
                    if ! command -v terraform &> /dev/null
                    then
                        echo "Terraform not found. Installing Terraform..."
                        curl -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
                        unzip terraform.zip
                        sudo mv terraform /usr/local/bin/
                        rm terraform.zip
                    else
                        echo "Terraform is already installed."
                    fi
                    terraform --version
                    """
                }
            }
        }
        stage('Checkout') {
            steps { 
                git branch: "${env.BRANCH_NAME}", credentialsId: '2159dd14-bf38-4ba6-8766-f73495d80fac', url: 'https://github.com/reachvigneshmohan/dockerimages.git'
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Generate the Terraform plan using the specified vars.tf and main.tf
                    // If vars.tf is in the same directory as main.tf, just use -var-file
                    sh """
                    terraform plan -out=${TF_PLAN_FILE} -var-file=${TF_VAR_FILE} | tee ${TF_PLAN_TEXT_FILE}
                    """
                    // The `tee` command displays the plan in the logs and saves it to a human-readable file (tfplan.txt)
                }
            }
        }

        stage('Save Plan to S3') {
            steps {
                script {
                    // Upload the human-readable plan to S3
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
                    // Apply the Terraform plan using the binary plan file
                    // terraform apply ${TF_PLAN_FILE}
                    sh """
                    terraform --version
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
