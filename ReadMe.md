# inception

_This project has been created as part of the 42 curriculum by nfakih._

## Description

Inception is an introduction to docker, where we set up multiple services (nginx, mariadb, wordpress, php) across different docker containers within the same docker network. The point is to learn how to use containers effeciently. Through the mandated setup, if one service fails (ie db) it wont affect the rest of the services. Additionally there is a single port (443) that's exposed to the host network, for increased security purposes, although possibly creating a bottle neck?

## Project Description

### Virtual Machine vs Docker
Docker is essentially a virtual machine without it's own kernel. A virtual machine is a machine within your own that uses its own kernel, meanwhile docker is an environment within your machine that uses your kernel. They both offer the safety of being machines seperate from their hosts, meaning any securtiy vulenrability wont descenc to the host. However, docker is much more portable, storage friendly, and easier to use. 

### Secrets vs Environment Variables

The .env file is essentially us replicating what happens in the host's OS, where there are environment variables (ie, $USER) that we specifically are declaring. We want this to be private on github as we don't want the database passwords etc.. to be public for security reasons. However, secrets are hidden from the docker image, but not from github.

### Docker Network vs Host Network

Docker network is the network between docker containers. Meanwhile, host network is the network on the host machine (virtual machine/aws) that connects the single container (nginx) to the outside world

### Docker Volumes vs Bind Mounts

## Instructions


```bash
make
```


## Resources

## AI Usage


*Made with lots coffee and debugging at 42 Beirut*

