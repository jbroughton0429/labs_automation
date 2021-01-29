# The MIT License
#
#  Copyright (c) 2015, CloudBees, Inc.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

## Code modified from: https://github.com/jenkinsci/docker-ssh-agent/blob/master/setup-sshd

## To fix this issue: https://github.com/jenkinsci/docker-ssh-agent/issues/33
## And to add Docker, Python3, Ansible, AWS to Remote Agent

## 26.1.2020 - Added Docker, Python3, Ansible and AWS to Remote Agent

FROM openjdk:11-jdk-stretch
LABEL Description="This is a modified image of jenkins-ssh to fix a bug and add additional packages: Docker, Ansible, Python3 AWS-CLI" 

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG JENKINS_AGENT_HOME=/home/${user}

ENV JENKINS_AGENT_HOME ${JENKINS_AGENT_HOME}

RUN groupadd -g ${gid} ${group} \
    && useradd -d "${JENKINS_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}"

 
#Install Python3 & Ansible
RUN apt-get update \
    && apt-get -y install python3 ansible

#Install AWS-CLI
WORKDIR /tmp
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm awscliv2.zip \
    && rm -R aws

# Pull the git repo down, grab my agent, delete repo.
# Fix the code for deploy.
# If I automate via Ansible/Otherwise, Comment this out and
# Use ansible to pull down from console machine.

RUN GIT_URL="https://github.com/jenkinsci/docker-ssh-agent/archive/master.zip" \
    && wget --no-check-certificate -O master.zip $GIT_URL \
    && unzip master.zip
RUN sed -i 's/grep _/egrep -v "^(HOME=|USER=|MAIL=|LC_ALL=|LS_COLORS=|LANG=|HOSTNAME=|PWD=|TERM=|SHLVL=|LANGUAGE=|_=)"'/g docker-ssh-agent-master/setup-sshd \
    && cp docker-ssh-agent-master/setup-sshd /usr/local/bin/setup-sshd
RUN rm master.zip \
    && rm -R docker-ssh-agent-master
 
 ## Build this out as 2nd stage

# setup SSH server
RUN apt-get update \
    && apt-get install --no-install-recommends -y openssh-server \
    && rm -rf /var/lib/apt/lists/*
RUN sed -i /etc/ssh/sshd_config \
        -e 's/#PermitRootLogin.*/PermitRootLogin no/' \
        -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
        -e 's/#PasswordAuthentication.*/PasswordAuthentication no/' \
        -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
        -e 's/#LogLevel.*/LogLevel INFO/' && \
    mkdir /var/run/sshd

VOLUME "${JENKINS_AGENT_HOME}" "/tmp" "/run" "/var/run"
WORKDIR "${JENKINS_AGENT_HOME}"

EXPOSE 22

ENTRYPOINT ["setup-sshd"]