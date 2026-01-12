// Packer Image Build Pipeline
// UniCredit GCP Migration

pipeline {
    agent any

    parameters {
        choice(name: 'IMAGE_TYPE', choices: ['rhel9-wildfly', 'win2022-iis'], description: 'Image type to build')
        string(name: 'JAVA_VERSION', defaultValue: '17', description: 'Java version for RHEL image (17 or 21)')
        string(name: 'DOTNET_VERSION', defaultValue: '4.8', description: '.NET version for Windows image')
    }

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-service-account')
        PKR_VAR_project_id = credentials('gcp-project-id')
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
        timeout(time: 2, unit: 'HOURS')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup') {
            steps {
                sh 'packer --version'
            }
        }

        stage('Validate RHEL9') {
            when {
                expression { params.IMAGE_TYPE == 'rhel9-wildfly' }
            }
            steps {
                sh '''
                    cd packer/linux/rhel9
                    packer init .
                    packer validate -var "java_version=${JAVA_VERSION}" .
                '''
            }
        }

        stage('Validate Windows') {
            when {
                expression { params.IMAGE_TYPE == 'win2022-iis' }
            }
            steps {
                sh '''
                    cd packer/windows/win2022
                    packer init .
                    packer validate -var "dotnet_version=${DOTNET_VERSION}" .
                '''
            }
        }

        stage('Build RHEL9') {
            when {
                expression { params.IMAGE_TYPE == 'rhel9-wildfly' }
            }
            steps {
                sh '''
                    cd packer/linux/rhel9
                    packer build -var "java_version=${JAVA_VERSION}" \
                        -machine-readable . | tee build.log
                '''
            }
            post {
                always {
                    archiveArtifacts artifacts: 'packer/linux/rhel9/manifest.json', fingerprint: true, allowEmptyArchive: true
                }
            }
        }

        stage('Build Windows') {
            when {
                expression { params.IMAGE_TYPE == 'win2022-iis' }
            }
            steps {
                sh '''
                    cd packer/windows/win2022
                    packer build -var "dotnet_version=${DOTNET_VERSION}" \
                        -machine-readable . | tee build.log
                '''
            }
            post {
                always {
                    archiveArtifacts artifacts: 'packer/windows/win2022/manifest.json', fingerprint: true, allowEmptyArchive: true
                }
            }
        }

        stage('Verify Image') {
            steps {
                script {
                    def manifestPath = params.IMAGE_TYPE == 'rhel9-wildfly' ?
                        'packer/linux/rhel9/manifest.json' :
                        'packer/windows/win2022/manifest.json'

                    def manifest = readJSON file: manifestPath
                    def imageId = manifest.builds[0].artifact_id
                    echo "Built image: ${imageId}"

                    // Verify image exists in GCP
                    sh "gcloud compute images describe ${imageId.split(':')[1]} --project=\${PKR_VAR_project_id}"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo "Packer build completed successfully for ${params.IMAGE_TYPE}"
        }
        failure {
            echo "Packer build failed for ${params.IMAGE_TYPE}"
        }
    }
}
