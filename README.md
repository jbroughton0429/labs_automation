# My Secret Lair of Goodies

You have stumbled upon my storage of various IaC, Engineering, and random tidbits of labs that I have created over the last few years to ease my frustrations while working and/or learning. As this folder grows i'll list out here a brief desciption of what you could find under the rug.

## Jenkins Lab
This is the Automated system I use when I need to spin up a quick Jenkins box. It's built out with Docker-Compose and Jenkins CaaC (configuration as a code). Notable items here if you feel like running off with this little gem:
* Fully automated built with CaaC and Docker
* Comes with Jenkins Agents (SSH & JNLP) configured for the Host
* Agents are configured for: Java, Python3, Ansible
* Host is configured for: Java, Python3, Ansible, Docker and plugin for TF (TF not built)
* Uses Jenkins Matrix Security, and setup for API Tokens (code for generating tokens as well)

