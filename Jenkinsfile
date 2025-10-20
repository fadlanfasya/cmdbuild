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
                sh '''
                    docker ps | grep tomcat || docker run -d --name tomcat -p 8081:8080 tomcat:9
                    docker cp cmdbuild/cmdbuild-4.1.0.war tomcat:/usr/local/tomcat/webapps/ROOT.war
                    docker exec tomcat bash -c "catalina.sh stop && catalina.sh start"
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying deployment...'
                sh 'curl -I http://localhost:8081 | grep "200 OK"'
            }
        }
    }
}
