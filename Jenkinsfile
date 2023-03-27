pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "devops_maven"
    }
    parameters {
        string defaultValue: 'Test', description: 'Enter The Branch Name', name: 'BranchName'
    }

    stages {                        
        stage('PullTheCode') {
            steps {
                git branch: "${params.BranchName}", url: 'https://github.com/kiranp227/pet-clinic-war.git'
            }
        }
        stage('Validate') {
            steps {
                sh "mvn validate"
            }
        }
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        stage('Test') {
            steps {
                sh "mvn test"
            }
        }
        stage('Build') {
            steps {
                sh "mvn package"
            }
        }
        stage('BuildImage') {
            steps {
                sh "docker build -t devops_image:${BUILD_NUMBER} ."
            }
        }
        stage('Deploy') {
            steps{
                input 'Do you want to deploy?'
                echo "Deploying the application to Dev environment"
                sh 'docker run -d -p 8082:8080 --restart=always --name devops_container devops_image:${BUILD_NUMBER}'
                echo "Applicaion is successfully deployed"
            }
        }
    }
}
