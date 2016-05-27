## Jenkins Docker Container

We are extending Jenkins 2.0 version. 

Usage:
```
$ docker build -t infinityworks/jenkins .
$ docker run -d -p 8080:8080 -p 50000:50000 -v /your/home:/var/jenkins_home -v $(which docker):/usr/bin/docker -v /var/run/docker.sock:/var/run/docker.sock  infinityworks/jenkins
```

More configurations can be foun [in the parent docker file](https://hub.docker.com/_/jenkins/)

 You can access Jenkins on http://[DOCKER_HOST]:8080
