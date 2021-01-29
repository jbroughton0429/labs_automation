# Jenkins Lab

- [Jenkins Lab](#jenkins-lab)
  - [Caveats (Hic sunt dracones)](#caveats-hic-sunt-dracones)
  - [Quick-Start (just run me already!)](#quick-start-just-run-me-already)
  - [Agent - JNLP](#agent---jnlp)
  - [Agent - SSH](#agent---ssh)
  - [Tokens!](#tokens)
  - [Conclusion](#conclusion)

This is a lab environment for auto-deploying a Jenkins environment in Docker with 2x agents (JNLP & SSH). I created this for the sole purpose of firing up a quick lab when I need to test: 
* JaaC (Jenkins as a Code)
* Communications between Agents and Sever
* Token Jobs

Without interruption of a production system, in a fully automated way. The Host and Agents have been rebuilt to support: __Ansible, Python3 and AWS-CLI__. The Host has been built to support __Docker-in-Docker builds & Terraform__.

## Caveats (Hic sunt dracones)

While this may look like polished, production-ready code, I assure you it is not. If you chose to take this and deploy it, do so at your own risk..with a few pointers.

* I have the Jenkins Host set to auto-accept keys - Set this to manually accept key /hostfile
    * _I did it this way as I wanted to fully automate the solution. SSH from Host to agent-ssh does not allow for an automated solution_  
* Put your admin user/password in something other than a docker env_file
    * _Might I suggest Vault?_ 
* Single Admin user = Bad Juju
    * _I have this set with the Matrix Plugin (love it!). However, I only need 1 user for testing. If going prod: LDAP, multiple users, RBAC, and SA._

## Quick-Start (just run me already!)
Don't want to know how it works? A Light switch makes the room bright kinda person? Well, this is just your section!

1. Edit your Secrets file for Jenkins Admin
    a. jenkins_lab/env_file_jenkins 

2. Run Jenkins Server
```
$ cd jenkins_lab
$ docker-compose up 
```
3. Login to Jenkins: **http://127.0.0.1:8080/**

If you do not want to use your Agents (JNLP/SSH), I would recommend disabling the agents so that your build job does not attempt to reference them.

The Main Jenkins will be able to run:
* Python3
* Java (openjdk version "1.8.0_242")
* Docker
* Ansible
* Plugin for TF (TF not installed currently)

If you want to run the agents, please check the below sections.

## Agent - JNLP

The JNLP agent is from:
**https://hub.docker.com/r/jenkins/inbound-agent/**
**https://github.com/jenkinsci/docker-inbound-agent**

As well as compiling/executing Java, it has been modified to support: __Python3, Ansible & AWS CLI__

### Steps to Start Agent - JNLP

1. Start the Main Jenkins service and pull your JNLP Security Token from the nodes
2. Insert the Security Token into docker-agents.yml: _JENKINS_SECRET:_

At this point, you can either comment out _jenkins-ssh_ service and start the docker-agents.yml service or continue to Agent-SSH setup.

**Start Agent Service Without SSH**
1. Comment out _jenkins-ssh_ from docker-agents.yml dockerfile
2. Start docker via docker-compose: 
```
$ docker-compose -f docker-agents.yml up
```
3. Mark JNLP Node Online in Jenkins

The nodes tag is: _agent-jnlp_

## Agent - SSH
The SSH agent is from:
**https://hub.docker.com/r/jenkins/ssh-agent**
**hhttps://hub.docker.com/r/jenkins/ssh-agent**

As well as compiling/executing Java, it has been modified to support: __Python3, Ansible & AWS CLI__

This package has been modified to correct ISSUE #33 (PATH for Jenkins user):
**https://github.com/jenkinsci/docker-ssh-agent/issues/33**

### Steps to Start Agent - JNLP

1. Generate OpenSSH certificates with your poison of choice (openssh,puttygen, etc)
2. Put your Private Key in: Manage Credentials -> jenkins(ssh-agent) __*Note:The credentials exist, update/replace the private key*__
3. Add Pubkey to docker-agents.yml _JENKINS_AGENT_SSH_PUBKEY_ !!**Single-Line Only**!!

If you decided to just use Agent-SSH and not Agent-JNLP, comment out the Agent-JNLP and start your services...or you can run them both.

**Start Agent Service**
1. Start docker via docker-compose:
```
$ docker-compose -f docker-agents.yml up
```
2. Mark SSH Agent Online in Jenkins
3. Click on 'status' and wait for the connection to be established
4. On the _left_ side of the screen, click 'accept key' to accept the key

The nodes tag is: _agent-ssh_

## Tokens! 
I've added in (for my own enjoyment (_read: I keep forgetting where I put the script_)) a groovy script that generates Tokens necessary for communicating to Jenkins pipelines via API.  A few versions back Crumbs became frowned upon and API tokens were the defacto standard.  The problem (or maybe it's a security fix? who knows) is that only users can generate tokens for themselves. Why don't I like this?

* I prefer Service Accounts that I can lockdown
* An 'Agent' That is controlled via Matrix security and a specific purpose, with no password issued
* The 'SA' can only do Remote access API calls

From what I have gathered, Jenkin's argument is users should be the only ones that generate their keys, or you can create a 'service' user with a password and login to generate a key. Well, that leaves a password vector-point for access that's not needed. Thus you have the Groovy script generously scraped from somewhere on the internet.

There is a user in my Jenkins system called 'jnlp' (Permissions across the board for everyone is Admin..read Caveats). The _agent-token.goovy_ script will generate a token for the user to pass API calls 

### Script Execution
1. To execute this script, it must be done from the Jenkins Script Console: _Manage Dashboard->Script Console_
2. Upon execution, you will be presented with **Result:<Token>**
3. Use the token as User: Token in your scripts
4. When you no longer need your token you can suspend/delete the token from the JNLP user

More information on API can be found here:
**https://www.jenkins.io/doc/book/using/remote-access-api/**
## Conclusion

I use this Lab primarily to startup a quick(ish) environment to test the integration of plugins, running agents, automation strategies, etc that I could normally not do in a production environment. For obvious reasons it's not going to mirror a production-like environment, however, it comes close for lab-work.  I'll be updating this periodically as I build out more scenarios (TF coming soon)


### Todos
* Add in TF for Host and Agents
* Figure out a better way to automate keys for SSH on Build
* Buy milk

