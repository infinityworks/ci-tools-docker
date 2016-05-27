FROM java:8-jdk

MAINTAINER Ayache Khettar <ayache.khettar@infinityworks.com>

RUN apt-get update && apt-get install -y git curl zip sudo ruby && rm -rf /var/lib/apt/lists/*


ENV JAVA_OPTS="-XX:PermSize=1024m -XX:MaxPermSize=512m"

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid

# adding docker group with the same guid as the mounted volume
RUN guid=$(stat -c '%g' /var/run/docker.sock) && addgroup --gid $guid docker && addgroup --system jenkins docker

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home

# add jenkins user to sudo list
# RUN adduser jenkins sudo
RUN echo "jenkins   ALL=(ALL)  NOPASSWD:ALL" >> etc/sudoers


# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

ENV TINI_SHA 066ad710107dc7ee05d3aa6e4974f01dc98f3888

# Use tini as subreaper in Docker container to adopt zombie processes <?xml version='1.0' encoding='UTF-8'?>

RUN curl -fsSL https://github.com/krallin/tini/releases/download/v0.5.0/tini-static -o /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha1sum -c -


# COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy

ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.0}
ARG JENKINS_SHA
ENV JENKINS_SHA ${JENKINS_SHA:-da06f963edb627f0ced2fce612f9985d1928f79b}


# could use ADD but this one does not check Last-Modified header
# see https://github.com/docker/docker/issues/8331
RUN curl -fsSL http://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war -o /usr/share/jenkins/jenkins.war \
  && echo "$JENKINS_SHA  /usr/share/jenkins/jenkins.war" | sha1sum -c -


ENV JENKINS_UC https://updates.jenkins-ci.org

RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref

# Install Docker binaries
RUN sudo apt-get

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log


USER ${user}

# from a derived Dockerfile, can use `RUN plugins.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
COPY plugins.sh /usr/local/bin/plugins.sh

COPY plugins.txt /var/jenkins_home/plugins.txt
RUN /usr/local/bin/plugins.sh /var/jenkins_home/plugins.txt

# Jenkins Settings, i.e. Maven, Groovy, ...
COPY config/hudson.tasks.Maven.xml /usr/share/jenkins/ref/hudson.tasks.Maven.xml
COPY config/hudson.plugins.groovy.Groovy.xml /usr/share/jenkins/ref/hudson.plugins.groovy.Groovy.xml
COPY config/maven-global-settings-files.xml /usr/share/jenkins/ref/maven-global-settings-files.xml
COPY config/org.jenkinsci.plugins.docker.commons.tools.DockerTool.xml /usr/share/jenkins/ref/org.jenkinsci.plugins.docker.commons.tools.DockerTool.xml
COPY config/settings.xml /usr/share/jenkins/ref/settings.xml
COPY config/settings.xml /var/jenkins_home/settings.xml

# setting jenkins binary run file
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
