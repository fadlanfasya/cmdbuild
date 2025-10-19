pipeline {
    agent any

    stages {
        stage('Prepare') {
            steps {
                echo 'Preparing build...'
            }
        }

        stage('Deploy WAR') {
            steps {
                echo 'Deploying CMDBuild.war to Tomcat container...'
                script {
                    // Copy the WAR into Tomcat's deployment folder
                    sh '''
                    docker cp cmdbuild/CMDBuild.war tomcat:/usr/local/tomcat/webapps/ROOT.war
                    docker restart tomcat
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying deployment...'
                sh 'sleep 10 && curl -I http://localhost:8081/'
            }
        }
    }
}
