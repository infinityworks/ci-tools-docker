## Jenkins Docker Container

We are extending Jenkins 2.0 version. Couple of jobs have been configured to run with this image. They are pet projects to show how to set up Job DSL and Workflow based Jennkins Jobs. Nexus and Sonar settings are set in settings.xml currenlty pointing to whatever has been set in the [docker compose file](../docker-compose.yml). Change appropriately when permanent IP addresses are known.

Usage:
```
$ docker build -t infinityworks/jenkins .
$ docker run -d -p 8080:8080 -p 50000:50000 -v /your/home:/var/jenkins_home -v $(which docker):/usr/bin/docker -v /var/run/docker.sock:/var/run/docker.sock  infinityworks/jenkins
```
More configurations can be foun [in the parent docker file](https://hub.docker.com/_/jenkins/)

Note: You may need to add the follwoing voluems for some of AWS enstances: -v /lib/x86_64-linux-gnu/libdevmapper.so.1.02.1:/lib/x86_64-linux-gnu/libdevmapper.so.1.02.1 -v /lib/x86_64-linux-gnu/libapparmor.so.1:/lib/x86_64-linux-gnu/libapparmor.so.1 -v /lib/x86_64-linux-gnu/libseccomp.so.2:/lib/x86_64-linux-gnu/libseccomp.so.2

You can access Jenkins on http://[DOCKER_HOST]:18080
