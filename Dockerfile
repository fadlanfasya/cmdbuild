# Use the official Jenkins LTS image as a base
FROM jenkins/jenkins:lts-jdk17

# Switch to the root user to install packages
USER root

# Install the Docker CLI
RUN apt-get update && apt-get install -y --no-install-recommends docker.io

# Good practice to switch back to the jenkins user
USER jenkins