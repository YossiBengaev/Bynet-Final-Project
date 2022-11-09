pipeline {
    
    agent any

    environment {
        DockerHubRegistry = 'yossibenga/flask_app'
        DockerHubURL = 'https://hub.docker.com/repository/docker/yossibenga/flask_app'
        DockerHubRegistryCredential = '90a24bb8-70d5-4b6c-8c60-35de22dc627f'
        DockerImage = 'yossibenga/flask_app'
              
        SshCredentialTest = credentials('ssh-test')
        SshCredentialProd = credentials('ssh-prod')
        
        JenkinsWorkDir = '/var/lib/jenkins'
        JenkinsJobDir = '/var/lib/jenkins/workspace/Final-Project'
        ProjectDir = '/var/lib/jenkins/workspace/Final-Project'
        ProjectTestDir = '/home/ec2-user/Final-Project'
        HomeDir="/home/ec2-user"
    }

    stages {
        stage('Build') {
            steps {
                sh 'cp ${JenkinsWorkDir}/.env ${ProjectDir}/.env'
                echo 'STAGE 2 -> Starting Build stage...'
                script {
                    dockerImage = docker.build("yossibenga/flask_app:latest")
                }
            }
        }
        stage('Push To DockerHub') {
            steps {
                echo 'STAGE 3 -> Starting Push To DockerHub stage...'
                script {
                    withDockerRegistry([ credentialsId: "$DockerHubRegistryCredential", url: "" ]) {
                    dockerImage.push()
                    sh 'docker rmi yossibenga/flask_app:latest'
                    }
                }
            }
        }
        stage('Test'){
            steps{
                echo 'STAGE 4 -> Starting Test stage...'
                sshagent(credentials:['ssh-test']) {
                    sh 'chmod u+x $ProjectDir/deploy.sh'
                    sh './deploy.sh test'
                }
            }
        }
        stage('Prod'){
            steps{
                echo 'STAGE 5 -> Starting Production stage...'
                script {
                     def USER_INPUT = input(message: 'User input required - Some Yes or No question?',
                                        parameters: [[$class: 'ChoiceParameterDefinition', choices: ['no','yes'].join('\n'),
                                        name: 'input', description: 'Menu - select box option']])
                    echo "The answer is: ${USER_INPUT}"

                     if( "${USER_INPUT}" == "yes"){
                        sshagent(['ssh-prod']) {
                            sh './deploy.sh production'
                        }          
                     } else {
                            echo 'You decided not to continue to Production.... :('
                       }
                //def USER_INPUT = input(message:"continue to production?" ok:"Yes do it!")
                //if( "${USER_INPUT}" == "Yes do it!"){
                    //sshagent(['ssh-prod']) {
                    //sh './deploy.sh production'
                    //}          
                //}  else{
                    //echo 'You decided not to continue to Production.... :('
                  //}
                }
            }
        }
    }
    post {
        always {
            echo 'One way or another, I have finished'
            script{
                echo 'start to cleanup after you...'
                sshagent(credentials:['ssh-test']) {
                    echo 'starting with Test server..'
                    sh 'chmod 777 $ProjectDir/cleanup_test.sh'
                    sh './cleanup_test.sh 1'
                }
                sshagent(['ssh-prod']) {
                    echo 'now start with production server..'
                    sh 'chmod 777 $ProjectDir/cleanup_production.sh'
                    sh './cleanup_production.sh 1'
                }
                deleteDir() /* clean up our workspace */
            }
        }
    }
}
