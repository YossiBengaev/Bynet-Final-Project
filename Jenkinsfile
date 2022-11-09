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
        ProjectDir = '/var/lib/jenkins/workspace/Final-Project'
    }

    stages {
        stage('Build') {
            steps {
                sh 'cp ${JenkinsWorkDir}/.env ${ProjectDir}/.env'
                echo '# # # # # STAGE 1 -> Starting Build stage... # # # # #'
                script {
                    dockerImage = docker.build("$DockerHubRegistry:latest")
                }
            }
        }
        stage('Push To DockerHub') {
            steps {
                echo '# # # # # STAGE 2 -> Starting Push To DockerHub stage... # # # # #'
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
                echo '# # # # # STAGE 3 -> Starting Test stage... # # # # #'
                sshagent(credentials:['ssh-test']) {
                    sh 'chmod u+x $ProjectDir/deploy.sh'
                    sh './deploy.sh test'
                }
            }
        }
        stage('Prod'){
            steps{
                echo '# # # # # STAGE 4 -> Starting Production stage... # # # # #'
                script {
                     def USER_INPUT1 = input(message: 'continue to production ? ? ?',
                                        parameters: [[$class: 'ChoiceParameterDefinition', choices: ['No','Yes do it!'].join('\n'),
                                        name: 'It is your choice to decide', description: 'Menu - select box option']])
                     if( "${USER_INPUT1}" == "Yes do it!"){
                        sshagent(['ssh-prod']) {
                            sh './deploy.sh production'
                        }          
                     } else {
                            echo 'You decided not to continue to Production.... :('
                       }
                }
            }
        }
    }
    post {
        always {
            echo 'One way or another, I have finished'
            script{
                echo 'start to cleanup after you...'
                sh 'chmod 777 $ProjectDir/cleanup.sh'
                sshagent(credentials:['ssh-test']) {
                    echo 'starting with Test server..'
                    sh './cleanup.sh test'
                }
                echo 'now start with production server..'
                def USER_INPUT2 = input(message: 'Clean the Production ? ? ?',
                                        parameters: [[$class: 'ChoiceParameterDefinition', choices: ['No','Yes do it!'].join('\n'),
                                        name: 'It is your choice to decide', description: 'Menu - select box option']])
                     if( "${USER_INPUT2}" == "Yes do it!"){
                        sshagent(['ssh-prod']) {
                            sh './cleanup.sh production'
                        }          
                     } else {
                            echo 'You decided not to clean the Production.. Do not forget to do it later by your self..'
                       }
                deleteDir() /* clean up our workspace */
                echo 'See you next time.. :-) '
            }
        }
    }
}
