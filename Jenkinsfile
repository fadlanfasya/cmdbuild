pipeline {
    agent any

    environment {
        APP_NAME = "cmdbuild"
        WAR_NAME = "cmdbuild-4.1.0.war"
        TOMCAT_CONTAINER = "tomcat"
        TOMCAT_PORT = "8081"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Cloning repository..."
                git branch: 'main', url: 'https://github.com/fadlanfasya/cmdbuild.git'
            }
        }

        stage('Build WAR') {
            steps {
                echo "Building WAR file with Maven..."
                sh '''
                    mvn clean package -DskipTests
                    echo "WAR files in target directory:"
                    ls -l target/
                '''
            }
        }

        stage('Prepare WAR for Deployment') {
            steps {
                echo "Preparing WAR file for deployment..."
                sh '''
                    mkdir -p cmdbuild
                    if [ -f target/${WAR_NAME} ]; then
                        cp target/${WAR_NAME} cmdbuild/${WAR_NAME}
                    else
                        echo "ERROR: target/${WAR_NAME} not found!"
                        ls -R target || true
                        exit 1
                    fi
                '''
            }
        }

        stage('Deploy WAR to Tomcat') {
            steps {
                echo "Deploying ${WAR_NAME} to Tomcat container..."

                sh '''
                    # Start Tomcat container if not running
                    docker ps | grep ${TOMCAT_CONTAINER} || docker run -d --name ${TOMCAT_CONTAINER} -p ${TOMCAT_PORT}:8080 tomcat:9

                    # Copy WAR into container
                    docker cp cmdbuild/${WAR_NAME} ${TOMCAT_CONTAINER}:/usr/local/tomcat/webapps/ROOT.war

                    # Restart Tomcat
                    docker exec ${TOMCAT_CONTAINER} bash -c "catalina.sh stop || true && catalina.sh start"
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "Verifying deployment..."
                sh '''
                    sleep 10
                    curl -I http://localhost:${TOMCAT_PORT} || true
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful! Application should be available at: http://localhost:${TOMCAT_PORT}"
        }
        failure {
            echo "❌ Build or deployment failed. Check logs above."
        }
    }
}
