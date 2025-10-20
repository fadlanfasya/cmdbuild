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
            # Ensure the WAR file exists
            if [ ! -f target/cmdbuild-4.1.0.war ]; then
                echo "ERROR: target/cmdbuild-4.1.0.war not found!"
                exit 1
            fi

            # Create temp directory for docker cp
            mkdir -p cmdbuild
            cp target/cmdbuild-4.1.0.war cmdbuild/cmdbuild-4.1.0.war

            # Start Tomcat container if not running
            if [ -z "$(docker ps -q -f name=tomcat)" ]; then
                echo "Starting Tomcat container..."
                docker run -d --name tomcat -p 8081:8080 tomcat:9
            fi

            # Copy WAR file into container
            docker cp cmdbuild/cmdbuild-4.1.0.war tomcat:/usr/local/tomcat/webapps/ROOT.war

            # Restart Tomcat
            echo "Restarting Tomcat..."
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
