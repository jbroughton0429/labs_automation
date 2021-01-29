# The MIT License
#
#  Copyright (c) 2015-2017, CloudBees, Inc.
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

## Code modified from: https://hub.docker.com/r/jenkins/inbound-agent/

## 26.1.2020 - Added Docker, Python3, Ansible and AWS to Remote Agent

FROM jenkins/agent:4.6-2

LABEL Description="This is a modified image from the Jenkins project, which allows connecting Jenkins agents via JNLP protocols: Ansible, Python3 AWS-CLI" 

ARG user=jenkins

USER root
 
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

# I'm going to overcomplicate the @#@# out of things
# Pull the git repo down, grab my agent, delete repo.
# If I automate via Ansible/Otherwise, Comment this out and
# Use ansible to pull down from console machine.

RUN GIT_URL="https://github.com/jenkinsci/docker-inbound-agent/archive/master.zip" \
    && wget --no-check-certificate -O master.zip $GIT_URL
RUN unzip master.zip \
    && cp docker-inbound-agent-master/jenkins-agent /usr/local/bin/jenkins-agent \
    && rm -R docker-inbound-agent-master \
    && rm master.zip

## Build this part out as a 2nd Stage

# Run the Jenkins Agent as user: jenkins
RUN chmod +x /usr/local/bin/jenkins-agent \
    && ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave

USER ${user}

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]