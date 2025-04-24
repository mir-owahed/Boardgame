# Use OpenJDK 17 as the base image
FROM openjdk:17-slim

# Set the working directory inside the container
WORKDIR /workspace

# Install Maven (as an example for a common build tool)
RUN apt-get update && apt-get install -y \
    maven \
    curl \
    git \    

# Set up Jenkins agent environment variables
ENV JENKINS_AGENT_HOME /workspace
ENV JENKINS_AGENT_NAME jenkins-agent

# Install Docker (if needed for Docker-in-Docker or running Docker commands from within the container)
RUN curl -fsSL https://get.docker.com | sh

# Allow Jenkins agent to run Docker commands (mount Docker socket later in the pipeline)
RUN groupadd docker && useradd -m -g docker docker

# Set the user as the 'docker' user
USER docker

# Default command (this will be overridden in Jenkins)
CMD ["tail", "-f", "/dev/null"]
