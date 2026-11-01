
def run(cmd) {
    if (isUnix()) {
        sh cmd
    } else {
        bat cmd
    }
}
def deploy() {
    awsRun """
        aws ssm send-command --region ${env.REGION} \
        --instance-ids ${env.INSTANCE} \
        --document-name AWS-RunShellScript \
        --parameters file://deploy.json
    """
}

pipeline {
    agent any

    environment {
        REGION   = 'ap-south-1'
        ACCOUNT  = '959891092671'
        REPO     = 'hello-jenkins'
        INSTANCE = 'none'

        REGISTRY = "${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com"
        IMG      = "${REPO}:${BUILD_NUMBER}"
        REMOTE   = "${REGISTRY}/${REPO}:latest"
    }

    stages {

        stage('Docker Check') {
            steps {
                script {
                    run 'where docker'
                    run 'docker --version'
                    run 'docker info'
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    run "docker build -t ${IMG} ."
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    run "docker run --rm ${IMG} nginx -t"
                }
            }
        }

        stage('Push') {
            steps {
                script {
                    docker.withRegistry(
                        "https://${env.REGISTRY}",
                        "ecr:${env.REGION}:aws-jenkins"
                    ) {
                        run "docker tag ${IMG} ${REMOTE}"
                        run "docker push ${REMOTE}"
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                not {
                    environment name: 'INSTANCE', value: 'none'
                }
            }
            steps {
                echo 'Deployment is not configured yet.'
            }
        }
    }
}
