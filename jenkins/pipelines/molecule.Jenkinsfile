// Jenkins Pipeline for Molecule Tests
// Runs Ansible role testing using Molecule framework

pipeline {
    agent any

    parameters {
        choice(
            name: 'ROLE_NAME',
            choices: ['all', 'wildfly', 'java_app', 'postgresql_client', 'sqlserver_client', 'iis', 'dotnet_app'],
            description: 'Select the Ansible role to test (or all)'
        )
        choice(
            name: 'SCENARIO',
            choices: ['default'],
            description: 'Molecule test scenario'
        )
        booleanParam(
            name: 'RUN_WINDOWS_TESTS',
            defaultValue: false,
            description: 'Run Windows role tests (requires Windows host configuration)'
        )
    }

    environment {
        ANSIBLE_FORCE_COLOR = 'true'
        MOLECULE_NO_LOG = 'false'
        PY_COLORS = '1'
    }

    stages {
        stage('Setup') {
            steps {
                script {
                    echo "Setting up Molecule testing environment..."
                }

                dir('ansible') {
                    sh '''
                        python3 -m venv .venv
                        . .venv/bin/activate
                        pip install --upgrade pip
                        pip install molecule molecule-plugins[docker] ansible-core ansible-lint yamllint
                        ansible-galaxy collection install -r molecule-requirements.yml
                    '''
                }
            }
        }

        stage('Lint Ansible Roles') {
            steps {
                dir('ansible') {
                    sh '''
                        . .venv/bin/activate
                        ansible-lint roles/ --exclude roles/*/molecule/ || true
                        yamllint -c .yamllint roles/ || true
                    '''
                }
            }
        }

        stage('Run Molecule Tests - Linux Roles') {
            when {
                expression { params.ROLE_NAME == 'all' || params.ROLE_NAME in ['wildfly', 'java_app', 'postgresql_client', 'sqlserver_client'] }
            }
            steps {
                dir('ansible') {
                    script {
                        def roles = params.ROLE_NAME == 'all' ?
                            ['wildfly', 'java_app', 'postgresql_client', 'sqlserver_client'] :
                            [params.ROLE_NAME]

                        roles.each { role ->
                            if (role in ['wildfly', 'java_app', 'postgresql_client', 'sqlserver_client']) {
                                stage("Test ${role}") {
                                    dir("roles/${role}") {
                                        sh """
                                            . ../../.venv/bin/activate
                                            molecule test -s ${params.SCENARIO} || exit 1
                                        """
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        stage('Run Molecule Tests - Windows Roles') {
            when {
                allOf {
                    expression { params.RUN_WINDOWS_TESTS == true }
                    expression { params.ROLE_NAME == 'all' || params.ROLE_NAME in ['iis', 'dotnet_app'] }
                }
            }
            steps {
                dir('ansible') {
                    script {
                        def roles = params.ROLE_NAME == 'all' ?
                            ['iis', 'dotnet_app'] :
                            [params.ROLE_NAME]

                        roles.each { role ->
                            if (role in ['iis', 'dotnet_app']) {
                                stage("Test ${role}") {
                                    withCredentials([
                                        string(credentialsId: 'molecule-windows-host', variable: 'MOLECULE_WINDOWS_HOST'),
                                        string(credentialsId: 'molecule-windows-user', variable: 'MOLECULE_WINDOWS_USER'),
                                        string(credentialsId: 'molecule-windows-password', variable: 'MOLECULE_WINDOWS_PASSWORD')
                                    ]) {
                                        dir("roles/${role}") {
                                            sh """
                                                . ../../.venv/bin/activate
                                                molecule test -s ${params.SCENARIO} || exit 1
                                            """
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            dir('ansible') {
                sh '''
                    . .venv/bin/activate || true
                    # Cleanup any running containers
                    docker ps -aq --filter "name=molecule" | xargs -r docker rm -f || true
                '''
            }
            cleanWs()
        }
        success {
            echo 'Molecule tests completed successfully!'
        }
        failure {
            echo 'Molecule tests failed!'
        }
    }
}
