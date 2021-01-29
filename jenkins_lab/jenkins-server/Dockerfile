FROM jenkins/jenkins:latest

ARG HOST_UID=1004
ARG HOST_GID=999

USER root

# Install Docker
RUN apt-get update &&\
  apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common
  
RUN curl -fsSL "https://download.docker.com/linux/debian/gpg" -o "gpg" && apt-key add gpg

RUN add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

RUN apt-get update &&\
  apt-get -y install docker-ce docker-ce-cli containerd.io

## Fix the Docker Perms Issue so that Jenkins can run docker jobs

RUN usermod -u $HOST_UID jenkins
RUN groupmod -g $HOST_GID docker
RUN usermod -aG docker jenkins

# Build this out as 2nd stage

## Setup and Deploy CASC
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY casc.yaml /var/jenkins_home/casc.yaml
