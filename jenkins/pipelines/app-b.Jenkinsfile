// Application B (.NET/IIS) Build and Deploy Pipeline
// UniCredit GCP Migration

pipeline {
    agent {
        label 'windows'
    }

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Target environment')
        choice(name: 'ACTION', choices: ['build', 'deploy', 'build-deploy', 'rollback'], description: 'Pipeline action')
        string(name: 'VERSION', defaultValue: '', description: 'Version to deploy (for deploy/rollback)')
    }

    environment {
        APP_NAME = 'app-b'
        ARTIFACT_NAME = 'app-b.zip'
        DOTNET_CLI_TELEMETRY_OPTOUT = '1'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Restore') {
            when {
                expression { params.ACTION in ['build', 'build-deploy'] }
            }
            steps {
                dir('applications/app-b/modern-src') {
                    bat 'dotnet restore'
                }
            }
        }

        stage('Build') {
            when {
                expression { params.ACTION in ['build', 'build-deploy'] }
            }
            steps {
                dir('applications/app-b/modern-src') {
                    bat 'dotnet build --configuration Release --no-restore'
                }
            }
        }

        stage('Unit Tests') {
            when {
                expression { params.ACTION in ['build', 'build-deploy'] }
            }
            steps {
                dir('applications/app-b/modern-src') {
                    bat 'dotnet test --configuration Release --no-build --logger trx'
                }
            }
            post {
                always {
                    mstest testResultsFile: '**/*.trx'
                }
            }
        }

        stage('Publish') {
            when {
                expression { params.ACTION in ['build', 'build-deploy'] }
            }
            steps {
                dir('applications/app-b/modern-src') {
                    bat 'dotnet publish --configuration Release --no-build --output ./publish'
                }
            }
        }

        stage('Package') {
            when {
                expression { params.ACTION in ['build', 'build-deploy'] }
            }
            steps {
                script {
                    def version = params.VERSION ?: env.BUILD_NUMBER
                    bat """
                        if not exist artifacts mkdir artifacts
                        powershell Compress-Archive -Path applications/app-b/modern-src/publish/* -DestinationPath artifacts/${APP_NAME}-${version}.zip -Force
                    """
                    archiveArtifacts artifacts: "artifacts/${APP_NAME}-${version}.zip", fingerprint: true
                }
            }
        }

        stage('Deploy') {
            when {
                expression { params.ACTION in ['deploy', 'build-deploy'] }
            }
            steps {
                script {
                    def version = params.VERSION ?: env.BUILD_NUMBER
                    withCredentials([usernamePassword(credentialsId: 'windows-admin', usernameVariable: 'WIN_USER', passwordVariable: 'WIN_PASS')]) {
                        bat """
                            cd ansible
                            ansible-playbook playbooks/windows-modern/deploy-app.yml ^
                                -i inventory/${ENVIRONMENT} ^
                                -e "ansible_user=${WIN_USER}" ^
                                -e "ansible_password=${WIN_PASS}" ^
                                -e "dotnet_app_name=${APP_NAME}" ^
                                -e "dotnet_app_version=${version}" ^
                                -e "dotnet_app_artifact_name=${APP_NAME}-${version}.zip"
                        """
                    }
                }
            }
        }

        stage('Smoke Test') {
            when {
                expression { params.ACTION in ['deploy', 'build-deploy'] }
            }
            steps {
                script {
                    def healthUrl = "http://\${APP_LB_IP}/${APP_NAME}/health"
                    bat """
                        powershell -Command "
                            for (\$i = 1; \$i -le 5; \$i++) {
                                try {
                                    \$response = Invoke-WebRequest -Uri '${healthUrl}' -UseBasicParsing -TimeoutSec 30
                                    if (\$response.StatusCode -eq 200) {
                                        Write-Host 'Health check passed'
                                        exit 0
                                    }
                                } catch {
                                    Write-Host 'Attempt \$i failed, retrying...'
                                }
                                Start-Sleep -Seconds 10
                            }
                            Write-Host 'Health check failed'
                            exit 1
                        "
                    """
                }
            }
        }

        stage('Rollback') {
            when {
                expression { params.ACTION == 'rollback' }
            }
            steps {
                script {
                    if (!params.VERSION) {
                        error "VERSION is required for rollback"
                    }
                    withCredentials([usernamePassword(credentialsId: 'windows-admin', usernameVariable: 'WIN_USER', passwordVariable: 'WIN_PASS')]) {
                        bat """
                            cd ansible
                            ansible-playbook playbooks/windows-modern/rollback-app.yml ^
                                -i inventory/${ENVIRONMENT} ^
                                -e "ansible_user=${WIN_USER}" ^
                                -e "ansible_password=${WIN_PASS}" ^
                                -e "dotnet_app_name=${APP_NAME}" ^
                                -e "dotnet_app_version=${VERSION}"
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo "Application B pipeline completed successfully"
        }
        failure {
            echo "Application B pipeline failed"
        }
    }
}
