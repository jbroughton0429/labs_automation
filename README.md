# My Secret Lair of Goodies

You have stumbled upon my storage of various IaC, Engineering, and random tidbits of labs that I have created over the last few years to ease my frustrations while working and/or learning. As this folder grows i'll list out here a brief desciption of what you could find under the rug.

## Jenkins Lab
This is the Automated system I use when I need to spin up a quick Jenkins box. It's built out with Docker-Compose and Jenkins CaaC (configuration as a code). Notable items here if you feel like running off with this little gem:

* Fully automated built with CaaC and Docker
* Comes with Jenkins Agents (SSH & JNLP) configured for the Host
* Agents are configured for: Java, Python3, Ansible
* Host is configured for: Java, Python3, Ansible, Docker and plugin for TF (TF not built)
* Uses Jenkins Matrix Security, and setup for API Tokens (code for generating tokens as well)

## Terraform AWS
This was a coding a challenge on S3/Python/DB. However i've since stripped the Python out (hey! no cheating!). I still reference the
TF/Packer from time to time when I need a template for building out a quick service in AWS

* Builds out 2 Packer images (MariaDB & a Console Server with ansible/packer/tf)
* Uses TF to create the 2 machines, a 'log' bucket and stores the TF machines state in bucket
* Primes the DB and sets it up with a dummy database
* Py scripts for SSH tunnels to the DB, and some py scripts for testing s3 via boto

