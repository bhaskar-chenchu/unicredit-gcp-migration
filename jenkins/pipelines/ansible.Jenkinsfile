// Ansible Deployment Pipeline
// UniCredit GCP Migration

pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Target environment')
        choice(name: 'PLAYBOOK', choices: ['linux-modern/deploy.yml', 'windows-modern/deploy.yml', 'linux-modern/configure.yml', 'windows-modern/configure.yml'], description: 'Playbook to run')
        string(name: 'LIMIT', defaultValue: '', description: 'Limit to specific hosts (optional)')
        string(name: 'TAGS', defaultValue: '', description: 'Run only specific tags (optional)')
        booleanParam(name: 'CHECK_MODE', defaultValue: false, description: 'Run in check mode (dry run)')
    }

    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
        ANSIBLE_FORCE_COLOR = 'true'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
        timeout(time: 1, unit: 'HOURS')
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
                    ansible --version
                    ansible-galaxy collection install community.windows ansible.windows --force
                '''
            }
        }

        stage('Lint') {
            steps {
                sh '''
                    pip install ansible-lint --quiet
                    ansible-lint ansible/playbooks/${PLAYBOOK} || true
                '''
            }
        }

        stage('Syntax Check') {
            steps {
                sh '''
                    cd ansible
                    ansible-playbook playbooks/${PLAYBOOK} \
                        -i inventory/${ENVIRONMENT} \
                        --syntax-check
                '''
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([
                    sshUserPrivateKey(credentialsId: 'ansible-ssh-key', keyFileVariable: 'SSH_KEY'),
                    usernamePassword(credentialsId: 'ansible-vault', usernameVariable: 'VAULT_USER', passwordVariable: 'VAULT_PASS')
                ]) {
                    sh '''
                        cd ansible

                        EXTRA_ARGS=""
                        if [ -n "${LIMIT}" ]; then
                            EXTRA_ARGS="${EXTRA_ARGS} --limit ${LIMIT}"
                        fi
                        if [ -n "${TAGS}" ]; then
                            EXTRA_ARGS="${EXTRA_ARGS} --tags ${TAGS}"
                        fi
                        if [ "${CHECK_MODE}" = "true" ]; then
                            EXTRA_ARGS="${EXTRA_ARGS} --check --diff"
                        fi

                        ansible-playbook playbooks/${PLAYBOOK} \
                            -i inventory/${ENVIRONMENT} \
                            --private-key ${SSH_KEY} \
                            --vault-password-file <(echo "${VAULT_PASS}") \
                            ${EXTRA_ARGS} \
                            -v
                    '''
                }
            }
        }

        stage('Verify') {
            when {
                expression { !params.CHECK_MODE }
            }
            steps {
                sh '''
                    cd ansible
                    ansible -i inventory/${ENVIRONMENT} all -m ping || true
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo "Ansible deployment completed successfully"
        }
        failure {
            echo "Ansible deployment failed"
        }
    }
}
