// Terraform Validation and Deployment Pipeline
// UniCredit GCP Migration

pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Target environment')
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Terraform action')
        booleanParam(name: 'AUTO_APPROVE', defaultValue: false, description: 'Auto-approve apply/destroy')
    }

    environment {
        TF_IN_AUTOMATION = 'true'
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-service-account')
        TF_VAR_project_id = credentials('gcp-project-id')
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
        timeout(time: 1, unit: 'HOURS')
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup') {
            steps {
                sh '''
                    terraform --version
                    cd terraform/environments/${ENVIRONMENT}
                    terraform init -input=false
                '''
            }
        }

        stage('Validate') {
            steps {
                sh '''
                    cd terraform/environments/${ENVIRONMENT}
                    terraform validate
                '''
            }
        }

        stage('Checkov Scan') {
            steps {
                sh '''
                    pip install checkov --quiet
                    checkov -d terraform/environments/${ENVIRONMENT} \
                        --framework terraform \
                        --output cli \
                        --soft-fail
                '''
            }
        }

        stage('Plan') {
            steps {
                sh '''
                    cd terraform/environments/${ENVIRONMENT}
                    terraform plan -input=false -out=tfplan
                '''
            }
        }

        stage('Approval') {
            when {
                expression { params.ACTION in ['apply', 'destroy'] && !params.AUTO_APPROVE }
            }
            steps {
                input message: "Review the plan and approve ${params.ACTION}?", ok: 'Proceed'
            }
        }

        stage('Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                sh '''
                    cd terraform/environments/${ENVIRONMENT}
                    terraform apply -input=false -auto-approve tfplan
                '''
            }
        }

        stage('Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                sh '''
                    cd terraform/environments/${ENVIRONMENT}
                    terraform destroy -input=false -auto-approve
                '''
            }
        }

        stage('Output') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                sh '''
                    cd terraform/environments/${ENVIRONMENT}
                    terraform output -json > terraform-outputs.json
                '''
                archiveArtifacts artifacts: 'terraform/environments/${ENVIRONMENT}/terraform-outputs.json', fingerprint: true
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo "Terraform ${params.ACTION} completed successfully for ${params.ENVIRONMENT}"
        }
        failure {
            echo "Terraform ${params.ACTION} failed for ${params.ENVIRONMENT}"
        }
    }
}
