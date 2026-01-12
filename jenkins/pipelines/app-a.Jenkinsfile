// Application A (Java/WildFly) Build and Deploy Pipeline
// UniCredit GCP Migration

pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Target environment')
        choice(name: 'ACTION', choices: ['build', 'deploy', 'build-deploy', 'rollback'], description: 'Pipeline action')
        string(name: 'VERSION', defaultValue: '', description: 'Version to deploy (for deploy/rollback)')
    }

    environment {
        JAVA_HOME = tool 'JDK17'
        MAVEN_HOME = tool 'Maven3'
        PATH = "${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${PATH}"
        APP_NAME = 'app-a'
        ARTIFACT_NAME = 'app-a.war'
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

        stage('Build') {
            when {
                expression { params.ACTION in ['build', 'build-deploy'] }
            }
            steps {
                dir('applications/app-a/modern-src') {
                    sh '''
                        mvn clean package -DskipTests
                        mvn verify
                    '''
                }
            }
            post {
                success {
                    archiveArtifacts artifacts: "applications/app-a/modern-src/target/*.war", fingerprint: true
                }
            }
        }

        stage('Unit Tests') {
            when {
                expression { params.ACTION in ['build', 'build-deploy'] }
            }
            steps {
                dir('applications/app-a/modern-src') {
                    sh 'mvn test'
                }
            }
            post {
                always {
                    junit 'applications/app-a/modern-src/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Code Quality') {
            when {
                expression { params.ACTION in ['build', 'build-deploy'] }
            }
            steps {
                dir('applications/app-a/modern-src') {
                    sh 'mvn checkstyle:check || true'
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
                    sh """
                        mkdir -p artifacts
                        cp applications/app-a/modern-src/target/*.war artifacts/${APP_NAME}-${version}.war
                    """
                    // Upload to artifact repository
                    // sh "gsutil cp artifacts/${APP_NAME}-${version}.war gs://your-artifact-bucket/"
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
                    withCredentials([sshUserPrivateKey(credentialsId: 'ansible-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                        sh """
                            cd ansible
                            ansible-playbook playbooks/linux-modern/deploy-app.yml \
                                -i inventory/${ENVIRONMENT} \
                                --private-key ${SSH_KEY} \
                                -e "java_app_name=${APP_NAME}" \
                                -e "java_app_version=${version}" \
                                -e "java_app_artifact_name=${APP_NAME}-${version}.war"
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
                    // Get load balancer IP from Terraform outputs
                    def healthUrl = "http://\${APP_LB_IP}:8080/${APP_NAME}/health"
                    sh """
                        for i in 1 2 3 4 5; do
                            if curl -sf ${healthUrl}; then
                                echo "Health check passed"
                                exit 0
                            fi
                            sleep 10
                        done
                        echo "Health check failed"
                        exit 1
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
                    withCredentials([sshUserPrivateKey(credentialsId: 'ansible-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                        sh """
                            cd ansible
                            ansible-playbook playbooks/linux-modern/rollback-app.yml \
                                -i inventory/${ENVIRONMENT} \
                                --private-key ${SSH_KEY} \
                                -e "java_app_name=${APP_NAME}" \
                                -e "java_app_version=${VERSION}"
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
            echo "Application A pipeline completed successfully"
        }
        failure {
            echo "Application A pipeline failed"
            // Trigger rollback on failure if this was a deploy
            script {
                if (params.ACTION in ['deploy', 'build-deploy']) {
                    echo "Consider running rollback"
                }
            }
        }
    }
}
