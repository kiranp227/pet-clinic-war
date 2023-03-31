pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "devops_maven"
    }
    parameters {
        string defaultValue: 'Test', description: 'Enter The Branch Name', name: 'BranchName'
        string defaultValue: 'www.Repo.git', description: 'Enter The Repo URL', name: 'RepoURL'
    }
    environment {     
    DOCKERHUB_CREDENTIALS= credentials('dockerhub')     
    } 

    stages {                        
        stage('PullTheCode') {
            steps {
                git branch: "${params.BranchName}", url: "${params.RepoURL}"
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
        stage('SonarQube Analysis') {
            steps {
                script {
                     // requires SonarQube Scanner 2.8+
                    scannerHome = tool 'sonarqube_devops'
                }
                withSonarQubeEnv('sonar_server') {
                    sh "${scannerHome}/bin/sonar-scanner -Dproject.settings=sonar.properties"
                }
            }
        }
        stage('BuildImage') {
            steps {
                sh "docker build -t devops_image:${BUILD_NUMBER} ."
            }
        }
        stage('Deploy') {
            steps{
                echo "Deploying the application to Dev environment"
                sh '''docker stop devops_container
                      docker rm devops_container
                      docker run -d -p 8082:8080 --restart=always --name devops_container devops_image:${BUILD_NUMBER}'''
                echo "Applicaion is successfully deployed"
            }
        }
        stage('PushTheImage'){
            steps{
                input 'Do you want to push the image?'
                sh '''docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW
                      docker tag devops_image:${BUILD_NUMBER} kiranp227/devops_image:${BUILD_NUMBER}
                      docker push kiranp227/devops_image:${BUILD_NUMBER}'''
            }
        }
        stage('CleanWorkSpace') {
            steps {
                cleanWs()
            }
        }
    }
}
