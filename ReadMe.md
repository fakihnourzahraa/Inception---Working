_This project has been created as part of the 42 curriculum by nfakih._

## Description

Inception is an introduction to docker, where we set up multiple services (nginx, mariadb, wordpress) across different docker containers within the same docker network. The point is to learn how to use docker and its containers effeciently. Through the mandated setup, if one service fails (ie db) it wont affect the rest of the services. Additionally there is a single port (443) that's exposed to the host network, for increased security purposes.

## Project Description

### Virtual Machine vs Docker
Docker is essentially a virtual machine without it's own kernel. A virtual machine is a machine within your own that uses its own kernel, meanwhile docker is an environment within your machine that uses your kernel. They both offer the safety of being machines seperate from their hosts, meaning any securtiy vulenrability wont descenc to the host. However, docker is much more portable, storage friendly, and easier to use. 

### Secrets vs Environment Variables

The .env file is essentially us replicating what happens in the host's OS, where there are environment variables (ie, $USER) that we specifically are declaring. We want this to be private on github for security reasons. However, secrets are hidden from the docker image, but not from github.

### Docker Network vs Host Network

Docker network is the network between docker containers. Meanwhile, host network is the network on the host machine (virtual machine/ec2) that connects the single container (nginx) to the outside world.

### Docker Volumes vs Bind Mounts

Docker volumes are used to store data created and used by Docker. Bind mounts are older types of data sroage, where a file on the host gets mounted into a container, thus using the hosts absolute path.


## Instructions
cd into the working directory (git repo) and:

```bash
make
```

Refer to USER_DOC.md for more information.

## Resources

GeeksforGeeks. (2025, July 23). Docker volume vs bind Mount. https://www.geeksforgeeks.org/devops/docker-volume-vs-bind-mount/ 

Inception. 42-School Project | by Youssef. | medium. (n.d.-c). https://medium.com/@imyzf/inception-3979046d90a0 

GeeksforGeeks. (2026, April 23). What is Docker? https://www.geeksforgeeks.org/devops/introduction-to-docker/ 

Docker Inc. (2026, February 21). Introduction. Docker Documentation. https://docs.docker.com/get-started/introduction/ 

Schmidt, J., developers  Docker Docker Best Practices, Jain, T., Verma, K., Lechner, M., & Selajev, O. (2024, November 6). Docker best practices: Choosing between run, CMD, and ENTRYPOINT. Docker. https://www.docker.com/blog/docker-best-practices-choosing-between-run-cmd-and-entrypoint/ 

West, A. (2026, May 11). Why your docker containers refuse to die: The PID 1 problem. DEV Community. https://dev.to/alanwest/why-your-docker-containers-refuse-to-die-the-pid-1-problem-e70 

GeeksforGeeks. (2025a, July 23). Differences between TLS 1.2 and TLS 1.3. https://www.geeksforgeeks.org/computer-networks/differences-between-tls-1-2-and-tls-1-3/ 

Docker Inc. (2026b, July 21). Networking overview. Docker Documentation. https://docs.docker.com/engine/network/ 

Understanding nginx: Architecture, configuration & alternatives. Architecture, Configuration & Alternatives | Solo.io. (n.d.). https://www.solo.io/topics/nginx 

https://www.youtube.com/watch?v=gAkwW2tuIqE

https://github.com/Forstman1/inception-42

https://www.youtube.com/watch?v=pg19Z8LL06w

## AI Usage
AI was used to simplify the learning process for this project. There was of course many other resources for me to understand from, however, the very detailed and hard to understand concepts were facilitated through AI. It also helped with testing (knowing what commands to run), and set up the env and secrets files (only since this is an educational project, and won't be used for real life cases).

*Made with lots coffee and debugging at 42 Beirut*

