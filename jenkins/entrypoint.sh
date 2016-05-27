#!/bin/bash
sudo chown jenkins /var/run/docker.sock
exec java -jar ${JENKINS_HOME}/jenkins.war
